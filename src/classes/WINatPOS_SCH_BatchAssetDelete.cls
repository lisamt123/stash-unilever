/**********************************************************************
Name: WINatPOS_SCH_BatchAssetDelete
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to schedule batch Apex to delete assets
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           17/09/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WINatPOS_SCH_BatchAssetDelete implements Schedulable {
    //public static String cron_expression = '0 0 0 * * ?';  // Every day, midnight 

    //global static String scheduleBatchJob() { 
    //    return System.schedule('Scheduled Job to Delete WINatPOS Assets', cron_expression, new WINatPOS_SCH_BatchAssetDelete());
    //}
       
    /*******************************************************************
    Purpose: Method to execute a scheduled Apex class for batch asset delete
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(SchedulableContext SC) {
        System.Debug('***WINatPOS_SCH_BatchAssetDelete invoked***');
        WINatPOSBatchAssetDelete batchDelete = new WINatPOSBatchAssetDelete();
        Database.executeBatch(batchDelete, 200);
    }
}