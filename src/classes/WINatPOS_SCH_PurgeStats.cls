/**********************************************************************
Name: WINatPOS_SCH_PurgeStats
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to schedule batch Apex to purge statistics
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           18/09/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WINatPOS_SCH_PurgeStats implements Schedulable {
    //public static String cron_expression = '0 0 0 * * ?';  // Every day, midnight 

    //global static String scheduleBatchJob() { 
    //    return System.schedule('Scheduled Job to purge WINatPOS statistical records', cron_expression, new WINatPOS_SCH_PurgeStats());
    //}
       
    /*******************************************************************
    Purpose: Method to execute a scheduled Apex class to purge stats
    Parameters: SchedulableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(SchedulableContext SC) {
        System.Debug('***WINatPOS_SCH_PurgeStats invoked***');
        WinatPOSPurgeStatistics__c purgeStatsCustomSettings = WinatPOSPurgeStatistics__c.getValues('PurgeConfig');
        
        System.Debug('*** Download Stats days: ' + Integer.ValueOf(purgeStatsCustomSettings.Download_Statistics__c));
        System.Debug('*** Search Stats days: ' + Integer.ValueOf(purgeStatsCustomSettings.Search_Statistics__c));
               
        WINatPOSPurgeStats batchPurge = new WINatPOSPurgeStats('Download_Statistics__c', 'Timestamp__c', Integer.ValueOf(purgeStatsCustomSettings.Download_Statistics__c));
        Database.executeBatch(batchPurge, 200);
        
        batchPurge = new WINatPOSPurgeStats('Search_Statistics__c', 'Timestamp__c', Integer.ValueOf(purgeStatsCustomSettings.Search_Statistics__c));
        Database.executeBatch(batchPurge, 200);
    }
}