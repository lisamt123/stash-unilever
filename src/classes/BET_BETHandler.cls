/*************************************************************************************
Name : BET_BETHandler

Purpose : Handler class used by BET related trigger

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  22-07-2015  Initial
*************************************************************************************/
public with sharing class BET_BETHandler implements ITrigger {

	private uw_TriggerHandler handler = new uw_TriggerHandler();

	public BET_BETHandler() {}

	public void bulkBefore() {
		if(Trigger.isInsert){
			BET_UpdateBETSearchHandler.beforeInsert(Trigger.new); // Taken from BET_UpdateBETSearch trigger
        	handler.handleBetBeforeInserts(Trigger.new); // Taken from uw_BET_before_insert trigger
		}
		if(Trigger.isUpdate){
			BET_UpdateBETSearchHandler.beforeUpdate(Trigger.new,BET_BETHandlerCls.buildBetMap(Trigger.oldMap)); // Taken from BET_UpdateBETSearch trigger
		}
		if(Trigger.isDelete){
			BET_BETHandlerCls.deleteBETRelatedCollaborationGroup(); // Taken from uw_BET_before_delete trigger
		}
	}

	public void bulkAfter() {
		if (Trigger.isUpdate){ // Taken from uw_BET_after_update trigger
    		handler.handleBetAfterUpdates(BET_BETHandlerCls.buildBetMap(Trigger.newMap),BET_BETHandlerCls.buildBetMap(Trigger.oldMap));
    		BET_BETHandlerCls.logChanges(); // Taken from BET_LogChanges trigger
    	}
    	if(Trigger.isInsert){
    		handler.handleBetAfterInserts(Trigger.new); // Taken from uw_BET_after_insert trigger
    	}
	}

	public void beforeInsert(SObject so) {}
	public void beforeUpdate(SObject oldSo, SObject so)	{}
	public void beforeDelete(SObject so) {}
	public void afterInsert(SObject so) {}
	public void afterUpdate(SObject oldSo, SObject so) {}
	public void afterDelete(SObject so) {}
	public void andFinally() {}
}