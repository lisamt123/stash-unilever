/**********************************************************************
Name: WINatPOS_SCH_PurgeStats_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOS_SCH_PurgeStats
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          18/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WINatPOS_SCH_PurgeStats_Test {     
    public static string CRON_EXP = '0 0 0 15 3 ? 2022';

  /*******************************************************************
    Purpose: Method to test scheduling Apex class for purging stats
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void testScheduledJob(){
        // create test data for custom settings
        WinatPOSPurgeStatistics__c purgeStatsCustomSettings = new WinatPOSPurgeStatistics__c();
        purgeStatsCustomSettings.Name = 'PurgeConfig';
        purgeStatsCustomSettings.Search_Statistics__c = 180;
        purgeStatsCustomSettings.Download_Statistics__c = 365;
        insert purgeStatsCustomSettings;
        
        Test.startTest();
    
        // schedule the test job
        String jobId = System.schedule('Scheduled Job to Purge WINatPOS stats', 
                                        CRON_EXP, new WINatPOS_SCH_PurgeStats());  
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