/*************************************************************************************
Name : BET_LinkingService

Purpose : Bet to IPM project linking service class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  03-08-2015  Initial
*************************************************************************************/
public with sharing class BET_LinkingService {

	public static final String FOLLOW_STATUS_NEW = 'New';
	public static final String FOLLOW_STATUS_APPROVED = 'Approved';
	public static final String FOLLOW_STATUS_REJECTED = 'Rejected';

	private BET_LinkingService() {}

	/************************************************************
		Purpose: Method sets given project as lead for given bet
		Parameters: Id Ipm project id , Id related BET record
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/
	public static void setASLead(Id ProjectId, Id BetId){
		System.debug('Entering setASLead : ' + ProjectId + ', ' + BetId);
		List<uw_Bet__c> betRecords = [select id, ownerid, Is_Archived__c, IPM_Project__c, Launch_Date__c from uw_Bet__c where id =: BetId];
		List<IPM_Project__c> projects = [select id,name,IPM_Target_Launch_Dates__c from IPM_Project__c where id=:ProjectId];
		BET_LinkingServiceHelper.validateParams(betRecords,projects);
		try{
			updateBetRecord(betRecords.get(0),projects.get(0));
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_SetAsLeadExceptionMessage,e);
		}
		System.debug('Exit setASLead');
	}

	/************************************************************
		Purpose: Method updates bet record based on given project
		Parameters: uw_Bet__c bet,IPM_Project__c project
		Returns: -
		Throws: -
	*************************************************************/
	public static void updateBetRecord(uw_Bet__c bet,IPM_Project__c project){
		updateBet(bet,project.id);
	}

	/************************************************************
		Purpose: Method updates bet record based on given project
		Parameters: uw_Bet__c bet,Id projectId
		Returns: -
		Throws: -
	*************************************************************/
	public static void updateBet(uw_Bet__c bet,Id projectId){
		IPM_BETWrapper projectWrapper = IPM_BETUpdateService.ipm_Wrapper(projectId);
		System.debug('projectWrapper ' + projectWrapper + ' , ' +projectId);
		bet.Launch_Date__c = projectWrapper.targetLaunchDate;
		bet.IPM_Project__c = projectWrapper.projectId;
		try{
			bet.Category_Group__c = projectWrapper.categoryGroupName;
			bet.Product_Category__c = projectWrapper.categoryName;
			bet.Brand_Position__c = projectWrapper.brandPosition;
		} catch(Exception e){
			System.debug(e);
		}
		update bet;
	}

    /************************************************************
		Purpose: Method creates ipm project's follow request
		Parameters: Id Ipm project id , Id related BET record, list of managers
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/
	public static void Follow(Id ProjectId, Id BetId, List<Id> managersIds){
		System.debug('Entering Follow : ' + ProjectId + ', ' + BetId + ', ' + managersIds);
		List<uw_Bet__c> betRecords = [select id, ownerid, Is_Archived__c, IPM_Project__c from uw_Bet__c where id =: BetId];
		List<IPM_Project__c> projects = [select id,name from IPM_Project__c where id=:ProjectId];
		BET_LinkingServiceHelper.validateFollowRequest(betRecords,projects);
		try{
			Boolean shouldBeAutoApproved = checkIfFollowRequestShouldBeAutoapproved(betRecords.get(0),managersIds);
			BET_Follow_Request__c followRequest = createFollowRequest(projects.get(0),betRecords.get(0),managersIds,shouldBeAutoApproved);
			createRelatedMemberRequests(followRequest,betRecords.get(0),managersIds);
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_FollowExceptionMessage,e);
		}
		System.debug('Exit Follow');
	}

	/************************************************************
		Purpose: Method creates ipm project's follow request record
		Parameters: IPM_Project__c project , uw_Bet__c bet, list of managers, list of managers, Boolean autoApproved
		Returns: BET_Follow_Request__c record
		Throws: -
	*************************************************************/
	@TestVisible
	private static BET_Follow_Request__c createFollowRequest(IPM_Project__c project, uw_Bet__c bet, List<Id> managersIds,Boolean autoApproved){
		System.debug('Entering createFollowRequest : ' + project + ', ' + bet + ', ' + managersIds + ', ' + autoApproved);
		BET_Follow_Request__c request = new BET_Follow_Request__c();
		request.Brand_Experience_Toolkit__c = bet.id;
		request.Project_Id__c = project.id;
		request.Status__c = autoApproved ? FOLLOW_STATUS_APPROVED : FOLLOW_STATUS_NEW;
		request.Project_Name__c = project.name;
		request.Project_Lead__c = managersIds.get(0);
		request.Is_Lead_Request__c = shouldMarkRequestAsLeadRequest(bet);
		request.Bet_owner__c = bet.ownerId;
		insert request;
		System.debug('Exit createFollowRequest : ' + request);
		return request;
	}

	/************************************************************
		Purpose: Method checks if reuest should be marked as lead
		Parameters: uw_Bet__c bet
		Returns: Boolean indicator
		Throws: -
	*************************************************************/
	@TestVisible
	private static Boolean shouldMarkRequestAsLeadRequest(uw_Bet__c bet){
		System.debug('Entering shouldMarkRequestAsLeadRequest : ' + bet);
		Boolean indicator = true;
		if(bet.IPM_Project__c != null) indicator = false;
		if(indicator) {
			List<BET_Follow_Request__c> requestsForGivenBet = [select id from BET_Follow_Request__c 
														    where Brand_Experience_Toolkit__c =: bet.id 
															and Status__c !=: FOLLOW_STATUS_REJECTED 
															and Is_Lead_Request__c = true];
			if(!requestsForGivenBet.isEmpty()) indicator = false;
		}
		System.debug('Exit shouldMarkRequestAsLeadRequest : ' + indicator);
		return indicator;
	}

	/************************************************************
		Purpose: Method checks if request should be autoapprove
		Parameters: uw_Bet__c relatedBet, list of managers
		Returns: Boolean indicator
		Throws: -
	*************************************************************/
	@TestVisible
	private static Boolean checkIfFollowRequestShouldBeAutoapproved(uw_Bet__c relatedBet , List<Id> managersIds){
		System.debug('Entering checkIfFollowRequestShouldBeAutoapproved : ' + relatedBet + ', ' + managersIds);
		Set<Id> managersSet = new Set<Id>();
		managersSet.addAll(managersIds);
		System.debug('Exit checkIfFollowRequestShouldBeAutoapproved : ' + managersSet.contains(relatedBet.ownerId));
		return managersSet.contains(relatedBet.ownerId);
	}

	/************************************************************
		Purpose: Method created related member requests
		Parameters: BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,List<Id> managersIds
		Returns: List of member requests Ids
		Throws: -
	*************************************************************/
	@TestVisible
	private static List<Id> createRelatedMemberRequests(BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,List<Id> managersIds){
		System.debug('Entering crateRelatedMemberRequests : ' + followRequest + ', ' + relatedBet + ', ' + managersIds);
		List<BET_Member_Request__c> mRequestsToBeCreated = new List<BET_Member_Request__c>();
		for(Id managerId : managersIds){
			mRequestsToBeCreated.add( new BET_Member_Request__c(Brand_Experience_Toolkit__c = relatedBet.id,
																UserId__c = managerId,
																Role__c = 'Manager',
																ProjectRequest__c = followRequest.id,
																Project_Id__c = followRequest.Project_Id__c,
																BET_owner__c = relatedBet.ownerid));
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
		4.12.
		3.5.
	*************************************************************/
	public static void UnFollow(Id ProjectId, Id BetId){ //US 23
		System.debug('Entering UnFollow : ' + ProjectId + ', ' + BetId);
		List<uw_Bet__c> betRecords = [select id, ownerid, Is_Archived__c, IPM_Project__c from uw_Bet__c where id =: BetId];
		List<IPM_Project__c> projects = [select id,name,IPM_Project_Leader__c from IPM_Project__c where id=:ProjectId];
		BET_LinkingServiceHelper.validateParams(betRecords,projects);
		try{
			Boolean projectIsALead = BET_LinkingServiceHelper.isProjectALead(ProjectId,betRecords.get(0));
			if(projectIsALead){
				List<IPM_Project__c> otherFollowProjects = BET_LinkingServiceHelper.getOtherFollowingProjects(ProjectId,BetId);
				if(otherFollowProjects.isEmpty()){
					BET_LinkingServiceHelper.archiveAndUnLeadBet(betRecords.get(0)); //US26
					BET_EmailNotificationService.notifyBetOwnerOfUnfollow(betRecords.get(0),projects.get(0)); //US22
				} else {
					BET_LinkingServiceHelper.setNewLeadProjectAndOwner(betRecords.get(0),otherFollowProjects.get(0),projects.get(0));
				}
			}
			BET_LinkingServiceHelper.removeIPMProjectFollowRequestsFromBet(ProjectId,BetId);
			BET_LinkingServiceHelper.removeIPMProjectMembersFromBet(ProjectId,BetId); //US25
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_UnFollowExceptionMessage,e);
		}
		System.debug('Exit UnFollow');
	}
}