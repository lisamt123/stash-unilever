/**********************************************************************
Name: bet_UpdateBrandKeywordSearch
Copyright © 2014 Unilever. 

============================================================================
============================================================================
Purpose: Trigger for populating Brand_Keyword_Search__c field in uw_BET__c object. SOSL porpose
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol         	03/12/2014     	INITIAL DEVELOPMENT
**********************************************************************/

trigger BET_UpdateBrandKeywordSearch on uw_Brand__c (after update) {
	Set<Id> brandsIds = new Set<Id>();

	for(uw_Brand__c b : Trigger.new){
		if(b.Name != Trigger.oldMap.get(b.Id).Name){
			brandsIds.add(b.Id);
		}
	}

	List<uw_BET__c> bets = [SELECT Id, uw_Brand__r.Name FROM uw_BET__c WHERE uw_Brand__c IN :brandsIds];
	for(uw_BET__c b : bets){
    	b.Brand_Keyword_Search__c = b.uw_Brand__r.Name;
    } 

    update bets;
}