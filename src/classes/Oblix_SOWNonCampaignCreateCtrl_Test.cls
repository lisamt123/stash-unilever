<<<<<<< HEAD
@isTest
// test continued on Oblix_SOWNonCampaignCreateCtrl_Test2 - which uses public attributes and methods from this class
public class Oblix_SOWNonCampaignCreateCtrl_Test {

    public static final String SOW_ID_PAGE_PARAMETER = 'sowId';
    public static final String PRESELECTED_ITEM_PAGE_PARAMETER = 'preSelectedSection';

    public static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART = '{"selectedCountry":"Argentina","selectedActivity":"Brand Communication Idea","selectedAgencyDepartment":"Creative","selectedRole":"Copywriter","otherName":"","description":"","hourlyRate":"45.502","hoursSelected":"5","totalAmount":227.51000000000002,"key":"';
    public static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART = 'Brand Communication IdeaArgentinaCreativeCopywriter","isActivity":true}';
    private static final String NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_FIRST_PART = '{"name":"testResource","selectedCountry":"Argentina","selectedActivity":"","selectedAgencyDepartment":"Creative","selectedRole":"Copywriter","otherName":"","description":"","hourlyRate":"45.502","hoursSelected":"5","totalAmount":227.51000000000002,"key":"';
    private static final String NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_SECOND_PART = 'testResourceArgentinaCreativeCopywriter","isActivity":false}';

    public static final String BRAND_BOOK = 'BRAND BOOK';
    public static final String ACTIVITY = 'ACTIVITY';
    private static final String TEST_RESOURCE_NAME = 'DedicatedResource1';

    private static Marketing_SOW__c sow = new Marketing_SOW__c();


    //@testSetup static void initCommonData() {
    static void initCommonData(Boolean createCampaignSet) {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();

            List<MDO_Geography__c> list_mdo_geography = Oblix_TestUtils.createMDOgeography();
            insert list_mdo_geography;
            list_mdo_geography = [SELECT Name FROM MDO_Geography__c WHERE geography_type__c = 'Country' AND Name = 'ARGENTINA' LIMIT 1];

            Account agency = new Account(Name = 'Test Agency unique123');
            insert agency;

            insert Oblix_TestUtils.createRoleRateCalculatorRecords(list_mdo_geography[0].Id, agency.Id);
        }

        Account agency = [SELECT Id FROM Account WHERE Name = 'Test Agency unique123' LIMIT 1];

        //Creating SOW
        sow.Active__c = true;
        sow.Name = 'Marketing Sow Approval';
        sow.SOW_Status__c = 'Open';
        sow.Financial_Year__c = 'FY2016';
        sow.Oblix_AgencyEstimate__c = agency.Id;
        insert sow;


        MDO_Geography__c country = [SELECT Id, Name FROM MDO_Geography__c WHERE geography_type__c = 'Country' AND Name = 'ARGENTINA' LIMIT 1];


