/* As is it not possible to create Reports using apex, we are giving @isTest(SeeAllData='true')
*Let us know if you have any other suggestions.
*/

@isTest
private class PBS_ReportGenerator_Test {
    
 @isTest(SeeAllData='true')
  static void testCrsStatusReport(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref = null;
    Test.startTest();
     pageref = reportgeneratorObj.generateCrsStatusReport();
     System.assert(pageref!= null);
    Test.stopTest();
  }
    @isTest(SeeAllData='true')
  static void testCrsStatsByUserRprt(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref = null;
    Test.startTest();
     pageref = reportgeneratorObj.generateCrsStatsByUserRprt();
     System.assert(pageref!= null);
    Test.stopTest();
  } 
    @isTest(SeeAllData='true')
  static void testCrsStatsByUserinDetl(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref = null;
    Test.startTest();
     pageref = reportgeneratorObj.generateCrsStatsByUserinDetl();
     System.assert(pageref!= null);
    Test.stopTest();
  }
  
     

}