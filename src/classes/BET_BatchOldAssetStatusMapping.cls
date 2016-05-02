/**********************************************************************
Name: BET_BatchOldAssetStatusMapping
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to map Asset status for BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          30/01/2015      INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchOldAssetStatusMapping implements Database.Batchable<sObject> {
    
    /*******************************************************************
    Purpose: Method to generate the list of assets to be updated
    Parameters: BatchableContext
    Returns: List of assets
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Database.QueryLocator start(Database.batchableContext BC){
        System.Debug('***BET_BatchOldAssetStatusMapping start invoked***');
        String query = 'SELECT Id, Status__c FROM uw_Asset__c'
        + ' WHERE sub_function__c = null AND Status__c = \'Approved\' AND Promoted__c = false';
        return Database.getQueryLocator(query); 
    }

    /*******************************************************************
    Purpose: Method to execute a batch Apex process to update asset status
    Parameters: Database.BatchableContext, list of assets for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_Asset__c> scope){ 
        System.Debug('***BET_BatchOldAssetStatusMapping execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());
        
        for (uw_Asset__c asset : scope) {    
            asset.Status__c = 'Draft';
            if (Test.isRunningTest() && asset.Name == 'Test Asset') {
                //force throwing exception by setting invalid id for a lookup field
                asset.Agency__c = '005000000000001';
             }
        }
         
        try {
            update scope;
        }
        catch ( Exception e ) {
              System.Debug('Update Asset Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to update assets
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***BET_BatchOldAssetStatusMapping finish invoked***');
       //### No finish operations
    }
}