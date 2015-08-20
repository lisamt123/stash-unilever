@IsTest(SeeAllData=true)
public class IPM_CreateTasks_Test1{

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
    
    static testmethod void testCreateIPMProjectResource(){

       Test.startTest();
       initializedData();

       Test.stopTest();  
    }
    
    @isTest
    static void testVerifyTasks() {
        
        IPM_Project_Resource__c pResource = initializedData();
        pResource.IPM_User__c = UserInfo.getUserId();
        update pResource;
    }
    
    static testmethod void testDeleteIPMProjectResource(){

       Test.startTest();
       IPM_Project_Resource__c  ipmProjectResource = initializedData();
       IPM_Bosscard__Share ipmBosscardShare= [select id from IPM_Bosscard__Share where userorgroupid= :ipmProjectResource.IPM_User__c];
       
       
           IPM_Milestone__Share ipmMilestoneShare= [select id from IPM_Milestone__Share where userorgroupid= :ipmProjectResource.IPM_User__c Limit 1];
               IPM_Task__Share ipmTaskShare= [select id from IPM_Task__Share where userorgroupid= :ipmProjectResource.IPM_User__c];

       
       delete ipmBosscardShare;
       delete ipmMilestoneShare;
       delete ipmTaskShare;
       delete ipmProjectResource;
       
       
       Test.stopTest();  
    }
    

@isTest(SeeAllData=true)
public static IPM_Project_Resource__c  initializedData()
    {       
       IPM_Project__share  proshare = new IPM_Project__share  ();
       List<IPM_Project__share> listproshare  = new List<IPM_Project__share>();
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
       

       PermissionSetAssignment permissionSetAssignment=  [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :fps.Id limit 1];
        
        
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
       User u =testData.createUser();
       User u1 = testRunAs();
       
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
        ipmltask.name='testtask';
        ipmltask.IPM_Project__c=project.id;
        insert ipmltask; 
        
        PLIpmMiles=new IPM_Milestone__c();
        PLIpmMiles.name='testtask';
        PLIpmMiles.IPM_Project__c=project.id;
        insert PLIpmMiles; 
        
        IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       
        ipmProjectResource.IPM_Role_Type__c = 'Finance';
        ipmProjectResource.IPM_Project__c = project.Id ;
        ipmProjectResource.IPM_User__c = permissionSetAssignment.AssigneeId ;
        insert ipmProjectResource;
        
        
          
       // test.startTest();
        project.IPM_Complexity__c='Full';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Fast_Track_Project__c=true;
        project.IPMProject_Span__c = 'Global';
        update project;
        //test.stopTest();
        
        /*
            Share insertion
        */
        
        Bossshare=new IPM_Bosscard__Share();
        Bossshare.parentid=Project.IPM_Bosscard__c;
        Bossshare.accesslevel='edit';
        Bossshare.userorgroupid = permissionSetAssignment.AssigneeId;
          
        IpmBossShare.add(Bossshare); 
        insert IpmBossShare;

        PLIpmMilesShr.ParentId= PLIpmMiles.Id;
        PLIpmMilesShr.userOrGroupId = permissionSetAssignment.AssigneeId;
        PLIpmMilesShr.accesslevel = 'Edit';
        ProMiles.add(PLIpmMilesShr);
        insert ProMiles;
       
        ProTskShare.ParentId= ipmltask.Id;
        ProTskShare.userOrGroupId = permissionSetAssignment.AssigneeId;
        ProTskShare.accesslevel = 'Edit';
        ProTaskShare.add(ProTskShare);
        insert ProTaskShare;
       
        proshare.ParentId= project.Id;
        proshare.userOrGroupId = permissionSetAssignment.AssigneeId;
        proshare.accesslevel = 'Edit';
        listproshare.add(proshare);
        insert listproshare  ;
       
        projectDocumentShare.ParentId= projDoc.Id;
        projectDocumentShare.userOrGroupId = permissionSetAssignment.AssigneeId ;
        projectDocumentShare.accesslevel = 'Edit';
        listIPMProjectDocumentShare.add(projectDocumentShare);
        insert listIPMProjectDocumentShare  ;
       
        projectDocumentSecShare.ParentId= projDocSec.Id;
        projectDocumentSecShare.userOrGroupId = permissionSetAssignment.AssigneeId ;
        projectDocumentSecShare.accesslevel = 'Edit';
        listIPMProjectDocumentSecShare.add(projectDocumentSecShare);
        insert listIPMProjectDocumentSecShare  ;
        
        questionaire = testdata.createIPMQuestionaire(project);

        ipmQuestionaireShare.ParentId= questionaire.Id;
        ipmQuestionaireShare.userOrGroupId = permissionSetAssignment.AssigneeId ;
        ipmQuestionaireShare.accesslevel = 'Edit';
        
        listIPMQuestionaireShare.add(ipmQuestionaireShare);
        insert listIPMQuestionaireShare;
        
        ipmProjDocSectionContentShare .ParentId= ipmProjDocSectionContent.Id;
        ipmProjDocSectionContentShare .userOrGroupId = permissionSetAssignment.AssigneeId ;
        ipmProjDocSectionContentShare .accesslevel = 'Edit';
        
        listipmProjDocSectionContentShare .add(ipmProjDocSectionContentShare );
        insert listipmProjDocSectionContentShare  ;

        return ipmProjectResource;
        
    }
  
  

      
  
  
   public static User  testRunAs() {
   
      List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg4.com' ];
      User u = new User();
        
        if(usrname== null){
              // Setup test data
              // This code runs as the system user
              Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 


              
              u = new User(Alias = 'standt4', Email='standarduser@testorg4.com', 
              EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg4.com', 
              IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u;
              
              
              
              System.runAs(u) {
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