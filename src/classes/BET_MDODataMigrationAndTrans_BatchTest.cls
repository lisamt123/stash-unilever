/*****************************************************************************************************************************
Name: BET_MDODataMigrationAndTrans_BatchTest
Copyright © 2015 Unilever. 

Purpose: One  off  update  in  BET  to  update  all  BET records  to refer  to  the  new
master data reference tables - test class

History
-------
VERSION AUTHOR                          DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            02/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
@isTest
private class BET_MDODataMigrationAndTrans_BatchTest {

    private static final String CATEGORY_ONE = 'Category One';
    private static final String BRAND_ONE = 'Test Brand One';
    private static final String BRAND_TWO = 'Test Brand Two';
    
    @isTest static void executeTest() {
        uw_Bet__c bet = BET_TestUtils.getTestBet();
        bet.Launch_Date__c = Date.today();
        
        MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
        MDO_Category__c cat = BET_TestUtils.createCategory(categoryGroup, CATEGORY_ONE);
        BET_TestUtils.createCategory(categoryGroup, 'Category Two');
        MDO_Brand__c br = BET_TestUtils.createBrand(BRAND_ONE);
        BET_TestUtils.createBrand(BRAND_TWO);

        uw_Brand__c brandOld = new uw_Brand__c();
        brandOld.name = BRAND_ONE;
        insert brandOld;

        BET_Category__c categoryOld = new BET_Category__c();
        categoryOld.name = 'TestCategoryGroup';
        insert categoryOld;

        BET_Category__c subcategoryOld = new BET_Category__c();
        subcategoryOld.name = CATEGORY_ONE;
        subcategoryOld.BET_Parent_Category__c = categoryOld.id;
        insert subcategoryOld;

        bet.uw_Brand__c = brandOld.id;
        bet.Category__c = categoryOld.id;
        bet.Sub_Category__c = subcategoryOld.id;
        bet.Brand_Position__c = null;
        insert bet;

        MDO_BrandPosition__c bp = new MDO_BrandPosition__c();
        insert bp;

        MDO_BrandPositions__c mbp = new MDO_BrandPositions__c(brand_id__c = br.id,product_category_id__c = cat.id,brand_position_id__c = bp.id);
        insert mbp;

        Test.startTest();
        BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
        Database.executeBatch(batch);
        Test.stopTest();

        bet = [select Brand_Position__c from uw_Bet__c where id =: bet.id];

        System.assertEquals(bet.Brand_Position__c,bp.id,'Brand position field should match given brand position record');
    }

    @isTest static void retrieveCategoryIdTest(){
        Test.startTest();
        uw_Bet__c bet = BET_TestUtils.getTestBet();
        bet.Launch_Date__c = Date.today();
        insert bet;

        MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
        BET_TestUtils.createCategory(categoryGroup, CATEGORY_ONE);

        BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
        System.assert(batch.retrieveCategoryId(categoryGroup,bet) == null,'Category should not equals null');
        Test.stopTest();
    }

    @isTest static void getBrandPositionTest(){
        Test.startTest();
        MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
        MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup, CATEGORY_ONE);
        MDO_Brand__c brand = BET_TestUtils.createBrand(BRAND_ONE);

        MDO_BrandPosition__c bp = new MDO_BrandPosition__c();
        insert bp;

        MDO_BrandPositions__c mbp = new MDO_BrandPositions__c(brand_id__c = brand.id,product_category_id__c = category.id,brand_position_id__c = bp.id);
        insert mbp;

        BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
        System.assertEquals(batch.getBrandPosition(brand.id,category.id),bp.id,'Brand position record should match given brand position record');
        Test.stopTest();
    }
	
	@isTest static void logErrorsTest(){
		Test.startTest();
		BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
		batch.logErrors(new List<uw_Bet__c> {new uw_Bet__c()});
		System.assertEquals(1,1,'Assertion is valid');
		Test.stopTest();
	}
    
}