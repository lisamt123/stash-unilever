/**********************************************************************
Name: BET_BatchBETStatusMapping
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to reassign categories for BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           08/01/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchBETStatusMapping implements Database.Batchable<uw_BET__c> {
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: BatchableContext
    Returns: List of BETs
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<uw_BET__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchBETStatusMapping start invoked***');
        List<uw_BET__c> betList = [SELECT Id, Name, Status__c, Inoplan_Project__c FROM uw_BET__c LIMIT 10000];
        return betList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to reassign brands
    Parameters: Database.BatchableContext, list of BETs for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_BET__c> scope){ 
        System.Debug('***BET_BatchBETStatusMapping execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());
        
        List<uw_BET__c> betList = new List<uw_BET__c>();
        for (uw_BET__c bet : scope) {   
            if ( bet.Status__c == 'In Studio' ) { 
                uw_BET__c newBET = new uw_BET__c();
                newBET.Id = bet.Id;
                newBET.Status__c = 'Unreleased';
                if (Test.isRunningTest() && bet.Name == 'scjh647cwfwi73g6fr') {
                    //force throwing exception by setting invalid id for a lookup field
                    newBET.Inoplan_Project__c = '005000000000001';
                }
                betList.add(newBET);
            }
        }


        try {
            update betList;
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
       System.Debug('***BET_BatchBETStatusMapping finish invoked***');
       //### No finish operations
    }
}