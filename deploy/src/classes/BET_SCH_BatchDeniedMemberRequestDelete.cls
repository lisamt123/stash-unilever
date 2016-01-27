/**********************************************************************
Name: BET_SCH_BatchDeniedMemberRequestDelete
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

global class BET_SCH_BatchDeniedMemberRequestDelete implements Schedulable {
    //public static String cron_expression = '0 0 0 * * ?';  // Every day, midnight 

    //global static String scheduleBatchJob() { 
    //    return System.schedule('Scheduled Job to Delete BET Denied Member Requests', cron_expression, new BET_SCH_BatchDeniedMemberRequestDelete());
    //}
       
    /*******************************************************************
    Purpose: Method to execute a scheduled Apex class for batch denied member requests delete
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(SchedulableContext SC) {
        System.Debug('***BET_SCH_BatchDeniedMemberRequestDelete invoked***');
        BET_BatchDeniedMemberRequestDelete batchDelete = new BET_BatchDeniedMemberRequestDelete();
        Database.executeBatch(batchDelete, 200);
    }
}