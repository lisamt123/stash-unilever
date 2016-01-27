@isTest
private class BET_CategoryBrandSelectionControllerTest {

	@isTest static void onCategoryGroupChangeTest(){
		Test.startTest();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		MDO_Category__c cgroup = BET_TestUtils.createCategoryGroup();
		controller.selectedCategoryGroup = cgroup.Id;
		controller.bet = BET_TestUtils.getTestBet();
		controller.onCategoryGroupChange();
		System.assertEquals(controller.compData.categoryGroup,cgroup.Id,'Category group ids should match');
		Test.stopTest();
	}

	@isTest static void onBrandPositioningChangeTest(){
		Test.startTest();
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
		System.assertEquals(controller.compData.brandpositioning,positionId,'Brand position ids should match');
		Test.stopTest();
	}

	@isTest static void onCategoryChangeTest(){
		Test.startTest();
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
		System.assertEquals(controller.compData.category,cat.id,'Category ids should match');
		Test.stopTest();
	}

	@isTest static void setGetBetTest(){
		Test.startTest();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		uw_Bet__c b = BET_TestUtils.getTestBet();
		controller.bet = b;
		System.assertEquals(controller.bet.id,b.id,'Toolkit ids should match');
		Test.stopTest();
	}

	@isTest static void setCompDataTest(){
		Test.startTest();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		System.assert(controller.categoryMigrated,'Category should be marked as migrated');
		Test.stopTest();
	}


	@isTest static void getCategoryGroupsTest(){
		Test.startTest();
		BET_TestUtils.createCategoryGroup();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		System.assert(!controller.getCategoryGroups().isEmpty(),'Category group list should not be empty');
		Test.stopTest();
	}

	@isTest static void getCategoriesTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		BET_TestUtils.createCategory(categoryGroup);
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		controller.selectedCategoryGroup = categoryGroup.id;
		System.assert(!controller.getCategories().isEmpty(),'Category list should not be empty');
		Test.stopTest();
	}

	@isTest static void getBrandPositioningsTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		BET_TestUtils.createBrandPositioning(category);
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		controller.selectedCategory = category.id;
		System.assert(!controller.getBrandPositionings().isEmpty(),'Brand potitioning list should not be empty');
		Test.stopTest();
	}

	@isTest static void getBrandsTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPositions__c positioning = BET_TestUtils.createBrandPositioning(category);
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		controller.selectedBrandPositioning = positioning.id;
		System.assert(!controller.getBrands().isEmpty(),'Brand list should not be empty');
		Test.stopTest();
	}

	@isTest static void onBrandChangeTest(){
		Test.startTest();
		MDO_Brand__c brand = BET_TestUtils.createBrand('Unit Test Brand');
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		controller.selectedBrand = brand.id;
		controller.onBrandChange();
		System.assertEquals(controller.compData.brand,controller.selectedBrand,'Brand ids should match');
		Test.stopTest();
	}

	@isTest static void onProjectChangeTest(){
		Test.startTest();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		uw_Bet__c b = BET_TestUtils.getTestBet();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		controller.bet = b;
		controller.onProjectChange();
		System.assertEquals(controller.compData.inoplanProject,b.Inoplan_Project__c,'Inoplan project ids should match');
		Test.stopTest();
	}

	@isTest static void getUserHasAccessToProjectTest(){
		Test.startTest();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		System.assert(!controller.getUserHasAccessToProject(),'User should not have access');
		Test.stopTest();
	}

	//FabricConditioner begin
	@isTest static void updateFabricDataTest(){
		Test.startTest();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		uw_Bet__c b = BET_TestUtils.getTestBet();
		BET_CategoryComponentData compData = new BET_CategoryComponentData();
		compData.categoryMigrated = true;
		compData.categoryNotMigrated = false;
		controller.compData = compData;
		controller.bet = b;
		controller.updateFabricData(true);
		controller.onFabricConditionersChange();
		System.assert(controller.compData.fabricConditionerCategory,'Conditioner category flag should be set');
		Test.stopTest();
	}

	@isTest static void getFabricConditionersTest(){
		Test.startTest();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		System.assert(!controller.getFabricConditioners().isEmpty(),'Fabric Conditioner list should not be empty');
		Test.stopTest();
	}
	//FabricConditioner end
	
}