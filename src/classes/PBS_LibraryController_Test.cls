@isTest
private class PBS_LibraryController_Test {

    @isTest static void noDataTest()
    {
        Test.startTest();

        PBS_LibraryController_CC pbsLibrary = new PBS_LibraryController_CC();
        System.assertNotEquals(null, pbsLibrary.language, 'Language should not be empty');

        System.assertEquals(1, pbsLibrary.getCurrentPageNumber(), 'Page should be 1');
        System.assertEquals(false, pbsLibrary.getHasNext(), 'There should be no next page');
        System.assertEquals(false, pbsLibrary.getHasPrevious(), 'There should be no previous page');

        System.assertEquals(true, pbsLibrary.pbsKnowledgeArticleList().isEmpty(), 'There should be no articles');
        System.assertEquals(1, pbsLibrary.getNumberOfPages(), 'There should be exaclty 1 page');

        pbsLibrary.next();
        System.assertEquals(1, pbsLibrary.getCurrentPageNumber(), 'Page should be 1');

        pbsLibrary.previous();
        System.assertEquals(1, pbsLibrary.getCurrentPageNumber(), 'Page should be 1');

        pbsLibrary.sortData();
        System.assertEquals(1, pbsLibrary.getCurrentPageNumber(), 'Page should be one');

        pbsLibrary.sortField = 'invalid field';
        System.assertEquals('Title', pbsLibrary.sortField, 'Sort field should be reset to title when provided name is invalid');

        pbsLibrary.sortField = 'Summary';
        System.assertEquals('Summary', pbsLibrary.sortField, 'Sort field should be Summary');

        pbsLibrary.sortDir = 'invalid';
        System.assertEquals('ASC', pbsLibrary.sortDir, 'Sort dir should be ASC as value provided was invalid');

        pbsLibrary.sortDir = 'DESC';
        System.assertEquals('DESC', pbsLibrary.sortDir, 'Sort dir should be DESC');

        pbsLibrary.filterArticleType = 'invalid';
        System.assertEquals('', pbsLibrary.filterArticleType, 'Fallback to all on invalid article type did not work');

        pbsLibrary.filterArticleType = 'PBS_FAQ_s__kav';
        System.assertEquals('PBS_FAQ_s__kav', pbsLibrary.filterArticleType, 'Article type filter should be PBS_FAQ_s__kav');

        Test.stopTest();
    }

    @isTest static void withDataTest() {
        Integer noOfElements = 15;
        PBS_Wiki__kav votedObj;
        List<Vote> votes     = new List<Vote>();
        for(integer i = 0; i < noOfElements; i++) {
            votedObj = PC_DataFactory.createWikiPage('test' + i, 'test summary ' + i, null, 'Content ' + i, null, true, true);
            votes.add(
                new Vote(
                    ParentId = votedObj.KnowledgeArticleId,
                    Type     = '5'
                )
            );
        }
        insert votes;

        Test.startTest();

        PBS_LibraryController_CC pbsLibrary = new PBS_LibraryController_CC();

        System.assertEquals(1, pbsLibrary.getCurrentPageNumber(), 'Page should be one');
        System.assertEquals(true, pbsLibrary.getHasNext(), 'There should be next page');
        System.assertEquals(false, pbsLibrary.getHasPrevious(), 'There should be no previous page');

        System.assertEquals(false, pbsLibrary.pbsKnowledgeArticleList().isEmpty(), 'There should be articles');
        System.assertEquals(2, pbsLibrary.getNumberOfPages(), 'Pages count is different then expected');

        pbsLibrary.next();
        System.assertEquals(2, pbsLibrary.getCurrentPageNumber(), 'Page should be 2');
        System.assertEquals(5 /* 15 created - 10 as second page */, pbsLibrary.pbsKnowledgeArticleList().size(), 'There should be 5 articles');
        System.assertEquals(true, pbsLibrary.getHasPrevious(), 'There should be previous page');

        pbsLibrary.previous();
        System.assertEquals(1, pbsLibrary.getCurrentPageNumber(), 'Page should be one');

        Test.stopTest();
    }

    @isTest static void articleTypeFilter() {
        PC_DataFactory.createWikiPage('test wiki', 'test summary ', null, 'Content ', null, true, true);
        PC_DataFactory.createFaqPage('test faq', 'test summary', '', '', null, true, true);

        Test.startTest();

        PBS_LibraryController_CC pbsLibrary = new PBS_LibraryController_CC();

        System.assertEquals(2, pbsLibrary.pbsKnowledgeArticleList().size(), 'There should be 2 articles');

        pbsLibrary.filterArticleType = 'PBS_FAQ_s__kav';
        System.assertEquals(1, pbsLibrary.pbsKnowledgeArticleList().size(), 'There should be 1 article');
        System.assertEquals(pbsLibrary.filterArticleType, pbsLibrary.pbsKnowledgeArticleList().get(0).ArticleType, 'Article type should match filter');

        pbsLibrary.filterArticleType = '';
        System.assertEquals(2, pbsLibrary.pbsKnowledgeArticleList().size(), 'There should be 2 articles');

        pbsLibrary.filterArticleType = 'PBS_Wiki__kav';
        System.assertEquals(1, pbsLibrary.pbsKnowledgeArticleList().size(), 'There should be 1 article');
        System.assertEquals(pbsLibrary.filterArticleType, pbsLibrary.pbsKnowledgeArticleList().get(0).ArticleType, 'Article type should match filter');
        
        pbsLibrary.searchstring = 'test wiki';
        pbsLibrary.getPbsArticleSearchList();
        
        Test.stopTest();
    }

    @isTest static void getArticleTypeFilterOptions() {
        Test.startTest();

        PBS_LibraryController_CC pbsLibrary = new PBS_LibraryController_CC();
        System.assertEquals(3, pbsLibrary.getArticleTypeFilterOptions().size(), 'There should be 3 options to choose from');

        Test.stopTest();
    }

}