@isTest
public with sharing class Oblix_NonCampaignRedirectController_Test {

    //private static User ul1;
    //private static User ul2;
    private static User ul3;
    private static User superuser;

    private static Marketing_SOW__c mSow;
    private static Marketing_Basics__c non_campaigns_to_test;
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
		non_campaigns_to_test = Oblix_TestUtils.createMarketingBasics(mSow.Id);
	}
	
	@isTest static void testRedirectSuperuser() {

        initTestUsersAndSOW();

        System.runAs(superuser) {

            //Init controller with existing non campaigns
            PageReference pageRef = Page.Oblix_NonCampaignRedirect;
            Test.setCurrentPage(pageRef);

          
            ApexPages.currentPage().getParameters().put('sowId', mSow.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(mSow);
            Oblix_NonCampaignRedirectController controller = new Oblix_NonCampaignRedirectController(sc);

            PageReference redirectToSwop = controller.redirectToNonCampaign();
            System.assertEquals(null, redirectToSwop);
        }
	}


    @isTest static void testRedirect() {
        initTestUsersAndSOW();


        System.runAs(ul3) {
            //MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            //Init controller with existing non campaigns
            PageReference pageRef = Page.Oblix_NonCampaignRedirect;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('sowId', mSow.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(non_campaigns_to_test);
            Oblix_NonCampaignRedirectController controller = new Oblix_NonCampaignRedirectController(sc);

            PageReference redirectToSwop = controller.redirectToNonCampaign();
            pageRef = Page.Oblix_SOWNonCampaignCreate; 
            pageRef.getParameters().put('sowId', sc.getId());
            System.assertNotEquals(NULL, redirectToSwop.getUrl());
        }
    }

    @isTest static void testRedirectMain() {
        initTestUsersAndSOW();

        System.runAs(ul3) {
            //MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_AssetRedirect;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('sowId', mSow.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(non_campaigns_to_test);
            Oblix_NonCampaignRedirectController controller = new Oblix_NonCampaignRedirectController(sc);

            PageReference redirectToSwop = controller.redirectToSwopMain();
            pageRef = Page.Oblix_SOWMain; 
            //pageRef.getParameters().put('sowId', sc.getId());
            System.assertEquals(pageRef.getUrl(), redirectToSwop.getUrl());
		}
    }
}