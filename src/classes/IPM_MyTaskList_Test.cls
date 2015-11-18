/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for IPM_MyTaskList class functionalities
*********************************************/
@isTest
private class IPM_MyTaskList_Test{

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
    public static IPM_Bosscard__c ipmBosscard;
    public static IPM_Project_Resource__c  ipmProjectResource;
    public static IPM_Project__c ipmProject;
    public static  IPM_Project_Document_Section_Content__c ipmProjDocSectionContent;
    
    /*String replaced for duplicate literals*/
    public static final string NULL_STR = '';
    public static final string BOSSCARD_STR = 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';

    /*
    * @description For Running Test Script
    */ 
    static testMethod void testIPM_MyTaskListConstructor(){
        Test.startTest();
        User u1=createUserBosscard(); 
        User u2=testRunAsBosscard();    
        
        System.assert(u1.UserName != null,IPM_ConstantUtils.MSG_SHOULD_NOT_NULL);
        System.assert(u2.UserName != null,IPM_ConstantUtils.MSG_SHOULD_NOT_NULL);   
        
        IPM_User_Profile__c  ipmUserProfile= createIpmUserProfileBosscard();
        
        System.assert(ipmUserProfile.IPM_user__c != null,IPM_ConstantUtils.MSG_SHOULD_NOT_NULL);
        
        PageReference pageRef = Page.IPM_ProjectSetupView;
        Test.setCurrentPageReference(pageRef);
        List<IPM_Bosscard__c> listIPMBosscard = createIPMBosscard();
        
        System.assert(listIPMBosscard[0].IPM_BosscardName__c =='Teb11114',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listIPMBosscard[0].Id);
        
        System.assert(listIPMProjects[0].IPM_Bosscard__c == listIPMBosscard[0].Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);

        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
        System.Assert(ApexPages.CurrentPage().getparameters().get('id') == listIPMProjects[0].id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
        IPM_Project_Resource__c  ipmpresource= IPM_TestFactory_Helper.createIPMProjectResource(listIPMProjects[0].id,FALSE);
        ipmpresource.IPM_Role_Type__c = 'BD';
        insert ipmpresource;
        
        System.assert(ipmpresource.IPM_Role_Type__c == 'BD',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        System.assert(ipmpresource.IPM_Project__c == listIPMProjects[0].Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        IPM_Task__c ipmTask = createIPMTask(listIPMProjects[0]); 
        
        System.assert(ipmTask.Name == 'testtask',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        Test.stopTest();  
   }
   
    /*
    * @description For testing the Taskid
    */ 
   static testMethod void testSetTaskId(){
       IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
       ipmMyTaskList.setTaskId(IPM_ConstantUtils.TEST_STR);
       System.assert(ipmMyTaskList.getTaskId() == IPM_ConstantUtils.TEST_STR,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
   }
  
    /*
    * @description For running the phase of task
    */ 
    static testMethod void testSetPhase(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.setPhase(IPM_ConstantUtils.TEST_STR);
        System.assert(ipmMyTaskList.getPhase() == IPM_ConstantUtils.TEST_STR,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
    }

    /*
    * @description For running the test script of getting phase 
    */ 
    static testMethod void testGetPhase(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        String sPhase = ipmMyTaskList.getPhase();
        System.assertEquals(NULL_STR, sPhase);
    }
    
    /*
    * @description For testing the testuser
    */   
    static testMethod void testSetUser(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.setUser(IPM_ConstantUtils.TEST_STR);
        System.assert(ipmMyTaskList.getUser() == IPM_ConstantUtils.TEST_STR,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
    }
     
    /*
    * @description For getting the user
    */ 
    static testMethod void testGetUser(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        String sUser = ipmMyTaskList.getUser();
        System.assertEquals(NULL_STR, sUser);
    }
   
    // Getting the Taskid
    static testMethod void testGetTaskId(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        String sTaskID = ipmMyTaskList.getTaskId();
        System.assertEquals(NULL_STR, sTaskID);
    }
   
    // Running test script for sort Phase
    
    static testMethod void testToggleSortPhases(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.toggleSortPhases();
        System.assertEquals(true, ipmMyTaskList.isAsc);
        System.assertEquals('IPM_Phase__c', ipmMyTaskList.currentSort.get(IPM_ConstantUtils.THIS_FIELD));
    }
    
    // Running test script for sort completion
    static testMethod void testToggleSortCompletion(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.toggleSortCompletion();
        System.assertEquals(true, ipmMyTaskList.isAsc);
        System.assertEquals('IPM_Completed__c', ipmMyTaskList.currentSort.get(IPM_ConstantUtils.THIS_FIELD));
    }
    
    // Running the Sorting for Assignee
   
    static testMethod void testToggleSortAssignees(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.toggleSortAssignees();
        System.assertEquals(true, ipmMyTaskList.isAsc);
        System.assertEquals('IPM_Assignee__r.Name', ipmMyTaskList.currentSort.get(IPM_ConstantUtils.THIS_FIELD));
    }
    
    // Running the Test script for Project Tasks
    
    static testMethod void testGetProjectTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.getProjectTasks();
        System.assert(ipmMyTaskList.projectTasks.size() == 0);
    }
    
    // Running the test script for Phase Filtering
    
    static testMethod void testFilteredPhase(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.filteredPhase();
        System.assert(ipmMyTaskList.projectTasks.size() == 0);
    }
    
    // Filtering the user
    
    static testMethod void testFilteredUser(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.filteredUser();
         System.assert(ipmMyTaskList.projectTasks.size() == 0);
    }
    
    // User tasks
    
    static testMethod void testMyTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.myTasks();
        System.assert(ipmMyTaskList.projectTasks.size() == 0);
    } 
    
    // Task role
    
    static testMethod void testMyRole(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.myRole();
        System.assert(ipmMyTaskList.projectTasks.size() == 0);
    }
    
    // Deleting the tasks
    
    static testMethod void testDeleteTask(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.deleteTask();
        System.assert(ipmMyTaskList.projectTasks.size() == 0);
    }
    
    // Marking the Tasks complete
   /* static testMethod void testMarkComplete(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        IPM_Task__c t= IPM_TestFactory_Helper.createIPMTask(null,FALSE);
        t.IPM_Completed__c=true;
        insert t;
        ipmMyTaskList.setTaskId(t.Id);
        System.assert(ipmMyTaskList.getTaskId() == t.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        ipmMyTaskList.markComplete();
    }*/

    static testMethod void testFirst(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.first();
        System.assert(ipmMyTaskList.standardSetCon.getPageSize() > 0);
    }
    
    static testMethod void testLast(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.last();
        System.assert(ipmMyTaskList.standardSetCon.getPageSize() > 0);
    }
    
    static testMethod void testPrevious(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.previous();
        System.assert(ipmMyTaskList.standardSetCon.getPageSize() > 0);
    }
    
    static testMethod void testProject(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        PageReference pageRefActual = ipmMyTaskList.project();
       System.assertEquals('/apex/ipmproject_1', pageRefActual.getURL());
    }
    
    static testMethod void testBosscard(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        PageReference pageRefActual = ipmMyTaskList.bosscard();
        System.assertEquals('/apex/ipmbosscard_1', pageRefActual.getURL());
        System.assertEquals(true, ipmMyTaskList.isBosscard);
    }
    
    static testMethod void testShowAllOverDue(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.showAllOverDue();
        System.assertEquals(ipmMyTaskList.setCon.getResultSize(), ipmMyTaskList.overduesize);
    }
    
    
    static testMethod void testGetOverduetasksSample(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        List<IPM_Task__c> lstTasks = ipmMyTaskList.getOverduetasksSample();
        System.assert(lstTasks.size() == 0);
    }
    
    static testMethod void testTodayTasksize(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.todayTasksize();
        System.assertEquals(ipmMyTaskList.setControl.getResultSize(), ipmMyTaskList.showtodaySize);
    }
    
    static testMethod void testShowAllNextSevenDays(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.showAllNextSevenDays();
        System.assertEquals(ipmMyTaskList.setCont.getResultSize(), ipmMyTaskList.nextSevensize);
    }
    
    static testMethod void testGetNextSevenTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        List<IPM_Task__c> lstTasks = ipmMyTaskList.getNextSevenTasks();
        System.assert(lstTasks.size() == 0);
    }
    
    static testMethod void testGetLaterTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        List<IPM_Task__c> lstTasks = ipmMyTaskList.getLaterTasks();
        System.assert(lstTasks.size() == 0);
    }
    
    static testMethod void testShowAllLaterTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.showAllLaterTasks();
        System.assertEquals(ipmMyTaskList.setContr.getResultSize(), ipmMyTaskList.laterSize);
    }
    
    static testMethod void testShowCompletedTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.showCompletedTasks();
        System.assertEquals(ipmMyTaskList.setController.getResultSize(), ipmMyTaskList.completedSize);
    }
    
    static testMethod void testGetcompletedTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        List<IPM_Task__c> lstTasks = ipmMyTaskList.getcompletedTasks();
        System.assert(lstTasks.size() == 0);
    }
    
