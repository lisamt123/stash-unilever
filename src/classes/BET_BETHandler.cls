/*************************************************************************************
Name : BET_BETHandler

Purpose : Handler class used by BET related trigger

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  22-07-2015  Initial
*************************************************************************************/
public with sharing class BET_BETHandler implements ITrigger {

	private final uw_TriggerHandler handler = new uw_TriggerHandler();

	public BET_BETHandler() {}

	public void bulkBefore() {
		if(Trigger.isInsert){
			BET_UpdateBETSearchHandler.beforeInsert(Trigger.new); // Taken from BET_UpdateBETSearch trigger
        	handler.handleBetBeforeInserts(Trigger.new); // Taken from uw_BET_before_insert trigger
        	BET_BETHandlerCls.updateReleaseDueDates(Trigger.new);
		}
		if(Trigger.isUpdate){
			BET_UpdateBETSearchHandler.beforeUpdate(Trigger.new,BET_BETHandlerCls.buildBetMap(Trigger.oldMap)); // Taken from BET_UpdateBETSearch trigger
			BET_BETHandlerCls.updateReleaseDueDates(Trigger.new);
		}
		if(Trigger.isDelete){
			BET_BETHandlerCls.deleteBETRelatedCollaborationGroup(); // Taken from uw_BET_before_delete trigger
		}
	}

	public void bulkAfter() {
		if (Trigger.isUpdate){ // Taken from uw_BET_after_update trigger
			BET_BETHandlerCls.unarchiveBet(Trigger.new,BET_BETHandlerCls.buildBetMap(Trigger.oldMap));
    		handler.handleBetAfterUpdates(BET_BETHandlerCls.buildBetMap(Trigger.newMap),BET_BETHandlerCls.buildBetMap(Trigger.oldMap));
    		BET_BETHandlerCls.logChanges(); // Taken from BET_LogChanges trigger
    		BET_BETHandlerCls.informIPMOnBetChanges(Trigger.new,BET_BETHandlerCls.buildBetMap(Trigger.oldMap));
    		BET_BETHandlerCls.archiveBet(Trigger.new,BET_BETHandlerCls.buildBetMap(Trigger.oldMap));
    		BET_BETHandlerCls.deleteBet(Trigger.new,BET_BETHandlerCls.buildBetMap(Trigger.oldMap));
    	}
    	if(Trigger.isInsert){
    		handler.handleBetAfterInserts(Trigger.new); // Taken from uw_BET_after_insert trigger
    	}
	}

	public void beforeInsert(SObject so) {System.debug('before insert ' + so);}
	public void beforeUpdate(SObject oldSo, SObject so)	{System.debug('before update ' + so + ', ' + oldSo);}
	public void beforeDelete(SObject so) {System.debug('before delete ' + so);}
	public void afterInsert(SObject so) {System.debug('after insert ' + so);}
	public void afterUpdate(SObject oldSo, SObject so) {System.debug('after update ' + so + ', ' + oldSo);}
	public void afterDelete(SObject so) {System.debug('after delete ' + so);}
	public void andFinally() {System.debug('finally');}
}