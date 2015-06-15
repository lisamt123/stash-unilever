@isTest
private class IPM_ProjetsShr_Trigger_Test{

    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static IPM_Bosscard__c Bosscard;
    public static IPM_Task__c ipmltask;
    public static IPM_Milestone__c PLIpmMiles;
    public static IPM_Questionnaire__c questionaire;
    public static PermissionSetAssignment permissionSetAssignment;
    public static IPM_Bosscard__Share Bossshare5;
    public static IPM_Project_Document__Share ProDocShr5;
    public static IPM_Project__Share ipmProshr5;
    public static IPM_Project_Resource__Share DPLrsShr5;
    public static IPM_Project_Resource__Share GatekrsShr5;
    public static IPM_Project_Resource__Share TPLrsShr5;
    public static IPM_Project_Document_Section__Share ProSec5;
    public static IPM_Task__Share ProTskShare5;
    public static IPM_Project_Document_Section_Content__Share IpmDocContent5;
    public static IPM_Milestone__Share PLIpmMilesShr5;
    public static IPM_Milestone__Share DPLIpmMilesShr5;
    public static IPM_Milestone__Share TPLIpmMilesShr5;
    public static IPM_Milestone__Share GatepmMilesShr5;
    public static IPM_Project_Resource__Share rsShr15;
    public static IPM_Questionnaire__Share IPMQuestshr5;

