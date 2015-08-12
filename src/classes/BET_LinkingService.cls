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
		validateParams(betRecords,projects);
		try{
			updateBetRecord(betRecords.get(0),projects.get(0));
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_SetAsLeadExceptionMessage,e);
		}
		System.debug('Exit setASLead');
	}

	public static void updateBetRecord(uw_Bet__c bet,IPM_Project__c project){
		updateBet(bet,project.id);
	}

	public static void updateBet(uw_Bet__c bet,Id projectId){
		IPM_BETWrapper projectWrapper = IPM_BETUpdateService.ipm_Wrapper(projectId);
		bet.Launch_Date__c = projectWrapper.targetLaunchDate;
		bet.IPM_Project__c = projectWrapper.projectId;
		bet.Category_Group__c = projectWrapper.categoryGroupName;
		bet.Product_Category__c = projectWrapper.categoryName;
		bet.Brand_Position__c = projectWrapper.brandPosition;
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
		validateFollowRequest(betRecords,projects);
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
		Purpose: Method validates inital parameters
		Parameters: List<uw_Bet__c> betRecords,List<IPM_Project__c> projects 
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/	
	private static void validateFollowRequest(List<uw_Bet__c> betRecords,List<IPM_Project__c> projects ){
		System.debug('Entering validateFollowRequest : ' + betRecords + ', ' + projects);
		if(betRecords.isEmpty()){
			throw new BET_CustomBETException(Label.BET_FollowBetNotExistsMessage);
		} else if(projects.isEmpty()){
			throw new BET_CustomBETException(Label.BET_FollowProjectNotExistsMessage);
		} else if(betRecords.get(0).Is_Archived__c) {
			throw new BET_CustomBETException(Label.BET_FollowBetArchivedMessage);
		}
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
		validateParams(betRecords,projects);
		try{
			Boolean projectIsALead = isProjectALead(ProjectId,betRecords.get(0));
			if(projectIsALead){
				List<IPM_Project__c> otherFollowProjects = getOtherFollowingProjects(ProjectId,BetId);
				if(otherFollowProjects.isEmpty()){
					archiveAndUnLeadBet(betRecords.get(0)); //US26
					BET_EmailNotificationService.notifyBetOwnerOfUnfollow(betRecords.get(0),projects.get(0)); //US22
				} else {
					setNewLeadProjectAndOwner(betRecords.get(0),otherFollowProjects.get(0),projects.get(0));
					BET_EmailNotificationService.notifyBetOwnerAndProjectLeadOfNewLeadProject(betRecords.get(0),otherFollowProjects.get(0),projects.get(0));
				}
			}
			removeIPMProjectMembersFromBet(ProjectId,BetId); //US25
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_UnFollowExceptionMessage,e);
		}
		System.debug('Exit UnFollow');
	}

	/************************************************************
		Purpose: Method validates inital parameters
		Parameters: List<uw_Bet__c> betRecords,List<IPM_Project__c> projects 
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/	
	private static void validateParams(List<uw_Bet__c> betRecords,List<IPM_Project__c> projects){
		System.debug('Entering validateParams : ' + betRecords + ', ' + projects);
		if(betRecords.isEmpty()){
			throw new BET_CustomBETException(Label.BET_FollowBetNotExistsMessage);
		} else if(projects.isEmpty()){
			throw new BET_CustomBETException(Label.BET_FollowProjectNotExistsMessage);
		}
	}

	/************************************************************
		Purpose: Method indicates if given project is bet lead
		Parameters: Id ProjectId, uw_Bet__c bet
		Returns: Boolean
		Throws: -
	*************************************************************/	
	private static Boolean isProjectALead(Id ProjectId, uw_Bet__c bet){
		System.debug('Entering isProjectALead : ' + bet + ', ' + ProjectId);
		Boolean result = bet.IPM_Project__c != null && bet.Inoplan_Project__c == ProjectId;
		System.debug('Exit isProjectALead : ' + result);
		return result;
	}

	/************************************************************
		Purpose: Method retreives other following projects than current lead project
		Parameters: Id ProjectId, Id BetId
		Returns: List<IPM_Project__c> list with one element
		Throws: -
	*************************************************************/	
	private static List<IPM_Project__c> getOtherFollowingProjects(Id ProjectId, Id BetId){
		System.debug('Entering getOtherFollowingProjects : ' + ProjectId + ', ' + BetId);
		List<String> projectsList = new List<String>();
		List<BET_Follow_Request__c> approvedRequests = [select Project_Id__c from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId and Status__c =: FOLLOW_STATUS_APPROVED];
		for(BET_Follow_Request__c aRequest : approvedRequests){
			projectsList.add(aRequest.Project_Id__c);
		}
		List<IPM_Project__c> followingProjects = [select id,IPM_Project_Leader__c from IPM_Project__c where id in : projectsList and id !=: ProjectId order by IPM_Target_Launch_Dates__c asc limit 1];
		System.debug('Exit getOtherFollowingProjects : ' + followingProjects);
		return followingProjects;
	}

	/************************************************************
		Purpose: Method archives and sets ipm project to null
		Parameters: uw_Bet__c bet
		Returns: -
		Throws: -
	*************************************************************/	
	private static void archiveAndUnLeadBet(uw_Bet__c bet){
		System.debug('Entering archiveAndUnLeadBet : ' + bet);
		bet.Is_Archived__c = true;
		bet.IPM_Project__c = null;
		update bet;
		System.debug('Exit archiveAndUnLeadBet : ' + bet);
	}

	/************************************************************
		Purpose: Method sets new lead project and new owner if necessary
		Parameters: uw_Bet__c bet, IPM_Project__c project, IPM_Project__c oldProject
		Returns: -
		Throws: -
	*************************************************************/
	private static void setNewLeadProjectAndOwner(uw_Bet__c bet, IPM_Project__c project,IPM_Project__c oldProject){
		System.debug('Entering setNewLeadProjectAndOwner : ' + bet + ', ' + project + ', ' + oldProject);
		if(oldProject.IPM_Project_Leader__c != null && oldProject.IPM_Project_Leader__c == bet.ownerId){
			bet.ownerId = project.IPM_Project_Leader__c;
		}
		bet.IPM_Project__c = project.id;
		update bet;
		System.debug('Exit setNewLeadProjectAndOwner : ' + bet);
	}

	/************************************************************
		Purpose: Method deletes project releted member requests and tem members
		Parameters: Id ProjectId, Id BetId
		Returns: -
		Throws: -
	*************************************************************/
	private static void removeIPMProjectMembersFromBet(Id ProjectId, Id BetId){
		System.debug('Entering setNewLeadProjectAndOwner : ' + ProjectId + ', ' + BetId);
		List<BET_Member_Request__c> requests = [select id,Brand_Experience_Toolkit__c,UserId__c from BET_Member_Request__c where Project_Id__c =: ProjectId and Brand_Experience_Toolkit__c =: BetId];
		Set<Id> userIds = new Set<Id>();
		for(BET_Member_Request__c request : requests){
			userIds.add(request.UserId__c);
		}
		List<uw_BET_Team_Member__c> teamMembers = [select id from uw_BET_Team_Member__c where BET__c =: betId and Team_Member__c =: userIds];
		System.debug('Exit setNewLeadProjectAndOwner : ' + requests + ', '+teamMembers);
		delete requests;
		delete teamMembers;
	}
}