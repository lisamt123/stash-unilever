@isTest
private class BET_UpsertBETControllerTest {
	

	@isTest static void gettersTest() {
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPosition__c position = BET_TestUtils.createBrandPosition(category);
		BET_MasterDataService.getBETBrandsForGivenPositioning(position.id);

		BET_UpsertBETController controller = new BET_UpsertBETController();
		controller.cat = category.id;
		controller.categoryName = categoryGroup.id;
		controller.brandPosition = position.id;
		controller.projectName = 'TestProjectName';

		System.assert(controller.catName!='Missing','Category name should be set');
		System.assert(controller.categoryGroupName!='Missing','Category group name should be set');
		System.assert(controller.brandPositionName!='Missing','Brand position name should be set');

		controller.categoryGroupName = 'TestName';
		controller.catName = 'TestName';
		controller.brandPositionName = 'TestName';
		controller.betobject = new uw_BET__c();

		Test.stopTest();
	}

	@isTest static void upsertBetTest() {
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPosition__c position = BET_TestUtils.createBrandPosition(category);
		BET_MasterDataService.getBETBrandsForGivenPositioning(position.id);

		BET_UpsertBETController controller = new BET_UpsertBETController();
		controller.cat = category.id;
		controller.categoryName = categoryGroup.id;
		controller.brandPosition = position.id;
		controller.projectName = 'TestProjectName';
		controller.owner = UserInfo.getUserId();

		System.assert(controller.upsertBet() != null,'Page reference should not be null');
		Test.stopTest();
	}
	
	@isTest static void skipForNowTest() {
		Test.startTest();
		BET_UpsertBETController controller = new BET_UpsertBETController();
		controller.cbackskipped = '/apex/bet';
		System.assert(controller.skipForNow() != null,'Page reference should not be null');
		Test.stopTest();
	}

	@isTest static void getBrandsTest(){
		Test.startTest();
		BET_UpsertBETController controller = new BET_UpsertBETController();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPosition__c position = BET_TestUtils.createBrandPosition(category);
		BET_MasterDataService.getBETBrandsForGivenPositioning(position.id);
		controller.cat = category.id;
		controller.categoryName = categoryGroup.id;
		controller.brandPosition = position.id;

		System.assertEquals(controller.getBrands().size(),2,'There should be 2 brands available');
		Test.stopTest();
	}

	@isTest static void addErrorMessageTest(){
		BET_UpsertBETController controller = new BET_UpsertBETController();
		Test.startTest();
		System.assert(controller.addErrorMessage('test messge') == null,'Page reference should be null');
		Test.stopTest();
	}
	
}