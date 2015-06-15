@isTest
public class IPMFinancialWrapper_Test {
public static IPM_Project__c project;
public static IPM_Financial__c financial;
static testMethod void initializeData(){
project=new IPM_Project__c();
financial=new IPM_Financial__c();
project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;

//String strRecordTypeId = [Select Id From RecordType Where SobjectType ='IPM_Financial__c' and Name ='Default'].Id;
//String strRecordTypeId=[select Id from RecordType where SobjectType='IPM_Financial__c' and Name='Default'].Id; 
/*financial.Target_Launch_Date__c=System.today();
financial.RecordTypeId=Schema.SObjectType.IPM_Financial__c.RecordTypeInfosByName.get('Default').RecordTypeId;
financial.Project_Sustainability_Period__c='';
//financial.Parent_Project__c='ROLLUPSUMNOW';
financial.Financial_External_ID__c='ROLLUPSUMNOW_SEAA_CONSOLIDATED';

insert financial;*/
}
 
   static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPMFinancialWrapper?id='+project.Id);
         Test.setCurrentPage(pRef);
         
         IPMFinancialWrapper ipmfinwrp=new IPMFinancialWrapper();
     
         
     }
}