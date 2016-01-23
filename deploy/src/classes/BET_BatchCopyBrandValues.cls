/**********************************************************************
Name: BET_BatchCopyBrandValues
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to migrate brand values from source brand to the new brands 
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           16/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchCopyBrandValues implements Database.Batchable<uw_Brand__c>, Database.Stateful {
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
    global Iterable<uw_Brand__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchCopyBrandValues start invoked***');
        populateBrandsMapIds();
        List<uw_Brand__c> oldBrandList = [SELECT Id, Name, Background_Colour__c, Banner_Colour__c, Banner_Location__c, Border_Colour__c, Brand_Logo_Image_Id__C, Component_Colour__c, Font_Colour__c  FROM uw_Brand__c WHERE Name = :brandsMapNames.keySet() LIMIT 10000];
        return oldBrandList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to reassign brands
    Parameters: Database.BatchableContext, list of BETs for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_Brand__c> scope){ 
        System.Debug('***BET_BatchCopyBrandValues execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());
        
        List<uw_Brand__c> newBrandList = new List<uw_Brand__c>();
        for ( uw_Brand__c brand : scope ) {
             uw_Brand__c newBrand = new uw_Brand__c();
             if ( brand.Background_Colour__c != null ) {
                  newBrand.Background_Colour__c = brand.Background_Colour__c;
             }
             if ( brand.Banner_Colour__c != null ) {
                  newBrand.Banner_Colour__c = brand.Banner_Colour__c;
             }
             if ( brand.Banner_Location__c != null ) {
                  newBrand.Banner_Location__c = brand.Banner_Location__c;
             }
             if ( brand.Border_Colour__c != null ) {
                  newBrand.Border_Colour__c = brand.Border_Colour__c;
             }
             if ( brand.Brand_Logo_Image_Id__c != null ) {
                  newBrand.Brand_Logo_Image_Id__c = brand.Brand_Logo_Image_Id__c;
             }
             if ( brand.Component_Colour__c != null ) {
                  newBrand.Component_Colour__c = brand.Component_Colour__c;
             }
             if ( brand.Font_Colour__c != null ) {
                  newBrand.Font_Colour__c = brand.Font_Colour__c;
             }
             if ( brand.Background_Colour__c != null || 
                  brand.Banner_Colour__c != null ||
                  brand.Banner_Location__c != null || 
                  brand.Border_Colour__c != null ||
                  brand.Brand_Logo_Image_Id__c != null || 
                  brand.Component_Colour__c != null  || 
                  brand.Font_Colour__c != null ) {
                  newBrand.Id = brandsMapIds.get(brand.Id);
                  System.Debug('Old Id: ' + brand.Id + ', Old Name: ' + brand.Name + ', New Id: ' + newBrand.Id);
                  newBrandList.add(newBrand);
             }
       }
        
       System.Debug('NEW BRANDLIST SIZE: ' + newBrandList.size());
        
       for ( uw_Brand__c b : newBrandList ) {
              System.Debug('Id: ' + b.Id + ', Name: ' + b.Name + ',Background_Colour: ' + b.Background_Colour__c + ',Banner_Colour: ' + b.Banner_Colour__c);
              System.Debug('Banner_Location: ' + b.Banner_Location__c + ',Border_Colour : ' + b.Border_Colour__c + ',Brand_Logo_Image_Id: ' + b.Brand_Logo_Image_Id__c); 
              System.Debug('Component_Colour: ' + b.Component_Colour__c + ', :Font_Colour__c ' + b.Font_Colour__c);                  
       }          

        
        try {
            update newBrandList;
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
       System.Debug('***BET_BatchCopyBrandValues finish invoked***');
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