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
1.1 -   Michal Bluj             29/07/2015      MDO Object related changes + removed redundand tests
**********************************************************************/
@isTest
private class uw_BETUtil_Test{

  private static final String MEDIA_TYPES = 'MediaTypes';
  private static final String COUNTRIES = 'Countries';
  private static final String CATEGORIES = 'Categories';
  private static final String BRANDS = 'Brands';

	@isTest static void getFiltersForAssetTest(){
    BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
    uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_APPROVED);
    List<uw_BETWrapper.FilterLineItemWrapper> result = uw_BETUtil.getFiltersForAsset('', '', 'Brand Development');
    System.assertEquals(2, result.size());
    System.assertEquals(MEDIA_TYPES, result[0].filterName);
    System.assertEquals(COUNTRIES, result[1].filterName);
  }

  @isTest static void getFiltersForBetTest(){
    uw_Bet__c betObject = BET_TestUtils.getTestBet();
    insert betObject;
    List<uw_BETWrapper.FilterLineItemWrapper> result = uw_BETUtil.getFiltersForBet(betObject.Product_Brand__c,betObject.Product_Category__c);
    System.assertEquals(2, result.size());
    System.assertEquals(CATEGORIES, result[0].filterName);
    System.assertEquals(BRANDS, result[1].filterName);
  }

}