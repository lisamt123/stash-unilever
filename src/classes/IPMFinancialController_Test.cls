@isTest
public class IPMFinancialController_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static Id currentFinancialId;
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    //public static  List<RolloutWrapper> lstRolloutWrappers=new  List<RolloutWrapper>();
   public static Map<String, IPM_Financial_Year__c> mapFinancialYearRecords=new Map<String, IPM_Financial_Year__c>();
    
   public static String REGIONAL_ROLLOUT_RECORDTYPE;
    public static String LOCAL_ROLLOUT_RECORDTYPE;
    public static String DEFAULT_FINANCIAL_RECORDTYPE;
    public static String CONSOLIDATED_FINANCIAL_RECORDTYPE;
    
    

    static testMethod void initializeData(){
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        insert project;
        
        childProject=new IPM_Project__c();
        childProject.Name='TESTAPPROVERCL_SEAA';
        childProject.IPM_Phase__c='Feasibility';
        childProject.IPM_Complexity__c='Full';
        childProject.IPM_GateKeeping_Model__c='RCLT'; 
        childProject.Sustainability_Period__c='3';
        insert childProject;

        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TESTAPPROVERCL_SEAA';
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
        finCon.Financial_External_ID__c='TESTAPPROVERCL_CONSOLIDATED';
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
        
        currentFinancialId=finDef.Id;
         
        finYear.IPM_Financial__c=finCon.Id;
        finYear.Name='Y0';
        finYear.Year__c='0';
        finYear.Year_Type__c='Innovation';
        insert finYear;  
    }
 
    static testMethod void dotest1(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon=new IPMFinancialController();
        ipmFinCon.sustainabilityPeriod=3;
        ipmFinCon.colSpan=2;
        ipmFinCon.isEditMode=true;
        ipmFinCon.currentFinancialId=finCon.Id;
        ipmFinCon.showTopDownTab=true;
       
        ipmFinCon.volumeUnit='Total Tons';
        ipmFinCon.tabLabelMyView='TOP DOWN';
        ipmFinCon.tabLabelTopDown='TOP DOWN';
        ipmFinCon.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        
        ipmFinCon.changeTabs();
        
        
       
    }
    
    
    static testMethod void dotest2(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon2=new IPMFinancialController();
        
        ipmFinCon2.sustainabilityPeriod=3;
        ipmFinCon2.colSpan=2;
        ipmFinCon2.isEditMode=true;
        ipmFinCon2.currentFinancialId=finCon.Id;
        ipmFinCon2.showTopDownTab=true;
      
        ipmFinCon2.volumeUnit='Total Tons';
        ipmFinCon2.tabLabelMyView='TOP DOWN';
        ipmFinCon2.tabLabelTopDown='TOP DOWN';
        ipmFinCon2.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon2.editFinancials();
        }
        
        
        static testMethod void dotest3(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon3=new IPMFinancialController();
        
        ipmFinCon3.sustainabilityPeriod=3;
        ipmFinCon3.colSpan=2;
        ipmFinCon3.isEditMode=true;
        ipmFinCon3.currentFinancialId=finCon.Id;
        ipmFinCon3.showTopDownTab=true;
      
        ipmFinCon3.volumeUnit='Total Tons';
        ipmFinCon3.tabLabelMyView='TOP DOWN';
        ipmFinCon3.tabLabelTopDown='TOP DOWN';
        ipmFinCon3.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon3.uploadDownloadTemplate();
        
        }
        static testMethod void dotest4(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon4=new IPMFinancialController();
        
        ipmFinCon4.sustainabilityPeriod=3;
        ipmFinCon4.colSpan=2;
        ipmFinCon4.isEditMode=true;
        ipmFinCon4.currentFinancialId=finCon.Id;
        ipmFinCon4.showTopDownTab=true;
      
        ipmFinCon4.volumeUnit='Total Tons';
        ipmFinCon4.tabLabelMyView='TOP DOWN';
        ipmFinCon4.tabLabelTopDown='TOP DOWN';
        ipmFinCon4.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon4.refreshFinancials();
       
        }
        
        static testMethod void dotest5(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon5=new IPMFinancialController();
        
        ipmFinCon5.sustainabilityPeriod=3;
        ipmFinCon5.colSpan=2;
        ipmFinCon5.isEditMode=true;
        ipmFinCon5.currentFinancialId=finCon.Id;
        ipmFinCon5.showTopDownTab=true;
      
        ipmFinCon5.volumeUnit='Total Tons';
        ipmFinCon5.tabLabelMyView='TOP DOWN';
        ipmFinCon5.tabLabelTopDown='TOP DOWN';
        ipmFinCon5.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
       
         ipmFinCon5.saveFinancials();
        }
        
        
         static testMethod void dotest6(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon6=new IPMFinancialController();
        
        ipmFinCon6.sustainabilityPeriod=3;
        ipmFinCon6.colSpan=2;
        ipmFinCon6.isEditMode=true;
        ipmFinCon6.currentFinancialId=finCon.Id;
        ipmFinCon6.showTopDownTab=true;
      
        ipmFinCon6.volumeUnit='Total Tons';
        ipmFinCon6.tabLabelMyView='TOP DOWN';
        ipmFinCon6.tabLabelTopDown='TOP DOWN';
        ipmFinCon6.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
         ipmFinCon6.refreshFromLocal();
       
        }
        
         static testMethod void dotest7(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon7=new IPMFinancialController();
        
        ipmFinCon7.sustainabilityPeriod=3;
        ipmFinCon7.colSpan=2;
        ipmFinCon7.isEditMode=true;
        ipmFinCon7.currentFinancialId=finCon.Id;
        ipmFinCon7.showTopDownTab=true;
      
        ipmFinCon7.volumeUnit='Total Tons';
        ipmFinCon7.tabLabelMyView='TOP DOWN';
        ipmFinCon7.tabLabelTopDown='TOP DOWN';
        ipmFinCon7.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
         ipmFinCon7.refreshFromRegional();
        
        }
        
         static testMethod void dotest8(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPMFinancialController ipmFinCon8=new IPMFinancialController();
        
        ipmFinCon8.sustainabilityPeriod=3;
        ipmFinCon8.colSpan=2;
        ipmFinCon8.isEditMode=true;
        ipmFinCon8.currentFinancialId=finCon.Id;
        ipmFinCon8.showTopDownTab=true;
      
        ipmFinCon8.volumeUnit='Total Tons';
        ipmFinCon8.tabLabelMyView='TOP DOWN';
        ipmFinCon8.tabLabelTopDown='TOP DOWN';
        ipmFinCon8.tabLabelRollup='BOTTOM UP';
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        IPMFinancialController.RolloutWrapper rollWrap=new IPMFinancialController.RolloutWrapper('region',lstFinancial);
         
        }
        
}