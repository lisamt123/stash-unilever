@isTest
private class IPM_FinancialControllerRegional_Test {

    private static final string LIT_OPERATIONAL = 'Operational';
    private static final integer EXEC_PART_3 = 3;
    private static final integer EXEC_PART_4 = 4;
    private static final integer EXEC_PART_6 = 6;
    private static final string INVALID_INDEX = 'Invalid index found';
    private static final string INVALID_PROJECT_NAME = 'Invalid project name';
    private static final string INVALID_SPAN_NAME = 'Invalid span name';
    private static final string INVALID_PROJECT_TYPE = 'Invalid project type';
    private static final string INVALID_FINACIAL_EXT_ID = 'Invalid Financial external id';
    private static final string MISALINGNED_NOT_CONFIRMED = 'Misaligned confirmation not found';
    private static final string INCORRECT_NAVIGATION_RESULT = 'Incorrect Navigation found';
    private static final string ERROR_MSG_NOT_CAPTURED = 'error message not captured';
    private static final string BLANK_STRING = IPM_ConstantUtils.IPM_SPACE;
    private static Set<String> regionalProjectNameSet = new Set<String>{'TestRegionalComments1','TestOperationalCommentsglobal1','TestOperationalCommentslocal1','TestOperationalCommentsregional1'};
    private static final string TLDNullMsg = 'TLD not set properly';
    private static final string showNextMsg = 'Financial year is to be navigated to left(Next)';
    private static final string showPreviousMsg = 'Financial year is to be navigated to right(Previous)'; 

