@isTest
private class Oblix_CampaignRedirectController_Test {

    //private static User ul1;
    //private static User ul2;
    private static User ul3;
    private static User superuser;

    private static Marketing_SOW__c mSow;
    private static Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test;
    private static Oblix_SOW_Projects__c campaigns_to_test;
    private static Oblix_Project_Assets__c asset_to_test;
    private static List<Oblix_Project_Assets__c> list_assets_in_basket;

    private static void initTestUsersAndSOW(){

		List<Asset_Scoring__c> list_of_asset_scoring;
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	list_of_asset_scoring = Oblix_TestUtils.createAssetScoringRecords(10);	
        	insert list_of_asset_scoring;

        	insert Oblix_TestUtils.createOblixCustomSettings();
        	insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
        	insert Oblix_TestUtils.createCountryCalculatorRecords();


        }

        Map<String, User> testUsers = Oblix_TestUtils.createTestUsers();
        //ul1 = testUsers.get('UL1');
        //ul2 = testUsers.get('UL2');
        ul3 = testUsers.get('UL3');
        superuser = testUsers.get('superuser');

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


		map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(1,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

		campaigns_to_test = map_campaigns_to_test.values()[0];


		list_assets_in_basket = new List<Oblix_Project_Assets__c>();
		list_assets_in_basket.addAll(campaigns_to_test.Agency_Project_Assets__r);

		asset_to_test = list_assets_in_basket[0];


	}
	
	@isTest static void testRedirectSuperuser() {

        initTestUsersAndSOW();

        System.runAs(superuser) {

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_CampaignRedirect;
            Test.setCurrentPage(pageRef);

          
            ApexPages.currentPage().getParameters().put('projectId', campaigns_to_test.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(asset_to_test);
            Oblix_CampaignRedirectController controller = new Oblix_CampaignRedirectController(sc);

            PageReference redirectToSwop = controller.redirectToCampaign();
            System.assertEquals(null, redirectToSwop);
        }
	}


    @isTest static void testRedirect() {
        initTestUsersAndSOW();


        System.runAs(ul3) {
            //MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_CampaignRedirect;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('projectId', campaigns_to_test.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(asset_to_test);
            Oblix_CampaignRedirectController controller = new Oblix_CampaignRedirectController(sc);

            PageReference redirectToSwop = controller.redirectToCampaign();
            pageRef = Page.Oblix_SOWMainDetail; 
            pageRef.getParameters().put('projectId', sc.getId());
            System.assertNotEquals(NULL, redirectToSwop.getUrl());
        }
    }

    @isTest static void testRedirectMain() {
        initTestUsersAndSOW();

        System.runAs(ul3) {
            //MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_CampaignRedirect;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('projectId', campaigns_to_test.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(asset_to_test);
            Oblix_CampaignRedirectController controller = new Oblix_CampaignRedirectController(sc);

            PageReference redirectToSwop = controller.redirectToCampaignMain();
            pageRef = Page.Oblix_CampaignSummary; 
            //pageRef.getParameters().put('sowId', sc.getId());
            System.assertEquals(pageRef.getUrl(), redirectToSwop.getUrl());
		}
    }
}
