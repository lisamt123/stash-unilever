/**********************************************************************
Name: uw_UpdateInfoprojectKeywordSearch
Copyright © 2014 Unilever. 

============================================================================
============================================================================
Purpose: Trigger for populating Inoplan_Project_Keyword_Search__c field in uw_BET__c object. SOSL porpose
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol         	03/12/2014     	INITIAL DEVELOPMENT
**********************************************************************/

trigger uw_UpdateInfoprojectKeywordSearch on uw_Inoplan_Project__c (after update) {
	Set<Id> projectIds = new Set<Id>();

	for(uw_Inoplan_Project__c p : Trigger.new){
		if(p.Name != Trigger.oldMap.get(p.Id).Name){
			projectIds.add(p.Id);
		}
	}

	List<uw_BET__c> bets = [SELECT Id, Inoplan_Project__r.Name FROM uw_BET__c WHERE Inoplan_Project__c IN :projectIds];
	for(uw_BET__c b : bets){
    	b.Inoplan_Project_Keyword_Search__c = b.Inoplan_Project__r.Name;
    }

    update bets;
}