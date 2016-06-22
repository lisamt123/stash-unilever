@isTest
private class IPM_FinancialControllerRegional_Test {

    private static final string LIT_OPERATIONAL = 'Operational';
    private static final string PROJECT_BI_LARGE = 'Large';
    private static final integer EXEC_PART_2 = 2;
    private static final integer EXEC_PART_3 = 3;
    private static final integer EXEC_PART_4 = 4;
    private static final integer EXEC_PART_6 = 6;
    private static final string INVALID_ROLLOUT_NAME = 'Invalid rollout name';
    private static final string INVALID_INDEX = 'Invalid index found';
    private static final string INVALID_PROJECT_NAME = 'Invalid project name';
    private static final string INVALID_SPAN_NAME = 'Invalid span name';
    private static final string INVALID_PROJECT_TYPE = 'Invalid project type';
    private static final string INVALID_FINACIAL_EXT_ID = 'Invalid Financial external id';
    private static final string MISALINGNED_NOT_CONFIRMED = 'Misaligned confirmation not found';
    private static final string INCORRECT_NAVIGATION_RESULT = 'Incorrect Navigation found';
    private static final string ERROR_MSG_NOT_CAPTURED = 'error message not captured';
    private static final string BLANK_STRING = IPM_ConstantUtils.IPM_SPACE;
    
    private static final string eitherConsolidatedNonKeyMsg = 'Financial is either consolidated or key';
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
            Test.startTest();

            List<IPM_Project__c> regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(1,UserList[0]); 
            regionalProjectList[0].IPM_Phase__c = 'Ideas';
            
            insert regionalProjectList;
            
            Test.stopTest();

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

            System.debug('getQueries9>>'+Limits.getQueries());        
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
        if (part == EXEC_PART_3)
        {
                
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
        }
        else if (part == EXEC_PART_4)
        {        
            ipmFinCon.changeSustainabilityPeriod();
            system.assertEquals(ipmFinCon.sustainabilityPeriodChanging, true, 'Invalid Sustainability period change');
            
            ipmFinCon.checkSustainabilityPeriodChanged();
            //verify after sustainability check cunters are reset
            system.assertEquals(ipmFinCon.nextIndex, 0, INVALID_INDEX);
            system.assertEquals(ipmFinCon.previousIndex, 0, INVALID_INDEX);
            system.assertEquals(ipmFinCon.isNavigation, false, INCORRECT_NAVIGATION_RESULT);
            
            ipmFinCon.isTargetLaunchDateMisaligned=true;

        }
        else if (part == EXEC_PART_6)
        {   //only for certain type
            //This fails 
            ipmFinCon.fieldsuffix = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            IPM_FinancialWrapper finWrapper = new IPM_FinancialWrapper();
            List<IPM_FinancialValueWrapper> liFinValWrGPL = new List<IPM_FinancialValueWrapper>();
            IPM_FinancialValueWrapper finvalwrGPL = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
            liFinValWrGPL.add(finvalwrGPL);
            finWrapper.lstGrossPLVolume = liFinValWrGPL;
            
            List<IPM_FinancialValueWrapper> liFinValWrINCPL = new List<IPM_FinancialValueWrapper>();
            IPM_FinancialValueWrapper finvalwrINCPL = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
            liFinValWrINCPL.add(finvalwrINCPL);
            finWrapper.lstIncrementalPLVolume = liFinValWrINCPL;

            //This works
            ipmFinCon.fieldsuffix = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            IPM_FinancialValueWrapper lstGrossPLVolumeTon = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
            finWrapper.lstGrossPLVolumeTons = new List<IPM_FinancialValueWrapper>{lstGrossPLVolumeTon};
            
            IPM_FinancialValueWrapper lstGrossPL = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
            finWrapper.lstGrossPLVolume = new List<IPM_FinancialValueWrapper>{lstGrossPL};
                
            IPM_FinancialValueWrapper lstIncrementalPLVolumeTon = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
            finWrapper.lstIncrementalPLVolumeTons = new List<IPM_FinancialValueWrapper>{lstIncrementalPLVolumeTon};
            
            IPM_FinancialValueWrapper lstIncrementalPL = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
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
             IPM_Project__c regionalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Regional' and IPM_Project_Type__c='Original' and Name='TestRegionalComments1' limit 1];
             system.assert(regionalOriginal!=null,'Regional original record (Regional company card) record not found.');
             system.assertEquals(regionalOriginal.name, 'TestRegionalComments1', INVALID_PROJECT_NAME);
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regionalOrigFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c, Parent_Project__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             system.assert(regionalOrigFin!=null,'Finance record for regional company card project (regional original) not found');
             system.assertEquals(regionalOrigFin.Financial_External_ID__c, 'TestRegionalComments1_UMCA', INVALID_FINACIAL_EXT_ID);
             
             regionalOrigFin.Parent_Project__c = regionalOriginal.id;
             regionalOrigFin.Copy_Local_to_Regional__c = true;
             regionalOrigFin.Copy_Regional_to_Local__c = true;
             //parent project is not populated when financials are created from TestFactory so update manually.
             update regionalOrigFin;
             //asserts starts below 

             Test.startTest();
            
             setPage(regionalOriginal.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = regionalOriginal;
             ipmFinCon.currentfinancial = regionalOrigFin;
             ipmFinCon.currentfinancialid = regionalOrigFin.id;
             ipmFinCon.isConsolidatedOrNonkey = false;
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             ipm_project__c sel = [select IPM_Project_Type__c, IPMProject_Span__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :regionalOriginal.id];
             system.assertEquals(sel.IPM_Project_Type__c, 'Original', INVALID_PROJECT_TYPE);
             system.assertEquals(sel.IPMProject_Span__c, 'Regional', INVALID_SPAN_NAME);
             system.assertEquals(ipmFinCon.showMisalignedConfirmbtn, true, MISALINGNED_NOT_CONFIRMED);
             
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
             
             system.assertEquals(false, ipmFinCon.isConsolidatedOrNonkey, eitherConsolidatedNonKeyMsg);
             system.assert(ipmFinCon.targetLaunchDateToDisplay!= null , TLDNullMsg);
             system.assertEquals(false,ipmFinCon.showNext , showNextMsg);
             system.assertEquals(false,ipmFinCon.showPrevious, showPreviousMsg);
             system.assert(ipmFinCon.tldAcceptFromValue == 'Accept Local TLD' , 'TLD accept value not returned as required');
             
             
            Test.stopTest();
         }  
     }


