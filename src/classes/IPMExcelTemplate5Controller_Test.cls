@isTest
public class  IPMExcelTemplate5Controller_Test {
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
        /* Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User u = new User(Alias = 'newUser1', Email='newuser@testorg7.com', 
             EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg7.com', 
             IPM_Category__c = 'test1'  , IPM_Brand_Positioning__c= 'test10',IPM_Brand_Name__c ='test10',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;*/
        
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL4';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
         project.IPM_Target_Launch_Dates__c=system.today();
        //project.IPM_Project_Leader__c=u.Id;
        //project.IPM_Technical_Project_Leader__c=u.Id;
        //project.Deputy_Project_Leader__c=u.Id;
        //project.IPM_Project_Gatekeeper__c=u.Id;
        //project.IPM_Finance_Member__c=u.Id;
        insert project;
        
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TESTAPPROVERCL4_SEAA';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        proRoll.Market_Cluster_Name__c='SEAA';
        proRoll.Market_Cluster__c='GEO0022';
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
      // proRoll.IPM_Regional_PL__c=u.Id;
        insert proRoll;
        
        
      
        
        
   
         /*String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.Volume_Unit_Global__c='Total Tons';
        //finCon.Volume_Unit__c='Total Tons';
        finCon.Financial_External_ID__c='TESTAPPROVERCL4_CONSOLIDATED';
        finCon.Target_Launch_Date__c=System.today();
        finCon.Status__c='Not Started';
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        insert finCon;*/
         
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.Volume_Unit_Local__c='Total Tons';
        finDef.Financial_External_ID__c='TESTAPPROVERCL4_CONSOLIDATED';
        finDef.Target_Launch_Date__c=System.today();
        finDef.Status__c='Not Started';
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        //finDef.Global_Project_Id__c=project.Id;
        finDef.Local_Project__c=project.Id;
        finDef.Regional_Project__c=project.Id;
        insert finDef;
        
          /*String strRecordTypeId3=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
         
        finFile.RecordTypeId=strRecordTypeId3;
        finFile.Name='file';
        finFile.IPM_Project__c=project.Id;
        
        insert finFile; */
        
        
        finYear.IPM_Financial__c=finDef.Id;
         finYear.Name='Y0';
        
              finYear.Year__c='0';
               finYear.Year_Type__c='Innovation';
               
        finYear.Contract_Approved__c=true;
        finYear.MD_Approved__c=true;
        finYear.MD_Approved__c=true;
        finYear.Copy_Global_to_Local__c=true;
        finYear.Copy_Global_to_Regional__c=true;
        finYear.Copy_Local_to_Regional__c=true;
        finYear.Copy_Regional_to_Local__c=true;
                
                    
         insert finYear;
        
       }
       static testMethod void dotest(){
     
       Test.startTest();
       
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        //project.IPMProject_Span__c='Global';
        //update project;
        IPMExcelTemplate5Controller excel51=new IPMExcelTemplate5Controller();
        //finYear.Year_Type__c='Calendar';
        //update finYear;
        //IPMExcelTemplate5Controller excel52=new IPMExcelTemplate5Controller();
       // project.IPMProject_Span__c='Local';
        //update project;
       // IPMExcelTemplate5Controller excel53=new IPMExcelTemplate5Controller();
        //project.IPMProject_Span__c='Regional';
        //update project;
        //IPMExcelTemplate5Controller excel54=new IPMExcelTemplate5Controller();
        IPMExcelTemplate5Controller.FinancialWrapper finWrp=new IPMExcelTemplate5Controller.FinancialWrapper();
        IPMExcelTemplate5Controller.YearTypeWrapper yrWrp=new IPMExcelTemplate5Controller.YearTypeWrapper();
        IPMExcelTemplate5Controller.RowWrapper RowWrp=new IPMExcelTemplate5Controller.RowWrapper();
        Test.stopTest();
        
        }}