@isTest
private class Oblix_SWOPredirectController_Test {

    //private static User ul1;
    //private static User ul2;
    private static User ul3;
    private static User superuser;

    private static Marketing_SOW__c mSow;


    private static void initTestUsersAndSOW(){

        Map<String, User> testUsers = Oblix_TestUtils.createTestUsers();
        //ul1 = testUsers.get('UL1');
        //ul2 = testUsers.get('UL2');
        ul3 = testUsers.get('UL3');
        superuser = testUsers.get('superuser');

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

    }
	
	@isTest static void testRedirectSuperuser() {

        initTestUsersAndSOW();

        System.runAs(superuser) {

            //MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_SWOPRedirect;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', mSow.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(mSow);
            Oblix_SWOPredirectController controller = new Oblix_SWOPredirectController(sc);

            PageReference redirectToSwop = controller.redirectToSwop();
            System.assertEquals(null, redirectToSwop);
        }
	}


    @isTest static void testRedirect() {
        initTestUsersAndSOW();


        System.runAs(ul3) {
            //MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_SWOPRedirect;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', mSow.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(mSow);
            Oblix_SWOPredirectController controller = new Oblix_SWOPredirectController(sc);

            PageReference redirectToSwop = controller.redirectToSwop();
            pageRef = Page.Oblix_SOWMainDetail; 
            pageRef.getParameters().put('sowId', sc.getId());
            System.assertEquals(pageRef.getUrl(), redirectToSwop.getUrl());
        }
    }

    @isTest static void testRedirectMain() {
        initTestUsersAndSOW();

        System.runAs(ul3) {
            //MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_SWOPRedirect;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', mSow.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(mSow);
            Oblix_SWOPredirectController controller = new Oblix_SWOPredirectController(sc);

            PageReference redirectToSwop = controller.redirectToSwopMain();
            pageRef = Page.Oblix_SOWMain; 
            //pageRef.getParameters().put('sowId', sc.getId());
            System.assertEquals(pageRef.getUrl(), redirectToSwop.getUrl());
		}
    }
}