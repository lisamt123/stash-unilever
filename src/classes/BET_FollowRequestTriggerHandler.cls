/*****************************************************************************************************************************
Name: BET_FollowRequesTriggerHandler
Copyright © 2015 Unilever. 

Purpose: BET Follow Request Handler. It uses ITrigger pattern 

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            06/08/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
public with sharing class BET_FollowRequestTriggerHandler implements ITrigger {
	
	public BET_FollowRequestTriggerHandler() {}

	public void bulkBefore() {
		System.debug('bulk before');
	}
	
	public void bulkAfter() {
		List<BET_Follow_Request__c> newList = new List<BET_Follow_Request__c>();
		for(sObject sobj : Trigger.new){
			newList.add((BET_Follow_Request__c)sobj);
		}
		if(Trigger.isUpdate){
			Map<Id,BET_Follow_Request__c> oldMap = new Map<Id,BET_Follow_Request__c>();
			for(Id identifier : Trigger.oldMap.keySet()){
				oldMap.put(identifier,(BET_Follow_Request__c)Trigger.oldMap.get(identifier));
			}
			BET_FollowRequestTriggerHandlerCls.handleUpdatedFollowRequests(newList,oldMap); 
		}
		if(Trigger.isInsert){
			BET_FollowRequestTriggerHandlerCls.handleInsertedFollowRequests(newList); 
		}
	}

	public void beforeInsert(SObject so) {
		System.debug('before Insert ' + so);
	}
	public void beforeUpdate(SObject oldSo, SObject so)	{
		System.debug('before Update ' + so + ', ' + oldSo);
	}
	public void beforeDelete(SObject so) {
		System.debug('before Delete ' + so);
	}
	public void afterInsert(SObject so) {
		System.debug('after Insert ' + so);
	}
	public void afterUpdate(SObject oldSo, SObject so) {
		System.debug('after Update ' + so + ', ' + oldSo);
	}
	public void afterDelete(SObject so) {
		System.debug('after Delete ' + so);
	}
	public void andFinally() {
		System.debug('and Finally');
	}

}