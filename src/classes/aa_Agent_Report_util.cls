/**
 * Name:        -   aa_Agent_Report_util ()
 * @description -   This class is used to capture mandatory fields 
 * @Author      -   Aslesha R K     
 */


public with sharing class aa_Agent_Report_util {
    
    /*******************************************************************
    Purpose: This method check  Chaterposting 
    Parameters: List of aa_Agent_Report__c
    Returns: Void
    Throws [Exceptions]: 
    ********************************************************************/
    public static void create_Chatter_posting(List<aa_Agent_Report__c> listAgentNew , List<aa_Agent_Report__c>listAgentOld){
        String STATUS_VALUE_TO_POST_ON = 'Published (Public)';
        
        map<Id,aa_Agent_Report__c> oldmap = new map<Id,aa_Agent_Report__c>();
        
        for(aa_Agent_Report__c obj : listAgentOld){
            oldmap.put(obj.id,obj);
        }      

        //Set<String> Set_Unilever_Brand=new set<String>();
        Map<String,String> sendTochatterMap= new Map<String,String>();
        for(aa_Agent_Report__c report:listAgentNew){
            if(report.Status__c != oldmap.get(report.Id).Status__c) {
                if(AA_TheAgentSingleExecution.hasAlreadyDone()) {
                    return;
                }
                else {              
                    AA_TheAgentSingleExecution.setAlreadyDone();
                    //go                
                    if (report.Status__c == STATUS_VALUE_TO_POST_ON) {        
                        
                        Map<String,String> map1 = addTosendChatter(report);   
                        sendTochatterMap = map1;            
                      
              
                    }

                }
            } 
          }
          AA_theAgent_ChatterPost_FutureClass.CallSendToChatter(sendTochatterMap);
        
    }
    public static Map<String,String> addTosendChatter(aa_Agent_Report__c report)
    {
                       Map<String,String> sendTochatterMap= new Map<String,String>();
                       // brand
                        if (String.isNotEmpty(report.Competitor_Brand__c)) {
                           sendTochatterMap.put(report.Competitor_Brand__c,JSON.serialize(report));
                        }                        
                       //competitor
                        if (String.isNotEmpty(report.Competitor_Name__c)) {                        
                            sendTochatterMap.put(report.Competitor_Name__c,JSON.serialize(report));
                        }                      
                        //retailer   
                        if (String.isNotEmpty(report.Retailer__c)) {
                            sendTochatterMap.put(report.Retailer__c,JSON.serialize(report));
                        }                        
                        //country
                        if (String.isNotEmpty(report.Country__c)) {
                            sendTochatterMap.put(report.Country__c,JSON.serialize(report));
                        }                        
                        //Unilever_Brand__c
                        if (String.isNotEmpty(report.Agent_App_Unilever_Brand__c)) {
                            sendTochatterMap.put(report.Agent_App_Unilever_Brand__c,JSON.serialize(report));
                        }                                                
                        //Category
                        if (String.isNotEmpty(report.Category__c)) {
                           sendTochatterMap.put(report.Category__c,JSON.serialize(report));
                        }                                                
                        //Topic
                        if (String.isNotEmpty(report.Topic__c)) {
                            sendTochatterMap.put(report.Topic__c,JSON.serialize(report));                   
                        }                                             
                        //Cluster   
                        if(String.isNotEmpty(report.ClusterId__c) && String.isEmpty(report.Country__c)){
                            sendTochatterMap.put(report.ClusterId__c,JSON.serialize(report));                    
                        }   
                        System.debug('Report Details==>'+report);
                        Id rTypeId=report.RecordTypeId;
                        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
                        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
                        Id cReportTypeId = (RT.get('Competitor Report')).getRecordTypeId();
                        
                        if(rTypeId == cReportTypeId && report.status__c =='Published (Public)'){
                                AA_DatabaseServiceUtil.sendToChatter(report.CreatedById,report.CreatedById, report.Report_Title__c, report.id,report.Country__c,report.TF_Mention_User__c);               
                        }
                        //User Name
                       // String CaretedbyName=userInfo.getUserName();
                       // if (String.isNotEmpty(CaretedbyName)) {
                       //     sendTochatterMap.put(userInfo.getUserId(),JSON.serialize(report));
                       // }
                        return sendTochatterMap;
    }
    
  public static void CallDeleteAgentReport(List<aa_Agent_Report__c> reportlist)
  {  
    List<Id> agentReportIDList =  new List<Id>();
    Set<Id> recordTypeIds = new Set<Id>();
    
    for(aa_Agent_Report__c  agentReportObj:reportlist){
        recordTypeIds.add(agentReportObj.RecordTypeId);
    }
    
    List<RecordType> recordtypeNameList = [select name,id from RecordType where id =:recordTypeIds];
    
    for(aa_Agent_Report__c agentReportObj:reportlist){
        
        for(RecordType recordtypeObject:recordtypeNameList ){
              
            if((agentReportObj.Status__c == 'Rejected' && recordtypeObject.name == 'ETS Members Record Type' && agentReportObj.Approve_Reject__c == 'Reject')
                ||
               (agentReportObj.Status__c == 'Rejected' && recordtypeObject.name == 'CI Manger Record type'))
                {
                       agentReportIDList.add(agentReportObj.id);    
                }
        
     }
    
    }
              
          
    List<aa_Agent_Report__c> agentReportNeedToDelete = [select id,name from aa_Agent_Report__c where id = :agentReportIDList];
    

    List<Database.DeleteResult> deletedList = Database.delete(agentReportNeedToDelete);
    for(Database.DeleteResult dr : deletedList) {
        if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
            System.debug('Successfully deleted account with ID: ' + dr.getId());
        }else {
                  // Operation failed, so get all errors               
            for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');                   
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
        }

    }    
    }
    
    Public static void Agent_After_Insert (List<aa_Agent_Report__c> reportlist){
       // aa_Agent_Report__Share is the "Share" table that was created when the
    // Organization Wide Default sharing setting was set to "Private".
    // Allocate storage for a list of aa_Agent_Report__Share records.
    
    List<aa_Agent_Report__Share> contributionShares = new List<aa_Agent_Report__Share>();

    // For each of the Contribution records being inserted, do the following:
    for(aa_Agent_Report__c contribution : reportlist){
    
        // Create a new aa_Agent_Report__Share record to be inserted in to the Contribution_Share table.
        aa_Agent_Report__Share creatorShare = new aa_Agent_Report__Share();
        
        // Populate the aa_Agent_Report__Share record with the ID of the record to be shared.
        creatorShare.ParentId = contribution.Id;
        
        // Set the ID of user being granted access. In this case,
        // we’re setting the Id of the CreatedBy user. This is because OWD
        // is Private and the record may change owner to be reviewed 
        creatorShare.UserOrGroupId = contribution.CreatedById;
        
        // Specify that the Creator should have edit access for
        // this particular Contribution record.
        creatorShare.AccessLevel = 'edit';
        
        // Specify that the reason the Creator can edit the record is
        // because they're the Creator of the record.
        // (Creator_Access__c is the Apex Sharing Reason.)
        creatorShare.RowCause = Schema.aa_Agent_Report__Share.RowCause.Creator_Access__c;

        // Add the new Share record to the list of new Share records.
        contributionShares.add(creatorShare);
    }
    // do the DML to create shares
    if (!contributionShares.isEmpty())
      insert contributionShares;

    // Need to add Error handling code here.
    }
    
    public static void AgentReportRejected_Email (List<aa_Agent_Report__c> OldReport){
    system.debug('Inside AgentReportRejected_Email');
       List<String> ownerIds = new List<String>();
        List<Messaging.SingleEmailMessage> mailList =  new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail ;
        Set<String> agentReportIds = new Set<String>(); 
        
        for(aa_Agent_Report__c AgentReportObj:OldReport){
            ownerIds.add(AgentReportObj.CreatedById);
            agentReportIds.add(AgentReportObj.id);
        }
        
      /* Set<String> processInstanceLst = new Set<String>();
       List<ProcessInstance> ProcessInstanceIdList = [SELECT Id,TargetObjectId FROM ProcessInstance WHERE TargetObjectId  IN: agentReportIds];
       System.debug('ProcessInstanceIdList =====>'+ProcessInstanceIdList);
       
       for(ProcessInstance ProcessObj:ProcessInstanceIdList){
            processInstanceLst.add(ProcessObj.id);
       }
       system.debug('=========>'+processInstanceLst);
       List<ProcessInstanceStep> ProcessInstanceStepList = [SELECT Id,ActorId,ProcessInstanceId ,OriginalActorId,StepStatus,Comments,CreatedById, CreatedDate, ProcessInstance.Status from ProcessInstanceStep WHERE ProcessInstanceId IN:processInstanceLst]; 
       
       System.debug('=======>'+ProcessInstanceStepList);*/
       List<User> userIds = [select id,email,FirstName,LastName,Name from user where id =:ownerIds ];
       system.debug('users last======>'+userIds);
        String CommentsValue;
        system.debug('======>'+userIds);
        for(aa_Agent_Report__c AgentReportObj:OldReport){
            for(User userObj:userIds){
                  if(AgentReportObj.CreatedById == userObj.id && AgentReportObj.Status__c == 'Rejected'){
                    /*   for(ProcessInstance ProcessInstanceObj :ProcessInstanceIdList){
                                system.debug('ProcessInstanceStepList======>'+ProcessInstanceStepList);
                               if(ProcessInstanceObj.TargetObjectId == AgentReportObj.id){
                                   for(ProcessInstanceStep ProcessInstanceStepObj : ProcessInstanceStepList){
                                            
                                                 if(ProcessInstanceStepObj.ProcessInstanceId == ProcessInstanceObj.id){
                                                    system.debug('=======>processInstanceStep====>'+ProcessInstanceStepObj.Comments );
                                                     if(ProcessInstanceStepObj.Comments != null){
                                                         CommentsValue = ProcessInstanceStepObj.Comments;
                                                         system.debug('approval process comment====>'+CommentsValue);
                                                     
                                                     }
                                                     
                                                 }
                                   
                                   
                                   }
                                   
                                                      
                                                     
                               
                               }
                       }*/
                       if(CommentsValue == null){
                        CommentsValue ='Approver Comments : '+ AgentReportObj.Comments__c;
                        system.debug('======>Ets Comment====>'+CommentsValue);
                       }
                        //system.debug('final Comment values=======>'+CommentsValue);
                        //system.debug('<===inside mail send all Condition=======>');
                        mail = new Messaging.SingleEmailMessage();
                        List<String> mailAdd = new List<String>();
                        mailAdd.add(userObj.email);
                        system.debug('mail Address======>'+mailAdd);
                        mail.setToAddresses(mailAdd);
                        //system.debug('======>approvalcomments=====>'+Approval.ApproveComment);
                       
                       
                        mail.setSubject('Sorry, we were unable to publish your competitor report: '+AgentReportObj.Report_Title__c);
                        mail.setPlainTextBody('Dear'+userObj.FirstName+' '+userObj.LastName+','+AA_Constants.NextLineText+
                        'Thank you for your competitor report. However we were unable to publish your report.'
                        +AA_Constants.NextLineText+CommentsValue
                        +AA_Constants.NextLineText+'PS: This is an auto generated mail, please do not reply. If you have any questions, please refer back to your regional Competitor Intelligence manager'
                        +AA_Constants.NextLineText+'Thanks,'+AA_Constants.NextLineText+'Agent App');
                      
                        
                        mail.setHtmlBody('<div style="border:2px solid blue;width:800px"> <img src="https://unilever--chazwa--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000O5Wf&oid=00Dc0000003vcv1&lastMod=1441542616000" width="800px"/><br/><br>'+'<p style="font-family:sans-serif;font-size:14px;margin-left:30px">Sorry, we were unable to publish your competitor report</br></br><span style="font-size:18px;color:#3366CC;font-weight:bold;">'+AgentReportObj.Report_Title__c+'</span> </br></br>Dear&nbsp;<span>'+userObj.Name+',</span><br/><br/>'+
                        'Thank you for your competitor report.&nbsp;However we were unable to publish your report.'+ '<br/><br/>'+
                         +CommentsValue+
                        '<br/><br/>PS: This is an auto generated mail, please do not reply. If you have any questions, please refer back to your regional Competitor Intelligence manager'+
                        '<br/><br/>'+'Thanks,<br/> '+'The agent </br></br></br></br></p></div>');
                         
                         mailList.add(mail);
                        
                         
                  }
            
            }
        
        }
        system.debug('mail===List'+mailList+'size==>'+mailList.size());
        Messaging.sendEmail(mailList);
        //system.debug('======>'+Messaging.sendEmail(mailList));
    }
}