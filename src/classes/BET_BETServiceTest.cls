/*************************************************************************************
Name : BET_BETServiceTest

Purpose : Test BET_BETService class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  30-07-2015  Initial
*************************************************************************************/

@isTest
private class BET_BETServiceTest {
	
    @isTest static void testGetBet(){
		uw_BET__c betObject = BET_TestUtils.getTestBet();
        //test for not created bet 
        BET_BETWrapper betWrap = BET_BETService.GetBet(betObject.id);
        system.assertEquals(null, betWrap.BetId);
        insert betObject;
        betWrap = BET_BETService.GetBet(betObject.id);
        system.assertEquals(betObject.id, betWrap.BetId);
        system.assertEquals(null, betWrap.FinalReleaseDate);
        //populate Launch date
        betObject.Launch_Date__c = Date.today();
        update betObject;
        betWrap = BET_BETService.GetBet(betObject.id);
        //check id release date is populated
        system.assert(betWrap.FinalReleaseDate != null);
    }
}