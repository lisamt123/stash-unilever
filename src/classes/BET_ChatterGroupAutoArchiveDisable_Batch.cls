/*************************************************************************************
Name : BET_ChatterGroupAutoArchiveDisable_Batch

Purpose : Class responsible for disable auto archive chatter groups
History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  20-08-2015  Initial
*************************************************************************************/
/* Batch class, with sharing is not needed */
global class BET_ChatterGroupAutoArchiveDisable_Batch implements Database.Batchable<sObject> {
	
	global BET_ChatterGroupAutoArchiveDisable_Batch() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('Starting BET_ChatterGroupAutoArchiveDisable_Batch');
		Set<String> collaborationGroupsIds = new Set<String>();
		for(uw_Bet__c bet : [select Studio_Chatter_Group__c from uw_Bet__c where Studio_Chatter_Group__c != null ]){
			collaborationGroupsIds.add(bet.Studio_Chatter_Group__c);
		}
		String query = 'Select id, IsAutoArchiveDisabled from CollaborationGroup where IsAutoArchiveDisabled = false and id in :collaborationGroupsIds';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		System.debug('Starting execute : ' + scope);
		for(CollaborationGroup chatterGroup : (List<CollaborationGroup>)scope){
			chatterGroup.IsAutoArchiveDisabled = true;
		}
		System.debug('Exit execute : ' + scope);
		update scope;
	}
	
	global void finish(Database.BatchableContext BC) {
		System.debug('Finish BET_ChatterGroupAutoArchiveDisable_Batch');
	}
	
}