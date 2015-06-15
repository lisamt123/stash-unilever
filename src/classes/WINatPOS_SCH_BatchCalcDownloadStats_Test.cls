/**********************************************************************
Name: WINatPOS_SCH_BatchCalcDownloadStats_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOS_SCH_BatchCalculateDownloadStats
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          03/10/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WINatPOS_SCH_BatchCalcDownloadStats_Test {
    public static string CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testScheduledJob(){
        // Create test data   
        WinatPOSBatchDownloadStats__c downloadStatsCustomSetting = new WinatPOSBatchDownloadStats__c();
        downloadStatsCustomSetting.Name = 'DownloadStatsConfig';
        downloadStatsCustomSetting.Last_Calculated_Download_Stats__c = null;
        insert downloadStatsCustomSetting;
    
        Test.startTest();
    
        // schedule the test job
        String jobId = System.schedule('Scheduled WINatPOS BatchCalculateDownloadStats Test', 
                                        CRON_EXP, new WINatPOS_SCH_BatchCalculateDownloadStats());
                                           
        // get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id =: jobId];
        
        Test.stopTest();
        
           // Verify the expressions are the same
        System.assertEquals(CRON_EXP,ct.CronExpression);
    
        // Verify the job has not run 
        System.assertEquals(0,ct.TimesTriggered);
    
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
    
    }   
}