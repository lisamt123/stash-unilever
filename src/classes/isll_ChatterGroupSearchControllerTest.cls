@isTest
public class isll_ChatterGroupSearchControllerTest {

    static testMethod void testIsll_ChatterGroupSearchController()
    {
        // Create collaboration group
        insert isll_TestData.createChatterGroup('TestGroup'+math.roundtolong(math.random()*1000000));

        isll_ChatterGroupSearchController testCon = new isll_ChatterGroupSearchController();

        // Test search text validation
        testCon.searchGroups();

        system.assertEquals(
            null,
            testCon.chatterGroups,
            'Chatter Groups list should still be null'
        );

        // Now searhc something
        testCon.searchText = 'Test';
        testCon.searchGroups();

        system.assertEquals(
            1,
            testCon.resultsSize,
            'Search results should equal 1'
        );
    }
}