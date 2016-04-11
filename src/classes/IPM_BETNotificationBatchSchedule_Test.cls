/**
   @Author: Cognizant
   @name : IPM_BETNotificationBatchSchedule_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_BETNotificationBatchScheduler
   @Version <1.0>
   @reference 
 */
  
@isTest
private with sharing class IPM_BETNotificationBatchSchedule_Test {

private static final String  FEED_NOT_UPDATED_ASSERT = 'Feed not Updated';

  private static testMethod void betTestMethod() {
     
      String CRON_EXP = '0 0 0 15 3 ? 2022'; 
      Test.startTest();
      // Schedule the test job
      String jobId = System.schedule('Test BET Due Date Batch', CRON_EXP, new IPM_BETDueDateNotificationBatchScheduler());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, ct.CronExpression,'Expressions are not same'+ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered,'Job has not run');

      // Verify the scheduled job hasn't run yet.
      for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed limit 50000]){
        System.assert(!projectFeed.Body.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),FEED_NOT_UPDATED_ASSERT);
      }
      Test.stopTest();
      
       // Now that the scheduled job has executed after Test.stopTest(),
        //Verify the scheduled job has run now.
      for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed limit 50000]){
        System.assert(projectFeed.Body.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),FEED_NOT_UPDATED_ASSERT);
      }

  }
  
}