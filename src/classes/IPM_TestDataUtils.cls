/*
    This will be the initial project data utility class to be used to insert the test data throughout organisation.
    Note that, this only builds the data but insertion should occur only in the calling classes.
*/
public with sharing class IPM_TestDataUtils {
    
    public List<IPM_Project__c> createIPMProjects(Id bosscard){
       
       List<IPM_Project__c > listOfIpmProjects= [SELECT Id, IPM_Complexity__c  from IPM_Project__c where IPM_Complexity__c ='Full' or IPM_Complexity__c ='Lite'];
       List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
       
       if(listOfIpmProjects.size()==0){
       
           
       
           IPM_Project__c ipmProject = new IPM_Project__c();
           ipmProject.IPM_Project_Name__c ='test';
           
           if(bosscard !=  null){
               ipmProject.IPM_Bosscard__c = bosscard;
               
           }
           ipmProject.IPM_Complexity__c = 'Full';
           //ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
           insert ipmProject;
           
           ipmProject.IPM_Project_Name__c ='test1';
           ipmProjects.add(ipmProject);
           
           ipmProject = new IPM_Project__c();
           insert ipmProject;
           ipmProjects.add(ipmProject);
       }
       
       else{
           
                ipmProjects = listOfIpmProjects;  
           
       }
       
       return ipmProjects;
       
       
   }
  
   
   public  List<IPM_Bosscard__c> createIPMBosscard(){     
        
       List<IPM_Bosscard__c> bosscard= [SELECT IPM_BosscardName__c,IPM_IsSaved__c  from IPM_Bosscard__c where IPM_BosscardName__c  ='Test Boss card' ];
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
           
       if(bosscard.size()==0){
                  

           ipmBosscard .IPM_BosscardName__c ='Test Boss card';
           ipmBosscard.IPM_Assumptions__c = 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Background__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Constraints__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Consumer_Need__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Deliverables__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Potential_Business_Opportunity__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Resources__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Scope__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_IsSaved__c = true;
          // ipmBosscard.IPM_Brand__c= 'LOjjii';
           //ipmBosscard.IPM_Category__c= 'LOjjii';
           ipmBosscard.IPM_Brand_Positioning__c= 'LOjjii';
           //ipmBosscard.IPM_Gate_Keeper__c= 'LOjjii';
           ipmBosscard.IPM_Target_Launch_Date__c= 'LOjjii';
           ipmBosscard.IPM_Is_Archived__c= false;
           
           insert ipmBosscard;
           ipmBosscards.add(ipmBosscard);  
           
       }
       
       else{
           
                ipmBosscards= bosscard;  
           
       }
       
           
                  
       return ipmBosscards ;
       
       
   }
   
      
    public User createUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 
        
        List<User> usrname = [SELECT UserName from User where UserName='newuser@testorg1.com' ];
        User u = new User();
        
        if(usrname== null){
        
             u = new User(Alias = 'newUser1', Email='newuser@testorg1.com', 
             EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg1.com', 
             IPM_Category__c = 'test1'  , IPM_Brand_Positioning__c= 'test10',IPM_Brand_Name__c ='test10',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;
         }     
         else {
             if(usrname.size()>0){
                 u = [SELECT UserName from User where UserName='newuser@testorg1.com' ];
                 
             }     
         }
         return u;
    }

    public User createUserBosscard1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 
        
        List<User> usrname = [SELECT UserName from User where UserName='newuser@testorgbosscard1.com' ];
        User u = new User();
        
        if(usrname== null){
        
             u = new User(Alias = 'testcard', Email='newuser@testorgbosscard1.com', 
             EmailEncodingKey='UTF-8', LastName='testorgbosscard1', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorgbosscard1.com', 
             IPM_Category__c = 'testorgbosscard1'  , IPM_Brand_Positioning__c= 'testorgbosscard1',IPM_Brand_Name__c ='test10',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;
         }     
         else {
             if(usrname.size()>0){
                 u = [SELECT UserName from User where UserName='newuser@testorgbosscard1.com' ];
                 
             }     
         }
         return u;
    }

   public User  testRunAs() {
   
      List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg4.com' ];
      User u = new User();
        
        if(usrname== null){
              // Setup test data
              // This code runs as the system user
              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
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
   public User  testRunAsBosscard() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              User u = new User(Alias = 'bosscrd', Email='standarduser@testorgbosscrdaa.com', 
              EmailEncodingKey='UTF-8', LastName='testorgbosscrdaa', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgbosscrdaa.com', 
              IPM_Category__c = 'testorgbosscr'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='testorgbosscrdaa', isActive =true);
              insert u;
              
              
              
              System.runAs(u) {
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }

      return u ;
   }
   
   
      public User  testRunAsBosscard1() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              User u = new User(Alias = 'bosscrd1', Email='standarduser@testorgbosscrd1aa.com', 
              EmailEncodingKey='UTF-8', LastName='testorgbosscrd1aa', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgbosscrd1aa.com', 
              IPM_Category__c = 'testorgbosscrd1aa'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='testorgbosscrd1aa', isActive =true);
              insert u;
              
              
              
              System.runAs(u) {
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }

      return u ;
   }
   
      public IPM_User_Profile__c  createIpmUserProfileBosscard(){
       
      User u =  testRunAsBosscard1();
      User u1 =   createUserBosscard1();
      
     /* List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
      PermissionSet Fps=new PermissionSet();
      Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_ProjectLeader'];
      */
       
      IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
      //IPM_Company_Card__c  ipmCompanyCard = createIpmCompanyCard();
      
      //ipmUserProfile.IPM_Company_Card__c = ipmCompanyCard.Id ;
      //ipmUserProfile.IPM_Business_Partner__c = true;
      //ipmUserProfile.IPM_Deputy_Business_Partner__c = true;
      ipmUserProfile.IPM_user__c =  u1.id;
      
      
     /* PermissionSetAssignment Fps1= new PermissionSetAssignment(); 

              
                 Fps1.PermissionSetId = Fps.id; //set the permission set Id
                 Fps1.AssigneeId = u1.Id; //set the User Id
                 newPermissionSetAccess.add(Fps1); 
      //insert newPermissionSetAccess;
      */
      
      
      //insert ipmUserProfile;
      
      return ipmUserProfile ;
   
   
   }
   public IPM_User_Profile__c  createIpmUserProfile(){
       
      User u =  testRunAs();
      User u1 =   createUser();
      
     /* List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
      PermissionSet Fps=new PermissionSet();
      Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_ProjectLeader'];
      */
       
      IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
      //IPM_Company_Card__c  ipmCompanyCard = createIpmCompanyCard();
      
      //ipmUserProfile.IPM_Company_Card__c = ipmCompanyCard.Id ;
      //ipmUserProfile.IPM_Business_Partner__c = true;
      //ipmUserProfile.IPM_Deputy_Business_Partner__c = true;
      ipmUserProfile.IPM_user__c =  u1.id;
      
      
     /* PermissionSetAssignment Fps1= new PermissionSetAssignment(); 

              
                 Fps1.PermissionSetId = Fps.id; //set the permission set Id
                 Fps1.AssigneeId = u1.Id; //set the User Id
                 newPermissionSetAccess.add(Fps1); 
      //insert newPermissionSetAccess;
      */
      
      
      //insert ipmUserProfile;
      
      return ipmUserProfile ;
   
   
   }
   

   
   public IPM_Project_Resource__c  createIPMProjectResource(String ipmRole, IPM_Project__c ipmProject){
        User u2 = new User(); 
              Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              u2 = new User(Alias = 'standt14', Email='standarduser@testorg14.com', 
              EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg14.com', 
              IPM_Category__c = 'test14'  , IPM_Brand_Positioning__c= 'test14',IPM_Brand_Name__c ='test1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u2;
       List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
       PermissionSet Fps=new PermissionSet();
       PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
       system.runAs(u2){
       
       Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
      
       assignpermission.AssigneeId =u2.id;
       assignpermission.PermissionSetId=Fps.id;
       insert assignpermission;
      }
       IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       //User u = testRunAsRole(ipmRole);
       
       ipmProjectResource.IPM_Role_Type__c = ipmRole;
       ipmProjectResource.IPM_Project__c = ipmProject.Id ;
       ipmProjectResource.IPM_User__c = assignpermission.AssigneeId;
       insert ipmProjectResource;
       
       return ipmProjectResource; 
   
   }
   

   public  IPM_Questionnaire__c createIPMQuestionaire (IPM_Project__c  project){
   
       IPM_Questionnaire__c ipmQuestionaire = new IPM_Questionnaire__c();
       
       if(project != null){
       
           ipmQuestionaire.IPM_Project__c = project.Id;
       } 
       
       insert ipmQuestionaire ;
       
       return ipmQuestionaire ;
       
   
   }
   
   
   public  IPM_Task__c createIPMTask(IPM_Project__c  project){
   
       IPM_Task__c ipmTask = new IPM_Task__c();
       
       if(project != null){
       
           ipmTask .IPM_Project__c = project.Id;
           ipmTask.recordtypeId = getTasksRecordType('IPM Project Tasks');
       } 
       
       insert ipmTask ;
       
       return ipmTask ;
       
   
   }
   
   public  IPM_Task__c createIPMTaskFromIPMFunction(IPM_Project__c  project,String IpmFunction){
   
       IPM_Task__c ipmTask = new IPM_Task__c();
       
       if(project != null){
       
           ipmTask .IPM_Project__c = project.Id;
           ipmTask.recordtypeId = getTasksRecordType('IPM Project Tasks');
           ipmTask.IPM_Function__c =IpmFunction; 
       } 
       
       insert ipmTask ;
       
       return ipmTask ;
       
   
   }
    
   
   public static String getTasksRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
   
   public static String getMilestoneRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
   
   public  IPM_Milestone__c createIPMMilestone(IPM_Project__c  project, string milestoneName){
   
       IPM_Milestone__c ipmMilestone = new IPM_Milestone__c();
       
       if(project != null){
       
           ipmMilestone.IPM_Project__c = project.Id;
           ipmMilestone.name = milestoneName;
           ipmMilestone .recordtypeId = getMilestoneRecordType('IPM Project Milestones');
       } 
       
       insert ipmMilestone;
       
       return ipmMilestone;
       
   
   }
   
   public void  createIPMCoreParameterStrategicHelpContent()
   {
       insert new IPM_CoreParameter_Strategic_help_content__c(Name='IPM CoreParameter Strategic text', IPM_BLG__c= 'Activity which does not involve a physical change to the product or pack but builds penetration and/or consumption of the current range usually via an activation activity. ...we know our growth is not only dependent on physical product launches and we mus', IPM_Innovation__c='A physical change to the product or pack that brings new consumer benefits and/or significant improvements in performance and claim strength utilizing technology that does not already exist in the market. ...true innovation is not commonplace approximatel',IPM_Renovation__c='A physical change to the product or pack that is perceived as a variation to an existing offering in the market and uses technology that already exists in the market. ...the majority of our projects are renovation as we are always improving our product an');
   
       
   }
   
   public void  createIPMCoreParameterCustomSettings()
   {
       insert new IPM_CoreParameter__c(Name='Question one', Q1__c= 'Launch New Brand', Q2__c='Brand Migration', Q3__c='Brand Extention', Q4__c='New Format', Q5__c='New Platform', Q6__c='New Variant/ Size', Q7__c='Grow the Core', Q8__c='New Channels', Q9__c='BLG', Q10__c='VIP', Q11__c='Technology Development', Q12__c='Supply Chain', Q13__c='Regulatory/ Compliance', Q14__c='Other',Question__c='Please categorize project in one of the following areas in order to define Market Place Activity');  
       insert new IPM_CoreParameter__c(Name='Question two', Q1__c= 'New Core Product', Q2__c='New Benefit', Q3__c='Improvement', Q4__c='Variant', Q5__c='No Change', Q6__c='New Variant/ Size', Q7__c='Grow the Core', Q8__c='New Channels', Q9__c='BLG', Q10__c='VIP', Q11__c='Technology Development', Q12__c='Supply Chain', Q13__c='Regulatory/ Compliance', Q14__c='Other',Question__c='Let’s define the extent of impact on the consumers perceived value from this project');  
       insert new IPM_CoreParameter__c(Name='Question three', Q1__c= 'Radical', Q2__c='Next Generation', Q3__c='Incremental', Q4__c='Base', Q5__c='No Change', Q6__c='New Variant/ Size', Q7__c='Grow the Core', Q8__c='New Channels', Q9__c='BLG', Q10__c='VIP', Q11__c='Technology Development', Q12__c='Supply Chain', Q13__c='Regulatory/ Compliance', Q14__c='Other',Question__c='How would you like to qualify the technology change brought in by this project?');  
       
       insert new IPM_CoreParameter__c(Name='Strategic Intent', Q1__c= 'Ideas', Q2__c='Feasibility', Q3__c='Capability',Q4__c='Base', Q5__c='No Change', Q6__c='New Variant/ Size', Q7__c='Grow the Core', Q8__c='New Channels', Q9__c='BLG', Q10__c='VIP', Q11__c='Technology Development', Q12__c='Supply Chain', Q13__c='Regulatory/ Compliance',Question__c='Please specify the phase in which you would like to initiate the project?');  
       
   } 
}