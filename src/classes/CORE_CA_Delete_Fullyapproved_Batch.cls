/*
   Class Name               : CORE_CA_Delete_Fullyapproved_Batch
   Date                     : 07/07/2015
   Requirement/Project Name : Chatter Approvals
   Requirement/Description  : Delete the purchase request or expense which are already fully approved and not modified within last 30 days.
                             
*/

global class CORE_CA_Delete_Fullyapproved_Batch implements Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC){
        date dt = system.today().addDays(-Integer.valueof(CORE_Chatter_Approval__c.getInstance('FullyApproved_deletePost_ChatterGroup').ReminderAlertDays__c));
        //Retrive all the records which are 'fully approved' in ariba and GTES.   
        return Database.getQueryLocator('SELECT Id,LastModifiedDate,External_System_Id__c FROM Core_Approval_Header__c WHERE ((Source_System__c = \'Ariba\' AND Status__c = \'Fully Approved\') OR (Source_System__c =\'GTES\'AND Fully_Approved__c = true)) AND LastModifiedDate <= :dt limit 3');
    }

    global void execute(Database.BatchableContext BC,List<sObject> scope){   
        List<Core_Approval_Header__c> lstHeader = scope; 
        String strName='';
        String strNextLine='\n';
        String strMsg = CORE_Chatter_Approval__c.getInstance('FullyApproved_delete_Msg').Text_Value__c;
        strMsg = strMsg.replace('XXX',string.valueof(System.now()));  
        String strGroupIds= CORE_Chatter_Approval__c.getInstance('FullyApproved_deletePost_ChatterGroup').Text_Value__c;
        
        for(Core_Approval_Header__c header:lstHeader){
            strName = strName+header.External_System_Id__c+strNextLine; 
        }
        strMsg = strMsg+strName;
        
        FeedItem fdItem=new FeedItem(Type='TextPost',Body= strMsg,ParentId=strGroupIds);
        
        //Delete header records      
        if(!lstHeader.isempty())
            Database.delete(lstHeader);  
        
        //Insert the text post with the list of deleted header record
        if(fdItem != null)
            Database.Insert(fdItem);    
    }

    global void finish(Database.BatchableContext BC){
    
    }
}