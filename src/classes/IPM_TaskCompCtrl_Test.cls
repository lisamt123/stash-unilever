/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class to test IPM_TaskCompCtrl class functionalities
*********************************************/
@isTest
private class IPM_TaskCompCtrl_Test{
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static IPM_Task__c ipmltask;
    public static IPM_Milestone__c PLIpmMiles;
    public static IPM_Questionnaire__c questionaire;
    public static List<IPM_Task__c> lstIPMTasks = new List<IPM_Task__c>();
    public static User standardUser;
    /*******************************************************************************************************
    * @description: testMethod to test constructor
    */
    static testMethod  void TaskCompCtrlConstructorTest(){
        Test.startTest();    
        initializedData();
        Test.stopTest();
        
        PageReference pageRef = Page.IPM_ProjectSetup;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('id', project.Id);
        
        ApexPages.CurrentPage().getparameters().put('Pid', project.Id);
        System.assert(project.Id != null);
    }
    /*******************************************************************************************************
    * @description: Method to create user
    */
    static User createUserBosscard(){
        standardUser = new User();
        standardUser = IPM_TestFactory_Helper.createUser(true);
        System.assert(standardUser != null, 'User Created');
       return standardUser;
    }
    /*******************************************************************************************************
    * @description: Method to create Profile
    */
    static IPM_User_Profile__c  createIpmUserProfileBosscard(){
        User u1 =   createUserBosscard1();
        IPM_User_Profile__c ipmUserProfile = IPM_TestFactory_Helper.createUserProfile(FALSE);
        ipmUserProfile.IPM_user__c =  u1.id;
        System.assertEquals(u1.Id, ipmUserProfile.IPM_user__c, 'IPM User Profile created');
        return ipmUserProfile ;
    }
    
    static User createUserBosscard1(){
         return IPM_TestFactory_Helper.createUser(true);
    }
    
    /*******************************************************************************************************
    * @description: Method to create Project
    */
    static List<IPM_Project__c> createIPMProjects(Id bosscard){
        List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();

        IPM_Project__c ipmProject = IPM_TestFactory_Helper.createIPMProject(FALSE);
        ipmProject.IPM_Project_Name__c ='tesp1';
        
        if(bosscard !=  null){
            ipmProject.IPM_Bosscard__c = bosscard;
            
        }
        
        ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
        insert ipmProject;
        
        ipmProject.IPM_Project_Name__c ='tessp2';
        ipmProjects.add(ipmProject);
        ipmProject = IPM_TestFactory_Helper.createIPMProject(TRUE);
        
        ipmProjects.add(ipmProject);
        System.assert(ipmProjects != NULL , 'Project created');
        return ipmProjects;
    }
    
    
    static  List<IPM_Bosscard__c> createIPMBosscard(){
        //String testStr = 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
        List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
        IPM_Bosscard__c ipmBosscard  = IPM_TestFactory_Helper.createIPMBosscard(FALSE);
        
        insert ipmBosscard;
        ipmBosscards.add(ipmBosscard);  
        System.assert(ipmBosscard != NULL , 'Bosscard created');
        return ipmBosscards ;
    }
    /*******************************************************************************************************
    * @description: Method to initialize data
    */
    static  IPM_Task__c  initializedData(){ 
          
       IPM_Project_Document_Section_Content__c  ipmProjDocSectionContent;  // =new IPM_Project_Document_Section_Content__c ();
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u1 = IPM_TestFactory_Helper.createUser(true);
        System.runAs(u1) {
            psa.AssigneeId = u1.Id;
            psa.PermissionSetId = Fps.Id;
            insert psa;
        }
        standardUser = IPM_TestFactory_Helper.createUser(TRUE);//new User();
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        standardUser = IPM_TestFactory_Helper.createUser(true);
       
        System.runAs(standardUser) {
            psa1.AssigneeId = standardUser.Id;
            psa1.PermissionSetId = Fps.Id;
            insert psa1;
        }
        projTempl=IPM_TestFactory_Helper.createIPMProjectTemplate(TRUE);
        
        ipdt=IPM_TestFactory_Helper.creteIPMDocumentTemplate(FALSE);
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Charter';
        insert ipdt;
        
        secMst=IPM_TestFactory_Helper.createIPMSection(FALSE);
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Name__c='Ideas';
        insert secMst;
        
        IPM_Bosscard__c Bosscard=IPM_TestFactory_Helper.createIPMBosscard(TRUE);
        
        project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.IPM_Bosscard__c=Bosscard.id;
        project.IPM_Technical_Project_Leader__c =standardUser.Id;
        project.IPM_Project_Leader__c = standardUser.Id;
        project.Deputy_Project_Leader__c = standardUser.Id;
        project.IPM_Project_Gatekeeper__c = standardUser.Id;
        insert project; 
        
        projTemp=IPM_TestFactory_Helper.createIPMProjectTemplate(TRUE);
        
        projDoc=IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
        projDoc.IPM_GateDocuments__c='Charter'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Project_Template__c=projTemp.Id;
        insert projDoc;     
        
        projDocSec=IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec; 
        
        ipmProjDocSectionContent =  IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        insert ipmProjDocSectionContent ;
        
        //Create Tasks in bulk
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(project.Id, false);
            task.IPM_Active__c  =true;
            task.IPM_Completed__c =false;
            task.IPM_Function__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_PL;
            task.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            task.IPM_Task_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
            task.IPM_Task_Name__c ='test' + i;
            task.IPM_Task_Type__c = IPM_ConstantUtils.TYPE_NON_NEGOTIABLE;
            task.IPM_Type_of_Gate__c = IPM_ConstantUtils.CHARTER_GATE;
            task.IPM_Project_Document_Section__c=projDocSec.Id;
            task.IPM_Project__c = project.Id;
            lstIPMTasks.add(task);
        }
        insert lstIPMTasks;
        
