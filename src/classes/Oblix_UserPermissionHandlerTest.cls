@isTest
private class Oblix_UserPermissionHandlerTest {
	
	@isTest static void testTrigger() {

		String brandName = 'Test_Brand';
		String categoryName = 'Test_Category';

		MDO_Brand__c brand = new MDO_Brand__c();
		brand.Name = brandName;
		brand.mdm_id__c = '111';
		insert brand;

		MDO_Category__c category = new MDO_Category__c();
		category.Name = categoryName;
		category.mdm_id__c = '222';
		category.category_type__c = 'Category';
		insert category;

		MDO_CategoryBrands__c cb = new MDO_CategoryBrands__c();
		cb.mdm_id__c = '333';
		cb.brand_id__c = brand.Id;
		cb.product_Category_Id__c = category.Id;
		insert cb;

		User u = Oblix_TestUtils.createTestUser();
		
		Oblix_User_Permission__c up = new Oblix_User_Permission__c();
		up.Level_of_Access__c = Oblix_Utils.USER_PERMISSION_APPROVER;
		up.CategoryBrand_id__c = cb.Id;
		up.User_id__c = u.Id;
		insert up;

		Oblix_User_Permission__c upDB = [SELECT Id, Brand_Name__c FROM Oblix_User_Permission__c WHERE Id =: up.Id];

		System.assert(upDB.Brand_Name__c == brandName);

	}
	
}