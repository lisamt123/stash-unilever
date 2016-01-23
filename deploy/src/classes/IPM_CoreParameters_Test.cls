/******************************************** 
 *@Author:Cognizant
 *@Date:25/08/2015
 *@Description : To test IPM_CoreParameters class functionalities
 *********************************************/@isTest
private with sharing class IPM_CoreParameters_Test {
    //*@Description: Object Variable decleration 
    private static IPM_Project__c projectWithOutBoss;
    private static IPM_Project__c testProject;
    private static User userInitialize;
    private static IPM_CoreParameters sic;
    private static MDO_Category__c mdmCategory;
    private static mdm_Brand_Position__c mdmPosition;
    private static user u4;
    private static user u5;
    private static user u6;
    private static user u7;
    private static user newUsr;
    private static user newUsr1;
    private static user newUsr2;
    private static User newAdminUser;
    private static user newPorjectLeader; //admin user  
    private static IPM_Project_Resource__c ipmProjectResource1;
    private static IPM_Project_Resource__c ipmProjectResource2;
    private static IPM_Project_Resource__c ipmProjectResource3;
    private static IPM_Project_Resource__c ipmProjectResource4;
    private static IPM_Project_Resource__c ipmProjectResource5;
    private static IPM_Project_Resource__c ipmProjectResource6;
    private static IPM_Project_Resource__c ipmProjectResource7;
    private static string variant = 'Variant';
    private static string base = 'Base';
    private static string space_STR = ' ';
    private static string userLastName = 'IPMUSER_LASTNAME';
    private static string sameName = 'Name should be ' + space_STR + userLastName;
    private static string blg = 'BLG';
    private static string common_STR = 'answer values should be';
    private static string readAccess = 'Current logged in user should have read access';
    private static string editAccess = 'Current logged in user should have edit access';
    private static string Laundry_STR = 'Laundry';
    
    /**************************************************
     * @description : Master data 
     ***************************************************/
    
    static void initializedData() {

        //insert users
        List < User > userList = new List < User > ();
        userInitialize = IPM_TestFactory_Helper.createUser(false);
        userList.add(userInitialize);
        u6 = IPM_TestFactory_Helper.createUser(false);
        userList.add(u6);
        u4 = IPM_TestFactory_Helper.createUser(false);
        userList.add(u4);
        u5 = IPM_TestFactory_Helper.createUser(false);
        userList.add(u5);
        u7 = IPM_TestFactory_Helper.createUser(false);
        userList.add(u7);
        newUsr = IPM_TestFactory_Helper.createUser(false);
        userList.add(newUsr);
        newUsr1 = IPM_TestFactory_Helper.createUser(false);
        userList.add(newUsr1);

        newUsr2 = IPM_TestFactory_Helper.createUser(false);
        userList.add(newUsr2);
        newAdminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        

        //Project Leader user  
        newPorjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
        
        insert userList;
        List < User > userAllList = [SELECT LastName FROM User WHERE LastName = : userLastName LIMIT 1];
        System.assertEquals(userAllList[0].LastName, userLastName, sameName); //positive test
        //we need to create project as admin because after inserting resource in project then we are using subscription
        system.runAs(newAdminUser){
            
            IPM_TestFactory_Helper.createIPMCoreParameterInnoReno();
            IPM_TestFactory_Helper.createIPMCoreParameterAllQuestions();
            mdmCategory=new MDO_Category__c();
            mdmCategory.Name=Laundry_STR;
            insert mdmCategory;
            MDO_Category__c marketMDO=new MDO_Category__c();
            marketMDO.name=Laundry_STR;
            marketMDO.parent_id__c=mdmCategory.id;
            marketMDO.category_type__c=IPM_ConstantUtils.IPM_MARKET;
            insert marketMDO;
            MDO_Category__c suSectorMDO=new MDO_Category__c();
            suSectorMDO.name=Laundry_STR;
            suSectorMDO.parent_L3__c=mdmCategory.id;
            suSectorMDO.category_type__c=IPM_ConstantUtils.IPM_SUBSECTOR;
            insert suSectorMDO;
            System.assertEquals(mdmCategory.Name, Laundry_STR, 'name should be'+ mdmCategory.Name); //positive test
           
            mdmPosition = IPM_TestFactory_Helper.createMDMBrandPosition(true);
            System.assertEquals(mdmPosition.Category_Name__c, Laundry_STR, 'category should be ' + space_STR + Laundry_STR); //positive test
            IPM_TestFactory_Helper.createIPMCategory();
            //get coreparameter configuration
            IPM_TestFactory_Helper.createIPMCoreParameterConfig();
            //insert coreparameter help text
            List < IPM_CorePara_helps_example__c > corehelpsList = new List < IPM_CorePara_helps_example__c > ();
            IPM_CorePara_helps_example__c coreParamHelp = IPM_TestFactory_Helper.createCoreParamHelpExapmle(false);
            coreParamHelp.IPM_Answer__c = IPM_ConstantUtils.IMPROVEMENT;
            coreParamHelp.IPM_Core_Parameter_Helps__c = IPM_ConstantUtils.IPM_CORE_PARAMETER_HELPS;
            corehelpsList.add(coreParamHelp);
            IPM_CorePara_helps_example__c coreParamHelp1 = IPM_TestFactory_Helper.createCoreParamHelpExapmle(false);
            coreParamHelp1.IPM_Answer__c = IPM_ConstantUtils.NOCHANGE;
            coreParamHelp1.IPM_Core_Parameter_Helps__c = IPM_ConstantUtils.IPM_CORE_PARAMETER_HELPS;
            corehelpsList.add(coreParamHelp1);
            IPM_CorePara_helps_example__c coreParamHelp2 = IPM_TestFactory_Helper.createCoreParamHelpExapmle(false);
            coreParamHelp2.IPM_Answer__c = IPM_ConstantUtils.BASE;
            coreParamHelp2.IPM_Core_Parameter_Helps__c = IPM_ConstantUtils.IPM_CORE_PARAMETER_HELPS;
            corehelpsList.add(coreParamHelp2);
            insert corehelpsList;
            List < IPM_CorePara_helps_example__c > coreParamHelpList = [SELECT id, IPM_Answer__c FROM IPM_CorePara_helps_example__c WHERE IPM_Answer__c = : IPM_ConstantUtils.IMPROVEMENT LIMIT 1];
            system.assertEquals(coreParamHelpList[0].IPM_Answer__c, IPM_ConstantUtils.IMPROVEMENT, common_STR + space_STR + IPM_ConstantUtils.IMPROVEMENT);
            IPM_Coreparameters corPrm=new IPM_Coreparameters();
            List < IPM_Company_Card__c > companyCardList = new List < IPM_Company_Card__c > ();
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            companyCardList.add(globalCompanyCard);
            insert companyCardList;
    
            List < IPM_Company_Card__c > ipmCompanyCardList = [SELECT Name FROM IPM_Company_Card__c WHERE Name = 'Test Company Card'
                                                                LIMIT 1];
            system.assertEquals(ipmCompanyCardList[0].Name, 'Test Company Card', 'company card should be Test Company Card');
            
            //Insert Project (without Bosscard)
            projectWithOutBoss = IPM_TestFactory_Helper.createIPMProject(false);
            ProjectWithOutBoss.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
            ProjectWithOutBoss.IPM_Project_Leader__c = userInitialize.id;
            ProjectWithOutBoss.Name = 'ProjectWithOutBoss';
            ProjectWithOutBoss.IPM_ProjectSubType__c = 'Innovation/Renovation';
            ProjectWithOutBoss.IPM_Category_Text__c = Laundry_STR;
            ProjectWithOutBoss.IPM_Phase__c = 'Ideas';
            ProjectWithOutBoss.IPMProject_Span__c = 'Global';
            ProjectWithOutBoss.IPM_CompanyCardText__c = 'Global Company Card';
            ProjectWithOutBoss.IPM_Target_Launch_Dates__c = date.today().addDays(730);
            insert projectWithOutBoss;
            List < IPM_Project__c > BDProjectList = [SELECT Id, Name FROM IPM_Project__c WHERE Name = 'ProjectWithOutBoss'
            LIMIT 1];
            system.assertEquals(BDProjectList[0].Name, ProjectWithOutBoss.Name, 'project name should be' + ProjectWithOutBoss.Name);
    
            //insert project resource
            List < IPM_Project_Resource__c > projectResourceList = new List < IPM_Project_Resource__c > ();
    
            ipmProjectResource3 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id, FALSE);
            ipmProjectResource3.IPM_Role_Type__c = 'R&D';
            ipmProjectResource3.IPM_User__c = u6.id;
            projectResourceList.add(ipmProjectResource3);
    
            ipmProjectResource1 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id, FALSE);
            ipmProjectResource1.IPM_Role_Type__c = 'CMI';
            ipmProjectResource1.IPM_User__c = u4.id;
            projectResourceList.add(ipmProjectResource1);
    
            ipmProjectResource2 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id, FALSE);
            ipmProjectResource2.IPM_User__c = u5.id;
            ipmProjectResource2.IPM_Role_Type__c = 'BD';
            projectResourceList.add(ipmProjectResource2);
    
            ipmProjectResource4 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id, FALSE);
            ipmProjectResource4.IPM_Role_Type__c = 'CD';
            ipmProjectResource4.IPM_User__c = u7.id;
            projectResourceList.add(ipmProjectResource4);
    
            ipmProjectResource5 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id, FALSE);
            ipmProjectResource5.IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN;
            ipmProjectResource5.IPM_User__c = newUsr.id;
            projectResourceList.add(ipmProjectResource5);
    
            ipmProjectResource6 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id, FALSE);
            ipmProjectResource6.IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;
            ipmProjectResource6.IPM_User__c = newUsr1.id;
            projectResourceList.add(ipmProjectResource6);
    
            ipmProjectResource7 = IPM_TestFactory_Helper.createIPMProjectResource(projectWithOutBoss.id, FALSE);
            ipmProjectResource7.IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_BB;
            ipmProjectResource7.IPM_User__c = newUsr2.id;
            projectResourceList.add(ipmProjectResource7);
            insert projectResourceList;
            List<IPM_Project_Resource__c>getUserResourceList=[SELECT IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE IPM_User__c =:newUsr2.id LIMIT 1];
            System.assertEquals(getUserResourceList[0].IPM_Role_Type__c,IPM_ConstantUtils.IPM_ROLE_BB,'Role type should be BB');//positive test
            
            //share project records
            List<IPM_Project__Share>projectShareList=IPM_TestFactory_Helper.shareIPMProject(BDProjectList,userList);
            insert projectShareList;
            list<IPM_Project__Share>shareList=[SELECT ParentId,UserOrGroupId FROM IPM_Project__Share WHERE ParentId=:projectWithOutBoss.id AND UserOrGroupId=:userInitialize.id LIMIT 1];
            system.assertEquals(shareList[0].UserOrGroupId,userInitialize.id,userInitialize.id+'User should have edit access to project');//positive test
           
            apexpages.currentpage().getparameters().put(IPM_ConstantUtils.EDITPARAMETER, 'editcore');
            apexpages.currentpage().getparameters().put(IPM_ConstantUtils.ADDITIONALPARAMETER, 'additional');
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
    
            //load data from static resources
            test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');
            test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');
            
            sic = new IPM_CoreParameters();
        }

    }
    /**************************************************************
     *@Description :executes the core logic and asserts for coreparameter.
     ***************************************************************/
    static testmethod void testinitiateCoreParameter() {
        initializedData();

        system.RunAs(userInitialize) {
            Test.startTest();
            sic.editMarketActivityByPL=false;
            sic.extraEditable=false;
            sic.IPM_Coreparameter.IPM_ProjectSubType__c = 'Operational';
            sic.IPM_Coreparameter.IPM_Answer_of_Q2__c = IPM_ConstantUtils.NOCHANGE;
            sic.IPM_Coreparameter.BET__c = null; 
            sic.getCoreparameterConfig();
            sic.getAllQuestions();
            system.assertEquals(sic.IPM_Coreparameter.IPM_Answer_of_Q2__c, null, 'answer number two should be null');
            sic.IPM_Coreparameter.IPM_ProjectSubType__c = IPM_ConstantUtils.IPM_BLG;
            sic.IPM_Coreparameter.IPM_Answer_of_Q3__c = IPM_ConstantUtils.BASE;
            sic.getCoreparameterConfig();
            sic.getAllQuestions();
            sic.showMessage();
            system.assertEquals(sic.IPM_Coreparameter.IPM_Answer_of_Q3__c, null, 'answer number three should be null');
            sic.answerone_STR = IPM_ConstantUtils.IMPROVEMENT;
            sic.answertwo_STR = IPM_ConstantUtils.NOCHANGE;
            sic.answerthree_STR = IPM_ConstantUtils.BASE;
            sic.getcoreparameterHelps();
            system.assertEquals(sic.IPM_Coreparameter.IPM_Answer_of_Q1__c, blg, common_STR + blg);
            String blgGraph = blg + IPM_ConstantUtils.IPM_BACKSLASH + sic.answertwo_STR;
            sic.getStrategicGraph();
            system.assertEquals(sic.coretickMark, blgGraph, 'coretickMark value should be' + space_STR + blgGraph);
            sic.IPM_Coreparameter.IPM_ProjectSubType__c = 'Operational';
            String operationalGraph = sic.answerthree_STR + IPM_ConstantUtils.IPM_BACKSLASH + 'Operational';
            sic.getStrategicGraph();
            system.assertEquals(sic.coretickMark, operationalGraph, 'coretickMark value should be' + space_STR + operationalGraph);
            sic.IPM_Coreparameter.IPM_Category_Text__c = Laundry_STR;
            sic.getMarket();
            system.assertEquals(sic.selCat, Laundry_STR, 'Project category should be ' + space_STR + Laundry_STR);
            sic.answerthree_STR = IPM_ConstantUtils.BASE;
            sic.resetAnswer();
            system.assertEquals(String.isBlank(sic.answerthree_STR), true, 'answer three value should be reset');
            sic.resetAnswer();
            // bet specific newly addded
            BET_BETWrapper bWrapper = new BET_BETWrapper();
            sic.SelectedBet = bWrapper;
            sic.projbetlink = 'testProjectName';
            sic.betName = 'testBetName';
            // Test class constructor invocation : NO SONAR 
            IPM_Coreparameters.IPM_BET_BETWrapper sicWrap = new IPM_Coreparameters.IPM_BET_BETWrapper(bWrapper);

            Test.stopTest();

        }

    }
    /**************************************************************
     *@Description :executes the core logic and asserts for coreparameter.
     ***************************************************************/
    static testmethod void  testgetCoreStrategicIntent(){
         initializedData();
         system.RunAs(userInitialize) {
             sic.answerone_STR=IPM_ConstantUtils.IMPROVEMENT;
             sic.answertwo_STR=IPM_ConstantUtils.NOCHANGE;
             sic.answerthree_STR=IPM_ConstantUtils.BASE;
             sic.getCoreStrategicIntent();
             sic.getcoreparameterHelps(); 
             
             sic.IPM_Coreparameter.IPM_ProjectSubType__c = IPM_ConstantUtils.IPM_BLG;
             sic.getCoreStrategicIntent();
            system.assertEquals(sic.IPM_Coreparameter.IPM_ProjectSubType__c,IPM_ConstantUtils.IPM_BLG,'Load Strategic Intent For BLG Project'); 
         }
    }
        
    /**************************************************************
     *@Description :executes the core logic and asserts for coreparameter.
     ***************************************************************/
    static testmethod void testAnswerone() {
        initializedData();

        system.RunAs(userInitialize) {
            Test.startTest();
            sic.SelectedAnswer = blg;
            sic.answerOne();
            system.assertEquals(sic.answerone_STR, blg, common_STR + space_STR + blg);//sic.answerone_STR values is coming from actual controller
            Test.stopTest();
        }

    }
    /**************************************************************
     *@Description :executes the core logic and asserts for coreparameter.
     ***************************************************************/
    static testmethod void testAnswerTwo() {
        initializedData();
        system.RunAs(userInitialize) {
            Test.startTest();
            sic.SelectedAnswer = Variant;
            sic.answerTwo();
            system.assertEquals(sic.answertwo_STR, Variant, common_STR + space_STR + Variant);
            Test.stopTest();
        }

    }
    /**************************************************************
     *@Description :executes the core logic and asserts for coreparameter.
     ***************************************************************/
    static testmethod void testAnswerThree() {
        initializedData();
        Test.startTest();
        system.RunAs(userInitialize) {
            sic.SelectedAnswer = Base;
            sic.answerThree();
            system.assertEquals(sic.answerthree_STR, Base, common_STR + space_STR + Base);
        }
        Test.stopTest();
    }
    /**************************************************************
     *@Description :executes the core logic and asserts for coreparameter.
     ***************************************************************/
    static testmethod void testanswerAnswer() {
        initializedData();
        system.RunAs(userInitialize) {
            Test.startTest();
            sic.IPM_Coreparameter.id = ProjectWithOutBoss.id;
            sic.answertwo_STR = Variant;
            sic.answerAnswer();//save answer
            List<IPM_Project__c>projectList=[SELECT IPM_Answer_of_Q2__c FROM IPM_Project__c WHERE ID=:ProjectWithOutBoss.id LIMIT 1];
            system.assertEquals(projectList[0].IPM_Answer_of_Q2__c, Variant, common_STR + space_STR + Variant);
            sic.IPM_Coreparameter.Name='InvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectnameInvalidaprojectname';
            sic.answerAnswer();//save answer
            Test.stopTest();
        }

    }
    static testmethod void testsaveAdditionalCorep() {
        initializedData();
        system.RunAs(userInitialize) {
            Test.startTest();
            
            sic.market_STR = 'test';
            sic.subSector_STR = 'testsub';
            sic.betValue_STR = IPM_ConstantUtils.NO_TOOLKIT;
            sic.IPM_Coreparameter.id = ProjectWithOutBoss.id;
            sic.saveAdditionalCorep();//save additional core parameter values 
            List<IPM_Project__c>projectList=[SELECT IPM_BET_Toolkit__c,IPM_Market__c FROM IPM_Project__c WHERE ID=:ProjectWithOutBoss.id LIMIT 1];
            system.assertEquals(projectList[0].IPM_Market__c, sic.market_STR,'project market value is:'+projectList[0].IPM_Market__c);//checking from database
            Test.stopTest();
        }

    }
    /**************************************************************
     *@Description :executes the core logic and asserts for coreparameter.
     ***************************************************************/
    static testmethod void testBetValue() {
        initializedData();
        system.RunAs(userInitialize) {
            Test.startTest();
            sic.isNoToolkit = true;
            sic.betValue_STR = IPM_ConstantUtils.NO_TOOLKIT;
            sic.betValue();
            system.assertEquals(sic.isNoToolkit, false, 'value shoud be false for no toolkit');//checking from actual controller
            Test.stopTest();
        }

    }
       
    /******************************************** 
     *@Description :testmethod to get BET toolkit options
     *********************************************/
    static testmethod void testGetBETToolkit() {
        initializedData();
        system.runAs(userInitialize) {
            Test.startTest();
            List < SelectOption > betToolList = sic.getBETToolkit();
            system.assertNotEquals(betToolList[0], null, 'BET list should not be empty');//getting values from actual controller
            Test.stopTest();
        }
    }
    /**************************************************************
    *@Description :testmethod to get logged in user type
    Pratyusha<10/01> Need to revamp this method
    */
    static testmethod void testgetMilesTaskIpmuserType() {
        initializedData();
        test.startTest();
        system.runAs(u4) {
            sic.getIpmuserType(); //get current logged in user access
            system.assert(!sic.isEditable, readAccess); //positive test
        }
        system.runAs(u6) {
            sic.getIpmuserType(); //get current logged in user access
            system.assert(!sic.isEditable, readAccess); //positive test
        }
        system.runAs(u5) {  
            sic.extraEditable=true;
            sic.getIpmuserType(); //get current logged in user access
            system.assert(sic.isEditCoreparam, editAccess); //positive test

        }
        system.runAs(u7) {

            sic.project.IPM_Project_Gatekeeper__c = u7.id;
            sic.getIpmuserType(); //get current logged in user access
            system.assert(!sic.isEditable, readAccess); //positive test

        }
        system.runAs(newUsr) {
            sic.project.IPM_Project_Gatekeeper__c = newUsr.id;
            sic.getIpmuserType(); //get current logged in user access
            system.assert(!sic.isEditable, readAccess); //positive test
        }

        system.runAs(newUsr1) {
            sic.project.IPM_Project_Gatekeeper__c = newUsr1.id;
            sic.getIpmuserType(); //get current logged in user access
            system.assert(!sic.isEditable, readAccess); //positive test
        }
        system.runAs(newUsr2) {
            sic.project.IPM_Project_Gatekeeper__c = newUsr2.id;
            sic.getIpmuserType(); //get current logged in user access
            system.assert(!sic.isEditable, readAccess); //positive test

        }
        Test.stopTest();
    }
    /**************************************************************
     *@Description :To cover code for Search BET
     ***************************************************************/
    
    static testmethod void testSearchBET() {
        initializedData();
        //Handled mix dml
        
        system.runAs(newAdminUser){
        //Initialize BET data
        uw_bet__c bet = BET_TestUtils.getTestBet();
        insert bet;
        List<uw_bet__c>betList=[SELECT ID FROM uw_bet__c WHERE ID=:bet.id LIMIT 1];
        system.assertEquals(betList[0].id,bet.id,'bet id is:'+betList[0].id);
        if (bet.final_release_due_date__c == null) {
            bet.final_release_due_date__c = date.today().addDays(730);
            
        }
        update bet;
        List<uw_bet__c>betLists=[SELECT final_release_due_date__c FROM uw_bet__c WHERE ID=:bet.id LIMIT 1];
        system.assertEquals(betLists[0].final_release_due_date__c,null,'bet release date is:'+betLists[0].final_release_due_date__c);
        
        
        
        ProjectWithOutBoss.BET_Link_Requested__c = null;
        ProjectWithOutBoss.bet__c = bet.id;
        update ProjectWithOutBoss;
        List < IPM_Project__c > betProjectList = [SELECT Id, bet__c FROM IPM_Project__c WHERE id=: ProjectWithOutBoss.id LIMIT 1];
        system.assertEquals(betProjectList[0].bet__c, ProjectWithOutBoss.bet__c, 'project bet should be' + betProjectList[0].bet__c);
        
        Id[] fixedSearchResults = new Id[1];
        fixedSearchResults[0] = bet.id;
        Test.setFixedSearchResults(fixedSearchResults);
        ProjectWithOutBoss.IPM_Category_Text__c = 'TestCategory';
        }
        system.runAs(userInitialize) {
            sic.checkLabel();

            Test.startTest();
            sic.projbetlink = 'testProjectName';
            sic.searchstring = 'Axe';
            sic.searchBET();
            List < IPM_Coreparameters.IPM_BET_BETWrapper > lstWrapper = sic.searchresultBet;
            Test.stopTest();
            
            system.assertEquals(1, lstWrapper.size(), 'Wrapper size not as expected');
        }
    }

    /**************************************************************
     *@Description :To cover code for Unlink BET
     ***************************************************************/
    static testmethod  void testUnlinkBET() {
        initializedData();
        //handled mix dml
        system.runAs(newAdminUser){
        //Initialize BET data
        uw_bet__c bet = BET_TestUtils.getTestBet();
        insert bet;
        List<uw_bet__c>betList=[SELECT ID FROM uw_bet__c WHERE ID=:bet.id LIMIT 1];
        system.assertEquals(betList[0].id,bet.id,'bet id is:'+betList[0].id);
        
        ProjectWithOutBoss.BET_Link_Requested__c = bet.id;
        ProjectWithOutBoss.bet__c = bet.id;
        update ProjectWithOutBoss;

        List < IPM_Project__c > BDProjectList = [SELECT Id, bet__c FROM IPM_Project__c WHERE id=: ProjectWithOutBoss.id 
                                                    LIMIT 1];
        system.assertEquals(BDProjectList[0].bet__c, ProjectWithOutBoss.bet__c, 'project bet should be' + BDProjectList[0].bet__c);
        
        BET_BETWrapper bWrapper = new BET_BETWrapper();
        sic.SelectedBet = bWrapper;
        sic.projbetlink = '';
        sic.betName = 'testBetName';
        // Test class constructor invocation : NO SONAR 
        IPM_Coreparameters.IPM_BET_BETWrapper sicWrap = new IPM_Coreparameters.IPM_BET_BETWrapper(bWrapper);

        apexpages.currentpage().getparameters().put(IPM_ConstantUtils.EDITPARAMETER, 'editcore');
        apexpages.currentpage().getparameters().put(IPM_ConstantUtils.ADDITIONALPARAMETER, 'additional');
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectWithOutBoss.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_Project_PID, projectWithOutBoss.id);
        
        sic = new IPM_CoreParameters();
        }
        system.runAs(newPorjectLeader) {

            testProject = IPM_TestFactory_Helper.createIPMProject(false);
            testProject.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
            testProject.IPM_Project_Leader__c = userInitialize.id;
            testProject.Name = 'ProjectWithOut';
            testProject.IPM_ProjectSubType__c = 'Innovation/Renovation';
            testProject.IPM_Category_Text__c = 'TestCategory';
            testProject.IPM_Phase__c = 'Ideas';
            testProject.IPMProject_Span__c = 'Global';
            testProject.IPM_CompanyCardText__c = 'Global Company Card';
            testProject.IPM_Target_Launch_Dates__c = date.today().addDays(730);
            testProject.IPM_Project_Leader__c = newUsr1.id;
            insert testProject;
            List < IPM_Project__c > ProjectsList = [SELECT Id, Name FROM IPM_Project__c WHERE id=: testProject.id 
                                                    LIMIT 1];
            system.assertEquals(ProjectsList[0].Name, testProject.Name, 'project name should be' + ProjectsList[0].Name);
        
            uw_bet__c bet1 = BET_TestUtils.getTestBet();
            insert bet1;
            List<uw_bet__c>betLists=[SELECT ID FROM uw_bet__c WHERE ID=:bet1.id LIMIT 1];
            system.assertEquals(betLists[0].id,bet1.id,'bet id is:'+betLists[0].id);
            testProject.BET_Link_Requested__c = bet1.id;
            testProject.bet__c = bet1.id;

            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, testProject.id);
            Test.startTest();
            sic.initialise();
            sic.Replace();
            ProjectWithOutBoss.BET_Link_Requested__c = '';
            //update ProjectWithOutBoss;
            update testProject;
            List < IPM_Project__c > ProjectsLists = [SELECT Id, BET_Link_Requested__c FROM IPM_Project__c WHERE id=: testProject.id 
                                                    LIMIT 1];
            system.assertEquals(ProjectsLists[0].BET_Link_Requested__c, testProject.BET_Link_Requested__c, 'project bet link should be' + ProjectsLists[0].BET_Link_Requested__c);
        
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, testProject.id);
            IPM_CoreParameters sic2 = new IPM_CoreParameters();
            sic2.Replace();
            sic2.projbetlink = 'testProjectName';
            string proBET = [select bet__c from IPM_Project__c where id = : testProject.id].bet__c;
            Test.stopTest();
            system.assertEquals(null, proBET, 'BET not unlinked from IPM Project!');
            apexpages.currentpage().getparameters().put(IPM_ConstantUtils.SF_ID,''); 
            
           
        }
    }

}