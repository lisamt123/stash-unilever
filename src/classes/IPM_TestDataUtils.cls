/**
    @Description: This will be the initial project data utility class to be used to insert the test data throughout organisation.
    Note that, this only builds the data but insertion should occur only in the calling classes.
    @Author: Cognizant Technology
    @Date: Oct 2014
    ATTENTION REVIEWERS!: This was written by many developers and I don't think these test functions would be required. I want to ask them to refactor themselves
                        once we start writing test classes. I don't want to remove these methods coz this will create compile issues.
**/
public with sharing class IPM_TestDataUtils {
    
    
	public static final String RANDOM_STR = 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
	public static final String NEWVARIANTSIZE_STR = 'New Variant/ Size';
	public static final String COREPARAMETER_BLG = 'BLG';
	public static final String COREPARAMETER_GROWTHECORE ='Grow the Core';
	public static final String COREPARAMETER_NEWSCHANNEL = 'New Channels';
	public static final String COREPARAMETER_REGULATORY = 'Regulatory/ Compliance';
	public static final String COREPARAMETER_SUPPLYCHAIN ='Supply Chain';
	public static final String COREPARAMETER_TECHNOLOGYDEV = 'Technology Development';
	public static final String COREPARAMETER_VIP = 'VIP';
    /******************************************************
    * @description: to create IPM Projects
    * @param1 - bosscard: Id of the bosscard
    * @return : Created list of all projects
    */
    public List<IPM_Project__c> createIPMProjects(Id bosscard){
       
       //retreive all the projects with full & lite complexities
       List<IPM_Project__c > listOfIpmProjects= [SELECT IPM_Complexity__c 
                                                 FROM IPM_Project__c 
                                                 WHERE IPM_Complexity__c ='Full' OR IPM_Complexity__c ='Lite'];
       List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
       if(listOfIpmProjects!=null && listOfIpmProjects.isEmpty()){
           IPM_Project__c ipmProject = new IPM_Project__c();
           ipmProject.IPM_Project_Name__c ='test';
           if(bosscard !=  null){
               ipmProject.IPM_Bosscard__c = bosscard;
               
           }
           ipmProject.IPM_Complexity__c = 'Full';
           ipmProject.IPM_Project_Name__c ='test1';
           ipmProjects.add(ipmProject);
           ipmProject = new IPM_Project__c();
           ipmProjects.add(ipmProject);
           insert ipmProjects;
       } else{
           ipmProjects = listOfIpmProjects;  
           
       }
       return ipmProjects;
    }
   /******************************************************
    * @description: to create bosscards
    * @return : Created list of all bosscards
    */
   public  List<IPM_Bosscard__c> createIPMBosscard(){     
        
       //list of bosscards
       List<IPM_Bosscard__c> bosscard= [SELECT IPM_BosscardName__c,IPM_IsSaved__c 
                                        FROM IPM_Bosscard__c 
                                        WHERE IPM_BosscardName__c  ='Test Boss card' ];
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();//to creates
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
       if(bosscard!=null && bosscard.isEmpty()){
           ipmBosscard .IPM_BosscardName__c ='Test Boss card';
           ipmBosscard.IPM_Assumptions__c = RANDOM_STR;
           ipmBosscard.IPM_Background__c= RANDOM_STR;
           ipmBosscard.IPM_Constraints__c= RANDOM_STR;
           ipmBosscard.IPM_Consumer_Need__c= RANDOM_STR;
           ipmBosscard.IPM_Deliverables__c= RANDOM_STR;
           ipmBosscard.IPM_Potential_Business_Opportunity__c= RANDOM_STR;
           ipmBosscard.IPM_Resources__c= RANDOM_STR;
           ipmBosscard.IPM_Scope__c= RANDOM_STR;
           ipmBosscard.IPM_IsSaved__c = true;
           ipmBosscard.IPM_Brand_Positioning__c= 'LOjjii';
           ipmBosscard.IPM_Target_Launch_Date__c= 'LOjjii';
           ipmBosscard.IPM_Is_Archived__c= false;
           ipmBosscards.add(ipmBosscard);  
       }else {
           ipmBosscards= bosscard;  
       }
       insert ipmBosscards; 
       return ipmBosscards ;
    }
   
    /******************************************************
    * @description: to create user
    * @return : sObject for the user
    */
    public User createUser(){
        
        List<User> usrname = [SELECT UserName from User where UserName='newuser@testorg1.com' ];//user details
        User u = new User();
        if(usrname== null){
            u = IPM_TestFactory_Helper.createUser(true);            
        }
        return u;  
    }
    
    /******************************************************
    * @description: To create user bosscards
    * @return : sObject for the user
    */
    public User createUserBosscard1(){
        
        List<User> usrname = [SELECT UserName from User where UserName='newuser@testorgbosscard1.com' ];
        User u = new User();
        if(usrname== null){
            u = IPM_TestFactory_Helper.createUser(true);
         }
        
         return u;
    }
    
    /******************************************************
    * @description: Create a persona user who will be running test
    * @return : sObject for the user
    */
    public User  testRunAs() {
   
       List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg4.com' ];
       User u = new User();
      /* if(usrname== null){
           // Setup test data
           // This code runs as the system user
           u =TestDataFactory.createUser(false); 
     }else {*/
           if(usrname!=null && !usrname.isEmpty()){
              u = [SELECT Alias,Email,EmailEncodingKey,LastName,
                            LanguageLocaleKey,LocaleSidKey,ProfileId,
                            TimeZoneSidKey,UserName,IPM_Category__c,
                            IPM_Brand_Positioning__c, IPM_Brand_Name__c ,
                            IPM_Role__c , IPM_Sub_Category__c
                    FROM User WHERE UserName='standarduser@testorg4.com' ];
               insert u; 
           }    
      //} 
        
      return u ;
    }
    
    /******************************************************
    * @description: Test with bosscard
    * @return : sObject for the user
    */
    public User  testRunAsBosscard() {
        return IPM_TestFactory_Helper.createUser(true);
    }
   
   /******************************************************
    * @description: Test with bosscard
    * @return : sObject for the user
    */
    public User  testRunAsBosscard1() {
        return IPM_TestFactory_Helper.createUser(true);
   }
   
   /******************************************************
    * @description: Test with profiled bosscard
    * @return : sObject for the user
    */
    public IPM_User_Profile__c  createIpmUserProfileBosscard(){
       
      testRunAsBosscard1();
      User u1 =   createUserBosscard1();
       
      IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
      ipmUserProfile.IPM_user__c =  u1.id;
      return ipmUserProfile ;
   }
   
   /******************************************************
    * @description: Test with profiled bosscard
    * @return : sObject for the user
    */
    public IPM_User_Profile__c  createIpmUserProfile(){
       
        testRunAs();
        User u1 =   createUser();
        IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
        ipmUserProfile.IPM_user__c =  u1.id;
        return ipmUserProfile ;
    }
   
    /******************************************************
    * @description: Test with project resource
    * @param1 : role of the team member
    * @param2 : sObject IPM_Project__c 
    * @return : sObject for the IPM_Project_Resource__c
    */
    public IPM_Project_Resource__c  createIPMProjectResource(String ipmRole, IPM_Project__c ipmProject){
        User u2 = new User(); 
        
        u2 = IPM_TestFactory_Helper.createUser(true);
        PermissionSet Fps=new PermissionSet();
        PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
        system.runAs(u2){
            Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
            assignpermission.AssigneeId =u2.id;
            assignpermission.PermissionSetId=Fps.id;
       }
       IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       ipmProjectResource.IPM_Role_Type__c = ipmRole;
       ipmProjectResource.IPM_Project__c = ipmProject.Id ;
       ipmProjectResource.IPM_User__c = assignpermission.AssigneeId;
       insert ipmProjectResource;
       return ipmProjectResource; 
   }
   
    /******************************************************
    * @description: Create questionaire records
    * @param1 : sObject IPM_Project__c 
    * @return : sObject for the IPM_Questionnaire__c
    */
    public  IPM_Questionnaire__c createIPMQuestionaire (IPM_Project__c  project){
   
       IPM_Questionnaire__c ipmQuestionaire = new IPM_Questionnaire__c();
       if(project != null){
           ipmQuestionaire.IPM_Project__c = project.Id;
       } 
       insert ipmQuestionaire ;
       return ipmQuestionaire ;
    }
   
    /******************************************************
    * @description: Create task record
    * @param1 : sObject IPM_Project__c 
    * @return : sObject for the IPM_Task__c
    */
    public  IPM_Task__c createIPMTask(IPM_Project__c  project){
   
       IPM_Task__c ipmTask = new IPM_Task__c();
       if(project != null){
           ipmTask .IPM_Project__c = project.Id;
           ipmTask.recordtypeId = getTasksRecordType(IPM_ConstantUtils.IPM_TASK_RECORDTYPE);
       } 
       insert ipmTask ;
       return ipmTask ;
    }
   
    /******************************************************
    * @description: Create task record with functional role
    * @param1 : sObject IPM_Project__c 
    * @param2 : role of the team member 
    * @return : sObject for the IPM_Task__c
    */
    public  IPM_Task__c createIPMTaskFromIPMFunction(IPM_Project__c  project,String IpmFunction){

       IPM_Task__c ipmTask = new IPM_Task__c();
       if(project != null){
           ipmTask .IPM_Project__c = project.Id;
           ipmTask.recordtypeId = getTasksRecordType(IPM_ConstantUtils.IPM_TASK_RECORDTYPE);
           ipmTask.IPM_Function__c =IpmFunction; 
       } 
       insert ipmTask ;
       return ipmTask ;
   }
    
    /******************************************************
    * @description: Create task record with functional role
    * @param1 : sObject IPM_Project__c 
    * @param2 : role of the team member 
    * @return : sObject for the IPM_Task__c
    */
    public static String getTasksRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
    
    /******************************************************
    * @description: get recordtype of the milestone
    * @param1 : RT name
    * @return : recordtype id
    */
    public static String getMilestoneRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
   
    /******************************************************
    * @description: Create milestone record 
    * @param1 : sObject IPM_Project__c 
    * @param2 : milestone name
    * @return : sObject for the IPM_Milestone__c
    */
    public  IPM_Milestone__c createIPMMilestone(IPM_Project__c  project, string milestoneName){
   
       IPM_Milestone__c ipmMilestone = new IPM_Milestone__c();
       if(project != null){
           ipmMilestone.IPM_Project__c = project.Id;
           ipmMilestone.name = milestoneName;
           ipmMilestone .recordtypeId = getMilestoneRecordType(IPM_ConstantUtils.MILESTONES_RECORDTYPE);
       } 
       insert ipmMilestone;
       return ipmMilestone;
    }
    
    /******************************************************
    * @description: create coreparaeter help content record
    */
    public IPM_CoreParameter_Strategic_help_content__c  createIPMCoreParameterStrategicHelpContent() {
       IPM_CoreParameter_Strategic_help_content__c corehelp= new IPM_CoreParameter_Strategic_help_content__c(Name='IPM CoreParameter Strategic text', 
                                    IPM_BLG__c= 'Activity which does not involve a physical change to the product or pack but builds penetration and/or consumption of the current range usually via an activation activity. ...we know our growth is not only dependent on physical product launches and we mus', IPM_Innovation__c='A physical change to the product or pack that brings new consumer benefits and/or significant improvements in performance and claim strength utilizing technology that does not already exist in the market. ...true innovation is not commonplace approximatel',IPM_Renovation__c='A physical change to the product or pack that is perceived as a variation to an existing offering in the market and uses technology that already exists in the market. ...the majority of our projects are renovation as we are always improving our product an');
      
        insert corehelp;
        return corehelp;  
    }
    
    /******************************************************
    * @description: Create core parameter records
    */
    public List<IPM_CoreParameter__c> createIPMCoreParameterCustomSettings() {
       List<IPM_CoreParameter__c> listIPMCoreParameterCustomSettings = new List<IPM_CoreParameter__c>();
       IPM_CoreParameter__c CP1 = new IPM_CoreParameter__c(Name='Question one', Q1__c= 'Launch New Brand', Q2__c='Brand Migration', Q3__c='Brand Extention', Q4__c='New Format', Q5__c='New Platform', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY, Q14__c='Other',Question__c='Please categorize project in one of the following areas in order to define Market Place Activity');  
       IPM_CoreParameter__c CP2 = new IPM_CoreParameter__c(Name='Question two', Q1__c= 'New Core Product', Q2__c='New Benefit', Q3__c='Improvement', Q4__c='Variant', Q5__c='No Change', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY, Q14__c='Other',Question__c='Let’s define the extent of impact on the consumers perceived value from this project');  
       IPM_CoreParameter__c CP3 = new IPM_CoreParameter__c(Name='Question three', Q1__c= 'Radical', Q2__c='Next Generation', Q3__c='Incremental', Q4__c='Base', Q5__c='No Change', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY, Q14__c='Other',Question__c='How would you like to qualify the technology change brought in by this project?');  
       IPM_CoreParameter__c CP4 = new IPM_CoreParameter__c(Name='Strategic Intent', Q1__c= 'Ideas', Q2__c='Feasibility', Q3__c='Capability',Q4__c='Base', Q5__c='No Change', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY,Question__c='Please specify the phase in which you would like to initiate the project?');  
       listIPMCoreParameterCustomSettings.add(CP1);
       listIPMCoreParameterCustomSettings.add(CP2);
       listIPMCoreParameterCustomSettings.add(CP3);
       listIPMCoreParameterCustomSettings.add(CP4);
        
        insert listIPMCoreParameterCustomSettings;
        return listIPMCoreParameterCustomSettings;
   } 
}