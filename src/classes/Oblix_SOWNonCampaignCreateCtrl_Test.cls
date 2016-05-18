@isTest
private class Oblix_SOWNonCampaignCreateCtrl_Test {

    private static final String SOW_ID_PAGE_PARAMETER = 'sowId';
    private static final String PRESELECTED_ITEM_PAGE_PARAMETER = 'preSelectedSection';

    private static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART = '{"selectedCountry":"Argentina","selectedActivity":"Brand Communication Idea","selectedAgencyDepartment":"Creative","selectedRole":"Copywriter","otherName":"","description":"","hourlyRate":"45.502","hoursSelected":"5","totalAmount":227.51000000000002,"key":"';

    private static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART = 'Brand Communication IdeaArgentinaCreativeCopywriter","isActivity":true}';

    private static Marketing_SOW__c sow = new Marketing_SOW__c();


    @testSetup static void initCommonData() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();
        }
    }


    @isTest private static void testBasketInit() {
        createBaselineSOW(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, 'BRAND BOOK');
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(4 ,controller.helper.basket.keySet().size());

        // When
        //Test.startTest();
    }

    /*@isTest private static void testAddToWorklist() {
        createBaselineSOW(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, 'BRAND BOOK');
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        //System.DEBUG(controller.nonCampaignItemToAddJSON);
        //System.DEBUG('Worklist Before Add :' + controller.helper.worklist);
        controller.addToWorkList();
        //System.DEBUG('Worklist After Add :' + controller.helper.worklist);
        System.assertEquals(2,controller.helper.worklist.size());

        // When
        //Test.startTest();
    }

    @isTest private static void testRemoveItem() {
        createBaselineSOW(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, 'BRAND BOOK');
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        //System.DEBUG(controller.nonCampaignItemToAddJSON);
        //System.DEBUG('Worklist Before Add :' + controller.helper.worklist);
        controller.addToWorkList();
        //System.DEBUG('Worklist After Add :' + controller.helper.worklist);
        //System.assertEquals(1,controller.helper.worklist.get('ACTIVITY').itemCount);
        controller.helper.itemToRemove = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
        controller.removeItem();
        //System.DEBUG('Worklist After Remove :' + controller.helper.worklist);
        //System.assertEquals(0,controller.helper.worklist.get('ACTIVITY').itemCount);

        // When
        //Test.startTest();
    }

     @isTest private static void testSaveWorkList() {
        createBaselineSOW(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, 'BRAND BOOK');
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        System.DEBUG(controller.nonCampaignItemToAddJSON);
        System.DEBUG('Worklist Before Add :' + controller.helper.basket);
        controller.addToWorkList();
        System.DEBUG('Worklist After Add :' + controller.helper.basket);
        System.assertEquals(1,controller.helper.worklist.get('ACTIVITY').itemCount);
        //controller.helper.itemToRemove = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
        controller.saveWorkList();
        System.DEBUG('Worklist After Remove :' + controller.helper.basket);
        //System.assertEquals(0,controller.helper.worklist.get('ACTIVITY').itemCount);

        // When
        //Test.startTest();
    }*/

    private static void createBaselineSOW(Boolean createCampaignSet) {

        //Creating SOW
        sow.Active__c = true;
        sow.Name = 'Marketing Sow Approval';
        sow.SOW_Status__c = 'Open';
        sow.Financial_Year__c = 'FY2016';
        //sow.Oblix_AgencyEstimate__c = myAccount.Id;
        insert sow;


        List <Oblix_Calculator__c> countriesNames = new List <Oblix_Calculator__c>();
        countriesNames =[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.Name 
                        from Oblix_Calculator__c  LIMIT 50000];


        List<Marketing_Basics__c> nonCampaigns = Oblix_TestUtils.createMarketingBasics(sow.Id, 7);

        if(createCampaignSet){
            //[0,1] - Activity / Brandbook
            setFirstNonCampaignsSet(nonCampaigns, countriesNames);

            //[2,3] - Activity / Brandbook
            setSecondNonCampaignsSet(nonCampaigns, countriesNames);

            //[4] - Activity / Brandbook
            setThirdNonCampaignsSet(nonCampaigns, countriesNames);

            //[5,6] - Activity / Brandbook
            setFourthNonCampaignsSet(nonCampaigns, countriesNames);
        }

        insert nonCampaigns;



    }

    private static void setFirstNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 0; i < 2; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Brand Book';
            nonCampaignItem.Non_campaign_title__c = 'Brand Book';
            nonCampaignItem.Activities__c = 'Brand Book';
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = ((i == 0) ? 'Digital Junior Account Manager' : 'Head of Digital');
            nonCampaignItem.Description__c = ((i == 0) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }

    private static void setSecondNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 2; i < 4; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Other test';
            nonCampaignItem.Non_campaign_title__c = 'Other';
            nonCampaignItem.Activities__c = 'Other';
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = ((i == 2) ? 'Digital Junior Account Manager' : 'Head of Digital');
            nonCampaignItem.Description__c = ((i == 2) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + nonCampaignItem.Name + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }

    private static void setThirdNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 4; i < 5; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Brand Communication Idea';
            nonCampaignItem.Non_campaign_title__c = 'Brand Communication Idea';
            nonCampaignItem.Activities__c = 'Brand Communication Idea';
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = 'Head of Digital';
            nonCampaignItem.Description__c = '';

            nonCampaignItem.No_of_Hours_Required__c = 33.5;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 36.5;
            nonCampaignItem.OblixOtherItemFee__c = 1222.75;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }


    private static void setFourthNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 5; i < 7; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'DedicatedResource1';
            nonCampaignItem.Non_campaign_title__c = '';
            nonCampaignItem.Activities__c = '';
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Creative';
            nonCampaignItem.Role_Title__c = ((i == 5) ? 'Creative Director' : 'Associate Creative Director');
            nonCampaignItem.Description__c = ((i == 5) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Name + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }








