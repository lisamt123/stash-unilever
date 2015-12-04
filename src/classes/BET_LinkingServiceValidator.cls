public class BET_LinkingServiceValidator {

	private BET_LinkingServiceValidator() {}

	/************************************************************
		Purpose: Method validates inital parameters
		Parameters: List<uw_Bet__c> betRecords
		Returns: -
		Throws: BET_CustomBETException
	*************************************************************/
	public static void validateFollowRequest(List<uw_Bet__c> betRecords){
		System.debug('Entering validateFollowRequest : ' + betRecords);
		validateParams(betRecords);
		if(betRecords.get(0).Is_Archived__c) {
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

}