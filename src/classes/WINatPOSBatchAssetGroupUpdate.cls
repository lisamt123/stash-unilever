/**********************************************************************
Name: WINatPOSBatchAssetGroupUpdate
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

global class WINatPOSBatchAssetGroupUpdate implements Database.Batchable<Asset_Group__c>{
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: Void
    Returns: List of Assets
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<Asset_Group__c> start(Database.batchableContext BC){
        System.Debug('***WINatPOSBatchAssetUpdate start invoked***');
        List<Asset_Group__c> assetGroupList = [SELECT Id, Name FROM Asset_Group__c LIMIT 5000];
        return assetGroupList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to delete assets
    Parameters: Database.BatchableContext, list of assets for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<Asset_Group__c> scope){ 
        System.Debug('***WINatPOSBatchAssetDelete execute invoked***'); 
        List<Asset_Group__c> updateAssetGroupList = new List<Asset_Group__c>();
            
        for (Asset_Group__c assetGroup : scope) {
            updateAssetGroupList.add(assetGroup);
        }
        
       // Force DML Exception for Update operation
        if ( Test.isRunningTest() ) {
           List<Asset_Group__c> dummyAssetGroupList = [SELECT Id, Name FROM Asset_Group__c WHERE Name = 'DummyAssetGroupForDMLUpdateException' LIMIT 1];
           if ( dummyAssetGroupList.size() != 0 ) {
               delete dummyAssetGroupList[0];
           }
        }
        
        try {
            update updateAssetGroupList;
        }
         catch ( Exception e ) {
              System.Debug('Update AssetGroup Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to delete assets
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***WINatPOSBatchAssetGroupUpdate finish invoked***');
       //### No finish operations
    }
}