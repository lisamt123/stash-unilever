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
            uw_Brand__c brand = uw_UnitTestDataFactory.initBrand('Test', true);
            uw_Inoplan_Project__c infoProject = uw_UnitTestDataFactory.createInoplan();
            insert infoProject;

            uw_Brand__c brand2 = uw_UnitTestDataFactory.initBrand('Brand', true);

            BET_Category__c cat1 = new BET_Category__c(Name='Cat1');
            insert cat1;

            BET_Category__c cat2 = new BET_Category__c(Name='Cat2', BET_Parent_Category__c=cat1.Id);
            insert cat2;

            BET_Category__c cat3 = new BET_Category__c(Name='Cat3');
            insert cat3;

            BET_Category__c cat4 = new BET_Category__c(Name='Cat4', BET_Parent_Category__c=cat3.Id);
            insert cat4;

            BET_Category_Brands__c junc1 = new BET_Category_Brands__c(BET_Brand__c=brand.Id, BET_Category__c=cat2.Id);
            insert junc1;

            BET_Category_Brands__c junc2 = new BET_Category_Brands__c(BET_Brand__c=brand2.Id, BET_Category__c=cat4.Id);
            insert junc2;

            uw_BET__c bet1 = uw_UnitTestDataFactory.initBET('Bet1', brand, true, infoProject, cat1, cat2);
            uw_BET__c bet2 = uw_UnitTestDataFactory.initBET('Bet2', brand, true, infoProject, cat1, cat2);
            uw_BET__c bet3 = uw_UnitTestDataFactory.initBET('Bet3', brand, true, infoProject, cat1, cat2);
            uw_BET__c bet4 = uw_UnitTestDataFactory.initBET('Bet4', brand2, true, infoProject, cat3, cat4);

            User u = uw_UnitTestDataFactory.initInternalUser('TestBzz', 'testbzz@force.com', 'testbzz', 'testbzz@force.com');

            //add members to bets
            uw_BET_Team_Member__c member1 = uw_UnitTestDataFactory.initTeamMember(u, bet1, uw_Constants.ACCESS_LEVEL_FULL,
                                            uw_Constants.BET_TEAM_ROLE_MANAGER, true, true, true, true);


            uw_BET_Team_Member__c member2 = uw_UnitTestDataFactory.initTeamMember(u, bet2, uw_Constants.ACCESS_LEVEL_FULL,
                                            uw_Constants.BET_TEAM_ROLE_MANAGER, true, true, true);


            uw_BET_Team_Member__c member3 = uw_UnitTestDataFactory.initTeamMember(u, bet3, uw_Constants.ACCESS_LEVEL_FULL,
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

            //add owner to bet
            bet4.OwnerId = u.Id;
            update bet4;

            uw_BET_Team_Member__c member4 = uw_UnitTestDataFactory.initTeamMember(u, bet4, uw_Constants.ACCESS_LEVEL_FULL,
                                            uw_Constants.BET_TEAM_ROLE_MANAGER, true, true, true);

            testUser = u;
            testBrand = brand2;
            testCategory = cat2;
            testBet = bet1;
        }
    }

    static testMethod void testMethodOne(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        uw_BETWrapper response;
        System.runAs(u){
            response = uw_BETSearchService.getMyBETs();
        }    
        //check if proper data was returned
        System.AssertEquals('0', response.status);   
        
        Map<String, List<uw_BETWrapper.BetSearchItem>> wraps = (Map<String, List<uw_BETWrapper.BetSearchItem>>)response.data;
        System.AssertEquals(2, wraps.get('betsIamMemberOf').size());   
        System.AssertEquals(1, wraps.get('betsIamOwnerOf').size());   
    }

    /*static testMethod void testMethodTwo(){
        uw_Brand__c brand = uw_UnitTestDataFactory.initBrand('Test', true);
        uw_Inoplan_Project__c infoProject = uw_UnitTestDataFactory.createInoplan();
        insert infoProject;

        BET_Category__c cat1 = new BET_Category__c(Name='Cat1');
        insert cat1;

        BET_Category__c cat2 = new BET_Category__c(Name='Cat2', BET_Parent_Category__c=cat1.Id);
        insert cat2;
     
        BET_Category_Brands__c junc1 = new BET_Category_Brands__c(BET_Brand__c=brand.Id, BET_Category__c=cat2.Id);
        insert junc1;

        uw_BET__c bet1 = uw_UnitTestDataFactory.initBET('Bet1', brand, true, infoProject, cat1, cat2);
        uw_BET__c bet2 = uw_UnitTestDataFactory.initBET('Bet2', brand, true, infoProject, cat1, cat2);
        uw_BET__c bet3 = uw_UnitTestDataFactory.initBET('Bet3', brand, true, infoProject, cat1, cat2);

        User u = uw_UnitTestDataFactory.initInternalUser('Test277', 'test277@force.com', 'test277', 'test277@force.com');

        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response = uw_BETSearchService.search(brand.Id,'','',3,1,true,true,'');
        }    
        
        System.AssertEquals(3, response.betSearchResult.size());  
    }*/

    static testMethod void testMethodThree(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response=uw_BETSearchService.search('','','',1,1,true,true,'');
        }    

        System.AssertEquals(1, response.betSearchResult.size());  
        System.AssertEquals(2, response.searchFilters.size());
    }

    static testMethod void testMethodFour(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,true,'');
        }    

        System.AssertEquals(4, response.betSearchResult.size());  
        System.AssertEquals(0, response.searchFilters.size());
    }

    /*static testMethod void testMethodFive(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        
        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response=uw_BETSearchService.search(helper.testBrand.Id,'','',4,1,false,true,'');
        }    

        System.AssertEquals(1, response.betSearchResult.size());  
        System.AssertEquals(0, response.searchFilters.size());
    }*/

    static testMethod void testMethodSix(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,true,'betOwnerName');
        }    

        System.AssertEquals(4, response.betSearchResult.size());  
        System.AssertEquals(0, response.searchFilters.size());
    }

    /*static testMethod void testMethodSeven(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        
        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response=uw_BETSearchService.search('',helper.testCategory.Id,'',3,1,false,true,'');
        }    

        System.AssertEquals('Bet1', response.betSearchResult[0].betName); 
    }*/

    static testMethod void testMethodEight(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,false,'');
        }    

        System.AssertEquals('Bet4', response.betSearchResult[0].betName); 
    }

    static testMethod void testMethodNine(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();
        User u = helper.testUser;

        /* one element per page. search with filters */
        uw_BETWrapper.SearchWrapper response;
        System.runAs(u){
            response=uw_BETSearchService.search('','','',4,1,false,true,'betName');
        }    

        System.AssertEquals('Bet1', response.betSearchResult[0].betName); 
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

        System.runAs(u){
            response=uw_BETSearchService.search('','','Bet1',1,1,false,true,'');
        }    

        System.AssertEquals(0, response.searchFilters.size());
    }
}