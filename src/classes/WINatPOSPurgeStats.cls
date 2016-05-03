/**********************************************************************
Name: WINatPOSPurgeStats
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to delete statistics
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           18/09/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WINatPOSPurgeStats implements Database.Batchable<SObject>{
    String tableName;
    String columnName;
    Integer purgeDateRange;
 
    global WINatPOSPurgeStats(String table, String column, Integer days) {
        tableName = table;
        columnName = column;
        purgeDateRange = days;
        System.Debug('***WINatPOSPurgeStats tableName: ' + tableName);
        System.Debug('***WINatPOSPurgeStats columnName: ' + columnName);
        System.Debug('***WINatPOSPurgeStats purgeDateRange: ' + purgeDateRange);
        
    }
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: Void
    Returns: List of SObjects
    Throws [Exceptions]: [optional]
    ********************************************************************/
    //global Iterable<SObject>   
    global Database.QueryLocator start(Database.batchableContext BC){
        System.Debug('***WINatPOSPurgeStats start invoked***');
        String query = 'SELECT Id FROM ' + tableName + ' WHERE ' + columnName + ' != LAST_N_DAYS:' + String.ValueOf(purgeDateRange);
        System.Debug('WINatPOSPurgeStats query: ' + query);
        return Database.getQueryLocator(query);
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to delete stats
    Parameters: Database.BatchableContext, list of stats for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, List<SObject> scope){ 
        System.Debug('***WINatPOSPurgeStats execute invoked***');  
 
        // Force DML Exception for Delete operation
        if ( Test.isRunningTest() ) {          
           if ( scope.size() == 1 ) {
               delete scope[0];
           }
        }     
 
        try {
           delete scope;
        }
        catch ( Exception e ) {
              System.Debug('Delete Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to delete assets
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***WINatPOSPurgeStats finish invoked***');
       //### No finish operations
    }
}