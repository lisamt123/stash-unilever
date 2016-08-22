@isTest
private class Oblix_SOWCreateController_Test {

    private static User ul1;
    //private static User ul2;
    //private static User ul3;
    //private static User superuser;

    //private static Marketing_SOW__c sowDove;
    //private static Marketing_SOW__c sowKnorr;
    //private static Marketing_SOW__c sowAmbrosia;
    //private static Marketing_SOW__c sowCiff;
    //private static Marketing_SOW__c sowInvalidBrandCatComb;

    private static MDO_CategoryBrands__c cbDovePC;
    private static MDO_CategoryBrands__c cbKnorrOF;
    private static MDO_CategoryBrands__c cbAmbrosiaOF;
    private static MDO_CategoryBrands__c cbCiffPC;

    private static final String BRAND_DOVE = 'Dove';
    private static final String BRAND_KNORR = 'Knorr';
    private static final String BRAND_AMBROSIA = 'Ambrosia';
    private static final String BRAND_CIFF = 'Ciff';
    private static final String SMALL_CAT_PC = 'Personal Care';
    private static final String SMALL_CAT_OF = 'Other Food';
    private static Pagereference permission_denied_page;


    @testSetup static void initCommonData() {

        User currentUser = new User(Id = UserInfo.getUserId());
        System.runAs(currentUser) {
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();
        }
    }

    private static void initTestUsers(){

        Map<String, User> testUsers = Oblix_TestUtils.createTestUsers();
        ul1 = testUsers.get('UL1');
        //ul2 = testUsers.get('UL2');
        //ul3 = testUsers.get('UL3');
        //superuser = testUsers.get('superuser');
    }
    
    @isTest static void testCheckUserHasPermissionToSOW() {
        initTestUsers();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


        PageReference pageRef = Page.Oblix_SOWCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('sowId', mSow.Id);
        Oblix_SOWCreateController controller = new Oblix_SOWCreateController();

        Test.startTest();

        PageReference checkUserHasPermissionToSOW = controller.checkUserHasPermissionToSOW();
        System.assertEquals(null, checkUserHasPermissionToSOW);

        System.runAs(ul1) {
            checkUserHasPermissionToSOW = controller.checkUserHasPermissionToSOW();

            permission_denied_page = Page.Oblix_PermissionDenied;
            System.assertEquals(null, checkUserHasPermissionToSOW);
        }

        PageReference checkUserHasPermissionToProject = controller.checkUserHasPermissionToProject();
        System.assertNotEquals(null, checkUserHasPermissionToProject);


        Test.stopTest();
          
    }


    @isTest static void testEditSOW() {
        initTestUsers();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

        PageReference pageRef = Page.Oblix_SOWCreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('sowId', mSow.Id);
        Oblix_SOWCreateController controller = new Oblix_SOWCreateController();

        Test.startTest();

        // S.S. 2016-06-06 ATTACHMENT UPLOAD IS NO LONGER USED IN THIS PAGE - MOVED TO SOW MAIN DETAIL PAGE
        //controller.pageAttachment.Name='Unit Test Attachment';
        //controller.pageAttachment.Body=Blob.valueOf('Unit Test Attachment Body');
        //controller.uploadAttachment();

        //List<Attachment> attachments = [SELECT Id FROM Attachment WHERE Parent.Id =: mSow.Id];
        //System.assertEquals(1, attachments.size());


        //controller.deleteAttachmentId = attachments[0].Id;
        //controller.deleteAttachment();

        //attachments = [SELECT Id FROM Attachment WHERE Parent.Id =: mSow.Id];
        //System.assertEquals(0, attachments.size());


        PageReference saveAndClose = controller.saveAndClose();
        PageReference sowDetailPage = new PageReference('/apex/Oblix_SOWMainDetail?sowId='+ mSow.Id);
        System.assertNotEquals(null, saveAndClose);
        System.assertEquals(sowDetailPage.getUrl(), saveAndClose.getUrl());

        controller.cancelAction();
        controller.getCategoryBrand();
        controller.getFYSelectOptions();

        System.assertNotEquals(null, controller.exitSwop());
        System.assertNotEquals(null, controller.goToReportsHome());

        Oblix_SOW_Projects__c campaign = controller.getCampaign('test', new List<String>{'Id'}, '');
        System.assertEquals(null, campaign);

        Test.stopTest();
          
    }


    @isTest static void testCreateNewSOW() {

        // insert brands MDO data
        MDO_Brand__c bDove = Oblix_TestUtils.createBrand(BRAND_DOVE);
        MDO_Brand__c bKnorr = Oblix_TestUtils.createBrand(BRAND_KNORR);
        MDO_Brand__c bAmbrosia = Oblix_TestUtils.createBrand(BRAND_AMBROSIA);
        MDO_Brand__c bCiff = Oblix_TestUtils.createBrand(BRAND_CIFF);
        insert new List<MDO_Brand__c>{bDove, bKnorr, bAmbrosia, bCiff};

        // insert categories MDO data
        MDO_Category__c scPC = Oblix_TestUtils.createProductCategory(SMALL_CAT_PC);
        MDO_Category__c scOF = Oblix_TestUtils.createProductCategory(SMALL_CAT_OF);
        MDO_Category__c bc = Oblix_TestUtils.createProductCategory('Big category');
        insert new List<MDO_Category__c>{scPC, scOF, bc};

        // insert category brand MDO data
        cbDovePC = Oblix_TestUtils.createCategoryBrand(scPC.Id, bDove.Id);
        cbKnorrOF = Oblix_TestUtils.createCategoryBrand(scOF.Id, bKnorr.Id);
        cbAmbrosiaOF = Oblix_TestUtils.createCategoryBrand(scOF.Id, bAmbrosia.Id);
        cbCiffPC = Oblix_TestUtils.createCategoryBrand(scPC.Id, bCiff.Id);
        insert new List<MDO_CategoryBrands__c>{cbDovePC, cbKnorrOF, cbAmbrosiaOF, cbCiffPC};

        PageReference pageRef = Page.Oblix_SOWCreate;
        Test.setCurrentPage(pageRef);
        Oblix_SOWCreateController controller = new Oblix_SOWCreateController();

        Test.startTest();

        System.assertEquals(true, controller.can_add_attachment);
        System.assertEquals(true, controller.can_delete_attachment);
        System.assertEquals(true, controller.can_see_financial_fields);
        

        controller.selected_sow.OblixBrand__c = bDove.Id;
        controller.getCategoryBrand();

        controller.selected_sow = null;
        PageReference checkUserHasPermissionToSOW = controller.checkUserHasPermissionToSOW();
        System.assertEquals(null, checkUserHasPermissionToSOW);
        System.assertEquals(true, controller.can_edit);
        System.assertEquals(false, controller.can_add_attachment);
        System.assertEquals(false, controller.can_delete_attachment);


        Test.stopTest();
          
    }
    
    
}