     //Use case: Local Rollout Feasibility phase 
     static testMethod void testLocalRollout()
     {
        List<User> regionalProjectLeaderList = [Select Id,Name,email from User where email = 'regionalUser@unilever.test.com']; 
        IPM_Project__c regionalProject = [Select Id,Name from IPM_ProjecT__c where Name = 'TestRegionalComments1'];

        System.runAs(regionalProjectLeaderList[0])
        {
             Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             List<IPM_Project__c> localRolloutProjectList  = [select id, name,IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c,IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Local' and IPM_Project_Type__c='Rollout' and Name='TestRegionalComments1_UMCA' limit 1];
             
             if(localRolloutProjectList.isEmpty())
             {
                List<IPM_Project_Rollout__c> newRolloutProjectList = new List<IPM_Project_Rollout__c>();
                for(IPM_Project_Rollout__c projectRoll : [select id,Name,IPM_Regional_PL__c from IPM_Project_Rollout__c where Regional_Project__c =:regionalProject.ID] )
                {

                    projectRoll.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                    projectRoll.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC; 
                    newRolloutProjectList.add(projectRoll); 
                }   
                
                update newRolloutProjectList;
             }

             Test.stopTest();
             
             localRolloutProjectList  = [select id, name,IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c,IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Local' and IPM_Project_Type__c='Rollout' and Name='TestRegionalComments1_UMCA' ];

             IPM_Project__c localRolloutProject = localRolloutProjectList[0];
             system.assert(localRolloutProject!=null,'Local rollout type project not created.');
             system.assertEquals(localRolloutProject.name, 'TestRegionalComments1_UMCA', INVALID_ROLLOUT_NAME);
             
             localRolloutProject.BI__c = PROJECT_BI_LARGE;
             update localRolloutProject;
             IPM_Project__c selP = [select BI__c from IPM_Project__c where id=:localRolloutProject.id];
             system.assertEquals(selP.BI__c, PROJECT_BI_LARGE,'BI did not update');
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c localRolloutFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             system.assert(localRolloutFin!=null, 'Finance record for Local rollout project is not created.');
             system.assertEquals(localRolloutFin.Financial_External_ID__c, 'TestRegionalComments1_UMCA', INVALID_FINACIAL_EXT_ID);
             
             setPage(localRolloutProject.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = localRolloutProject;
             ipmFinCon.currentfinancial = localRolloutFin;
             ipmFinCon.currentfinancialid = localRolloutFin.id;

             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             ipm_project__c sel = [select IPM_Project_Type__c, IPMProject_Span__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :localRolloutProject.id];
             system.assertEquals(sel.IPMProject_Span__c, 'Local', INVALID_SPAN_NAME);
             system.assertEquals(sel.MisAligned_Confirmed_By_Finance_Leader__c, true, MISALINGNED_NOT_CONFIRMED);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(localRolloutProject.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(localRolloutProject.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
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
            globalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
         }

        System.runAs(globalProjectLeader)
        { 
            Test.startTest();
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.createOperationalProjectList(false,1,'global');
            insert projectList;

            IPM_Project__c projectRecord = projectList[0];

            system.assertNotEquals(projectRecord,null, 'Record for Global Operational not created in previous step.'); 
            
            ipm_project__c globalOperationalProject = [select name from ipm_project__c where id=: projectRecord.id];
            system.assertEquals(globalOperationalProject.name,'TestOperationalCommentsglobal1', 'Project not created.');
            
            Test.stopTest(); 

            setPage(projectRecord.Id);

             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             globalOperationalProject = [select IPM_Project_Type__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :projectRecord.id];
             system.assertEquals(globalOperationalProject.IPM_Project_Type__c, LIT_OPERATIONAL, INVALID_PROJECT_TYPE);
             system.assertEquals(globalOperationalProject.MisAligned_Confirmed_By_Finance_Leader__c, true, MISALINGNED_NOT_CONFIRMED); 
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
            localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }

        System.runAs(localProjectLeader)
        { 
            Test.startTest();
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.createOperationalProjectList(false,1,'local');

            insert projectList;
            IPM_Project__c projectRecord = projectList[0];

            system.assertNotEquals(projectRecord,null, 'Local operational project record is not created in previous step.'); 

            ipm_project__c localOperationalProject = [select Name,IPM_Project_Name__c from ipm_project__c where id=: projectRecord.id];
            system.assertEquals(localOperationalProject.IPM_Project_Name__c, 'TestOperationalCommentslocal1', 'Project not created.'); 
            
            Test.stopTest();

            setPage(projectRecord.Id);
         
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
            ipmFinCon.isConsolidatedOrNonkey=false;
             //asserts are in source method for callCtrlAction calls    
            callCtrlAction(ipmFinCon, EXEC_PART_2);
            callCtrlAction(ipmFinCon, EXEC_PART_3);
             
            ipmFinCon.updateMisalignmentByFinanceLeader();
            localOperationalProject = [select IPM_Project_Type__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :projectRecord.id];
            system.assertEquals(localOperationalProject.IPM_Project_Type__c, LIT_OPERATIONAL, INVALID_PROJECT_TYPE);
            system.assertEquals(localOperationalProject.MisAligned_Confirmed_By_Finance_Leader__c, true, MISALINGNED_NOT_CONFIRMED);
            ipmFinCon.project = null;
            ipmFinCon.updateMisalignmentByFinanceLeader();
            string msg = 'Please contact your administrator';
            system.assert(ipmFinCon.errorMessage.contains(msg),ERROR_MSG_NOT_CAPTURED);
             
             
            //asserts are in source method to check tab load
            //Load Tab MyView
            loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
            //Load Tab TopDown
            loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
            //Load Tab Rollup
            loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
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
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }

        System.runAs(regionalProjectLeader)
        {
            Test.startTest();
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.createOperationalProjectList(false,1,'regional');

            insert projectList;
            IPM_Project__c projectRecord = projectList[0];

            system.assertNotEquals(projectRecord,null, 'Local operational project record is not created in previous step.'); 

            ipm_project__c regionalOperationalProject = [select Name,IPM_Project_Name__c from ipm_project__c where id=: projectRecord.id];
            system.assertEquals(regionalOperationalProject.IPM_Project_Name__c, 'TestOperationalCommentsregional1', 'Project not created.'); 
            
            Test.stopTest();

            setPage(projectRecord.Id); 


            list<IPM_Financial__c> regOpFin = [select id, name, Global_External_Id__c, Global_Project_Id__c from IPM_Financial__c where Regional_Project__c =:projectRecord.id limit 1]; 
             
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
            if (regOpFin!=null && !regOpFin.isEmpty())
            {
                ipmFinCon.currentfinancialid = regOpFin[0].id;
            }

            //asserts are in source method for callCtrlAction calls    
            callCtrlAction(ipmFinCon, EXEC_PART_2);
            
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