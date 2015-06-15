@isTest(SeeAllData=true)
public class  IPM_FinancialFileShare_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static IPM_Project_Resource__c proRes=new IPM_Project_Resource__c();
    public static IPM_Company_Card__c comCard=new IPM_Company_Card__c(); 
    public static IPM_Financial_File__Share finFilShare=new IPM_Financial_File__Share();
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Financial_File__c finFile=new IPM_Financial_File__c();
    public static map<id,IPM_Financial_File__c>NewFin=new map<id,IPM_Financial_File__c>();
    public static IPM_Financial_File__Share   ipmFinFileShare = new IPM_Financial_File__Share();
    public static List<IPM_Financial_File__Share> listipmFinFileShare  = new List<IPM_Financial_File__Share>();
    public static List<IPM_Project__c> prolst=new List<IPM_Project__c>();
    
    static testMethod void initializeData(){
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        u1 = new User(Alias = 'raj18', Email='raj18@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='raj18@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        String strRecordTypeId4=[Select Id From RecordType Where SobjectType='IPM_Company_Card__c' and Name='Regional Company Card'].Id;
           comCard.Name='a';
           comCard.IPM_Currency__c='RSD';
           
           insert comCard;
            
            
        
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL1';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        project.IPM_Company_Card__c=comCard.Id;
        
        insert project;
        
        childProject=new IPM_Project__c();
        childProject.Name='TESTAPPROVERCL_SEAA';
        childProject.IPM_Phase__c='Feasibility';
        childProject.IPM_Complexity__c='Full';
        childProject.IPM_GateKeeping_Model__c='RCLT'; 
        childProject.Sustainability_Period__c='3';
        insert childProject;
        
        prolst.add(project);

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
        finCon.Financial_External_ID__c='TESTAPPROVERCL1_CONSOLIDATED';
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
        
       
           
         
        IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c = psa.AssigneeId;
        insert ipmProjectResource;
           
           ipmFinFileShare.ParentId= finFile.Id;
        ipmFinFileShare.userOrGroupId = psa.AssigneeId ;
       ipmFinFileShare.accesslevel = 'Edit';
        
        listipmFinFileShare.add(ipmFinFileShare );
        insert listipmFinFileShare;
        
        
       project.IPM_Technical_Project_Leader__c=u1.Id;
        project.IPM_Project_Leader__c=u1.Id;
        project.Deputy_Project_Leader__c=u1.Id;
        project.IPM_Project_Gatekeeper__c=u1.Id;
        update project;
        
        
           
    }
 
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        NewFin.put(finFile.Id,finFile);
        IPM_FinancialFileShare ipmFinFilShare=new IPM_FinancialFileShare();
        ipmFinFilShare.Sharerecords(NewFin);
    }
}