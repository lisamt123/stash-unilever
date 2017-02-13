/***************************************************************
Name: UL_PromotionWorkflowService
Copyright © 2016 Accenture
======================================================
Purpose:
Utility class for Promotion approval process steps
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Badri         16/12/2016     INITIAL DEV            
***************************************************************/
global without sharing class UL_PromotionWorkflowService{
    public static final String FINANCE_QUEUE = 'Finance Check Dynamic Queue';
    public static final String MANAGER_QUEUE = 'Manager Check Dynamic Queue';
    public static final string Active = 'Active';
    public static final string STATUS_APPROVE = 'Approve' ;
    public static final string STATUS_REJECT = 'Reject' ;
    public static final string ROLE_TPM = 'TPM' ;
    public static final string STEP_URGENT = 'Urgent' ;
    public static final string COMMENTS_REJECT = 'Rejecting Workflow' ;
    public static final string COMMENTS_APPROVE = 'Approving Workflow' ;
    public static final string COMMENTS_SUBMIT = 'Submitting Workflow for Approval' ;
    public static final string ROLE_FINANCE_USER = 'Finance User' ;
    public static final string QUEUE_FINANCE = 'finance' ;
    public static final string ROLE_MANAGER = 'manager' ;
    public static final Boolean BOOLEAN_FALSE = false ;
    public static  Id mainApproverId ;        
    /*******************************************************************
     Purpose: Generic enum to provide values  
     Version 1.0
     Parameters: N/A
     Returns: N/A
     Throws : N/A 
    ********************************************************************/  
    private enum UtilityEnum{
        manager,
        finance,
        SoCo_Promotion_Submit,
        SoCo_Promotion_Approved,
        SoCo_Promotion_Rejected,
        UL_Finance_Check,
        queue
    }
    /*******************************************************************
    Purpose: Initiate approval process for Promotion.  
    Version 1.0
    Parameters: Promotion Id, List of promotion, Queue Id 
    Returns: N/A
    Throws : N/A 
    ********************************************************************/
    public static void submitForApproval(Id promoId,List<ACCL__Promotion__c> promotionLst,Id queueId, Boolean emailResponse){
        String state = promotionLst[0].UL_Current_Status__c ;
        list<id> listNextapprover = new list<id>();
        
        try{
            //set current user as approval process submitter
            User submitter = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
            
            //if promotion is not active, not in planning and creator is not the submitter show error message
            if(String.isNotBlank(state)){
                if(!state.equalsIgnoreCase(UL_Utility.STATUS_PLANNING.toUpperCase()) || !promotionLst[0].ACCL__Active__c || submitter.Id != promotionLst[0].CreatedById){                    
                    throw new UL_CustomException(Label.UL_PROMOTION_SUBMIT_VALIDATION);
                }
            }
            
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(COMMENTS_SUBMIT);
            req1.setObjectId(promoId);
            req1.setSubmitterId(submitter.Id);
            
            //query for applicable approval process from Promotion Template, if no Approval Process set, show message to the user
            List<ProcessDefinition> apprProcLst = new List<ProcessDefinition>() ;
            apprProcLst = [SELECT Name,Id,DeveloperName FROM ProcessDefinition WHERE State=:ACTIVE AND Name =: promotionLst[0].ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c LIMIT 1] ;
            if(apprProcLst.size() > 0){
                String apprProcId = apprProcLst[0].DeveloperName ;
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId(apprProcId); 
            }
            else{
                throw new UL_CustomException(System.Label.UL_WORKFLOW_NOT_SET_ON_TEMPLATE);
            }
            
            /*get next step Approver Id, if not available show error message
            1. if threshold not violated, get the approver from finance user set up on the user record
            2. if threshold violated, get the approver by using role passed from threshold engine */
            if(!promotionLst[0].UL_ThresholdViolated__c){                       
                if(promotionLst[0].UL_Threshold_Window_Result__c == null){                        
                    listNextapprover = UL_PromotionWorkflowService.getApproverIds(promoId,ROLE_FINANCE_USER);
                    if(listNextapprover.size() == 0){
                      throw new UL_CustomException(ROLE_FINANCE_USER + label.UL_UserNotSetup);
                    }
                    queueId = UL_PromotionWorkflowService.addApproverstoQueue(promoId,listNextapprover,QUEUE_FINANCE); 
                    req1.setNextApproverIds(new list<id> {queueid});
                }
                Else{
                    req1.setNextApproverIds(new list<id> {UserInfo.getUserId()});
                }
            }
            else {
              req1.setNextApproverIds(new list<id> {queueid});
            }
           
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            //unlock promotion record after submission
            unlockPromotion( promoId) ;
            
            /*send email, if threshold violated or no threshold records set up, only to the main approver.
            No need to mail when threshold not violated i.e. in case of self-approval */
            if((promotionLst[0].UL_ThresholdViolated__c || (!promotionLst[0].UL_ThresholdViolated__c && promotionLst[0].UL_Threshold_Window_Result__c == null)) && !emailResponse){
                sendEmail(promoId, mainApproverId, UL_Utility.STATUS_SUBMIT.toLowerCase()) ;
            }
        }catch(Exception ex){
             UL_Utility.logError(ex, UserInfo.getUserId());
             throw ex;
        } 
    }    
    /*******************************************************************
        Purpose: Unlock Promotion - enable editable.  
        Version 1.0
        Parameters: Promotion Id
        Returns: N/A
        Throws : N/A 
        ********************************************************************/
    public static void unlockPromotion(Id promoId){ 
        try{    
            Approval.UNLockResult lrList = Approval.unLock(promoId, BOOLEAN_FALSE);
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }    
    /*******************************************************************
     Purpose: Execute Promotion approval Workflow.  
     Version 1.0
     Parameters: Promotion Id, List of Promotions, Current Status String
     Returns: Workflow Item Id
     Throws : N/A 
    ********************************************************************/
    public static Id approveWorkflow(Id promoId, List<ACCL__Promotion__c> promotionLst,String currentStatus, Boolean emailResponse){
        List<ProcessInstancenode> processInstanceNodeLst = new List<ProcessInstancenode>() ;
        list<Id> nextApproverId = new list<id>() ;
        Id queueId = UL_Utility.NULL_ID;
        Id workItemId = UL_Utility.NULL_ID;
        String state = promotionLst[0].UL_Current_Status__c ;       
        
        try{
            //sow error message, if user is clicking on Approve button, if promotion is in Approved or Planning state.
            if(promotionLst[0].UL_ThresholdViolated__c ){
                if(String.isNotBlank(state)){
                    if(UL_Utility.STATUS_APPROVED.equals(state) || UL_Utility.STATUS_PLANNING.equals(state)){
                        throw new UL_CustomException(Label.UL_PROMOTION_APPROVAL_VALIDATION);
                    }
                }
            }
            
            //create ProcessWorkitemRequest object
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(COMMENTS_APPROVE);
            req.setAction(UL_Utility.STATUS_APPROVE);
            
            //1. if threshold is pass, set promotion creator as the next approver
            if(!promotionLst[0].UL_ThresholdViolated__c && promotionLst[0].UL_Threshold_Window_Result__c != null){
                req.setNextApproverIds(new Id[] {promotionLst[0].CreatedById});
            }
            
            //2. if threshold violated or threshold records not set up, set approver based on approval step
            if((promotionLst[0].UL_ThresholdViolated__c || (!promotionLst[0].UL_ThresholdViolated__c && promotionLst[0].UL_Threshold_Window_Result__c == null))){
                //query ProcessInstanceNode table, to know which workflow step, the promotion is in
                processInstanceNodeLst = [SELECT ProcessNodeName, ProcessNodeid, ProcessNode.DeveloperName,ProcessInstanceId,NodeStatus,ProcessInstance.ProcessDefinition.DeveloperName
                FROM ProcessInstanceNode WHERE Processinstance.targetobjectid =: promoId 
                                    AND NodeStatus =: UL_Utility.STATUS_PENDING LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
                                    
                if(processInstanceNodeLst.size() > 0){  
                    for(ProcessInstanceNode procInstNode : processInstanceNodeLst) {
                        /* 1. if current workflow step is Finance Check, and if the workflow is not PastDated/Urgent one, set next approver to Account Manager
                        2. if current workflow step is Finance Check, and if the workflow is PastDated/Urgent one, set next approver to Director */
                        if(procInstNode.ProcessNode.DeveloperName.equalsIgnoreCase(UtilityEnum.UL_Finance_Check.Name())){
                            if(currentStatus!=null && currentStatus.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase())){
                                if(!procInstNode.ProcessInstance.ProcessDefinition.DeveloperName.containsIgnoreCase(STEP_URGENT)){
                                    nextApproverId = getApproverIds(promoId, ROLE_MANAGER);
                                }
                                else{
                                    nextApproverId = getApproverIds(promoId, ROLE_TPM);
                                }
                                //show error if next approver is not resolved
                                if(nextApproverId.size() == 0){
                                    throw new ul_customexception(label.UL_UserNotSetup );
                                }
                                //add approver(s) to corresponding queue
                                queueId = addApproverstoQueue(promoId,nextApproverId, UL_Utility.ROLE_ACCOUNT_MANAGER.capitalize());                            
                            }
                            //set queue as the next approver
                            req.setNextApproverIds(new list<id>{queueId});
                        }
                    }
                }            
            
                List<ProcessInstanceWorkitem> processInstanceWorkItemLst = new List<ProcessInstanceWorkitem>() ;
                List<User > currentUser = new List<User >() ;
                List<User > assigneeUser = new List<User >() ;
                Boolean memberExists = false ;
                Id assigneeUserId = UL_Utility.NULL_ID;
                Id currentUserId = UL_Utility.NULL_ID; 
                Id approvalAssigneeId = UL_Utility.NULL_ID;
                
                //if current user who cliked on Approve button is not supposed to approve the promotion, show error
                processInstanceWorkItemLst = [SELECT CreatedById,CreatedDate,ElapsedTimeInDays,ElapsedTimeInHours,ElapsedTimeInMinutes,Id,IsDeleted,OriginalActorId,ProcessInstanceId,
                                            ActorId,SystemModstamp FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectid =: promoId LIMIT 1];
                if(processInstanceWorkItemLst.size() > 0 && !emailResponse){
                    if(promotionLst[0].UL_Finance_Check_Approvers__c!=null && currentStatus!=null && currentStatus.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase()) && !promotionLst[0].UL_Finance_Check_Approvers__c.contains(userinfo.getuserid())){
                       throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                    }
                   if(promotionLst[0].UL_Manager_Check_Approvers__c!=null && currentStatus!=null 
                   && (currentStatus.containsIgnoreCase(UL_Utility.STATUS_MANAGER_CHECK.toLowerCase()) || currentStatus.containsIgnoreCase(UL_Utility.STATUS_DIRECTOR_CHECK.toLowerCase()))
                   && !promotionLst[0].UL_Manager_Check_Approvers__c.contains(userinfo.getuserid())){
                       throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                    } 
                }
            }
            
            //approve the request, if there is an item pending for approval
            workItemId = getWorkItemId(promoId);        
            if(workItemId != null){
                req.setWorkitemId(workItemId);                
                Approval.ProcessResult result =  Approval.process(req);
                //send email if there is next step, to next approver
                workItemId = getWorkItemId(promoId);
                if(workItemId != null 
                && (promotionLst[0].UL_ThresholdViolated__c || (!promotionLst[0].UL_ThresholdViolated__c && promotionLst[0].UL_Threshold_Window_Result__c == null))
                && processInstanceNodeLst[0].ProcessNode.DeveloperName.equalsIgnoreCase(UtilityEnum.UL_Finance_Check.Name())){
                    sendEmail(promoId, mainApproverId, UL_Utility.STATUS_APPROVE.toLowerCase()) ;
                }
            }
        }catch(Exception ex){
            throw ex;
            UL_Utility.logError(ex, UserInfo.getUserId());
        }        
        return workItemId;
    }
    /*******************************************************************
     Purpose: Get ProcessInstanceWorkItemId using SOQL.  
     Version 1.0
     Parameters: Object Id
     Returns: Workflow Item Id
     Throws : N/A 
    ********************************************************************/
    public static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        try{
            for(ProcessInstanceWorkitem workItem  : [SELECT p.Id FROM ProcessInstanceWorkitem p
                WHERE p.ProcessInstance.TargetObjectId =: targetObjectId LIMIT 1])
            {
                retVal  =  workItem.Id;
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return retVal;
    }    
    /*******************************************************************
     Purpose: Execute reject action on Promotion.  
     Version 1.0
     Parameters: Promotion Id, List of Promotions
     Returns: N/A
     Throws : N/A 
    ********************************************************************/
    public static void rejectWorkflow(Id promoId, List<ACCL__Promotion__c> promotionLst, Boolean emailResponse)
    {
        //create ProcessWorkitemRequest object: set 1. action as REJECT 2. rejection comments
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(COMMENTS_REJECT);
        req.setAction(UL_Utility.STATUS_REJECT);
        Id workItemId = getWorkItemId(promoId);
        String state = promotionLst[0].UL_Current_Status__c ;
        
        try{
            if(String.isNotBlank(state)){
                //show error, if promotion is in Planning
                if(UL_Utility.STATUS_PLANNING.equalsIgnoreCase(state)){                    
                    throw new UL_CustomException(Label.UL_PROMOTION_REJECT_VALIDATION);
                }
                //show error, if promotion is Approved and not future dated
                if(UL_Utility.STATUS_APPROVED.equalsIgnoreCase(state) && promotionLst[0].ACCL__Date_From__c <= System.today()){                    
                    throw new UL_CustomException(Label.UL_PROMOTION_PLANNING_VALIDATION);
                }
            }
            
            //show error, if user clicking on Reject button is not the assigned user: 1, 2, 3
            List<ProcessInstanceWorkitem> processInstanceWorkItemLst = new List<ProcessInstanceWorkitem>() ;
            processInstanceWorkItemLst = [SELECT CreatedById,CreatedDate,ElapsedTimeInDays,ElapsedTimeInHours,ElapsedTimeInMinutes,Id,IsDeleted,OriginalActorId,ProcessInstanceId,
                                            ActorId,SystemModstamp FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectid =: promoId LIMIT 1];            
            if(processInstanceWorkItemLst.size() > 0 && !emailResponse){
                //1. if current step is Finance Check
                if(promotionLst[0].UL_Finance_Check_Approvers__c!=null && promotionLst[0].UL_Current_Status__c !=null && promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase()) && !promotionLst[0].UL_Finance_Check_Approvers__c.contains(userinfo.getuserid())){
                   throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                }
                //2. if current step is Manager Check or Director Check
                else if(promotionLst[0].UL_Manager_Check_Approvers__c!=null && promotionLst[0].UL_Current_Status__c !=null && promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_MANAGER_CHECK.toLowerCase()) && !promotionLst[0].UL_Manager_Check_Approvers__c.contains(userinfo.getuserid())){
                   throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                }
                //3. if user is not the creator and current workflow step is neither Finance Check nor Manager Check (covers Director Check)
                else if(!promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_MANAGER_CHECK.toLowerCase())
                && !promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase())  
                && !promotionLst[0].CreatedById.equals(userinfo.getuserid())){
                    throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                }
            }
            
            //reject workflow, if there is an item pending for action
            if(workItemId != null){            
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
                //send rejection email to creator
                sendEmail(promoId, promotionLst[0].CreatedById, STATUS_REJECT) ;
            }
        }
        catch(Exception ex){
            throw ex;
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }    
    /*******************************************************************
     Purpose: Get approvers for a Promotion by role.  
     Version 1.0
     Parameters: Promotion Id, Targeted user role String
     Returns: List of Approver ids
     Throws : N/A 
    ********************************************************************/
    public static list<Id> getApproverIds(Id promotionId, String userRole){
        Set<Id> approverIds = new Set<Id>() ;
        List<Id> nextApproverIds = new List<Id>() ;
        try{
            for(ACCL__Promotion__c promuser : [SELECT CreatedBy.UL_Finance_Analyst__c, CreatedBy.UL_Finance_Analyst__r.userrole.name,CreatedBy.UL_Finance_Manager__c,CreatedBy.UL_Finance_Manager__r.userrole.name,CreatedBy.managerid,CreatedBy.manager.userrole.name FROM ACCL__Promotion__c WHERE Id =: promotionId LIMIT 1]){
                system.debug('userRole '+userRole) ;
                system.debug('promuser.CreatedBy.UL_Finance_Analyst__r.userrole.name '+promuser.CreatedBy.UL_Finance_Analyst__r.userrole.name) ;
                //if user role is not = Director
                if(!userRole.containsIgnoreCase(ROLE_TPM)){
                    //if role passed to this function is Finance Analyst's
                    if(promuser.CreatedBy.UL_Finance_Analyst__r.userrole.name.containsIgnorecase(userRole)){
                        approverIds.add(promuser.CreatedBy.UL_Finance_Analyst__c);
                    }
                    system.debug('promuser.CreatedBy.UL_Finance_manager__r.userrole.name '+promuser.CreatedBy.UL_Finance_manager__r.userrole.name) ;
                    //if role passed to this function is Finance Manager's
                    if(promuser.CreatedBy.UL_Finance_manager__r.userrole.name.containsIgnorecase(userRole)){
                        approverIds.add(promuser.CreatedBy.UL_Finance_Manager__c);
                    }
                }
                system.debug('promuser.CreatedBy.manager.userrole.name '+promuser.CreatedBy.manager.userrole.name) ;
                //if role passed to this function is Manager's - includes Account Manager, Director 
                if(promuser.CreatedBy.manager.userrole.name.containsIgnorecase(userRole)){
                    approverIds.add(promuser.CreatedBy.managerid);
                }
            }
            system.debug('approverIds '+approverIds) ;
            //store main approver, only to whom email will be sent.
            for(Id apprId : approverIds){
                mainApproverId = apprId ;
            }
            
            //get additional approvers, from category team, matching role
            for(UL_UserCustomerProduct__c categoryUser : [SELECT User__c,User__r.userrole.name FROM UL_UserCustomerProduct__c WHERE Product__c IN (SELECT Product__c FROM UL_PromotionCategory__c WHERE Promotion__c =: promotionId) LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
               if(categoryUser.User__r.userrole.name.containsIgnoreCase(userRole)){
                    approverIds.add(categoryUser.User__c ) ;
               }
            } 
            system.debug('approverIds '+approverIds) ;  
            nextApproverIds.addAll(approverIds);
            
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return nextApproverIds;
    }    
    /*******************************************************************
     Purpose: Adding approvers to targeted queue to avail for Promotion approval/rejection  
     Version 1.0
     Parameters: Promotion Id, List of next targeted approvers, next step name String
     Returns: Queue id
     Throws : N/A 
    ********************************************************************/
    public static id addApproverstoQueue(Id promotionId,List<Id> nextApproverIds, String stepName ){    
        //Update approvers to promotion field and add next approvers to Queue dynamically
        list<group> groupQueues = new list<group>();
        
        try{
            ACCL__Promotion__c promotionObj = new ACCL__Promotion__c();
            promotionObj.id = promotionId;
            
            //query for finance/manager queues depending on workflow step: 1,2. And store approvers on to Finance/Manager approver field on promotion
            //1. finance queue
            if(stepName.containsIgnoreCase(UtilityEnum.finance.Name())){
              promotionObj.UL_Finance_Check_Approvers__c = JSON.Serialize(nextApproverIds);
              groupQueues = [SELECT Id,name FROM Group WHERE type=:UtilityEnum.queue.Name() AND name=:FINANCE_QUEUE LIMIT 1];
            }
            //2. manager queue
            if(stepName.containsIgnoreCase(UtilityEnum.manager.Name())){
               promotionObj.UL_Manager_Check_Approvers__c = JSON.Serialize(nextApproverIds); 
               groupQueues = [SELECT Id,name FROM Group WHERE type=:UtilityEnum.queue.Name() AND name=:MANAGER_QUEUE LIMIT 1];
            }

            database.update(promotionObj);
            upsertQueue(nextApproverIds,groupQueues[0].id);
        }catch(exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }      
        return groupQueues[0].id;
    }      
    /*******************************************************************
     Purpose: Update approver queue  
     Version 1.0
     Parameters: List of next targeted approvers, Queue Id
     Returns: N/A
     Throws : N/A 
    ********************************************************************/ 
    @future
    public static void upsertQueue(list<id> nextApproverIds, id queueId){
        try{
            list<GroupMember> queueMembers = new list<GroupMember>();
            for(Id approverId : nextApproverIds){
               GroupMember addmember = (GroupMember)UL_Utility.getNewObject(Schema.SObjectType.GroupMember);
               addmember.UserOrGroupId = approverId;
               addmember.GroupId = queueId;
               queueMembers.add(addmember);
            }
            if(!queueMembers.isempty()){
             database.upsert(queueMembers);
            }
        }catch(exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }     
    /*******************************************************************
    Purpose: Sent approval pending emails to approver(s)  
    Version 1.0
    Parameters: Promotion Id, Action as String
    Returns: N/A
    Throws : N/A 
    ********************************************************************/   
    public static void sendEmail(Id promotionId,Id emailToId, String actionStr){
        Messaging.SingleEmailMessage mailMessage = new Messaging.SingleEmailMessage();
        try{
            List<EmailTemplate> emailTemplateList = new List<EmailTemplate>() ;
            
            //fetch email template based on string passed to this function: 1,2,3
            //1. Submit for Approval template
            if(actionStr.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT.toLowerCase())){
               emailTemplateList = [SELECT Id, Name FROM EmailTemplate WHERE Name =: UtilityEnum.SoCo_Promotion_Submit.Name() LIMIT 1] ;
            }
            //2. Submit for Approval template
            if(actionStr.equalsIgnoreCase(STATUS_APPROVE)){
               emailTemplateList = [SELECT Id, Name FROM EmailTemplate WHERE Name =: UtilityEnum.SoCo_Promotion_Approved.Name() LIMIT 1] ;
            }
            //3. Submit for Approval template
            if(actionStr.equalsIgnoreCase(STATUS_REJECT)){
               emailTemplateList = [SELECT Id, Name FROM EmailTemplate WHERE Name =: UtilityEnum.SoCo_Promotion_Rejected.Name() LIMIT 1] ;
            }
            
            //construct Messaging.SingleEmailMessage object: 1. set template 2. set promotion record id 3. set Recepient 
            if(!emailTemplateList.isEmpty()){
                mailMessage.setTemplateId(emailTemplateList[0].Id);
                mailMessage.setWhatId(promotionId);
                mailMessage.setTargetObjectId(emailToId);
                mailMessage.setSaveAsActivity(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailMessage });
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
}