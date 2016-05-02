/*************************************************************************************
Name : BET_AssetHandler

Purpose : ITrigger pattern class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-09-2015  Initial
*************************************************************************************/
public with sharing class BET_AssetHandler implements ITrigger {
	
	public BET_AssetHandler() {}

	public void bulkBefore() {
		System.debug('Entering bulkBefore');
		if(Trigger.isInsert){
			BET_AssetHandlerCls.updateAssetOrdering(Trigger.new);
		}
	}

	public void bulkAfter() {
		System.debug('Entering bulkAfter');
		if(Trigger.isInsert){
			BET_AssetHandlerCls.handleOpenAssetInserts(Trigger.new);
			BET_AssetHandlerCls.updateActualAssetsNumber(Trigger.new);
		}
		if(Trigger.isUpdate){
			BET_AssetHandlerCls.handleOpenCloseAssetUpdates(Trigger.new,(Map<Id,uw_Asset__c>)Trigger.oldMap);
			BET_AssetHandlerCls.updateActualAssetsNumber(Trigger.new,(Map<Id,uw_Asset__c>)Trigger.oldMap);
			BET_AssetHandlerCls.updateBETStatusAccordingly(Trigger.new,(Map<Id,uw_Asset__c>)Trigger.oldMap);
		}
		if(Trigger.isDelete){
			BET_AssetHandlerCls.updateActualAssetsNumberAfterDeletion(Trigger.old);
			BET_AssetHandlerCls.updateBETStatusAccordingly(Trigger.old);
		}
	}

	public void beforeInsert(SObject so) {System.debug('Entering beforeInsert ' + so);}
	public void beforeUpdate(SObject oldSo, SObject so)	{System.debug('Entering beforeUpdate ' + so + ', ' + oldSo);}
	public void beforeDelete(SObject so) {System.debug('Entering beforeDelete ' + so);}
	public void afterInsert(SObject so) {System.debug('Entering afterInsert ' + so);}
	public void afterUpdate(SObject oldSo, SObject so) {System.debug('Entering afterUpdate ' + so + ', ' + oldSo);}
	public void afterDelete(SObject so) {System.debug('Entering afterDelete ' + so);}
	public void andFinally() {System.debug('Entering finally');}
}