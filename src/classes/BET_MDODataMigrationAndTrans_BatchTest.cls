/*****************************************************************************************************************************
Name: BET_MDODataMigrationAndTrans_BatchTest
Copyright © 2015 Unilever. 

Purpose: One  off  update  in  BET  to  update  all  BET records  to refer  to  the  new
master data reference tables - test class

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            02/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
@isTest
private class BET_MDODataMigrationAndTrans_BatchTest {
	
	@isTest static void executeTest() {

		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Launch_Date__c = Date.today();
		insert bet;

		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		BET_TestUtils.createCategory(categoryGroup, 'Category One');
		BET_TestUtils.createCategory(categoryGroup, 'Category Two');
		BET_TestUtils.createBrand('Test Brand One');
		BET_TestUtils.createBrand('Test Brand Two');

		Test.startTest();
	    BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
	    Database.executeBatch(batch);
	    Test.stopTest();

	    //during development

	}

	@isTest static void retrieveCategoryIdTest(){

		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Launch_Date__c = Date.today();
		insert bet;

		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		BET_TestUtils.createCategory(categoryGroup, 'Category One');

		BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
		System.assert(batch.retrieveCategoryId(categoryGroup,bet) == null);
	}

	@isTest static void getBrandPositionTest(){

		MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
		MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup, 'Category One');
		MDO_Brand__c brand = BET_TestUtils.createBrand('Test Brand One');

		MDO_BrandPosition__c bp = new MDO_BrandPosition__c();
		insert bp;

		MDO_BrandPositions__c mbp = new MDO_BrandPositions__c(brand_id__c = brand.id,product_category_id__c = category.id,brand_position_id__c = bp.id);
		insert mbp;

		BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
		System.assertEquals(batch.getBrandPosition(brand.id,category.id),bp.id);
	}
	
}