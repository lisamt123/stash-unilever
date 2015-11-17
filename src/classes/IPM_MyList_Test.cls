/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for IPM_MyList class functionalities
*/


@istest
public class IPM_MyList_Test{
    
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static IPM_Bosscard__c bosscard;
    public static IPM_Task__c ipmltask;
    public static IPM_Milestone__c milestones;
    public static IPM_Questionnaire__c questionaire;
    public static IPM_Project_Document_Section_Content__c  proDocSecCon;
    public static IPM_MyList taskListTest = new IPM_MyList();
    public static User user1;
    public static User user2;
    
    /*
    * @description For Running Test Script
    */ 
    public static testmethod void myListTest(){
        list<IPM_Task__c> tskList= initializedData1();
        IPM_Task__c ipmTask= tskList[0];
   		IPM_MyList ipm = new IPM_MyList();
   		
        Test.startTest();
	        ipm.toggleSortAssignees();
	      //  ipm.filteredPhase();
	        //ipm.filteredUser();
	        ipm.deleteTask();
	        ipm.setTaskId(string.valueof(ipmTask.id));
	        ipm.markComplete();
	        ipm.project();
	     //   ipm.bosscard();
	        
	        ipm.setprojectName('test proj');
	        String prName=ipm.getprojectName();
	        System.Assert(prName == 'test proj',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
	        
	        ipm.setcategoryName('cat1');
	        String catName=ipm.getcategoryName();
	        System.Assert(catName == 'cat1',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
	        
	        ipm.setbrandName('br1');
	        String bName=ipm.getbrandName();
	        System.Assert(bName == 'br1',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
	        
	        ipm.setPhase('test');
	        String pValue=ipm.getPhase();
	        System.Assert(pValue  == 'test',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
	        
	        ipm.setUser('Sample');
	        String uName=ipm.getUser();
	        System.Assert(uName == 'Sample',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
	        
	        //ipm.filteredProject();
	        ipm.toggleSortSections();
	        ipm.toggleSortTasks();
	       // ipm.filterCompleteTasks();
	        ipm.toggleSortPhases();
	        ipm.toggleDueDate();
	      //  ipm.projectSearch();
	        ipm.toggleSortCompletion();
	       // ipm.filteredBrand();
	        ipm.showAllNextSevenDays();
	       // ipm.filteredCategory();
	        ipm.getTaskId();
	        //ipm.First();
	        //ipm.Last();
	        //ipm.Previous();
	        //ipm.Next();  
	        ipm.filteredProjectReset();
	        ipm.filterCompleteTasksReset();
	        ipm.filterProject();
        Test.stopTest();
    }
    /*creat user with permission set*/
    static User createUserWithPermissionSet(){ 
    	PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
        User users = new User();
        users = IPM_TestFactory_Helper.createUser(true);
        System.runAs(users) {
            psa.AssigneeId = users.Id;
            psa.PermissionSetId = permissionSet.Id;
            insert psa;
        }
        return users;
    }
    /*
    * @description For Initializing the data
    */ 
    static list<IPM_Task__c>  initializedData1() {
       /* list<IPM_Project__share  > listproshare  = new list<IPM_Project__share>();
        list<IPM_Project_Document__share  > proDocShareList  = new list<IPM_Project_Document__share  >();
        list<IPM_Project_Document_Section__Share> proDocSecShList  = new list<IPM_Project_Document_Section__Share>();
        list<IPM_Task__Share>proTaskShareList = new list<IPM_Task__Share>();
        list<IPM_Milestone__Share>proMileShareList = new list<IPM_Milestone__Share>();
        list<IPM_Bosscard__Share>bossShareList = new list<IPM_Bosscard__Share>();
        list<IPM_Questionnaire__Share > quesShareList  = new list<IPM_Questionnaire__Share >();
        list<IPM_Project_Document_Section_Content__share  > proDocSecConShare  = new list<IPM_Project_Document_Section_Content__share  >();*/
        list<IPM_Task__c> taskTest = new list<IPM_Task__c> ();
        
        /*IPM_Project__share  proshare = (IPM_Project__share)IPM_TestFactory_Helper.createShareObject('IPM_Project__share');
        IPM_Project_Document__share  proDocShr = (IPM_Project_Document__share)IPM_TestFactory_Helper.createShareObject('IPM_Project_Document__share');
        IPM_Project_Document_Section__Share  proDocSecShr = (IPM_Project_Document_Section__Share)IPM_TestFactory_Helper.createShareObject('IPM_Project_Document_Section__Share');
        IPM_Bosscard__Share bossShare=(IPM_Bosscard__Share)IPM_TestFactory_Helper.createShareObject('IPM_Bosscard__Share');
        IPM_Questionnaire__Share quesShr = (IPM_Questionnaire__Share)IPM_TestFactory_Helper.createShareObject('IPM_Questionnaire__Share');
        IPM_Project_Document_Section_Content__share  proDocSecConShr = (IPM_Project_Document_Section_Content__share)IPM_TestFactory_Helper.createShareObject('IPM_Project_Document_Section_Content__share');
        IPM_Milestone__Share milesShare=(IPM_Milestone__Share)IPM_TestFactory_Helper.createShareObject('IPM_Milestone__Share'); */
		
		user1 = createUserWithPermissionSet();
        user2 = createUserWithPermissionSet();
        
        projTempl = IPM_TestFactory_Helper.createIPMProjectTemplate(true);
        
        ipdt = IPM_TestFactory_Helper.creteIPMDocumentTemplate(false);
        ipdt.IPM_Project_Template__c=projTempl.ID;
        insert ipdt;
        
        secMst = IPM_TestFactory_Helper.createIPMSection(false);
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Name__c=IPM_ConstantUtils.PHASE_IDEAS;
        insert secMst;
        System.assert(secMst.IPM_Section_Name__c == IPM_ConstantUtils.PHASE_IDEAS,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        
        String gateName = 'TEST GATE 1';
        bosscard = IPM_TestFactory_Helper.createIPMBosscard(false);
        bosscard.Name= gateName;
        insert bosscard;
        System.Assert(bosscard.Name == gateName,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        project = IPM_TestFactory_Helper.createIPMProject(false);
        project.IPM_Bosscard__c=Bosscard.id;

        project.IPM_Technical_Project_Leader__c =user1.Id;
        project.IPM_Project_Leader__c = user1.Id;
        project.Deputy_Project_Leader__c = user1.Id;
        project.IPM_Project_Gatekeeper__c = user1.Id;
        project.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
        insert project; 
        System.assert(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        system.debug('*****project'+project);
        
        projTemp = IPM_TestFactory_Helper.createIPMProjectTemplate(true);
        
        projDoc = IPM_TestFactory_Helper.createIPMProjectDocument(false);
        projDoc.IPM_Project__c=project.Id;
        projDoc.IPM_Project_Template__c=projTemp.Id;
        insert projDoc;     
        System.Assert(projDoc.IPM_Project__c == project.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        System.Assert(projDoc.IPM_Project_Template__c==projTemp.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);        
        
        projDocSec = IPM_TestFactory_Helper.createIPMProjectDocumentSection(false);
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec; 
        System.Assert(projDocSec.IPM_Project_Document__c==projDoc.ID,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        proDocSecCon =  new IPM_Project_Document_Section_Content__c ();
        proDocSecCon .IPM_Project_Document_Section__c =projDocSec.Id;
        insert proDocSecCon ;
        System.Assert(proDocSecCon.IPM_Project_Document_Section__c == projDocSec.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);

        for(integer i=0 ;i<4 ;i++){
    		IPM_Task__c ipmTask= IPM_TestFactory_Helper.createIPMTask(project.id, false);
    		ipmTask.name='testTask'+i;
    		ipmTask.IPM_Project_Document_Section__c = projDocSec.id;
            ipmTask.IPM_Phase__c = project.IPM_Phase__c;
    		taskTest.add(ipmTask);
    	}
    	insert taskTest;
        
        milestones = IPM_TestFactory_Helper.createIPMMilestone(project.id, false);
        milestones.name='testtas25778k';
        insert milestones; 
        System.Assert(milestones.name=='testtas25778k',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        IPM_Project_Resource__c  proRes = IPM_TestFactory_Helper.createIPMProjectResource(project.Id, false);
        proRes.IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
        proRes.IPM_Project_Role_Owner__c = true;
        proRes.IPM_User__c = user1.id ;
        insert proRes;
        System.Assert(proRes.IPM_Project__c == project.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        questionaire = (IPM_Questionnaire__c) IPM_TestFactory_Helper.createIPMQuestionnaire(project.id,TRUE);
        
        /*Share insertion*/
        /*bossShare.parentid=Project.IPM_Bosscard__c;
        bossShare.accesslevel=IPM_ConstantUtils.EDIT_ACCESS;
        bossShare.userorgroupid = user1.id;
        bossShareList.add(Bossshare); 
        insert bossShareList;
        System.Assert(Bossshare.parentid== Project.IPM_Bosscard__c,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        milesShare.ParentId= milestones.Id;
        milesShare.userOrGroupId = user1.id;
        milesShare.accesslevel = IPM_ConstantUtils.EDIT_ACCESS;
        proMileShareList.add(milesShare);
        insert proMileShareList;
        System.Assert(milesShare.userOrGroupId == user1.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME); 
        
        list<IPM_Task__c> ipmTaskList = [SELECT Id FROM IPM_Task__c ];
        for(IPM_Task__c task: ipmTaskList){
        	IPM_Task__Share proTskShare = (IPM_Task__Share)IPM_TestFactory_Helper.createShareObject('IPM_Task__Share');
	        proTskShare.ParentId= task.Id;
	        proTskShare.userOrGroupId = user1.id;
	        proTskShare.accesslevel = IPM_ConstantUtils.EDIT_ACCESS;
	        proTaskShareList.add(proTskShare);
        }
        insert proTaskShareList;
        
        proshare.ParentId= project.Id;
        proshare.userOrGroupId = user1.id;
        proshare.accesslevel = IPM_ConstantUtils.EDIT_ACCESS;
        listproshare.add(proshare);
        insert listproshare  ;
        System.Assert(proshare.ParentId== project.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        proDocShr.ParentId= projDoc.Id;
        proDocShr.userOrGroupId = user1.id ;
        proDocShr.accesslevel = IPM_ConstantUtils.EDIT_ACCESS;
        proDocShareList.add(proDocShr);
        insert proDocShareList  ;
        System.Assert(proDocShr.ParentId== projDoc.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        proDocSecShr.ParentId= projDocSec.Id;
        proDocSecShr.userOrGroupId = user1.id ;
        proDocSecShr.accesslevel = IPM_ConstantUtils.EDIT_ACCESS;
        proDocSecShList.add(proDocSecShr);
        insert proDocSecShList  ;
        System.Assert(proDocSecShr.ParentId== projDocSec.Id,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        quesShr.ParentId= questionaire.Id;
        quesShr.userOrGroupId = user1.id ;
        quesShr.accesslevel = IPM_ConstantUtils.EDIT_ACCESS;
        quesShareList.add(quesShr);
        insert quesShareList;
        
        proDocSecConShr.ParentId= proDocSecCon.Id;
        proDocSecConShr.userOrGroupId = user1.id ;
        proDocSecConShr.accesslevel = IPM_ConstantUtils.EDIT_ACCESS;
        proDocSecConShare.add(proDocSecConShr );
        insert proDocSecConShare  ; */
        
        return taskTest;
    }
    
    /*
    * @description For Running Test Script
    */   
    public static User  testRunAs() {
        List<User> usrname = [SELECT UserName from User where UserName='standarduser@toop23.com' ];
        User user3 = new User();
        if(usrname == null){
            // Setup test data
            // This code runs as the system user
           user3 = IPM_TestFactory_Helper.createUser(true);
            System.runAs(user3) {
                PermissionSet perSet = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
                PermissionSetAssignment perSetAss = new PermissionSetAssignment();
                perSetAss.AssigneeId = user3.Id;
                perSetAss.PermissionSetId = perSet.Id;
                insert perSetAss;
                // The following code runs as user 'user3' 
                System.debug('Current User: ' + UserInfo.getUserName());
                System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            }
        }
        else {
            if(usrname != null && !usrname.isEmpty()){
                user3 = [SELECT Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName, IPM_Category__c ,IPM_Brand_Positioning__c, IPM_Brand_Name__c ,IPM_Role__c , IPM_Sub_Category__c    from User where UserName='standarduser@testorg4.com' ];     
            }     
        }   
        return user3 ;
    }
	/*test cases for open task*/
    public static testmethod void myTaskOpenTest(){
    	Test.startTest();
	    	list<IPM_Task__c> overdueTask;
	    	list<IPM_Task__c> todayTask;
	    	list<IPM_Task__c> sevendaysTask;
	    	list<IPM_Task__c> laterTask;
	    	list<IPM_Task__c> overdueTaskQuery;
	    	list<IPM_Task__c> todayTaskQuery;
	    	list<IPM_Task__c> sevenDaysQry;
	    	list<IPM_Task__c> laterTaskQuery;
	    	list<IPM_Task__c> completedTask;
	    	list<Date> setDate =  new list<Date>{system.Today().addDays(-14),system.Today(),system.Today().addDays(5),system.Today().addDays(14)};
	    	list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
	    	list<IPM_Task__c> updatedTaskTest = new list<IPM_Task__c> ();
	    	
	    	insertTask = initializedData1();
	    	for(integer i=0 ;i<4 ;i++){
	    		IPM_Task__c ipmTask= insertTask[i];
	    		ipmTask.IPM_Due_Date1__c = setDate[i];
	    		ipmTask.IPM_Completed__c = false;
	    		updatedTaskTest.add(ipmTask);
	    	}
	    	update updatedTaskTest;
	    	
	    	overdueTask = taskListTest.getOverduetasksSample();
	    	todayTask = taskListTest.getprojectTaskssample();
	    	sevendaysTask = taskListTest.getNextSevenTasks();
	    	laterTask = taskListTest.getLaterTasks();
	    	completedTask = taskListTest.getcompletedTasks();
	    	taskListTest.showAllOverDue();
	    	taskListTest.todayTasksize();
	    	taskListTest.showAllNextSevenDays();
	    	taskListTest.showAllLaterTasks();
	    	
	    	system.assertEquals(completedTask.size(),0);
	    	
	    	overdueTaskQuery = [SELECT Id,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Due_Date1__c =:system.Today().addDays(-14)];
	    	system.assertEquals(overdueTask[0].id,overdueTaskQuery[0].id);
	    	system.assertEquals(overdueTask.size(),overdueTaskQuery.size());
	    	
	    	todayTaskQuery = [SELECT Id,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Due_Date1__c =:system.Today()];
	    	system.assertEquals(todayTask[0].id,todayTaskQuery[0].id);
	    	system.assertEquals(todayTask.size(),todayTaskQuery.size());
	    	
	    	sevenDaysQry = [SELECT Id,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Due_Date1__c =:system.Today().addDays(5)];
	    	system.assertEquals(sevendaysTask[0].id,sevenDaysQry[0].id);
	    	system.assertEquals(sevendaysTask.size(),sevenDaysQry.size());
	    	
	    	laterTaskQuery = [SELECT Id,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Due_Date1__c =:system.Today().addDays(14)];
	    	system.assertEquals(laterTask[0].id,laterTaskQuery[0].id);
	    	system.assertEquals(laterTask.size(),laterTaskQuery.size());
    	Test.stopTest();
    	
    }
    /*test cases for completed task*/
    public static testmethod void myTaskCompletedTest(){
    	Test.startTest();
	    	list<IPM_Task__c> overdueTask;
	    	list<IPM_Task__c> todayTask;
	    	list<IPM_Task__c> sevendaysTask;
	    	list<IPM_Task__c> laterTask;
	    	list<IPM_Task__c> completedTask;
	    	list<Date> setDate =  new list<Date>{system.Today().addDays(-14),system.Today(),system.Today().addDays(5),system.Today().addDays(14)};
	    	list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
	    	list<IPM_Task__c> updatedTaskTest = new list<IPM_Task__c> ();
	    	
	    	insertTask = initializedData1();
	    	for(integer i=0 ;i<4 ;i++){
	    		IPM_Task__c ipmTask= insertTask[i];
	    		ipmTask.IPM_Due_Date1__c = setDate[i];
	    		ipmTask.IPM_Completed__c = true;
	    		updatedTaskTest.add(ipmTask);
	    	}
	    	update updatedTaskTest;
	    	
	    	overdueTask = taskListTest.getOverduetasksSample();
	    	todayTask = taskListTest.getprojectTaskssample();
	    	sevendaysTask = taskListTest.getNextSevenTasks();
	    	laterTask = taskListTest.getLaterTasks();
	    	completedTask = taskListTest.getcompletedTasks();
	    	taskListTest.showCompletedTasks();
	    	
	    	system.assertEquals(completedTask.size(),4);
	    	system.assertEquals(overdueTask.size(),0);
	    	system.assertEquals(todayTask.size(),0);
	    	system.assertEquals(sevendaysTask.size(),0);
	    	system.assertEquals(laterTask.size(),0);
	    	
    	Test.stopTest();
    }
    /*logged in user can view task where he is the owner*/
    public static testmethod void taskVisibilityPositiveTest(){
    	list<IPM_Task__c> taskList = new list<IPM_Task__c> ();
	    taskList = initializedData1();
	    system.assertEquals(taskList.size()>0,true);
	    
	    PageReference pgRef = Page.IPM_MyToDoList;   
        Test.setCurrentPage(pgRef);
        list<IPM_Task__c> taskTest = [SELECT Id FROM IPM_Task__c];
        //system.debug('*****taskTest11'+taskTest);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(taskTest);
        list<IPM_Task__c>updatedTaskTest = ssc.getRecords();
        //system.debug('*******updatedTaskTest11'+updatedTaskTest);
        system.assertEquals(updatedTaskTest.size(),4); 
    }   
    /*logged in user can not view task where he is not the owner*/
	public static testmethod void taskVisibilityNegativeTest(){  
	  	list<IPM_Task__c> taskList = initializedData1();
	  	system.assertEquals(taskList.size()>0,true);
	  	 
	    user2 = IPM_TestFactory_Helper.createUser(true);
	    
        System.runAs(user2) {
          PageReference pgRef = Page.IPM_MyToDoList;   
          Test.setCurrentPage(pgRef);
          list<IPM_Task__c> taskTest = [SELECT Id FROM IPM_Task__c];
          //system.debug('*****taskTest22'+taskTest);
          ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(taskTest);
          list<IPM_Task__c>updatedTaskTest = ssc.getRecords();
          //system.debug('*******updatedTaskTest22'+updatedTaskTest);
          system.assertEquals(updatedTaskTest.size(),0);  
        }
    
    }  
    /* task with project approch is external */
    public static testmethod void projectWithExternalApprochTest(){ 
     	user1 = createUserWithPermissionSet();
     	list<IPM_Task__c>  taskList = initializedData1();
     	system.assertEquals(taskList.size()>0,true);
     	
     	list<IPM_Project__c> projList = [SELECT Id,IPM_PM_Approach__c FROM IPM_Project__c WHERE Id =: taskList[0].IPM_Project__c];
     	projList[0].IPM_PM_Approach__c = 'External' ;
     	update projList[0];
     	
     	System.runAs(user1) {
     		IPM_MyList ipm = new IPM_MyList();
     		ipm.showCompletedTasks();
     		System.assert(ipm != null);
     	}
     }
    
}