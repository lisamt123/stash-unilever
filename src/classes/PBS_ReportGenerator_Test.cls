/* As is it not possible to create Reports using apex, we are giving @isTest(SeeAllData='true')
*Let us know if you have any other suggestions.
*/

@isTest
private class PBS_ReportGenerator_Test {
    
 @isTest(SeeAllData='true')
    static void testCrsStatusReport(){
        Test.startTest();
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
        Test.stopTest();
        system.assert(reportgeneratorObj != null);
    }
}