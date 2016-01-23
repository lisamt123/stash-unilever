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
	
    private static final String EXCEPTION_MSG = 'Method should throw BET_CustomBETException'; 

    @isTest static void testGetBet(){
		uw_BET__c betObject = BET_TestUtils.getTestBet();
        //test for not created bet 
        try{
            BET_BETService.GetBet(betObject.id);
            system.assertEquals(0,1,EXCEPTION_MSG);
        }catch(BET_CustomBETException ex){
            system.assertEquals(String.format(Label.BetServiceGetBetError,new List<String>{betObject.id}),ex.getMessage(),'Exception should be equal to ' + String.format(Label.BetServiceGetBetError,new List<String>{betObject.id}));
        }

        insert betObject;
        Test.startTest();
        BET_BETWrapper betWrap = BET_BETService.GetBet(betObject.id);
        system.assertEquals(betObject.id, betWrap.BetId,'Bet identifiers must match');
        system.assertEquals(null, betWrap.finalReleaseDueDate,'Final release due date should not be set');
        //populate Launch date
        betObject.Launch_Date__c = Date.today();
        update betObject;
        betWrap = BET_BETService.GetBet(betObject.id);
        //check id release date is populated
        Test.stopTest();
        system.assert(betWrap.finalReleaseDueDate!= null,'Final release due date should be set');
    }

    @isTest static void shouldSearchBets(){
        Test.startTest();
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
        Test.stopTest();
    }

    @isTest static void updateBetTest(){
        uw_BET__c betObject = BET_TestUtils.getTestBet();

        IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
        betObject.IPM_Project__c = project.id;
        insert betObject;

        IPM_BETWrapper IPMProject = new IPM_BETWrapper(project);
        IPMProject.targetLaunchDate = date.today();

        System.assert(betObject.Launch_Date__c == null,'Launch Date should not be set');
        Test.startTest();
        BET_BETService.updateBet(betObject.id,IPMProject);
        Test.stopTest();
        betObject = [select Launch_Date__c from uw_BET__c where id=: betObject.id];

        System.assertEquals(betObject.Launch_Date__c,date.today(),'Launch date should be set to ' + date.today());
    }

    @isTest static void getFirstReleaseDueDateTest(){
        Test.startTest();
        Date dateInJulyOrAfter = BET_BETService.getFirstReleaseDueDate(Date.newInstance(2015,7,10));
        Date dateBeforeJuly = BET_BETService.getFirstReleaseDueDate(Date.newInstance(2015,6,10));
        Test.stopTest();
        System.assertEquals(dateInJulyOrAfter.year(),2014,'Year should be 2014');
        System.assertEquals(dateInJulyOrAfter.month(),6,'Month should be set to June');
        System.assertEquals(dateInJulyOrAfter.day(),30,'Day should be 30');

        System.assertEquals(dateBeforeJuly.year(),2014,'Year should be 2014');
        System.assertEquals(dateBeforeJuly.month(),4,'Month should be set to April');
        System.assertEquals(dateBeforeJuly.day(),15,'Day should be 15');

    }

    @isTest static void getFinalReleaseDueDateTest(){
        Test.startTest();
        Date tld = BET_BETService.getFinalReleaseDueDate(Date.newInstance(2015,9,10));
        Test.stopTest();
        System.assertEquals(tld.year(),2015,'Year should be 2015');
        System.assertEquals(tld.month(),3,'Month should be set to March');
        System.assertEquals(tld.day(),10,'Day should be 10');
    }

    @isTest static void getProductCategoryByMDOIdNullTest(){
        Test.startTest();
        try{
            BET_BETService.getProductCategoryByMDOId('123xyz');
            system.assertEquals(0,1,EXCEPTION_MSG);
        }catch(BET_CustomBETException e){
            system.assertEquals(1,1,EXCEPTION_MSG);
        }
        Test.stopTest();
    }

    @isTest static void updateBetNullTest(){
        Test.startTest();
        try{
            BET_BETService.updateBet(null,null);
            system.assertEquals(0,1,EXCEPTION_MSG);
        }catch(BET_CustomBETException e){
            system.assertEquals(1,1,EXCEPTION_MSG);
        }
        Test.stopTest();
    }

    @isTest static void updateBetFieldsNullTest(){
        Test.startTest();
        try{
            BET_BETService.updateBetFields(null,null);
            system.assertEquals(0,1,EXCEPTION_MSG);
        }catch(BET_CustomBETException e){
            system.assertEquals(1,1,EXCEPTION_MSG);
        }
        Test.stopTest();
    }
}