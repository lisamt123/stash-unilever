/*****************************************************************************************************************************
Name: uw_BET_Trigger
Copyright © 2014 Unilever. 

Purpose: BET object trigger. It uses ITrigger pattern 

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            22/07/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/

trigger uw_BET_Trigger on uw_Bet__c (before insert,before update,before delete,after insert,after update) {
	BET_TriggerFactory.createHandler(uw_Bet__c.sObjectType);
}