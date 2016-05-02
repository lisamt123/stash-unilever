/*****************************************************************************************************************************
Name: BET_InoplanToIPMMigration_Batch_Test
Copyright © 2015 Unilever. 

Purpose: Unit test for BET_InoplanToIPMMigration_Batch

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   piotr.czechumski@gmail.com      04/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
@isTest (SeeAllData=false)
private class BET_InoplanToIPMMigration_Batch_Test {
	
	@isTest static void shouldCreateFollowRequest() {
		// given
		BET_TestUtils tu = new BET_TestUtils();
		tu.initBET();
		User sa = BET_TestUtils.createUserSystemAdmin();
		IPM_Project__c ipmProject = BET_TestUtils.createIPMProject('Test mig',
			tu.liInoplanProjects[0].Project_Id__c + BET_InoplanToIPMMigration_Batch.IPM_INOPLAN_SUFFIX, sa.id, sa.id );
		String strCatName = tu.liCategories[0].name;

		System.assertEquals(false, [select id, Is_Archived__c from uw_bet__c where id = :tu.liBets[0].id].Is_Archived__c);
		// when
		Test.startTest();
			BET_InoplanToIPMMigration_Batch batch = new BET_InoplanToIPMMigration_Batch(strCatName);
			Database.executeBatch(batch);
		Test.stopTest();

		// then
		List<BET_Follow_Request__c> liRequests = [select Brand_Experience_Toolkit__c, Project_Id__c from BET_Follow_Request__c 
													where Brand_Experience_Toolkit__c = :tu.liBets[0].id];
		System.assertEquals(1, liRequests.size(), 'There should be 1 request pending');
		System.assertEquals(ipmProject.id, liRequests[0].Project_Id__c, 'Request should be for provided IPM');
	}

	@isTest static void shouldLogErrorNoIPMFound() {
		// given
		BET_TestUtils tu = new BET_TestUtils();
		tu.initBET();
		String strCatName = tu.liCategories[0].name;

		// when
		Test.startTest();
			BET_InoplanToIPMMigration_Batch batch = new BET_InoplanToIPMMigration_Batch(strCatName);
			Database.executeBatch(batch);
		Test.stopTest();

		// then
		List<BET_Follow_Request__c> liRequests = [select Brand_Experience_Toolkit__c, Project_Id__c from BET_Follow_Request__c 
													where Brand_Experience_Toolkit__c = :tu.liBets[0].id];
		System.assertEquals(0, liRequests.size(), 'There should no pending request');
	}
}