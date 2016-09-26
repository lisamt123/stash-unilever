@isTest
public with sharing class Oblix_SOWNonCampaignCreateCtrl_Test2 {

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
            Oblix_SOWNonCampaignCreateCtrl_Test.setFirstNonCampaignsSet(nonCampaigns, country);

            //[4] - Activity / Brandbook
            //[5,6] - Activity / Brandbook
            Oblix_SOWNonCampaignCreateCtrl_Test.setSecondNonCampaignsSet(nonCampaigns, country);

            insert nonCampaigns;
        }



    }

    @isTest private static void testBasketInit() {
        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.PRESELECTED_ITEM_PAGE_PARAMETER, Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK);

        Test.startTest();

            Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        Test.stopTest();

        //Check whether controller was initiated with 3 item groupings
        System.assertEquals(4 ,controller.helper.basket.keySet().size());

    }



    @isTest private static void testAddToWorklist() {
        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.PRESELECTED_ITEM_PAGE_PARAMETER, Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        //Check whether controller was initiated wihtout any grouping
        System.assertEquals(0 ,controller.helper.basket.keySet().size());
        //Check that ACtivity Tab worklist doesn't contain any items
        System.assertEquals(0,controller.helper.worklist.get(controller.helper.currentTab).items.size());

        Test.startTest();

            controller.nonCampaignItemToAddJSON = Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
            controller.addToWorkList();

            controller.nonCampaignItemToAddJSON = Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
            controller.addToWorkList();

        Test.stopTest();

        //Check that ACtivity Tab worklist contain 1 item        
        System.assertEquals(1,controller.helper.worklist.get(controller.helper.currentTab).items.size());


    }

    @isTest private static void testRemoveItem() {
        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.PRESELECTED_ITEM_PAGE_PARAMETER, Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        controller.nonCampaignItemToAddJSON = Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;
        controller.addToWorkList();

        System.assertEquals(1,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).itemCount);
        System.assertEquals(1,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).items.size());
        System.assertNotEquals(0,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).totalValue);

        Test.startTest();

            controller.helper.itemToRemove = sow.Id + 'Brand Communication IdeaArgentinaCreativeCopywriter';
            controller.removeItem();

        Test.stopTest();

        //System.DEBUG('Worklist After Remove :' + controller.helper.worklist);
        System.assertEquals(0,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).itemCount);
        System.assertEquals(0,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).items.size());
        System.assertEquals(0,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).totalValue);

        
    }


    @isTest private static void testRemoveSection() {
        initCommonData(true);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.PRESELECTED_ITEM_PAGE_PARAMETER, Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();

        controller.helper.currentSection = Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK;
        controller.helper.openBasketSection();

        System.assertEquals(2,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).itemCount);
        System.assertEquals(2,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).items.size());
        System.assertNotEquals(0,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).totalValue);

        Test.startTest();

            controller.helper.sectionToRemove = Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK;
            controller.removeSection();

        Test.stopTest();

        //System.DEBUG('Worklist After Remove :' + controller.helper.worklist);
        System.assertEquals(0, controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).itemCount);
        System.assertEquals(0, controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).items.size());
        System.assertEquals(0, controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).totalValue);

        System.assertEquals(null, controller.helper.basket.get(Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK));

        
    }
    

    @isTest private static void testSaveWorkList() {
        initCommonData(false);

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_SOWNonCampaignCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.SOW_ID_PAGE_PARAMETER, sow.Id);
        ApexPages.currentPage().getParameters().put(Oblix_SOWNonCampaignCreateCtrl_Test.PRESELECTED_ITEM_PAGE_PARAMETER, Oblix_SOWNonCampaignCreateCtrl_Test.BRAND_BOOK);
        Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();


        controller.nonCampaignItemToAddJSON = Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_FIRST_PART + sow.Id + Oblix_SOWNonCampaignCreateCtrl_Test.NON_CAMPAIGN_ITEM_WORKLIST_JSON_SECOND_PART;

        controller.addToWorkList();
        System.assertEquals(1,controller.helper.worklist.get(Oblix_SOWNonCampaignCreateCtrl_Test.ACTIVITY).itemCount);

        Test.startTest();
            
            controller.saveWorkList();

        Test.stopTest();

        System.debug('### basket keyset: ' + controller.helper.basket.keySet());
        System.assertEquals(1,controller.helper.basket.get('BRAND COMMUNICATION IDEA').itemCount);
    }

}