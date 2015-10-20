/*************************************************************************************
Name : BET_AssetService

Purpose : Asset related service methods

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-09-2015  Initial
*************************************************************************************/

/*Without sharing due to it is a service method */

global class BET_AssetService {

	private static final Set<String> excludedMediaType = new Set<String>{'BET Presentation'};
	private static final String START_STR = '/download/';
	private static final String END_STR = '?';

	private BET_AssetService() {}


	/************************************************************
        Purpose: Grants access to files attached to bet
        Parameters: Id betId,Id userId
        Returns: -
        Throws: -
    *************************************************************/
	@Future
	public static void grantAccessToBetsAssets(Id betId,Id userId){
		List<ContentDocumentLink> links = new List<ContentDocumentLink>();

		Set<Id> cVersions = new Set<Id>();

		List<uw_Asset__c> assets = [select id, Url_of_asset__c from uw_Asset__c where uw_BET__c =: betId];

		for(uw_Asset__c asset : assets){
			if(!String.isBlank(asset.Url_of_asset__c)){
				Integer startIdx = asset.Url_of_asset__c.indexOf(START_STR);
		        Integer endIdx = asset.Url_of_asset__c.indexOf(END_STR); 
		        asset.Url_of_asset__c.substring(startIdx+10, endIdx);
				cVersions.add((Id)asset.Url_of_asset__c.substring(startIdx+10, endIdx));
			}
		}

		Map<Id,Id> versionsDocumentMap = new Map<Id,Id>();

		System.debug('cVersions ' + cVersions);

		for(ContentVersion cv : [select id, ContentDocumentId from ContentVersion where id in : cVersions]){
			versionsDocumentMap.put((Id)cv.id,cv.ContentDocumentId);
		}


		System.debug('versionsDocumentMap ' + versionsDocumentMap);
		for(uw_Asset__c asset : assets){
			if(!String.isBlank(asset.Url_of_asset__c)){
				Integer startIdx = asset.Url_of_asset__c.indexOf(START_STR);
	            Integer endIdx = asset.Url_of_asset__c.indexOf(END_STR); 
				ContentDocumentLink link = new ContentDocumentLink();
				link.LinkedEntityId = userId;
				System.debug('versionsDocumentMap key ' + (Id)asset.Url_of_asset__c.substring(startIdx+10, endIdx));
				link.ContentDocumentId = versionsDocumentMap.get((Id)asset.Url_of_asset__c.substring(startIdx+10, endIdx));
				link.ShareType = 'V';
				link.Visibility = 'AllUsers';
				links.add(link);
			}
		}
		insert links;
	}

	/************************************************************
        Purpose: Checks if bets have related expected assets
        Parameters: List<Id> betIds
        Returns: Map<Id,Boolean>
        Throws: -
    *************************************************************/
	public static Map<Id,Boolean> betContainsExpectedAssetsRecord(List<Id> betIds){
		System.debug('Entering betContainsExpectedAssetsRecord : ' + betIds);
		Map<Id,Boolean> resultMap = new Map<Id,Boolean>();
		for(Id bId : betIds){
			resultMap.put(bId,false);			
		}
		for(BET_ExpectedAssets__c eAssets : [select id,Brand_Experience_Toolkit__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c in : betIds]){
			resultMap.put(eAssets.Brand_Experience_Toolkit__c,true);
		}
		System.debug('Exit betContainsExpectedAssetsRecord : ' + resultMap);
		return resultMap;
	}

	/************************************************************
        Purpose: Creates expected assets records for given bets
        Parameters: List<Id> betIds
        Returns: -
        Throws: -
    *************************************************************/
	public static void createExpectedAssetsRecordsForBet(List<Id> betIds){
		System.debug('Entering createExpectedAssetsRecordsForBet : ' + betIds);
		List<BET_ExpectedAssets__c> expectedAssetsData = new List<BET_ExpectedAssets__c>();
		for(Id betId : betIds){
			for(String mediaType : getAvailableMediaTypes()){
				expectedAssetsData.add(new BET_ExpectedAssets__c(Expected__c = 0,Actual__c = 0,Type__c = mediaType,Brand_Experience_Toolkit__c = betId));
			}
		}
		System.debug('Exit createExpectedAssetsRecordsForBet : ' + expectedAssetsData);
		insert expectedAssetsData;
	}

	/************************************************************
        Purpose: Retrieves list of available media types
        Parameters: -
        Returns: List<String>
        Throws: -
    *************************************************************/
	public static List<String> getAvailableMediaTypes(){
		System.debug('Entering getAvailableMediaTypes');
		List<String> mediaTypes = new List<String>();
		Schema.DescribeFieldResult fieldResult = uw_Asset__c.Media_Type__c.getDescribe();
   		for(Schema.PicklistEntry f : fieldResult.getPicklistValues()){
   			if(!excludedMediaType.contains(f.getValue())){
      			mediaTypes.add(f.getValue());
      		}
   		}    
   		System.debug('Exit getAvailableMediaTypes : ' + mediaTypes);
   		return mediaTypes;   
	}

	/************************************************************
        Purpose: Retrieves list of available countires for assets
        Parameters: -
        Returns: List<String>
        Throws: -
    *************************************************************/
	public static List<String> getAvailableAssetsCountries(){
		System.debug('Entering getAvailableAssetsCountries');
		List<String> retVal = new List<String>();
		Schema.DescribeFieldResult fieldResult = uw_Asset__c.Country__c.getDescribe();
   		for(Schema.PicklistEntry f : fieldResult.getPicklistValues()){
      		retVal.add(f.getValue());
   		}    
   		System.debug('Exit getAvailableAssetsCountries : ' + retVal);
   		return retVal;   
	}

	/************************************************************
        Purpose: Retrieves list of available status for assets
        Parameters: -
        Returns: List<String>
        Throws: -
    *************************************************************/
	public static List<String> getAvailableAssetsStatus(){
		System.debug('Entering getAvailableAssetsStatus');
		List<String> retVal = new List<String>();
		Schema.DescribeFieldResult fieldResult = uw_Asset__c.Status__c.getDescribe();
   		for(Schema.PicklistEntry f : fieldResult.getPicklistValues()){
      		retVal.add(f.getValue());
   		}    
   		System.debug('Exit getAvailableAssetsStatus : ' + retVal);
   		return retVal;   
	}

	/************************************************************
        Purpose: Retrieves bet identifiers from given assets
        Parameters: List<uw_Asset__c> assets
        Returns: -
        Throws: -
    *************************************************************/
	public static List<Id> getBetIdsFromAssets(List<uw_Asset__c> assets){
		System.debug('Entering getBetIdsFromAssets : ' + assets);
		List<Id> bets = new List<Id>();
		for(uw_Asset__c asset : assets){
			bets.add(asset.uw_BET__c);
		}
		System.debug('Exit getBetIdsFromAssets : ' + bets);
		return bets;
	}

	/************************************************************
        Purpose: Retrieves assets type map counter
        Parameters: LId betId
        Returns: Map<String,Integer> 
        Throws: -
    *************************************************************/
	public static Map<String,Integer> approvedAssetTypesNumerMap(Id betId){
		Map<String,Integer> assetsMap = new Map<String,Integer>();
		for (AggregateResult aresult :  [select count(id), Media_Type__c from uw_Asset__c where uw_BET__c =: betId and status__c = 'Approved' and Media_Type__c not in : excludedMediaType group by Media_Type__c]){
			assetsMap.put((String)aresult.get('Media_Type__c'),(Integer)aresult.get('expr0'));
		}
		return assetsMap;
	}

}