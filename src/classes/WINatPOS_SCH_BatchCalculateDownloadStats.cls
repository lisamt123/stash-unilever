/**********************************************************************
Name: WINatPOS_SCH_BatchCalculateDownloadStats
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to schedule batch Apex to claculate download statistics
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          03/10/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WINatPOS_SCH_BatchCalculateDownloadStats implements Schedulable {

    //public static String cron_expression = '0 0 * * * ?';  // Every Day, every hour 

    //global static String scheduleBatchJob() { 
    //    return System.schedule('Scheduled Job to Calculate WINatPOS Download Stats', cron_expression, new WINatPOS_SCH_BatchCalculateDownloadStats());
    //}
       
    global void execute(SchedulableContext SC) {
        WINatPOSBatchCalculateDownloadStats batchCalc = new WINatPOSBatchCalculateDownloadStats();
        Database.executeBatch(batchCalc, 200);
    }
}