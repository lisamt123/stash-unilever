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
			updateBetsWithLeadProjects(leadRequests);
		}
		if(!notLeadRequests.isEmpty()){
			createFollowProjectChatterFeeds(notLeadRequests,notLeadReguestRelatedBets);
		}
		if(!approvedRequests.isEmpty()){
			approveAllRelatedMemberRequests(getIds(approvedRequests));
		}
		notifyIPMProjectLeads(approvedRequests,BET_LinkingService.FOLLOW_STATUS_APPROVED);
		updateBetsWithLeadProjectsWhenThereIsNoLeadProjectOnBET(approvedRequests,leadReguestRelatedBets);
	}

	/************************************************************
		Purpose: Method created chatter feeds when project is following bet
		Parameters: List<BET_Follow_Request__c> notLeadRequests,Set<Id> notLeadReguestRelatedBets
		Returns: -
		Throws: -
	*************************************************************/
	private static void createFollowProjectChatterFeeds(List<BET_Follow_Request__c> notLeadRequests,Set<Id> notLeadReguestRelatedBets){
		Map<Id,uw_Bet__c> betsMap = new Map<Id,uw_Bet__c>();
		for(uw_Bet__c bet : [select id,name,Studio_Chatter_Group__c from uw_Bet__c where id in : notLeadReguestRelatedBets]){
			betsMap.put(bet.id,bet);
		}
		List<FeedItem> feedToInsert = new List<FeedItem>();
		for(BET_Follow_Request__c req : notLeadRequests) {
			FeedItem f = new FeedItem();
        	f.Body = 'Project ' + req.Project_Name__c + ' has linked to BET ' + betsMap.get(req.Brand_Experience_Toolkit__c).name;
        	f.Type = 'TextPost';
        	f.ParentId = betsMap.get(req.Brand_Experience_Toolkit__c).Studio_Chatter_Group__c;
        	feedToInsert.add(f);
    	}

        insert feedToInsert;
	}

	/************************************************************
		Purpose: Method sets lead project on bet when there is no lead yet and ther is no lead request in batch
		Parameters: List<BET_Follow_Request__c> approvedRequests,Set<Id> leadReguestRelatedBets
		Returns: -
		Throws: -
	*************************************************************/
	private static void updateBetsWithLeadProjectsWhenThereIsNoLeadProjectOnBET(List<BET_Follow_Request__c> approvedRequests,Set<Id> leadReguestRelatedBets){
		Map<Id,uw_Bet__c> betMap = new Map<Id,uw_Bet__c>();
		Set<Id> betIds = new Set<Id>();
		for(BET_Follow_Request__c fr : approvedRequests){
			if(!leadReguestRelatedBets.contains(fr.Brand_Experience_Toolkit__c)){
				betIds.add(fr.Brand_Experience_Toolkit__c);
			}
		}
		for(uw_Bet__c bet : [select id,Launch_Date__c,IPM_Project__c,Category_Group__c,
							 Product_Category__c,Brand_Position__c 
							 from uw_Bet__c where id in : betIds and IPM_Project__c = null]){
			betMap.put(bet.id,bet);
		}
		Set<Id> processedBets = new Set<Id>();
		for(BET_Follow_Request__c request : approvedRequests){
			if(betMap.get(request.Brand_Experience_Toolkit__c) != null && !processedBets.contains(request.Brand_Experience_Toolkit__c)){
				IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper((Id)request.Project_Id__c);
				BET_LinkingService.updateBet(betMap.get(request.Brand_Experience_Toolkit__c),project);
				processedBets.add(request.Brand_Experience_Toolkit__c);
			}
		}
	}

	/************************************************************
		Purpose: Method updates Bet records if requests are lead
		Parameters: List<BET_Follow_Request__c> leadRequests
		Returns: -
		Throws: -
	*************************************************************/
	private static void updateBetsWithLeadProjects(List<BET_Follow_Request__c> leadRequests){
		Map<Id,uw_Bet__c> betMap = new Map<Id,uw_Bet__c>();
		Set<Id> betIds = new Set<Id>();
		for(BET_Follow_Request__c fr : leadRequests){
			betIds.add(fr.Brand_Experience_Toolkit__c);
		}
		for(uw_Bet__c bet : [select id,Launch_Date__c,IPM_Project__c,Category_Group__c,
							 Product_Category__c,Brand_Position__c 
							 from uw_Bet__c where id in : betIds]){
			betMap.put(bet.id,bet);
		}
		for(BET_Follow_Request__c request : leadRequests){
			IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper((Id)request.Project_Id__c);
			BET_LinkingService.updateBet(betMap.get(request.Brand_Experience_Toolkit__c),project);
		}
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
		rejectAllRelatedMemberRequests(getIds(rejectedRequests));
		notifyIPMProjectLeads(rejectedRequests,BET_LinkingService.FOLLOW_STATUS_REJECTED);
	}

	/************************************************************
		Purpose: Method notifies IPM if lead request has been approved or rejected
		Parameters: List<BET_Follow_Request__c> requests,String status
		Returns: -
		Throws: -
	*************************************************************/
	private static void notifyIPMProjectLeads(List<BET_Follow_Request__c> requests,String status){
		for(BET_Follow_Request__c request : requests){
			IPM_BETUpdateService.ipm_BETLinkingService((Id)request.Project_Id__c,request.Brand_Experience_Toolkit__c,status);
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
		updateRelatedMemberRequests(rejectedRequestsIds,BET_SuggestedMemberService.REJECTED);
	}

	/************************************************************
		Purpose: Method approves all member requests associated with follow requests
		Parameters: List<Id> rejectedRequestsIds
		Returns: -
		Throws: -
	*************************************************************/
	private static void approveAllRelatedMemberRequests(List<Id> approvedRequestsIds){
		updateRelatedMemberRequests(approvedRequestsIds,BET_SuggestedMemberService.APPROVED);
	}

	/************************************************************
		Purpose: Method updates status to member requests associated with follow requests
		Parameters: List<Id> requestsIds, String status
		Returns: -
		Throws: -
	*************************************************************/
	private static void updateRelatedMemberRequests(List<Id> requestsIds,String status){
		List<BET_Member_Request__c> relatedMemberRequest = [select id, Status__c from BET_Member_Request__c where 	ProjectRequest__c in: requestsIds];
		for(BET_Member_Request__c request : relatedMemberRequest){
			request.Status__c = status;
		}
		update relatedMemberRequest;
	}
}