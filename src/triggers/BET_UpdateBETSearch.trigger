/**********************************************************************
Name: uw_UpdateInfoprojectKeywordSearch
Copyright © 2014 Unilever. 

============================================================================
============================================================================
Purpose: Trigger for populating Region_Keyword_Tag__c or/and  Category_Keyword_Tag__c fields in uw_BET__c object. SOSL porpose
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol         	03/12/2014     	INITIAL DEVELOPMENT
**********************************************************************/

trigger BET_UpdateBETSearch on uw_BET__c (before insert, before update) {
	if (Trigger.isBefore && Trigger.isInsert) {
		BET_UpdateBETSearchHandler.beforeInsert(Trigger.new);
	}
	if (Trigger.isBefore && Trigger.isUpdate) {
		BET_UpdateBETSearchHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
	}
}