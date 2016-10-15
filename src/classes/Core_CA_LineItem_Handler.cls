/*
  Class Name: Core_CA_LineItem_Handler
  Author : Mindtree
  Date: 15 March 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: This is a handler class which executes from trigger, This class is mainly used to
                           1. Assign Record type for LineItem record.
                           
*/
public class Core_CA_LineItem_Handler implements ITrigger{
    
    //SOQL queries to retrive the recordtype for Lineitem object. 
    List<RecordType> aribaRecordType  = [SELECT Id FROM RecordType where Name ='Ariba' AND SobjectType = 'Core_Approval_Details__c'];
    List<RecordType> gtesRecordType   = [SELECT Id FROM RecordType where Name ='GTES' AND SobjectType = 'Core_Approval_Details__c'];
    List<RecordType> invoiceRecordType =[SELECT Id FROM RecordType where Name ='Invoice' AND SobjectType = 'Core_Approval_Details__c'];

    public void beforeInsert(SObject so){    
        // Cast the SObject to an Account
        Core_Approval_Details__c a = (Core_Approval_Details__c)so;
     
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
    public void bulkBefore(){ System.debug('Inside bulkBefore');}
    public void bulkAfter(){ System.debug('Inside bulkBefore');}
    //public void beforeInsert(SObject so){}
    public void beforeUpdate(SObject oldSo,SObject so){System.debug('Inside beforeUpdate');}
    public void beforeDelete(SObject so){System.debug('Inside beforeDelete');}
    public void afterInsert(SObject so){System.debug('Inside afterInsert');}
    public void afterUpdate(SObject oldSo,SObject so){System.debug('Inside afterUpdate');}
    public void afterDelete(SObject so){System.debug('Inside afterDelete');}
    public void andFinally(){System.debug('Inside andFinally');}
}