@isTest
public class  IPMExcelTemplate3Controller_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_User_Profile__c us=new IPM_User_Profile__c();
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Project_Template__c proTemp=new IPM_Project_Template__c();
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    public static Set<Id> setProjectDocumentIds=new Set<Id>();
    public static List<IPM_Project_Document__c> lstProjectDocuments=new List<IPM_Project_Document__c>();
    public static Set<Id> localRolloutIDs=new Set<Id>();
    //public static Set<String> setTrimmedProjectIds;
    public static Set<String> setSustainabilityPeriod=new Set<String>();
    public static Set<String> setTrimmedProjectIds=new Set<String>();
    //public static Set<String> setSustainabilityPeriod;
    // public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Financial_File__c finFile=new IPM_Financial_File__c();
    public static List<IPM_Financial__c> lstUpsertFinancials = new List<IPM_Financial__c>();
    
    static testMethod void initializeData(){
        
         
        
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL7';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
         project.IPM_Target_Launch_Dates__c=system.today();
        
        
        insert project;
        
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TESTAPPROVERCL7_SEAA';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        proRoll.Market_Cluster_Name__c='SEAA';
        proRoll.Market_Cluster__c='GEO0022';
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
      
        insert proRoll;
        
        
      
        
        
   
         String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.Volume_Unit__c='Total Tons';
        finCon.Financial_External_ID__c='TESTAPPROVERCL7_CONSOLIDATED';
        finCon.Target_Launch_Date__c=System.today();
        finCon.Status__c='Not Started';
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        insert finCon;
         
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.Volume_Unit__c='Total Tons';
        finDef.Financial_External_ID__c='external11';
        finDef.Target_Launch_Date__c=System.today();
        finDef.Status__c='Not Started';
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        insert finDef;
        
          String strRecordTypeId3=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
         
        finFile.RecordTypeId=strRecordTypeId3;
        finFile.Name='file';
        finFile.IPM_Project__c=project.Id;
        
        insert finFile; 
        
        
       }
       static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMExcelTemplate3Controller excel3=new IPMExcelTemplate3Controller();
        IPMExcelTemplate3Controller.FinancialWrapper finWrp=new IPMExcelTemplate3Controller.FinancialWrapper();
        IPMExcelTemplate3Controller.YearTypeWrapper yrWrp=new IPMExcelTemplate3Controller.YearTypeWrapper();
        IPMExcelTemplate3Controller.RowWrapper RowWrp=new IPMExcelTemplate3Controller.RowWrapper();
        
        }}