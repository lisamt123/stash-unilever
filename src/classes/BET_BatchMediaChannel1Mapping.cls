/**********************************************************************
Name: BET_BatchMediaChannel1Mapping
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to mapping media type/media channel 1 (Category) values for Assets
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           17/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchMediaChannel1Mapping implements Database.Batchable<uw_Asset__c>, Database.Stateful {
    private Map<String, String> brandsMapNames = new Map<String, String> {
           'Cause Related Marketing' => 'Other',
           'Digital OOH' => 'Other Digital',
           'Fees' => 'Other',
           'In Store' => 'In-Store',
           'Interactive TV' => 'TVC',
           'Online Display' => 'Other Digital',
           'Online Search' => 'Other Digital',
           'Online Video' => 'Other Digital',
           'Out of Home' => 'OOH',
           'PR & Event Sponsorship' => 'PR',
           'Print' => 'In-Store',
           'Production' => 'Other',
           'Reserve' => 'Other',
           'TV' => 'TVC'
          };
              
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: BatchableContext
    Returns: List of BETs
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<uw_Asset__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchMediaChannel1Mapping start invoked***');
        // LIMIT value below in SOQL is subject to how many assets we have in the Production system
        List<uw_Asset__c> assetList = [SELECT Id, Name, Media_Channel_1__c FROM uw_Asset__c LIMIT 20000];  
        return assetList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to reassign brands
    Parameters: Database.BatchableContext, list of BETs for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_Asset__c> scope){ 
        System.Debug('***BET_BatchMediaChannel1Mapping execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());
        
        List<uw_Asset__c> updateAssetList = new List<uw_Asset__c>();
        for (uw_Asset__c asset : scope) { 
           uw_Asset__c newAsset = new uw_Asset__c();
           newAsset.Id = asset.Id; 
           // Media Channel 1 is blank -  Returns true if the specified String is white space, empty (''), or null; otherwise, returns false. 
           if ( String.isBlank(asset.Media_Channel_1__c) ) {
                //System.Debug('ISBLANK: ' + asset.Media_Channel_1__c + ' ,ASSET NAME: ' + asset.Name);
                newAsset.Media_Type__c = null;
           }
           // Media Channel can be found in the mapping table
           else if ( brandsMapNames.containsKey(asset.Media_Channel_1__c)) {
                //uw_Asset__c newAsset = new uw_Asset__c();
                //newAsset.Id = asset.Id;
                //newAsset.Media_Channel_1__c = brandsMapNames.get(asset.Media_Channel_1__c);
                newAsset.Media_Type__c = brandsMapNames.get(asset.Media_Channel_1__c);
                //updateAssetList.add(newAsset);
           }
           else {
                newAsset.Media_Type__c = asset.Media_Channel_1__c;
           }
           updateAssetList.add(newAsset);
 
        }
        
        try {
            update updateAssetList;
        }
        catch ( Exception e ) {
              System.Debug('Update BET Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to reassign Brands
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***BET_BatchMediaChannel1Mapping finish invoked***');
       //### No finish operations
    }
}