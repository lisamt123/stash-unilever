/**********************************************************************
Name: BET_BatchCategoryMapping
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to reassign categories for BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           22/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchCategoryMapping implements Database.Batchable<uw_BET__c>, Database.Stateful {
    private Map<String, String> divisionsMapNames = new Map<String, String> {
            'Home Care excl Other Operations' => 'Home Care',
            'Personal Care excl Skin' => 'Personal Care',
            'Skin' => 'Personal Care',
            'Foods' => 'Food',
            'Refreshment' => 'Refreshment'
          };
          
    private Map<String, String> categoriesMapNames = new Map<String, String> {
            // 'Cooking Fats & Oils Category' => 'Delete',    -- Delete
            'Desserts Category' => 'Other Foods',
            'Dressings' => 'Dressings',
            //'Frozen Foods Category' => 'Delete',  -- Delete
            'Other Foods' => 'Other Foods',
            'Savoury' => 'Savoury',
            'Spreads' => 'Spreads',
            //'Vitality Shots Category' => 'Delete' -- Delete
            'Refreshment' => 'Refreshment',
            'Household Care' => 'Household Care',
            'Laundry' => 'Laundry',
            //'Non Corporate Home Care Category' => 'Delete' -- Delete
            'Deodorants & Fragrances' => 'Deodorants & Fragrances',
            'Hair Care' => 'Hair Care',
            //'Non Corporate Personal Care Cat' => 'Delete' -- Delete
            'Oral Care' => 'Oral Care',
            //'Prestige Legacy' => 'Delete' -- Delete
            'Skin Care' => 'Skin Care',
            'Skin Cleansing' => 'Skin Cleansing',
            'Coffee & Snacks' => 'Coffee & Snacks',
            'Ice Cream' => 'Ice Cream',
            'Tea and Soy & Fruit Beverages' => 'Tea and Soy & Fruit Beverages',
            'Water Purification Category' => 'Water Purification Category',
            'Weight Management' => 'Weight Management'
          };
              
    private Map<String, Id> categoriesMapIds = new Map<String, Id>();
    /*******************************************************************
    Purpose: Method to generate the list of assets to be deleted
    Parameters: BatchableContext
    Returns: List of BETs
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<uw_BET__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchCategoryMapping start invoked***');
        populateCategoriesMapIds();
        List<uw_BET__c> betList = [SELECT Id, Name, Product_Category_Sub_Division__c, Category_Level_2__c, Category_Level_3__c, Category__c,Sub_Category__c FROM uw_BET__c LIMIT 10000];
        return betList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to reassign brands
    Parameters: Database.BatchableContext, list of BETs for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, list<uw_BET__c> scope){ 
        System.Debug('***BET_BatchCategoryMapping execute invoked***'); 
        System.Debug('Size of scope: ' + scope.size());
        
        List<uw_BET__c> betList = new List<uw_BET__c>();
        for (uw_BET__c bet : scope) { 
             if ( String.isBlank(bet.Product_Category_Sub_Division__c) == true ) continue;
             // Cross category will be manually updated.  
             if ( bet.Product_Category_Sub_Division__c != 'Cross Category' ) {
                 uw_BET__c newBET = new uw_BET__c();
                 newBET.Id = bet.Id;
                 newBET.Name = bet.Name;
                 String division = bet.Product_Category_Sub_Division__c;
                 String newDivision = (division == null ) ? null : divisionsMapNames.get(division);
                 String category = bet.Category_Level_2__c;
                 String newCategory = (category == null ) ? null : categoriesMapNames.get(category);
                 System.Debug('NEW DEVISION: ' + newDivision);
                 System.Debug('NEW CATEGORY: ' + newCategory);
                 newBET.Category__c = categoriesMapIds.get(newDivision);
                 newBET.Sub_Category__c = categoriesMapIds.get(newCategory);
                 System.Debug('NEWBET DEVISION: ' + newBET.Category__c);
                 System.Debug('NEWBET CATEGORY: ' + newBET.Sub_Category__c );

                 betList.add(newBET);
             }
        }  
        
        for ( uw_BET__c bet : betList ) {
             System.Debug('BET ID: ' + bet.Id + ' BET Name: ' + bet.Name);
             System.Debug('BET Category: ' + bet.Category__c + ' BET SubCategory: ' + bet.Sub_Category__c);
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
       System.Debug('***BET_BatchCategoryMapping finish invoked***');
       //### No finish operations
    }
    
    void populateCategoriesMapIds() { 
       List<BET_Category__c> categoryList = [SELECT Id, Name FROM BET_Category__c LIMIT 100];
       
       for ( BET_Category__c category : categoryList ) {
           categoriesMapIds.put(category.Name, category.Id);  
       }
       
       for ( String categoryName : categoriesMapIds.keySet() ) {
           System.Debug('Category Name: ' + categoryName + ' Category Id: ' + categoriesMapIds.get(categoryName));
       }
       
    }
}