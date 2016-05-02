/**********************************************************************
Name: BET_BatchBrandMapping
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to reassign brands for BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           16/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchBrandMapping implements Database.Batchable<uw_BET__c>, Database.Stateful {
    private Map<String, String> brandsMapNames = new Map<String, String> {
            'Adolphs' => 'Adolph\'s',
            'Amaze' => 'Amaze (Foods)',
            'Baby' => 'Zwitsal',
            'Babycare' => 'Zwitsal',
            'Becel pro.activ' => 'Becel',
            'Bona' => 'Bona (HPC)',
            //'Brandcentre-testrecord' => 'Other',       - Not used, delete
            //'Brandcentre-testrecord2' => 'Other',      - Not used, delete
            'Café Zero' => 'Cafe Zero',
            'Calvé' => 'Calve',
            //'cB4L Resource' => 'Other',                - Manual change
            //'Cebralín' => 'CebralÃ­n',                  - Keep as is
            //'Chef' => 'Other',                         - Not used, delete
            //'Clean & Care' => 'Other',                 - Not used, delete
            'Crème Bonjour' => 'Creme Bonjour',
            //'Cross-Brand' => 'Other',                  - Manual change, then delete
            'Dawn' => 'Dawn (HPC)',
            'Dirt is Good' => 'Omo',
            'Everyman' => 'Wheel (HPC)',
            'Family Goodness' => 'Rama',
            'Family Health Brand' => 'Signal',
            'Fleischmann\'s' => 'Fleischmanns',
            'Healthy Heart' => 'Becel',
            'Hellmann\'s' => 'Hellmanns',
            //'I/B/F' => 'Other',                        - Not used, delete
            'Jif' => 'Jif (Foods)',
            'Knorrox' => 'Knorr Knorrox',
            //'Kookos' => 'Other',                       - Not used, delete
            'Lipton' => 'Lipton Tea',
            'Lipton International' => 'Lipton Tea',
            'Naturas' => 'Natura\'s',
            'O\'Hoy' => 'O\'Hoj',
            //'Other Foods' => 'Other',                  - Not used, delete
            //'Other HPC' => 'Other',                    - Not used, delete
            //'Other Sara Lee' => 'Other',               - Not used, delete
            'Pepperami' => 'Peperami',
            //'Perfect Store 2.0' => 'Other',            - Not used, delete
            //'Physka' => 'Other',                       - Not used, delete    
            'Ragu / Raguletto' => 'Ragu',
            //'Rasch' => 'Other',                        - Not used, delete
            //'Rexona PW' => 'Rexona',                   - Not used, delete
            'Smart Choice' => 'Geisha',
            'Solo' => 'Solo (Foods)',
            //'Special Benefit' => 'Other',              - Not used, delete
            //'Sunil Value' => 'Other',                  - Not used, delete
            //'Sunlight Skin' => 'Other',                - Not used, delete
            //'Test Brand' => 'Other',                   - Not used, delete
            //'Top Performance' => 'Other',              - Not used, delete
            'TRESemmé' => 'TRESemme',
            'Unilever' => 'Unilever Brand',
            'Wall\'s' => 'Walls',
            'Zhonghua' => 'Zhong Hua'
          };
              
    private Map<Id, Id> brandsMapIds = new Map<Id, Id>();
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: BatchableContext
    Returns: List of BETs
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<uw_BET__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchBrandMapping start invoked***');
        populateBrandsMapIds();
        List<uw_BET__c> betList = [SELECT Id, Name, uw_Brand__c, uw_Brand__r.Name FROM uw_BET__c LIMIT 10000];
        return betList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to reassign brands
    Parameters: Database.BatchableContext, list of BETs for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_BET__c> scope){ 
        System.Debug('***BET_BatchBrandMapping execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());
        
        List<uw_BET__c> betList = new List<uw_BET__c>();
        for (uw_BET__c bet : scope) {    
            if ( brandsMapIds.containsKey(bet.uw_Brand__c) == true ) {
                uw_BET__c newBET = new uw_BET__c();
                newBET.Id = bet.Id;
                newBET.uw_Brand__c = brandsMapIds.get(bet.uw_Brand__c);
                betList.add(newBET);
                System.Debug('BET ID TO UPDATE: ' + bet.Id + '. BET NAME TO UPDATE: ' + bet.Name);
                System.Debug('OLD BRAND Id: ' + bet.uw_Brand__c + '. NEW BRAND Id: ' + newBET.uw_Brand__c );
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
       System.Debug('***BET_BatchBrandMapping finish invoked***');
       //### No finish operations
    }
    
    void populateBrandsMapIds() { 
        Map<String, Id> oldBrandNameIdMap = new Map<String, Id>();
        Map<String, Id> newBrandNameIdMap = new Map<String, Id>();

        
        List<uw_Brand__c> oldBrandList = [SELECT Id, Name FROM uw_Brand__c WHERE Name = :brandsMapNames.keySet()];
        List<uw_Brand__c> newBrandList = [SELECT Id, Name  FROM uw_Brand__c WHERE Name = :brandsMapNames.values()];
        // Convert List<Brand> into Map<BradName, Id>
        for (uw_Brand__c brand : oldBrandList) {
            oldBrandNameIdMap.put(brand.Name, brand.Id);
        }
        
        // Convert List<Brand> into Map<BradName, Id>
        for (uw_Brand__c brand : newBrandList) {
            newBrandNameIdMap.put(brand.Name, brand.Id);
        }
        
        for (uw_Brand__c brand : oldBrandList ) {
            String oldName = brand.Name;
            String newName = brandsMapNames.get(brand.Name);
            System.Debug('OLD BRAND NAME: ' + oldName);
            System.Debug('NEW BRAND NAME: ' + newName);
            
            Id oldId = oldBrandNameIdMap.get(oldName);
            Id newId = newBrandNameIdMap.get(newName);
            System.Debug('OLD BRAND ID: ' + oldId);
            System.Debug('NEW BRAND ID: ' + newId);
            
            brandsMapIds.put(oldId, newId);
        }
        
        for ( Id oldBrandId : brandsMapIds.keySet()) {
             Id newBrandId = brandsMapIds.get(oldBrandId);
             System.Debug('OldId: ' + oldBrandId + ', NewId: ' + newBrandId);       
        }   
    }
}