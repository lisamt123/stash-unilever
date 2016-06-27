@isTest
private class PBS_ReportGenerator_Test {
    
 @isTest(SeeAllData='true')
 public static void testCrsStatusReport(){
    PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
    Pagereference pageref;
    Test.startTest();
     pageref = reportgeneratorObj.generateCrsStatusReport();
     System.assert(pageref!= null);
    Test.stopTest();
  }
    @isTest(SeeAllData='true')
  public static void testTPlanAsgmntsRprt(){
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
    static testMethod void testgetUserNames(){
      PBS_ReportGenerator_CC reportgeneratorObj = new PBS_ReportGenerator_CC();
      List<SelectOption> nameList = new List<SelectOption>();
        PBS_Standard_Job_Profile__c jobprofile = new PBS_Standard_Job_Profile__c();
       PBS_Profile__c userName = new PBS_Profile__c();
    Test.startTest();
        jobprofile.Name='Dummy Role';
        insert jobprofile;
        userName.User__c=UserInfo.getUserId();
        for(PBS_Standard_Job_Profile__c jobprof : [SELECT id FROM PBS_Standard_Job_Profile__c]){
        userName.user_role__c = jobprof.id;}
        insert userName;
        System.assert(reportgeneratorObj.getUserNames().size()>0);
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