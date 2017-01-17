/*
Class Name               : CORE_CA_Delete_Fullyapproved_Batch
Date                     : 07/07/2015
Requirement/Project Name : Chatter Approvals
Requirement/Description  : Delete the purchase request or expense which are already fully approved and not modified within last 30 days.

*/

global with sharing class CORE_CA_Delete_Fullyapproved_Batch implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start (Database.BatchableContext BC){
        date dt = system.today().addDays(-Integer.valueof(CORE_Chatter_Approval__c.getInstance('FullyApproved_deletePost_ChatterGroup').ReminderAlertDays__c));
        return Database.getQueryLocator('SELECT Id FROM Core_Approval_Header__c WHERE LastModifiedDate <= :dt AND Source_System__c In (\'Ariba\',\'GTES\',\'CLM\')');
    }
    
    global void execute(Database.BatchableContext BC,List<sObject> scope){  
        
        String strNameAriba='\n';
        String strNameGtes='\n';
        String strNameClm='\n';
        String strNextLine='\n';
        String strMsg;
        
        strMsg = CORE_Chatter_Approval__c.getInstance('FullyApproved_delete_Msg').Text_Value__c;
        strMsg = strMsg.replace('XXX',string.valueof(System.now()));  
            
        
        String strGroupIds= CORE_Chatter_Approval__c.getInstance('FullyApproved_deletePost_ChatterGroup').Text_Value__c;
        if((CORE_Chatter_Approval__c.getInstance('AribaBatch').Text_Value__c =='Yes'))
        {
            List<Core_Approval_Header__c> lstHeaderAriba =[SELECT Id,LastModifiedDate,External_System_Id__c FROM Core_Approval_Header__c WHERE (Source_System__c = 'Ariba' AND Status__c = 'Fully Approved') AND Id IN :scope];
            
            for(Core_Approval_Header__c header:lstHeaderAriba){
                strNameAriba = strNameAriba+header.External_System_Id__c+strNextLine; 
            }
            strMsg = strMsg+strNameAriba;
            
            //Delete header records      
            if(!lstHeaderAriba.isempty())
            {
                Database.delete(lstHeaderAriba); 
                }
                   
                
              
        }
        if((CORE_Chatter_Approval__c.getInstance('GTESBatch').Text_Value__c =='Yes'))
        {
            List<Core_Approval_Header__c> lstHeaderGTES =[SELECT Id,LastModifiedDate,External_System_Id__c FROM Core_Approval_Header__c WHERE (Source_System__c ='GTES'AND Fully_Approved__c = true) AND Id IN :scope]; 
            
            for(Core_Approval_Header__c header:lstHeaderGTES){
                strNameGtes = strNameGtes+header.External_System_Id__c+strNextLine; 
            }
            strMsg = strMsg+strNameGtes;
            
            //Delete header records      
            if(!lstHeaderGTES.isempty())
            {
                Database.delete(lstHeaderGTES); 
                }
                
            
        }
        if((CORE_Chatter_Approval__c.getInstance('CLMBatch').Text_Value__c =='Yes'))
        {
            List<Core_Approval_Header__c> lstHeaderCLM =[SELECT Id,LastModifiedDate,External_System_Id__c FROM Core_Approval_Header__c WHERE (Source_System__c ='CLM'AND Fully_Approved__c = true) AND Id IN :scope]; 
            
            for(Core_Approval_Header__c header:lstHeaderCLM){
                strNameClm = strNameClm+header.External_System_Id__c+strNextLine; 
            }
            strMsg = strMsg+strNameClm;
            
            //Delete header records      
            if(!lstHeaderCLM.isempty())
            {
                Database.delete(lstHeaderCLM);  
                }
            
            
            
        }
        //Insert the text post with the list of deleted header record
        FeedItem fdItem=new FeedItem(Type='TextPost',Body= strMsg,ParentId=strGroupIds);
        if(fdItem != null)
        {
            Database.Insert(fdItem);
            }
                    
                
    }
    
    global void finish(Database.BatchableContext BC){
        //method is meant to be empty
    }
}