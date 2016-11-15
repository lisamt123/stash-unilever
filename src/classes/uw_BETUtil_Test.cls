/**********************************************************************
Name: uw_BETUtil_Test 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: test for uw_BETUtil. Code coverage only
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class uw_BETUtil_Test{
	static testMethod void testMethodOne(){
		//create bet, brand and categories
       	BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
       	uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_APPROVED);

       	List<uw_BETWrapper.FilterLineItemWrapper> result;

       	result = uw_BETUtil.getFiltersForAsset('', '', 'Brand Development');
       	System.assertEquals(2, result.size());
       	System.assertEquals('MediaTypes', result[0].filterName);
       	System.assertEquals('Countries', result[1].filterName);

       	result = uw_BETUtil.getFiltersForBet(wrap.BET.uw_Brand__c, wrap.BET.Sub_Category__c);
       	System.assertEquals(2, result.size());
       	System.assertEquals('Categories', result[0].filterName);
       	System.assertEquals('Brands', result[1].filterName);

       	result = uw_BETUtil.getFiltersForBet(wrap.BET.uw_Brand__c, wrap.BET.Category__c);
       	System.assertEquals(2, result.size());
       	System.assertEquals('Categories', result[0].filterName);
       	System.assertEquals('Brands', result[1].filterName);
    }

    static testMethod void checkFiltersForBet(){
    	uw_Inoplan_Project__c inoplan = BET_TestingHelper.initInoplan('Test Inoplan', true);

    	BET_Category__c parentCategory = BET_TestingHelper.initCategory('Test Parent', true);
        BET_Category__c subCategory = BET_TestingHelper.initCategory('Test Subcategory', parentCategory, true);
        uw_Brand__c brand = BET_TestingHelper.initBrand('Test Brand', true);

        BET_Category_Brands__c b = new BET_Category_Brands__c(BET_Category__c=subCategory.Id, BET_Brand__c=brand.Id);
        insert b;
        
        User u = BET_TestingHelper.getDefaultOwner();

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(u, 'Test BET Name', BET_TestingHelper.BET_STATUS_FIRSTRELEASE, inoplan, parentCategory, subCategory, brand, true);

        List<uw_BETWrapper.FilterLineItemWrapper> result = uw_BETUtil.getFiltersForBet(brand.Id, subCategory.Id);
        System.assertEquals(2, result.size());
    }
}