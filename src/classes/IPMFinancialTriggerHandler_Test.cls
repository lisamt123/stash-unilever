@isTest
public class IPMFinancialTriggerHandler_Test {
public static IPM_Project__c project;
public static IPM_Financial__c fin=new IPM_Financial__c();
public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
 public static IPM_Project_Rollout__c proRoll;
public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
public static Map<Id, IPM_Financial__c> mapNewFinancials=new Map<Id, IPM_Financial__c>();
public static Map<Id, IPM_Financial__c> mapOldFinancials=new Map<Id, IPM_Financial__c>();

//lstInsertFinancialYears.add();
static testMethod void initializeData(){
project=new IPM_Project__c();

project.Name='TestComments1';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
project.Sustainability_Period__c='3';
insert project;

String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TEST FINANCE D_EUR';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        proRoll.IPM_Project__c=project.Id;
        insert proRoll;
        
        
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        fin.RecordTypeId=strRecordTypeId1;
        fin.Volume_Unit__c='Total Tons';
        fin.Financial_External_ID__c='Tes1_CONSOLIDATED';
        fin.Target_Launch_Date__c=System.today();
        fin.Status__c='Not Started';
        fin.IPM_Project_Rollout__c=proRoll.Id;
        fin.Parent_Project__c=project.Id;
        fin.Project_Sustainability_Period__c='3';
        
        
         fin.IPM_Project_Rollout__c=proRoll.Id;
         insert fin;
         
         
         finYear.IPM_Financial__c=fin.Id;
         finYear.Name='Y0';
         finYear.Year__c='0';
         finYear.Year_Type__c='Innovation';
                
                    
         insert finYear;

}
 
  static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPMFinancialTriggerHandler?id='+project.Id);
         Test.setCurrentPage(pRef);
         
      
         IPMFinancialTriggerHandler ipmFinTrgHand=new IPMFinancialTriggerHandler();
          mapNewFinancials.put(fin.Id,fin);
          mapOldFinancials.put(fin.Id,fin);
     ipmFinTrgHand.onAfterInsert(lstFinancial);
     
     ipmFinTrgHand.onAfterUpdate(mapNewFinancials,mapOldFinancials);
    
         
     }
}