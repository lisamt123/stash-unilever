@isTest
private class IPM_TaskCompCtrl_Test{

    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    //public static IPM_Bosscard__c Bosscard;
    public static IPM_Task__c ipmltask;
    public static IPM_Milestone__c PLIpmMiles;
    public static IPM_Questionnaire__c questionaire;
    
    static testMethod  void ipm_TaskCompCtrl_TestConstructor(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
        //createUserBosscard(); 
        //testRunAsBosscard();       
        initializedData();
        
        //IPM_User_Profile__c  ipmUserProfile= createIpmUserProfileBosscard();
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        //List<IPM_Bosscard__c> listIPMBosscard = createIPMBosscard();
        //List<IPM_Project__c> listIPMProjects= createIPMProjects(listIPMBosscard[0].Id);
        ApexPages.CurrentPage().getparameters().put('id', project.Id);
        
        
        //ApexPages.StandardController sc = new ApexPages.standardController(project.Id);
        ApexPages.CurrentPage().getparameters().put('Pid', project.Id);
        //testData.createIPMProjectResource ('BD',listIPMProjects[0]);
        //IPM_Task__c ipmTask = createIPMTask(listIPMProjects[0]);
        IPM_TaskCompCtrl sic = new IPM_TaskCompCtrl();
        Test.stopTest();  
       
    }
  
   static User createUserBosscard(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 

        User u = new User();

        
             u = new User(Alias = 'rap205', Email='newuser@rap205.com', 
             EmailEncodingKey='UTF-8', LastName='rap205', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@rap205.com', 
             IPM_Category__c = 'rap205'  , IPM_Brand_Positioning__c= 'rap205',IPM_Brand_Name__c ='rap205',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;

         return u;
    }
   static User  testRunAsBosscard() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 
              User u = new User(Alias = 'rap203', Email='standarduser@rap203.com', 
              EmailEncodingKey='UTF-8', LastName='testorgteyd0112a', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@rap203.com', 
              IPM_Category__c = 'rap203'  , IPM_Brand_Positioning__c= 'rap203',IPM_Brand_Name__c ='rap203',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='rap203', isActive =true);
              insert u;
              
              System.runAs(u) {
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }

      return u ;
   }
   
   static IPM_User_Profile__c  createIpmUserProfileBosscard(){
       
      User u =  testRunAsBosscard1();
      User u1 =   createUserBosscard1();
      IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
      ipmUserProfile.IPM_user__c =  u1.id;
      return ipmUserProfile ;
   
   
   }
   
      
   static User  testRunAsBosscard1() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              User u = new User(Alias = 'rap201', Email='standarduser@rap201.com', 
              EmailEncodingKey='UTF-8', LastName='rap201', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@rap201.com', 
              IPM_Category__c = 'rap201'  , IPM_Brand_Positioning__c= 'rap201',IPM_Brand_Name__c ='rap201',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='rap201', isActive =true);
              insert u;
              
              System.runAs(u) {
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }

