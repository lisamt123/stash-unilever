/*
   Class Name               : CORE_CA_Delete_Fullyapproved_Batch
   Date                     : 07/07/2015
   Requirement/Project Name : Chatter Approvals
   Requirement/Description  : Delete the purchase request or expense which are already fully approved and not modified within last 30 days.
                             
*/

global class CORE_CA_Delete_Fullyapproved_Batch implements Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC){
        date dt = system.today().addDays(-30);
        //Retrive all the records which are 'fully approved' in ariba and GTES.   
        return Database.getQueryLocator('SELECT Id,LastModifiedDate  FROM Core_Approval_Header__c WHERE ((Source_System__c = \'Ariba\' AND Status__c = \'Fully Approved\') OR (Source_System__c =\'GTES\'AND Fully_Approved__c = true)) AND LastModifiedDate <= :dt limit 1');
    }

    global void execute(Database.BatchableContext BC,List<sObject> scope){   
        List<Core_Approval_Header__c> lstHeader = scope; 
        
        if(!lstHeader.isempty())
            Database.delete(lstHeader);      
    }

    global void finish(Database.BatchableContext BC){
    
    }
}