/* As is it not possible to create Reports using apex, we are giving @isTest(SeeAllData='true')
*Let us know if you have any other suggestions.
*/

@isTest
private class PBS_CourseStatusInDtlReport_Test {
    
  static testMethod void testgetUserNames(){
      PBS_CourseStatsInDetailReport_CC CoursinDetlObj = new PBS_CourseStatsInDetailReport_CC();
        PBS_Standard_Job_Profile__c jobprofile = new PBS_Standard_Job_Profile__c();
       PBS_Profile__c userName = new PBS_Profile__c();
    Test.startTest();
        jobprofile.Name='Dummy Role';
        insert jobprofile;
        userName.User__c=UserInfo.getUserId();
        List<PBS_Standard_Job_Profile__c> jobProfileList = [SELECT id FROM PBS_Standard_Job_Profile__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        for(PBS_Standard_Job_Profile__c jobprof : jobProfileList ){
        userName.user_role__c = jobprof.id;}
        insert userName;
        System.assert(CoursinDetlObj.getUserNames().size()>0);
    Test.stopTest();
 }
    @isTest(SeeAllData='true')
    static void testGenerateDetlRprt(){
     PBS_CourseStatsInDetailReport_CC courseindetlrptObj = new PBS_CourseStatsInDetailReport_CC();
     Pagereference pageref = null;
    Test.startTest();
     pageref = courseindetlrptObj.gnertCrseStusInDtlRprt();
     System.assert(pageref!= null);
    Test.stopTest();
  }
     
}