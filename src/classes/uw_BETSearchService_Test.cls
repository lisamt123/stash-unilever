/**********************************************************************
Name: uw_BETSearchService_Test
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: test for uw_BETSearchService
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             26/11/2014      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class uw_BETSearchService_Test{
    public class TestingHelper{
        public User testUser;
        public uw_Brand__c testBrand;
        public BET_Category__c testCategory;
        public uw_BET__c testBet;
        public TestingHelper(){}

        private void prepareData(){

            User u = uw_UnitTestDataFactory.initInternalUser('TestBzz', 'testbzz@force.com', 'testbzz', 'testbzz@force.com');

            uw_BET__c bet1 = BET_TestUtils.getTestBet();
            bet1.name = 'Bet1'+Math.random();

            uw_BET__c bet2 = BET_TestUtils.getTestBet();
            bet2.name = 'Bet2'+Math.random();

            uw_BET__c bet3 = BET_TestUtils.getTestBet();
            bet3.name = 'Bet3'+Math.random();

            uw_BET__c bet4 = BET_TestUtils.getTestBet();
            bet4.name = 'Bet4'+Math.random();
            bet4.OwnerId = u.Id;

            insert new List<uw_BET__c>{bet1,bet2,bet3,bet4};

            //add members to bets
            uw_BET_Team_Member__c member1 = uw_UnitTestDataFactory.initTeamMember(u, bet1, uw_Constants.ACCESS_LEVEL_FULL,
                                            uw_Constants.BET_TEAM_ROLE_MANAGER, true, true, true, true);

            uw_BET_Team_Member__c member2 = uw_UnitTestDataFactory.initTeamMember(u, bet2, uw_Constants.ACCESS_LEVEL_FULL,
                                            uw_Constants.BET_TEAM_ROLE_MANAGER, true, true, true);


            uw_BET_Team_Member__c member3 = uw_UnitTestDataFactory.initTeamMember(u, bet3, uw_Constants.ACCESS_LEVEL_FULL,
                                            uw_Constants.BET_TEAM_ROLE_MANAGER, true, true, true);

            uw_BET_Team_Member__c member4 = uw_UnitTestDataFactory.initTeamMember(u, bet4, uw_Constants.ACCESS_LEVEL_FULL,
                                            uw_Constants.BET_TEAM_ROLE_MANAGER, true, true, true);


            uw_BET__Share newShare1 = new uw_BET__Share();
            newShare1.UserOrGroupId = member1.Team_Member__c;
            newShare1.AccessLevel = 'Read';
            newShare1.ParentId = member1.BET__c;
            insert newShare1;

            uw_BET__Share newShare2 = new uw_BET__Share();
            newShare2.UserOrGroupId = member2.Team_Member__c;
            newShare2.AccessLevel = 'Read';
            newShare2.ParentId = member2.BET__c;
            insert newShare2;

            uw_BET__Share newShare3 = new uw_BET__Share();
            newShare3.UserOrGroupId = member3.Team_Member__c;
            newShare3.AccessLevel = 'Read';
            newShare3.ParentId = member3.BET__c;
            insert newShare3;


            testUser = u;
            testBet = bet1;
        }
    }

    static testMethod void testMethodOne(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        uw_BETWrapper response;
        Test.startTest();
        System.runAs(u){
            response = uw_BETSearchService.getMyBETs();
        }
        Test.stopTest();
        //check if proper data was returned
        System.AssertEquals('0', response.status);   
        
        Map<String, List<uw_BETWrapper.BetSearchItem>> wraps = (Map<String, List<uw_BETWrapper.BetSearchItem>>)response.data;
        System.AssertEquals(2, wraps.get('betsIamMemberOf').size());   
        System.AssertEquals(1, wraps.get('betsIamOwnerOf').size());   
    }

    static testMethod void testMethodTwo(){
        uw_BET__c bet1 = BET_TestUtils.getTestBet();
        bet1.name = 'Bet1'+Math.random();
        insert bet1;

        User u = uw_UnitTestDataFactory.initInternalUser('Test277', 'test277@force.com', 'test277', 'test277@force.com');

        uw_BETWrapper.SearchWrapper response;
        Test.startTest();
        System.runAs(u){
            response = uw_BETSearchService.search(bet1.Product_Brand__c,'','',3,1,true,true,'');
        }    
        Test.stopTest();
        
        System.AssertEquals(1, response.betSearchResult.size());  
    }

    static testMethod void testMethodThree(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;

        Test.startTest();
        System.runAs(u){
            response=uw_BETSearchService.search('','','',1,1,true,true,'');
        }    
        Test.stopTest();

        System.AssertEquals(1, response.betSearchResult.size());  
        System.AssertEquals(2, response.searchFilters.size());
    }

    static testMethod void testMethodFour(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;

        Test.startTest();
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,true,'');
        }    
        Test.stopTest();

        System.AssertEquals(4, response.betSearchResult.size());  
        System.AssertEquals(0, response.searchFilters.size());
    }

    static testMethod void testMethodSix(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;

        Test.startTest();
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,true,'betOwnerName');
        }    
        Test.stopTest();

        System.AssertEquals(4, response.betSearchResult.size());  
        System.AssertEquals(0, response.searchFilters.size());
    }

    static testMethod void testMethodSeven(){
        uw_BET__c bet1 = BET_TestUtils.getTestBet();
        bet1.name = 'Bet1'+Math.random();
        insert bet1;

        User u = uw_UnitTestDataFactory.initInternalUser('Test277', 'test277@force.com', 'test277', 'test277@force.com');
        
        uw_BETWrapper.SearchWrapper response;

        Test.startTest();
        System.runAs(u){
            response=uw_BETSearchService.search('',bet1.Product_Category__c,'',3,1,false,true,'');
        }    
        Test.stopTest();

        System.AssertEquals(bet1.name, response.betSearchResult[0].betName); 
    }

    static testMethod void testMethodEight(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;

        Test.startTest();
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,false,'');
        }    
        Test.stopTest();

        System.assert(response.betSearchResult[0].betName.contains('Bet4')); 
    }

    static testMethod void testMethodNine(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;

        Test.startTest();
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,true,'betName');
        }    
        Test.stopTest();

        System.Assert(response.betSearchResult[0].betName.contains('Bet1')); 
    }

    static testMethod void testMethodTen(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = helper.testBet.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        System.runAs(u){
            response=uw_BETSearchService.search('','','Bet1',1,1,false,true,'');
        }    
        Test.stopTest();

        System.AssertEquals(0, response.searchFilters.size());
    }
}