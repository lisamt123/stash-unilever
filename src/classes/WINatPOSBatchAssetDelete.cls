/**********************************************************************
Name: WINatPOSBatchAssetDelete
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to delete assets
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           17/09/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WINatPOSBatchAssetDelete implements Database.Batchable<Asset__c>{
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: Void
    Returns: List of Assets
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<Asset__c> start(Database.batchableContext BC){
        System.Debug('***WINatPOSBatchAssetDelete start invoked***');
        String deleteStatus = System.Label.WinatPOS_Asset_Delete_Status;
        //List<Asset__c> assetList = [SELECT Id, Status__c, Scheduled_Delete_Date__c FROM Asset__c WHERE  Status__c = 'ToDelete' AND Scheduled_Delete_Date__c = TODAY];
        List<Asset__c> assetList = [SELECT Id, Status__c, Scheduled_Delete_Date__c FROM Asset__c WHERE  Status__c = :deleteStatus AND Scheduled_Delete_Date__c = TODAY];
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
        List<File__c> deleteFileList = new List<File__c>();
        List<Asset__c> deleteAssetList = new List<Asset__c>();
            
        for (Asset__c asset : scope) {
            // Cascading delete: delete all custom File records associated with the Asset record that is being deleted
            List<File__c> fileList = [SELECT Id, Name FROM File__c WHERE Asset__c = :asset.Id];
            for ( File__c file : fileList ) {
                deleteFileList.add(file);
            }
            deleteAssetList.add(asset);
        }
        
        // Force DML Exception for Delete operation
        if ( Test.isRunningTest() ) {
           List<Asset__c> dummyAssetList = [SELECT Id, Name FROM Asset__c WHERE Name = 'DummyAssetForDMLDeleteException' LIMIT 1];
           if ( dummyAssetList.size() != 0 ) {
               delete dummyAssetList[0];
               deleteAssetList.add(dummyAssetList[0]);
           }
        }
        
        try {
            delete deleteFileList;
            delete deleteAssetList;
        }
         catch ( Exception e ) {
              System.Debug('Delete File Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
        //try {
        //    delete deleteAssetList;
        //}
        // catch ( Exception e ) {
        //      System.Debug('Delete File Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        //}
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to delete assets
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***WINatPOSBatchAssetDelete finish invoked***');
       //### No finish operations
    }
}