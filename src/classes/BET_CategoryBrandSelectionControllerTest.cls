@isTest
private class BET_CategoryBrandSelectionControllerTest {

	@isTest static void onCategoryGroupChangeTest(){
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		MDO_Category__c cgroup = BET_TestUtils.createCategoryGroup();
		controller.selectedCategoryGroup = cgroup.Id;
		controller.bet = BET_TestUtils.getTestBet();
		controller.onCategoryGroupChange();
		System.assertEquals(controller.compData.categoryGroup,cgroup.Id);
	}

	@isTest static void onBrandPositioningChangeTest(){
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		MDO_Category__c cgroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c cat = BET_TestUtils.createCategory(cgroup);
		Id positionId = BET_TestUtils.createBrandPosition(cat).id;
		controller.selectedBrandPositioning = positionId;
		controller.onBrandPositioningChange();
		System.assertEquals(controller.compData.brandpositioning,positionId);
	}

	@isTest static void onCategoryChangeTest(){
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		MDO_Category__c cgroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c cat = BET_TestUtils.createCategory(cgroup);
		controller.selectedCategory = cat.id;
		controller.bet = BET_TestUtils.getTestBet();
		controller.onCategoryChange();
		System.assertEquals(controller.compData.category,cat.id);

	}

	@isTest static void setGetBetTest(){
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		uw_Bet__c b = BET_TestUtils.getTestBet();
		controller.bet = b;
		System.assertEquals(controller.bet.id,b.id);
	}

	@isTest static void setCompDataTest(){
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		System.assert(controller.categoryMigrated);
	}


	@isTest static void getCategoryGroupsTest(){
		BET_TestUtils.createCategoryGroup();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		System.assert(!controller.getCategoryGroups().isEmpty());
	}

	@isTest static void getCategoriesTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		BET_TestUtils.createCategory(categoryGroup);
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		controller.selectedCategoryGroup = categoryGroup.id;
		System.assert(!controller.getCategories().isEmpty());
	}

	@isTest static void getBrandPositioningsTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		BET_TestUtils.createBrandPositioning(category);
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		controller.selectedCategory = category.id;
		System.assert(!controller.getBrandPositionings().isEmpty());
	}

	@isTest static void getBrandsTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPositions__c positioning = BET_TestUtils.createBrandPositioning(category);
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		controller.selectedBrandPositioning = positioning.id;
		System.assert(!controller.getBrands().isEmpty());
	}

	@isTest static void onBrandChangeTest(){
		MDO_Brand__c brand = BET_TestUtils.createBrand('Unit Test Brand');
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		controller.selectedBrand = brand.id;
		controller.onBrandChange();
		System.assertEquals(controller.compData.brand,controller.selectedBrand);
	}

	@isTest static void onProjectChangeTest(){
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		uw_Bet__c b = BET_TestUtils.getTestBet();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		controller.bet = b;
		controller.onProjectChange();
		System.assertEquals(controller.compData.inoplanProject,b.Inoplan_Project__c);
	}
	
}