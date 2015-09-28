/*************************************************************************************
Name : BET_AssetService

Purpose : Asset related service methods

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-09-2015  Initial
*************************************************************************************/
public without sharing class BET_AssetService {

	private static final Set<String> excludedMediaType = new Set<String>{'BET Presentation'};

	private BET_AssetService() {}

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