    static testMethod void testSetprojectName(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.setprojectName(IPM_ConstantUtils.TEST_STR);
        System.assertEquals(IPM_ConstantUtils.TEST_STR, ipmMyTaskList.getprojectName());
    }
    
    static testMethod void testGetprojectName(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        System.assertEquals(NULL_STR, ipmMyTaskList.getprojectName());
    }
    
    static testMethod void testFilteredProject(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.filteredProject();
        System.assert(ipmMyTaskList.setCon.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setController.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setControl.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setContr.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setCont.getRecords().size() == 0);
    }
    
    static testMethod void testSetcategoryName(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.setcategoryName(IPM_ConstantUtils.TEST_STR);
        System.assert(ipmMyTaskList.getcategoryName() == IPM_ConstantUtils.TEST_STR , IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
    }
    
    static testMethod void testGetcategoryName(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        System.assertEquals(NULL_STR , ipmMyTaskList.getcategoryName());
    }
    
    static testMethod void testFilteredCategory(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.filteredCategory();
        System.assert(ipmMyTaskList.setCon.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setController.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setControl.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setContr.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setCont.getRecords().size() == 0);
    }
    
    static testMethod void testSetbrandName(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.setbrandName(IPM_ConstantUtils.TEST_STR);
        System.assert(ipmMyTaskList.getbrandName() ==IPM_ConstantUtils.TEST_STR,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
    }
    
    static testMethod void testGetbrandName(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        System.assertEquals(NULL_STR , ipmMyTaskList.getbrandName());
    }
    
    static testMethod void testToggleDueDate(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.toggleDueDate();
        System.assertEquals(true, ipmMyTaskList.isAsc);
        System.assertEquals('IPM_Due_Date1__c', ipmMyTaskList.currentSort.get(IPM_ConstantUtils.THIS_FIELD));
    }
    
    static testMethod void testProjectSearch(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.projectSearch();
        System.assert(ipmMyTaskList.setCon.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setController.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setControl.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setContr.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setCont.getRecords().size() == 0);
    }
    
    static testMethod void testReset(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.reset();
        System.assert(ipmMyTaskList.setCon.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setController.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setControl.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setContr.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setCont.getRecords().size() == 0);
    }
    
    static testMethod void testResetall(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.resetall();
        System.assert(ipmMyTaskList.setCon.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setController.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setControl.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setContr.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setCont.getRecords().size() == 0);
    }
    
    static testMethod void testFilterCompleteTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.filterCompleteTasks();
        System.assert(ipmMyTaskList.setCon.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setController.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setControl.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setContr.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setCont.getRecords().size() == 0);
    }
    
    static testMethod void testToggleSortTasks(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.toggleSortTasks();
        System.assertEquals(true, ipmMyTaskList.isAsc);
        System.assertEquals('IPM_Task_Name__c', ipmMyTaskList.currentSort.get(IPM_ConstantUtils.THIS_FIELD));
    }
    
    static testMethod void testToggleSortSections(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.toggleSortSections();
        System.assertEquals(true, ipmMyTaskList.isAsc);
        System.assertEquals('IPM_Project_Document_Section__r.IPM_Section_Sequence__c', ipmMyTaskList.currentSort.get(IPM_ConstantUtils.THIS_FIELD));
    }
    
    static testMethod void testFilteredBrand(){
        IPM_MyTaskList ipmMyTaskList= new IPM_MyTaskList();
        ipmMyTaskList.filteredBrand();
        System.assert(ipmMyTaskList.setCon.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setController.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setControl.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setContr.getRecords().size() == 0);
        System.assert(ipmMyTaskList.setCont.getRecords().size() == 0);
    }
    
    static User createUserBosscard(){

        
        return IPM_TestFactory_Helper.createUser(true);
    }
    static User  testRunAsBosscard() {
      User u = IPM_TestFactory_Helper.createUser(true);
        System.runAs(u) {
            // The following code runs as user 'u' 
          //  System.debug('Current User: ' + UserInfo.getUserName());
          //  System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        
        return u ;
    }
    
    static IPM_User_Profile__c  createIpmUserProfileBosscard(){
        User u1 =   createUserBosscard1();
        
       
        //IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
        IPM_User_Profile__c ipmUserProfile = IPM_TestFactory_Helper.createUserProfile(false);
        ipmUserProfile.IPM_user__c =  u1.id;

       
        return ipmUserProfile ;  
    }

    static User  testRunAsBosscard1() {

        User u = IPM_TestFactory_Helper.createUser(true);
        System.runAs(u) {
            // The following code runs as user 'u' 
          //  System.debug('Current User: ' + UserInfo.getUserName());
          //  System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        return u ;
    }
    
    static User createUserBosscard1(){
        return IPM_TestFactory_Helper.createUser(true);
    }
    
    static List<IPM_Project__c> createIPMProjects(Id bosscard){
        
        List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
        
        //IPM_Project__c ipmProject = new IPM_Project__c();
        ipmProject = IPM_TestFactory_Helper.createIPMProject(FALSE);
        ipmProject.IPM_Project_Name__c =IPM_ConstantUtils.TEST_STR;
        
        if(bosscard !=  null){
            ipmProject.IPM_Bosscard__c = bosscard;
            
        }
        ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
        insert ipmProject;
        System.Assert(ipmProject.IPM_Project_Leader__c ==Userinfo.getUserId(),IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        ipmProject.IPM_Project_Name__c ='test1';
        ipmProjects.add(ipmProject);
        
        //ipmProject = new IPM_Project__c();
        IPM_TestFactory_Helper.createIPMProject(TRUE);
        ipmProjects.add(ipmProject);
        return ipmProjects;
    }

    static  List<IPM_Bosscard__c> createIPMBosscard(){     
        List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
        //IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
        ipmBosscard = IPM_TestFactory_Helper.createIPMBosscard(FALSE); 
        ipmBosscard .IPM_BosscardName__c ='Teb11114';
        
        System.Assert(ipmBosscard .IPM_BosscardName__c =='Teb11114',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        insert ipmBosscard;
        ipmBosscards.add(ipmBosscard);  
        return ipmBosscards ; 
    }
    
    static  IPM_Task__c createIPMTask(IPM_Project__c  project){
        IPM_Task__c task=  initializedData();
        System.Assert(task !=null,IPM_ConstantUtils.MSG_SHOULD_NOT_NULL);
        return task; 
    }
    
    static  IPM_Task__c  initializedData()
    {       
       

        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User u1 = IPM_TestFactory_Helper.createUser(true);
        System.runAs(u1) {
            psa.AssigneeId = u1.Id;
            psa.PermissionSetId = Fps.Id;
            insert psa;
        }
        User u = new User();
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        u = IPM_TestFactory_Helper.createUser(true);
        System.runAs(u) {
            psa1.AssigneeId = u.Id;
            psa1.PermissionSetId = Fps.Id;
            insert psa1;
        }
        projTempl = IPM_TestFactory_Helper.createIPMProjectTemplate(TRUE);
        //insert projTempl;
        
       
        
        ipdt = IPM_TestFactory_Helper.creteIPMDocumentTemplate(FALSE);
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Charter';
		ipdt.IPM_Document_Order__c=10;
        insert ipdt;
        
         System.Assert(ipdt.IPM_Project_Template__c ==projTempl.ID,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        secMst = IPM_TestFactory_Helper.createIPMSection(FALSE);
        secMst.IPM_Document_Template__c=ipdt.ID;
        insert secMst;
        
        System.Assert(secMst.IPM_Document_Template__c ==ipdt.ID,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        IPM_Bosscard__c Bosscard = IPM_TestFactory_Helper.createIPMBosscard(FALSE);
        Bosscard.Name='TestGate1';
        insert Bosscard;
        System.Assert(Bosscard.Name=='TestGate1',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.Name='TestGate';
        project.IPM_Bosscard__c=Bosscard.id;
        
        System.Assert(project.IPM_Bosscard__c== Bosscard.id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        //insert ipmCompanyCard;
        project.IPM_Technical_Project_Leader__c =u.Id;
        project.IPM_Project_Leader__c = u.Id;
        project.Deputy_Project_Leader__c = u.Id;
        project.IPM_Project_Gatekeeper__c = u.Id;
        insert project; 
        
        System.Assert(project.IPM_Project_Gatekeeper__c == u.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        projTemp = IPM_TestFactory_Helper.createIPMProjectTemplate(TRUE);
        
        System.Assert(projTemp.IPM_Template_Complexity__c==IPM_ConstantUtils.IPM_COMPLEXITY_FULL,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        projDoc = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Project_Template__c=projTemp.Id;
        projDoc.IPM_Document_Order__c=10;
        insert projDoc;     
        
        System.Assert(projDoc.IPM_Project__c==project.ID,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        projDocSec = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec; 
        
        System.Assert(projDocSec.IPM_Section__c== secMst.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        ipmProjDocSectionContent = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);
        ipmProjDocSectionContent .IPM_Project_Document_Section__c =projDocSec.ID;
        
        insert ipmProjDocSectionContent ;
        
        System.Assert(ipmProjDocSectionContent .IPM_Project_Document_Section__c ==projDocSec.ID,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
 
        ipmltask = IPM_TestFactory_Helper.createIPMTask(project.id,TRUE);
        
        System.Assert(ipmltask.IPM_Project__c==project.id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        PLIpmMiles = IPM_TestFactory_Helper.createIPMMilestone(project.id,TRUE);
        System.Assert(PLIpmMiles.IPM_Project__c==project.id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        ipmProjectResource = IPM_TestFactory_Helper.createIPMProjectResource(project.Id,FALSE);
        ipmProjectResource.IPM_User__c = psa.AssigneeId ;
        insert ipmProjectResource;
        System.Assert(ipmProjectResource.IPM_Project__c == project.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
       
        
        return ipmltask;
        
    }

    public static User  testRunAs() {
        
        List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg345434.com' ];
        User u = new User();
        
        if(usrname== null){
            // Setup test data
            // This code runs as the system user
            u = IPM_TestFactory_Helper.createUser(true);
            System.runAs(u) {
                PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = ps.Id;
                insert psa;
      
                // The following code runs as user 'u' 
              //  System.debug('Current User: ' + UserInfo.getUserName());
              //  System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            }
        }
        else {
            if(usrname!= null && !usrname.isEmpty()){
                u = [SELECT Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName, IPM_Category__c ,IPM_Brand_Positioning__c, IPM_Brand_Name__c ,IPM_Role__c , IPM_Sub_Category__c    from User where UserName='standarduser@testorg4.com' ]; 
            }     
        }   
        return u ;
    }
    
    public static String getTasksRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
}