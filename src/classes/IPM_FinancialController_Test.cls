/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FinancialController class 
*/
@isTest 
public class IPM_FinancialController_Test {
    
    private static final string SELCTED_COUNTRY = 'USD';
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
    
    @testSetup static void financialSetUp() 
     {
         List<User> userList = IPM_TestFactory_Helper.createUserList();
         system.assertNotEquals(userList[0],null);
          
         IPM_TestFactory_Helper.getProjectMasterData();
         
         List<IPM_Project__c> globalProjectList = IPM_TestFactory_Helper.projectSetUp(1,userList[0]);
         system.assertNotEquals(globalProjectList,null);
         
         System.runAs(userList[0])
         {
            insert globalProjectList;
         }
         
         
         //PageReference pageRef = new PageReference('/apex/IPM_Financial?Id='+globalProjectList[0].Id);
         //Test.setCurrentPageReference(pageRef); 
         setPage(globalProjectList[0].Id);
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            //callCtrlAction(ipmFinCon,1);
            callCtrlAction(ipmFinCon, EXEC_PART_2);
            callCtrlAction(ipmFinCon, EXEC_PART_3);
            callCtrlAction(ipmFinCon, EXEC_PART_4);
         
         
         
         
        List<IPM_Project_Rollout__c> localRolloutList; 
        System.runAs(userList[0])
        {
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalProjectList,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
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
        }
        
        ///Create id set from projectlist
        list<id> liGlobIds = new list<id>();
        for(IPM_project__c g: globalProjectList){
            liGlobIds.add(g.id);
        }
        List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(liGlobIds,userList[0]); 
        //update BI
        for(IPM_project__c pr: projectListPhaseChange){
            pr.BI__c = PROJECT_BI_LARGE;
        }
        update projectListPhaseChange;
        
        //To create Local projects THIS STEP IS NOT CREATING LOCAL PROJECTS?
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
                break;
            }
            update localRolloutList;
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
           
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = 'AG').Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);                    
                countryList.add(tempCountry);
            }
            insert countryList;  
            
            Test.startTest();
            // initiate the phase change of the project 
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.IPM_Regional_PL__c = userList[1].Id;
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;  
                break;
            }
            update localRolloutList;
            projectList[0].IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            update projectList[0];
            
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
            system.assertEquals(pf, null);
         pf = ipmFinCon.goToSection();
            system.assertEquals(pf, null);
        ipmFinCon.changeSustainabilityPeriod();
        ipmFinCon.refreshFinancials();
        ipmFinCon.editFinancials(); 
        ipmFinCon.updateMisalignmentByFinanceLeader();
        pf = ipmFinCon.loadCurrencyPage();
            system.assertEquals(pf, null);
        //ipmFinCon.updateCountry();    
        
     }
     
     //Use case: Global original Feasibility phase and NON consilidate financnials
     static testMethod void testGlobalOriginalNONConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original'  and Name='TestComments1' limit 1];
             system.assert(globalOriginal!=null);
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c globFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_BR'];
             system.assert(globFin!=null);
             
             setPage(globalOriginal.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = globalOriginal;
             ipmFinCon.currentfinancial = globFin;
             ipmFinCon.currentfinancialid = globFin.id;
             ipmFinCon.isConsolidatedOrNonkey = false;
             ipmFinCon.refreshFinancials();
             
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             //callCtrlAction(ipmFinCon,6);
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
             testCatch(globalOriginal, ipmFinCon);
         Test.stopTest();    
     }
     
     //Use case: Global original Feasibility phase and consilidate financnials
     static testMethod void testGlobalOriginalConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original' and Name='TestComments1' limit 1];
             system.assert(globalOriginal!=null);
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c globFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_CONSOLIDATED'];
             system.assert(globFin!=null);
             
             setPage(globalOriginal.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = globalOriginal;
             ipmFinCon.currentfinancial = globFin;
             ipmFinCon.currentfinancialid = globFin.id;
             ipmFinCon.isConsolidatedOrNonkey = true;
             
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(globalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
             ipmFinCon.refreshFinancials();
         Test.stopTest();
     }
     
     //Use case: Regional Rollout Feasibility phase and NON consilidate financnials
     static testMethod void testregionalRolloutNONConsolidate(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c regionalRolloutNC = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Regional' and IPM_Project_Type__c='Rollout' and Name='TestComments1_LA' limit 1];
             system.assert(regionalRolloutNC!=null);
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regionalRolloutNCFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_BR'];
             system.assert(regionalRolloutNCFin!=null);
             
             pageReference pf = setPage(regionalRolloutNC.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = regionalRolloutNC;
             ipmFinCon.currentfinancial = regionalRolloutNCFin;
             ipmFinCon.currentfinancialid = regionalRolloutNCFin.id;
             ipmFinCon.isConsolidatedOrNonkey = false;
             
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_5);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
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
             system.assert(regionalRollout!=null);
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regFinCon = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c, Parent_Project__c from IPM_Financial__c where Financial_External_ID__c='TestComments1_LA_CONSOLIDATED'];
             system.assert(regFinCon!=null);
             
             setPage(regionalRollout.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = regionalRollout;
             ipmFinCon.currentfinancial = regFinCon;
             ipmFinCon.currentfinancialid = regFinCon.id;
             ipmFinCon.isConsolidatedOrNonkey = true;
             
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_5); //Multicurrency calls can be just one place
             callCtrlAction(ipmFinCon, EXEC_PART_6);
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
             system.assert(regionalOriginal!=null);
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c regionalOrigFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c, Parent_Project__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             system.assert(regionalOrigFin!=null);
             regionalOrigFin.Parent_Project__c = regionalOriginal.id;
             //parent project is not populated when financials are created from TestFactory so update manually.
             update regionalOrigFin;
             
             setPage(regionalOriginal.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = regionalOriginal;
             ipmFinCon.currentfinancial = regionalOrigFin;
             ipmFinCon.currentfinancialid = regionalOrigFin.id;
             ipmFinCon.isConsolidatedOrNonkey = false;
             
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             //Load Tab MyView
             loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(regionalOriginal.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
         Test.stopTest();
     }
     
     //Use case: Local Rollout Feasibility phase 
     //Pending here: . 
     static testMethod void testLocalRollout(){
         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c localRollout = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Local' and IPM_Project_Type__c='Rollout' and Name='TestRegionalComments1_UMCA' limit 1];
             system.assert(localRollout!=null);
             
             //Finance record for global project which is NON consolidate             
             IPM_Financial__c localRolloutFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             system.assert(localRolloutFin!=null);
             
             setPage(localRollout.id);
             IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             ipmFinCon.project = localRollout;
             ipmFinCon.currentfinancial = localRolloutFin;
             ipmFinCon.currentfinancialid = localRolloutFin.id;
             
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             callCtrlAction(ipmFinCon, EXEC_PART_4);
             callCtrlAction(ipmFinCon, EXEC_PART_6);
             //Load Tab MyView
             loadTab(localRollout.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(localRollout.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             
         Test.stopTest();
     }
     
     ///
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
         system.assertNotEquals(projectRecord,null); 
         setPage(projectRecord.Id);
         
         IPM_FinancialController ipmFinCon = new IPM_FinancialController();
             boolean bConsolidateNonKey = ipmFinCon.isConsolidatedOrNonkey;
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             //Load Tab MyView
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             
        Test.stopTest();    
     }
     
     ///
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
         system.assertNotEquals(projectRecord,null); 
          setPage(projectRecord.Id);
         
         IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
            ipmFinCon.isConsolidatedOrNonkey=false;
             
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
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
            
                Set<String> projectNameSet = new Set<String>{TESTREGIONALCOMMENTS1};
                List<IPM_Project__c>  projectList = [Select Id, Name,IPM_Project_Type__c, IPM_Phase__c, (Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet];
                system.assert(projectList.size() > 0);
            
            //PageReference pRef = new PageReference('/apex/IPM_Financial_Currency?id='+projectList[0].Id);
            //Test.setCurrentPage(pRef); 
            setPage(projectList[0].Id);
            
            IPM_FinancialController ipmCurr=new IPM_FinancialController();
            ipmCurr.loadCurrencyPage();
            ipmCurr.currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME;
            ipmCurr.getItems();
            ipmCurr.selectedCurrency = SELCTED_CURRENCY_GBP;
            ipmCurr.applyRate();
            //verify if exchange rate is applied as per selected country
            system.assertEquals(ipmCurr.exRate,0.8);
            
            ipmCurr.selectedCurrency = SELCTED_CURRENCY_EUR;
            ipmCurr.applyRate();
            //verify if exchange rate is applied when go back to default currency
            system.assertEquals(ipmCurr.exRate,1);
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
         system.assertNotEquals(projectRecord,null); 
         //PageReference pageRef = new PageReference('/apex/IPM_Financial?Id='+projectRecord.Id);
         //Test.setCurrentPageReference(pageRef); 
         setPage(projectRecord.Id);
         
         list<IPM_Financial__c> regOpFin = [select id, name, Global_External_Id__c, Global_Project_Id__c from IPM_Financial__c where Global_External_Id__c=:projectRecord.id or
                                    Global_Project_Id__c=:projectRecord.id or Financial_External_ID__c = :LIT_TEST limit 1];
         
         IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            if (regOpFin!=null && !regOpFin.isEmpty()){
                ipmFinCon.currentfinancialid = regOpFin[0].id;
            }
             callCtrlAction(ipmFinCon, EXEC_PART_2);
             callCtrlAction(ipmFinCon, EXEC_PART_3);
             //Load Tab MyView
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_MYVIEW_NAME);
             //Load Tab TopDown
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_TOPDOWN_NAME);
             //Load Tab Rollup
             loadTab(projectRecord.id, ipmFinCon, IPM_ConstantUtils.TAB_ROLLUP_NAME);
        Test.stopTest();    
     }
    
    private static pageReference setPage(Id id){
        //PageReference pageRef = new PageReference('/apex/IPM_Financial?Id='+id);
        PageReference pageRef = Page.IPM_Financial;
        pageRef.getParameters().put('id', id);
        Test.setCurrentPageReference(pageRef);
        return pageref;
    }
    
    private static void callCtrlAction(IPM_FinancialController ipmfincon, integer part){
        if (part == EXEC_PART_2){        
                ipmFinCon.selectedDocumentSection = DOC_SECTION;
                ipmFinCon.goToSection();
                ipmFinCon.refreshFromLocal();
                ipmFinCon.refreshFromRegional();
                ipmFinCon.alignTLD(); //Should be after Sustainability method call
                
                List<IPM_FinancialValueWrapper> lstIncrementalPLProfit = new List<IPM_FinancialValueWrapper>();
                IPM_FinancialValueWrapper valueWrapper = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0);
                lstIncrementalPLProfit.add(valueWrapper);
                ipmFinCon.validateGrossProfit(lstIncrementalPLProfit);
                
                ipmFinCon.validateY0Turnover(IPM_ConstantUtils.INVALID_VALUE);
                ipmFinCon.validateGrossTurnover(lstIncrementalPLProfit);
                ipmFinCon.validateIncrementalTurnover(lstIncrementalPLProfit);
                ipmFinCon.validateIncrementalProfit(lstIncrementalPLProfit);
                ipmFinCon.validateY0PBO(IPM_ConstantUtils.INVALID_VALUE);
                ipmFinCon.validateGrossPBO(lstIncrementalPLProfit);
                ipmFinCon.validateIncrementalPBO(lstIncrementalPLProfit);
                ipmFinCon.validateGrossProfit(lstIncrementalPLProfit);
                ipmFinCon.validateY0GrossProfit(IPM_ConstantUtils.INVALID_VALUE);
        }
        if (part == EXEC_PART_3){
                ipmFinCon.isEditMode=true;
                ipmFinCon.editFinancials();
                ipmFinCon.BI = PROJECT_BI_LARGE;
                ipmFinCon.saveFinancials();
                ipmFinCon.selectedSustainabilityPeriod = SUST_PERIOD_3;
                ipmFinCon.changeSustainabilityPeriod(); 
                ipmFinCon.checkSustainabilityPeriodChanged();
                ipmFinCon.selectedSustainabilityPeriod = SUST_PERIOD_3;
                ipmFinCon.alignTLD(); //Should be after Sustainability method call
        }
        if (part == EXEC_PART_4){
                ipmFinCon.changeSustainabilityPeriod();
                ipmFinCon.checkSustainabilityPeriodChanged();
                ipmFinCon.isTargetLaunchDateMisaligned=true;
                ipmFinCon.updateMisalignmentByFinanceLeader(); //has Local and Global condition
                string tdDisplay = ipmFinCon.targetLaunchDateToDisplay;
                string tldaceept = ipmFinCon.tldAcceptFromValue;
                boolean shNext = ipmFinCon.showNext;
                ipmFinCon.next();
                boolean shPrev = ipmFinCon.showPrevious;
                ipmFinCon.previous();
        }
        if (part == EXEC_PART_5){ //Multicurrency methods call
            ipmFinCon.loadCurrencyPage();
            ipmFinCon.getItems();
            ipmFinCon.selectedCurrency = SELCTED_COUNTRY;
            ipmFinCon.applyRate();
            ipmFinCon.CopyPasteTemplate();
            IPM_Country__c ctr = [select id from IPM_Country__c limit 1];
            ipmFinCon.country = ctr.id;
            ipmFinCon.checkCountry=false;
            ipmFinCon.updateCountry();
            
        }
        if (part == EXEC_PART_6){ //only for certain type
                ipmFinCon.updateMisalignmentByFinanceLeader(); //has Local and Global condition
                string tdDisplay = ipmFinCon.targetLaunchDateToDisplay;
                ipmFinCon.changeSustainabilityPeriod();
                         
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
                //ipmFinCon.populateVolumeType(finWrapper);
                
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
                ipmFinCon.populateVolumeType(finWrapper);
                
        }
    }
    
     //Parameterised function to load different tabs on Financial page.
     //Use Case: Rollout or Regional original projects have different tab sets.
     private static void loadTab(id projectId, IPM_FinancialController ipmFinCon, string tab){
             PageReference pageRef = Page.IPM_Financial;
             pageRef.getParameters().put('id', projectId);
             Test.setCurrentPageReference(pageRef);
             ipmFinCon.currentTab = tab;
             system.assertEquals(ipmFinCon.currentTab,tab);
             ipmFinCon.changeTabs();
     }

     
    
}