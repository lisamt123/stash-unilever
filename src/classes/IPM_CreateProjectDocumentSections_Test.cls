@isTest
public class IPM_CreateProjectDocumentSections_Test{    
    public static IPM_Project__c project;
    public static IPM_Project__c regionalProject;
    public static IPM_Project__c localProject;
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project__c> projList=new List<IPM_Project__c>();
    public static IPM_Project_Document_Section__c projDocSec;
    

    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_Project_Rollout__c projRoll;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static IPM_Section__c secMst1;
    public static IPM_Section__c secMst2;
    public static IPM_Section__c secMst3;
    public static IPM_Section__c secMst4;
    public static IPM_Section__c secMst5;
    public static IPM_Section__c secMst6;
    public static IPM_Section__c secMst7;
    public static IPM_Section__c secMst8;
    public static IPM_Section__c secMst9;
    public static IPM_Section__c secMst10;
    public static IPM_Section__c secMst11;
    public static IPM_Section__c secMst12;
    public static IPM_Section__c secMst13;
    public static IPM_Section__c secMst14;
    public static IPM_Section__c secMst15;
    public static IPM_Section__c secMst16;
    public static IPM_Section__c    secMst17;
    public static IPM_Section__c    secMst18;
    public static IPM_Section__c    secMst19;
    public static IPM_Section__c    secMst20;
    public static IPM_Section__c    secMst21;
    public static IPM_Section__c    secMst22;
    public static IPM_Section__c    secMst23;
    public static IPM_Section__c    secMst24;
    public static IPM_Section__c    secMst25;
    public static IPM_Section__c    secMst26;
    public static IPM_Section__c    secMst27;
    public static IPM_Section__c    secMst28;
    public static IPM_Section__c    secMst29;
    public static IPM_Section__c    secMst30;
    public static IPM_Section__c    secMst31;
    public static IPM_Section__c    secMst32;
    public static Set<Id> bosscardId=new Set<Id>();
    public static IPM_Bosscard__c bosscard=new IPM_Bosscard__c();
    public static IPM_Questionnaire__c ques;
    public static User user;
    public static IPM_OTIF_Status__c ipmOtif;
    static testMethod void initializeData()
    {
        Test.startTest();
        List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
       PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            
            u1 = new User(Alias = 'cregd3', Email='cregd3@testorg4.com', 
            EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='cregd3@testorg4.com', 
            IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
            IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
            insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        List<IPM_Project_Rollout__Share> rollShareList=new list<IPM_Project_Rollout__Share>();
        IPM_Project_Rollout__Share roll=new IPM_Project_Rollout__Share();
        
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='CharterGate Full';
        ipdt.IPM_Document_Type__c='Charter';
        insert ipdt;
        
         secMst1=new IPM_Section__c();
            secMst1.IPM_Document_Template__c=ipdt.ID;
            secMst1.IPM_Section_Sequence__c='1.1';
            secMst1.IPM_Section_Name__c='Idea / Graphic';
            insert secMst1;
            
            secMst2=new IPM_Section__c();
            secMst2.IPM_Document_Template__c=ipdt.ID;
            secMst2.IPM_Section_Sequence__c='1.1';
            secMst2.IPM_Section_Name__c=' Consumer Need';
            insert secMst2;
        
            secMst=new IPM_Section__c();
            secMst.IPM_Document_Template__c=ipdt.ID;
            secMst.IPM_Section_Sequence__c='1.1';
            secMst.IPM_Section_Name__c='Environmental Impact';
            insert secMst;
            
            secMst3=new IPM_Section__c();
            secMst3.IPM_Document_Template__c=ipdt.ID;
            secMst3.IPM_Section_Sequence__c='1.1';
            secMst3.IPM_Section_Name__c=' Justification';
            secMst3.IPM_Section_Type__c='Sub Header';
            insert secMst3;
        
            secMst4=new IPM_Section__c();
            secMst4.IPM_Document_Template__c=ipdt.ID;
            secMst4.IPM_Section_Sequence__c='1.1';
            secMst4.IPM_Section_Name__c='OTIF Status';
            secMst4.IPM_Section_Type__c='Static Table';
            insert secMst4;
        
            secMst5=new IPM_Section__c();
            secMst5.IPM_Document_Template__c=ipdt.ID;
            secMst5.IPM_Section_Sequence__c='1.1';
            secMst5.IPM_Section_Name__c=' Strategic Fit';
            insert secMst5;  
        
            secMst6=new IPM_Section__c();
            secMst6.IPM_Document_Template__c=ipdt.ID;
            secMst6.IPM_Section_Sequence__c='1.1';
            secMst6.IPM_Section_Name__c='Feedback From BOSSCARD';
            insert secMst6;
        
       bosscard=new IPM_Bosscard__c();
            bosscard.Name='TestComments';
            bosscard.IPM_Bosscard_Status__c='Approved';
            bosscard.IPM_Consumer_Need__c='Consumer Need';
            bosscard.IPM_Background__c='Strategic Fit';
            bosscard.IPM_Sustainibility__c='Environmental Impact';
            bosscard.IPM_Bosscard_Approver_Comments__c='Feedback';
                  
            insert bosscard;
            bosscardId.add(bosscard.Id);
        
        project=new IPM_Project__c();
        project.Name='TestComments';
        project.IPM_Bosscard__c=bosscard.Id;
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='GCLT & RCLT'; 
        insert project;
         projList.add(project);
        
        projRoll=new IPM_Project_Rollout__c();
        projRoll.IPM_Project__c=project.ID;
        projRoll.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
        projRoll.IPM_Rollout_Project__c='TestComments_SEAA';
        projRoll.Market_Cluster__c='SEAA';
        projRoll.Target_Launch_Date__c=date.today();
        projRoll.IPM_Regional_PL__c=u1.Id;
        insert projRoll;
        
        roll.ParentId= projRoll.Id;
        roll.userOrGroupId = psa.AssigneeId ;
        roll.accesslevel = 'Edit';
        rollShareList.add(roll);
        insert rollShareList;
       
         ques=new IPM_Questionnaire__c();
            ques.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
            ques.IPM_Sequence_Number__c=1;
            ques.IPM_Section_Sequence_Number__c='1.2.1';
            ques.IPM_Question__c='Test GK Question';
            ques.IPM_RQS_Gate_Type__c='Charter';
            ques.IPM_HelpText_Yes__c='Help Text Yes';
            ques.IPM_HelpText_No__c='help Text No';
            ques.IPM_HelpText_Partly__c='help text partly';
            //ques.IPM_Project_Document_Section__c=projDocSec.Id;
            ques.Is_Master__c=true;
            insert ques;
        
            ipmOtif=new IPM_OTIF_Status__c ();
            ipmOtif.Name='Contract Attractive Business';
            ipmOtif.IPM_Gate_Document_Type__c='Charter';
            insert ipmOtif;
        
        
        }
        static testMethod void testCreateCharterDocument()
    {
        initializeData();
        
        IPM_CreateProjectDocumentSections ipmCreateCharter=new IPM_CreateProjectDocumentSections ();
        
        ipmCreateCharter.createSections(projList,bosscardId);
        ipmCreateCharter.updateSections(projList, bosscardId);
    }
}