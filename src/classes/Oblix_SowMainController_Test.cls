@isTest
private class Oblix_SowMainController_Test {

<<<<<<< HEAD
private static final String TWO_ELEMENTS_MESSSAGE = 'There should be two elements';
    private static final String NOT_NULL_MESSSAGE = 'Page reference should not be null';
    private static final String FINAL_TEST = 'test';
    @isTest static void selectOptionsTest() {
        User u = Oblix_TestUtils.createTestUser();
=======
    private static Marketing_SOW__c sowDove;
    private static Marketing_SOW__c sowKnorr;
    //private static Marketing_SOW__c sowAmbrosia;
    //private static Marketing_SOW__c sowCiff;
    //private static Marketing_SOW__c sowInvalidBrandCatComb;
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            mSow.RecordTypeId = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing');
            update mSow;

<<<<<<< HEAD
            Oblix_SowMainController controller = new Oblix_SowMainController();
=======
    private static User ul1;
    private static User ul2;
    private static User ul3;
    private static User superuser;
    private static User ul1_2;

    private static Oblix_User_Permission__c up1Dove;
    private static Oblix_User_Permission__c up1_2Knorr;
    
    
    @isTest static void testGetAllSOWRecords() {
        
        initTestData();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

            Test.stopTest();

            System.assertEquals(controller.getSmallCategory().size(), 2, TWO_ELEMENTS_MESSSAGE);
            System.assertEquals(controller.getBigCategory().size(), 2, TWO_ELEMENTS_MESSSAGE);
            System.assertEquals(controller.getBrandItems().size(), 2, TWO_ELEMENTS_MESSSAGE);
            System.assert(!controller.getFinancialYear().isEmpty(), 'There should be financial year options');

        }
    }

    @isTest static void getthousandBlocksTest() {

        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            Oblix_SowMainController controller = new Oblix_SowMainController();


            List<Marketing_SOW__c> lstSowsMarketingLocal = new List<Marketing_SOW__c>();
            for (Integer i = 0 ; i < 2000 ; i ++) {
                Marketing_SOW__c item = new Marketing_SOW__c();
                lstSowsMarketingLocal.add(item);
            }

            Oblix_SowMainController.limitWrapper[] wrapperlist = controller.getthousandBlocks(lstSowsMarketingLocal);

            Test.stopTest();

            System.assert(!wrapperlist.isEmpty(), 'There should be elements in the list');
        }
    }

    @isTest static void actionsTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SowMainController controller = new Oblix_SowMainController();

            Test.stopTest();

            controller.selectedSewId = mSow.id;
            controller.clearFilters();

            Attachment att = new Attachment(parentId = mSow.id, name = 'attachmentUnitTest', body = Blob.valueOf(FINAL_TEST));
            insert att;

            controller.ViewAttachements();
            controller.applyFilters();
            controller.Cancel();

            System.assert(controller.CreateSOWAction() != null, NOT_NULL_MESSSAGE);
            System.assert(controller.ViewAction() != null, NOT_NULL_MESSSAGE);
            System.assert(controller.ViewSow() != null, NOT_NULL_MESSSAGE);
    //        System.assert(controller.selSow.id != null, 'Record should be selected');
   //         System.assert(!controller.lstAttachements.isEmpty(), 'List should not be empty');

        }
    }
<<<<<<< HEAD
    @isTest static void removeAttachments_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Attachment attach = Oblix_TestUtils.createAttachment(FINAL_TEST, FINAL_TEST,
                                Oblix_TestUtils.createTestMarketingSow(FINAL_TEST, null,
                                        Oblix_TestUtils.createBrand(FINAL_TEST, FINAL_TEST).Id).Id);
            System.assertEquals(1, [SELECT Id FROM Attachment Limit 100].size());
            Test.startTest();
            Oblix_SowMainController.removeAttachments(new List<String> {attach.Id});
            Test.stopTest();
            System.assertEquals(0, [SELECT Id FROM Attachment Limit 100].size());
