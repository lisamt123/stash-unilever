/*
  Class Name: Core_CA_LineItem_Handler
  Author : Mindtree
  Date: 15 March 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: This is a handler class which executes from trigger, This class is mainly used to
                           1. Assign Record type for LineItem record.
                           
*/
public class Core_CA_LineItem_Handler implements ITrigger{

    public void beforeInsert(SObject so){
        
        // Cast the SObject to an Account
        Core_Approval_Details__c a = (Core_Approval_Details__c)so;
       
        List<RecordType> aribaRecordType  = [SELECT Id FROM RecordType where Name ='Ariba' AND SobjectType = 'Core_Approval_Details__c'];
        List<RecordType> gtesRecordType   = [SELECT Id FROM RecordType where Name ='GTES' AND SobjectType = 'Core_Approval_Details__c'];
        List<RecordType> invoiceRecordType =[SELECT Id FROM RecordType where Name ='Invoice' AND SobjectType = 'Core_Approval_Details__c'];
        
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
           //Updating Record type for Invoice
           else if(a.Source_System__c == 'Invoice'){
               a.Name = a.Expense_Type__c;
               a.RecordTypeId = invoiceRecordType[0].Id;
           }    
    }
    public void bulkBefore(){}
    public void bulkAfter(){}
  //public void beforeInsert(SObject so){}
    public void beforeUpdate(SObject oldSo,SObject so){}
    public void beforeDelete(SObject so){}
    public void afterInsert(SObject so){}
    public void afterUpdate(SObject oldSo,SObject so){}
    public void afterDelete(SObject so){}
    public void andFinally(){}
}