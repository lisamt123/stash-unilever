@isTest
public class IPM_RolloutShare_Test {
    public static IPM_Project__c project;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static map<id,IPM_Project_Rollout__c>NewRollout=new map<id,IPM_Project_Rollout__c>();
    public static IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
    public static IPM_Financial__c finCon=new IPM_Financial__c();
     public static  IPM_Project_Rollout__Share   ipmProRollShare = new  IPM_Project_Rollout__Share();
     
    static void initializeData(){
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
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
        insert proRoll;
      
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User rollu1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        rollu1 = new User(Alias = 'rollu1', Email='rollu1@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='rollu1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='rollu1@testorg4.com', 
        IPM_Category__c = 'rollu1'  , IPM_Brand_Positioning__c= 'rollu1',IPM_Brand_Name__c ='rollu1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        try{
        system.debug('rollu1....'+rollu1 );
        insert rollu1;
        }catch(exception e){
        }
          System.runAs(rollu1) {
                psa.AssigneeId = rollu1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c = rollu1.id ;
        insert ipmProjectResource;
        
       ipmProRollShare.ParentId= proRoll.Id;
       ipmProRollShare.userOrGroupId =  psa.AssigneeId  ;
       ipmProRollShare.accesslevel = 'Edit';
       
    }
 
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPM_RolloutShare ipmRollShare=new IPM_RolloutShare();
        NewRollout.put(proRoll.id,proRoll);
        IPM_Project_Rollout__Share share=new  IPM_Project_Rollout__Share();
        ipmRollShare.Sharerecords(NewRollout);
        ipmRollShare.UpdateSharerecords(NewRollout);
    }
    
}