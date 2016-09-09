/**
  @author : Cognizant
  @name : IPM_BD_BB_Report_Batch_Test
  @CreateDate : 25/07/2016
  @description : This test class will cover the functionality which have been covered in IPM_BD_BB_Report_Batch 
  @Version : 1.0
  @reference : IPM_BD_BB_Report_Batch
*/

@isTest
private class IPM_BD_BB_Report_Batch_Test {
<<<<<<< HEAD
    
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> lstFinancialYear=new List<IPM_Financial_Year__c>();
    public static List<IPM_Milestone__c> ipmMileStoneTestList=new List<IPM_Milestone__c>();
    public static List<IPM_Country__c> ipmcountrylist = new List<IPM_Country__c>();
    public static IPM_Reporting__c reportParameter;
    public static User testUser;
    public static List<User> userList;
    public static Id projid;
    public static set<id> projidset = new set<id>();
    public static final String YEAR_1 = 'Y1';
    public static final String GROSS = 'Gross';
    public static final String INCREMENTAL = 'Incremental';
    public static final String CALENDAR = 'Calendar';
<<<<<<< HEAD
    
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData1
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void initializeData1(){
        test.startTest(); 
              
            user systemAdmin= IPM_TestFactory_Helper.createUserAdmin(false);
            system.runAs(systemAdmin){
                testUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
                userList = IPM_TestFactory_Helper.createUserList(); 
                system.assertNotEquals(userList[0],null);
            }
            
            
            //Insert data for Custom setting
            reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting();
            List<IPM_Reporting__c>reportParameterlist=[SELECT Id FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
            system.assert(reportParameterlist[0].Id != null); //positive test
            
            Id projid;
            // Being used Below in Code. Sonar
           
            
            system.runAs(testUser)
            {
            
            //Test project creation
=======
    private static final string IPMUSER_LASTNAME='IPMUSER_LASTNAME';
    private static final string BD_BB_REPORT = 'BD BB Report';
    
     /**********************************************************************
    *  @Description: Test Method to create project data for the other test methods
    *  @name : createProject
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void createProject(){
      systemAdmin= IPM_TestFactory_Helper.createUserAdmin(false);
        system.runAs(systemAdmin){
            testUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
            userList = IPM_TestFactory_Helper.createUserList(); 
            system.assertEquals(userList[0].LastName,IPMUSER_LASTNAME,'Error in User Creation');
=======
	 
	 public static final String ASSERT_ERROR_STR = 'Projects not Created Properly.Actual size should be '; 
	 public static final String BD_BB_REPORT = 'BD BB Report';
	 
     @testSetup static void projectDataSetUp(){
        
        // Create an instance of admin user.
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
        User globalProjectLeader = null;
        // Create an instances of standard Users for Allocation to Project Leaders.
        System.runAs(adminUser)
        {
        	globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            localProjectLeader.lastname = 'LOCAL_PL'; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
         
            List<User> dbUserList =  [Select Id from User where id in :userList];
            System.assertEquals(dbUserList.size(),userList.size(),'Users not Created Properly.Actual no of Users should be'+userList.size());
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData(); 
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        }
        
        // Insert the project as a Global project Leader.
        System.runAs(globalProjectLeader)
        {
        	List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList;
            
            List<IPM_Project__c> dbProjectList =  [Select Id from IPM_Project__c where id in :projectList];
            System.assertEquals(dbProjectList.size(),projectList.size(),ASSERT_ERROR_STR+projectList.size());
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
        }
        
      }   
      
      public static testMethod void createProject(){
      	
      	// prepare custom setting data
	 	Decimal startYear = System.today().year();
        //Insert data for Custom setting
        List<IPM_Reporting__c> reportCSList = new List<IPM_Reporting__c>();
        
        IPM_Reporting__c reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting(BD_BB_REPORT, false);
        reportParameter.IPM_Start_Year__c = startYear;
        insert reportParameter;
        
        String strCSName = '';
        
        for(Integer i = 1; i < 7; i++){
            for(String strPhase : IPM_ConstantUtils.DEFAULT_PHASE_SEQ){
                strCSName = 'GKM' + String.valueOf(i) + IPM_ConstantUtils.HYPHEN_DELIMITER + strPhase;
                IPM_Reporting__c reportCS  = IPM_TestFactory_Helper.createIPMReportingCustomSetting(strCSName, false);
                reportCS.IPM_Start_Year__c = startYear;
                reportCSList.add(reportCS);
            }   
        }
        insert reportCSList;
      	
      	
        // Get the newly created Projects from Database. 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
        User globalProjectLeader = null;
        User regionalProjectLeader = null;
        
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
<<<<<<< HEAD
          //Test project creation
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            projectList = IPM_TestFactory_Helper.insertIPMProjectList();
            
            for(IPM_Project__c p:projectList){
                if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
                    p.IPM_Project_Type__c = IPM_Utils.Original;
                    p.IPM_Category_Text__c = IPM_ConstantUtils.HHC_CONSTANT;
                    p.IPM_Project_Leader__c = testUser.Id;
                    projid = p.Id;                  

                }
                if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
                    p.IPM_Project_Type__c = IPM_Utils.Rollout; 
                }
                if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
                    p.IPM_Project_Type__c = IPM_Utils.Rollout;
                }
                p.Project_External_ID__c = p.id + p.IPMProject_Span__c;
                projidset.add(p.id);                
            }
            update projectList;
            
<<<<<<< HEAD
            list<IPM_Project__c> projectListtest = new list<IPM_Project__c>([SELECT id FROM IPM_Project__c WHERE id IN:projectList Limit 100]);
            system.assertEquals(projectList.size(),projectListtest.size());
            
=======
            list<IPM_Project__c> projectListtest = new list<IPM_Project__c>([SELECT id,Name,IPMProject_Span__c FROM IPM_Project__c WHERE id IN:projectList Limit 100]);
            system.assertEquals(projectList[0].Name,projectListtest[0].Name,'Name doesnt matched');
      }
    }
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData1
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void initializeData1(){
              
       createProject();
       system.runAs(testUser){
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            List<IPM_Analytics__c> analyticsRecDelList = new list<IPM_Analytics__c>();
            for(IPM_Project__c projRec: projectList){
              IPM_Analytics__c analyticsRec =  new IPM_Analytics__c();
              analyticsRec.IPM_Project_Id__c = projRec.Id;
              analyticsRecDelList.add(analyticsRec);
=======
            if(lUser.lastName == 'GLOBAL_PL')
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == 'REGIONAL_PL')
            {
                regionalProjectLeader = lUser;
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            createProjectGlobal(projectNameSet, globalProjectIdList, projectMap,globalProjectLeader,regionalProjectLeader); 
        }
        Test.stopTest();
        
        List<IPM_Project__c> regionalProjects = new List<IPM_Project__c>();
        
        System.RunAs(globalProjectLeader)
        {
            Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);

            for(Id gbProjectId : globalToRegionalMap.keySet())
            {
               regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
            }
            
<<<<<<< HEAD
            //Test Finance data creation            
            lstFinancial = IPM_TestFactory_Helper.insertIPMFinancialList(true);
<<<<<<< HEAD
            list<IPM_Financial__c> insertedfinancialrecord = new list <IPM_Financial__c> ([SELECT id FROM IPM_Financial__c WHERE id IN:lstFinancial Limit 100]);
            system.assertEquals(insertedfinancialrecord.size(),lstFinancial.size());
=======
            
            map<Id,IPM_Financial__c> updatededFinancialrecord = new map <Id,IPM_Financial__c> ();
            list<IPM_Financial__c> insertedfinancialrecord = new list <IPM_Financial__c> ([SELECT id,Name,Target_Launch_Date__c,Parent_Project__c,Local_Project__c,Financial_External_ID__c,Regional_Project__c
                                                    FROM IPM_Financial__c WHERE id IN:lstFinancial Limit 100]);
=======
            List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c, IPMProject_Span__c, (Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
                
            for(IPM_Project__c regionalProject : DBRegionalProjects) 
            {
               Id parentGlobalProjectId = regionalProject.IPM_Parent_Project__c;
                
               IPM_Project__c parentGlobalProject = projectMap.get(parentGlobalProjectId);
                
               // Only Contract document Available at Regional Level.
               System.assertEquals(regionalProject.Project_Documents__r.size(),1,'Contract Document either doesnt have a document or has more document');
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'Milestones didnt copy from Parent Project Properly');
            }
        }
        
        /******************************** Regional Project Leader View for Regional Projects  ****************************************/
        System.RunAs(regionalProjectLeader)
        {
            // Update phase for Local Rollouts. 
            List<IPM_Project__c> regionalProjectsFR = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c, IPMProject_Span__c, (Select Id from Project_Documents__r),(Select Id from Regional_Project_Rollout__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
            
            for(IPM_Project__c regionalProject : regionalProjectsFR)
            {
                // Validate there is atleast one Task associated with Regional Project
                System.assert(regionalProject.Tasks__r.size()>0,'Tasks not generated by transaction management');
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,'Task complexity doesnt match Project complexity.');
                    System.assertEquals(task.IPM_Phase__c,regionalProject.IPM_Phase__c,'Task Phase is not equal to Project Phase');   
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0,'Milestones not present or not visible to Regional Project Leader');
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,'Regional has more financials than expected'); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility','Regional Project Phase not equal to feasiblity.'); // Phase would be feasibility for Regional Projects.
                
            }
        }
     	
     	     	 
		System.RunAs(globalProjectLeader){
			string  query = 'SELECT Id,IPM_Global_ProjectId__c, IPM_Project_Name__c, IPM_Parent_Project__r.IPM_project_name__c, IPM_Platform_Formula__c, BET__r.Name, BET__r.Owner.Name, BETCurrentStatus__c, Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Project_Rollout__r.name,IPM_Project_Rollout__r.Id,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_White_Space_Project__c,Is_Archieved__c,IPM_ProjectGKM__c,IPM_Complexity__c,IPM_Market__c,IPM_Sub_sector__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c WHERE IPM_Project_Name__c != null' ;
			IPM_BD_BB_Report_Batch  batchs = new IPM_BD_BB_Report_Batch(query); 
			database.executebatch(batchs,100);
            batchs.calculateCPP(10000, 200000);  
            batchs.calculateCPP(8000, 1000000); 
            batchs.calculateCPP(8000, 2000000);
            batchs.calculateCPP(1000, 2000000);
            batchs.calculateCPP(200, 150000);   
            batchs.calculateCPP(100, 150000); 
            batchs.calculateCPP(100, null);
		}
     	
      }
 	
