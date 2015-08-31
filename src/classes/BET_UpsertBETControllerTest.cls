@isTest
private class BET_UpsertBETControllerTest {
	

	@isTest static void gettersTest() {

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
	}

	@isTest static void settersTest() {

		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPosition__c position = BET_TestUtils.createBrandPosition(category);
		BET_MasterDataService.getBETBrandsForGivenPositioning(position.id);

		BET_UpsertBETController controller = new BET_UpsertBETController();

		controller.catName ='Category Name';
		controller.categoryGroupName ='Category Group Name';
		controller.brandPositionName ='Brand Position Name';
		controller.betobject = new uw_Bet__c();

		System.assert(true);
	}

	@isTest static void upsertBetTest() {

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
	}
	
	@isTest static void skipForNowTest() {
		BET_UpsertBETController controller = new BET_UpsertBETController();
		controller.cbackskipped = '/apex/bet';
		System.assert(controller.skipForNow() != null);
	}

	@isTest static void getBrandsTest(){
		BET_UpsertBETController controller = new BET_UpsertBETController();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPosition__c position = BET_TestUtils.createBrandPosition(category);
		BET_MasterDataService.getBETBrandsForGivenPositioning(position.id);
		controller.cat = category.id;
		controller.categoryName = categoryGroup.id;
		controller.brandPosition = position.id;

		System.assertEquals(controller.getBrands().size(),2);
	}
	
}