=======

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  test approval reassignment
    ********************************************************************************/
    @isTest static void testApprovalReassignment(){

        initTestData();

        Test.setCurrentPageReference(new PageReference('Page.Oblix_SOWMainDetail'));
        System.currentPageReference().getParameters().put('sowId', sowKnorr.Id);
        Oblix_SowMainDetailController controller = new Oblix_SowMainDetailController();

        controller.submitForApproval();

        Test.startTest();

        up1_2Knorr.CategoryBrand_id__c = cbDovePC.Id;
        update up1_2Knorr;

        up1Dove.CategoryBrand_id__c = cbKnorrOF.Id;
        update up1Dove;

        Test.stopTest();

        List<ProcessInstanceWorkItem> pendingApprovals = [Select Id, ActorId, ProcessInstance.TargetObjectId From ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :sowKnorr.Id];

        System.assertEquals(1, pendingApprovals.size());
        System.assertEquals(ul1.Id, pendingApprovals[0].ActorId);

    }


    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  initialize test data
    ********************************************************************************/
    private static void initTestData(){

        // insert brands MDO data
        MDO_Brand__c bDove = Oblix_TestUtils.createBrand(BRAND_DOVE);
        MDO_Brand__c bKnorr = Oblix_TestUtils.createBrand(BRAND_KNORR);
        MDO_Brand__c bAmbrosia = Oblix_TestUtils.createBrand(BRAND_AMBROSIA);
        MDO_Brand__c bCiff = Oblix_TestUtils.createBrand(BRAND_CIFF);
        insert new List<MDO_Brand__c>{bDove, bKnorr, bAmbrosia, bCiff};

        insert Oblix_TestUtils.createOblixCustomSettings();

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

        // insert users
        User thisUser = new User(Id = UserInfo.getUserId());
        System.runAs(thisUser){
            ul1 = Oblix_TestUtils.createMarketingUser('UL1');
            ul2 = Oblix_TestUtils.createMarketingUser('UL2');
            ul3 = Oblix_TestUtils.createMarketingUser('UL3');
            superuser = Oblix_TestUtils.createMarketingUser('superu');
            ul1_2 = Oblix_TestUtils.createMarketingUser('UL1_1');
            insert new List<User>{ul1, ul2, ul3, superuser, ul1_2};

            // assign permission sets (step 1. get permission set ids, verify they exist)
            Map<String, Id> oblixPermissionSets = Oblix_TestUtils.getOblixPermissionSets();

            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL2));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL3));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_SUPERUSER));

            PermissionSetAssignment ul1PSA = Oblix_TestUtils.createPermissionSetAssignment(ul1.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            PermissionSetAssignment ul2PSA = Oblix_TestUtils.createPermissionSetAssignment(ul2.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL2));
            PermissionSetAssignment ul3PSA = Oblix_TestUtils.createPermissionSetAssignment(ul3.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL3));
            PermissionSetAssignment superuserPSA = Oblix_TestUtils.createPermissionSetAssignment(superuser.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_SUPERUSER));
            PermissionSetAssignment ul1_2PSA = Oblix_TestUtils.createPermissionSetAssignment(ul1_2.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            insert new List<PermissionSetAssignment>{ul1PSA, ul2PSA, ul3PSA, superuserPSA, ul1_2PSA};
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        }
    }
    @isTest static void uploadeAttachmentTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