 	public static void createProjectGlobal(set<String> projectNameSet, List<Id> globalProjectIdList, Map<Id,IPM_Project__c> projectMap,User globalProjectLeader,User regionalProjectLeader){
         
         	List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            
            for(IPM_Project__c project : projectList)
            {
            	project.IPM_Fast_Track_Project__c= true;
                projectMap.put(project.Id,project);
            }
            
<<<<<<< HEAD
            system.assertEquals(insertedfinancialrecord[0].Target_Launch_Date__c,lstFinancial[0].Target_Launch_Date__c,'Project Financials TLD differs');
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

            //Test Financial Year Data creation/update
            lstFinancialYear = IPM_TestFactory_Helper.insertIPMFinancialYearList();
            list<IPM_Financial_Year__c> insertedfinancialyrrecord = new list <IPM_Financial_Year__c> ([SELECT id FROM IPM_Financial_Year__c WHERE id IN:lstFinancialYear Limit 100]);
            system.assertEquals(insertedfinancialyrrecord.size(),lstFinancialYear.size());
            
            //Test Milestone Data Creation/Update
            Id mileMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
            ipmMileStoneTestList = IPM_TestFactory_Helper.createIPMMilestoneList(false, 7);
                          
            for(Integer i = 0; i < ipmMileStoneTestList.size(); i++){
                
                ipmMileStoneTestList[i].IPM_Due_Date__c = system.today() + i;                
                ipmMileStoneTestList[i].IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
                ipmMileStoneTestList[i].recordtypeid = mileMRecordType;
                ipmMileStoneTestList[i].IPM_Project__c = projid;
                ipmMileStoneTestList[i].IPM_Due_Date__c = system.today() + 30;          
                ipmMileStoneTestList[i].IPM_Proposed_Date__c = system.today() + 60;
                ipmMileStoneTestList[i].IPM_Completed_on__c = system.today() + 90;
                ipmMileStoneTestList[i].IPM_Name__c = projid + string.valueof(i); 
                                          
                if(i==0){
                	 ipmMileStoneTestList[0].IPM_Type_of_gate__c = IPM_Utils.Charter; 
                }          
                if(i==1) {
                	ipmMileStoneTestList[1].IPM_Type_of_gate__c = IPM_Utils.Contract;
                }
                if(i==2){
                	 ipmMileStoneTestList[2].IPM_Type_of_gate__c = IPM_Utils.MarketReady;
                }
                
                if(i==3){
                	 ipmMileStoneTestList[3].IPM_Type_of_gate__c = IPM_Utils.MarketDeployment;
                }
                if(i==4) {
                	ipmMileStoneTestList[4].IPM_Name__c = IPM_Utils.TargetLaunchDateShiptoTrade;
                }
                
                if(i==5) {
                	ipmMileStoneTestList[5].IPM_Name__c = IPM_ConstantUtils.BET_MS_FIRST_RELEASE;
                }
                	
                if(i==6) {
                	ipmMileStoneTestList[6].IPM_Name__c = IPM_ConstantUtils.BET_MS_FINAL_RELEASE;
                }
            }

            insert ipmMileStoneTestList;
            List<IPM_Milestone__c> ipmMileStoneTestListtest = new List<IPM_Milestone__c>([SELECT Id FROM IPM_Milestone__c where id IN:ipmMileStoneTestList limit 100]);
            system.assert(ipmMileStoneTestListtest.size() == 7); //positive test 
            
            //Test Country Data Creation/Update    
            //Insert Geography
            MDO_Geography__c geo = IPM_TestFactory_Helper.createMDOGeography(false);
            geo.Name='TestRegion';
            geo.geography_type__c='Cluster';
            Insert geo;
            List<MDO_Geography__c> geolist = new List<MDO_Geography__c>([SELECT Id FROM MDO_Geography__c where id =: geo.id limit 1]);
            system.assertEquals(geolist[0].id, geo.id, 'Error in Geography Creation'); //positive test
            }  
        test.stopTest();
    }
    
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData2
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void initializeData2(){
<<<<<<< HEAD
        test.startTest();
        user systemAdmin= IPM_TestFactory_Helper.createUserAdmin(false);
            system.runAs(systemAdmin){
                testUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
                userList = IPM_TestFactory_Helper.createUserList(); 
                system.assertNotEquals(userList[0],null);
            }
        //Insert data for Custom setting
            reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting();
            List<IPM_Reporting__c>reportParameterlist=[SELECT Id FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
            system.assert(reportParameterlist[0].Id != null); //positive test
            
        system.runAs(testUser ){
         
        
        List<IPM_Project__c> globalprojectlist = new List<IPM_Project__c>();
            //Test project creation
            projectList = IPM_TestFactory_Helper.insertIPMProjectList();                      
            id projid;          
=======
      
      createProject();
        system.runAs(testUser){
          
          List<IPM_Project__c> globalprojectlist = new List<IPM_Project__c>();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            for(IPM_Project__c p:projectList){
              if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
                globalprojectlist.add(p);  
              }
            }
<<<<<<< HEAD
            update projectList;
            
            list<IPM_Project__c> projectListtest = new list<IPM_Project__c>([SELECT id FROM IPM_Project__c WHERE id IN:projectList Limit 100]);
            system.assertEquals(projectList.size(),projectListtest.size());
            
        // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalprojectlist,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
            list<IPM_Project_Rollout__c> insertedregionalRolloutrecords = new list <IPM_Project_Rollout__c> ([SELECT id FROM IPM_Project_Rollout__c WHERE id IN:regionalRolloutList Limit 100]);
            system.assertEquals(insertedregionalRolloutrecords.size(),regionalRolloutList.size());
=======
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalprojectlist,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
            //check regional rollouts have been created
            list<IPM_Project_Rollout__c> insertedregionalRolloutrecords = new list <IPM_Project_Rollout__c> ([SELECT id,Name FROM IPM_Project_Rollout__c WHERE id IN:regionalRolloutList Limit 100]);
            system.assertEquals(insertedregionalRolloutrecords[0].Name,regionalRolloutList[0].Name,'Project Regional Rollout Name differs');
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            
=======
            IPM_ProjectHelper.copyOverMPAValue(projectMap);
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
        
            // Get Standard Milestones from database  
            System.assert(standardMileStoneMap.values().size() > 0,'Project Milestones not generated');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'Project Documents dont match the actual Documents');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,'Complexity doesnt match the Original Complexity');     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),'Project Milestones not equal to Master Milestones');
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,'Project Documents dont match the actual Documents'); // One for Global consolidated Financials
                
                // Project default phase would always be set as IDEAS.
                System.assertEquals(project.IPM_Phase__c,'Ideas','Project not equal to Ideas'); // Phase would be always ideas for Global Project.
            }
              
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            insert regionalRolloutList;
            
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
            Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
            for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
            {
                List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
            }
            
            // Create local Rollouts for Created regional Rollouts.
