/*****************************************************************************************************************************
Name: BET_Team_MemberHandler
Copyright © 2015 Unilever. 

Purpose: BET_Team_MemberHandler uses ITrigger pattern

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            13/08/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
public with sharing class BET_Team_MemberHandler  implements ITrigger {
	
	public BET_Team_MemberHandler() {}

	public void bulkBefore() {
		System.debug('bulk before');
	}
	
	public void bulkAfter() {
		System.debug('bulk after');
		if(Trigger.isInsert){
			BET_Team_MemberHandlerCls.runPostApprovalInsertTeamMemberOperations((List<uw_BET_Team_Member__c>)Trigger.new);
		}
		if(Trigger.isUpdate){
			BET_Team_MemberHandlerCls.runRoleModifications((List<uw_BET_Team_Member__c>)Trigger.new,(Map<Id,uw_BET_Team_Member__c>)Trigger.oldMap);
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