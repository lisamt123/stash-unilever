/*************************************************************************************
Name : BET_LinkingSevice

Purpose : Bet to IPM project linking service class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  03-08-2015  Initial
*************************************************************************************/
public with sharing class BET_LinkingSevice {

	private BET_LinkingSevice() {}

	 /************************************************************
		Purpose: Method sets given project as lead for given bet
		Parameters: Id Ipm project id , Id related BET record
		Returns: -
		Throws: -
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
		Throws: -
	*************************************************************/
	public static void Follow(Id ProjectId, Id BetId, List<Id> managersIds){
		try{
			System.debug('Entering Follow : ' + ProjectId + ', ' + BetId + ', ' + managersIds);
		}catch(Exception e){
			throw new BET_CustomBETException(Label.BET_FollowExceptionMessage,e);
		}
		System.debug('Exit Follow');
	}

    /************************************************************
		Purpose: Method creates ipm project's unfollow request
		Parameters: Id Ipm project id , Id related BET record
		Returns: -
		Throws: -
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