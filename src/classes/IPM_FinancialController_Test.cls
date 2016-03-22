/*
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FinancialController class 
*/
@isTest 
public class IPM_FinancialController_Test {
    
    private static final string SELCTED_CURRENCY_EUR = 'EUR';
    private static final string SELCTED_CURRENCY_GBP = 'GBP';
    private static final string PROJECT_BI_LARGE = 'Large';
    private static final string SUST_PERIOD_3 = '3';
    private static final string SUST_PERIOD_5 = '5';
    private static final string DOC_SECTION = 'Charter';
    private static final string TESTREGIONALCOMMENTS1 = 'TestRegionalComments1';
    private static final string LIT_TEST = 'test';
    private static final string LIT_OPERATIONAL = 'Operational';
    private static final integer EXEC_PART_2 = 2;
    private static final integer EXEC_PART_3 = 3;
    private static final integer EXEC_PART_4 = 4;
    private static final integer EXEC_PART_5 = 5;
    private static final integer EXEC_PART_6 = 6;
    
    //This method creates required global, regional and local projects and rollouts, also related financials. These records are then accessed across the testmethods.
    @testSetup static void financialSetUp() 
     {
         List<User> userList = IPM_TestFactory_Helper.createUserList();
         system.assertNotEquals(userList[0],null,'User not created');
         //asserts based on Hard coded names from helper can be a risk, if helper changes then assert will fail.
          
         IPM_TestFactory_Helper.getProjectMasterData();
         
         List<IPM_Project__c> globalProjectList = IPM_TestFactory_Helper.projectSetUp(1,userList[0]);
         system.assertNotEquals(globalProjectList,null, 'Global projects not created');
         //User at index 0 is Global Project Leader and hence assert is not done based on hard coded names
         
         System.runAs(userList[0])
         {
            insert globalProjectList;
         }
         
         setPage(globalProjectList[0].Id);
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
            //asserts are done in source method.
            callCtrlAction(ipmFinCon, EXEC_PART_2);
            callCtrlAction(ipmFinCon, EXEC_PART_3);
            callCtrlAction(ipmFinCon, EXEC_PART_4);

        Test.startTest(); 
        List<IPM_Project_Rollout__c> localRolloutList; 
        System.runAs(userList[0])
        {
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalProjectList,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            system.assert(regionalRolloutList.size()>0, 'project rollout cannot be created'); //names cannot be asserted as project name set in helper class
            
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
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
            insert localRolloutList; 
            system.assert(localRolloutList.size()>0, 'project rollout map cannot be created'); //names cannot be asserted as project and rollout map set in helper class
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AGO';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BRA';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
            //assert on counti is sufficient, additional soql can be a risk for SOQL gov limit as this method has loads of queries.
            system.assert(countryList.size()>0, 'country records not created');
        }
        
        ///Create id set from projectlist
        list<id> liGlobIds = new list<id>();
        set<id> setIds = new set<Id>();
        
        for(IPM_project__c g: globalProjectList){
            liGlobIds.add(g.id);
        }
        List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(liGlobIds,userList[0]); 
        //update BI
        for(IPM_project__c pr: projectListPhaseChange){
            pr.BI__c = PROJECT_BI_LARGE;
            setIds.add(pr.id);
        }
        update projectListPhaseChange;
        
        //assert preparation
        List<IPM_Project__c> selList = [select BI__c from IPM_project__c where id in :setIds];
        for(IPM_project__c project: selList){
            system.assertEquals(project.BI__c, PROJECT_BI_LARGE, 'BI not set as Large');
        }
        
        setIds = new set<Id>();
        System.runAs(userList[1])
        {
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.IPM_Regional_PL__c = userList[2].Id;
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE; 
                localRollout.Target_Launch_Date__c = System.today().addMonths(10); //To cover 2523 line
                localRollout.Previous_Target_Launch_Date__c = System.today().addMonths(9); //To cover 2523 line
                setIds.add(localRollout.id);
            }
            update localRolloutList;
            
            //assert preparation
            list<IPM_Project_Rollout__c> selRolloutList = [select KeyMCO__c, IPM_Regional_PL__c, IPM_Project_Job_Status__c, IPM_RolloutJobType__c, Target_Launch_Date__c, Previous_Target_Launch_Date__c from IPM_Project_Rollout__c where id in :setIds];
            for(IPM_Project_Rollout__c localRollout : selRolloutList)
            {
                system.assertEquals(localRollout.KeyMCO__c, true);
                system.assertEquals(localRollout.IPM_Regional_PL__c, userList[2].Id);
                system.assertEquals(localRollout.IPM_Project_Job_Status__c, IPM_ConstantUtils.JOB_STATUS_ELIGIBLE);
                system.assertEquals(localRollout.Previous_Target_Launch_Date__c, System.today()); //To cover 2523 line
            }
        }

