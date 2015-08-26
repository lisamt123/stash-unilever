/*************************************************************************************
Name : BET_AccessService

Purpose : Access service class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  23-07-2015  Initial
*************************************************************************************/
public with sharing class BET_AccessService {
	

	private static final String NO_BET_ACCESS = 'No';
	private static final String BET_MEMBER = 'Member';
	private static final String BET_MANAGER = 'Manager';
	private static final String BET_OWNER = 'Owner';
	private static final String BET_ACCESS_PENDING = 'Pending';

	private static final String MANAGER_ROLE = 'Manager';
	private static final String MEMBER_ROLE = 'Member';


	private BET_AccessService(){}

	/************************************************************
		Purpose: Method checks if user has access to bet
		Parameters: Id of related user , Id of related bet
		Returns: Status String (“No”, “Member”,”Manager “, “Owner”, “Pending”)
		Throws: BET_CustomBETException
	*************************************************************/
	public static String HasUserAccess(Id userId,Id betId){
		System.debug('Entering HasUserAccess : ' + userId + ', ' + betId);
		String status = NO_BET_ACCESS;
		try{
			List<uw_BET_Team_Member__c> teamMembersRecords = [select Role__c, IsOwner__c, 
			Invite_Pending__c from uw_BET_Team_Member__c 
			where Team_Member__c =:userId 
			and BET__c =: betId limit 1];

			if(!teamMembersRecords.isEmpty()){
				uw_BET_Team_Member__c tMember = teamMembersRecords.get(0);
				status = getStatus(tMember);
				if(status == NO_BET_ACCESS && checkIfRequestAccessIsPending(userId,betId)){
					status = BET_ACCESS_PENDING;
				}
			}
		}catch(Exception e){
			throw new BET_CustomBETException('Unable to check user access',e);
		}
		System.debug('Exit HasUserAccess : ' + status);
		return status;
	}

	/************************************************************
		Purpose: Method returns status of user access;
		Parameters: Team member records
		Returns: Status String (“No”, “Member”,”Manager “, “Owner”, “Pending”)
		Throws: -
	*************************************************************/
	@TestVisible
	private static String getStatus(uw_BET_Team_Member__c tMember){
		System.debug('Entering getStatus : ' + tMember);
		String status = NO_BET_ACCESS;
		if(tMember.IsOwner__c){
			status = BET_OWNER;
		} else if(tMember.Role__c == MANAGER_ROLE){
			status = BET_MANAGER;
		} else if(tMember.Role__c == MEMBER_ROLE){
			status = BET_MEMBER;
		}
		System.debug('Exit getStatus : ' + status);
		return status;
	}

	@TestVisible
	private static Boolean checkIfRequestAccessIsPending(Id userId,Id betId){
		System.debug('Entering checkIfRequestAccessIsPending : ' + userId + ', ' + betId);
		List<BET_Member_Request__c> requests = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: betId and UserId__c =: userId and Status__c = 'New'];
		System.debug('Exit checkIfRequestAccessIsPending : ' + !requests.isEmpty());
		return !requests.isEmpty();
	}

	/************************************************************
		Purpose: Method creates access requests
		Parameters: List of member requests, Id of related bet
		Returns: List od Id of a created requests
		Throws: BET_CustomBETException
	*************************************************************/
	public static List<Id> RequestAccess(List<BET_BETWrapper.MemberRequest> memberRequests, Id betId){
		System.debug('Entering RequestAccess : ' + memberRequests + ', ' + betId);
		List<Id> requestIds = new List<Id>();
		Boolean isOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betId, UserInfo.getUserId());
		try{
			List<BET_Member_Request__c> mRequestsToBeCreated = new List<BET_Member_Request__c>();
			for(BET_BETWrapper.MemberRequest request : memberRequests){
				mRequestsToBeCreated.add(
					new BET_Member_Request__c(
						Brand_Experience_Toolkit__c=betId,
						UserId__c=request.UserId,
						Role__c = request.AccessLevel,
						Status__c= isOwnerOrManager ? BET_LinkingService.FOLLOW_STATUS_APPROVED : BET_LinkingService.FOLLOW_STATUS_NEW)
				);
			}
			insert mRequestsToBeCreated;
			for(BET_Member_Request__c mrequest : mRequestsToBeCreated){
				requestIds.add(mrequest.id);
			}
		}catch(Exception e){
			throw new BET_CustomBETException('Unable to create access request',e);
		}
		System.debug('Exit RequestAccess : ' + requestIds);
		return requestIds;
	}

	/************************************************************
		Purpose: Method creates access request
		Parameters: User email, Id of related bet
		Returns: Id of a created request
		Throws: BET_CustomBETException
	*************************************************************/
	public static Id RequestExternalUserAccess(String userEmail, Id betId){
		System.debug('Entering RequestExternalUserAccess : ' + userEmail + ', ' + betId);
		Id requestId = null;
		Boolean isOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betId, UserInfo.getUserId());
		try{
			BET_Member_Request__c mrequest = new BET_Member_Request__c(
				Brand_Experience_Toolkit__c=betId,
				External_User_Email__c=userEmail,
				External_User_Request__c=true,
				Status__c = isOwnerOrManager ? BET_LinkingService.FOLLOW_STATUS_APPROVED : BET_LinkingService.FOLLOW_STATUS_NEW);
			insert mrequest;
			requestId = mrequest.id;
		}catch(Exception e){
			throw new BET_CustomBETException('Unable to create access request',e);
		}
		System.debug('Exit RequestExternalUserAccess : ' + requestId);
		return requestId;
	}

}