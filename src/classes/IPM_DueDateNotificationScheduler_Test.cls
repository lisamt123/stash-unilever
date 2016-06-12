/**
   @Author: Cognizant
   @name : IPM_DueDateNotificationScheduler_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_DueDateNotificationScheduler
   @Version <1.0>
   @reference 
 */
 
@isTest
private with sharing class IPM_DueDateNotificationScheduler_Test {

private static final String  FEED_UPDATED_ASSERT = 'Feed Not Updated';
    
  private static testMethod void dueDateTestMethod() {
    
          String CRON_EXP = '0 0 0 15 3 ? 2022'; 
          Test.startTest();
          // Schedule the test job
          String jobId = System.schedule('Test Due Date Batch', CRON_EXP, new IPM_DueDateNotificationScheduler());
             
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
    
          // Verify the expressions are the same
          System.assertEquals(CRON_EXP, ct.CronExpression, 'Time not matched');
    
          // Verify the job has not run
          System.assertEquals(0, ct.TimesTriggered, 'TriggeredTime not matched');
    
          // Verify the scheduled job hasn't run yet.
          for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed limit 50000]){
            System.assert(!projectFeed.Body.contains(IPM_ConstantUtils.GATE_APPROVAL_DATE),FEED_UPDATED_ASSERT);
          }
            Test.StopTest();
            
          //Now that the scheduled job has executed after Test.stopTest(),
          // Verify the scheduled job has run now
          for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed limit 50000]){
          	//The chatter will be posted when the batch is run
            System.assert(projectFeed.Body.contains(IPM_ConstantUtils.GATE_APPROVAL_DATE),FEED_UPDATED_ASSERT);
          }
    }
}