@isTest
public class  IPM_CompanyCard_Test {
    public static IPM_Project__c project;
   
     public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static IPM_Company_Card__c comCard=new IPM_Company_Card__c();
    public static string CCid;
    static testMethod void initializeData(){
        
        
        
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
         project.IPM_Target_Launch_Dates__c=system.today();
        
        insert project;
        
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
       //proRoll.IPM_Regional_PL__c=u.Id;
        insert proRoll;
        
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Company_Card__c' and Name='Regional Company Card'].Id;
        comCard.Name='com';
        comCard.IPM_Managed_Category__c='Savory';
        comCard.IPM_Currency__c='AED';
        comCard.IPM_TxtGeographical_Scope__c='geo';
        comCard.RecordTypeId=strRecordTypeId1; 
        comCard.IPM_Market_Cluster__c='clus';
        comCard.IPM_MCO__c='mco';
        insert comCard;
        CCid=comCard.Id;
        
        
        
    }
 
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPM_Company_Card__c?id='+comCard.Id);
        Test.setCurrentPage(pRef);
         //ApexPages.StandardController sc = new ApexPages.StandardController(IPM_CompanyCard);
        IPM_CompanyCard ipmComCard=new IPM_CompanyCard();
        
        String region=ipmComCard.onRegionSelection();
       String clus=ipmComCard.onUnileverClusterSelection();
        String country=ipmComCard.onCountryClusterSelection();
        ipmComCard.showDropdown();
        ipmComCard.SaveCC();
        }}