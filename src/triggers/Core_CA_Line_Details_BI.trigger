/**
* Trigger Name: Core_CA_Line_Details_BI
* Author : Mindtree
* Date: 18 Sept 2014
* Requirement/Project Name: Unilever Salesforce Engagement
* Requirement/Description: Used to update Name with Expense_Type__c field for GTES And
*                          Line_Item_Number__c field for Ariba.
**/

trigger Core_CA_Line_Details_BI on Core_Approval_Details__c (Before Insert) {
    
    if (Trigger.isInsert) {
        List<RecordType> aribaRecordType  = [SELECT Id FROM RecordType where Name ='Ariba' AND SobjectType = 'Core_Approval_Details__c'];
        List<RecordType> gtesRecordType   = [SELECT Id FROM RecordType where Name ='GTES' AND SobjectType = 'Core_Approval_Details__c'];
        //List<RecordType> remedyRecordType = [SELECT Id FROM RecordType where Name ='Remedy' AND SobjectType = 'Core_Approval_Details__c'];
        
        for (Core_Approval_Details__c a : Trigger.new) {
        
        //Fetching Record Type Id for Selected Source System.
            //List<RecordType> recordTypeList = [SELECT Id FROM RecordType where Name =: a.Source_System__c AND SobjectType = 'Core_Approval_Details__c'];            
            //a.RecordType = recordTypeList[0]; 
        
           //Updating Name field with Line Item Number for Ariba.
           if(a.Source_System__c == 'Ariba') {          
               a.Name = '' + a.Line_Item_Number__c;
               a.RecordTypeId = aribaRecordType[0].Id;
           }
           //Updating Name field with Expense Type for GTES.
           else if(a.Source_System__c == 'GTES'){
               if(a.Expense_Type__c != null){
                   if(a.Expense_Type__c.length()>80)
                       a.Name = a.Expense_Type__c.SubString(0,80);
                   else    
                       a.Name = a.Expense_Type__c;  
               }                    
               a.RecordTypeId = gtesRecordType[0].Id;
           }
           //Updating Record type for Remedy
           //else if(a.Source_System__c == 'Remedy'){
               //a.Name = a.Expense_Type__c;
               //a.RecordTypeId = remedyRecordType[0].Id;
           //}    
        }
    }
}