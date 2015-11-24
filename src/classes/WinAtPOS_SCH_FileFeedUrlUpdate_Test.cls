/**********************************************************************
Name: WinAtPOS_SCH_FileFeedUrlUpdate_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WinAtPOS_SCH_FileFeedUrlUpdate
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          02/12/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WinAtPOS_SCH_FileFeedUrlUpdate_Test {
	public static string CRON_EXP = '0 0 * * * ?';
    
    static testmethod void testScheduledJob(){
        Test.startTest();
    
        // schedule the test job
        String jobId = System.schedule('Scheduled WINatPOS WinAtPOS_SCH_FileFeedUrlUpdate Test', 
                                        CRON_EXP, new WinAtPOS_SCH_FileFeedUrlUpdate());
                                           
        // get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id =: jobId];
        
        Test.stopTest();
        
           // Verify the expressions are the same
        System.assertEquals(CRON_EXP,ct.CronExpression);
    
    }
}