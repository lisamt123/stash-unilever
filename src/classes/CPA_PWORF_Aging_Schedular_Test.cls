/**********************************************************************
Name: CPA_PWORF_Aging_Schedular_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the util class of rest of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Name      19/04/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class CPA_PWORF_Aging_Schedular_Test {
public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    /*******************************************************************
    Purpose: This method is used to cover Schedular
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
 ********************************************************************/    

   static testmethod void test() {
      Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new CPA_ScheduleBatchProrfAgeUpdate());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];
      Test.stopTest();
    System.assert(CRON_EXP == ct.CronExpression);
      System.assert(0 == ct.TimesTriggered);
      

   }
    
}