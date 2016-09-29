/*
   Class Name               : CORE_CA_Delete_Fullyapproved_Batch
   Date                     : 07/07/2015
   Requirement/Project Name : Chatter Approvals
   Requirement/Description  : Delete the purchase request or expense which are already fully approved and not modified within last 30 days.
                             
*/

global with sharing class CORE_CA_Delete_Fullyapproved_Batch implements Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC){
        date dt = system.today().addDays(-Integer.valueof(CORE_Chatter_Approval__c.getInstance('FullyApproved_deletePost_ChatterGroup').ReminderAlertDays__c));
        return Database.getQueryLocator('SELECT Id FROM Core_Approval_Header__c WHERE LastModifiedDate <= :dt LIMIT 125');
    }

    global void execute(Database.BatchableContext BC,List<sObject> scope){  
    
        String strName='';
        String strNextLine='\n';
        String strMsg;
        
        String strGroupIds= CORE_Chatter_Approval__c.getInstance('FullyApproved_deletePost_ChatterGroup').Text_Value__c;
        
    if((CORE_Chatter_Approval__c.getInstance('AribaBatch').Text_Value__c =='Yes'))
    {
        List<Core_Approval_Header__c> lstHeaderAriba =[SELECT Id,LastModifiedDate,External_System_Id__c FROM Core_Approval_Header__c WHERE (Source_System__c = 'Ariba' AND Status__c = 'Fully Approved') AND Id IN :scope];
        strMsg = CORE_Chatter_Approval__c.getInstance('FullyApproved_delete_Msg').Text_Value__c;
        strMsg = strMsg.replace('XXX',string.valueof(System.now()));  
        
        for(Core_Approval_Header__c header:lstHeaderAriba){
            
            strName = strName+header.External_System_Id__c+strNextLine; 
        }
        strMsg = strMsg+strName;
        FeedItem fdItemAriba=new FeedItem(Type='TextPost',Body= strMsg,ParentId=strGroupIds);
        
        //Delete header records      
        if(!lstHeaderAriba.isempty())
            Database.delete(lstHeaderAriba);  
        
        //Insert the text post with the list of deleted header record
        if(fdItemAriba != null && !lstHeaderAriba.isempty())
            Database.Insert(fdItemAriba);    
    }
    if((CORE_Chatter_Approval__c.getInstance('GTESBatch').Text_Value__c =='Yes'))
    {
        List<Core_Approval_Header__c> lstHeaderGTES =[SELECT Id,LastModifiedDate,External_System_Id__c FROM Core_Approval_Header__c WHERE (Source_System__c ='GTES'AND Fully_Approved__c = true) AND Id IN :scope]; 
        strMsg = CORE_Chatter_Approval__c.getInstance('FullyApproved_delete_Msg').Text_Value__c;
       strMsg = strMsg.replace('XXX',string.valueof(System.now()));  
       
        for(Core_Approval_Header__c header:lstHeaderGTES){
            strName = strName+header.External_System_Id__c+strNextLine; 
        }
        strMsg = strMsg+strName;
        FeedItem fdItemGTES=new FeedItem(Type='TextPost',Body= strMsg,ParentId=strGroupIds);
        
        //Delete header records      
        if(!lstHeaderGTES.isempty())
            Database.delete(lstHeaderGTES);  
        
        //Insert the text post with the list of deleted header record
        if(fdItemGTES != null && !lstHeaderGTES.isempty())
            Database.Insert(fdItemGTES);    
    }
    }

    global void finish(Database.BatchableContext BC){
    	//method is meant to be empty
    }
}