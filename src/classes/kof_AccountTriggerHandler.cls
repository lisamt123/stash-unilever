/***
Class: kof_AccountTriggerHandler
Description: the trigger handler for the kof_account trigger
**/

public with sharing class kof_AccountTriggerHandler {

	/**
		sets the root orgaisation on the kof account
		@params kof_Account__c[] oldItems - list containing old values of kof_accounts__c
		@params kof_Account__c[] updatedItems - list containing new values of kof_accounts__c
		@params Map<Id, kof_Account__c> itemMap - map of kof_accounts

	**/
	public void onBeforeUpdate(kof_Account__c[] oldItems, kof_Account__c[] updatedItems, Map<Id, kof_Account__c> itemMap) {
		Map<Id,kof_Account__c> reloadedItems = 
			new Map<Id,kof_Account__c>([SELECT ParentAccount__c, ParentAccount__r.Root_Organisation__c FROM kof_Account__c WHERE id IN :itemMap.keySet()]);
		
		for (Id i : itemMap.keySet()) {
			kof_Account__c item = itemMap.get(i);
			item.Root_Organisation__c = (reloadedItems.get(i).ParentAccount__c != null) ? reloadedItems.get(i).ParentAccount__r.Root_Organisation__c : i;
		}
	}
	
	/**
		sets the root organisation
		@params kof_Account__c[] newItems - list of inserted kof_Accounts__c
		@params Map<Id, kof_Account__c> itemMap - map of kof Accounts
	**/
	public void onAfterInsert(kof_Account__c[] newItems, Map<Id, kof_Account__c> itemMap) {
		List<kof_Account__c> reloadedItems = [SELECT ParentAccount__c, ParentAccount__r.Root_Organisation__c FROM kof_Account__c WHERE id IN :itemMap.keySet()];
		
		for (kof_Account__c item : reloadedItems) {
			item.Root_Organisation__c = (item.ParentAccount__c != null) ? item.ParentAccount__r.Root_Organisation__c : item.Id;
		}
		update reloadedItems;
	}
	
}