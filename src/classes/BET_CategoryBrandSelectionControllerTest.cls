@isTest
private class BET_CategoryBrandSelectionControllerTest {

	@isTest static void getCategoryGroupsTest(){
		BET_TestUtils.createCategoryGroup();
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		System.assert(!controller.getCategoryGroups().isEmpty());
	}

	@isTest static void getCategoriesTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		BET_CategoryBrandSelectionController controller = new BET_CategoryBrandSelectionController();
		controller.selectedCategoryGroup = categoryGroup.id;
		System.assert(!controller.getCategories().isEmpty());
	}

	@isTest static void getBrandPositioningsTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPositions__c positioning = BET_TestUtils.createBrandPositioning(category);
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
	
}