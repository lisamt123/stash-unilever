@isTest
public class  IPMProcessFinancials_Test {
    public static IPM_Project__c project;
   
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
   // public static List<IPM_Financial__c> lstUpsertFinancials = new List<IPM_Financial__c>();
  
    
    
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
        project.Name='TESTAPPROVERCL';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
         project.IPM_Target_Launch_Dates__c=system.today();
        //project.IPM_Project_Leader__c=u.Id;
        //project.IPM_Technical_Project_Leader__c=u.Id;
       // project.Deputy_Project_Leader__c=u.Id;
       // project.IPM_Project_Gatekeeper__c=u.Id;
       // project.IPM_Finance_Member__c=u.Id;
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
        
        
        proTemp.IPM_Template_Complexity__c='Full';
        proTemp.IPM_Category__c='HHC';
        proTemp.IPM_Project__c=project.Id;
        insert proTemp;
        
        
        
    proDoc.Name='TESTAPPROVERCL-Charter';
       proDoc.IPM_Project__c=project.Id;
       proDoc.IPM_Project_Template__c=proTemp.Id;
        proDoc.IPM_Document_Status__c='Approved';
        proDoc.IPM_GateDocuments__c='Charter';
        //proDoc.IPM_Project_Complexity__c='Full';
        proDoc.IPM_Approval_Date__c=System.today();
        proDoc.IPM_Approved_Comments__c='RCLT will work';
        
       // proDoc.Name='doc';
        //insert proDoc;
        setProjectDocumentIds.add(proDoc.Id);
        
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
        
          String strRecordTypeId3=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
         
        finFile.RecordTypeId=strRecordTypeId3;
        finFile.Name='file';
        finFile.IPM_Project__c=project.Id;
        
        insert finFile; 
        
        
        //project.IPM_Project_Name__c;
       
        
        
        
    }
 
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMProcessFinancials?id='+project.Id);
        Test.setCurrentPage(pRef);
      
      setSustainabilityPeriod.add(project.Id+'_3_3');
    setTrimmedProjectIds.add(project.Id);
    setProjectDocumentIds.add(proDoc.Id);
    //lstProjectDocuments.add(proDoc);
   
   //lstUpsertFinancials.add(finCon);
        IPMProcessFinancials ipmProFin=new IPMProcessFinancials();
       IPMProcessFinancials.processDocumentApprovalFinancials(setProjectDocumentIds);
       ipmProFin.updateProjectDocumentFinancials(lstProjectDocuments);
        
        IPMProcessFinancials.processProjectFinancials(setTrimmedProjectIds,setSustainabilityPeriod);
        ipmProFin.updateProjectFinancials(setTrimmedProjectIds,setSustainabilityPeriod);
        //ipmProFin.updateLocalFinancials(localRolloutIDs);
    }
}