<<<<<<< HEAD
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
=======
        // insert oblix user permission (user permissions to brand-category)
        // UL1 Dove approver, Knorr edit, Ambrosia read only, Ciff no access
        // UL2 Dove Edit, Knorr read only, Ambrosia no access, Ciff no access
        // UL3 Dove Read only, Knorr no access, Ambrosia no access, Ciff edit (should have read regardless)
        // superuser Dove approver, Knorr edit, Ambrosia read only, Diff no access
        // UL1_2 Knorr approver
        up1Dove = Oblix_TestUtils.createUserPermission(ul1.Id, cbDovePC.Id, Oblix_Utils.USER_PERMISSION_APPROVER, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c up1Knorr = Oblix_TestUtils.createUserPermission(ul1.Id, cbKnorrOF.Id, Oblix_Utils.USER_PERMISSION_ACCESS_EDIT, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c up1Ambrosia = Oblix_TestUtils.createUserPermission(ul1.Id, cbAmbrosiaOF.Id, Oblix_Utils.USER_PERMISSION_READ_ONLY, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SowMainController controller = new Oblix_SowMainController();

<<<<<<< HEAD
            controller.attachment = new Attachment(name = FINAL_TEST, body = Blob.valueOf(FINAL_TEST));

            controller.selectedSewId = mSow.id;

            controller.uploadeAttachment();
=======
        Oblix_User_Permission__c superuserDove = Oblix_TestUtils.createUserPermission(superuser.Id, cbDovePC.Id, Oblix_Utils.USER_PERMISSION_APPROVER, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c superuserKnorr = Oblix_TestUtils.createUserPermission(superuser.Id, cbKnorrOF.Id, Oblix_Utils.USER_PERMISSION_ACCESS_EDIT, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c superuserAmbrosia = Oblix_TestUtils.createUserPermission(superuser.Id, cbAmbrosiaOF.Id, Oblix_Utils.USER_PERMISSION_READ_ONLY, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);

        up1_2Knorr = Oblix_TestUtils.createUserPermission(ul1_2.Id, cbKnorrOF.Id, Oblix_Utils.USER_PERMISSION_APPROVER, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);

        insert new List<Oblix_User_Permission__c>{up1Dove, up1Knorr, up1Ambrosia, up2Dove, up2Knorr, up3Dove, up3Ciff, superuserDove, superuserKnorr, superuserAmbrosia, up1_2Knorr};

        Account agency = Oblix_TestUtils.createAccount();
        sowDove = Oblix_TestUtils.createTestMarketingSow('Dove SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbDovePC.brand_id__c, cbDovePC.product_Category_Id__c, bc.Id, agency.Id);
        sowKnorr = Oblix_TestUtils.createTestMarketingSow('Knorr SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbKnorrOF.brand_id__c, cbKnorrOF.product_Category_Id__c, bc.Id, agency.Id);
        Marketing_SOW__c sowAmbrosia = Oblix_TestUtils.createTestMarketingSow('Ambrosia SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbAmbrosiaOF.brand_id__c, cbAmbrosiaOF.product_Category_Id__c, bc.Id, agency.Id);
        Marketing_SOW__c sowCiff = Oblix_TestUtils.createTestMarketingSow('Ciff SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbCiffPC.brand_id__c, cbCiffPC.product_Category_Id__c, bc.Id, agency.Id);
        Marketing_SOW__c sowInvalidBrandCatComb = Oblix_TestUtils.createTestMarketingSow('SOW invalid', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, bCiff.Id, scOF.Id, bc.Id, agency.Id);
        insert new List<Marketing_SOW__c>{sowDove, sowKnorr, sowAmbrosia, sowCiff};
        update new List<Marketing_SOW__c>{sowDove, sowKnorr, sowAmbrosia, sowCiff};
        system.assertNotEquals(NULL, sowInvalidBrandCatComb, 'Expecting sowInvalidBrandCatComb to be populated');
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

            Test.stopTest();

            System.assert(!controller.lstAttachements.isEmpty() , 'Attachment should be uploaded');
        }
    }

    @isTest static void applyFilters_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand('Test', 'test');
            Marketing_SOW__c marketingSow1 = Oblix_TestUtils.createTestMarketingSow('test1', null, brand.Id);
            Marketing_SOW__c marketingSow2 = Oblix_TestUtils.createTestMarketingSow('test2', null, brand.Id);
            Set<String> categoryNames = new Set<String> {
                Oblix_TestUtils.DEFAULT_BIG_PROD_CAT_NAME,
                Oblix_TestUtils.DEFAULT_SMALL_PROD_CAT_NAME
            };
            MDO_Category__c smallCategory = null;
            MDO_Category__c bigCategory = null;
            for (MDO_Category__c productCategory : [SELECT Id, Name FROM MDO_Category__c WHERE Name IN :categoryNames]) {
                if (productCategory.Name.equalsIgnoreCase(Oblix_TestUtils.DEFAULT_BIG_PROD_CAT_NAME)) {
                    bigCategory = productCategory;
                }
                if (productCategory.Name.equalsIgnoreCase(Oblix_TestUtils.DEFAULT_BIG_PROD_CAT_NAME)) {
                    smallCategory = productCategory;
                }
            }
            String selectedYear = 'test';
            marketingSow1.Financial_Year__c = selectedYear;
            update marketingSow1;


            Oblix_SowMainController sowDetails = new Oblix_SowMainController();
            sowDetails.selectedBrand = brand.Id;
            sowDetails.selectedFYear = selectedYear;
            sowDetails.selectedSmallCat = smallCategory.Id;
            sowDetails.selectedBigCat = bigCategory.Id;
            Test.startTest();
            sowDetails.applyFilters();
            System.assertEquals(1, sowDetails.thousandBlocks.size());
            sowDetails.clearFilters();
            System.assertNotEquals(0, sowDetails.thousandBlocks.size());
            Test.stopTest();
        }
    }
}