/*****************************************************************************************************************************
Name: BET_MDODataMigrationAndTransformBatch
Copyright © 2015 Unilever. 

Purpose: One  off  update  in  BET  to  update  all  BET records  to refer  to  the  new
master data reference tables

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            02/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
global class BET_MDODataMigrationAndTransformBatch implements Database.Batchable<sObject> {
	
	String query = 'SELECT id,uw_Brand__c,uw_Brand__r.name,Product_Brand__c,Category__c,Category__r.name,Category_Group__c,Sub_Category__c,Sub_Category__r.name,Product_Category__c,Brand_Position__c '+
				   'FROM uw_Bet__c '+
				   'WHERE Brand_Position__c == null';

	global Map<String,MDO_Category__c> categoryGroups = new Map<String,MDO_Category__c>();
	global Map<Id,List<MDO_Category__c>> categoryGroupRelatedCategories = new Map<Id,List<MDO_Category__c>>();
	global Map<String,MDO_Brand__c> brands = new Map<String,MDO_Brand__c>();

	global BET_MDODataMigrationAndTransformBatch() {
		for(MDO_Category__c categoryGroup : (List<MDO_Category__c>)BET_MasterDataService.getBETCategoryGroups()){
			categoryGroups.put(categoryGroup.name, categoryGroup);
		}

		for(MDO_Category__c category : BET_MasterDataService.getAllAvailableCategories()){
			if(categoryGroupRelatedCategories.keySet().contains(category.parent_id__r.parent_id__c)){
				categoryGroupRelatedCategories.get(category.parent_id__r.parent_id__c).add(category);
			} else {
				categoryGroupRelatedCategories.put(category.parent_id__r.parent_id__c, new List<MDO_Category__c>{category});
			}
		}

		for(MDO_Brand__c brand : [select id,name from MDO_Brand__c where status__c = 'Active']){
			brands.put(brand.name, brand);
		}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		update proceedWithDataTransormation((List<uw_Bet__c>)scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

	global List<uw_Bet__c> proceedWithDataTransormation(List<uw_Bet__c> scope){
		System.debug('Entering proceedWithDataTransormation : ' + scope);
		List<uw_Bet__c> betsForUpdate = new List<uw_Bet__c>();
		List<uw_Bet__c> betsForErrors = new List<uw_Bet__c>();
		for(uw_Bet__c bet : scope) {
			MDO_Category__c categoryGroup = categoryGroups.get(bet.Category__r.name);
			MDO_Brand__c brand = brands.get(bet.uw_Brand__r.name);
			bet.Category_Group__c = categoryGroup == null ? null : categoryGroup.id;
			bet.Product_Brand__c = brand == null ? null : brand.id;
			if(categoryGroup != null) {
				for(MDO_Category__c category : categoryGroupRelatedCategories.get(categoryGroup.id)){
					if(category.name == bet.Sub_Category__r.name){
						bet.Product_Category__c = category.id;
					}
				}
			}
			if(bet.Product_Category__c != null && bet.Product_Brand__c != null){
				bet.Brand_Position__c = getBrandPosition(bet.Product_Brand__c,bet.Product_Category__c);
			}
			if(validateBet(bet)){
				betsForUpdate.add(bet);
			} else {
				betsForErrors.add(bet);
			}
		}
		System.debug('Exit proceedWithDataTransormation : ' + betsForUpdate + ', ' + betsForErrors);
		logErrors(betsForErrors);
		return betsForUpdate;
	}

	global Id getBrandPosition(Id brandId,Id categoryId){
		List<MDO_BrandPositions__c> bpositions = [select id,brand_position_id__c from MDO_BrandPositions__c where 
														brand_id__c =: brandId 
														and product_category_id__c in (select id from MDO_Category__c where parent_id__c =: categoryId or id =: categoryId)];	

		return bpositions.isEmpty() ? null : bpositions.get(0).brand_position_id__c;
	}

	global Boolean validateBet(uw_Bet__c bet){
		System.debug('Entering validateBet : ' + bet);
		return bet.Product_Brand__c != null && bet.Category__c != null && bet.Product_Category__c != null && bet.Brand_Position__c != null;
	}

	global void logErrors(List<uw_Bet__c> betsForErrors){
		for(uw_Bet__c betRecord : betsForErrors){
			system.debug('Invalid MDO matching for BET : ' + betRecord);
		}
	}
	
}