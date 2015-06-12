@isTest
public class IPM_ProjectTriggerHandler_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    
   public static  Map<Id, IPM_Project__c> oldProjectsMap=new  Map<Id, IPM_Project__c>();
   
    static void initializeData(){
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User  u = new User(Alias = 'jtestrx', Email='jtestrr4@testorgx4.com', 
              EmailEncodingKey='UTF-8', LastName='jTestingx4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='jtestrr4@testorgx4.com', 
              IPM_Category__c = 'jtestrx4'  , IPM_Brand_Positioning__c= 'jtestx4',IPM_Brand_Name__c ='jtestrx1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='jtesrxt', isActive =true);
              insert u;
             
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        project.IPM_Target_Launch_Dates__c=system.today();
        project.IPM_Project_Leader__c=u.Id;
        project.IPM_Technical_Project_Leader__c=u.Id;
        project.Deputy_Project_Leader__c=u.Id;
        project.IPM_Project_Gatekeeper__c=u.Id;
        project.IPM_Finance_Member__c=u.Id;
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
        
        
    }
 
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        oldProjectsMap.put(project.Id,project);
        IPM_Project__c[] newProjects=new IPM_Project__c[]{project};
        //IPM_ProjectTriggerHandler ipmProTriHand=new IPM_ProjectTriggerHandler(false);
        //ipmProTriHand.onAfterInsert(newProjects);
        //ipmProTriHand.onAfterUpdate(newProjects,oldProjectsMap);
        
    }
}