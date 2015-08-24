public class BET_LinkingServiceHelper {

	private BET_LinkingServiceHelper() {}

	/************************************************************
		Purpose: Method validates inital parameters
		Parameters: List<uw_Bet__c> betRecords
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/	
	public static void validateFollowRequest(List<uw_Bet__c> betRecords){
		System.debug('Entering validateFollowRequest : ' + betRecords);
		if(betRecords.isEmpty()){
			throw new BET_CustomBETException(Label.BET_FollowBetNotExistsMessage);
		} else if(betRecords.get(0).Is_Archived__c) {
			throw new BET_CustomBETException(Label.BET_FollowBetArchivedMessage);
		}
		System.debug('Exit validateFollowRequest');
	}

	/************************************************************
		Purpose: Method validates inital parameters
		Parameters: List<uw_Bet__c> betRecords
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/	
	public static void validateParams(List<uw_Bet__c> betRecords){
		System.debug('Entering validateParams : ' + betRecords);
		if(betRecords.isEmpty()){
			throw new BET_CustomBETException(Label.BET_FollowBetNotExistsMessage);
		}
	}

	/************************************************************
		Purpose: Method indicates if given project is bet lead
		Parameters: Id ProjectId, uw_Bet__c bet
		Returns: Boolean
		Throws: -
	*************************************************************/	
	public static Boolean isProjectALead(Id ProjectId, uw_Bet__c bet){
		System.debug('Entering isProjectALead : ' + bet + ', ' + ProjectId);
		Boolean result = bet.IPM_Project__c != null && bet.IPM_Project__c == ProjectId;
		System.debug('Exit isProjectALead : ' + result);
		return result;
	}

	/************************************************************
		Purpose: Method retreives other following projects than current lead project
		Parameters: Id ProjectId, Id BetId
		Returns: List<IPM_Project__c> list with one element
		Throws: -
	*************************************************************/	
	public static List<IPM_Project__c> getOtherFollowingProjects(Id ProjectId, Id BetId){
		System.debug('Entering getOtherFollowingProjects : ' + ProjectId + ', ' + BetId);
		List<String> projectsList = new List<String>();
		List<BET_Follow_Request__c> approvedRequests = [select Project_Id__c from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId and Status__c =: BET_LinkingService.FOLLOW_STATUS_APPROVED];
		for(BET_Follow_Request__c aRequest : approvedRequests){
			projectsList.add(aRequest.Project_Id__c);
		}
		List<IPM_Project__c> followingProjects = [select id,IPM_Project_Leader__c,name from IPM_Project__c where id in : projectsList and id !=: ProjectId order by IPM_Target_Launch_Dates__c asc limit 1];
		System.debug('Exit getOtherFollowingProjects : ' + followingProjects);
		return followingProjects;
	}

	/************************************************************
		Purpose: Method archives and sets ipm project to null
		Parameters: uw_Bet__c bet
		Returns: -
		Throws: -
	*************************************************************/	
	public static void archiveAndUnLeadBet(uw_Bet__c bet){
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
	public static uw_Bet__c setNewLeadProjectAndOwner(uw_Bet__c bet, IPM_Project__c project,IPM_BETWrapper oldProject){
		System.debug('Entering setNewLeadProjectAndOwner : ' + bet + ', ' + project + ', ' + oldProject);
		if(oldProject.pLId != null && oldProject.pLId == bet.ownerId){
			bet.ownerId = project.IPM_Project_Leader__c;
		} else {
			BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,oldProject); //US23
		}
		BET_EmailNotificationService.notifyBetOwnerAndProjectLeadOfNewLeadProject(bet,project); //US23
		bet.IPM_Project__c = project.id;
		update bet;
		System.debug('Exit setNewLeadProjectAndOwner : ' + bet);
		return bet;
	}

	/************************************************************
		Purpose: Method deletes project releted member requests and tem members
		Parameters: Id ProjectId, Id BetId
		Returns: -
		Throws: -
	*************************************************************/
	public static void removeIPMProjectMembersFromBet(Id ProjectId, Id BetId,Id betOwner){
		System.debug('Entering setNewLeadProjectAndOwner : ' + ProjectId + ', ' + BetId);
		List<BET_Member_Request__c> requests = [select id,Brand_Experience_Toolkit__c,UserId__c from BET_Member_Request__c where Project_Id__c =: ProjectId and Brand_Experience_Toolkit__c =: BetId];
		Set<Id> userIds = new Set<Id>();
		for(BET_Member_Request__c request : requests){
			userIds.add(request.UserId__c);
		}
		List<uw_BET_Team_Member__c> teamMembers = [select id from uw_BET_Team_Member__c where BET__c =: betId and Team_Member__c =: userIds and Team_Member__c !=: betOwner];
		System.debug('Exit setNewLeadProjectAndOwner : ' + requests + ', '+teamMembers);
		delete requests;
		delete teamMembers;
	}

	/************************************************************
		Purpose: Method deletes project releted project follow requests
		Parameters: Id ProjectId, Id BetId
		Returns: -
		Throws: -
	*************************************************************/
	public static void removeIPMProjectFollowRequestsFromBet(Id ProjectId, Id BetId){
		System.debug('Entering removeIPMProjectFollowRequestsFromBet : ' + ProjectId + ', ' + BetId);
		delete [select id from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId and Project_Id__c =: ProjectId];
		System.debug('Exit removeIPMProjectFollowRequestsFromBet');
	}

	/************************************************************
		Purpose: Method removes bet member related to owner. This record does not have corresponding member request so it should be removed separately
		Parameters: Id oldBetOwner,uw_Bet__c bet
		Returns: -
		Throws: -
	*************************************************************/
	public static void removeOldBetOwnerFromMembers(Id oldBetOwner,uw_Bet__c bet){
		System.debug('Entering removeOldBetOwnerFromMembers : ' + oldBetOwner + ', ' + bet);
		List<uw_BET_Team_Member__c> owner = [select id from uw_BET_Team_Member__c where IsOwner__c = true and BET__c =: bet.id and Team_Member__c =: oldBetOwner];
		delete owner;
		System.debug('Entering removeIPMProjectFollowRequestsFromBet');
	}

	/************************************************************
		Purpose: Method removes bet member related to project Lead. This record does not have corresponding member request so it should be removed separately
		Parameters: Id oldBetOwner,uw_Bet__c bet
		Returns: -
		Throws: -
	*************************************************************/
	public static void removeOldPLFromMembers(Id oldPL,uw_Bet__c bet){
		System.debug('Entering removeOldPLFromMembers : ' + oldPL + ', ' + bet);
		List<uw_BET_Team_Member__c> pLead = [select id from uw_BET_Team_Member__c where BET__c =: bet.id and Team_Member__c =: oldPL];
		delete pLead;
		System.debug('Entering removeOldPLFromMembers');
	}

	/************************************************************
		Purpose: Method creates member requests
		Parameters: BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,String Role, String user
		Returns: BET_Member_Request__c object
		Throws: -
	*************************************************************/
	public static BET_Member_Request__c createMemberRequest(BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,String Role, String user){
		return new BET_Member_Request__c(Brand_Experience_Toolkit__c = relatedBet.id, UserId__c = user, Role__c = role,
										ProjectRequest__c = followRequest.id, Project_Id__c = followRequest.Project_Id__c, BET_owner__c = relatedBet.ownerid);
	}

	/************************************************************
		Purpose: Method creates manager requests for new PL
		Parameters: Id newPL,uw_Bet__c bet, IPM_Project__c newProject
		Returns: -
		Throws: -
	*************************************************************/
	public static void createMemberRequestForNewPL(Id newPL,uw_Bet__c bet, IPM_BETWrapper newProject){
		BET_Member_Request__c request = new BET_Member_Request__c(Brand_Experience_Toolkit__c = bet.id, UserId__c = newPL, Role__c = 'Manager',
							  Project_Id__c = newProject.projectId, BET_owner__c = bet.ownerid, Status__c = 'New');
		insert request;
		request.Status__c = 'Approved';
		update request;
	}
}