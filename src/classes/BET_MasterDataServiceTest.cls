@isTest
public class BET_MasterDataServiceTest {

	@isTest static void getBETCategoryGroupsTest() {
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		List<sObject> groups = BET_MasterDataService.getBETCategoryGroups();
		System.assert(!groups.isEmpty());
	}
	
	@isTest static void getBETCategoriesForGivenGroupTest() {
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		List<sObject> categories = BET_MasterDataService.getBETCategoriesForGivenGroup(categoryGroup.id);
		System.assert(!categories.isEmpty());
	}

	@isTest static void getBETBrandPositioningsForGivenCategoryAndGroupTest() {
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPositions__c positioning = BET_TestUtils.createBrandPositioning(category);
		BET_MasterDataService.getBETBrandPositioningsForGivenCategoryAndGroup(category.id);
	}

	@isTest static void getBETBrandsForGivenPositioningTest() {
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPosition__c position = BET_TestUtils.createBrandPosition(category);
		List<sObject> brands = BET_MasterDataService.getBETBrandsForGivenPositioning(position.id);
		System.assert(!brands.isEmpty());
	}

	@isTest static void isCategoryMigratedToIPMTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		Boolean ismigrated = BET_MasterDataService.isCategoryMigratedToIPM(category.id);
		System.assert(ismigrated);
	}

	@isTest static void getCategoryGroupNameTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		String name = BET_MasterDataService.getCategoryGroupName(categoryGroup.id);
		System.assertEquals(name,categoryGroup.name);
	}

	@isTest static void getCategoryNameTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		String name = BET_MasterDataService.getCategoryName(category.id);
		System.assertEquals(name,category.name);
	}

	@isTest static void getBrandPositionNameTest(){
		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup);
		MDO_BrandPositions__c positioning = BET_TestUtils.createBrandPositioning(category);
		String name = BET_MasterDataService.getBrandPositionName(positioning.id);
		System.assertEquals(name,positioning.brand_position_id__r.name);
	}
	
}