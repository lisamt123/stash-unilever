@isTest
private class Oblix_SOWMainDetailController_Test {

	//private static final String TWO_ELEMENTS_MESSSAGE = 'There should be two elements';
    private static final String NOT_NULL_MESSSAGE = 'Page reference should not be null';
    private static final String FINAL_TEST = 'test';
/*
@isTest static void getthousandBlocksTest() {

        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            Oblix_SOWMainDetailController controller = new Oblix_SOWMainDetailController();


            List<Oblix_SOWMainDetailController.CampaignNonCampaignItems> lstSowsMarketingLocal = new List<Oblix_SOWMainDetailController.CampaignNonCampaignItems>();
            for (Integer i = 0 ; i < 2000 ; i ++) {
                Marketing_SOW__c item = new Marketing_SOW__c();
                lstSowsMarketingLocal.add(new Oblix_SOWMainDetailController.CampaignNonCampaignItems('Marketing_SOW__c',item));
            }

            Oblix_SOWMainDetailController.limitWrapper[] wrapperlist = controller.getthousandBlocks(lstSowsMarketingLocal);

            Test.stopTest();

            System.assert(!wrapperlist.isEmpty(), 'There should be elements in the list');
        }
    }

*/
    @isTest static void actionsTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
			Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
			
			Oblix_SOWMainDetailController controllerNoParams = new Oblix_SOWMainDetailController();
			
            ApexPages.currentPage().getParameters().put('projectId',project.Id);
            ApexPages.currentPage().getParameters().put('sowId',mSow.Id);

            Oblix_SOWMainDetailController controller = new Oblix_SOWMainDetailController();
			List<SelectOption> options = controller.getFYSelectOptions();
			System.assert(controller.backAction() != null);
			System.assert(controller.cancelAction() != null);
			System.assert(controller.exitSwop() != null);
			controller.editAction();
			System.assert(controller.editActionPage() != null);
			
			controller.saveSOW();
		    controller.softSaveCampaign();
			System.assert(controller.msDetail() != null);
			System.assert(controller.viewProject() != null);
			System.assert(controller.createNonCamp() != null);
			System.assert(controller.addProject() != null);
			controller.cloneAction(); 
			
            Test.stopTest();

            controller.sow_id = mSow.id;
//            controller.RerenderSelectedSow();

            Attachment att = new Attachment(parentId = mSow.id, name = 'attachmentUnitTest', body = Blob.valueOf(FINAL_TEST));
            insert att;

            controller.refreshAttachments();
            controller.uploadeAttachment();
            controller.SaveAttachments();
   //         controller.applyFilters();
            controller.Cancel();
			System.assert(controller.deleteAction() != null);
        //    System.assert(controller.CreateSOWAction() != null, NOT_NULL_MESSSAGE);
            System.assert(controller.viewNonCampaign() != null, NOT_NULL_MESSSAGE);
            System.assert(controller.addNonCampaignProject() != null, NOT_NULL_MESSSAGE);
            System.assert(Oblix_SOWMainDetailController.reportFolderURL != null, NOT_NULL_MESSSAGE);
            controller.FileCount = '5';
            System.assertEquals(null, controller.changeCount());
            controller.getCategoryBrand();

        }
    }
    @isTest static void removeAttachments_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Attachment attach = Oblix_TestUtils.createAttachment(FINAL_TEST, FINAL_TEST,
                                Oblix_TestUtils.createTestMarketingSow(FINAL_TEST, null,
                                        Oblix_TestUtils.createBrand(FINAL_TEST, FINAL_TEST).Id).Id);
            System.assertEquals(1, [SELECT Id FROM Attachment Limit 100].size());
            Test.startTest();
            Oblix_SOWMainDetailController.removeAttachments(new List<String> {attach.Id});
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

            Oblix_SOWMainDetailController controller = new Oblix_SOWMainDetailController();

            controller.attachment = new Attachment(name = FINAL_TEST, body = Blob.valueOf(FINAL_TEST));

            controller.sow_Id = mSow.id;

            controller.uploadeAttachment();

            Test.stopTest();
            
            System.assert(controller != null);
            System.assert(controller.liso_attachments != null);

     //       System.assert(!controller.liso_attachments.isEmpty() , 'Attachment should be uploaded');
        }
    }


}