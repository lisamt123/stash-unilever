/*
   Class Name              : CORE_CA_ReminderAlert
   Date                    : 17/09/2014
   Requirement/Project Name: Chatter Approvals
   Requirement/Description : Send the reminder alert(Chatter notification) to the approver.
       Reminder should be sent on the day depending on.
       1. Ariba: 'Reminder_Alert_Days__c' field of the Chatter approval object.
       2. GTES : 'Core_CA_GTES_ReminderDays__c' custom setting.
*/

global class CORE_CA_ReminderAlert_Batch implements Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC){
        // Retrive all the records which are not 'approved' or 'rejected' from the Interested Party object.
        return Database.getQueryLocator('SELECT Id,Source_System__c,Interested_Party__c,Approval_Header__c,CreatedDate,Is_Active__c  FROM Core_Approver_Details__c WHERE Status__c != \'Approved\' AND Status__c != \'Rejected\' AND Action__c !=\'APPR\'AND Action__c !=\'REJC\' AND Role__c = \'APP\' ');
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
            List<Core_Approval_Header__c> lstApprovalHeader = [Select Id,Reminder_Alert_Days__c,Name,Status__c,Fully_Approved__c from Core_Approval_Header__c where id =: approverDetail.Approval_Header__c];  
            
            if(approverDetail.Interested_Party__c != null ){          
                
                //Send reminder alert to ariba system
                if(approverDetail.Source_System__c == 'Ariba' && lstApprovalHeader[0].Status__c =='Submitted' && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == 'Yes' && approverDetail.Is_Active__c == true){ 
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
                if(approverDetail.Source_System__c == 'GTES' && CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c == 'Yes' && lstApprovalHeader[0].Fully_Approved__c == false ){ 
                    intReminderAlertDays = integer.valueOf(CORE_Chatter_Approval__c.getinstance('GTES').ReminderAlertDays__c);                   
                    if(intReminderAlertDays == approverDetail.CreatedDate.date().daysBetween(System.now().date())){
                         strBody = CORE_Chatter_Approval__c.getinstance('GTES-ApprovalOverdue').Text_Value__c;
                         strBody = strBody.replace('XXX',lstApprovalHeader[0].Name);
                         strBody = strBody.replace('YYY',mapUser.get(approverDetail.Interested_Party__c).Name);                      
                        feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                            LinkURL =baseUrl+'/'+lstApprovalHeader[0].Id , Title =lstApprovalHeader[0].Name, CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c )); 
                        /*feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = strBody , ParentId = approverDetail.Approval_Header__c,
                                                            LinkURL =baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+lstApprovalHeader[0].Id+'&ipId='+approverDetail.Id , Title =lstApprovalHeader[0].Name, CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c ));*/
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