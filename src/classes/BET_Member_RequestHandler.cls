/*****************************************************************************************************************************
Name: BET_Member_RequestHandler
Copyright © 2015 Unilever. 

Purpose: BET Member Request Handler. It uses ITrigger pattern 

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   k.szepietowski@polsource.com            23/07/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
public with sharing class BET_Member_RequestHandler implements ITrigger {

	public BET_Member_RequestHandler() {}
	
    /************************************************************
        Purpose: Method responsible for handling all logic executed under trigger before insert/update/delete  
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
	public void bulkBefore() {
		if(Trigger.isInsert){
			BET_MemberRequestHandlerCls.preventMemberRequestDuplicatesWhileInsert(Trigger.new); 
        	
		}
	}
	
    /************************************************************
        Purpose: Method responsible for handling all logic executed under trigger after insert/update/delete  
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
	public void bulkAfter() {
		if (Trigger.isUpdate){
            BET_MemberRequestHandlerCls.createTeamMemberForApprovedRequest((List<BET_Member_Request__c>)Trigger.new, (Map<Id,BET_Member_Request__c>)Trigger.oldMap);
    	}
    	if(Trigger.isInsert){
    		//BET_MemberRequestHandlerCls.informIPMOfProjectMemberRequest((List<BET_Member_Request__c>)Trigger.new);
    		BET_MemberRequestHandlerCls.createTeamMemberForApprovedRequest((List<BET_Member_Request__c>)Trigger.new, (Map<Id,BET_Member_Request__c>)Trigger.oldMap);
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