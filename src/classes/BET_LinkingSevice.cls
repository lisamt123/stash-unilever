/*************************************************************************************
Name : BET_LinkingSevice

Purpose : Bet to IPM project linking service class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  03-08-2015  Initial
*************************************************************************************/
public with sharing class BET_LinkingSevice {

	private static final String FOLLOW_STATUS_NEW = 'New';
	private static final String FOLLOW_STATUS_APPROVED = 'Approved';

	private BET_LinkingSevice() {}

	 /************************************************************
		Purpose: Method sets given project as lead for given bet
		Parameters: Id Ipm project id , Id related BET record
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/
	public static void setASLead(Id ProjectId, Id BetId){
		try{
			System.debug('Entering setASLead : ' + ProjectId + ', ' + BetId);
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_SetAsLeadExceptionMessage,e);
		}
		System.debug('Exit setASLead');
	}

    /************************************************************
		Purpose: Method creates ipm project's follow request
		Parameters: Id Ipm project id , Id related BET record, list of managers
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/
	public static void Follow(Id ProjectId, Id BetId, List<Id> managersIds){
		try{
			System.debug('Entering Follow : ' + ProjectId + ', ' + BetId + ', ' + managersIds);
			List<uw_Bet__c> betRecords = [select id, ownerid, Is_Archived__c from uw_Bet__c where id =: BetId];
			List<IPM_Project__c> projects = [select id,name from IPM_Project__c where id=:ProjectId];
			if(betRecords.isEmpty()){
				throw new BET_CustomBETException(Label.BET_FollowBetNotExistsMessage);
			} else if(projects.isEmpty()){
				throw new BET_CustomBETException(Label.BET_FollowProjectNotExistsMessage);
			} else if(betRecords.get(0).Is_Archived__c) {
				throw new BET_CustomBETException(Label.BET_FollowBetArchivedMessage);
			}
			Boolean shouldBeAutoApproved = checkIfFollowRequestShouldBeAutoapproved(betRecords.get(0),managersIds);
			BET_Follow_Request__c followRequest = createFollowRequest(projects.get(0),betRecords.get(0),managersIds,shouldBeAutoApproved);
			crateRelatedMemberRequests(followRequest,betRecords.get(0),managersIds);
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_FollowExceptionMessage,e);
		}
		System.debug('Exit Follow');
	}

	@TestVisible
	private static BET_Follow_Request__c createFollowRequest(IPM_Project__c project, uw_Bet__c bet, List<Id> managersIds,Boolean autoApproved){
		System.debug('Entering createFollowRequest : ' + project + ', ' + bet + ', ' + managersIds + ', ' + autoApproved);
		BET_Follow_Request__c request = new BET_Follow_Request__c();
		request.Brand_Experience_Toolkit__c = bet.id;
		request.Project_Id__c = project.id;
		request.Status__c = autoApproved ? FOLLOW_STATUS_APPROVED : FOLLOW_STATUS_NEW;
		request.Project_Name__c = project.name;
		insert request;
		System.debug('Exit createFollowRequest : ' + request);
		return request;
	}

	@TestVisible
	private static Boolean checkIfFollowRequestShouldBeAutoapproved(uw_Bet__c relatedBet , List<Id> managersIds){
		System.debug('Entering checkIfFollowRequestShouldBeAutoapproved : ' + relatedBet + ', ' + managersIds);
		Set<Id> managersSet = new Set<Id>();
		managersSet.addAll(managersIds);
		System.debug('Exit checkIfFollowRequestShouldBeAutoapproved : ' + managersSet.contains(relatedBet.ownerId));
		return managersSet.contains(relatedBet.ownerId);
	}

	@TestVisible
	private static List<Id> crateRelatedMemberRequests(BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,List<Id> managersIds){
		System.debug('Entering crateRelatedMemberRequests : ' + followRequest + ', ' + relatedBet + ', ' + managersIds);
		List<BET_Member_Request__c> mRequestsToBeCreated = new List<BET_Member_Request__c>();
		for(Id managerId : managersIds){
			mRequestsToBeCreated.add( new BET_Member_Request__c(Brand_Experience_Toolkit__c=relatedBet.id,
																UserId__c=managerId,
																ProjectRequest__c=followRequest.id));
		}
		insert mRequestsToBeCreated;
		List<Id> requestIds = new List<Id>();
		for(BET_Member_Request__c mrequest : mRequestsToBeCreated){
			requestIds.add(mrequest.id);
		}
		System.debug('Exit crateRelatedMemberRequests : ' + requestIds);
		return requestIds;
	}

    /************************************************************
		Purpose: Method creates ipm project's unfollow request
		Parameters: Id Ipm project id , Id related BET record
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/
	public static void UnFollow(Id ProjectId, Id BetId){
		try{
			System.debug('Entering UnFollow : ' + ProjectId + ', ' + BetId);
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_UnFollowExceptionMessage,e);
		}
		System.debug('Exit UnFollow');
	}
}