        if(createCampaignSet){

            List<Marketing_Basics__c> nonCampaigns = Oblix_TestUtils.createMarketingBasics(sow.Id, 7);

            //[0,1] - Activity / Brandbook
            //[2,3] - Activity / Brandbook
            setFirstNonCampaignsSet(nonCampaigns, country);

            //[4] - Activity / Brandbook
            //[5,6] - Activity / Brandbook
            setSecondNonCampaignsSet(nonCampaigns, country);

            insert nonCampaigns;
        }



    }

    //private static void createBaselineSOW(Boolean createCampaignSet) {

    //    Account agency = [SELECT Id FROM Account WHERE Name = 'Test Agency unique123' LIMIT 1];

    //    //Creating SOW
    //    sow.Active__c = true;
    //    sow.Name = 'Marketing Sow Approval';
    //    sow.SOW_Status__c = 'Open';
    //    sow.Financial_Year__c = 'FY2016';
    //    sow.Oblix_AgencyEstimate__c = agency.Id;
    //    insert sow;


    //    MDO_Geography__c country = [SELECT Id, Name FROM MDO_Geography__c WHERE geography_type__c = 'Country' AND Name = 'ARGENTINA' LIMIT 1];


    //    if(createCampaignSet){

    //        List<Marketing_Basics__c> nonCampaigns = Oblix_TestUtils.createMarketingBasics(sow.Id, 7);

    //        //[0,1] - Activity / Brandbook
    //        //[2,3] - Activity / Brandbook
    //        setFirstNonCampaignsSet(nonCampaigns, country);

    //        //[4] - Activity / Brandbook
    //        //[5,6] - Activity / Brandbook
    //        setSecondNonCampaignsSet(nonCampaigns, country);

    //        insert nonCampaigns;
    //    }

    //}


    


    @isTest private static void testOpenActivityForUpdate() {
        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
        controller.addToWorkList();

        Test.startTest();
        
            controller.helper.currentItemKey = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
            controller.openActivityForUpdate();
        
        Test.stopTest();

        System.assertEquals(sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter', controller.helper.currentActivity.key);
        System.assertEquals('ACTIVITY', controller.helper.currentTab);

    }

    @isTest private static void testOpenResourceForUpdate() {
        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();


        controller.helper.currentTab = controller.helper.RESOURCE_DEV_NAME.toUpperCase();
        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_SECOND_PART;
        controller.addToWorkList();

        Test.startTest();

            controller.helper.currentItemKey = sow.Id + 'testResourceArgentinaCreativeCopywriter';
            controller.openResourceForUpdate();

        Test.stopTest();
        
        System.assertEquals(sow.Id + 'testResourceArgentinaCreativeCopywriter', controller.helper.currentResource.key);
        System.assertEquals('RESOURCE', controller.helper.currentTab);

    }


    @isTest private static void testFinishBasket() {

        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        System.assertEquals(true, controller.can_manage_non_campaign);
        System.assertEquals(false, controller.is_agency_user);

        Test.startTest();

            PageReference res = controller.finishBasket();

        Test.stopTest();

        System.debug('### pageref url: ' + res.getUrl());
        System.assertEquals('/apex/oblix_sowmaindetail?sowId='+sow.Id, res.getUrl());

    }



    @isTest private static void testIsUpdateActivity() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first BRANDBOOK item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK).items.values()[0];

        Test.startTest();

            controller.helper.currentActivity.key = '123';
            System.assertEquals(false, controller.helper.isUpdateActivity);


            //Select item that exists only in work list
            controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
            controller.addToWorkList();
            controller.helper.currentActivity.key = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
            System.assertEquals(true, controller.helper.isUpdateActivity);
            

            //Select item that exists only in the basket
            controller.helper.currentActivity = item;
            System.assertEquals(true, controller.helper.isUpdateActivity);

        Test.stopTest();

    }



    @isTest private static void testIsUpdateResource() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(controller.helper.RESOURCE_DEV_NAME.toUpperCase()).items.values()[0];

        Test.startTest();

            controller.helper.currentResource.key = '123';
            System.assertEquals(false, controller.helper.isUpdateResource);


            //Select item that exists only in work list
            controller.helper.currentTab = controller.helper.RESOURCE_DEV_NAME.toUpperCase();
            controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_SECOND_PART;
            controller.addToWorkList();
            controller.helper.currentResource.key = sow.Id + 'testResourceArgentinaCreativeCopywriter';
            System.assertEquals(true, controller.helper.isUpdateResource);
            

            //Select item that exists only in the basket
            controller.helper.currentResource = item;
            System.assertEquals(true, controller.helper.isUpdateResource);

        Test.stopTest();

    }



    @isTest private static void testFillPicklists() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK.toUpperCase()).items.values()[0];

        Test.startTest();

            controller.helper.currentItemKey = item.key;
            controller.openActivityForUpdate();

        Test.stopTest();

        System.assertNotEquals(0, controller.helper.countries.size());
        System.assertNotEquals(0, controller.helper.agencyRoleTitle.size());
        System.assertNotEquals(0, controller.helper.agencyDepartments.size());

    }




    @isTest private static void testRefreshActivitySelection() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK.toUpperCase()).items.values()[0];

        Oblix_NonCampaignWrapper resource = controller.helper.basket.get(controller.helper.RESOURCE_DEV_NAME.toUpperCase()).items.values()[0];

        Test.startTest();

            controller.helper.currentItemKey = item.key;
            controller.openActivityForUpdate();

            controller.helper.currentActivity.selectedActivity = 'Test';
            controller.helper.refreshActivitySelection();

            controller.helper.currentSection = controller.helper.RESOURCE_DEV_NAME;
            controller.helper.openBasketSection();
            controller.helper.currentItemKey = resource.key;
            controller.openActivityForUpdate();
            controller.helper.refreshActivitySelection();

        Test.stopTest();

        System.assertNotEquals(0, controller.helper.countries.size());

    }


    @isTest private static void testOpenTab() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK.toUpperCase()).items.values()[0];

        Test.startTest();

            controller.helper.currentTab = controller.helper.RESOURCE_DEV_NAME;
            controller.helper.openTab();

            System.assertEquals(controller.helper.RESOURCE_DEV_NAME.toUpperCase(), controller.helper.currentSection);

            controller.helper.currentTab = controller.helper.ACTIVITY_DEV_NAME;
            controller.helper.openTab();

            System.assertEquals(null, controller.helper.currentSection);

            controller.helper.currentSection = controller.helper.RESOURCE_DEV_NAME;
            controller.helper.openBasketSection();

            System.assertEquals(controller.helper.RESOURCE_DEV_NAME.toUpperCase(), controller.helper.currentSection);

        Test.stopTest();

    }

    public static void setFirstNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, MDO_Geography__c country){

        for (Integer i = 0; i < 2; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Brand Book';
            nonCampaignItem.Non_campaign_title__c = 'Brand Book';
            nonCampaignItem.Activities__c = 'Brand Book';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Account Management';
            if(i == 0){
                nonCampaignItem.Role_Title__c = 'Account Director';
                nonCampaignItem.Description__c = 'Test description';
            } else {
                nonCampaignItem.Role_Title__c = 'Account Executive';
                nonCampaignItem.Description__c = '';
            }
            //nonCampaignItem.Role_Title__c = ((i == 0) ? 'Account Director' : 'Account Executive');
            //nonCampaignItem.Description__c = ((i == 0) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

        for (Integer i = 2; i < 4; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Other test';
            nonCampaignItem.Non_campaign_title__c = 'Other';
            nonCampaignItem.Activities__c = 'Other';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            if(i == 2){
                nonCampaignItem.Role_Title__c = 'Digital Junior Account Manager';
                nonCampaignItem.Description__c = 'Test description';
            } else {
                nonCampaignItem.Role_Title__c = 'Head of Digital';
                nonCampaignItem.Description__c = '';
            }
            //nonCampaignItem.Role_Title__c = ((i == 2) ? 'Digital Junior Account Manager' : 'Head of Digital');
            //nonCampaignItem.Description__c = ((i == 2) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + nonCampaignItem.Name + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }

    public static void setSecondNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, MDO_Geography__c country){

        for (Integer i = 4; i < 5; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Brand Communication Idea';
            nonCampaignItem.Non_campaign_title__c = 'Brand Communication Idea';
            nonCampaignItem.Activities__c = 'Brand Communication Idea';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = 'Head of Digital';
            nonCampaignItem.Description__c = '';

            nonCampaignItem.No_of_Hours_Required__c = 33.5;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 36.5;
            nonCampaignItem.OblixOtherItemFee__c = 1222.75;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

        for (Integer i = 5; i < 7; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = TEST_RESOURCE_NAME;
            nonCampaignItem.Non_campaign_title__c = '';
            nonCampaignItem.Activities__c = '';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Creative';
            nonCampaignItem.Role_Title__c = ((i == 5) ? 'Creative Director' : 'Associate Creative Director');
            nonCampaignItem.Description__c = ((i == 5) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Name + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
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


=======
@isTest
// test continued on Oblix_SOWNonCampaignCreateCtrl_Test2 - which uses public attributes and methods from this class
public class Oblix_SOWNonCampaignCreateCtrl_Test {

    public static final String SOW_ID_PAGE_PARAMETER = 'sowId';
    public static final String PRESELECTED_ITEM_PAGE_PARAMETER = 'preSelectedSection';

    public static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART = '{"selectedCountry":"Argentina","selectedActivity":"Brand Communication Idea","selectedAgencyDepartment":"Creative","selectedRole":"Copywriter","otherName":"","description":"","hourlyRate":"45.502","hoursSelected":"5","totalAmount":227.51000000000002,"key":"';
    public static final String NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART = 'Brand Communication IdeaArgentinaCreativeCopywriter","isActivity":true}';
    private static final String NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_FIRST_PART = '{"name":"testResource","selectedCountry":"Argentina","selectedActivity":"","selectedAgencyDepartment":"Creative","selectedRole":"Copywriter","otherName":"","description":"","hourlyRate":"45.502","hoursSelected":"5","totalAmount":227.51000000000002,"key":"';
    private static final String NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_SECOND_PART = 'testResourceArgentinaCreativeCopywriter","isActivity":false}';

    public static final String BRAND_BOOK = 'BRAND BOOK';
    public static final String ACTIVITY = 'ACTIVITY';
    private static final String TEST_RESOURCE_NAME = 'DedicatedResource1';

    private static Marketing_SOW__c sow = new Marketing_SOW__c();


    //@testSetup static void initCommonData() {
    static void initCommonData(Boolean createCampaignSet) {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();

            List<MDO_Geography__c> list_mdo_geography = Oblix_TestUtils.createMDOgeography();
            insert list_mdo_geography;
            list_mdo_geography = [SELECT Name FROM MDO_Geography__c WHERE geography_type__c = 'Country' AND Name = 'ARGENTINA' LIMIT 1];

            Account agency = new Account(Name = 'Test Agency unique123');
            insert agency;

            insert Oblix_TestUtils.createRoleRateCalculatorRecords(list_mdo_geography[0].Id, agency.Id);
        }

        Account agency = [SELECT Id FROM Account WHERE Name = 'Test Agency unique123' LIMIT 1];

        //Creating SOW
        sow.Active__c = true;
        sow.Name = 'Marketing Sow Approval';
        sow.SOW_Status__c = 'Open';
        sow.Financial_Year__c = 'FY2016';
        sow.Oblix_AgencyEstimate__c = agency.Id;
        insert sow;


        MDO_Geography__c country = [SELECT Id, Name FROM MDO_Geography__c WHERE geography_type__c = 'Country' AND Name = 'ARGENTINA' LIMIT 1];


        if(createCampaignSet){

            List<Marketing_Basics__c> nonCampaigns = Oblix_TestUtils.createMarketingBasics(sow.Id, 7);

            //[0,1] - Activity / Brandbook
            //[2,3] - Activity / Brandbook
            setFirstNonCampaignsSet(nonCampaigns, country);

            //[4] - Activity / Brandbook
            //[5,6] - Activity / Brandbook
            setSecondNonCampaignsSet(nonCampaigns, country);

            insert nonCampaigns;
        }



    }

    //private static void createBaselineSOW(Boolean createCampaignSet) {

    //    Account agency = [SELECT Id FROM Account WHERE Name = 'Test Agency unique123' LIMIT 1];

    //    //Creating SOW
    //    sow.Active__c = true;
    //    sow.Name = 'Marketing Sow Approval';
    //    sow.SOW_Status__c = 'Open';
    //    sow.Financial_Year__c = 'FY2016';
    //    sow.Oblix_AgencyEstimate__c = agency.Id;
    //    insert sow;


    //    MDO_Geography__c country = [SELECT Id, Name FROM MDO_Geography__c WHERE geography_type__c = 'Country' AND Name = 'ARGENTINA' LIMIT 1];


    //    if(createCampaignSet){

    //        List<Marketing_Basics__c> nonCampaigns = Oblix_TestUtils.createMarketingBasics(sow.Id, 7);

    //        //[0,1] - Activity / Brandbook
    //        //[2,3] - Activity / Brandbook
    //        setFirstNonCampaignsSet(nonCampaigns, country);

    //        //[4] - Activity / Brandbook
    //        //[5,6] - Activity / Brandbook
    //        setSecondNonCampaignsSet(nonCampaigns, country);

    //        insert nonCampaigns;
    //    }

    //}


    


    @isTest private static void testOpenActivityForUpdate() {
        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
        controller.addToWorkList();

        Test.startTest();
        
            controller.helper.currentItemKey = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
            controller.openActivityForUpdate();
        
        Test.stopTest();

        System.assertEquals(sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter', controller.helper.currentActivity.key);
        System.assertEquals('ACTIVITY', controller.helper.currentTab);

    }

    @isTest private static void testOpenResourceForUpdate() {
        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();


        controller.helper.currentTab = controller.helper.RESOURCE_DEV_NAME.toUpperCase();
        controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_SECOND_PART;
        controller.addToWorkList();

        Test.startTest();

            controller.helper.currentItemKey = sow.Id + 'testResourceArgentinaCreativeCopywriter';
            controller.openResourceForUpdate();

        Test.stopTest();
        
        System.assertEquals(sow.Id + 'testResourceArgentinaCreativeCopywriter', controller.helper.currentResource.key);
        System.assertEquals('RESOURCE', controller.helper.currentTab);

    }


    @isTest private static void testFinishBasket() {

        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        System.assertEquals(true, controller.can_manage_non_campaign);
        System.assertEquals(false, controller.is_agency_user);

        Test.startTest();

            PageReference res = controller.finishBasket();

        Test.stopTest();

        System.debug('### pageref url: ' + res.getUrl());
        System.assertEquals('/apex/oblix_sowmaindetail?sowId='+sow.Id, res.getUrl());

    }



    @isTest private static void testIsUpdateActivity() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first BRANDBOOK item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK).items.values()[0];

        Test.startTest();

            controller.helper.currentActivity.key = '123';
            System.assertEquals(false, controller.helper.isUpdateActivity);


            //Select item that exists only in work list
            controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
            controller.addToWorkList();
            controller.helper.currentActivity.key = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
            System.assertEquals(true, controller.helper.isUpdateActivity);
            

            //Select item that exists only in the basket
            controller.helper.currentActivity = item;
            System.assertEquals(true, controller.helper.isUpdateActivity);

        Test.stopTest();

    }



    @isTest private static void testIsUpdateResource() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(controller.helper.RESOURCE_DEV_NAME.toUpperCase()).items.values()[0];

        Test.startTest();

            controller.helper.currentResource.key = '123';
            System.assertEquals(false, controller.helper.isUpdateResource);


            //Select item that exists only in work list
            controller.helper.currentTab = controller.helper.RESOURCE_DEV_NAME.toUpperCase();
            controller.nonCampaignItemToAddJSON = NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_FIRST_PART + sow.Id + NON_CAMPAIGN_RESOURCE_WORKLIST_JSON_SECOND_PART;
            controller.addToWorkList();
            controller.helper.currentResource.key = sow.Id + 'testResourceArgentinaCreativeCopywriter';
            System.assertEquals(true, controller.helper.isUpdateResource);
            

            //Select item that exists only in the basket
            controller.helper.currentResource = item;
            System.assertEquals(true, controller.helper.isUpdateResource);

        Test.stopTest();

    }



    @isTest private static void testFillPicklists() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK.toUpperCase()).items.values()[0];

        Test.startTest();

            controller.helper.currentItemKey = item.key;
            controller.openActivityForUpdate();

        Test.stopTest();

        System.assertNotEquals(0, controller.helper.countries.size());
        System.assertNotEquals(0, controller.helper.agencyRoleTitle.size());
        System.assertNotEquals(0, controller.helper.agencyDepartments.size());

    }




    @isTest private static void testRefreshActivitySelection() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK.toUpperCase()).items.values()[0];

        Oblix_NonCampaignWrapper resource = controller.helper.basket.get(controller.helper.RESOURCE_DEV_NAME.toUpperCase()).items.values()[0];

        Test.startTest();

            controller.helper.currentItemKey = item.key;
            controller.openActivityForUpdate();

            controller.helper.currentActivity.selectedActivity = 'Test';
            controller.helper.refreshActivitySelection();

            controller.helper.currentSection = controller.helper.RESOURCE_DEV_NAME;
            controller.helper.openBasketSection();
            controller.helper.currentItemKey = resource.key;
            controller.openActivityForUpdate();
            controller.helper.refreshActivitySelection();

        Test.stopTest();

        System.assertNotEquals(0, controller.helper.countries.size());

    }


    @isTest private static void testOpenTab() {

        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(PRESELECTED_ITEM_PAGE_PARAMETER, BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Refernce to first TEST_RESOURCE_NAME item in the basket
        Oblix_NonCampaignWrapper item = controller.helper.basket.get(BRAND_BOOK.toUpperCase()).items.values()[0];
        system.assert(true,item!=null);
        Test.startTest();

            controller.helper.currentTab = controller.helper.RESOURCE_DEV_NAME;
            controller.helper.openTab();

            System.assertEquals(controller.helper.RESOURCE_DEV_NAME.toUpperCase(), controller.helper.currentSection);

            controller.helper.currentTab = controller.helper.ACTIVITY_DEV_NAME;
            controller.helper.openTab();

            System.assertEquals(null, controller.helper.currentSection);

            controller.helper.currentSection = controller.helper.RESOURCE_DEV_NAME;
            controller.helper.openBasketSection();

            System.assertEquals(controller.helper.RESOURCE_DEV_NAME.toUpperCase(), controller.helper.currentSection);

        Test.stopTest();

    }

    public static void setFirstNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, MDO_Geography__c country){

        for (Integer i = 0; i < 2; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Brand Book';
            nonCampaignItem.Non_campaign_title__c = 'Brand Book';
            nonCampaignItem.Activities__c = 'Brand Book';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Account Management';
            if(i == 0){
                nonCampaignItem.Role_Title__c = 'Account Director';
                nonCampaignItem.Description__c = 'Test description';
            } else {
                nonCampaignItem.Role_Title__c = 'Account Executive';
                nonCampaignItem.Description__c = '';
            }
            //nonCampaignItem.Role_Title__c = ((i == 0) ? 'Account Director' : 'Account Executive');
            //nonCampaignItem.Description__c = ((i == 0) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

        for (Integer i = 2; i < 4; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Other test';
            nonCampaignItem.Non_campaign_title__c = 'Other';
            nonCampaignItem.Activities__c = 'Other';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            if(i == 2){
                nonCampaignItem.Role_Title__c = 'Digital Junior Account Manager';
                nonCampaignItem.Description__c = 'Test description';
            } else {
                nonCampaignItem.Role_Title__c = 'Head of Digital';
                nonCampaignItem.Description__c = '';
            }
            //nonCampaignItem.Role_Title__c = ((i == 2) ? 'Digital Junior Account Manager' : 'Head of Digital');
            //nonCampaignItem.Description__c = ((i == 2) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + nonCampaignItem.Name + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

    }

    public static void setSecondNonCampaignsSet(List<Marketing_Basics__c> nonCampaigns, MDO_Geography__c country){

        for (Integer i = 4; i < 5; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = 'Brand Communication Idea';
            nonCampaignItem.Non_campaign_title__c = 'Brand Communication Idea';
            nonCampaignItem.Activities__c = 'Brand Communication Idea';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Digital Account Management';
            nonCampaignItem.Role_Title__c = 'Head of Digital';
            nonCampaignItem.Description__c = '';

            nonCampaignItem.No_of_Hours_Required__c = 33.5;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 36.5;
            nonCampaignItem.OblixOtherItemFee__c = 1222.75;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Activities__c + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
                                    nonCampaignItem.Role_Title__c;   
        }

        for (Integer i = 5; i < 7; i++) {
            Marketing_Basics__c nonCampaignItem = nonCampaigns[i];
            
            nonCampaignItem.Name = TEST_RESOURCE_NAME;
            nonCampaignItem.Non_campaign_title__c = '';
            nonCampaignItem.Activities__c = '';
            nonCampaignItem.OblixCountry__c = country.Id;
            nonCampaignItem.Agency_Department__c = 'Creative';
            nonCampaignItem.Role_Title__c = ((i == 5) ? 'Creative Director' : 'Associate Creative Director');
            nonCampaignItem.Description__c = ((i == 5) ? 'Test description' : '');

            nonCampaignItem.No_of_Hours_Required__c = 22;
            //nonCampaignItem.Oblix_Hourly_Rate__c = 46;
            nonCampaignItem.OblixOtherItemFee__c = 1001;

            nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;

            nonCampaignItem.Non_Campaign_Key__c = nonCampaignItem.Oblix_SOWMarketing__c + nonCampaignItem.Name + 
                                    country.Name + nonCampaignItem.Agency_Department__c + 
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


>>>>>>> develop
}