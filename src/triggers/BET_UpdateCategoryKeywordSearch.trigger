/**********************************************************************
Name: BET_UpdateCategoryKeywordSearch
Copyright © 2014 Unilever. 

============================================================================
============================================================================
Purpose: Trigger for populating Category_Keyword_Search__c field in uw_BET__c object. SOSL porpose
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol         	03/12/2014     	INITIAL DEVELOPMENT
**********************************************************************/

trigger BET_UpdateCategoryKeywordSearch on BET_Category__c (after update) {
	Set<Id> categoriesIds = new Set<Id>();

	for(BET_Category__c b : Trigger.new){
		if(b.Name != Trigger.oldMap.get(b.Id).Name){
			categoriesIds.add(b.Id);
		}
	}

	List<uw_BET__c> bets = [SELECT Id, Sub_Category__r.Name FROM uw_BET__c WHERE Sub_Category__c IN :categoriesIds];
	for(uw_BET__c b : bets){
    	b.Category_Keyword_Search__c = b.Sub_Category__r.Name;
    } 

    update bets;
}