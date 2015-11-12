@isTest
private class Oblix_Ctrl07ProjectEdit_CC_Test {

	private static final String NOT_NULL_MESSAGE = 'Page Reference should not be null';
	
	@isTest static void initTest() {
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
			System.assert(project.Id != null,'project not null');
			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

			Test.stopTest();
		}
	}

	@isTest static void assetWrapperTest(){
		Test.startTest();

		Oblix_Ctrl07ProjectEdit_CC.assetWrapper wrapper = new Oblix_Ctrl07ProjectEdit_CC.assetWrapper();

		System.assert(wrapper.assetWrapp != null,'It should not be null');
		System.assert(wrapper.keyAsset == '','This should be empty string');
		System.assert(wrapper.quantity == 0,'Quantity should be zero');

		Test.stopTest();

	}

	@istest static void backActionWithProjectTest(){
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

			Test.stopTest();

			System.assert(controller.BackAction() != null,NOT_NULL_MESSAGE);
			}	

	}

	@istest static void backActionWithoutProjectTest(){
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {

			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			ApexPages.currentPage().getParameters().put('sowId', mSow.id);

			Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

			Test.stopTest();

			System.assert(controller.BackAction() != null,NOT_NULL_MESSAGE);
		}

	}

	@isTest static void AddAgencySplitTest(){
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

			controller.lstProjectSplitHubs = new List<Oblix_Marketing_SOW_Project_Splits__c>();

			controller.AddAgencySplit();

			Test.stopTest();

			System.assert(!controller.lstProjectSplitHubs.isEmpty(),'Collection should not be empty');
		}
	}
	

	@isTest static void setInfoSplitHubTest(){
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

			controller.listItems = 'null_null_1.0,null_null_2.0,';

			controller.setInfoSplitHub();

			System.assert(controller.agencySplitInstanceJS != null,'Object should not be null');

			Test.stopTest();
		}
	}

	@isTest static void setInfoMethodTest(){
		User u = Oblix_TestUtils.createTestUser();
		System.runAs(u) {
			Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

			Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

			ApexPages.currentPage().getParameters().put('projectId', project.id);

			Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

			controller.setInfoDrivers();
			controller.setInfoStages();
			controller.setInfoCountries();
			controller.setInfoTimeLine();
			controller.EditAction();

			Test.stopTest();

			System.assert(project != null,'Project should not be null');
			System.assert(controller.isEdit,'Edit flag should be set');
		}
	}

}