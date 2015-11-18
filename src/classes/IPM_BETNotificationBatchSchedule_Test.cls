@isTest
public with sharing class IPM_BETNotificationBatchSchedule_Test {

private static final String  FEED_UPDATED_ASSERT = 'Feed Updated';

  public static testMethod void betTestMethod() {
     
      String CRON_EXP = '0 0 0 15 3 ? 2022'; 
      Test.startTest();
      // Schedule the test job
      String jobId = System.schedule('Test BET Due Date Batch', CRON_EXP, new IPM_BETDueDateNotificationBatchScheduler());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, ct.CronExpression,'expressions are not same'+ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered,'job already run');

      // Verify the scheduled job hasn't run yet.
      for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed limit 50000]){
        System.assert(!projectFeed.Body.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),FEED_UPDATED_ASSERT);
      }
      Test.stopTest();

  }
  
}