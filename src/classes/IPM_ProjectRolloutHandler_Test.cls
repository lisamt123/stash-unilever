@isTest
public class  IPM_ProjectRolloutHandler_Test {
    public static IPM_Project__c project;
   
   
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static IPM_Project_Rollout__c[] newProjectRollOuts;
    public static Map<Id, IPM_Project_Rollout__c> oldProjectRollOutsMap=new Map<Id, IPM_Project_Rollout__c>();
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
        
     newProjectRollOuts=new IPM_Project_Rollout__c[]{proRoll};
        oldProjectRollOutsMap.put(proRoll.Id,proRoll);
        
        
    }
 
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPM_ProjectRolloutHandler?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPM_ProjectRolloutHandler proRollHand=new IPM_ProjectRolloutHandler(false);
       proRollHand.OnBeforeInsert(newProjectRollOuts);
       proRollHand.OnAfterInsert(newProjectRollOuts);
       proRollHand.OnAfterUpdate(newProjectRollOuts,oldProjectRollOutsMap);
       proRollHand.OnAfterDelete(newProjectRollOuts);
       proRollHand.OnAfterUnDelete(newProjectRollOuts);
       }}