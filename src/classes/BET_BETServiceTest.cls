/*************************************************************************************
Name : BET_BETServiceTest

Purpose : Test BET_BETService class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  30-07-2015  Initial
1.1      piotr.czechusmki@gmail.com    05-08-2015  Add search service
*************************************************************************************/

@isTest (seeAllData=false)
private class BET_BETServiceTest {
	
    @isTest static void testGetBet(){
		uw_BET__c betObject = BET_TestUtils.getTestBet();
        //test for not created bet 
        try{
            BET_BETService.GetBet(betObject.id);
            system.assertEquals(0,1,'method should throw BET_CustomBETException');
        }catch(BET_CustomBETException ex){
            system.assertEquals(String.format(Label.BetServiceGetBetError,new List<String>{betObject.id}),ex.getMessage());
        }

        insert betObject;
        BET_BETWrapper betWrap = BET_BETService.GetBet(betObject.id);
        system.assertEquals(betObject.id, betWrap.BetId);
        system.assertEquals(null, betWrap.FinalReleaseDate);
        //populate Launch date
        betObject.Launch_Date__c = Date.today();
        update betObject;
        betWrap = BET_BETService.GetBet(betObject.id);
        //check id release date is populated
        system.assert(betWrap.FinalReleaseDate != null);
    }

    @isTest static void shouldSearchBets(){
        // given
        BET_TestUtils tu = new BET_TestUtils();
        tu.initBET();

        // when
        Id [] fixedSearchResults= new Id[1];

        // then
        List<BET_BETWrapper> searchResults;

        // Search by name
        fixedSearchResults[0] = tu.liBets.get(0).id; // seting expected results for SOSL
        Test.setFixedSearchResults(fixedSearchResults);
        searchResults = BET_BETService.searchBet(tu.liBets.get(0).name, null, '');
        system.assertEquals(1, searchResults.size(), 'Should return single record by name');
        system.assertEquals(tu.liBets.get(0).name, searchResults.get(0).BetName, 
            'Should return single record with matching name');
        // with Cat Id
        searchResults = BET_BETService.searchBet(tu.liBets.get(0).name, tu.liCategories[0].id, null); 
        // with Cat Mdo Id
        searchResults = BET_BETService.searchBet(tu.liBets.get(0).name, null, tu.liCategories[0].mdm_id__c); 

        fixedSearchResults= new Id[0];
        Test.setFixedSearchResults(fixedSearchResults);
        searchResults = BET_BETService.searchBet('BetWithThisNameCannotExist1.1', null, null);
        system.assertEquals(0, searchResults.size(), 'Should not find any Bet');
    }
}