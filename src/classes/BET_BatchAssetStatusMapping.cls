/**********************************************************************
Name: BET_BatchAssetStatusMapping
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to map Asset status for BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           17/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchAssetStatusMapping implements Database.Batchable<uw_Asset__c> {
    
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: BatchableContext
    Returns: List of BETs
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<uw_Asset__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchAssetStatusMapping start invoked***');
        // LIMIT value below in SOQL is subject to how many assets we have in the Production system
        // Work In Progress and Blank values have to be mapped to Draft
        //List<uw_Asset__c> assetList = [SELECT Id, Name, Status__c FROM uw_Asset__c WHERE Status__c = 'Work In Progress' OR Status__c = '' LIMIT 20000];
        List<uw_Asset__c> assetList = [SELECT Id, Name, Status__c, Studio_Asset_Type__c FROM uw_Asset__c LIMIT 20000];  
        return assetList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to reassign brands
    Parameters: Database.BatchableContext, list of BETs for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_Asset__c> scope){ 
        System.Debug('***BET_BatchAssetStatusMapping execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());
        
        List<uw_Asset__c> updateAssetList = new List<uw_Asset__c>();
        for (uw_Asset__c asset : scope) {    
             uw_Asset__c newAsset = new  uw_Asset__c();
             newAsset.Id = asset.Id;
             //if ( String.isBlank(asset.Status__c) || asset.Status__c == 'Work In Progress' ) {
             //     newAsset.Status__c = 'Draft';
             //}
             //if ( asset.Status__c == 'Final' ) {
             //     newAsset.Status__c = 'Approved';
             //}
             
             if ( asset.Status__c == 'Final' ) {
                  newAsset.Status__c = 'Approved';
             }
             else {
                  newAsset.Status__c = 'Draft';
             }

             if ( asset.Studio_Asset_Type__c == 'Document' ) {
                  newAsset.Studio_Asset_Type__c = 'Creative Work';
             }
             if (Test.isRunningTest() && asset.Name == 'Test Asset') {
                //force throwing exception by setting invalid id for a lookup field
                newAsset.Agency__c = '005000000000001';
             }
             //newAsset.Status__c = 'Draft';
             updateAssetList.add(newAsset);
        }
         
        try {
            update updateAssetList;
        }
        catch ( Exception e ) {
              System.Debug('Update Asset Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to reassign Brands
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***BET_BatchMediaChannel2Mapping finish invoked***');
       //### No finish operations
    }
}