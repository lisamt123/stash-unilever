@isTest
private class Oblix_SowMainController_Test {

private static final String TWO_ELEMENTS_MESSSAGE = 'There should be two elements';
    private static final String NOT_NULL_MESSSAGE = 'Page reference should not be null';
    private static final String FINAL_TEST = 'test';
    @isTest static void selectOptionsTest() {
        User u = Oblix_TestUtils.createTestUser();

        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            mSow.RecordTypeId = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing');
            update mSow;

            Oblix_SowMainController controller = new Oblix_SowMainController();

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
        }
    }
    @isTest static void uploadeAttachmentTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SowMainController controller = new Oblix_SowMainController();

            controller.attachment = new Attachment(name = FINAL_TEST, body = Blob.valueOf(FINAL_TEST));

            controller.selectedSewId = mSow.id;

            controller.uploadeAttachment();

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