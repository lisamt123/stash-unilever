@isTest
public class BET_MasterDataServiceTest {

	@isTest static void getBETCategoryGroupsTest() {
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		List<sObject> groups = BET_MasterDataService.getBETCategoryGroups();
		System.assertEquals(groups.get(0).id,categoryGroup.id,'Category group id must match');
		Test.stopTest();
	}
	
	@isTest static void getBETCategoriesForGivenGroupTest() {
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		List<sObject> categories = BET_MasterDataService.getBETCategoriesForGivenGroup(categoryGroup.id);
		System.assertEquals(categories.get(0).id,category.id,'Category id must match');
		System.assert(BET_MasterDataService.getBETCategoriesForGivenGroup(null).isEmpty(),'Result set should be empty');
		Test.stopTest();
	}

	@isTest static void getBETBrandPositioningsForGivenCategoryAndGroupTest() {
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		BET_TestUtils.createBrandPosition(category);
		List<MDO_BrandPosition__c> positions = BET_MasterDataService.getBETBrandPositioningsForGivenCategoryAndGroup(category.id);
		System.assertEquals(positions.size(),1,'There should be one brand position retrieved');
		Test.stopTest();
	}

	@isTest static void getBETBrandsForGivenPositioningTest() {
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPosition__c position = BET_TestUtils.createBrandPosition(category);
		List<sObject> brands = BET_MasterDataService.getBETBrandsForGivenPositioning(position.id);
		System.assertEquals(((MDO_Brand__c)brands.get(0)).name,'battle Axe','Brand name must match');
		Test.stopTest();
	}

	@isTest static void getCategoryGroupNameTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		String name = BET_MasterDataService.getCategoryGroupName(categoryGroup.id);
		System.assertEquals(name,categoryGroup.name,'Category group name must match');
		Test.stopTest();
	}

	@isTest static void getCategoryNameTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		String name = BET_MasterDataService.getCategoryName(category.id);
		System.assertEquals(name,category.name,'Category name must match');
		Test.stopTest();
	}

	@isTest static void getBrandPositionNameTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPositions__c positioning = BET_TestUtils.createBrandPositioning(category);
		String name = BET_MasterDataService.getBrandPositionName(positioning.id);
		System.assertEquals(name,positioning.brand_position_id__r.name,'Brand position name must match');
		Test.stopTest();
	}

	@isTest static void getAllAvailableCategoriesTest(){
		Test.startTest();
		System.assertEquals(BET_MasterDataService.getAllAvailableCategories().size(),0,'There should be no available category');
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		BET_TestUtils.createCategory(categoryGroup);
		System.assertEquals(BET_MasterDataService.getAllAvailableCategories().size(),1,'There should be one available category');
		Test.stopTest();
	}

	@isTest static void getAllAvailableUniqueBrandsForCategoryTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		System.assertEquals(BET_MasterDataService.getAllAvailableUniqueBrandsForCategory(category.id).size(),0,'There should be no available brands for category');
		BET_TestUtils.createBrandPosition(category);
		System.assertEquals(BET_MasterDataService.getAllAvailableUniqueBrandsForCategory(category.id).size(),1,'There should be one available brand for category');
		Test.stopTest();
	}

	@isTest static void isFabricConditionersCategoryTest(){
		Test.startTest();
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		category.Name = BET_MasterDataService.LAUNDRY;
		update category;
		System.assert(BET_MasterDataService.isFabricConditionersCategory(category.id),'This should be fabric conditioners category');
		Test.stopTest();
	}

	@isTest static void isValidRelationWithBrandPositionAndCategoryNullTest(){
		Test.startTest();
		System.assert(!BET_MasterDataService.isValidRelationWithBrandPositionAndCategory(null,null),'Should be not valid');
		Test.stopTest();
	}

	@isTest static void isValidRelationWithCategoryAndCategoryGroupNullTest(){
		Test.startTest();
		System.assert(!BET_MasterDataService.isValidRelationWithCategoryAndCategoryGroup(null,null),'Should be not valid');
		Test.stopTest();
	}
	
}