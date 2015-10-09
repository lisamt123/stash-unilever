/* Service helper class takes sharings settings from parent class */
public class BET_LinkingServiceCleaner {

	private BET_LinkingServiceCleaner(){}
	
	/************************************************************
		Purpose: Method deletes project releted member requests and tem members
		Parameters: Id ProjectId, Id BetId
		Returns: -
		Throws: -
	*************************************************************/
	public static void removeIPMProjectMembersFromBet(Id ProjectId, Id BetId,Id betOwner){
		System.debug('Entering removeIPMProjectMembersFromBet : ' + ProjectId + ', ' + BetId);

		Set<Id> otherProjectsUserIds = new Set<Id>();
		for(BET_Member_Request__c orequest : [select id,Brand_Experience_Toolkit__c,UserId__c from BET_Member_Request__c where Status__c = 'Approved' and Project_Id__c !=: ProjectId and Brand_Experience_Toolkit__c =: BetId]){
			otherProjectsUserIds.add(orequest.UserId__c);
		}

		List<BET_Member_Request__c> requests = [select id,Brand_Experience_Toolkit__c,UserId__c from BET_Member_Request__c where Status__c = 'Approved' and Project_Id__c =: ProjectId and Brand_Experience_Toolkit__c =: BetId];
		Set<Id> userIds = new Set<Id>();
		for(BET_Member_Request__c request : requests){
			if(!otherProjectsUserIds.contains(request.UserId__c)){
				userIds.add(request.UserId__c);
			}
		}

		List<uw_BET_Team_Member__c> teamMembers = [select id from uw_BET_Team_Member__c where BET__c =: betId and Team_Member__c =: userIds and Team_Member__c !=: betOwner];
		System.debug('Exit removeIPMProjectMembersFromBet : ' + teamMembers);
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
		Purpose: Method removes bet member related to project Lead. 
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
		Purpose: Method removes bet member related to project Lead.
		Parameters: Id oldBetOwner,uw_Bet__c bet
		Returns: -
		Throws: -
	*************************************************************/
	public static void removeOldPLFromMembers(Id oldPL,uw_Bet__c bet,Id ProjectId){
		System.debug('Entering removeOldPLFromMembers : ' + oldPL + ', ' + bet);

		Set<Id> otherProjectsUserIds = new Set<Id>();
		for(BET_Member_Request__c orequest : [select id,Brand_Experience_Toolkit__c,UserId__c from BET_Member_Request__c where Status__c = 'Approved' and Project_Id__c !=: ProjectId and Brand_Experience_Toolkit__c =: bet.id]){
			otherProjectsUserIds.add(orequest.UserId__c);
		}

		List<uw_BET_Team_Member__c> pLead = [select id from uw_BET_Team_Member__c where BET__c =: bet.id and Team_Member__c =: oldPL and Team_Member__c not in : otherProjectsUserIds];
		delete pLead;
		System.debug('Entering removeOldPLFromMembers');
	}
	

}