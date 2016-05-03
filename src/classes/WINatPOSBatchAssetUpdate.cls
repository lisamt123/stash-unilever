/**********************************************************************
Name: WINatPOSBatchAssetUpdate
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to delete assets
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           08/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WINatPOSBatchAssetUpdate implements Database.Batchable<Asset__c>{
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: Void
    Returns: List of Assets
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<Asset__c> start(Database.batchableContext BC){
        System.Debug('***WINatPOSBatchAssetUpdate start invoked***');
        List<Asset__c> assetList = [SELECT Id, Name FROM Asset__c LIMIT 10000];
        return assetList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to delete assets
    Parameters: Database.BatchableContext, list of assets for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<Asset__c> scope){ 
        System.Debug('***WINatPOSBatchAssetDelete execute invoked***'); 
        List<Asset__c> updateAssetList = new List<Asset__c>();
            
        for (Asset__c asset : scope) {
            updateAssetList.add(asset);
        }
        
       // Force DML Exception for Update operation
        if ( Test.isRunningTest() ) {
           List<Asset__c> dummyAssetList = [SELECT Id, Name FROM Asset__c WHERE Name = 'DummyAssetForDMLUpdateException' LIMIT 1];
           if ( dummyAssetList.size() != 0 ) {
               delete dummyAssetList[0];
           }
        }
        
        try {
            update updateAssetList;
        }
         catch ( Exception e ) {
              System.Debug('Update Asset Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to delete assets
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***WINatPOSBatchAssetUpdate finish invoked***');
       //### No finish operations
    }
}