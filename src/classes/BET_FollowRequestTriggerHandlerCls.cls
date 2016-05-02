/*****************************************************************************************************************************
Name: BET_FollowRequestTriggerHandlerCls
Copyright © 2015 Unilever. 

Purpose: Holds all Follow Request trigger related logic

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            06/08/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
public without sharing class BET_FollowRequestTriggerHandlerCls {

	private BET_FollowRequestTriggerHandlerCls() {}

	/************************************************************
		Purpose: Method handles all updates made on follow requests
		Parameters: List<BET_Follow_Request__c> requests, Map<Id,BET_Follow_Request__c> oldMap
		Returns: -
		Throws: -
	*************************************************************/
	public static void handleUpdatedFollowRequests(List<BET_Follow_Request__c> requests, Map<Id,BET_Follow_Request__c> oldMap){
		List<BET_Follow_Request__c> approvedRequests = new List<BET_Follow_Request__c>();
		List<BET_Follow_Request__c> rejectedRequests = new List<BET_Follow_Request__c>();
		for(BET_Follow_Request__c request : requests){
			if(request.Status__c == BET_LinkingService.FOLLOW_STATUS_APPROVED 
				&& oldMap.get(request.id).Status__c != BET_LinkingService.FOLLOW_STATUS_APPROVED){
				approvedRequests.add(request);
			} else if (request.Status__c == BET_LinkingService.FOLLOW_STATUS_REJECTED 
				&& oldMap.get(request.id).Status__c != BET_LinkingService.FOLLOW_STATUS_REJECTED){
				rejectedRequests.add(request);
			}
		}
		handleApprovedRequests(approvedRequests);
		handleRejectedRequests(rejectedRequests);
	}

	/************************************************************
		Purpose: Method handles all inserts made on follow requests
		Parameters: List<BET_Follow_Request__c> requests
		Returns: -
		Throws: -
	*************************************************************/
	public static void handleInsertedFollowRequests(List<BET_Follow_Request__c> requests){
		List<BET_Follow_Request__c> approvedRequests = new List<BET_Follow_Request__c>();
		for(BET_Follow_Request__c request : requests){
			if(request.Status__c == BET_LinkingService.FOLLOW_STATUS_APPROVED){
				approvedRequests.add(request);
			}
		}
		handleApprovedRequests(approvedRequests);
	}

	/************************************************************
		Purpose: Method handles requests that have been approved
		Parameters: List<BET_Follow_Request__c> approvedRequests
		Returns: -
		Throws: -
	*************************************************************/
	private static void handleApprovedRequests(List<BET_Follow_Request__c> approvedRequests){
		List<BET_Follow_Request__c> leadRequests = new List<BET_Follow_Request__c>();
		List<BET_Follow_Request__c> notLeadRequests = new List<BET_Follow_Request__c>();
		Set<Id> leadReguestRelatedBets = new Set<Id>();
		Set<Id> notLeadReguestRelatedBets = new Set<Id>();
		for(BET_Follow_Request__c request : approvedRequests){
			if(request.Is_Lead_Request__c){
				leadRequests.add(request);
				leadReguestRelatedBets.add(request.Brand_Experience_Toolkit__c);
			} else {
				notLeadRequests.add(request);
				notLeadReguestRelatedBets.add(request.Brand_Experience_Toolkit__c);
			}
		}
		if(!leadRequests.isEmpty()){
			BET_FollowRequestTriggerHandlerClsHelper.updateBetsWithLeadProjects(leadRequests);
		}
		if(!notLeadRequests.isEmpty()){
			BET_FollowRequestTriggerHandlerClsHelper.createFollowProjectChatterFeeds(notLeadRequests,notLeadReguestRelatedBets);
		}
		if(!approvedRequests.isEmpty()){
			BET_FollowRequestTriggerHandlerClsHelper.updateRelatedMemberRequests(BET_FollowRequestTriggerHandlerClsHelper.getIds(approvedRequests),BET_SuggestedMemberService.APPROVED);
		}
		BET_FollowRequestTriggerHandlerClsHelper.notifyIPMProjectLeads(approvedRequests,BET_LinkingService.FOLLOW_STATUS_APPROVED);
		BET_FollowRequestTriggerHandlerClsHelper.updateBetsWithLeadProjectsWhenThereIsNoLeadProjectOnBET(approvedRequests,leadReguestRelatedBets);
	}

	/************************************************************
		Purpose: Method handles requests that have been rejected
		Parameters: List<BET_Follow_Request__c> approvedRequests
		Returns: -
		Throws: -
	*************************************************************/
	private static void handleRejectedRequests(List<BET_Follow_Request__c> rejectedRequests){
		List<BET_Follow_Request__c> leadRequests = new List<BET_Follow_Request__c>();
		for(BET_Follow_Request__c request : rejectedRequests){
			if(request.Is_Lead_Request__c){
				leadRequests.add(request);
			}
		}
		BET_FollowRequestTriggerHandlerClsHelper.updateRelatedMemberRequests(BET_FollowRequestTriggerHandlerClsHelper.getIds(rejectedRequests),BET_SuggestedMemberService.REJECTED);
		BET_FollowRequestTriggerHandlerClsHelper.notifyIPMProjectLeads(rejectedRequests,BET_LinkingService.FOLLOW_STATUS_REJECTED);
	}

}