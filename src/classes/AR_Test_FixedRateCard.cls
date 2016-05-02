@isTest
public with sharing class AR_Test_FixedRateCard {
	static testmethod void Test_AR_FixedRateCard() 
	{
		//current Page 
		test.setCurrentPage(Page.ar_fixedPriceRatecard);//AR_FixedRateCard Maximum Allowable Price Master_Artwork__c
		
		// insert all data required for the page 
		ar_Application__c test_app = TestDataFactory.getApplication();
		test_app.Status__c = 'Incomplete';
		insert test_app;
		AR_SessionHandler.SetCookie(test_app.Id);
		
		
		AR_Fixed_Rate_Card_Questions__c tmp_test1 = new AR_Fixed_Rate_Card_Questions__c();
		tmp_test1.Name = 'Artwork';
		tmp_test1.Task_Group__c = 'Artwork';
		tmp_test1.Task_Group_short__c = 'Artwork';
		tmp_test1.Definition__c = 'Test';
		insert tmp_test1;
		
		AR_Fixed_Rate_Card_Questions__c tmp_test2 = new AR_Fixed_Rate_Card_Questions__c();
		tmp_test2.Name = 'Test';
		tmp_test2.Task_Group_short__c = 'Test';
		tmp_test2.Task_Group__c = 'Test';
		tmp_test2.Definition__c = 'Test';
		insert tmp_test2;
		
		AR_FixedRateCardHelper TestHelper = new AR_FixedRateCardHelper();
		
		Test.startTest();
			AR_FixedRateCardController test_Controller = new AR_FixedRateCardController();
			test_Controller.InitPage();
			test_Controller.AddRow();
			for(String s:test_Controller.fixRateCardObjectList.get(0).fixRateCardObjectListTask.keyset())
			{
				for(AR_SObjectHolder obj:test_Controller.fixRateCardObjectList.get(0).fixRateCardObjectListTask.get(s))
				{
					obj.obj.put('Maximum_Allowable_Price__c',10);
				}
				
			}
			for(AR_SObjectHolder obj:test_Controller.fixRateCardObjectList.get(0).fixRateCardObjectListArtwork)
			{
					obj.obj.put('Master_Artwork__c','test');
			}
			test_Controller.save();
			test_Controller.fixRateCardObjectList.get(0).removerow();
			test_Controller.save();
		Test.stopTest();
		List<ar_Fixed_Price_Rate_Card__c> test_brSystem;
		test_brSystem = [select id,Master_Artwork__c,Maximum_Allowable_Price__c from ar_Fixed_Price_Rate_Card__c where Application__c = :test_app.id and Maximum_Allowable_Price__c != null];
		for(ar_Fixed_Price_Rate_Card__c f:test_brSystem)
		{
			system.assertEquals(10,f.Maximum_Allowable_Price__c, 'Save failed. ar_Fixed_Price_Rate_Card__c is not in the System');
		}
		
		List<ar_Fixed_Price_Rate_Card__c> test_rtASystem;
		test_rtASystem = [select id,Master_Artwork__c,Maximum_Allowable_Price__c from ar_Fixed_Price_Rate_Card__c where Application__c = :test_app.id and Master_Artwork__c != null];
		for(ar_Fixed_Price_Rate_Card__c f:test_rtASystem)
		{
			system.assertEquals('test',f.Master_Artwork__c, 'Save failed. ar_Fixed_Price_Rate_Card__c is not in the System');
		}
	}
	
}