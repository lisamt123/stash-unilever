/**********************************************************************
Name: BET_SoslFieldsBatch_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_SoslFieldsBatch
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/01/2015      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_SoslFieldsBatch_Test { 
    /*******************************************************************
    Purpose: Method to test populating fields for SOSL queries
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapStatus(){
        uw_Inoplan_Project__c inoplan = BET_TestingHelper.initInoplan('Test Inoplan', true);

    	BET_Category__c parentCategory = BET_TestingHelper.initCategory('Test Parent', true);
        BET_Category__c subCategory = BET_TestingHelper.initCategory('Test Subcategory', parentCategory, true);
        uw_Brand__c brand = BET_TestingHelper.initBrand('Test Brand', true);

        BET_Category_Brands__c b = new BET_Category_Brands__c(BET_Category__c=subCategory.Id, BET_Brand__c=brand.Id);
        insert b;
        
        User u = BET_TestingHelper.getDefaultOwner();

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(u, 'Test BET Name', BET_TestingHelper.BET_STATUS_FIRSTRELEASE, inoplan, parentCategory, subCategory, brand, true);

		// Start test
		Test.startTest();
		BET_SoslFieldsBatch batchMapping = new  BET_SoslFieldsBatch();
		Database.executeBatch(batchMapping, 200);
		Test.stopTest();

		uw_BET__c bet = [SELECT Id, Name, Inoplan_Project_Keyword_Search__c, Brand_Keyword_Search__c, Category_Keyword_Search__c, Owner_Keyword_Search__c FROM uw_BET__c WHERE Name = 'Test BET Name'];

		System.assertEquals('Test Inoplan', bet.Inoplan_Project_Keyword_Search__c);
		System.assertEquals('Test Brand', bet.Brand_Keyword_Search__c);
		System.assertEquals('Test Subcategory', bet.Category_Keyword_Search__c);
		System.assertEquals('test-owner', bet.Owner_Keyword_Search__c);
    }
}