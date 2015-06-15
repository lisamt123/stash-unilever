/*
   Class Name               : CORE_CA_UnfollowUser_Batch
   Date                     : 12/02/2015
   Requirement/Project Name : Chatter Approvals
   Requirement/Description  : Unfollow the user depending on following condition.
                              GTES  - Ledger_Extract__c has a value i.e. not blank or null and Last_Modified_Date is within the last 24 hours.
                              Ariba - Status__c = ‘Fully Approved’ and Last_Modified_Date is within the last 24 hours. 

*/

global class CORE_CA_UnfollowUser_Batch implements Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC){
        //Retrive all the records which are 'fully approved' in ariba and 'sent for payment' in GTES.   
        return Database.getQueryLocator('SELECT Id,LastModifiedDate  FROM Core_Approval_Header__c WHERE (Source_System__c = \'Ariba\' AND Status__c = \'Fully Approved\') OR (Source_System__c =\'GTES\'AND Ledger_Extract__c != null)  ');
    }

    global void execute(Database.BatchableContext BC,List<sObject> scope){   
        List<Core_Approval_Header__c> lstHeader = scope; 
        List<EntitySubscription> lstEntitySubDelete= new List<EntitySubscription>(); 
        //Retrive the unfollow hours value from custom setting.
        Integer intUnfollowHours = integer.valueOf(CORE_Chatter_Approval__c.getinstance('Unfollow_hours').ReminderAlertDays__c);  
       
        //loop through the header record
        for(Core_Approval_Header__c headerRec : lstHeader){  
        	system.debug('headerRec.LastModifiedDate'+headerRec.LastModifiedDate);
            //Check whether the record is last modified between the time mentioned in custom setting.
            if(headerRec.LastModifiedDate > System.now().addHours(-(intUnfollowHours))){
            	system.debug('headerRec.LastModifiedDate'+headerRec.LastModifiedDate);
                 List<EntitySubscription> lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE ParentId = :headerRec.Id]; 
                 //Add entity subscription to the list.   
                 if(!lstEntitySubQuery.isempty()) lstEntitySubDelete.addAll(lstEntitySubQuery);           
            }       
        }
        
        //delete entity subscription record
        if(!lstEntitySubDelete.isempty())
            Database.delete(lstEntitySubDelete);
           
    }

    global void finish(Database.BatchableContext BC){
    
    }
}