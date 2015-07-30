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
		if(Trigger.isUpdate){
			
		}
		if(Trigger.isDelete){
			
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
    		BET_MemberRequestHandlerCls.createTeamMemberForApprovedRequest((List<BET_Member_Request__c>)Trigger.new, (Map<Id,BET_Member_Request__c>)Trigger.oldMap);
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