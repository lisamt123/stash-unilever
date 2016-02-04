/* Helper class takes sharing settings from its 'parent' */
public class BET_FollowRequestTriggerHandlerClsHelper {

	private BET_FollowRequestTriggerHandlerClsHelper() {}

	/************************************************************
		Purpose: Method created chatter feeds when project is following bet
		Parameters: List<BET_Follow_Request__c> notLeadRequests,Set<Id> notLeadReguestRelatedBets
		Returns: -
		Throws: -
	*************************************************************/
	public static void createFollowProjectChatterFeeds(List<BET_Follow_Request__c> notLeadRequests,Set<Id> notLeadReguestRelatedBets){
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
	public static void updateBetsWithLeadProjectsWhenThereIsNoLeadProjectOnBET(List<BET_Follow_Request__c> approvedRequests,Set<Id> leadReguestRelatedBets){
		Map<Id,uw_Bet__c> betMap = new Map<Id,uw_Bet__c>();
		Set<Id> betIds = new Set<Id>();
		for(BET_Follow_Request__c fr : approvedRequests){
			if(!leadReguestRelatedBets.contains(fr.Brand_Experience_Toolkit__c)){
				betIds.add(fr.Brand_Experience_Toolkit__c);
			}
		}
		for(uw_Bet__c bet : [select id,Launch_Date__c,IPM_Project__c,Category_Group__c,
							 Product_Category__c,Brand_Position__c,Inoplan_Project_Keyword_Search__c
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
	public static void updateBetsWithLeadProjects(List<BET_Follow_Request__c> leadRequests){
		Map<Id,uw_Bet__c> betMap = new Map<Id,uw_Bet__c>();
		Set<Id> betIds = new Set<Id>();
		for(BET_Follow_Request__c fr : leadRequests){
			betIds.add(fr.Brand_Experience_Toolkit__c);
		}
		for(uw_Bet__c bet : [select id,Launch_Date__c,IPM_Project__c,Category_Group__c,
							 Product_Category__c,Brand_Position__c,Inoplan_Project_Keyword_Search__c 
							 from uw_Bet__c where id in : betIds]){
			betMap.put(bet.id,bet);
		}
		for(BET_Follow_Request__c request : leadRequests){
			IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper((Id)request.Project_Id__c);
			BET_LinkingService.updateBet(betMap.get(request.Brand_Experience_Toolkit__c),project);
		}
	}

	/************************************************************
		Purpose: Method notifies IPM if lead request has been approved or rejected
		Parameters: List<BET_Follow_Request__c> requests,String status
		Returns: -
		Throws: -
	*************************************************************/
	public static void notifyIPMProjectLeads(List<BET_Follow_Request__c> requests,String status){
		if(!Test.isRunningTest()){
			for(BET_Follow_Request__c request : requests){
				IPM_BETUpdateService.ipm_BETLinkingService((Id)request.Project_Id__c,request.Brand_Experience_Toolkit__c,status);
			}
		}
	}

	/************************************************************
		Purpose: Method retrieves list of request ids for given request list
		Parameters: List<BET_Follow_Request__c> requests
		Returns: List<Id>
		Throws: -
	*************************************************************/
	public static List<Id> getIds(List<BET_Follow_Request__c> requests){
		List<Id> requestIds = new List<Id>();
		for(BET_Follow_Request__c request : requests){
			requestIds.add(request.id);
		}
		return requestIds;
	}

	/************************************************************
		Purpose: Method updates status to member requests associated with follow requests
		Parameters: List<Id> requestsIds, String status
		Returns: -
		Throws: -
	*************************************************************/
	public static void updateRelatedMemberRequests(List<Id> requestsIds,String status){
		List<BET_Member_Request__c> relatedMemberRequest = [select id, Status__c from BET_Member_Request__c where 	ProjectRequest__c in: requestsIds];
		for(BET_Member_Request__c request : relatedMemberRequest){
			request.Status__c = status;
		}
		update relatedMemberRequest;
	}

}