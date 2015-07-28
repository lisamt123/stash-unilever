/*************************************************************************************
Name : BET_AccessService

Purpose : Access service class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  23-07-2015  Initial
*************************************************************************************/
public with sharing class BET_AccessService {
	
	/************************************************************
		Purpose: Method checks if user has access to bet
		Parameters: Id of related user , Id of related bet
		Returns: Status String (“No”, “Member”,”Manager “, “Owner”, “Pending”)
		Throws: BET_CustomBETException
	*************************************************************/
	public static String HasUserAccess(Id userId,Id betId){
		String status = null;
		try{

		}catch(Exception e){
			throw new BET_CustomBETException(e);
		}
		return status;

	}

	/************************************************************
		Purpose: Method creates access requests
		Parameters: List of member requests, Id of related bet
		Returns: Id of a created request
		Throws: BET_CustomBETException
	*************************************************************/
	public static Id RequestAccess(List<BET_BETWrapper.MemberRequest> memberRequests, Id betId){
		Id requestId = null;
		try{

		}catch(Exception e){
			throw new BET_CustomBETException(e);
		}
		return requestId;
	}

	/************************************************************
		Purpose: Method creates access request
		Parameters: User email, Id of related bet
		Returns: Id of a created request
		Throws: BET_CustomBETException
	*************************************************************/
	public static Id RequestExternalUserAccess(String userEmail, Id betId){
		Id requestId = null;
		try{

		}catch(Exception e){
			throw new BET_CustomBETException(e);
		}
		return requestId;
	}

}