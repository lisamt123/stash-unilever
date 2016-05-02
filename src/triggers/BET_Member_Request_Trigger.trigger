/*****************************************************************************************************************************
Name: uw_BET_Trigger
Copyright © 2015 Unilever. 

Purpose: BET Member Request trigger. It uses ITrigger pattern 

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   k.szepietowski@polsource.com            23/07/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
trigger BET_Member_Request_Trigger on BET_Member_Request__c (before insert,before update,before delete,after insert,after update) {
	BET_TriggerFactory.createHandler(BET_Member_Request__c.sObjectType);
}