/*
  Class Name: BEN_EmailRemainderSchedularTest
  Author : Mindtree
  Date: 5 Jan 2017
  Requirement/Project Name: SF Benchmarking
  Requirement/Description: This TestClass will cover BEN_EmailRemainderSchedular Apex class
**************************************************************************************************************************
*/ 

@isTest
private class BEN_EmailRemainderSchedularTest{

   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   static testmethod void scheduletest() {
      Test.startTest();

      String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new BEN_EmailRemainderSchedular());
         
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
      System.assertEquals(CRON_EXP, ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);
      System.assertEquals('2022-03-15 00:00:00',String.valueOf(ct.NextFireTime));
      
      Test.stopTest();

   }
}