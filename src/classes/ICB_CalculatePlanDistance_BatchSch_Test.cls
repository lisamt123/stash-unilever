/**********************************************************************
Name: ICB_CalculatePlanDistance_BatchSch_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: ICB_CalculatePlanDistance_BatchSchedule.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 12/06/2016  Class creation  
***********************************************************************/
@IsTest
public class ICB_CalculatePlanDistance_BatchSch_Test
{
	/********************************************************************
    Purpose: Test the Schedulable class ICB_CalculatePlanDistance_BatchSchedule
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    static testMethod void icb_CalculatePlanDistance_BatchSchedule_Test()
    {
        String cronExp = '0 0 0 15 12 ? 2050';
        
        System.Test.startTest();
        
        String jobId = System.schedule('ICB_CalculatePlanDistance_BatchSchedule', cronExp, new ICB_CalculatePlanDistance_BatchSchedule());
        
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id =: jobId];
        
        System.assertEquals(jobId, cronTrigger.Id);
        System.assertEquals(cronExp, cronTrigger.CronExpression);
        System.assertEquals(0, cronTrigger.TimesTriggered);
        System.assertEquals('2050-12-15 00:00:00', String.valueOf(CronTrigger.NextFireTime));
        
        System.Test.stopTest();
        
        
    } 
}