<<<<<<< HEAD
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
            insert localRolloutList;
<<<<<<< HEAD
            list<IPM_Project_Rollout__c> insertedlocalRolloutrecords = new list <IPM_Project_Rollout__c> ([SELECT id FROM IPM_Project_Rollout__c WHERE id IN:localRolloutList Limit 100]);
            system.assertEquals(insertedlocalRolloutrecords.size(),localRolloutList.size());             
=======
            
            //check local rollouts have been created 
            list<IPM_Project_Rollout__c> insertedlocalRolloutrecords = new list <IPM_Project_Rollout__c> ([SELECT id,Name FROM IPM_Project_Rollout__c WHERE id IN:localRolloutList Limit 100]);
            system.assertEquals(insertedlocalRolloutrecords[0].Name,localRolloutList[0].Name,'Project Local Rollout differs');             
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
                        
=======
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
             
            insert localRolloutList; 
           
            List<IPM_Project_Rollout__c> dbRolloutList =  [Select Id from IPM_Project_Rollout__c where id in :localRolloutList];
            System.assertEquals(dbRolloutList.size(),localRolloutList.size(),ASSERT_ERROR_STR+localRolloutList.size());
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AF'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);    
                
                countryList.add(tempCountry);
<<<<<<< HEAD
             }
              
             insert countryList;
             list<IPM_Country__c> insertedcountryrecords = new list <IPM_Country__c> ([SELECT id FROM IPM_Country__c WHERE id IN:countryList Limit 100]);
             system.assertEquals(insertedcountryrecords.size(),countryList.size());             
             
             
            //Insert Financial records for rollouts
            List<IPM_Financial__c> finList = new List<IPM_Financial__c>();
            String strRecordTypeConId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
            
            IPM_Financial__c finRegional = new IPM_Financial__c();      
            finRegional.Parent_Project__c = projid;
            finRegional.IPM_Project_Rollout__c = regionalRolloutList[0].id;
            finRegional.RecordTypeId = strRecordTypeConId;
            finRegional.Financial_External_ID__c = regionalRolloutList[0].name+IPM_Utils.CONSOLIDATED;
            finRegional.Target_Launch_Date__c = System.today()+100000;
            finList.add(finRegional);
            
            IPM_Financial__c finlocal = new IPM_Financial__c();
            finRegional.Parent_Project__c = projid;
            finlocal.IPM_Project_Rollout__c = localRolloutList[0].id;
            finlocal.RecordTypeId = strRecordTypeConId;
            finlocal.Financial_External_ID__c = localRolloutList[0].name;
            finlocal.Target_Launch_Date__c = System.today()+100000;
            finList.add(finlocal);
            
            insert finList;
            
            list<IPM_Financial__c> insertedfinancialrolloutrecords = new list <IPM_Financial__c> ([SELECT id FROM IPM_Financial__c WHERE id IN:finList Limit 100]);
            system.assertEquals(insertedfinancialrolloutrecords.size(),finList.size());
