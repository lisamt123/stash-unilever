@isTest
public class  IPM_FinancialShare_Test {
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
     public static IPM_Company_Card__c comCard=new IPM_Company_Card__c();
       public static IPM_Financial_File__Share   ipmFinFileShare = new IPM_Financial_File__Share();
       public static List<IPM_Financial_File__Share> listipmFinFileShare  = new List<IPM_Financial_File__Share>();
     public static List<IPM_Project__c> prolst=new List<IPM_Project__c>();
    

    static testMethod void initializeData(){
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u1 = new User(Alias = 'fin30', Email='fin30@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='fin20', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='fin30@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        insert project;
        IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c = psa.AssigneeId ;
        insert ipmProjectResource;
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
       // finCon.Volume_Unit__c='Total Tons';
        finCon.Financial_External_ID__c='TESTAPPROVERCL_CONSOLIDATED';
        finCon.Target_Launch_Date__c=System.today();
        finCon.Status__c='Not Started';
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        insert finCon;
         
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef.RecordTypeId=strRecordTypeId2;
       // finDef.Volume_Unit__c='Total Tons';
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
        IPM_FinancialShare fishare=new IPM_FinancialShare();
        map<id,IPM_Financial__c>mpfin=new map<id,IPM_Financial__c>();
        mpfin.put(finCon.id,finCon);
        fishare.Sharerecords(mpfin);
           
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
}