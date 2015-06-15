@isTest
public class  IPM_CreateRolloutProjects_Test {
    public static IPM_Project__c project;
   
     public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static IPM_Company_Card__c comCard=new IPM_Company_Card__c();
    public static string CCid;
    public static List<IPM_Project_Document__c> ProjDocList=new List<IPM_Project_Document__c>();
    public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
    
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
      
        insert proRoll;
        
        proDoc.Name='TESTAPPROVERCL-Charter';
       proDoc.IPM_Project__c=project.Id;
       //proDoc.IPM_Project_Template__c=proTemp.Id;
        proDoc.IPM_Document_Status__c='Approved';
        proDoc.IPM_GateDocuments__c='Charter';
        //proDoc.IPM_Project_Complexity__c='Full';
        proDoc.IPM_Approval_Date__c=System.today();
        proDoc.IPM_Approved_Comments__c='RCLT will work';
        
       // proDoc.Name='doc';
        insert proDoc;
        
        
        
        
        
    }
 
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPM_CreateRolloutProjects crtRollPro=new IPM_CreateRolloutProjects();
        ProjDocList.add(proDoc);
        IPM_CreateRolloutProjects.createProjects(ProjDocList);
       
        }}