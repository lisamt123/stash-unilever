@isTest
private class Oblix_Ctrl06SOWView_CC_Test {
	

	private static final String NULL_MESSAGE = 'Page Reference should be null';
	private static final String NOT_NULL_MESSAGE = 'Page Reference should not be null';


	@isTest static void ViewProjectTest(){
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

			Marketing_Basics__c basics = Oblix_TestUtils.createMarketingBasics(mSow.id);

			ApexPages.currentPage().getParameters().put('sowId', mSow.id);
			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();
		
			controller.selectedProjectId = ''+basics.id;

			Test.stopTest();

			System.assert(controller.ViewProject() == null,NULL_MESSAGE);

		}
	}

	@isTest static void uploadeAttachmentTest(){
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

			ApexPages.currentPage().getParameters().put('sowId', mSow.id);
			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();

			controller.attachment = new Attachment(name = 'Test',body = Blob.valueOf('Test'));

			controller.uploadeAttachment();

			Test.stopTest();

			System.assert(!controller.lstAttachements.isEmpty() ,'Attachment should be uploaded');
		}
	}


	@isTest static void getthousandBlocksTest(){

		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();


			List<Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems> lstCampaignNonCampaign = new List<Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems>();
			for(Integer i = 0 ; i < 2000 ; i ++){
				Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems item = new Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems();
				item.objectDyn = new Marketing_SOW__c();
				item.objName = 'name'+i;
				lstCampaignNonCampaign.add(item);
			}

			Oblix_Ctrl06SOWView_CC.limitWrapper[] wrapperlist = controller.getthousandBlocks(lstCampaignNonCampaign);

			Test.stopTest();

			System.assert(!wrapperlist.isEmpty(),'There should be elements in the list');
		}
	}

	@isTest static void actionsTest() {
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

			ApexPages.currentPage().getParameters().put('sowId', mSow.id);
			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Test.startTest();

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();

			PageReference back = controller.backAction();

			PageReference createProject = controller.CreateProjectAction();

			PageReference saveProject = controller.SaveProjectAction();

			PageReference detail = controller.msDetail();

			PageReference nonCamp = controller.createNonCamp();

			PageReference addProj = controller.AddProject();

			controller.FileCount = '1';
	
			PageReference changeCount = controller.ChangeCount();

			controller.allFileList = new List<Attachment>{new Attachment(name = 'Test',body = Blob.valueOf('Test'))};

			PageReference upploadAtt = controller.uploadAttachment();

			PageReference saveAtt = controller.SaveAttachments();

			controller.EditAction();

			Test.stopTest();

			System.assert(back != null,NOT_NULL_MESSAGE);
			System.assert(createProject != null,NOT_NULL_MESSAGE);
			System.assert(saveProject != null,NOT_NULL_MESSAGE);
			System.assert(detail != null,NOT_NULL_MESSAGE);
			System.assert(nonCamp != null,NOT_NULL_MESSAGE);
			System.assert(addProj != null,NOT_NULL_MESSAGE);
			System.assert(changeCount == null,NULL_MESSAGE);
			System.assert(upploadAtt == null,NULL_MESSAGE);
			System.assert(saveAtt == null,NULL_MESSAGE);
			System.assert(controller.isEdit,'Edit flag should be set');

		}
	}
	
}