    static testmethod void testCreateIPMProjectResource(){

       Test.startTest();
       initializedData();

       Test.stopTest();  
    }
  static testmethod void testUpdateIPMProject1(){
       Test.startTest();
      // IPM_Project__c ipmProject = initializedData();
      
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u2 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u2 = new User(Alias = 'gan10', Email='gan10@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan10@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa.AssigneeId = u2.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u3 =new User();
        u3 = new User(Alias = 'gan11', Email='gan11@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan11@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u3;
          System.runAs(u3) {
                psa1.AssigneeId = u3.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           }
       IPM_Project__c proj=new IPM_Project__c();
       
       insert proj;
       proj.IPM_Technical_Project_Leader__c =u2.Id;
       proj.IPM_Project_Leader__c = u3.Id;
       proj.OwnerId = u3.Id;
       proj.Deputy_Project_Leader__c = u3.Id;
       proj.IPM_Project_Gatekeeper__c = u3.Id;
      
       IPM_Company_Card__c cc=new IPM_Company_Card__c();
       cc.name='ccname';
       
       insert cc;
       
       proj.IPM_Company_Card__c=cc.id;
       update proj;
       Test.stopTest();  
      
    }
    
    

    static void testUpdateIPMProject2(){
       
       Test.startTest();
       
       IPM_Project__c ipmProject = initializedData();
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u2 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u2 = new User(Alias = 'gan12', Email='gan12@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan12@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa.AssigneeId = u2.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u3 =new User();
        u3 = new User(Alias = 'gan13', Email='gan13@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan13@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u3;
          System.runAs(u3) {
                psa1.AssigneeId = u3.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           }
        PermissionSetAssignment psa2 = new PermissionSetAssignment();
        User BPuser =new User();
        BPuser = new User(Alias = 'gan14', Email='gan14@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan14@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert BPuser;
          System.runAs(BPuser) {
                psa2.AssigneeId = BPuser.Id;
                psa2.PermissionSetId = Fps.Id;
                insert psa2;
           }   
       ipm_company_card__c cc=new ipm_company_card__c ();
       cc.name='Updated Global CC';
       cc.IPM_Managed_Category__c='HHC';
       cc.IPM_Business_Partner__c=BPuser.id;
       //cc.IPM_user__c=u.Id;
       insert cc;
       project.IPM_Technical_Project_Leader__c =u2.Id;
       ipmProject.IPM_Project_Leader__c = u3.Id;
       ipmProject.OwnerId = u2.Id;
       ipmProject.Deputy_Project_Leader__c = u2.Id;
       ipmProject.IPM_Project_Gatekeeper__c = u3.Id;
       ipmProject.ipm_company_card__c=cc.id;     
       try{
           update ipmProject ;
       }
       
       catch(Exception e){
       
       }
      
       
       Test.stopTest();
       
    }
    

    static testmethod void testUpdateIPMProject3(){
       
       Test.startTest();
        IPM_Project__c ipmProject = initializedData();
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u2 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u2 = new User(Alias = 'gan15', Email='gan15@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan15@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa.AssigneeId = u2.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u3 =new User();
        u3 = new User(Alias = 'gan16', Email='gan16@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan16@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u3;
          System.runAs(u3) {
                psa1.AssigneeId = u3.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           }     
       project.IPM_Technical_Project_Leader__c =u3.Id;
       ipmProject.IPM_Project_Leader__c = u3.Id;
       ipmProject.OwnerId = u3.Id;
       ipmProject.Deputy_Project_Leader__c = u3.Id;
       ipmProject.IPM_Project_Gatekeeper__c = u2.Id;
            
       try{
           update ipmProject ;
       }
       
       catch(Exception e){
       
       }
      

       Test.stopTest();
      
    }
    
   
    static testmethod  void testDeleteIPMProject(){

       Test.startTest();
        IPM_Project__c  ipmProject = initializedData();
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u2 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u2 = new User(Alias = 'gan17', Email='gan17@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan17@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa.AssigneeId = u2.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
       
       IPM_Bosscard__c bossc=new IPM_Bosscard__c();
       insert bossc;
       
       IPM_Project__c project1=new IPM_Project__c();
       project1.IPM_Bosscard__c=bossc.id;
       insert project1;
       IPM_Milestone__c miles=new IPM_Milestone__c();
       miles.IPM_Project__c=project1.id;
       insert miles;
       IPM_Task__c task=new IPM_Task__c();
       insert task;
       
       IPM_Bosscard__Share bossShare=new IPM_Bosscard__Share();
       bossShare.parentid=bossc.id;
       bossShare.accesslevel='Read';
       bossShare.userOrGroupId=psa.AssigneeId;
       insert bossShare;
       
       IPM_Milestone__Share milesShare=new IPM_Milestone__Share();
       milesShare.parentid=miles.id;
       milesShare.accesslevel='Read';
       milesShare.userOrGroupId=psa.AssigneeId;
       insert milesShare;
       
       IPM_Task__Share taskshare=new IPM_Task__Share();
       taskshare.parentid=task.id;
       taskshare.accesslevel='Read';
       taskshare.userOrGroupId=psa.AssigneeId;
       insert taskshare;
       
       IPM_Bosscard__Share ipmBosscardShare= [select id from IPM_Bosscard__Share where userorgroupid= :psa.AssigneeId];
       IPM_Milestone__Share ipmMilestoneShare= [select id from IPM_Milestone__Share where userorgroupid= :psa.AssigneeId limit 1];
       IPM_Task__Share ipmTaskShare= [select id from IPM_Task__Share where userorgroupid= :psa.AssigneeId limit 1];

       
       delete ipmBosscardShare;
       delete ipmMilestoneShare;
       delete ipmTaskShare;

       
       
       Test.stopTest();  
    }
    


static testmethod IPM_Project__c  initializedData()
    {       
       
       IPM_Project__share  proshare = new IPM_Project__share  ();
       List<IPM_Project__share  > listproshare  = new List<IPM_Project__share>();
       IPM_Project_Document__share  projectDocumentShare = new IPM_Project_Document__share  ();
       List<IPM_Project_Document__share  > listIPMProjectDocumentShare  = new List<IPM_Project_Document__share  >();
       IPM_Project_Document_Section__Share  projectDocumentSecShare = new IPM_Project_Document_Section__Share  ();
       List<IPM_Project_Document_Section__Share  > listIPMProjectDocumentSecShare  = new List<IPM_Project_Document_Section__Share>();
       List<IPM_Task__Share>ProTaskShare=new list<IPM_Task__Share>();
       List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__Share>();
       List<IPM_Project_Document_Section_Content__Share>ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
       List<IPM_Milestone__Share>ProMiles=new list<IPM_Milestone__Share>();
       List<IPM_Questionnaire__Share>IpmQuests=new list<IPM_Questionnaire__Share>();
       List<IPM_Bosscard__Share>IpmBossShare=new list<IPM_Bosscard__Share>();
       IPM_Bosscard__Share Bossshare=new IPM_Bosscard__Share();
       IPM_Questionnaire__Share ipmQuestionaireShare = new IPM_Questionnaire__Share();
       List<IPM_Questionnaire__Share > listIPMQuestionaireShare  = new List<IPM_Questionnaire__Share >();

       IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent =new IPM_Project_Document_Section_Content__c ();
       IPM_Project_Document_Section_Content__share  ipmProjDocSectionContentShare = new IPM_Project_Document_Section_Content__share  ();
       List<IPM_Project_Document_Section_Content__share  > listipmProjDocSectionContentShare  = new List<IPM_Project_Document_Section_Content__share  >();

       IPM_Project_Document__Share ProDocShr=new IPM_Project_Document__Share();
       IPM_Project__Share ipmProshr=new IPM_Project__Share ();
       IPM_Project_Resource__Share DPLrsShr=new IPM_Project_Resource__Share ();
       IPM_Project_Resource__Share GatekrsShr=new IPM_Project_Resource__Share ();
       IPM_Project_Resource__Share TPLrsShr=new IPM_Project_Resource__Share ();
       IPM_Project_Document_Section__Share ProSec;
       IPM_Task__Share ProTskShare=new IPM_Task__Share ();
       IPM_Project_Document_Section_Content__Share IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
       IPM_Milestone__Share PLIpmMilesShr=new IPM_Milestone__Share ();
       IPM_Questionnaire__Share IPMQuestshr=new IPM_Questionnaire__Share ();
        
        List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u = new User(Alias = 'gan18', Email='gan18@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan18@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
          System.runAs(u) {
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u1 = new User();
        
        u1 = new User(Alias = 'gan19', Email='gan19@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan19@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u1;
          System.runAs(u1) {
                psa1.AssigneeId = u1.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           }   
       //permissionSetAssignment=  [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :fps.Id limit 1];
        
       ipm_company_card__c cc=new ipm_company_card__c ();
       cc.name='Global CC';
       cc.IPM_Managed_Category__c='HHC';
       //cc.IPM_user__c=u.Id;
       insert cc;
       
       projTempl=new IPM_Project_Template__c();
       projTempl.IPM_Template_Complexity__c='Full';
       insert projTempl;
        
       ipdt=new IPM_Document_Template__c();
       ipdt.IPM_Project_Template__c=projTempl.ID;
       ipdt.IPM_Document_Template_Name__c='Contract';
       ipdt.IPM_Document_Type__c='Charter';
       insert ipdt;
       
       secMst=new IPM_Section__c();
       secMst.IPM_Document_Template__c=ipdt.ID;
       secMst.IPM_Section_Sequence__c='1.1';
       secMst.IPM_Section_Name__c='Ideas';
       insert secMst;
        
       Bosscard=new IPM_Bosscard__c();
       Bosscard.Name='TestGate1';
       insert Bosscard;
        
       project=new IPM_Project__c();
       project.Name='TestGate';
       project.IPM_Phase__c='Ideas';
       project.IPM_Complexity__c='Full';
       project.IPM_Bosscard__c=Bosscard.id;
        
       IPM_TestDataUtils testData = new IPM_TestDataUtils();
       project.IPM_Technical_Project_Leader__c =u1.Id;
       project.IPM_Project_Leader__c = u.Id;
       project.Deputy_Project_Leader__c = u.Id;
       project.IPM_Project_Gatekeeper__c = u.Id;
       project.ipm_company_card__c=cc.id;
       
       insert project; 

       projTemp=new IPM_Project_Template__c();
       projTemp.IPM_Template_Complexity__c='Full';
       insert projTemp;
        
       projDoc=new IPM_Project_Document__c();
       projDoc.IPM_GateDocuments__c='Charter'; 
       projDoc.IPM_Project__c=project.ID;
       projDoc.IPM_Project_Template__c=projTemp.Id;
       insert projDoc;     
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec; 

       ipmProjDocSectionContent =  new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        
        insert ipmProjDocSectionContent ;
        
        
        
        ipmltask=new IPM_Task__c ();
        ipmltask.name='testtask';
        ipmltask.IPM_Project__c=project.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask';
        PLIpmMiles.IPM_Project__c=project.id;
        insert PLIpmMiles; 
       /*
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Parent_Project__c=project.Id;
        proj.IPMProject_Span__c='Local';
        insert proj;*/
        
        IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c = psa.AssigneeId;
        insert ipmProjectResource;
        
        /*IPM_Project_Resource__c  ipmProjectResource1 = new IPM_Project_Resource__c();
        ipmProjectResource1.IPM_Role_Type__c = 'Finance';
        ipmProjectResource1.IPM_Project__c = proj.Id ;
        ipmProjectResource1.IPM_User__c = permissionSetAssignment.AssigneeId ;
        insert ipmProjectResource1;*/
        map<id,IPM_Project_Resource__c>mapRes=new map<id,IPM_Project_Resource__c>();
        mapRes.put(ipmProjectResource.id ,ipmProjectResource );
        IPM_Projectshare proshr=new IPM_Projectshare ();
        proshr.ShareWithLocalMember(mapRes);
        //Test.stopTest();
        /*
            Share insertion
        */
        
        Bossshare=new IPM_Bosscard__Share();
        Bossshare.parentid=Project.IPM_Bosscard__c;
        Bossshare.accesslevel='edit';
        Bossshare.userorgroupid = psa.AssigneeId;
          
        IpmBossShare.add(Bossshare); 
        insert IpmBossShare;

        PLIpmMilesShr.ParentId= PLIpmMiles.Id;
        PLIpmMilesShr.userOrGroupId = psa.AssigneeId;
        PLIpmMilesShr.accesslevel = 'Edit';
        ProMiles.add(PLIpmMilesShr);
        insert ProMiles;
       
        ProTskShare.ParentId= ipmltask.Id;
        ProTskShare.userOrGroupId = psa.AssigneeId;
        ProTskShare.accesslevel = 'Edit';
        ProTaskShare.add(ProTskShare);
        insert ProTaskShare;
       
        proshare.ParentId= project.Id;
        proshare.userOrGroupId = psa.AssigneeId;
        proshare.accesslevel = 'Edit';
        listproshare.add(proshare);
        insert listproshare  ;
       
        projectDocumentShare.ParentId= projDoc.Id;
        projectDocumentShare.userOrGroupId = psa.AssigneeId ;
        projectDocumentShare.accesslevel = 'Edit';
        listIPMProjectDocumentShare.add(projectDocumentShare);
        insert listIPMProjectDocumentShare  ;
       
        projectDocumentSecShare.ParentId= projDocSec.Id;
        projectDocumentSecShare.userOrGroupId = psa.AssigneeId ;
        projectDocumentSecShare.accesslevel = 'Edit';
        listIPMProjectDocumentSecShare.add(projectDocumentSecShare);
        insert listIPMProjectDocumentSecShare  ;
        
        questionaire = testdata.createIPMQuestionaire(project);

        ipmQuestionaireShare.ParentId= questionaire.Id;
        ipmQuestionaireShare.userOrGroupId = psa.AssigneeId ;
        ipmQuestionaireShare.accesslevel = 'Edit';
        
        listIPMQuestionaireShare.add(ipmQuestionaireShare);
        insert listIPMQuestionaireShare;
        
        ipmProjDocSectionContentShare .ParentId= ipmProjDocSectionContent.Id;
        ipmProjDocSectionContentShare .userOrGroupId = psa.AssigneeId ;
        ipmProjDocSectionContentShare .accesslevel = 'Edit';
        
        listipmProjDocSectionContentShare .add(ipmProjDocSectionContentShare );
        insert listipmProjDocSectionContentShare  ;

        return project;
        
    }
  
 static testmethod void sharewithlocaluser(){
 test.StartTest();
       
       IPM_TestDataUtils testData = new IPM_TestDataUtils();
       PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u = new User(Alias = 'Lo20', Email='Lo20@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Looo', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='Lo20@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
          System.runAs(u) {
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u2 = new User();
        
        u2 = new User(Alias = 'gan21', Email='gan21@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan21@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa1.AssigneeId = u2.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           } 
       
       IPM_Project__c project1=new IPM_Project__c();
       project1.IPM_Technical_Project_Leader__c =u2.Id;
       project1.IPM_Project_Leader__c = u.Id;
       project1.Deputy_Project_Leader__c = u.Id;
       project1.IPM_Project_Gatekeeper__c = u.Id;
       
       insert project1; 
      
        
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Parent_Project__c=project1.Id;
        proj.IPMProject_Span__c='Local';
        insert proj;
        IPM_Project_Resource__c  ipmProjectResource1 = new IPM_Project_Resource__c();
        ipmProjectResource1.IPM_Role_Type__c = 'Finance';
        ipmProjectResource1.IPM_Project__c = proj.Id ;
        ipmProjectResource1.IPM_User__c = psa.AssigneeId;
        insert ipmProjectResource1;
        
       projTempl=new IPM_Project_Template__c();
       projTempl.IPM_Template_Complexity__c='Full';
       insert projTempl;
        
       ipdt=new IPM_Document_Template__c();
       ipdt.IPM_Project_Template__c=projTempl.ID;
       ipdt.IPM_Document_Template_Name__c='Contract';
       ipdt.IPM_Document_Type__c='Charter';
       insert ipdt;
       
       secMst=new IPM_Section__c();
       secMst.IPM_Document_Template__c=ipdt.ID;
       secMst.IPM_Section_Sequence__c='1.1';
       secMst.IPM_Section_Name__c='Ideas';
       insert secMst;
        
       Bosscard=new IPM_Bosscard__c();
       Bosscard.Name='TestGate1';
       insert Bosscard;
        
            
       projTemp=new IPM_Project_Template__c();
       projTemp.IPM_Template_Complexity__c='Full';
       insert projTemp;
        
       projDoc=new IPM_Project_Document__c();
       projDoc.IPM_GateDocuments__c='Charter'; 
       projDoc.IPM_Project__c=project1.ID;
       projDoc.IPM_Project_Template__c=projTemp.Id;
       insert projDoc;     
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec; 

        IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent =new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent =  new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        
        insert ipmProjDocSectionContent ;
        
        
        
        ipmltask=new IPM_Task__c ();
        ipmltask.name='testtask';
        ipmltask.IPM_Project__c=project1.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask';
        PLIpmMiles.IPM_Project__c=project1.id;
        insert PLIpmMiles; 
       
        map<id,IPM_Project_Resource__c>mapRes=new map<id,IPM_Project_Resource__c>();
        mapRes.put(ipmProjectResource1.id ,ipmProjectResource1 );
        IPM_Projectshare proshr=new IPM_Projectshare ();
        proshr.ShareWithLocalMember(mapRes);
        map<id,IPM_Project__c>newpro=new map<id,IPM_Project__c>();
        newpro.put(proj.id,proj);
        
        test.StopTest();
        
 
 } 
 static testmethod void sharewithlocaluserProj(){
 test.StartTest();
       
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u = new User(Alias = 'Lo50', Email='Lo50@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Looo', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='Lo50@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
          System.runAs(u) {
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u2 = new User();
        
        u2 = new User(Alias = 'Lo51', Email='Lo51@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='Lo51@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa1.AssigneeId = u2.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           } 
       
       IPM_Project__c project1=new IPM_Project__c();
       
       
       insert project1; 
      
        
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Parent_Project__c=project1.Id;
        proj.IPMProject_Span__c='Local';
        insert proj;
        IPM_Project_Resource__c  ipmProjectResource1 = new IPM_Project_Resource__c();
        ipmProjectResource1.IPM_Role_Type__c = 'Finance';
        ipmProjectResource1.IPM_Project__c = proj.Id ;
        ipmProjectResource1.IPM_User__c = psa.AssigneeId;
       // insert ipmProjectResource1;
        
       projTempl=new IPM_Project_Template__c();
       projTempl.IPM_Template_Complexity__c='Full';
       //insert projTempl;
        
       ipdt=new IPM_Document_Template__c();
       ipdt.IPM_Project_Template__c=projTempl.ID;
       ipdt.IPM_Document_Template_Name__c='Contract';
       ipdt.IPM_Document_Type__c='Charter';
      // insert ipdt;
       
       secMst=new IPM_Section__c();
       secMst.IPM_Document_Template__c=ipdt.ID;
       secMst.IPM_Section_Sequence__c='1.1';
       secMst.IPM_Section_Name__c='Ideas';
      // insert secMst;
       
       Bosscard=new IPM_Bosscard__c();
       Bosscard.Name='TestGate1';
       //insert Bosscard;
        
            
       projTemp=new IPM_Project_Template__c();
       projTemp.IPM_Template_Complexity__c='Full';
      // insert projTemp;
        
       projDoc=new IPM_Project_Document__c();
       projDoc.IPM_GateDocuments__c='Charter'; 
       projDoc.IPM_Project__c=project1.ID;
       projDoc.IPM_Project_Template__c=projTemp.Id;
      // insert projDoc;     
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
       // insert projDocSec; 

        IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent =new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent =  new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        
        //insert ipmProjDocSectionContent ;
        
        
        
        ipmltask=new IPM_Task__c ();
        ipmltask.name='testtask';
        ipmltask.IPM_Project__c=project1.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask';
        PLIpmMiles.IPM_Project__c=project1.id;
        insert PLIpmMiles; 
       
        proj.IPM_Parent_Project__c=project1.Id;
        proj.IPMProject_Span__c='Local';
        proj.IPM_Technical_Project_Leader__c =u2.Id;
        proj.IPM_Project_Leader__c = u.Id;
        proj.Deputy_Project_Leader__c = u.Id;
        proj.IPM_Project_Gatekeeper__c = u.Id;
        update proj;
       
        test.StopTest();
        
 
 } 
static testmethod  void Deletesharewithlocaluser(){
 test.StartTest();
      
       IPM_TestDataUtils testData = new IPM_TestDataUtils();
       PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u = new User(Alias = 'delp12', Email='delp12@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='delp12', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='delp12@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
          System.runAs(u) {
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u2 = new User();
       
        u2 = new User(Alias = 'gan23', Email='gan23@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan23@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa1.AssigneeId = u2.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           } 
       
       IPM_Project__c project1=new IPM_Project__c();
       project1.IPM_Technical_Project_Leader__c =u2.Id;
       project1.IPM_Project_Leader__c = u.Id;
       project1.Deputy_Project_Leader__c = u.Id;
       project1.IPM_Project_Gatekeeper__c = u.Id;
       
       insert project1; 
    
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Parent_Project__c=project1.Id;
        proj.IPMProject_Span__c='Local';
        insert proj;
        IPM_Project_Resource__c  ipmProjectResource1 = new IPM_Project_Resource__c();
        ipmProjectResource1.IPM_Role_Type__c = 'Finance';
        ipmProjectResource1.IPM_Project__c = proj.Id ;
        ipmProjectResource1.IPM_User__c = psa.AssigneeId ;
        insert ipmProjectResource1;
        
       
        IPM_Projectshare proshr=new IPM_Projectshare ();
        delete ipmProjectResource1;
        map<id,IPM_Project_Resource__c>DeleteRes=new map<id,IPM_Project_Resource__c>();
        DeleteRes.put(ipmProjectResource1.id ,ipmProjectResource1 );
        proshr.DeleteshareLocalMember(DeleteRes);
        test.StopTest();
 
 } 
 static testmethod void sharewithlocalPL(){     
      test.StartTest();
      IPM_TestDataUtils testData = new IPM_TestDataUtils();
       PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u = new User(Alias = 'gg24', Email='gg24@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='gggg', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gg24@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u;
          System.runAs(u) {
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        User u2 = new User();
       
        u2 = new User(Alias = 'gan25', Email='gan25@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='gan25@testorg4.com', 
        IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u2;
          System.runAs(u2) {
                psa1.AssigneeId = u2.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           } 
       
       IPM_Project__c project1=new IPM_Project__c();
       insert project1; 
       
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Parent_Project__c=project1.Id;
        proj.IPMProject_Span__c='Local';
        proj.IPM_Technical_Project_Leader__c =u2.Id;
        proj.IPM_Project_Leader__c = u.Id;
        proj.Deputy_Project_Leader__c = u.Id;
        proj.IPM_Project_Gatekeeper__c = u.Id;
        insert proj;
        IPM_Project_Resource__c  ipmProjectResource1 = new IPM_Project_Resource__c();
        ipmProjectResource1.IPM_Role_Type__c = 'Finance';
        ipmProjectResource1.IPM_Project__c = proj.Id ;
        ipmProjectResource1.IPM_User__c = psa.AssigneeId;
        insert ipmProjectResource1;
        
       projTempl=new IPM_Project_Template__c();
       projTempl.IPM_Template_Complexity__c='Full';
       insert projTempl;
        
       ipdt=new IPM_Document_Template__c();
       ipdt.IPM_Project_Template__c=projTempl.ID;
       ipdt.IPM_Document_Template_Name__c='Contract';
       ipdt.IPM_Document_Type__c='Charter';
       insert ipdt;
       
       secMst=new IPM_Section__c();
       secMst.IPM_Document_Template__c=ipdt.ID;
       secMst.IPM_Section_Sequence__c='1.1';
       secMst.IPM_Section_Name__c='Ideas';
       insert secMst;
        
       Bosscard=new IPM_Bosscard__c();
       Bosscard.Name='TestGate1';
       insert Bosscard;
        
            
       projTemp=new IPM_Project_Template__c();
       projTemp.IPM_Template_Complexity__c='Full';
       insert projTemp;
        
       projDoc=new IPM_Project_Document__c();
       projDoc.IPM_GateDocuments__c='Charter'; 
       projDoc.IPM_Project__c=project1.ID;
       projDoc.IPM_Project_Template__c=projTemp.Id;
       insert projDoc;     
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec; 

        IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent =new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent =  new IPM_Project_Document_Section_Content__c ();
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        
        insert ipmProjDocSectionContent ;
        
        
        
        ipmltask=new IPM_Task__c ();
        ipmltask.name='testtask';
        ipmltask.IPM_Project__c=project1.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask';
        PLIpmMiles.IPM_Project__c=project1.id;
        insert PLIpmMiles; 
       
        map<id,IPM_Project__c>newpro=new map<id,IPM_Project__c>();
        newpro.put(proj.id,proj);
        IPM_Projectshare proshr=new IPM_Projectshare ();
        proshr.ShareWithLocalPL(newpro);
        test.StopTest();
        
 
 
 }
  
  
   public static User  testRunAs() {
   
      List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg4.com' ];
      User u = new User();
        
        if(usrname== null){
              // Setup test data
              // This code runs as the system user
              Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 


              
              u = new User(Alias = 'sttandt4', Email='sttandarduser@testorg4.com', 
              EmailEncodingKey='UTF-8', LastName='Testinng4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standdarduser@testorg4.com', 
              IPM_Category__c = 'testt4'  , IPM_Brand_Positioning__c= 'testt4',IPM_Brand_Name__c ='testt1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='testt', isActive =true);
              insert u;
              
              
              
              System.runAs(u) {
              
                  PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
                  PermissionSetAssignment psa = new PermissionSetAssignment();
                  psa.AssigneeId = u.Id;
                  psa.PermissionSetId = ps.Id;
                  insert psa;

              
              
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }
      }
      else {
             if(usrname.size()>0){
                 u = [SELECT Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName, IPM_Category__c ,IPM_Brand_Positioning__c, IPM_Brand_Name__c ,IPM_Role__c , IPM_Sub_Category__c    from User where UserName='standarduser@testorg4.com' ];
                 
             }     
         }   
      return u ;
   }
   
    
}