      return u ;
   }
    
    static User createUserBosscard1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 

        User u = new User();
        u = new User(Alias = 'rap19', Email='newuser@rap19.com', 
             EmailEncodingKey='UTF-8', LastName='b11114', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@rap19.com', 
             IPM_Category__c = 'rap19'  , IPM_Brand_Positioning__c= 'rap19',IPM_Brand_Name__c ='rap19',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='rap19' , isActive =true);
        insert u;

        return u;
    }
    
   static List<IPM_Project__c> createIPMProjects(Id bosscard){
       
       List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
       
       IPM_Project__c ipmProject = new IPM_Project__c();
       ipmProject.IPM_Project_Name__c ='tesp1';
           
       if(bosscard !=  null){
           ipmProject.IPM_Bosscard__c = bosscard;
               
       }
       ipmProject.IPM_Complexity__c = 'Full';
       ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
       insert ipmProject;
           
       ipmProject.IPM_Project_Name__c ='tessp2';
       ipmProjects.add(ipmProject);
       ipmProject = new IPM_Project__c();
       insert ipmProject;
       ipmProjects.add(ipmProject);
     
       
       return ipmProjects;
       
       
   }
   
   
   static  List<IPM_Bosscard__c> createIPMBosscard(){     
        
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();

           ipmBosscard .IPM_BosscardName__c ='Teb11114';
           ipmBosscard.IPM_Assumptions__c = 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Background__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Constraints__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Consumer_Need__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Deliverables__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Potential_Business_Opportunity__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Resources__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Scope__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_IsSaved__c = true;
           ipmBosscard.IPM_Brand_Positioning__c= 'LOjjii';
           ipmBosscard.IPM_Target_Launch_Date__c= 'LOjjii';
           ipmBosscard.IPM_Is_Archived__c= false;
           
           insert ipmBosscard;
           ipmBosscards.add(ipmBosscard);  
       
       return ipmBosscards ;
       
       
   }
   
   
   static  IPM_Task__c  initializedData()
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
        
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        u1 = new User(Alias = 'rap18', Email='rap18@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='rap18', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='rap18@testorg4.com', 
        IPM_Category__c = 'rap18'  , IPM_Brand_Positioning__c= 'rap18',IPM_Brand_Name__c ='rap18',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
        insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        User u = new User();
        PermissionSetAssignment psa1 = new PermissionSetAssignment();   
        u = new User(Alias = 'rap17', Email='rap17@testorg4.com', 
        EmailEncodingKey='UTF-8', LastName='rap17', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='rap17@testorg4.com', 
        IPM_Category__c = 'rap17'  , IPM_Brand_Positioning__c= 'rap17',IPM_Brand_Name__c ='rap17',
        IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='rap17', isActive =true);
        insert u;
          System.runAs(u) {
                psa1.AssigneeId = u.Id;
                psa1.PermissionSetId = Fps.Id;
                insert psa1;
           }
       projTempl=new IPM_Project_Template__c();
       projTempl.IPM_Template_Complexity__c='Full';
       insert projTempl;
        
       ipdt=new IPM_Document_Template__c();
       ipdt.IPM_Project_Template__c=projTempl.ID;
       ipdt.IPM_Document_Template_Name__c='Charter';
       ipdt.IPM_Document_Type__c='Charter';
       insert ipdt;
       
       secMst=new IPM_Section__c();
       secMst.IPM_Document_Template__c=ipdt.ID;
       secMst.IPM_Section_Sequence__c='1.1';
       secMst.IPM_Section_Name__c='Ideas';
       insert secMst;
        
       IPM_Bosscard__c Bosscard=new IPM_Bosscard__c();
       Bosscard.Name='TestGate124';
       insert Bosscard;
        
       project=new IPM_Project__c();
       project.Name='TestGate124';
       project.IPM_Phase__c='Ideas';
       project.IPM_Complexity__c='Full';
       project.IPM_Bosscard__c=Bosscard.id;
        
       IPM_TestDataUtils testData = new IPM_TestDataUtils();
             
       
       IPM_Company_Card__c ipmCompanyCard = new IPM_Company_Card__c();
       project.IPM_Technical_Project_Leader__c =u.Id;
       project.IPM_Project_Leader__c = u.Id;
       project.Deputy_Project_Leader__c = u.Id;
       project.IPM_Project_Gatekeeper__c = u.Id;
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
        ipmltask.name='testtask1';
        ipmltask.IPM_Project__c=project.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask2';
        PLIpmMiles.IPM_Project__c=project.id;
        insert PLIpmMiles; 
        
        IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c = psa.AssigneeId ;
        insert ipmProjectResource;
        
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

        return ipmltask;
        
    }
  
   public static User  testRunAs() {
   
      List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg345434.com' ];
      User u = new User();
        
        if(usrname== null){
              // Setup test data
              // This code runs as the system user
              Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
              u = new User(Alias = 's4yy22', Email='standarduser@s4yy22.com', 
              EmailEncodingKey='UTF-8', LastName='s4yy22', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standardus5er@s4yy22.com', 
              IPM_Category__c = 's4yy22'  , IPM_Brand_Positioning__c= 's4yy22',IPM_Brand_Name__c ='s4yy22',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test3', isActive =true);
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
   
   public static String getTasksRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
   }
}