/*
    static Marketing_Basics__c globalAct; 

    @isTest private static void createMaketingSow (){
      
         Account myAccount = new Account();
             myAccount.Name = 'AgencyAccount';
         insert myAccount;
         Marketing_SOW__c marketingSow = new Marketing_SOW__c();
            marketingSow.Active__c = true;
            marketingSow.Name = 'Marketinf Sow Approval';
            marketingSow.SOW_Status__c = 'Open';
            marketingSow.Financial_Year__c = 'FY2015';
            marketingSow.Oblix_AgencyEstimate__c = myAccount.Id;
            insert marketingSow;
            MDO_Geography__c geographyRegion = new MDO_Geography__c();
            geographyRegion.Name = 'Europe';
            geographyRegion.geography_type__c = 'Region';
            insert geographyRegion;
          
          MDO_Geography__c geographyCountry = new MDO_Geography__c();
            geographyCountry.Name = 'France';
            geographyCountry.geography_type__c = 'Country';
            geographyCountry.parent_L5__c = geographyRegion.Id;
            insert geographyCountry;  
          Oblix_Calculator__c roleRate = new Oblix_Calculator__c();
              roleRate.Agency_Department__c = 'Account Management';
              roleRate.Role_Title__c = 'Global Account Head';
              roleRate.OblixCountry__c = geographyCountry.Id;
              roleRate.FTE__c = 20;
              roleRate.Role_Daily_Rate_EUR__c = 10;
              roleRate.Financial_Year__c = marketingSow.Financial_Year__c ;
              roleRate.RecordTypeId = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate');
              roleRate.Oblix_Agency__c = marketingSow.Oblix_AgencyEstimate__c;
              insert roleRate; 
          String marKObjName = 'Marketing_Basics__c';
          Marketing_Basics__c basicParent = new Marketing_Basics__c();
            basicParent.Non_Campaign_Key__c = '123';
            basicParent.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParent.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
            basicParent.OblixCountry__c = geographyCountry.Id;
            basicParent.OblixOtherItemFee__c  = 33;
            basicParent.No_of_Hours_Required__c = 5;
            insert basicParent;
            
      Marketing_Basics__c basicParent1 = new Marketing_Basics__c();
            basicParent1.Non_Campaign_Key__c = '124';
            basicParent1.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParent1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
            basicParent1.FTE__c = 50;
            basicParent1.OblixCountry__c = geographyCountry.Id;
            basicParent1.OblixOtherItemFee__c  = 33;
            basicParent1.No_of_Hours_Required__c = 5;
            insert basicParent1;
          
            
          Marketing_Basics__c basicParentActivity = new Marketing_Basics__c();
            basicParentActivity.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParentActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');
            basicParentActivity.OblixCountry__c = geographyCountry.Id;
            basicParentActivity.Non_Campaign_Key__c = '125';
            basicParentActivity.No_of_Hours_Required__c = 5;
          Marketing_Basics__c basicParentActivity1 = new Marketing_Basics__c();
            basicParentActivity1.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParentActivity1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');  
            //basicParentActivity1.FTE__c = 50;
            basicParentActivity1.No_of_Hours_Required__c = 10;
            basicParentActivity1.OblixCountry__c = geographyCountry.Id;
            basicParentActivity1.Non_Campaign_Key__c = '126';
            basicParentActivity1.No_of_Hours_Required__c = 5;
            basicParentActivity1.OblixOtherItemFee__c = 10;
            basicParentActivity1.name = 'preselected';
            insert basicParentActivity1;
            globalAct = basicParentActivity1;
            //return marketingSow.id; 


            User u = Oblix_TestUtils.createTestUser(); 
         
        System.runAs(u){
   
            Test.startTest();
            ApexPages.currentPage().getParameters().put('preSelectedName', 'preselected' );
            ApexPages.currentPage().getParameters().put('sowId', marketingSow.id);
            //Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();
                 
            //controller.seletedActivity = JSON.serialize(globalAct);
            //test insert activity
            //controller.selectedTab = 'activity';
            //controller.activity.name='istest';
            ////controller.activity.selectedCountryname ='France' ;
            ////controller.fillAgencyDepartment();
            ////controller.activity.selectedAgencyDepartment= 'Account Management';
            ////controller.activity.hourlyRate = '100';
            ////controller.fillRoleTitle();
            ////controller.fillRate();

            ////controller.resource.name='istest';
            ////controller.resource.selectedCountryname ='France' ;
            ////controller.resource.selectedAgencyDepartment= 'Account Management';
            ////controller.getSelectedActivitiesByName();
            ////controller.addToActivitySelectionMap();
            ////controller.insertSelectedActivitiesAndRefreshBasket();
            ////controller.removeFromSelectionMap();
            ////controller.removeItemFromBasketList();
            ////controller.upsertSelectedResourceAndRefreshBasket();
            ////controller.clearActivitySelectionMap();
            //List<SelectOption> roleTitle = new List<SelectOption>{new SelectOption('1','1')};
            //Map<String,String> roleTitlesNameMap = new  Map<String,String>();
            //roleTitlesNameMap.put('1','1');
            //List<SelectOption> result = controller.populateRoleTitleList(roleTitlesNameMap);
            //System.assert(result != null);
            System.assert(ApexPages.currentPage().getParameters() != null);


            //System.assertNotEquals(null, controller.activity.nonCampaignItem);
            //System.assertEquals(null, controller.activity.selectedCountry);
            //System.assertEquals(null, controller.activity.selectedCountryname);
            //System.assertEquals(null, controller.activity.selectedActivity);
            //System.assertEquals(null, controller.activity.selectedCountryActivity);
            //System.assertEquals(null, controller.activity.selectedAgencyDepartment);
            //System.assertEquals(null, controller.activity.selectedRole);
            //System.assertEquals(null, controller.activity.hourlyRate);
            //System.assertEquals(null, controller.activity.roundedRate);
            //System.assertEquals(null, controller.activity.hoursSelected);
            //System.assertEquals(null, controller.activity.result);
            //System.assertEquals(null, controller.activity.name);
            //System.assertEquals(null, controller.activity.totalAmount);
            //System.assertEquals(null, controller.activity.key);
            //System.assertEquals(null, controller.activity.activityId);
            //System.assertEquals(null, controller.activity.agencyVisible);
            //System.assertEquals(null, controller.activity.roleVisible);
            //System.assertEquals(null, controller.activity.valVisible);


            Test.stopTest();
               
         }
        
    }
 */




