trigger AA_AgentReportRejected_Email on aa_Agent_Report__c (before delete) {
        
        List<String> ownerIds = new List<String>();
        List<Messaging.SingleEmailMessage> mailList =  new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail ;
        Set<String> agentReportIds = new Set<String>(); 
        
        for(aa_Agent_Report__c AgentReportObj:Trigger.old){
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
        for(aa_Agent_Report__c AgentReportObj:Trigger.old){
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
                        mail.setPlainTextBody('Dear'+userObj.FirstName+' '+userObj.LastName+','+'\n\n'+
                        'Thank you for your competitor report. However we were unable to publish your report.'
                        +'\n\n'+CommentsValue
                        +'\n\n'+'PS: This is an auto generated mail, please do not reply. If you have any questions, please refer back to your regional Competitor Intelligence manager'
                        +'\n\n'+'Thanks,'+'\n\n'+'Agent App');
                      
                        
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