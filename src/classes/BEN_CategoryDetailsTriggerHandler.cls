/**********************************************************************
Name: BEN_CategoryDetailsTriggerHandler Copyright © 2016 Salesforce 
======================================================
======================================================
Purpose: This Class is used to perform Approval Process
======================================================
======================================================
History
-------
VERSION     AUTHOR        DATE            DETAIL Description
V1.0         Swathi         20/12/2016    Approval Process for Category Details
***********************************************************************/

public class BEN_CategoryDetailsTriggerHandler{
    
    private static boolean isDone = false;
    public static boolean rejectedRecord = false;
    public static Boolean loginUser = false;
    /*******************************************************************
Purpose: This method is used to perform submit for  Approval process& make the Reject comments require
Parameters: Id,BEN_Category_Details__c
Returns: 
Throws [Exceptions]: 
********************************************************************/  
    public static void SendRecordForApproval(List<BEN_Category_Details__c> categryList, Map<Id,BEN_Category_Details__c> oldMap,Map<Id,BEN_Category_Details__c> newMap){
        if(!isDone){
            loginUser = checkApproverUser();
            System.debug('-------------'+loginUser );
            Map<Id,BEN_Category_Details__c> categoryMap = new Map<Id,BEN_Category_Details__c>([select Id,In_Approval__c,
                                                                                               Product_Category__c,
                                                                                               Product_Category__r.Name,txt_Reason_for_Deletion__c,
                                                                                               CreatedBy.Name,LastModifiedBy.Name
                                                                                               from BEN_Category_Details__c
                                                                                               where Id In :categryList]); 
            
            
            Map<Id,Group> grpMap = new Map<Id,Group>([SELECT Id,DeveloperName,(SELECT Id, UserOrGroupId FROM GroupMembers) FROM Group Where Type='Queue' and Name like 'BEN_%' ]);
           
            /*
Map<Id,BEN_Category_Details__c> firstStepMap = new Map<Id,BEN_Category_Details__c>();
for(BEN_Category_Details__c catgrydtls1 : [select Id,Approval_Status__c from BEN_Category_Details__c where Id IN :oldMap.keySet()]){
if(catgrydtls1.Approval_Status__c=='In First Step') 
firstStepMap.put(catgrydtls1.Id,catgrydtls1);    
}
*/
            
            List<String> idList = new List<String>();
            List<String> usrList = new List<String>();
            
            List<String> mailToAddresses = new List<String>();
            Map<String,BEN_CategoryDetails__c> categoryQueuesMap = BEN_CategoryDetails__c.getAll();
            
            String rejectionComments  =null;
            
            Map<Id, BEN_Category_Details__c> rejectedStatements = new Map<Id, BEN_Category_Details__c>{};
                
                
                //Check current record is going for Submit for Approval from Reject status
                ID CurrentRecord= categryList.get(0).ID;
            
            Set<Id> Ids = oldMap.keyset();
            if(Ids.contains(CurrentRecord)){
                if(((BEN_Category_Details__c)oldMap.get(CurrentRecord)).pkl_Status__c == BEN_ConstantsForBenchmarkingAppClasses.REJECTED){
                    rejectedRecord = true;
                }
            }
            
            
            for(BEN_Category_Details__c  inv: (List<BEN_Category_Details__c>)trigger.new){        
                if (inv.pkl_Status__c == BEN_ConstantsForBenchmarkingAppClasses.REJECTED){
                    rejectedStatements.put(inv.Id, inv); 
                }
            }
            
            if (!rejectedStatements.isEmpty()){
                
                //  Get the most recent approval process instance for the object.
                // If there are some approvals to be reviewed for approval, then
                // get the most recent process instance for each object.
                List<Id> processInstanceIds = new List<Id>{};
                    
                    for (BEN_Category_Details__c invs : [SELECT (SELECT ID
                                                                 FROM ProcessInstances
                                                                 ORDER BY CreatedDate DESC
                                                                 LIMIT 1)
                                                         FROM BEN_Category_Details__c 
                                                         WHERE ID IN :rejectedStatements.keySet()])
                {
                    if(invs.ProcessInstances != null && invs.ProcessInstances.size()>0)
                        processInstanceIds.add(invs.ProcessInstances[0].Id);
                }
                
                // Now that we have the most recent process instances, we can check
                // the most recent process steps for comments. 
                for (ProcessInstance pi : [SELECT TargetObjectId,
                                           (SELECT Id, StepStatus, Comments
                                            FROM Steps
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1 )
                                           FROM ProcessInstance
                                           WHERE Id IN :processInstanceIds
                                           ORDER BY CreatedDate DESC])  
                {     
                    
                    if ((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0)){             
                        rejectedStatements.get(pi.TargetObjectId).addError('Operation Cancelled: Please provide a rejection reason!');
                    }
                    else{
                        rejectionComments = pi.Steps[0].Comments;
                        
                    }
                } 
            }
            
            // this code is for to get GPL ids to sent mail in retest case
            List<String> GPLUserIDs = new List<String>();
            for(Group gr : grpMap.values()){
                if(gr.DeveloperName=='BEN_GPL'){
                    for(GroupMember gm : grpMap.get(gr.Id).GroupMembers){
                        GPLUserIDs.add(gm.UserOrGroupId);            
                    }    
                }
            }
            
            //This for loop is for getting Specific Queues  
            for(BEN_Category_Details__c catgryDtls : categryList){
                
                if(categoryQueuesMap.containsKey(categoryMap.get(catgryDtls.Id).Product_Category__r.Name)){                 
                    idList.add(categoryQueuesMap.get(categoryMap.get(catgryDtls.Id).Product_Category__r.Name).QueueId__c);      
                }
                for(String qID : idList){  
                    if(grpMap.containsKey(qId)){                        
                        for(GroupMember gm : grpMap.get(qId).GroupMembers){
                            usrList.add(gm.UserOrGroupId);            
                        }
                    }
                }
                //This is for checking Mark For Retest
                if(newMap.get(catgryDtls.Id).bln_Flag_for_Retest__c){
                    if(oldMap.get(catgryDtls.Id).bln_Flag_for_Retest__c==false && newMap.get(catgryDtls.Id).bln_Flag_for_Retest__c){
                        usrList.addAll(GPLUserIDs);
                        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();  
                        String body =  'Hi Category Approver/GPL ,<br/><br/>'+        
                            'Test result ' +catgryDtls.Name+ ' : is been pinned for re-test by '+ UserInfo.getFirstName() + ' '+UserInfo.getLastName() +
                            '<br/><br/>'+
                            'You can access the result via the link below;'+
                            '<br/><br/>'+
                            URL.getSalesforceBaseUrl().toExternalForm()+'/'+catgryDtls.Id+
                            '<br/>'+
                            'This is an automatically generated email, please do not reply'+
                            '<br/><br/>Thanks,<br/>'+
                            //newMap.get(catgryDtls.Id).LastModifiedBy.Name;
                            UserInfo.getFirstName() + ' '+UserInfo.getLastName();
                            //catgryDtls.LastModifiedBy.Name;

                        
                        
                        mail.settoAddresses(usrList);
                        mail.setHTMLBody(body);
                        mail.setSubject('Test Pinned for Re-test'); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
                        isDone = true;  
                    }
                }     //This is for checking Mark For Deletion
                else  if (catgryDtls.In_Approval__c && catgryDtls.bln_Mark_for_Deletion__c) {   
                    
                    approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();                    
                    req1.setObjectId(catgryDtls.id); 
                    approval.ProcessResult result = Approval.process(req1);  
                    sendEmail(catgryDtls,usrList,categoryMap);
                    
                    isDone = true; 
                }//This is for calling Approvalprocess and record rejected
                else if (catgryDtls.In_Approval__c && rejectedRecord== true) {   
                    approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Re-submitting request for approval.');
                    req1.setObjectId(catgryDtls.id); 
                    req1.setNextApproverIds(idList);   
                    
                    //if(!Test.isRunningTest())
                    approval.ProcessResult result = Approval.process(req1);   
                    sendEmail(catgryDtls,usrList,categoryMap);
                    
                    isDone = true; 
                } //This is for calling Approvalprocess
                else if (catgryDtls.In_Approval__c) { 
                    approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(catgryDtls.id); 
                    req1.setNextApproverIds(idList);   
                    
                    //if(!Test.isRunningTest())
                    approval.ProcessResult result = Approval.process(req1);   
                    sendEmail(catgryDtls,usrList,categoryMap);
                    isDone = true; 
                }//This step is for sending email to particular Queue if GPL rejects
                else if(catgryDtls.Approval_Status__c == BEN_ConstantsForBenchmarkingAppClasses.INSECONDSTEP && catgryDtls.pkl_Status__c == BEN_ConstantsForBenchmarkingAppClasses.REJECTED){
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();  
                    String body =  'Hi Category Approver,<br/><br/>'+        
                        'Test result ' +catgryDtls.Name+ ' is Rejected by GPL.'+ 
                        'Reason for Rejection indicated '+ rejectionComments  + 
                        '<br/><br/>'+
                        'You can access the result via the link below;'+
                        '<br/><br/>'+
                        URL.getSalesforceBaseUrl().toExternalForm()+'/'+catgryDtls.Id+
                        '<br/>'+
                        'This is an automatically generated email, please do not reply.'+
                        '<br/><br/>Thanks,<br/>'+
                        categoryMap.get(catgryDtls.Id).LastModifiedBy.Name;
                    
                    
                    mail.settoAddresses(usrList);
                    mail.setHTMLBody(body);
                    mail.setSubject('Test Result Rejected by GPL'); 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
                    isDone = true;     
                }
                
            }
        }
    }
    // This method is for sending Emails to GPL for Deletion & for Queues for Approval
    public static void sendEmail (BEN_Category_Details__c catgryDtls,List<String> usrList,Map<Id,BEN_Category_Details__c> categoryMap){
        
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        String body='';
        if (catgryDtls.In_Approval__c && catgryDtls.bln_Mark_for_Deletion__c) {   
            body =  'Hi Category Approver,<br/><br/>'+        
                'Test result ' +catgryDtls.Product_Category__c+ ' : has been marked for deletion. Reason for deletion indicated '+ 
                catgryDtls.txt_Reason_for_Deletion__c +
                '<br/><br/>'+
                'You can access the result via the link below;'+
                '<br/><br/>'+
                URL.getSalesforceBaseUrl().toExternalForm()+'/'+catgryDtls.Id+
                '<br/>'+
                'This is an automatically generated email, please do not reply'+
                '<br/><br/>Thanks,<br/>'+
                categoryMap.get(catgryDtls.Id).LastModifiedBy.Name;
                
              mail.setSubject('Test Result Submitted For Deletion');
            
            
        }else if(rejectedRecord == true){
            body =  'Hi Category Approver,<br/><br/>'+        
                'Test result ' +catgryDtls.Name+ ' is Re-submitted for your approval.'+ 
                '<br/><br/>'+
                'You can access the result via the link below;'+
                '<br/><br/>'+
                URL.getSalesforceBaseUrl().toExternalForm()+'/'+catgryDtls.Id+
                '<br/>'+
                'This is an automatically generated email, please do not reply.'+
                '<br/><br/>Thanks,<br/>'+
                categoryMap.get(catgryDtls.Id).CreatedBy.Name;
            
            mail.setSubject('Test Result Re-Submitted For Approval');
            
        }
        else{                    
            body =  'Hi Category Approver,<br/><br/>'+        
                'Test result ' +catgryDtls.Name+ ' is submitted for your approval.'+ 
                '<br/><br/>'+
                'You can access the result via the link below;'+
                '<br/><br/>'+
               
                URL.getSalesforceBaseUrl().toExternalForm()+'/'+catgryDtls.Id+ 
                
                '<br/>'+
              
                'This is an automatically generated email, please do not reply.'+
                '<br/><br/>Thanks,<br/>'+
                categoryMap.get(catgryDtls.Id).CreatedBy.Name;
            
            mail.setSubject('Test Result Submitted For Approval');
            
            
            
        }
        
        
        mail.settoAddresses(usrList);
        mail.setHTMLBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
        
    }    
    
    public static boolean checkApproverUser(){
         
            String loginUserID = UserInfo.getUserId();
            Boolean user = false;
            
            Id users_Id = ID.valueOf(loginUserID);
            User ApprovalSubUser = [Select Id, UserName from User where ID=:users_Id];
            List< PermissionSet>  permSets = [Select ID, Name from PermissionSet where Name Like '%Approver%'];
            List<PermissionSetAssignment> permsAssigns = [SELECT Id, AssigneeId, PermissionSet.Name FROM PermissionSetAssignment WHERE PermissionSetId IN :permSets];
            for(PermissionSetAssignment psa : permsAssigns){
                if(psa.AssigneeId == ApprovalSubUser.ID){
                    user = true;  break;
                }  
            }
        return user;
    }
    
    
    
    
    
}