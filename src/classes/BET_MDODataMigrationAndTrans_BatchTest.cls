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

		Test.startTest();
	    BET_MDODataMigrationAndTransform_Batch batch = new BET_MDODataMigrationAndTransform_Batch();
	    Database.executeBatch(batch);
	    Test.stopTest();

	    //during development

	}
	
}