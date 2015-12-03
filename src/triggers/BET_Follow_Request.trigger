/**************************************************************************************
Name: BET_Follow_Request
Copyright © 2014 Unilever. 

Purpose: BET Follow Request object trigger. It uses ITrigger pattern 

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            06/08/2015      INITIAL DEVELOPMENT
************************************************************************************/
trigger BET_Follow_Request on BET_Follow_Request__c (before insert,after insert, after update) {
	BET_TriggerFactory.createHandler(BET_Follow_Request__c.sObjectType);
}