/*
   @isTest
private class Oblix_SOWNonCampaignCreateCtrl_Test {

    private static final String SOW_ID_PAGE_PARAMETER = 'sowId';
    private static final String PRESELECTED_ITEM_PAGE_PARAMETER = 'preSelectedSection';

    private static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART = '{"selectedCountry":"Argentina","selectedActivity":"Brand Communication Idea","selectedAgencyDepartment":"Creative","selectedRole":"Copywriter","otherName":"","description":"","hourlyRate":"45.502","hoursSelected":"5","totalAmount":227.51000000000002,"key":"';

    private static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART = 'Brand Communication IdeaArgentinaCreativeCopywriter","isActivity":true}';
    private static final String BRAND_BOOK = 'brand book';

    private static Marketing_SOW__c sow = new Marketing_SOW__c();


    @testSetup static void initCommonData() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();
        }
    }


    @isTest private static void testBasketInit() {
        createBaselineSOW(true);

        Test.startTest();
        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        Test.stopTest();
        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(4 ,controller.helper.basket.keySet().size());

        // When
        //Test.startTest();
    }

    @isTest private static void testAddToWorklist() {
        createBaselineSOW(false);

        Test.startTest();
        
        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        System.assertEquals(0 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
        controller.addToWorkList();

        Test.stopTest();

        System.assertEquals(2,controller.helper.worklist.size());

        // When
        //Test.startTest();
    }

    @isTest private static void testOpenActivityForUpdate() {
        createBaselineSOW(false);

        Test.startTest();
        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        //System.DEBUG(controller.nonCampaignItemToAddJSON);
        //System.DEBUG('Worklist Before Add :' + controller.helper.worklist);
        controller.addToWorkList();
        controller.helper.currentItemKey = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
        controller.openActivityForUpdate();
        //System.DEBUG('Worklist After Add :' + controller.helper.worklist);
        Test.stopTest();
        System.assertEquals(2,controller.helper.worklist.size());

        // When
        //Test.startTest();
    }

    @isTest private static void testOpenResourceForUpdate() {
        createBaselineSOW(false);

        Test.startTest();
        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        //System.DEBUG(controller.nonCampaignItemToAddJSON);
        //System.DEBUG('Worklist Before Add :' + controller.helper.worklist);
        controller.addToWorkList();
        controller.helper.currentItemKey = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
        controller.openResourceForUpdate();
        //System.DEBUG('Worklist After Add :' + controller.helper.worklist);
        Test.stopTest();
        System.assertEquals(2,controller.helper.worklist.size());

        // When
        //Test.startTest();
    }

    @isTest private static void testRemoveItem() {
        createBaselineSOW(false);
        Test.startTest();

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        //System.DEBUG(controller.nonCampaignItemToAddJSON);
        //System.DEBUG('Worklist Before Add :' + controller.helper.worklist);
        controller.addToWorkList();
        //System.DEBUG('Worklist After Add :' + controller.helper.worklist);
        //System.assertEquals(1,controller.helper.worklist.get('ACTIVITY').itemCount);
        controller.helper.itemToRemove = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
        controller.removeItem();
        Test.stopTest();
        //System.DEBUG('Worklist After Remove :' + controller.helper.worklist);
        //System.assertEquals(0,controller.helper.worklist.get('ACTIVITY').itemCount);

        // When
        //Test.startTest();
    }

     @isTest private static void testSaveWorkList() {
        createBaselineSOW(false);

        Test.startTest();
        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        System.DEBUG(controller.nonCampaignItemToAddJSON);
        System.DEBUG('Worklist Before Add :' + controller.helper.basket);
        controller.addToWorkList();
        System.DEBUG('Worklist After Add :' + controller.helper.basket);
        System.DEBUG('Worklist After Add keyset :' + controller.helper.basket.keyset());
        System.assertEquals(1,controller.helper.worklist.get('ACTIVITY').itemCount);
        //controller.helper.itemToRemove = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
        controller.saveWorkList();
        System.DEBUG('Worklist After save :' + controller.helper.basket);
        System.DEBUG('Worklist After save keyset :' + controller.helper.basket.keyset());
        Test.stopTest();
        System.assertEquals(1,controller.helper.basket.get('BRAND COMMUNICATION IDEA').itemCount);

        // When
        //Test.startTest();
    }

    @isTest private static void testRemoveSection() {
        createBaselineSOW(false);

        Test.startTest();
        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(1 ,controller.helper.basket.keySet().size());

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        System.DEBUG(controller.nonCampaignItemToAddJSON);
        System.DEBUG('Worklist Before Add :' + controller.helper.basket);
        controller.addToWorkList();
        System.DEBUG('Worklist After Add :' + controller.helper.basket);
        System.DEBUG('Worklist After Add keyset :' + controller.helper.basket.keyset());
        System.assertEquals(1,controller.helper.worklist.get('ACTIVITY').itemCount);
        //controller.helper.itemToRemove = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
        controller.saveWorkList();
        System.DEBUG('Worklist After save :' + controller.helper.basket);
        System.DEBUG('Worklist After save keyset :' + controller.helper.basket.keyset());
        System.assertEquals(1,controller.helper.basket.get('BRAND COMMUNICATION IDEA').itemCount);
        controller.helper.sectionToRemove = 'BRAND COMMUNICATION IDEA';
        controller.removeSection();
        Test.stopTest();
        System.DEBUG('Worklist After remove :' + controller.helper.basket);
        System.DEBUG('Worklist After remove keyset :' + controller.helper.basket.keyset());
        System.assertEquals(null,controller.helper.basket.get('BRAND COMMUNICATION IDEA'));
        // When
        //Test.startTest();
    }

    private static void createBaselineSOW(Boolean createCampaignSet) {

        //Creating SOW
        sow.Active__c = true;
        sow.Name = 'Marketing Sow Approval';
        sow.SOW_Status__c = 'Open';
        sow.Financial_Year__c = 'FY2016';
        //sow.Oblix_AgencyEstimate__c = myAccount.Id;
        insert sow;


        List <Oblix_Calculator__c> countriesNames = new List <Oblix_Calculator__c>();
        countriesNames =[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.Name 
                        from Oblix_Calculator__c  LIMIT 50000];


        if(createCampaignSet){
            List<Marketing_Basics__c> nonCampaigns = Oblix_TestUtils.createMarketingBasics(sow.Id, 7);

            //[0,1] - Activity / Brandbook
            setFirstNonCampaignsSet(nonCampaigns, countriesNames);

            //[2,3] - Activity / Brandbook
            setSecondNonCampaignsSet(nonCampaigns, countriesNames);

            //[4] - Activity / Brandbook
            setThirdNonCampaignsSet(nonCampaigns, countriesNames);

            //[5,6] - Activity / Brandbook
            setFourthNonCampaignsSet(nonCampaigns, countriesNames);

            insert nonCampaigns;
        }


    }

    private static void setFirstNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 0; i < 2; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = BRAND_BOOK;
            nonCampaignItem.Non_campaign_title__c = BRAND_BOOK;
            nonCampaignItem.Activities__c = BRAND_BOOK;
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = ((i == 0) ? 'Digital Junior Account Manager' : 'Head of Digital');
            nonCampaignItem.Description__c = ((i == 0) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            nonCampaignItem.Hourly_Rate_or_FTE__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }

    private static void setSecondNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 2; i < 4; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Other test';
            nonCampaignItem.Non_campaign_title__c = 'Other';
            nonCampaignItem.Activities__c = 'Other';
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = ((i == 2) ? 'Digital Junior Account Manager' : 'Head of Digital');
            nonCampaignItem.Description__c = ((i == 2) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            nonCampaignItem.Hourly_Rate_or_FTE__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + nonCampaignItem.Name + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }

    private static void setThirdNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 4; i < 5; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Brand Communication Idea';
            nonCampaignItem.Non_campaign_title__c = 'Brand Communication Idea';
            nonCampaignItem.Activities__c = 'Brand Communication Idea';
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = 'Head of Digital';
            nonCampaignItem.Description__c = '';

            nonCampaignItem.No_of_Hours_Required__c = 33.5;
            nonCampaignItem.Hourly_Rate_or_FTE__c = 36.5;
            nonCampaignItem.OblixOtherItemFee__c = 1222.75;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }


    private static void setFourthNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, List <Oblix_Calculator__c> countriesNames){

        for (Integer i = 5; i < 7; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'DedicatedResource1';
            nonCampaignItem.Non_campaign_title__c = '';
            nonCampaignItem.Activities__c = '';
            nonCampaignItem.OblixCountry__c = countriesNames[0].OblixCountry__c;
            nonCampaignItem.Agency_Department__c = 'Creative';
            nonCampaignItem.Role_Title__c = ((i == 5) ? 'Creative Director' : 'Associate Creative Director');
            nonCampaignItem.Description__c = ((i == 5) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            nonCampaignItem.Hourly_Rate_or_FTE__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Name + 
                                    countriesNames[0].OblixCountry__r.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }




 
 */
}