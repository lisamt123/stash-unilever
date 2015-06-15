@isTest
public class  IPM_ChangProjectDocStatusController_Test 
{
    public static IPM_Project__c project;
    public static IPM_Project_Rollout__c projRoll;
    public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
    public static User u;
    //public static User u1;
    static testMethod void initializeData()
    {
       
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u1 = new User(Alias = 'eeekkkb', Email='zstandaarduseryy@testorg145.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4llghue', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='raj21adllbn@testorgdnd.com', 
        IPM_Category__c = 'test4llbnghue'  , IPM_Brand_Positioning__c= 'test4llbnghue',IPM_Brand_Name__c ='test1llbnghue',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='testllbnghu', isActive =true);
        insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        project=new IPM_Project__c();
        project.Name='TESTAPPROVERCL4';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        project.IPM_Target_Launch_Dates__c=system.today();
        project.IPM_IsCompleted__c=true; 
        project.IPM_Project_Gatekeeper__c=u1.Id;
        insert project;
        
        projRoll=new IPM_Project_Rollout__c();
        projRoll.IPM_Project__c=project.ID;
        projRoll.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
        projRoll.IPM_Rollout_Project__c='TestComments_SEAA';
        projRoll.Market_Cluster__c='SEAA';
        projRoll.Target_Launch_Date__c=date.today();
        projRoll.IPM_Regional_PL__c=u1.Id;
        insert projRoll;
        
        IPM_Project_Rollout__Share roll=new IPM_Project_Rollout__Share();
        roll.ParentId= projRoll.Id;
        roll.userOrGroupId = psa.AssigneeId ;
        roll.accesslevel = 'Edit';
        insert roll;
        
        System.debug(project.IPM_Project_Gatekeeper__c+'project.IPM_Project_Gatekeeper__c');
        proDoc.Name='doc';
        proDoc.IPM_Project__c=project.Id;
        proDoc.IPM_GateDocuments__c='Charter';
        proDoc.IPM_Document_Status__c='Stopped';
        proDoc.IPM_Stopped_Date__c=system.today();
        proDoc.IPM_Stopped_Comments__c='comment';
        insert proDoc;
        
        IPM_Project_Document_Section__c projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Gate_Document_Summary__c='dsfadfadsfasaadfdsfadfadfsd';
        projDocSec.IPM_Project_Document__c=proDoc.Id;
        insert projDocSec;
    }
    static testMethod void dotest1()
    {
        Test.startTest();
        initializeData();
        PageReference pRef = new PageReference('/apex/IPM_ChangProjectDocumentStatusController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPM_ChangProjectDocumentStatusController chngPro=new IPM_ChangProjectDocumentStatusController();
        //chngPro.sendEmail();
        //chngPro.submit();
        //chngPro.updateStatus();
        Test.stopTest();
    }
    static testMethod void dotest2()
    {
        Test.startTest();
        initializeData();
        IPM_Project_Document__c projd=[Select Id,IPM_Document_Status__c from IPM_Project_Document__c  where Id=:proDoc.Id For Update];
        projd.IPM_Document_Status__c='Proposed';
        update projd;
        PageReference pRef = new PageReference('/apex/IPM_ChangProjectDocumentStatusController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPM_ChangProjectDocumentStatusController chngPro=new IPM_ChangProjectDocumentStatusController();
        chngPro.sendEmail();
       // chngPro.submit();
        chngPro.updateStatus();
        Test.stopTest();
    }
    static testMethod void dotest3()
    {
        /*
        Test.startTest();
        initializeData();
        project.IPM_Phase__c='Feasibility';
        update project;
        IPM_Project_Document__c projd=[Select Id,IPM_Document_Status__c,IPM_GateDocuments__c from IPM_Project_Document__c  where Id=:proDoc.Id For Update];
        projd.IPM_GateDocuments__c='Contract';
        projd.IPM_Document_Status__c='Approved';
        update projd;
        PageReference pRef = new PageReference('/apex/IPM_ChangProjectDocumentStatusController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPM_ChangProjectDocumentStatusController chngPro=new IPM_ChangProjectDocumentStatusController();
        //chngPro.sendEmail();
        System.debug('project.IPM_Project_Gatekeeper__c'+project.IPM_Project_Gatekeeper__c);
        //chngPro.submit();
        //chngPro.updateStatus();
        Test.stopTest();
        */
        
    }
    
    static testMethod void dotest4()
    {
        Test.startTest();
        initializeData();
        IPM_Project_Document__c projd=[Select Id,IPM_Document_Status__c,IPM_GateDocuments__c,IPM_Postponement_Date__c,IPM_Postponed_Comments__c from IPM_Project_Document__c  where Id=:proDoc.Id For Update];
        projd.IPM_Document_Status__c='Postponed';
        projd.IPM_Postponed_Comments__c='Postponed';
        projd.IPM_Postponement_Date__c=system.today();
        update projd;
        PageReference pRef = new PageReference('/apex/IPM_ChangProjectDocumentStatusController?id='+project.Id);
        Test.setCurrentPage(pRef);
        IPM_ChangProjectDocumentStatusController chngPro=new IPM_ChangProjectDocumentStatusController();
        chngPro.sendEmail();
        chngPro.submit();
        chngPro.updateStatus();
        Test.stopTest();
    }
    public static User  testRunAs() 
    {
        List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg4.com' ];
        u = new User();
        if(usrname== null)
        {
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            u = new User(Alias = 'standt4', Email='standarduser@testorg4.com', 
            EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg4.com', 
            IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
            IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
            insert u;
            System.runAs(u) 
            {
                PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = ps.Id;
                insert psa;
            }
        }
        else 
        {
            if(usrname.size()>0)
            {
                u = [SELECT Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName, IPM_Category__c ,IPM_Brand_Positioning__c, IPM_Brand_Name__c ,IPM_Role__c , IPM_Sub_Category__c    from User where UserName='standarduser@testorg4.com' ];
            }     
        }   
        return u ;
    }
}