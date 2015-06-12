@isTest
public class IPMFinancialYearTriggerHandler_Test {
public static IPM_Project__c project;
public static IPM_Financial__c finCon=new IPM_Financial__c();
public static IPM_Financial__c finDef=new IPM_Financial__c();
 public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
public static Map<Id, IPM_Financial_Year__c> mapNewFinancials=new Map<Id, IPM_Financial_Year__c>();
public static Map<Id, IPM_Financial_Year__c> mapOldFinancials=new Map<Id, IPM_Financial_Year__c>();
//public static Map<String, IPM_Financial_Year__c> mapFinancialYears=new Map<String, IPM_Financial_Year__c>();
public static ipmFinancialWrapper financialsInnovation;
public static  ipmFinancialWrapper financialsCalendar;
public static String volumeUnit;
public static Id currentFinancialId;
public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
public static String VOLUME_UNIT_TONS = 'Total Tons';
public static String DEFAULT_FINANCIAL_RECORDTYPE;
  public static String CONSOLIDATED_FINANCIAL_RECORDTYPE;
public static Map<String, List<IPM_Financial__c>> mapAllConsolidatedFinancials;
public static Map<String, IPM_Financial_Year__c> mapUpdateConsolidatedFinancialYears;
public static Map<String, IPM_Financial_Year__c> mapAllFinancialYears;
public static IPM_Financial_Year__c financialYear=new IPM_Financial_Year__c();

//lstInsertFinancialYears.add();
static testMethod void initializeData(){
project=new IPM_Project__c();

project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
project.Sustainability_Period__c='3';
project.IPMProject_Span__c='Global';
insert project;

String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TEST FINANCE D_EUR';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        //proRoll.Project_Sustainability_Period__c='5';
        proRoll.IPM_Project__c=project.Id;
        proRoll.Market_Cluster_Name__c='market';
        proRoll.MCO_Name__c='mco';
        proRoll.IPM_Status__c='Leader';
        proRoll.Market_Cluster__c='cluster';
      
        proRoll.Local_Project__c=project.Id;
        proRoll.IPM_Project__c=project.Id;
       // proRoll.Project_Span__c='Global';
        //proRoll.Project_Sustainability_Period__c='5';
        proRoll.Regional_Project__c=project.Id;
        proRoll.IPM_Rollout_Project__c='TEST FINANCE D_EUR';
        proRoll.Name='TEST FINANCE D_EUR';
        insert proRoll;
        
        
        
        
        
         
         
         
         String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.Volume_Unit__c='Total Tons';
        finCon.Financial_External_ID__c='TESTAPPROVERCL4_CONSOLIDATED';
        finCon.Target_Launch_Date__c=System.today();
        finCon.Status__c='Not Started';
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Charter_Approved__c=true;
        finCon.Contract_Approved__c=true;
        finCon.MD_Approved__c=true;
        finCon.MD_Approved__c=true;
        finCon.Copy_Global_to_Local__c=true;
        finCon.Copy_Global_to_Regional__c=true;
        finCon.Copy_Local_to_Regional__c=true;
        finCon.Copy_Regional_to_Local__c=true;
        insert finCon;
         
         
         
          /*String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.Volume_Unit__c='Total Tons';
        finDef.Financial_External_ID__c='external11';
        finDef.Target_Launch_Date__c=System.today();
        finDef.Status__c='Not Started';
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        //finDef.Global_Project_Id__c=project.Id;
        //finDef.Local_Project__c=project.Id;
        //finDef.Regional_Project__c=project.Id;
        insert finDef;*/
         
        // DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
         CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
         
         
         
        finYear.IPM_Financial__c=finCon.Id;
         finYear.Name='Y0';
         // finYear.Global_Project_Id__c='a0QL0000002GBwD';
           //finYear.Regional_External_Id__c='Test1';
            //finYear.Financial_RecordtypeId__c='012L00000000goT';
             //finYear.Financial_External_Id__c='Tes1_CONSOLIDATED';
              finYear.Year__c='0';
               finYear.Year_Type__c='Innovation';
               finCon.Charter_Approved__c=true;
        finYear.Contract_Approved__c=true;
        finYear.MD_Approved__c=true;
        finYear.MD_Approved__c=true;
        finYear.Copy_Global_to_Local__c=true;
        finYear.Copy_Global_to_Regional__c=true;
        finYear.Copy_Local_to_Regional__c=true;
        finYear.Copy_Regional_to_Local__c=true;
        //finYear.Volume_Unit_Global__c='VOLUME_UNIT_TONS';
      // finYear.Volume_Unit_Local__c='VOLUME_UNIT_TONS';
        //finYear.Volume_Unit_Regional__c='VOLUME_UNIT_TONS';
                
                    
         insert finYear;
         
         financialYear=finYear;


}
 
  static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
          Test.setCurrentPage(pRef);
          
         IPMFinancialYearTriggerHandler ipmFinCon=new IPMFinancialYearTriggerHandler();
      lstFinancial.add(finCon);
      mapNewFinancials.put(finYear.Id,finYear);
      mapOldFinancials.put(finYear.Id,finYear);
      //for(String s:lstFinancial){
    //  mapAllConsolidatedFinancials('str',lstFinancial);
      //}
      //mapUpdateConsolidatedFinancialYears.put('str',finYear);
      //mapAllFinancialYears.put('str',finYear);
         ipmFinCon.onAfterUpdate(mapNewFinancials,mapOldFinancials);
         
         
     
         
     }
}