        //This creates Regional original project. But we need rollout projects also and financial
        List<IPM_Project__c> regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(1,UserList[1]);
        System.runAs(userList[1])
        {
            insert regionalProjectList;
            /******************************** Create Local Rollouts for Created Regional Original project ****************************************/
            
            list<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c from IPM_Project__c where IPMProject_Span__c = 'Regional'];
            
            // Create local Rollouts for Created regional Rollouts.
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsOriginalList(false,projectList,new List<User>{userList[1]});  
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
            }
             
            insert localRolloutList; 
            //assert is done on size. Avoding SOQLs here as this method has lots of queries and can hit gov limit.
            system.assert(localRolloutList.size()>0, 'local rollouts not created');
           
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = 'AG').Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);                    
                countryList.add(tempCountry);
            }
            insert countryList;  
            system.assert(countryList.size()>0,'countries record not created');//Avoiding SOQL for further asserts
            
            // initiate the phase change of the project 
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.IPM_Regional_PL__c = userList[1].Id;
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;  
            }
            update localRolloutList;
            projectList[0].IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            update projectList[0];
            ipm_project__c selP = [select IPM_Phase__c from ipm_project__c where id=:projectList[0].id];
            system.assert(selP!=null,'project did not update properly');
            IPM_TestFactory_Helper.createIPMCountryList(true,1);
            Test.stopTest();
            
        }
        
     }
     
     private static void testCatch(IPM_project__c project, IPM_FinancialController ipmFinCon){
         ipmFinCon.project = null;
         ipmFinCon.currentfinancial = null;
         ipmFinCon.currentfinancialid = null;
         //These two methods use project.id and if project is null it will go to catch block
         PageReference pf = new PageReference('SET_BY_RETURN_VALUE');
         pf = ipmFinCon.CopyPasteTemplate();
            system.assertEquals(pf, null,'page reference not set.');
         pf = ipmFinCon.goToSection();
            system.assertEquals(pf, null,'page reference not set');
        ipmFinCon.changeSustainabilityPeriod();
         //is there an assert we can add here for sustainability period ?
        ipmFinCon.refreshFinancials();
        system.assert(ipmFinCon.errorMessage.contains(Label.IPM_PLEASE_CONTACT_ADMINISTRATOR),'error message not captured');
        
        //assert fieldsuffix is set to Regional after financials are refreshed
        system.assertEquals(ipmFinCon.fieldsuffix, 'Regional', 'field suffix not set properly, financials will not be loaded as per tab');
        ipmFinCon.editFinancials();
        system.assertEquals(ipmFinCon.isEditMode, true,'Edit mode not set');
        ipmFinCon.updateMisalignmentByFinanceLeader();
        system.assert(ipmFinCon.errorMessage.contains(Label.IPM_PLEASE_CONTACT_ADMINISTRATOR),'error message not captured');
        
        pf = ipmFinCon.loadCurrencyPage();
        system.assertEquals(pf, null, 'Page reference is null');
     }
     
     //Use case: Global original Feasibility phase and NON consilidate financnials
     static testMethod void testGlobalOriginalNONConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original'  and Name='TestComments1' limit 1];
             system.assert(globalOriginal!=null, 'Global original project not created');
             system.assertEquals(globalOriginal.name, 'TestComments1');
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c globFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_BR'];
             system.assert(globFin!=null,'Finance record for global project not created.');
             system.assertEquals(globFin.Financial_External_ID__c, 'TestComments1_LA_BR');
             
             setPage(globalOriginal.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = globalOriginal;
             ipmFinCon.currentfinancial = globFin;
             ipmFinCon.currentfinancialid = globFin.id;
             ipmFinCon.isConsolidatedOrNonkey = false;
             
             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);

             //asserts are in source method to check tab load
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
             
             //private method testCatch has ASSERTS statements so no duplicates here
             testCatch(globalOriginal, ipmFinCon);
         Test.stopTest();    
     }
     
     //Use case: Global original Feasibility phase and consilidate financnials
     static testMethod void testGlobalOriginalConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original' and Name='TestComments1' limit 1];
             system.assert(globalOriginal!=null, 'Global project not created');
             system.assertEquals(globalOriginal.name, 'TestComments1');
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c globFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_CONSOLIDATED'];
             system.assert(globFin!=null, 'Finance record not found.');
             system.assertEquals(globFin.Financial_External_ID__c, 'TestComments1_LA_CONSOLIDATED');
             
             setPage(globalOriginal.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = globalOriginal;
             ipmFinCon.currentfinancial = globFin;
             ipmFinCon.currentfinancialid = globFin.id;
             ipmFinCon.isConsolidatedOrNonkey = true;
             
             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             ipm_project__c sel = [select IPM_Project_Type__c,IPMProject_Span__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :globalOriginal.id];
             system.assertEquals(sel.IPM_Project_Type__c, 'Original');
             system.assertEquals(sel.IPMProject_Span__c, 'Global');
             system.assertEquals(ipmFinCon.showMisalignedConfirmbtn, true);
             
             //asserts are in source method to check tab load
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
         Test.stopTest();
     }
     
     //Use case: Regional Rollout Feasibility phase and NON consilidate financnials
     static testMethod void testregionalRolloutNONConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c regionalRolloutNC = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Regional' and IPM_Project_Type__c='Rollout' and Name='TestComments1_LA' limit 1];
             system.assert(regionalRolloutNC!=null,'Regional rollout record for non consolidate not found');
             system.assertEquals(regionalRolloutNC.name, 'TestComments1_LA');
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regionalRolloutNCFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_BR'];
             system.assert(regionalRolloutNCFin!=null, 'Finance record for regional rollout project could not be found');
             system.assertEquals(regionalRolloutNCFin.Financial_External_ID__c, 'TestComments1_LA_BR');
             
             pageReference pf = setPage(regionalRolloutNC.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = regionalRolloutNC;
             ipmFinCon.currentfinancial = regionalRolloutNCFin;
             ipmFinCon.currentfinancialid = regionalRolloutNCFin.id;
             ipmFinCon.isConsolidatedOrNonkey = false;
             
             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_5);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(regionalRolloutNC.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(regionalRolloutNC.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(regionalRolloutNC.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);

         Test.stopTest();    
     }
     
     //Use case: Regional Rollout Feasibility phase and consilidate financnials
     static testMethod void testRegionalRolloutConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c regionalRollout = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c, IPM_Parent_Project__c  from IPM_Project__c where IPMProject_Span__c='Regional' and IPM_Project_Type__c='Rollout' and Name='TestComments1_LA' limit 1];
             system.assert(regionalRollout!=null,'Regional rollout consolidate record not found.');
             system.assertEquals(regionalRollout.name, 'TestComments1_LA');
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regFinCon = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c, Parent_Project__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_CONSOLIDATED'];
             system.assert(regFinCon!=null,'Finance record for regional rollout not found.');
             system.assertEquals(regFinCon.Financial_External_ID__c, 'TestComments1_LA_CONSOLIDATED');
             
             setPage(regionalRollout.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = regionalRollout;
             ipmFinCon.currentfinancial = regFinCon;
             ipmFinCon.currentfinancialid = regFinCon.id;
             ipmFinCon.isConsolidatedOrNonkey = true;
             
             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_5); 
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(regionalRollout.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(regionalRollout.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(regionalRollout.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);

         Test.stopTest();
     }
     
     //Use case: Regional original IDEAS phase and WITHOUTconsilidate financnials
     static testMethod void testRegionalOriginalNONConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c regionalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Regional' and IPM_Project_Type__c='Original' and Name='TestRegionalComments1' limit 1];
             system.assert(regionalOriginal!=null,'Regional original record (Regional company card) record not found.');
             system.assertEquals(regionalOriginal.name, 'TestRegionalComments1');
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regionalOrigFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c, Parent_Project__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             system.assert(regionalOrigFin!=null,'Finance record for regional company card project (regional original) not found');
             system.assertEquals(regionalOrigFin.Financial_External_ID__c, 'TestRegionalComments1_UMCA');
             
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
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             ipm_project__c sel = [select IPM_Project_Type__c, IPMProject_Span__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :regionalOriginal.id];
             system.assertEquals(sel.IPM_Project_Type__c, 'Original');
             system.assertEquals(sel.IPMProject_Span__c, 'Regional');
             system.assertEquals(ipmFinCon.showMisalignedConfirmbtn, true);
             
             ipmFinCon.refreshFromLocal();
             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             ///loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME); //Keep this line commented
             //Load Tab Rollup
         Test.stopTest();
     }
     
     //Use case: Local Rollout Feasibility phase 
     static testMethod void testLocalRollout(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c localRollout = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Local' and IPM_Project_Type__c='Rollout' and Name='TestRegionalComments1_UMCA' limit 1];
             system.assert(localRollout!=null,'Local rollout type project not created.');
             system.assertEquals(localRollout.name, 'TestRegionalComments1_UMCA');
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c localRolloutFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             system.assert(localRolloutFin!=null, 'Finance record for Local rollout project is not created.');
             system.assertEquals(localRolloutFin.Financial_External_ID__c, 'TestRegionalComments1_UMCA');
             
             setPage(localRollout.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = localRollout;
             ipmFinCon.currentfinancial = localRolloutFin;
             ipmFinCon.currentfinancialid = localRolloutFin.id;

             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             ipm_project__c sel = [select IPM_Project_Type__c, IPMProject_Span__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :localRollout.id];
             system.assertEquals(sel.IPMProject_Span__c, 'Local');
             system.assertEquals(sel.MisAligned_Confirmed_By_Finance_Leader__c, true);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(localRollout.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(localRollout.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             
         Test.stopTest();
     }
     
     static testMethod void financialGlobalOperationalTest(){
         Test.startTest();
         IPM_Project__c projectRecord = new IPM_Project__c(NAME = LIT_TEST,IPM_PROJECT_NAME__c=LIT_TEST ,
                IPM_COMPLEXITY__c =IPM_ConstantUtils.COMPLEXITY_FULL, IPM_GATEKEEPING_MODEL__c = 'GCLT & RCLT',
                IPM_TARGET_LAUNCH_DATES__c = System.today().addMonths(6),IPMProject_Span__c='Global', 
                IPM_PROJECT_LEADER__c = UserInfo.getUserId(),IPM_CompanyCardText__c = 'Global Company Card',
                IPM_Brand_Positioning__c = 'Dirt is Good',IPM_Project_Type__c = LIT_OPERATIONAL,
                IPM_ProjectSubType__c = 'Innovation/Renovation',IPM_Phase__c='Ideas',IPM_SourceProjectType__c = LIT_OPERATIONAL,
                Sustainability_Period__c = '3',IPM_Category_Text__c ='Household Care',IPM_Child_Complexity__c =IPM_ConstantUtils.COMPLEXITY_FULL, BI__c='Large');
         insert projectRecord;
         system.assertNotEquals(projectRecord,null, 'Record for Global Operational not created in previous step.'); 
         
         ipm_project__c sel = [select name from ipm_project__c where id=: projectRecord.id];
         system.assertEquals(sel.name, LIT_TEST, 'Project not created.');
         
         setPage(projectRecord.Id);
         
         IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             boolean bConsolidateNonKey = ipmFinCon.isConsolidatedOrNonkey;
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             sel = [select IPM_Project_Type__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :projectRecord.id];
             system.assertEquals(sel.IPM_Project_Type__c, LIT_OPERATIONAL);
             system.assertEquals(sel.MisAligned_Confirmed_By_Finance_Leader__c, true);
        Test.stopTest();    
     }
     
     static testMethod void financialLocalOperationalTest(){
         Test.startTest();
         IPM_Project__c projectRecord = new IPM_Project__c(NAME = LIT_TEST,IPM_PROJECT_NAME__c=LIT_TEST ,
                IPM_COMPLEXITY__c =IPM_ConstantUtils.COMPLEXITY_FULL, IPM_GATEKEEPING_MODEL__c = 'GCLT & RCLT',
                IPM_TARGET_LAUNCH_DATES__c = System.today().addMonths(6), Previous_Target_Launch_Date__c = System.today().addMonths(9), IPMProject_Span__c='Local', 
                IPM_PROJECT_LEADER__c = UserInfo.getUserId(),IPM_CompanyCardText__c = 'Local Company Card',
                IPM_Brand_Positioning__c = 'Dirt is Good',IPM_Project_Type__c = LIT_OPERATIONAL,
                IPM_ProjectSubType__c = 'Innovation/Renovation',IPM_Phase__c='Ideas',IPM_SourceProjectType__c = LIT_OPERATIONAL,
                Sustainability_Period__c = '3',IPM_Category_Text__c ='Household Care',IPM_Child_Complexity__c =IPM_ConstantUtils.COMPLEXITY_FULL, BI__c='Large');
                
         insert projectRecord;
         
         system.assertNotEquals(projectRecord,null, 'Local operational project record is not created in previous step.'); 
         ipm_project__c sel = [select name from ipm_project__c where id=: projectRecord.id];
         system.assertEquals(sel.name, LIT_TEST, 'Project not created.');
         
         setPage(projectRecord.Id);
         
         IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
             ipmFinCon.isConsolidatedOrNonkey=false;
             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             
             ipmFinCon.updateMisalignmentByFinanceLeader();
             sel = [select IPM_Project_Type__c, MisAligned_Confirmed_By_Finance_Leader__c from ipm_project__c where id = :projectRecord.id];
             system.assertEquals(sel.IPM_Project_Type__c, LIT_OPERATIONAL);
             system.assertEquals(sel.MisAligned_Confirmed_By_Finance_Leader__c, true);
             ipmFinCon.project = null;
             ipmFinCon.updateMisalignmentByFinanceLeader();
             string msg = 'Please contact your administrator';
             system.assert(ipmFinCon.errorMessage.contains(msg),'error message not captured');
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
         Test.stopTest();       
     }
     
     static testMethod void testCurrency(){
        Test.startTest();
                list<IPM_Exchange_Rate__c> liEX = new list<IPM_Exchange_Rate__c>();
                liEX.add(new IPM_Exchange_Rate__c(Name='EUR', Currency_Code__c='EUR',Exchange_Rate__c=1));
                liEX.add(new IPM_Exchange_Rate__c(Name='GBP', Currency_Code__c='GBP',Exchange_Rate__c=0.8)); 
                liEX.add(new IPM_Exchange_Rate__c(Name='USD', Currency_Code__c='USD',Exchange_Rate__c=1.3));         
                insert liEX;   
                system.assertEquals(liEX.size(),3);

                Set<String> projectNameSet = new Set<String>{TESTREGIONALCOMMENTS1};
                List<IPM_Project__c>  projectList = [Select Id, Name,IPM_Project_Type__c, IPM_Phase__c, (Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet];
                system.assert(projectList.size() > 0,'Project not created.');
                system.assertEquals(projectList[0].Name, 'TestRegionalComments1');

            setPage(projectList[0].Id);
            
            IPM_FinancialController ipmCurr=new IPM_FinancialController();
            pageReference pref = ipmCurr.loadCurrencyPage();
            Test.setCurrentPageReference(pref);
            id sfdcId = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
            system.assert(sfdcId != null,'record id not set');
            
            ipmCurr.currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME;
            list<SelectOption> selOp =  ipmCurr.getItems();
            system.assert(selOp.size()==3,'data size do not match');
            
            ipmCurr.selectedCurrency = SELCTED_CURRENCY_GBP;
            ipmCurr.applyRate();
            //verify if exchange rate is applied as per selected country
            system.assertEquals(ipmCurr.exRate,0.8,'Exchange rate could not be set properly');
            
            ipmCurr.selectedCurrency = SELCTED_CURRENCY_EUR;
            ipmCurr.applyRate();
            //verify if exchange rate is applied when go back to default currency
            system.assertEquals(ipmCurr.exRate,1,'Exchange rate could not be APPLIED.');
        Test.stopTest();
        
    }
     
     static testMethod void financialRegionalOperationalTest(){
         Test.startTest();
         IPM_Project__c projectRecord = new IPM_Project__c(NAME = LIT_TEST,IPM_PROJECT_NAME__c=LIT_TEST ,
                IPM_COMPLEXITY__c =IPM_ConstantUtils.COMPLEXITY_FULL, IPM_GATEKEEPING_MODEL__c = 'GCLT & RCLT',
                IPM_TARGET_LAUNCH_DATES__c = System.today().addMonths(6),IPMProject_Span__c='Regional', 
                IPM_PROJECT_LEADER__c = UserInfo.getUserId(),IPM_CompanyCardText__c = 'Regional Company Card',
                IPM_Brand_Positioning__c = 'Dirt is Good',IPM_Project_Type__c = LIT_OPERATIONAL,
                IPM_ProjectSubType__c = 'Innovation/Renovation',IPM_Phase__c='Ideas',IPM_SourceProjectType__c = LIT_OPERATIONAL,
                Sustainability_Period__c = '3',IPM_Category_Text__c ='Household Care',IPM_Child_Complexity__c =IPM_ConstantUtils.COMPLEXITY_FULL);
                
         insert projectRecord;
         
         system.assertNotEquals(projectRecord,null,'Regional operationl project not created.'); 
         ipm_project__c sel = [select name from ipm_project__c where id=: projectRecord.id];
         system.assertEquals(sel.name, LIT_TEST, 'Project not created.');
         
         setPage(projectRecord.Id);
         
         list<IPM_Financial__c> regOpFin = [select id, name, Global_External_Id__c, Global_Project_Id__c from IPM_Financial__c where Global_External_Id__c=:projectRecord.id or
                                    Global_Project_Id__c=:projectRecord.id or Financial_External_ID__c = :LIT_TEST limit 1];
         
         IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            if (regOpFin!=null && !regOpFin.isEmpty()){
                ipmFinCon.currentfinancialid = regOpFin[0].id;
            }

             //asserts are in source method for callCtrlAction calls    
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             
             //asserts are in source method to check tab load
             //Load Tab MyView
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
        Test.stopTest();    
     }
    
    private static pageReference setPage(Id id){
        PageReference pageRef = Page.IPM_Financial;
        pageRef.getParameters().put('id', id);
        Test.setCurrentPageReference(pageRef);
        return pageref;
    }
    
    private static void callCtrlAction(IPM_FinancialController ipmfincon, integer part){
        if (part == EXEC_PART_2){        
            
            PageReference tmplatePage = ipmFinCon.CopyPasteTemplate();
            Test.setCurrentPageReference(tmplatePage);
            id sfdcid = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
            system.assert(sfdcid !=null,'record id not set');
            
                ipmFinCon.selectedDocumentSection = DOC_SECTION;
                PageReference sectionPage = ipmFinCon.goToSection();
                Test.setCurrentPage(sectionPage);
                //verify if record is generated for section documents.
                sfdcid = Apexpages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
                string doc  = Apexpages.currentPage().getParameters().get(IPM_ConstantUtils.SF_PROJ_DOC_SEC_ID);
                system.assert(sfdcid != null,'recordid not set');
                system.assert(doc == 'Charter','document not created');
                
                ipmFinCon.alignTLD(); //Should be after Sustainability method call
                system.assertEquals(ipmFinCon.nextIndex, 0);
                system.assertEquals(ipmFinCon.previousIndex, 0);

                List<IPM_FinancialValueWrapper> lstIncrementalPLProfit = new List<IPM_FinancialValueWrapper>();
                IPM_FinancialValueWrapper valueWrapper = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
                lstIncrementalPLProfit.add(valueWrapper);
                boolean flag = ipmFinCon.validateGrossProfit(lstIncrementalPLProfit);
                system.assertEquals(flag, true, 'Gross profit validation failed');
                
                ipmFinCon.validateY0Turnover(IPM_ConstantUtils.INVALID_VALUE);
                system.assertEquals(ipmFinCon.isy0TurnoverInvalid, true,'Y0 turnover cannot ve validated');
                system.assertEquals(ipmFinCon.isValidationFailed, true,'Validation failed after validating Year0 turnover');
                
                flag = ipmFinCon.validateGrossTurnover(lstIncrementalPLProfit);
                system.assertEquals(flag, true, 'Gross turnover cannot be validated');
                
                flag = ipmFinCon.validateIncrementalTurnover(lstIncrementalPLProfit);
                system.assertEquals(flag, true,'Incremental turnover cannot be validated');
                
                flag = ipmFinCon.validateIncrementalProfit(lstIncrementalPLProfit);
                system.assertEquals(flag, true,'Incremental PL proft cannot be validated');
                
                ipmFinCon.validateY0PBO(IPM_ConstantUtils.INVALID_VALUE);
                system.assertEquals(ipmFinCon.isValidationFailed, true,'Year0 PBO cannot be validated');
                
                flag = ipmFinCon.validateGrossPBO(lstIncrementalPLProfit);
                system.assertEquals(flag, true,'Gross PBO cannot be validated');
                
                flag = ipmFinCon.validateIncrementalPBO(lstIncrementalPLProfit);
                system.assertEquals(flag, true,'Incremental PBO validation failed');
                
                flag = ipmFinCon.validateGrossProfit(lstIncrementalPLProfit);
                system.assertEquals(flag, true,'Gross profit validation failed');
                
                ipmFinCon.validateY0GrossProfit(IPM_ConstantUtils.INVALID_VALUE);
                system.assertEquals(ipmFinCon.isValidationFailed, true,'Year0 Gross profit cannot be validated');
        }
        if (part == EXEC_PART_3){
                
                ipmFinCon.editFinancials();
                system.assertEquals(ipmFinCon.isEditMode, true,'Edit mode is invalid');
                
                ipmFinCon.BI = PROJECT_BI_LARGE;
                ipmFinCon.saveFinancials();
                //assert missing
                ipmFinCon.selectedSustainabilityPeriod = SUST_PERIOD_3;
                ipmFinCon.changeSustainabilityPeriod(); 
                system.assertEquals(ipmFinCon.sustainabilityPeriodChanging, true,'Sustainability period could not be changed');
                
                ipmFinCon.checkSustainabilityPeriodChanged();
                //verify after sustainability check cunters are reset
                system.assertEquals(ipmFinCon.nextIndex, 0);
                system.assertEquals(ipmFinCon.previousIndex, 0);
                system.assertEquals(ipmFinCon.isNavigation, false);
             
                ipmFinCon.selectedSustainabilityPeriod = SUST_PERIOD_5;
        }
        if (part == EXEC_PART_4){
                
                ipmFinCon.changeSustainabilityPeriod();
                system.assertEquals(ipmFinCon.sustainabilityPeriodChanging, true);
                
                ipmFinCon.checkSustainabilityPeriodChanged();
                //verify after sustainability check cunters are reset
                system.assertEquals(ipmFinCon.nextIndex, 0);
                system.assertEquals(ipmFinCon.previousIndex, 0);
                system.assertEquals(ipmFinCon.isNavigation, false);
                
                ipmFinCon.isTargetLaunchDateMisaligned=true;
                string tdDisplay = ipmFinCon.targetLaunchDateToDisplay;
                string tldaceept = ipmFinCon.tldAcceptFromValue;

        }
        if (part == EXEC_PART_5){ 
            IPM_Country__c ctr = [select id, Name from IPM_Country__c limit 1];
            ipmFinCon.country = ctr.id;
            ipmFinCon.checkCountry=false;
            ipmFinCon.updateCountry();
            ctr = [select Calculation_Index__c from IPM_Country__c limit 1];
            system.assert(!ctr.Calculation_Index__c,'calculation index field not updated');

            ipmFinCon.next();
            system.assertEquals(ipmFinCon.isNavigation, false);
            ipmFinCon.previous();
            system.assertEquals(ipmFinCon.isNavigation, false);
            
        }
        if (part == EXEC_PART_6){ //only for certain type
                string tdDisplay = ipmFinCon.targetLaunchDateToDisplay;
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
    
     //Parameterised function to load different tabs on Financial page.
     //Use Case: Rollout or Regional original projects have different tab sets.
     private static void loadTab(id projectId, IPM_FinancialController ipmFinCon, string tab){
             PageReference pageRef = Page.IPM_Financial;
             pageRef.getParameters().put('id', projectId);
             Test.setCurrentPageReference(pageRef);
             ipmFinCon.currentTab = tab;
             system.assertEquals(ipmFinCon.currentTab,tab,'Current tab could not be set as -' + tab );
             ipmFinCon.changeTabs();
             system.assertEquals(ipmFinCon.isEditMode, false);
     }

     
    
}