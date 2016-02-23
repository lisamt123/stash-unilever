@isTest
private class Oblix_Ctrl06SOWView_CC_Test {


	private static final String NULL_MESSAGE = 'Page Reference should be null';
	private static final String NOT_NULL_MESSAGE = 'Page Reference should not be null';
	private static final String PROJECT_TXT = 'Project';
	private static final String PROJECTID_TXT = 'projectId';
	private static final String SOWID_TXT = 'sowId';
	private static final String TEST_NAME = 'test';

	@isTest static void saveSOWTest() {
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
 
			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

			ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
			ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();

			mSow.Financial_Year__c = '2015';
			mSow.BB_or_BD__c = TEST_NAME;


			controller.noteAsset = new Note(body = TEST_NAME);

			controller.selSow = new Marketing_SOW__c();

			controller.saveSOW();

			controller.selSow = mSow;

			controller.saveSOW();

			Test.stopTest();

			System.assert(!controller.isEdit, 'Edit flag should not be set');
		}
	}


	@isTest static void ViewProjectTest() {
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

			Marketing_Basics__c basics = Oblix_TestUtils.createMarketingBasics(mSow.id);

			ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
			ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();

			controller.selectedProjectId = '' + basics.id;

			Test.stopTest();

			System.assert(controller.ViewProject() == null, NULL_MESSAGE);

		}
	}

	@isTest static void uploadeAttachmentTest() {
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

			ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
			ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();

			controller.attachment = new Attachment(name = TEST_NAME, body = Blob.valueOf(TEST_NAME));

			controller.uploadeAttachment();

			Test.stopTest();

			System.assert(!controller.lstAttachements.isEmpty() , 'Attachment should be uploaded');
		}
	}


	@isTest static void getthousandBlocksTest() {

		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();


			List<Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems> lstCampaignNonCampaign = new List<Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems>();
			for (Integer i = 0 ; i < 2000 ; i ++) {
				Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems item = new Oblix_Ctrl06SOWView_CC.CampaignNonCampaignItems();
				item.objectDyn = new Marketing_SOW__c();
				item.objName = 'name' + i;
				lstCampaignNonCampaign.add(item);
			}

			Oblix_Ctrl06SOWView_CC.limitWrapper[] wrapperlist = controller.getthousandBlocks(lstCampaignNonCampaign);

			Test.stopTest();

			System.assert(!wrapperlist.isEmpty(), 'There should be elements in the list');
		}
	}

	@isTest static void removeAttachments_Test() {
		System.runAs(Oblix_TestUtils.createTestUser()) {
			Attachment attach = Oblix_TestUtils.createAttachment(TEST_NAME, TEST_NAME,
			                    Oblix_TestUtils.createTestMarketingSow(TEST_NAME, null,
			                            Oblix_TestUtils.createBrand(TEST_NAME, TEST_NAME).Id).Id);
			System.assertEquals(1, [SELECT Id FROM Attachment Limit 100].size());
			Test.startTest();
			Oblix_Ctrl06SOWView_CC.removeAttachments(new List<String> {attach.Id});
			Test.stopTest();
			System.assertEquals(0, [SELECT Id FROM Attachment Limit 100].size());
		}
	}

	@isTest static void CloneAction_Test() {
		User currentUser = Oblix_TestUtils.createTestUser();
		System.runAs(currentUser) {
			Marketing_SOW__c marketingSow = Oblix_TestUtils.createTestMarketingSow(TEST_NAME, null,
			                                Oblix_TestUtils.createBrand(TEST_NAME, TEST_NAME).Id);
			marketingSow.BB_or_BD__c = 'BD';
			MDO_Category__c smallCategory = null;
			MDO_Category__c bigCategory = null;
			Set<String> categoryNames = new Set<String> {
				Oblix_TestUtils.DEFAULT_BIG_PROD_CAT_NAME,
				Oblix_TestUtils.DEFAULT_SMALL_PROD_CAT_NAME
			};
			for (MDO_Category__c productCategory : [SELECT Id, Name FROM MDO_Category__c WHERE Name IN :categoryNames]) {
				if (productCategory.Name.equalsIgnoreCase(Oblix_TestUtils.DEFAULT_BIG_PROD_CAT_NAME)) {
					bigCategory = productCategory;
				}
				if (productCategory.Name.equalsIgnoreCase(Oblix_TestUtils.DEFAULT_BIG_PROD_CAT_NAME)) {
					smallCategory = productCategory;
				}
			}
			String selectedYear = 'test';
			marketingSow.BigOblixProductCategory__c = bigCategory.Id;
			marketingSow.SmallProductCategory__c = smallCategory.Id;
			marketingSow.Financial_Year__c = selectedYear;
			marketingSow.Unilever_Lead__c = currentUser.Id;
			marketingSow.Agency_Contact__c = currentUser.Id;
			marketingSow.Oblix_AgencyEstimate__c = Oblix_TestUtils.createAccount().Id;
			update marketingSow;
			Oblix_Ctrl06SOWView_CC view = new Oblix_Ctrl06SOWView_CC();
			view.selSow = marketingSow;
			Test.startTest();
			view.CloneAction();
			Test.stopTest();
			System.assertEquals(null, view.sowId);
		}
	}

	@isTest static void SaveSOW_Error_Test() {
		System.runAs(Oblix_TestUtils.createTestUser()) {
			Marketing_SOW__c marketingSow = Oblix_TestUtils.createTestMarketingSow(TEST_NAME, null,
			                                Oblix_TestUtils.createBrand(TEST_NAME, TEST_NAME).Id);
			marketingSow.BB_or_BD__c = null;
			marketingSow.Financial_Year__c = null;
			update marketingSow;
			Oblix_Ctrl06SOWView_CC ctrl = new Oblix_Ctrl06SOWView_CC();
			Test.startTest();
			ctrl.SaveSOW();
			Test.stopTest();
			System.assertNotEquals(null, ctrl.selSow, 'Checking if method changed selSow value');
		}
	}

	@isTest static void deleteAction_Test() {
		System.runAs(Oblix_TestUtils.createTestUser()) {
			Marketing_SOW__c marketingSow = Oblix_TestUtils.createTestMarketingSow(TEST_NAME, null,
			                                Oblix_TestUtils.createBrand(TEST_NAME, TEST_NAME).Id);
			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('test', marketingSow.Id);
			Oblix_Marketing_SOW_Project_Splits__c projectSplit = Oblix_TestUtils.createSowProjectSplits(project.Id);

			Oblix_Ctrl06SOWView_CC ctrl = new Oblix_Ctrl06SOWView_CC();
			ctrl.selSow = marketingSow;
			Test.startTest();
			PageReference result = ctrl.deleteAction();
			Test.stopTest();
			System.assertNotEquals(null, result, 'Page is not correct');
		}
	}

	@isTest static void CountriesByFYear_Test() {
		System.runAs(Oblix_TestUtils.createTestUser()) {
			String calcParam = 'test';
			Oblix_TestUtils.createCalculator('test_calc', calcParam);
			Test.startTest();
			Set<String> result = Oblix_Utils.CountriesByFYear(calcParam);
			Test.stopTest();
			System.assertEquals(1, result.size(), 'Wrong size.');
		}
	}

	@isTest static void actionsTest() {
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

			ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
			ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

			Test.startTest();

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();

			PageReference back = controller.backAction();

			PageReference detail = controller.msDetail();

			PageReference nonCamp = controller.createNonCamp();

			PageReference addProj = controller.AddProject();

			controller.FileCount = '1';

			PageReference changeCount = controller.ChangeCount();

			controller.allFileList = new List<Attachment> {new Attachment(name = TEST_NAME, body = Blob.valueOf(TEST_NAME))};

			PageReference upploadAtt = controller.uploadAttachment();

			PageReference saveAtt = controller.SaveAttachments();

			boolean is = controller.isViewProject;
			set<string> s = controller.setRecordType;
			string r = controller.PrStage;
			string p = controller.PrStatus;
			list<Oblix_Project_Assets__c> l = controller.lstAssets;
			string i = controller.IdsProject;
			List<Attachment> a = controller.AttachementToAdd;

			controller.EditAction();

			controller.Cancel();

			Test.stopTest();

			System.assert(back != null, NOT_NULL_MESSAGE);
			System.assert(detail != null, NOT_NULL_MESSAGE);
			System.assert(nonCamp != null, NOT_NULL_MESSAGE);
			System.assert(addProj != null, NOT_NULL_MESSAGE);
			System.assert(changeCount == null, NULL_MESSAGE);
			System.assert(upploadAtt == null, NULL_MESSAGE);
			System.assert(saveAtt == null, NULL_MESSAGE);
			System.assert(controller.isEdit, 'Edit flag should be set');

		}
	}

	@isTest
	static void populateBigSmallC_Test(){

		System.runAs(Oblix_TestUtils.createTestUser()) {

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(TEST_NAME, TEST_NAME);
			Marketing_SOW__c marketingSow = Oblix_TestUtils.createTestMarketingSow(TEST_NAME, null,
			                                brand.Id);
			marketingSow.BB_or_BD__c = 'BD';
			
			MDO_Category__c bigCategory = Oblix_TestUtils.createBigProductCategory();
			MDO_Category__c smallCategory = Oblix_TestUtils.createSmallProductCategory(bigCategory.Id);

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();
			controller.selSow = marketingSow;

			Test.startTest();

			controller.getCategoryBrand();

			System.assertEquals(null, controller.selSow.SmallProductCategory__c);
			System.assertEquals(null, controller.selSow.BigOblixProductCategory__c);

			Oblix_TestUtils.createCategoryBrand(smallCategory, brand);

			controller.getCategoryBrand();

			Test.stopTest();

			System.assertEquals(smallCategory.Id, controller.selSow.SmallProductCategory__c);
			System.assertEquals(bigCategory.Id, controller.selSow.BigOblixProductCategory__c);

		}

	}

	@isTest
	static void reportListTest(){
		System.runAs(Oblix_TestUtils.createTestUser()) {

			Test.startTest();

			PageReference pr = Oblix_Ctrl06SOWView_CC.reportFolderURL;

			Test.stopTest();

			System.assertNotEquals(null, pr);

		}

	}

	@isTest
	static void ftSelectOptionsTest(){
		System.runAs(Oblix_TestUtils.createTestUser()) {

			Test.startTest();

			Oblix_Ctrl06SOWView_CC controller = new Oblix_Ctrl06SOWView_CC();
			List<SelectOption> fyOptions = controller.getFYSelectOptions();

			Test.stopTest();

			System.assert(fyOptions.size() > 0);

		}

	}
	
}