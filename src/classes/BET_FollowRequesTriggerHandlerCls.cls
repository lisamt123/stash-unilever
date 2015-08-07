/*****************************************************************************************************************************
Name: BET_FollowRequesTriggerHandlerCls
Copyright © 2015 Unilever. 

Purpose: Holds all Follow Request trigger related logic

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            06/08/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
public with sharing class BET_FollowRequesTriggerHandlerCls {

	private BET_FollowRequesTriggerHandlerCls() {}

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
			if(request.Status__c == BET_LinkingService.FOLLOW_STATUS_APPROVED && oldMap.get(request.id).Status__c != BET_LinkingService.FOLLOW_STATUS_APPROVED){
				approvedRequests.add(request);
			} else if (request.Status__c == BET_LinkingService.FOLLOW_STATUS_REJECTED && oldMap.get(request.id).Status__c != BET_LinkingService.FOLLOW_STATUS_REJECTED){
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
		for(BET_Follow_Request__c request : approvedRequests){
			if(request.Is_Lead_Request__c){
				leadRequests.add(request);
			}
		}
		if(!leadRequests.isEmpty()) updateBetsWithLeadProjects(leadRequests);
		if(!approvedRequests.isEmpty()) approveAllRelatedMemberRequests(getIds(approvedRequests));
		notifyIPMProjectLeads(approvedRequests,'Approved');
	}

	/************************************************************
		Purpose: Method updates Bet records if requests are lead
		Parameters: List<BET_Follow_Request__c> leadRequests
		Returns: -
		Throws: -
	*************************************************************/
	private static void updateBetsWithLeadProjects(List<BET_Follow_Request__c> leadRequests){

	}

	/************************************************************
		Purpose: Method handles requests that have been rejected
		Parameters: List<BET_Follow_Request__c> approvedRequests
		Returns: -
		Throws: -
	*************************************************************/
	private static void handleRejectedRequests(List<BET_Follow_Request__c> rejectedRequests){
		rejectAllRelatedMemberRequests(getIds(rejectedRequests));
		notifyIPMProjectLeads(rejectedRequests,'Rejected');
	}

	private static void notifyIPMProjectLeads(List<BET_Follow_Request__c> rejectedRequests,String status){
		for(BET_Follow_Request__c request : rejectedRequests){
			IPM_BETLinkingService.notifyIPM(request.Brand_Experience_Toolkit__c,(Id)request.Project_Id__c,status);
		}
	}

	/************************************************************
		Purpose: Method retrieves list of request ids for given request list
		Parameters: List<BET_Follow_Request__c> requests
		Returns: List<Id>
		Throws: -
	*************************************************************/
	private static List<Id> getIds(List<BET_Follow_Request__c> requests){
		List<Id> requestIds = new List<Id>();
		for(BET_Follow_Request__c request : requests){
			requestIds.add(request.id);
		}
		return requestIds;
	}

	/************************************************************
		Purpose: Method rejects all member requests associated with follow requests
		Parameters: List<Id> rejectedRequestsIds
		Returns: -
		Throws: -
	*************************************************************/
	private static void rejectAllRelatedMemberRequests(List<Id> rejectedRequestsIds){
		List<BET_Member_Request__c> relatedMemberRequest = [select id, Status__c from BET_Member_Request__c where 	ProjectRequest__c in: rejectedRequestsIds];
		for(BET_Member_Request__c request : relatedMemberRequest){
			request.Status__c = 'Rejected';
		}
		update relatedMemberRequest;
	}

	/************************************************************
		Purpose: Method approves all member requests associated with follow requests
		Parameters: List<Id> rejectedRequestsIds
		Returns: -
		Throws: -
	*************************************************************/
	private static void approveAllRelatedMemberRequests(List<Id> approvedRequestsIds){
		List<BET_Member_Request__c> relatedMemberRequest = [select id, Status__c from BET_Member_Request__c where 	ProjectRequest__c in: approvedRequestsIds];
		for(BET_Member_Request__c request : relatedMemberRequest){
			request.Status__c = 'Approved';
		}
		update relatedMemberRequest;
	}
}