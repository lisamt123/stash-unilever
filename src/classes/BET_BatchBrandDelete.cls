/**********************************************************************
Name: BET_BatchBrandDelete
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to delete unnecessary brands for BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           17/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchBrandDelete implements Database.Batchable<uw_Brand__c> {
      private List<String> brandsToDelete = new List<String> {
               'Adolphs', 'Amaze', 'Baby', 'Babycare',  'Becel pro.activ',  'Bona', 
               'Brandcentre-testrecord', 'Brandcentre-testrecord2', 'Café Zero',  'Calvé', 
               'Chef', 'Clean & Care','Crème Bonjour',  'Dawn', 'Dirt is Good', 'Everyman',
               'Family Goodness', 'Family Health Brand', 'Fleischmann\'s', 'Healthy Heart',
               'Hellmann\'s', 'I/B/F', 'Jif', 'Knorrox',
               'Kookos',  'Lipton',  'Lipton International', 'Naturas', 'O\'Hoy',
               'Other Foods', 'Other HPC', 'Other Sara Lee',  'Pepperami','Perfect Store 2.0',
               'Physka', 'Ragu / Raguletto', 'Rasch', 'Rexona PW', 
               'Smart Choice', 'Solo', 'Special Benefit', 'Sunil Value', 'Sunlight Skin', 
               'Test Brand', 'Top Performance', 'TRESemmé',  'Unilever',  'Wall\'s',  'Zhonghua'
      };
    
    /*******************************************************************
    Purpose: Method to generate the list of brands to be deleted
    Parameters: BatchableContext
    Returns: List of Brands
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<uw_Brand__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchBrandDelete start invoked***');
        List<uw_Brand__c> brandList = [SELECT Id, Name  FROM  uw_Brand__c WHERE Name = :brandsToDelete  LIMIT 10000];
        return brandList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to reassign brands
    Parameters: Database.BatchableContext, list of BETs for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_Brand__c> scope){ 
        System.Debug('***BET_BatchBrandMapping execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());

        for (uw_Brand__c brand : scope) {    
            System.Debug('Brand ID: ' + brand.Id + ', Brand Name: ' + brand.Name);
        }
        
        // Force DML Exception for Delete operation
        if ( Test.isRunningTest() ) {
           List<uw_Brand__c> dummyBrandList = [SELECT Id, Name FROM uw_Brand__c WHERE Name = 'Test Brand' LIMIT 1];
           if ( dummyBrandList.size() != 0 ) {
               delete dummyBrandList[0];
           }
        }
        
        try {
            delete scope;
        }
        catch ( Exception e ) {
              System.Debug('Delete Brand Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to reassign Brands
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('BET_BatchBrandDelete ***finish invoked***');
       //### No finish operations
    }
}