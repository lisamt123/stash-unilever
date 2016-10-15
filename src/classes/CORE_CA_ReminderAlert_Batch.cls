/*
   Class Name              : CORE_CA_ReminderAlert
   Date                    : 17/09/2014
   Requirement/Project Name: Chatter Approvals
   Requirement/Description : Send the reminder alert(Chatter notification) to the approver.
       Reminder should be sent on the day depending on.
       1. Ariba: 'Reminder_Alert_Days__c' field of the Chatter approval object.
       2. GTES : 'Core_CA_GTES_ReminderDays__c' custom setting.
*/

global with sharing class CORE_CA_ReminderAlert_Batch implements Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC){
        // Retrive all the records which are not 'approved' or 'rejected' from the Interested Party object.
        return Database.getQueryLocator('SELECT Id,Source_System__c,Interested_Party__c,Approval_Header__c,CreatedDate,Is_Active__c FROM Core_Approver_Details__c WHERE ( Status__c != \'Approved\' AND Status__c != \'Rejected\' AND Action__c !=\'APPR\'AND Action__c !=\'REJC\' AND Role__c = \'APP\' AND (Source_System__c=\'Ariba\' OR Source_System__c=\'GTES\')) OR ( Status__c != \'Approved\' AND Status__c != \'Rejected\' AND Status__c!=\'Rework\' AND Action__c !=\'APPR\' AND Action__c !=\'REJC\' AND Action__c !=\'REWO\' AND (Role__c = \'APP\' OR Role__c = \'END\') AND Source_System__c=\'Clarity\') OR ( Status__c != \'Approved\' AND Status__c != \'Return to AP\' AND Status__c!=\'Query With Vendor\' AND Action__c !=\'APPR\' AND Action__c !=\'REJC\' AND Action__c !=\'QUER\' AND (Role__c = \'APP\') AND Source_System__c=\'Invoice\')' );
    }

    global void execute(Database.BatchableContext BC,List<sObject> scope){   
        List<Core_Approver_Details__c> lstApproverDetail=scope;
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        Decimal intReminderAlertDays;
        String strBody;
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        Set<Id> setUserId = new Set<Id>();
        for(Core_Approver_Details__c approverDetail :lstApproverDetail){
            setUserId.add(approverDetail.Interested_Party__c);
        }
        
        //map of user
        Map<Id,User> mapUser = new Map<Id,User>([Select Name FROM User WHERE IsActive= true and Id IN : setUserId]);
             
        // Loop through the retrived record.
        for(Core_Approver_Details__c approverDetail :lstApproverDetail){
            List<Core_Approval_Header__c> lstApprovalHeader = [Select Id,Reminder_Alert_Days__c,Name,Status__c,Fully_Approved__c,Requested_For_Details__c, Ariba_Company_Code__c from Core_Approval_Header__c where id =: approverDetail.Approval_Header__c];  
            
            if(approverDetail.Interested_Party__c != null ){          
                
                //Send reminder alert to ariba system
                if(approverDetail.Source_System__c == 'Ariba' && lstApprovalHeader[0].Status__c =='Submitted' && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == 'Yes' && approverDetail.Is_Active__c ){ 
                    intReminderAlertDays = lstApprovalHeader[0].Reminder_Alert_Days__c;  
                    if(intReminderAlertDays == approverDetail.CreatedDate.date().daysBetween(System.now().date())){
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ApprovalOverdue').Text_Value__c;
                        strBody = strBody.replace('YYY',lstApprovalHeader[0].Name); 
                        strBody = strBody.replace('XXX',mapUser.get(approverDetail.Interested_Party__c).Name);                  
                       feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                             LinkURL =baseUrl+'/'+lstApprovalHeader[0].Id , Title = lstApprovalHeader[0].Name, CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c ));
                        /* feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                             LinkURL = baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+lstApprovalHeader[0].Id+'&ipId='+approverDetail.Id , Title = lstApprovalHeader[0].Name, CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c )); */
                    }
                }
                
                //Send reminder alert to GTES system
                if(approverDetail.Source_System__c == 'GTES' && CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c == 'Yes' && !lstApprovalHeader[0].Fully_Approved__c  ){ 
                    intReminderAlertDays = integer.valueOf(CORE_Chatter_Approval__c.getinstance('GTES').ReminderAlertDays__c);                   
                    if(intReminderAlertDays == approverDetail.CreatedDate.date().daysBetween(System.now().date())){
                         strBody = CORE_Chatter_Approval__c.getinstance('GTES-ApprovalOverdue').Text_Value__c;
                         strBody = strBody.replace('YYY',lstApprovalHeader[0].Name);
                         strBody = strBody.replace('XXX',mapUser.get(approverDetail.Interested_Party__c).Name);                      
                        feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                            LinkURL =baseUrl+'/'+lstApprovalHeader[0].Id , Title =lstApprovalHeader[0].Name, CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c )); 
                        /*feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                            LinkURL =baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+lstApprovalHeader[0].Id+'&ipId='+approverDetail.Id , Title =lstApprovalHeader[0].Name, CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c ));*/
                    }
                }   
                
                //Send reminder alert to Clarity system
                if(approverDetail.Source_System__c == 'Clarity' && CORE_Chatter_Approval__c.getinstance('Clarity_Notification').Text_Value__c == 'Yes'){ 
                    intReminderAlertDays = integer.valueOf(CORE_Chatter_Approval__c.getinstance('Clarity').ReminderAlertDays__c);                   
                    if(intReminderAlertDays == approverDetail.CreatedDate.date().daysBetween(System.now().date())){
                         strBody = CORE_Chatter_Approval__c.getinstance('Clarity_ApprovalOverdue').Text_Value__c;
                         strBody = strBody.replace('YYY',lstApprovalHeader[0].Name);
                         strBody = strBody.replace('XXX',mapUser.get(approverDetail.Interested_Party__c).Name);                      
                        feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                            LinkURL =baseUrl+'/'+lstApprovalHeader[0].Id , Title =lstApprovalHeader[0].Name, CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c )); 
                    }
                }  
                
                //Send reminder alert to Invoice system
                if(approverDetail.Source_System__c == 'Invoice' && CORE_Chatter_Approval__c.getinstance('Invoice_Notification').Text_Value__c == 'Yes'){ 
                    intReminderAlertDays = integer.valueOf(CORE_Chatter_Approval__c.getinstance('Invoice').ReminderAlertDays__c);                   
                    if(intReminderAlertDays == approverDetail.CreatedDate.date().daysBetween(System.now().date())){
                         strBody = CORE_Chatter_Approval__c.getinstance('Invoice_ApprovalOverdue').Text_Value__c;
                         strBody = strBody.replace('YYY',lstApprovalHeader[0].Requested_For_Details__c);
                         strBody = strBody.replace('XXX',mapUser.get(approverDetail.Interested_Party__c).Name);
                         strBody = strBody.replace('ZZZ',lstApprovalHeader[0].Ariba_Company_Code__c);
                        feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                            LinkURL =baseUrl+'/'+lstApprovalHeader[0].Id , Title =lstApprovalHeader[0].Requested_For_Details__c, CreatedById = CORE_Chatter_Approval__c.getinstance('Invoice').Text_Value__c )); 
                    }
                }                         
            } 
        }            
        
        //Insert the FeedItem. 
        if(!feedItemsToInsert.isEmpty())
            Database.insert(feedItemsToInsert, false);
 
    }

    global void finish(Database.BatchableContext BC){
    
    }
}