/*****************************************************************************************************************************
Name: BET_MDODataMigrationAndTransformBatch
Copyright © 2015 Unilever. 

Purpose: One  off  update  in  BET  to  update  all  BET records  to refer  to  the  new
master data reference tables

History
-------
VERSION AUTHOR                          DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            02/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
/* Batch class so with sharing is not needed */
global class BET_MDODataMigrationAndTransform_Batch implements Database.Batchable<sObject> {
    
    String query = 'SELECT id,uw_Brand__c,uw_Brand__r.name,Product_Brand__c,Category__c,Category__r.name,Category_Group__c,Sub_Category__c,Sub_Category__r.name,Product_Category__c,Brand_Position__c '+
                   'FROM uw_Bet__c '+
                   'WHERE Brand_Position__c = null';

    global Map<String,MDO_Category__c> categoryGroups = new Map<String,MDO_Category__c>();
    global Map<Id,List<MDO_Category__c>> categoryGroupRelatedCategories = new Map<Id,List<MDO_Category__c>>();
    global Map<String,List<MDO_Brand__c>> brands = new Map<String,List<MDO_Brand__c>>();

    global BET_MDODataMigrationAndTransform_Batch() {
        for(MDO_Category__c categoryGroup : (List<MDO_Category__c>)BET_MasterDataService.getBETCategoryGroups()){
            categoryGroups.put(categoryGroup.name.toUpperCase('en'), categoryGroup);
        }

        for(MDO_Category__c category : BET_MasterDataService.getAllAvailableCategories()){
            if(categoryGroupRelatedCategories.keySet().contains(category.parent_id__r.parent_id__c)){
                categoryGroupRelatedCategories.get(category.parent_id__r.parent_id__c).add(category);
            } else {
                categoryGroupRelatedCategories.put(category.parent_id__r.parent_id__c, new List<MDO_Category__c>{category});
            }
        }

        for(MDO_Brand__c brand : [select id,name from MDO_Brand__c where status__c = 'Active']){
            if(brands.keySet().contains(brand.name.toUpperCase('en'))){
                brands.get(brand.name.toUpperCase('en')).add(brand);
            } else {
                brands.put(brand.name.toUpperCase('en'), new List<MDO_Brand__c> {brand});
            }
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try{
            update proceedWithDataTransormation((List<uw_Bet__c>)scope);
        } catch (DmlException e){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'BET_MDODataMigrationAndTransform_Batch','execute',
                'execute ' + (List<uw_Bet__c>)scope + ' ' + e.getStackTraceString(), e,'ERROR',null,null,(Integer)DateTime.now().getTime(),'BET');
        }  
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Finish BET_MDODataMigrationAndTransform_Batch');
    }

    global List<uw_Bet__c> proceedWithDataTransormation(List<uw_Bet__c> scope){
        System.debug('Entering proceedWithDataTransormation : ' + scope);
        List<uw_Bet__c> betsForUpdate = new List<uw_Bet__c>();
        List<uw_Bet__c> betsForErrors = new List<uw_Bet__c>();
        for(uw_Bet__c bet : scope) {
            /*try{*/
                System.debug('Step 1 : Retriving category group by name : ' +  bet.Category__r.name.toUpperCase('en'));
                MDO_Category__c categoryGroup = categoryGroups.get(bet.Category__r.name.toUpperCase('en'));
                System.debug('Step 2 : Retrieved category group : ' + categoryGroup);
                System.debug('Step 3 : Retriving category brand by name : ' +  bet.uw_Brand__r.name.toUpperCase('en'));
                List<MDO_Brand__c> brandsobj = brands.get(bet.uw_Brand__r.name.toUpperCase('en'));
                System.debug('Step 4 : Retrieved brand : ' + brandsobj);
                bet.Category_Group__c = categoryGroup == null ? null : categoryGroup.id;
                if(categoryGroup != null) {
                    bet.Product_Category__c = retrieveCategoryId(categoryGroup,bet);
                }
                if(brandsobj != null) {
                    for(MDO_Brand__c brand : brandsobj){
                        bet.Product_Brand__c = brand.id;
                        if(bet.Product_Category__c != null && bet.Product_Brand__c != null){
                            System.debug('Step 8 : Retriving getBrandPosition : ' +  bet.Product_Brand__c + ' ' + bet.Product_Category__c);
                            bet.Brand_Position__c = getBrandPosition(bet.Product_Brand__c,bet.Product_Category__c);
                            System.debug('Step 9 : Retrived brand position : ' +  bet.Brand_Position__c);
                        }
                        if(bet.Brand_Position__c != null){
                            break;
                        }
                    }
                }
                if(validateBet(bet)){
                    betsForUpdate.add(bet);
                } else {
                    betsForErrors.add(bet);
                }
            /*} 
            catch (NullPointerException exc){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'BET_MDODataMigrationAndTransform_Batch','proceedWithDataTransormation',
                'NullPointerException for bet ' + bet.id + ' ' + exc.getStackTraceString(),exc,'ERROR',null,null,(Integer)DateTime.now().getTime(),'BET');
            }*/
        }
        System.debug('Exit proceedWithDataTransormation : ' + betsForUpdate + ', ' + betsForErrors);
        logErrors(betsForErrors);
        return betsForUpdate;
    }

    global Id retrieveCategoryId(MDO_Category__c categoryGroup,uw_Bet__c bet){
        Id categoryId = null;
        System.debug('Step 5 : Retriving category by category group : ' +  categoryGroup.id);
        for(MDO_Category__c category : categoryGroupRelatedCategories.get(categoryGroup.id)){
            System.debug('Step 6 : Comapring  : ' + category.name + ' with ' + bet.Sub_Category__r.name);
            if(category.name != null && bet.Sub_Category__r.name != null && category.name.toUpperCase('en') == bet.Sub_Category__r.name.toUpperCase('en')){
                System.debug('Step 7 : Setting category to  : ' + category.id);
                categoryId = category.id;
                break;
            }
        }
        return categoryId;
    }

    global Id getBrandPosition(Id brandId,Id categoryId){
        List<MDO_BrandPositions__c> bpositions = [select id,brand_position_id__c from MDO_BrandPositions__c 
                                                        where brand_id__c =: brandId 
                                                        and product_category_id__c in 
                                                        (select id from MDO_Category__c where parent_id__c =: categoryId or id =: categoryId)]; 

        return bpositions.isEmpty() ? null : bpositions.get(0).brand_position_id__c;
    }

    global Boolean validateBet(uw_Bet__c bet){
        System.debug('Entering validateBet : ' + bet);
        return bet.Product_Brand__c != null && bet.Category__c != null && bet.Product_Category__c != null && bet.Brand_Position__c != null;
    }

    global void logErrors(List<uw_Bet__c> betsForErrors){
        for(uw_Bet__c betRecord : betsForErrors){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'BET_MDODataMigrationAndTransform_Batch','proceedWithDataTransormation',
                'Invalid MDO matching for BET  ' + betRecord.id + ' category : ' + betRecord.Sub_Category__c + ', ' + betRecord.Product_Category__c,
                new BET_CustomBETException('Invalid MDO matching for BET : ' + betRecord),'ERROR',null,null,(Integer)DateTime.now().getTime(),'BET');
        }
    }
    
}