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
            String custSetDataSetName = UL_Utility.STRING_NULL;
            String state = promotionLst[0].UL_Current_Status__c ;
            list<id> listNextapprover = new list<id>();
            
            try{
                User submitter = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
                
                if(String.isNotBlank(state)){
                    if(!state.equalsIgnoreCase(UL_Utility.STATUS_PLANNING.toUpperCase()) || !promotionLst[0].ACCL__Active__c || submitter.Id != promotionLst[0].CreatedById){                    
                        throw new UL_CustomException(Label.UL_PROMOTION_SUBMIT_VALIDATION);
                    }
                }                
                /*if(promotionLst.size() > 0 && String.isNotBlank(promotionLst[0].ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c)){
                    custSetDataSetName = promotionLst[0].ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c + UL_Utility.HYPHEN + promotionLst[0].ACCL__Sales_Org__c ;
                }*/
            
                //if(String.isNotBlank(custSetDataSetName)){      
                    //UL_PromotionTemplate_ApprovalProcess__c apprProcCustSetRec = UL_PromotionTemplate_ApprovalProcess__c.getInstance(custSetDataSetName)  ;
                    
                    //if(apprProcCustSetRec  != null && String.isNotBlank(apprProcCustSetRec.UL_Approval_Process__c)){                        
                        // Create an approval request for the account
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for approval.');
                        req1.setObjectId(promoId);              
                        
                        // Submit on behalf of a specific submitter
                        req1.setSubmitterId(submitter.Id);              
                        List<ProcessDefinition> apprProcLst = new List<ProcessDefinition>() ;
                        apprProcLst = [SELECT Name,Id,DeveloperName FROM ProcessDefinition WHERE State=:ACTIVE AND Name =: promotionLst[0].ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c] ;
                        if(apprProcLst.size() > 0){
                            String apprProcId = apprProcLst[0].DeveloperName ;
                            // Submit the record to specific process and skip the criteria evaluation
                            req1.setProcessDefinitionNameOrId(apprProcId); 
                        }
                        else{
                            throw new UL_CustomException('No Workflow is set on the Promotion Template');
                        }
                        
                        if(!promotionLst[0].UL_ThresholdViolated__c){                       
                            if(promotionLst[0].UL_Threshold_Window_Result__c == null){                        
                                listNextapprover = UL_PromotionWorkflowService.getApproverIds(promoId,'Finance User');
                                if(listNextapprover !=null && listNextapprover.isempty()){
                                  throw new UL_CustomException('role-Finance User '+label.UL_UserNotSetup);
                                }
                                queueId = UL_PromotionWorkflowService.addApproverstoQueue(promoId,listNextapprover,'finance'); 
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
                        
                        unlockPromotion( promoId) ;
                        if((promotionLst[0].UL_ThresholdViolated__c || (!promotionLst[0].UL_ThresholdViolated__c && promotionLst[0].UL_Threshold_Window_Result__c == null)) && !emailResponse){
                            sendEmail(promoId, mainApproverId, UL_Utility.STATUS_SUBMIT.toLowerCase()) ;
                        }
                        //}                                            
                 //}
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
            Approval.UNLockResult lrList = Approval.unLock(promoId, false);
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
            if(promotionLst[0].UL_ThresholdViolated__c ){
                if(String.isNotBlank(state)){
                    if(UL_Utility.STATUS_APPROVED.equals(state) || UL_Utility.STATUS_PLANNING.equals(state)){
                        throw new UL_CustomException(Label.UL_PROMOTION_APPROVAL_VALIDATION);
                    }
                }
            }
            
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Request Approved');
            req.setAction(UL_Utility.STATUS_APPROVE);
            
            if(!promotionLst[0].UL_ThresholdViolated__c && promotionLst[0].UL_Threshold_Window_Result__c != null){
                req.setNextApproverIds(new Id[] {promotionLst[0].CreatedById});
            }
            
            if((promotionLst[0].UL_ThresholdViolated__c || (!promotionLst[0].UL_ThresholdViolated__c && promotionLst[0].UL_Threshold_Window_Result__c == null))){
                //processInstanceNodeLst = [SELECT ProcessNodeName, ProcessNodeid, ProcessInstanceId,NodeStatus FROM ProcessInstanceNode WHERE Processinstance.targetobjectid =: promoId 
                  //                  AND ProcessNode.DeveloperName =: UtilityEnum.UL_Finance_Check.Name() AND NodeStatus =: UL_Utility.STATUS_PENDING LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
                processInstanceNodeLst = [SELECT ProcessNodeName, ProcessNodeid, ProcessNode.DeveloperName,ProcessInstanceId,NodeStatus FROM ProcessInstanceNode WHERE Processinstance.targetobjectid =: promoId 
                                    AND NodeStatus =: UL_Utility.STATUS_PENDING LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
                                    
                if(processInstanceNodeLst.size() > 0){  
                    for(ProcessInstanceNode procInstNode : processInstanceNodeLst) {
                        if(procInstNode.ProcessNode.DeveloperName.equalsIgnoreCase(UtilityEnum.UL_Finance_Check.Name())){
                            if(currentStatus!=null && currentStatus.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase())){        
                               nextApproverId = getApproverIds(promoId, UL_Utility.ROLE_ACCOUNT_MANAGER);
                                if(nextApproverId==null || nextApproverId.isempty()){
                                    throw new ul_customexception(label.UL_UserNotSetup );
                                }
                               queueId = addApproverstoQueue(promoId,nextApproverId, UL_Utility.ROLE_ACCOUNT_MANAGER.capitalize());                            
                            }
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
                processInstanceWorkItemLst = [SELECT CreatedById,CreatedDate,ElapsedTimeInDays,ElapsedTimeInHours,ElapsedTimeInMinutes,Id,IsDeleted,OriginalActorId,ProcessInstanceId,
                                            ActorId,SystemModstamp FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectid =: promoId LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
                if(processInstanceWorkItemLst.size() > 0 && !emailResponse){
                    if(promotionLst[0].UL_Finance_Check_Approvers__c!=null && currentStatus!=null && currentStatus.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase()) && !promotionLst[0].UL_Finance_Check_Approvers__c.contains(userinfo.getuserid())){
                       throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                    }
                   if(promotionLst[0].UL_Manager_Check_Approvers__c!=null && currentStatus!=null && currentStatus.containsIgnoreCase(UL_Utility.STATUS_MANAGER_CHECK.toLowerCase()) && !promotionLst[0].UL_Manager_Check_Approvers__c.contains(userinfo.getuserid())){
                       throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                    } 
                }
            }
            
            workItemId = getWorkItemId(promoId);        
            if(workItemId != null){
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
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
                WHERE p.ProcessInstance.TargetObjectId =: targetObjectId LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())])
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
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected request');
        req.setAction(UL_Utility.STATUS_REJECT);
        Id workItemId = getWorkItemId(promoId);
        String state = promotionLst[0].UL_Current_Status__c ;
        
        try{
            if(String.isNotBlank(state)){
                if(UL_Utility.STATUS_PLANNING.equalsIgnoreCase(state)){                    
                    throw new UL_CustomException(Label.UL_PROMOTION_REJECT_VALIDATION);
                }
                if(UL_Utility.STATUS_APPROVED.equalsIgnoreCase(state) && promotionLst[0].ACCL__Date_From__c <= System.today()){                    
                    throw new UL_CustomException(Label.UL_PROMOTION_PLANNING_VALIDATION);
                }
            }
            
            List<ProcessInstanceWorkitem> processInstanceWorkItemLst = new List<ProcessInstanceWorkitem>() ;
            processInstanceWorkItemLst = [SELECT CreatedById,CreatedDate,ElapsedTimeInDays,ElapsedTimeInHours,ElapsedTimeInMinutes,Id,IsDeleted,OriginalActorId,ProcessInstanceId,
                                            ActorId,SystemModstamp FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectid =: promoId LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
            if(processInstanceWorkItemLst.size() > 0 && !emailResponse){
                if(promotionLst[0].UL_Finance_Check_Approvers__c!=null && promotionLst[0].UL_Current_Status__c !=null && promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase()) && !promotionLst[0].UL_Finance_Check_Approvers__c.contains(userinfo.getuserid())){
                   throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                }
                else if(promotionLst[0].UL_Manager_Check_Approvers__c!=null && promotionLst[0].UL_Current_Status__c !=null && promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_MANAGER_CHECK.toLowerCase()) && !promotionLst[0].UL_Manager_Check_Approvers__c.contains(userinfo.getuserid())){
                   throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                }
                else if(!promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_MANAGER_CHECK.toLowerCase())
                && !promotionLst[0].UL_Current_Status__c.containsIgnoreCase(UL_Utility.STATUS_FINANCE_CHECK.toLowerCase())  
                && !promotionLst[0].CreatedById.equals(userinfo.getuserid())){
                    throw new ul_customexception(Label.UL_PROMOTION_ASSIGNE_VALIDATION);
                }
            }
            
            if(workItemId != null){            
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
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
            for(ACCL__Promotion__c promuser : [SELECT CreatedBy.UL_Finance_Analyst__c, CreatedBy.UL_Finance_Analyst__r.userrole.name,CreatedBy.UL_Finance_Manager__c,CreatedBy.UL_Finance_Manager__r.userrole.name,CreatedBy.managerid,CreatedBy.manager.userrole.name FROM ACCL__Promotion__c WHERE Id =: promotionId LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
                system.debug('userRole '+userRole) ;
                system.debug('promuser.CreatedBy.UL_Finance_Analyst__r.userrole.name '+promuser.CreatedBy.UL_Finance_Analyst__r.userrole.name) ;
                if(promuser.CreatedBy.UL_Finance_Analyst__r.userrole.name.containsIgnorecase(userRole)){
                    approverIds.add(promuser.CreatedBy.UL_Finance_Analyst__c);
                    //sendEmail(promotionId,promuser.CreatedBy.UL_Finance_Analyst__c, UL_Utility.STATUS_SUBMIT.toLowerCase()) ;
                }
                system.debug('promuser.CreatedBy.UL_Finance_manager__r.userrole.name '+promuser.CreatedBy.UL_Finance_manager__r.userrole.name) ;
                if(promuser.CreatedBy.UL_Finance_manager__r.userrole.name.containsIgnorecase(userRole)){
                    approverIds.add(promuser.CreatedBy.UL_Finance_Manager__c);
                    //sendEmail(promotionId,promuser.CreatedBy.UL_Finance_Manager__c, UL_Utility.STATUS_SUBMIT.toLowerCase()) ;
                }
                system.debug('promuser.CreatedBy.manager.userrole.name '+promuser.CreatedBy.manager.userrole.name) ;
                if(promuser.CreatedBy.manager.userrole.name.containsIgnorecase(userRole)){
                    approverIds.add(promuser.CreatedBy.managerid);
                    //sendEmail(promotionId,promuser.CreatedBy.manager, UL_Utility.STATUS_SUBMIT.toLowerCase()) ;
                }
            }
            system.debug('approverIds '+approverIds) ;
            for(Id apprId : approverIds){
                mainApproverId = apprId ;
            }
            
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
          if(stepName.containsIgnoreCase(UtilityEnum.finance.Name())){
              promotionObj.UL_Finance_Check_Approvers__c = JSON.Serialize(nextApproverIds);
              groupQueues = [SELECT Id,name FROM Group WHERE type=:UtilityEnum.queue.Name() AND name=:FINANCE_QUEUE LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
          }
          
          if(stepName.containsIgnoreCase(UtilityEnum.manager.Name())){
               promotionObj.UL_Manager_Check_Approvers__c = JSON.Serialize(nextApproverIds); 
               groupQueues = [SELECT Id,name FROM Group WHERE type=:UtilityEnum.queue.Name() AND name=:MANAGER_QUEUE LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
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
             
             if(actionStr.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT.toLowerCase())){
                emailTemplateList = [SELECT Id, Name FROM EmailTemplate WHERE Name =: UtilityEnum.SoCo_Promotion_Submit.Name() LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
             }
             if(actionStr.equalsIgnoreCase(STATUS_APPROVE)){
                emailTemplateList = [SELECT Id, Name FROM EmailTemplate WHERE Name =: UtilityEnum.SoCo_Promotion_Approved.Name() LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
             }
             if(actionStr.equalsIgnoreCase(STATUS_REJECT)){
                emailTemplateList = [SELECT Id, Name FROM EmailTemplate WHERE Name =: UtilityEnum.SoCo_Promotion_Rejected.Name() LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
             }
             
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