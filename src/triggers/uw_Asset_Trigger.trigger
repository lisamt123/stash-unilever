/*****************************************************************************************************************************
Name: uw_Asset_Trigger
Copyright © 2015 Unilever. 

Purpose: Asset object trigger. It uses ITrigger pattern 

History
-------
VERSION AUTHOR                          DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            17/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
trigger uw_Asset_Trigger on uw_Asset__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	BET_TriggerFactory.createHandler(uw_Asset__c.sObjectType);
}