        //Create milestone for local project
        List<IPM_Milestone__c> lstMilestones = new List<IPM_Milestone__c>();
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Milestone__c projectMilestone = IPM_TestFactory_Helper.createIPMMilestone(project.Id, false);
            projectMilestone.IPM_Phase__c= IPM_ConstantUtils.PHASE_IDEAS;
            projectMilestone.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
            projectMilestone.IPM_Due_Date__c = System.today() - 5;
            projectMilestone.IPM_Completed_On__c = null;
            projectMilestone.IPM_Project__c = project.Id;
            lstMilestones.add(projectMilestone);
        }
        insert lstMilestones; 
        
        //Bulk insert of project resources
        List<IPM_Project_Resource__c> ipmProjRescourceTestList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 20); 
        
        for(Integer i = 0; i < ipmProjRescourceTestList.size(); i++){
            ipmProjRescourceTestList[i].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_BD_MARKETING;
            ipmProjRescourceTestList[i].IPM_User__c =standardUser.Id;
            ipmProjRescourceTestList[i].IPM_Project__c = project.Id;
        }
        insert ipmProjRescourceTestList;
        
        
        return ipmltask;
    }
    
    public static User  testRunAs() {
        List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg345434.com' ];
        standardUser = new User();
        
        if(usrname== null){
            // Setup test data
            // This code runs as the system user
            standardUser = IPM_TestFactory_Helper.createUser(true);
            System.runAs(standardUser) {
                PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = standardUser.Id;
                psa.PermissionSetId = ps.Id;
                insert psa;
                
                // The following code runs as user 'u' 
            }
        }
        else {
            if(usrname != null && !usrname.isEmpty()){
                standardUser = [SELECT Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName, IPM_Category__c ,IPM_Brand_Positioning__c, IPM_Brand_Name__c ,IPM_Role__c , IPM_Sub_Category__c    from User where UserName='standarduser@testorg4.com' ];
            }     
        }   
        System.assert(standardUser != NULL, 'User created');
        return standardUser ;
    }
    /*******************************************************************************************************
    * @description: Method to get recordtypes of task
    */
    public static String getTasksRecordType(String pRecordType) {
        System.assert(Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId() != NULL, 'Record type Id validated');
        return Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
    /*******************************************************************************************************
    * @description: Testmethod to test task
    */
    Public static testmethod void testtask(){
        Test.startTest();
        IPM_Project__c ip = IPM_TestFactory_Helper.createIPMProject(FALSE);
        ip.name = 'test';
        ip.IPM_PM_Approach__c = 'External';
        insert ip;
        
        List<IPM_Task__c> taskList = new List<IPM_Task__c> ();
        
        IPM_Task__c i = IPM_TestFactory_Helper.createIPMTask(ip.id,FALSE);
        i.name = 'ABC';
        i.IPM_Assignee__c = userinfo.getuserid();
        i.IPM_Completed__c = true;
        i.IPM_Active__c = true;
        i.IPM_Project__c = ip.Id;
        taskList.add(i);
        
        IPM_Task__c i1 = IPM_TestFactory_Helper.createIPMTask(ip.id,FALSE);
        i1.name = 'ABC1';
        i1.IPM_Assignee__c = userinfo.getuserid();
        i1.IPM_Completed__c = false;
        i1.IPM_Active__c = true;
        i1.IPM_Project__c = ip.Id;
        taskList.add(i1);
        
        insert taskList;
        
        ApexPages.currentPage().getParameters().put('pid',ip.id);
        IPM_TaskCompCtrl ipm = new IPM_TaskCompCtrl();
        ipm.setTaskId(i.id);
        ipm.setPhase(i.id);
        ipm.getPhase();
        System.assertEquals(i.id, ipm.getPhase());
        ipm.setUser(userinfo.getuserid());
        ipm.getUser();
        System.assertEquals(userinfo.getuserid(), ipm.getUser());
        
        
        IPM_User_Profile__c ipmUserProfile = IPM_TestFactory_Helper.createUserProfile(FALSE);
        ipmUserProfile.IPM_user__c =  UserInfo.getUserId();
        upsert ipmUserProfile ;
        
        ipm.getProjectTasks();
        
        System.assertEquals(i.id, ipm.getTaskId());
        ipm.toggleDueDate();
        ipm.toggleSortTasks();
        ipm.toggleSortSections();
        ipm.toggleSortPhases();
        ipm.toggleSortCompletion();
        ipm.toggleSortAssignees();
        ipm.getProjectTasks();
        ipm.filteredPhase();
        ipm.filteredUser();
        ipm.filterCompleteTasks();
        ipm.myTasks();
        ipm.myRole();
        ipm.markComplete();
        ipm.deleteTask();
        ipm.markComplete();
        
        ipm.SaveIPMApproach();
        System.assertEquals(IPM_ConstantUtils.IPM_APPROACH_EXTERNAL , ip.IPM_PM_Approach__c);
        
        Map<String,Boolean> phaseTask = new Map<String,Boolean>();
        Boolean phase = false;
        for(IPM_Task__c  currentTask : taskList){
            phaseTask.put(currentTask.IPM_Phase__c, phase );
            phase = true;
        }
        
        ipm.phaseTaskComp = phaseTask;
        ipm.postProcessing(taskList);
    
        ipm.IsTaskEditable = true;//used by security
        ipm.IsAllEditable = true;//used by security
        ipm.UFunctionRole = 'Test';//this property needs to be removed.
        ipm.pmApproachMessage = true;
        ipm.isCreateTask = true;
        ipm.isApproachEdit = true;
        ipm.isChecked = 'true';
        
        ApexPages.currentPage().getParameters().put('pid','Invalid');
        try{
        
        ipm = new IPM_TaskCompCtrl();
        }catch(Exception e){
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assertNotEquals(0, pageMessages.size());

            // Check that the error message you are expecting is in pageMessages
            Boolean messageFound = false;

            for(ApexPages.Message message : pageMessages) {
                 messageFound = true;        
            }
            System.assert(messageFound);
        }

        Test.stopTest();
    }
}