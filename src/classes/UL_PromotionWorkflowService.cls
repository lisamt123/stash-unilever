global without sharing class UL_PromotionWorkflowService{
    public static final String FINANCE_CHECK = 'UL_Finance_Check' ;
    public static final String INSTANCE_NODE_STATUS_PENDING = 'Pending' ;
    public static final String WORKFLOW_STATE_APPROVED = 'Approved' ;
    public static final String WORKFLOW_STATE_PLANNING = 'PLANNING' ; 
    public static final string ACTION_SUBMIT = 'submit' ;   

    public static void submitForApproval(Id promoId,List<ACCL__Promotion__c> promotionLst,id queueId){
        //List<ACCL__Promotion__c> promotionLst = new List<ACCL__Promotion__c>() ;
        String apprProcName ;
        String custSetDataSetName ;
        UL_PromotionTemplate_ApprovalProcess__c apprProcCustSetRec = new UL_PromotionTemplate_ApprovalProcess__c() ;
        String WFState = promotionLst[0].UL_Current_Status__c ;
        Date dateFrom = promotionLst[0].ACCL__Date_From__c ;
        Date dateThru = promotionLst[0].ACCL__Date_Thru__c ;
        
        //promotionLst = [SELECT  ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c FROM ACCL__Promotion__c WHERE Id =: promoId] ;
        system.debug('promotionLst '+promotionLst) ;
        User submitter = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        if(String.isNotBlank(WFState)){
            if(!WFState.equalsIgnoreCase(WORKFLOW_STATE_PLANNING) || !promotionLst[0].ACCL__Active__c || submitter.Id != promotionLst[0].CreatedById){                    
                throw new UL_CustomException('You can submit workflow for approval, only if you are creator and promotion is in Planning state and is Active');
            }
        }
        
        if(promotionLst.size() > 0 && String.isNotBlank(promotionLst[0].ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c)){
            custSetDataSetName = promotionLst[0].ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c + '-' + promotionLst[0].ACCL__Sales_Org__c ;
        }
        system.debug('custSetDataSetName '+custSetDataSetName) ;
        
        if(String.isNotBlank(custSetDataSetName)){      
            apprProcCustSetRec = UL_PromotionTemplate_ApprovalProcess__c.getInstance(custSetDataSetName)  ;
            system.debug('apprProcCustSetRec '+apprProcCustSetRec) ;
            
            if(apprProcCustSetRec  != null && String.isNotBlank(apprProcCustSetRec.UL_Approval_Process__c)){        
                //submitter = [SELECT Id,UL_Finance_User__c FROM User WHERE Id =: UserInfo.getUserId()];
                
                // Create an approval request for the account
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(promoId);              
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(submitter.Id);              
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId(apprProcCustSetRec.UL_Approval_Process__c);
               
                req1.setNextApproverIds(new list<id> {queueid});                
                
                system.debug('req1 '+req1) ;
                
                
                try{
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);  
                    unlockPromotion( promoId) ;
                    sendEmail(promoId, queueid, ACTION_SUBMIT) ;
                    // Verify the result
                    System.assert(result.isSuccess());
                }
                catch(Exception e){
                    //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Not able to submit');
                    //ApexPages.addMessage(msg);
                    throw new UL_CustomException('If you are trying to submit Promotion for Workflow Approval, please check that the Promotion is Active and is in Planning state or '+e.getmessage());
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_PromotionWorkflowService', 'submitForApproval', 'An Exception occured in Code', e, NULL, NULL, NULL, NULL,UL_Utility.APPLICATION_NAME);
                }                     
                //System.assertEquals('For Finance Approval', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus()); 
            }
        }
    }
    
    public static void unlockPromotion(Id promoId){     
        Approval.UNLockResult lrList = Approval.unLock(promoId, false);
    }
    
    
    public static Id approveWorkflow(Id promoId, List<ACCL__Promotion__c> promotionLst,String currentStatus){
        List<ACCL__Promotion__c> promoLst = new List<ACCL__Promotion__c>() ;
        List<User> userLst = new List<User>() ;
        List<ProcessInstancenode> processInstanceNodeLst = new List<ProcessInstancenode>() ;
        list<Id> nextApproverId = new list<id>() ;
        id queueId;
        String retVal = '' ;
        Id workItemId = null ;
        String WFState = promotionLst[0].UL_Current_Status__c ;
        Date dateFrom = promotionLst[0].ACCL__Date_From__c ;
        Date dateThru = promotionLst[0].ACCL__Date_Thru__c ;
        
        if(promotionLst[0].UL_ThresholdViolated__c){
            if(String.isNotBlank(WFState)){
                if(WFState == 'Approved' || WFState == 'Planning'){
                    throw new UL_CustomException('You can approve a Promotion if it is not in Planning and not in Approved state');
                }
            }
        }
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Request Approved');
        req.setAction('Approve');
        
        if(!promotionLst[0].UL_ThresholdViolated__c){
            req.setNextApproverIds(new Id[] {promotionLst[0].CreatedById});
        }
        
        if(promotionLst[0].UL_ThresholdViolated__c){
            processInstanceNodeLst = [SELECT ProcessNodeName, ProcessNodeid, ProcessInstanceId,NodeStatus FROM ProcessInstancenode WHERE Processinstance.targetobjectid =: promoId 
                                AND ProcessNode.DeveloperName =: FINANCE_CHECK AND NodeStatus =: INSTANCE_NODE_STATUS_PENDING] ;
            system.debug('processInstanceNodeLst '+processInstanceNodeLst) ;
            if(processInstanceNodeLst.size() > 0){  
            if(currentStatus!=null && currentStatus.containsIgnoreCase('finance check')){        
               nextApproverId = getApproverIds(promoId,'Account Manager');
               queueId = addApproverstoQueue(promoId,nextApproverId, 'Account Manager');
               }           
                         
                req.setNextApproverIds(new list<id>{queueId});
            }            
        
            List<ProcessInstanceWorkitem> processInstanceWorkItemLst = new List<ProcessInstanceWorkitem>() ;
            List<User > currentUser = new List<User >() ;
            List<User > assigneeUser = new List<User >() ;
            Boolean memberExists = false ;
            Id assigneeUserId ;
            Id currentUserId ; 
            Id approvalAssigneeId ;
            processInstanceWorkItemLst = [SELECT CreatedById,CreatedDate,ElapsedTimeInDays,ElapsedTimeInHours,ElapsedTimeInMinutes,Id,IsDeleted,OriginalActorId,ProcessInstanceId,
                                        ActorId,SystemModstamp FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectid =: promoId] ;
            if(processInstanceWorkItemLst.size() > 0){
                if(promotionLst[0].UL_Finance_Check_Approvers__c!=null && currentStatus!=null && currentStatus.containsIgnoreCase('finance check') && !promotionLst[0].UL_Finance_Check_Approvers__c.contains(userinfo.getuserid())){
                   throw new ul_customexception('You are not assigne for Approver');
                }
               if(promotionLst[0].UL_Manager_Check_Approvers__c!=null && currentStatus!=null && currentStatus.containsIgnoreCase('manager check') && !promotionLst[0].UL_Manager_Check_Approvers__c.contains(userinfo.getuserid())){
                   throw new ul_customexception('You are not assigne for Approver');
                } 
            }
        }
        
        workItemId = getWorkItemId(promoId);        
        if(workItemId != null){
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
            workItemId = getWorkItemId(promoId);
        }        
        return workItemId;
    }
    
    
    /**
    * Get ProcessInstanceWorkItemId using SOQL
    **/
    public static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
    }
    
    
    /**
    * This method will Reject the opportunity
    **/
    public static void rejectWorkflow(Id promoId, List<ACCL__Promotion__c> promotionLst)
    {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected request');
        req.setAction('Reject');
        Id workItemId = getWorkItemId(promoId);
        String WFState = promotionLst[0].UL_Current_Status__c ;
        Date dateFrom = promotionLst[0].ACCL__Date_From__c ;
        Date dateThru = promotionLst[0].ACCL__Date_Thru__c ;
        
        if(String.isNotBlank(WFState)){
            if(WFState == 'Planning'){                    
                throw new UL_CustomException('You can not reject Promotion which is in Planning state');
            }
            if(WFState == 'Approved' && dateFrom <= System.today()){                    
                throw new UL_CustomException('You can put Promotion back in Planning only if it is future dated');
            }
        }
        
        if(workItemId != null){            
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
    public static list<Id> getApproverIds(Id promotionId, String userRole){
        Set<Id> approverIds = new Set<Id>() ;
        List<Id> nextApproverIds = new List<Id>() ;
        list<UL_UserCustomerProduct__c> categoryUsers = new list<UL_UserCustomerProduct__c>();
        Map<String,Id> roleUserId = new Map<String,Id>();
        categoryUsers = [select User__c,User__r.userrole.name from UL_UserCustomerProduct__c where Product__c in (SELECT Product__c FROM UL_PromotionCategory__c WHERE Promotion__c =: promotionId)] ;
        system.debug('categoryUsers '+categoryUsers ) ;
        List<ACCL__Promotion__c> promoUsers = new List<ACCL__Promotion__c>() ;
        promoUsers = [SELECT CreatedBy.UL_Finance_Analyst__c, CreatedBy.UL_Finance_Analyst__r.userrole.name,CreatedBy.UL_Finance_Manager__c,CreatedBy.UL_Finance_Manager__r.userrole.name,CreatedBy.managerid,CreatedBy.manager.userrole.name FROM ACCL__Promotion__c WHERE Id =: promotionId] ;
        system.debug('promoUsers '+promoUsers ) ;
        for(ACCL__Promotion__c promuser : promoUsers){
            if(promuser.CreatedBy.UL_Finance_Analyst__r.userrole.name==userRole){
            approverIds.add(promuser.CreatedBy.UL_Finance_Analyst__c);
            sendEmail(promotionId,promuser.CreatedBy.UL_Finance_Analyst__c,ACTION_SUBMIT ) ;
            }
            if(promuser.CreatedBy.UL_Finance_manager__r.userrole.name==userRole){
            approverIds.add(promuser.CreatedBy.UL_Finance_Manager__c);
            sendEmail(promotionId,promuser.CreatedBy.UL_Finance_Manager__c,ACTION_SUBMIT ) ;
            }
            
            if(promuser.CreatedBy.manager.userrole.name.containsIgnorecase(userRole)){
            approverIds.add(promuser.CreatedBy.managerid);
            }
        }
        for(UL_UserCustomerProduct__c categoryUser : categoryUsers){
           if(categoryUser.User__r.userrole.name.containsIgnoreCase(userRole)){
            approverIds.add(categoryUser.User__c ) ;
            }
        } 
          
        nextApproverIds.addAll(approverIds ) ;
        system.debug('nextApproverIds '+nextApproverIds) ;  
        return nextApproverIds;
    }
    public static id addApproverstoQueue(Id promotionId,List<Id> nextApproverIds, String stepName ){
    //Update approvers to promotion field and add next approvers to Queue dynamically
    list<group> groupQueues = new list<group>();
    
    try{
      system.debug('next approvers-'+nextApproverIds+' step-'+stepName );
      ACCL__Promotion__c promotionObj = new ACCL__Promotion__c();
      promotionObj.id = promotionId;
      if(stepName.containsIgnoreCase('finance')){
      promotionObj.UL_Finance_Check_Approvers__c = JSON.Serialize(nextApproverIds);
      groupQueues = [select Id,name from Group where type='queue' and name='Finance Check Dynamic Queue'];
      }
      if(stepName.containsIgnoreCase('manager')){
       promotionObj.UL_Manager_Check_Approvers__c = JSON.Serialize(nextApproverIds); 
       groupQueues = [select Id,name from Group where type='queue' and name='Manager Check Dynamic Queue'];
       system.debug('group queue '+groupQueues);
      }
      
      database.update(promotionObj);
      upsertQueue(nextApproverIds,groupQueues[0].id);
      }
      Catch(exception e){
       throw new UL_CustomException('Error-'+e.getmessage());
      }
      return groupQueues[0].id;
    }
      
      
     @future
     public static void upsertQueue(list<id> nextApproverids, id queueid){
     list<GroupMember> queueMembers = new list<GroupMember>();
     for(Id approverId : nextApproverIds){
        GroupMember addmember = new GroupMember();
        addmember.UserOrGroupId = approverId;
        addmember.GroupId = queueid;
        queueMembers.add(addmember);
      }
      if(!queueMembers.isempty()){
       database.upsert(queueMembers);
      }
     } 
       
     public static void sendEmail(Id promotionId,Id toId, String actionStr){
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    // Who you are sending the email to
    // The email template ID used for the email
    /*public enum actionENUM {SoCo_Promotion_Rejected, SoCo_Promotion_Submit, SoCo_Promotion_Approved} 
    public enum actionENUM2 {submit, approve, reject}
    String templateId ;
    List<actionENUM> actionLst = new List<actionENUM>() ;
List<EmailTemplate> tempLst = new List<EmailTemplate>() ;
    actionLst = actionENUM.values() ;
    for(Integer i=0;i< actionLst.size(); i++){
        if(actionLst[i] == actionENUM2.submit){
        tempLst = [SELECT Id, Name FROM EmailTemplate WHERE Name =: 'test'] ;
    }
    }*/
    
    List<EmailTemplate> tempLst = new List<EmailTemplate>() ;
    if(actionStr.equalsIgnoreCase(ACTION_SUBMIT)){
        tempLst = [SELECT Id, Name FROM EmailTemplate WHERE Name =: 'SoCo_Promotion_Submit'] ;
    }

    mail.setTemplateId(tempLst[0].Id);
    mail.setWhatId(promotionId);
    mail.setTargetObjectId(toId);
    //mail.setWhoId('00558000001WZqx');
    //mail.toAddresses = new String[] { '00558000001WZqx' };
    mail.setSaveAsActivity(false);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 }
}