    @testSetup public static void createRegionalOriginalProject()
     {
        List<IPM_Project_Rollout__c> localRolloutList; 
        List<User> userList = new List<User>();

        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
         	Test.startTest();
            //This creates Regional original project. But we need rollout projects also and financial
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);
            regionalProjectLeader.email = 'regionalUser@unilever.test.com';
            update regionalProjectLeader;
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);
            userList = new List<User>{regionalProjectLeader,localProjectLeader};
        }

        // Create Company Card information(Master Data)
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        IPM_TestFactory_Helper.getProjectMasterData();

        IPM_TestFactory_Helper.shareMasterProject(new List<User>{userList[0]}); 

        System.runAs(userList[0])
        { 
            

            List<IPM_Project__c> regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(1,UserList[0]); 
            regionalProjectList[0].IPM_Phase__c = 'Ideas';
            
            insert regionalProjectList;
            
          

            /******************************** Create Local Rollouts for Created Regional Original project ****************************************/
            
            // Create local Rollouts for Created regional Rollouts.
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsOriginalList(false,regionalProjectList,new List<User>{userList[0]});   
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true; 
                localRollout.IPM_Regional_PL__c = userList[1].Id;
            }
             
            insert localRolloutList;

            System.debug('getQueries7>>'+Limits.getQueries());

            //assert is done on size. Avoding SOQLs here as this method has lots of queries and can hit gov limit.
            system.assert(localRolloutList.size()>0, 'local rollouts not created');
           
            // Create Country specific information.
            List<IPM_Country__c> countryList = new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = 'AG').Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);                    
                countryList.add(tempCountry);
            }
            insert countryList;

            system.assert(countryList.size()>0,'countries record not created');//Avoiding SOQL for further asserts
            
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(new List<Id>{regionalProjectList[0].Id},userList[0]); 

            update projectListPhaseChange;
			Test.stopTest(); 
                   
        }
     }

    private static pageReference setPage(Id id){ 
        PageReference pageRef = Page.IPM_Financial;
        pageRef.getParameters().put('id', id);
        Test.setCurrentPageReference(pageRef);
        return pageref;
    }
    
    //Parameterised function to load different tabs on Financial page.
     //Use Case: Rollout or Regional original projects have different tab sets.
    private static void loadTab(id projectId, IPM_FinancialController ipmFinCon, string tab){
             PageReference pageRef = Page.IPM_Financial;
             pageRef.getParameters().put('id', projectId);
             Test.setCurrentPageReference(pageRef);
             ipmFinCon.currentTab = tab;
             system.assertEquals(ipmFinCon.currentTab,tab,'Current tab could not be set as -' + tab );
             ipmFinCon.changeTabs();
             system.assertEquals(ipmFinCon.isEditMode, false, 'Financial is editable');
     }

     private static void callCtrlAction(IPM_FinancialController ipmfincon, integer part)
     {   
        //Finance record for global project which is NON consolidate             
        
        String currentTab = 'myview'; 
		String fieldSuffix = IPM_ConstantUtils.BLANK; 
		String fieldLiteral = IPM_ConstantUtils.FIELD_LITERAL_VOLUME;
		List<IPM_Project__c> lstProject = [SELECT Id, IPM_Project_Job_Status__c, IPMProject_Span__c, IPM_Phase__c, IPM_ProjectGKM__c,IPM_SourceProjectType__c From IPM_Project__c WHERE Name in: regionalProjectNameSet limit 1];
        
        List<IPM_Financial__c> Fins = [SELECT Id,Local_Project__c, Yellow_Validation_Cells_Global__c,Red_Validation_Cells_Global__c, Yellow_Validation_Cells_Regional__c,Red_Validation_Cells_Regional__c, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c FROM IPM_Financial__c WHERE Local_Project__c =: lstProject[0].Id  Or Parent_Project__c  =: lstProject[0].Id  Or Regional_Project__c =: lstProject[0].Id];
        IPM_Financial__c consolidatedFin = Fins[0]; 
        
		IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
		IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION= true;
		IPM_Financial_Year__c FinYear = IPM_TestFactory_Helper.createIPMFinancialYear(false);
		FinYear.IPM_Financial__c = consolidatedFin.Id;
		FinYear.Volume_Global__c =10;
		FinYear.Volume_Local__c =10;
		FinYear.Volume_Regional__c =10;
		insert FinYear; 
		IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
		IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION= false;
		
        if (part == EXEC_PART_3){
                
            ipmFinCon.editFinancials();
            system.assertEquals(ipmFinCon.isEditMode, true,'Edit mode is invalid');
            
            ipmFinCon.BI = 'Large';
            ipmFinCon.saveFinancials();
            //assert missing
            ipmFinCon.selectedSustainabilityPeriod = '3';
            ipmFinCon.changeSustainabilityPeriod(); 
            system.assertEquals(ipmFinCon.sustainabilityPeriodChanging, true,'Sustainability period could not be changed');
            
            ipmFinCon.checkSustainabilityPeriodChanged();
            //verify after sustainability check cunters are reset
            system.assertEquals(ipmFinCon.nextIndex, 0, INVALID_INDEX);
            system.assertEquals(ipmFinCon.previousIndex, 0, INVALID_INDEX);
            system.assertEquals(ipmFinCon.isNavigation, false, INCORRECT_NAVIGATION_RESULT);
         
            ipmFinCon.selectedSustainabilityPeriod = '5';
            
        }else if (part == EXEC_PART_4){ 
        	       
            ipmFinCon.changeSustainabilityPeriod();
            system.assertEquals(ipmFinCon.sustainabilityPeriodChanging, true, 'Invalid Sustainability period change');
            
            ipmFinCon.checkSustainabilityPeriodChanged();
            //verify after sustainability check cunters are reset
            system.assertEquals(ipmFinCon.nextIndex, 0, INVALID_INDEX);
            system.assertEquals(ipmFinCon.previousIndex, 0, INVALID_INDEX);
            system.assertEquals(ipmFinCon.isNavigation, false, INCORRECT_NAVIGATION_RESULT);
            
            ipmFinCon.isTargetLaunchDateMisaligned=true;

        }else if (part == EXEC_PART_6){   
        	//only for certain type
            //This fails
	
            ipmFinCon.fieldsuffix = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
			fieldSuffix = 'Global';//IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            IPM_FinancialWrapper finWrapper = new IPM_FinancialWrapper();
            List<IPM_FinancialValueWrapper> liFinValWrGPL = new List<IPM_FinancialValueWrapper>();
            
            String queryString='Select ';
	      	For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
	  		  	if (!field.equalsignoreCase('Id') ){
	              	queryString+= field + ', ';
	          	}
	      	}
	      	queryString += ' id From IPM_Financial_year__c  WHERE Id =\'' + FinYear.Id + '\'';
	      	List<IPM_Financial_year__c> finYears = Database.query(queryString);
            
            
            IPM_FinancialValueWrapper finvalwrGPL = new IPM_FinancialValueWrapper(finYears[0], lstProject[0], fieldsuffix, fieldLiteral, 0, consolidatedFin,currentTab);
            liFinValWrGPL.add(finvalwrGPL);
            finWrapper.lstGrossPLVolume = liFinValWrGPL;
            
            List<IPM_FinancialValueWrapper> liFinValWrINCPL = new List<IPM_FinancialValueWrapper>();
            IPM_FinancialValueWrapper finvalwrINCPL = new IPM_FinancialValueWrapper(finYears[0], lstProject[0], fieldsuffix, fieldLiteral, 2, consolidatedFin,currentTab);
            liFinValWrINCPL.add(finvalwrINCPL);
            finWrapper.lstIncrementalPLVolume = liFinValWrINCPL;

            //This works
            ipmFinCon.fieldsuffix = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
			fieldSuffix = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            IPM_FinancialValueWrapper lstGrossPLVolumeTon = new IPM_FinancialValueWrapper(finYears[0], lstProject[0], fieldsuffix, fieldLiteral, 2, consolidatedFin,currentTab);
            finWrapper.lstGrossPLVolumeTons = new List<IPM_FinancialValueWrapper>{lstGrossPLVolumeTon};
            
            IPM_FinancialValueWrapper lstGrossPL = new IPM_FinancialValueWrapper(finYears[0], lstProject[0], fieldsuffix, fieldLiteral, 2, consolidatedFin,currentTab);
            finWrapper.lstGrossPLVolume = new List<IPM_FinancialValueWrapper>{lstGrossPL};
                
            IPM_FinancialValueWrapper lstIncrementalPLVolumeTon = new IPM_FinancialValueWrapper(finYears[0], lstProject[0], fieldsuffix, fieldLiteral, 2, consolidatedFin,currentTab);
            finWrapper.lstIncrementalPLVolumeTons = new List<IPM_FinancialValueWrapper>{lstIncrementalPLVolumeTon};
            
            IPM_FinancialValueWrapper lstIncrementalPL = new IPM_FinancialValueWrapper(finYears[0], lstProject[0], fieldsuffix, fieldLiteral, 2, consolidatedFin,currentTab);
            finWrapper.lstIncrementalPLVolume = new List<IPM_FinancialValueWrapper>{lstIncrementalPL};
            //ipmFinCon.populateVolumeType(finWrapper);
            ipmFinCon.financialsInnovation = finWrapper;
            ipmFinCon.updateVolumeType();
            //Cannot be asserted as this function is called from vf page to Re-render content panel
        }
    }

     //Use case: Regional original IDEAS phase and WITHOUTconsilidate financnials
     static testMethod void testRegionalOriginalNONConsolidate()
     {   
         List<User> regionalProjectLeaderList = [Select Id,Name,email from User where email = 'regionalUser@unilever.test.com']; 

         System.runAs(regionalProjectLeaderList[0])
         {
            //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c regionalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c,IPM_Phase__c,IPM_ProjectGKM__c  from IPM_Project__c where IPMProject_Span__c='Regional' and IPM_Project_Type__c='Original' and Name='TestRegionalComments1' limit 1];
             system.assert(regionalOriginal!=null,'Regional original record (Regional company card) record not found.');
             system.assertEquals(regionalOriginal.name, 'TestRegionalComments1', INVALID_PROJECT_NAME);
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regionalOrigFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c, Parent_Project__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             
             
             regionalOrigFin.Copy_Local_to_Regional__c =true;
             update regionalOrigFin; 
             system.assert(regionalOrigFin!=null,'Finance record for regional company card project (regional original) not found');
             system.assertEquals(regionalOrigFin.Financial_External_ID__c, 'TestRegionalComments1_UMCA', INVALID_FINACIAL_EXT_ID);
             
             regionalOrigFin.Parent_Project__c = regionalOriginal.id;
             regionalOrigFin.Copy_Local_to_Regional__c = true;
             regionalOrigFin.Copy_Regional_to_Local__c = true;
             //parent project is not populated when financials are created from TestFactory so update manually.
             update regionalOrigFin;
             //asserts starts below 

             
            
             setPage(regionalOriginal.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             
             ipmFinCon.project = regionalOriginal;
             ipmFinCon.currentfinancial = regionalOrigFin;
             ipmFinCon.currentfinancialid = regionalOrigFin.id;
             ipmFinCon.isConsolidatedOrNonkey = false;
             
             ipmFincon.refreshFromLocal();
             ipmFinCon.updateMisalignmentByFinanceLeader();
             ipm_project__c sel = [select IPM_Project_Type__c, IPMProject_Span__c, MisAligned_Confirmed_By_Finance_Leader__c,IPM_Phase__c,IPM_ProjectGKM__c from ipm_project__c where id = :regionalOriginal.id];
             system.assertEquals(sel.IPM_Project_Type__c, 'Original', INVALID_PROJECT_TYPE);
             system.assertEquals(sel.IPMProject_Span__c, 'Regional', INVALID_SPAN_NAME);
             system.assertEquals(ipmFinCon.showMisalignedConfirmbtn, true, MISALINGNED_NOT_CONFIRMED);
             Test.startTest();
             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6); 
              
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);//
             //Load Tab Rollup
             loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
             Test.stopTest(); 
             system.assert(ipmFinCon.targetLaunchDateToDisplay!= null , TLDNullMsg);
             system.assertEquals(false,ipmFinCon.showNext , showNextMsg);
             system.assertEquals(false,ipmFinCon.showPrevious, showPreviousMsg);
             system.assert(ipmFinCon.tldAcceptFromValue == 'Accept Local TLD' , 'TLD accept value not returned as required');
             
             
         }  
     }



    static testMethod void financialGlobalOperationalTest()
     {     	  
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         User globalProjectLeader = null;

         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            //This creates Regional original project. But we need rollout projects also and financial
            globalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
         }

        System.runAs(globalProjectLeader)
        { 
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.createOperationalProjectList(false,1,'global');
            for(Integer i=0; i<projectList.size(); i++){
				projectList[i].IPM_ProjectGKM__c = 'GKM5';
			}
            insert projectList;

            IPM_Project__c projectRecord = projectList[0];

            system.assertNotEquals(projectRecord,null, 'Record for Global Operational not created in previous step.'); 
            
            ipm_project__c globalOperationalProject = [select Id,name,IPM_Phase__c,IPM_ProjectGKM__c from ipm_project__c where id=: projectRecord.id];
            system.assertEquals(globalOperationalProject.name,'TestOperationalCommentsglobal1', 'Project not created.');
            
            
             
            setPage(projectRecord.Id);
			Test.startTest();
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = globalOperationalProject;
             
             //callCtrlAction(ipmFinCon, EXEC_PART_3);
             Test.stopTest();
             //asserts are in source method to check tab load
             //Load Tab MyView
             //loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             globalOperationalProject = [select Id,IPM_Project_Type__c, MisAligned_Confirmed_By_Finance_Leader__c,IPM_Phase__c,IPM_ProjectGKM__c from ipm_project__c where id = :projectRecord.id];
             system.assertEquals(globalOperationalProject.IPM_Project_Type__c, LIT_OPERATIONAL, INVALID_PROJECT_TYPE);
             //system.assertEquals(globalOperationalProject.MisAligned_Confirmed_By_Finance_Leader__c, true, MISALINGNED_NOT_CONFIRMED); 
         }
     }
     
     
     static testMethod void financialLocalOperationalTest() 
     {
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        User localProjectLeader = null; 

         // Create an instances of standard Users for Allocation to Project Leaders.
        System.runAs(adminUser)
        {   
            //This creates Regional original project. But we need rollout projects also and financial
            localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }

        System.runAs(localProjectLeader)
        { 
            
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.createOperationalProjectList(false,1,'local');
			for(Integer i=0; i<projectList.size(); i++){
				projectList[i].IPM_ProjectGKM__c = 'GKM7';
			}
            insert projectList;
            IPM_Project__c projectRecord = projectList[0];

            system.assertNotEquals(projectRecord,null, 'Local operational project record is not created in previous step.'); 

            ipm_project__c localOperationalProject = [select Name,IPM_Project_Name__c from ipm_project__c where id=: projectRecord.id];
            system.assertEquals(localOperationalProject.IPM_Project_Name__c, 'TestOperationalCommentslocal1', 'Project not created.'); 
            
            Test.startTest();
	
            setPage(projectRecord.Id);
         
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            ipmFinCon.project = localOperationalProject;
            
            ipmFinCon.isConsolidatedOrNonkey=false;
             //asserts are in source method for callCtrlAction calls    
            
            //callCtrlAction(ipmFinCon, EXEC_PART_3);
            Test.stopTest();
             
            ipmFinCon.updateMisalignmentByFinanceLeader();
            localOperationalProject = [select IPM_Project_Type__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :projectRecord.id];
            system.assertEquals(localOperationalProject.IPM_Project_Type__c, LIT_OPERATIONAL, INVALID_PROJECT_TYPE);
            //system.assertEquals(localOperationalProject.MisAligned_Confirmed_By_Finance_Leader__c, true, MISALINGNED_NOT_CONFIRMED);
            ipmFinCon.project = null;
            ipmFinCon.updateMisalignmentByFinanceLeader();
            string msg = 'Please contact your administrator';
            system.assert(ipmFinCon.errorMessage.contains(msg),ERROR_MSG_NOT_CAPTURED);
             
             
            //asserts are in source method to check tab load
            //Load Tab MyView
            //loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
            //Load Tab TopDown
           // loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
            //Load Tab Rollup
            //loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
        }
    }

    static testMethod void financialRegionalOperationalTest()
    {

        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        User regionalProjectLeader = null; 

         // Create an instances of standard Users for Allocation to Project Leaders.
        System.runAs(adminUser)
        {   
            //This creates Regional original project. But we need rollout projects also and financial
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }

        System.runAs(regionalProjectLeader)
        {
            Test.startTest();
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.createOperationalProjectList(false,1,'regional');
			for(Integer i=0; i<projectList.size(); i++){
				projectList[i].IPM_ProjectGKM__c = 'GKM6';
			}
            insert projectList;
            IPM_Project__c projectRecord = projectList[0];

            system.assertNotEquals(projectRecord,null, 'Local operational project record is not created in previous step.'); 

            ipm_project__c regionalOperationalProject = [select Name,IPM_Project_Name__c from ipm_project__c where id=: projectRecord.id];
            system.assertEquals(regionalOperationalProject.IPM_Project_Name__c, 'TestOperationalCommentsregional1', 'Project not created.'); 
            
            

            setPage(projectRecord.Id); 

            list<IPM_Financial__c> regOpFin = [select id, name, Global_External_Id__c, Global_Project_Id__c from IPM_Financial__c where Regional_Project__c =:projectRecord.id limit 1]; 
             
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
            if (regOpFin!=null && !regOpFin.isEmpty())
            {
                ipmFinCon.currentfinancialid = regOpFin[0].id;
            }

            //asserts are in source method for callCtrlAction calls    
            
            Test.stopTest();
            callCtrlAction(ipmFinCon, EXEC_PART_3);
            
            //Load Tab MyView
            loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
            
            //Load Tab TopDown
            loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
            
            //Load Tab Rollup
            loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
        }
     } 
    
}