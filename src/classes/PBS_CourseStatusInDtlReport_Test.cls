@isTest
private class PBS_CourseStatusInDtlReport_Test {
    
  static testMethod void testgetUserNames(){
      PBS_CourseStatsInDetailReport_CC CoursinDetlObj = new PBS_CourseStatsInDetailReport_CC();
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
        System.assert(CoursinDetlObj.getUserNames().size()>0);
    Test.stopTest();
 }
    @isTest(SeeAllData='true')
    static void testGenerateDetlRprt(){
     PBS_CourseStatsInDetailReport_CC courseindetlrptObj = new PBS_CourseStatsInDetailReport_CC();
     Pagereference pageref;
    Test.startTest();
     pageref = courseindetlrptObj.gnertCrseStusInDtlRprt();
     System.assert(pageref!= null);
    Test.stopTest();
  }
     
}