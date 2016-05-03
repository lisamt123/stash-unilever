/**********************************************************************
Name: BET_BatchScheduler
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: test class for BET_BatchScheduler
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             08/12/2014      INITIAL DEVELOPMENT
**********************************************************************/
@IsTest public with sharing class BET_BatchScheduler_Test {
	static testMethod void test(){
		Test.startTest();
		
      	BET_BatchScheduler s = new BET_BatchScheduler();
		string sch = '0 0 1 * * ?';
		String jobId = system.schedule('First/Final Release date mail info'+System.now().millisecond(),sch,s);

		// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      	System.assertEquals(sch, ct.CronExpression,'Expressions must match');

      	System.assertEquals(0, ct.TimesTriggered,'Cron should not be triggered');

	    Test.stopTest(); 	
	} 
}