@isTest
private class PBS_ReportGenerator_Test {
    
 @isTest(SeeAllData='true')
  static void testCrsStatusReport(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref;
    Test.startTest();
     pageref = reportgeneratorObj.generateCrsStatusReport();
     System.assert(pageref!= null);
    Test.stopTest();
  }
    @isTest(SeeAllData='true')
   static void testTPlanAsgmntsRprt(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref;
    Test.startTest();
    pageref = reportgeneratorObj.gnrtTPlanAsgmntsWithUserDtlsRprt();
    System.assert(pageref!= null);
    Test.stopTest();
  }
    @isTest(SeeAllData='true')
  static void testCrsStatsByUserRprt(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref;
    Test.startTest();
     pageref = reportgeneratorObj.generateCrsStatsByUserRprt();
     System.assert(pageref!= null);
    Test.stopTest();
  } 
    @isTest(SeeAllData='true')
  static void testCrsStatsByUserinDetl(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref;
    Test.startTest();
     pageref = reportgeneratorObj.generateCrsStatsByUserinDetl();
     System.assert(pageref!= null);
    Test.stopTest();
  }
  
     @isTest(SeeAllData='true')
    static void testGenerateDetlRprt(){
     PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
     Pagereference pageref;
    Test.startTest();
     pageref = reportgeneratorObj.generateReport();
     System.assert(pageref!= null);
    Test.stopTest();
  }

}