=======
            }
            
            insert countryList;
            List<IPM_Country__c> dbCountryList =  [Select Id from IPM_Country__c where id in :countryList];
            System.assertEquals(dbCountryList.size(),countryList.size(),ASSERT_ERROR_STR+countryList.size());
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
            
            /******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
            
            
<<<<<<< HEAD
            //For Local Rollouts
            IPM_Financial_Year__c finYear5 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear5.IPM_Financial__c= finList[1].Id;
            finYear5.Name = YEAR_1;
            finYear5.year__c = INNOVATION;
            finYear5.PL_type__C = GROSS;
            finYear.add(finYear5);
            IPM_Financial_Year__c finYear6 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear6.IPM_Financial__c= finList[1].Id;
            finYear6.Name = YEAR_1;
            finYear6.year__c = INNOVATION;
            finYear6.PL_type__C = INCREMENTAL;
            finYear.add(finYear6);            
            IPM_Financial_Year__c finYear7 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear7.IPM_Financial__c= finList[1].Id;
            finYear7.Name = YEAR_1;
            finYear7.year__c = CALENDAR;
            finYear7.PL_type__C = GROSS;
            finYear.add(finYear7);            
            IPM_Financial_Year__c finYear8 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear8.IPM_Financial__c= finList[1].Id;
            finYear8.Name = YEAR_1;
            finYear8.year__c = CALENDAR;
            finYear8.PL_type__C = INCREMENTAL;
            finYear.add(finYear8);
            insert finYear;         
             
            list<IPM_Financial_Year__c> insertedfinancialyrrolloutrecords = new list <IPM_Financial_Year__c> ([SELECT id FROM IPM_Financial_Year__c WHERE id IN:finYear Limit 100]);
            system.assertEquals(insertedfinancialyrrolloutrecords.size(),finYear.size());
        
        }
        test.stopTest();
    }
        
    
    static testMethod void testBDBBreport1() { 
        initializeData1();            
        system.runAs(testUser){
            string query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Member__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c, CreatedDate FROM IPM_Project__c WHERE Is_Archieved__c = false'; 
            IPM_BD_BB_Report_Batch  batchs = new IPM_BD_BB_Report_Batch(query); 
<<<<<<< HEAD
            database.executebatch(batchs,100);
        }   
        system.assertequals(system.now().day(),reportParameter.Last_Batch_RunDate__c.day(),'Error in Batch Last run date update - initializeData1 Method');            
=======
            database.executebatch(batchs,100);  
            
            string cppRec ;
            cppRec = batchs.calculateCPP(40000.00, 400000000.00);
            system.assertequals(cppRec,'Gold','CPP value is not Gold'); 
            
            cppRec = batchs.calculateCPP(2.00, 1000.00);
            system.assertequals(cppRec,'Silver','CPP value is not SILVER'); 
            
            cppRec = batchs.calculateCPP(0.20, 1000.00);
            system.assertequals(cppRec,'Bronze','CPP value is not BRONZE'); 
=======
             // Set GateKeeping Model as RCLT and start with Regional Project Creation.
            for(IPM_Project__c project : projectList)
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            }  
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
            
            update projectList;
            
            for(IPM_Project__c project : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            
<<<<<<< HEAD
        }  
         
        List<IPM_Reporting__c>reportParameterlist1=[SELECT Id, Last_Batch_RunDate__c FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
        system.assertequals(reportParameterlist1[0].Last_Batch_RunDate__c.day(),reportParameter.Last_Batch_RunDate__c.day(),'Error in Batch Last run date update - initializeData2 Method');            
        Test.stopTest();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    }
        static testMethod void testBDBBreport2() { 
        initializeData2();            
        system.runAs(testUser){
            string query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Member__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate FROM IPM_Project__c WHERE Is_Archieved__c = false'; 
            IPM_BD_BB_Report_Batch  batch = new IPM_BD_BB_Report_Batch(query); 
            database.executebatch(batch,100);
        }   
        system.assertequals(system.now().day(),reportParameter.Last_Batch_RunDate__c.day(),'Error in Batch Last run date update - initializeData2 Method');            
    }
    
    
=======
            update projectListPhaseChange;
     }
 	     
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
}