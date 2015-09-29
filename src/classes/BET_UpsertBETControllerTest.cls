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

		System.assert(controller.catName!='Missing');
		System.assert(controller.categoryGroupName!='Missing');
		System.assert(controller.brandPositionName!='Missing');
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

		System.assert(controller.upsertBet() != null);
		Test.stopTest();
	}
	
	@isTest static void skipForNowTest() {
		Test.startTest();
		BET_UpsertBETController controller = new BET_UpsertBETController();
		controller.cbackskipped = '/apex/bet';
		System.assert(controller.skipForNow() != null);
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

		System.assertEquals(controller.getBrands().size(),2);
		Test.stopTest();
	}
	
}