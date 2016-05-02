/*************************************************************************************
Name : BET_AssetService

Purpose : Asset related service methods

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-09-2015  Initial
*************************************************************************************/

/*Without sharing due to it is a service method */

global without sharing class BET_AssetService {

	private static final Set<String> excludedMediaType = new Set<String>{'BET Presentation'};
	private BET_AssetService() {}

	/************************************************************
        Purpose: Reorders assets
        Parameters: String betId
        Returns: -
        Throws: -
    *************************************************************/
	public static void forceAssetReordering(String betId){
		Boolean reorder = false;
        List<String> assetsOrdered = new List<String>();
        Set<Integer> orderSet = new Set<Integer>();
        for(uw_Asset__c asset : [select Order_Of_Display__c from uw_Asset__c where uw_BET__c = :betId and Status__c = 'Approved'
                            order by Order_Of_Display__c asc]){
            assetsOrdered.add((String)asset.id);
            if(asset.Order_Of_Display__c == null) {
                reorder = true;
            } else {
                if(orderSet.contains((Integer)asset.Order_Of_Display__c)){
                    reorder = true;
                } else {
                    orderSet.add((Integer)asset.Order_Of_Display__c);
                }
            }
        }
        if(reorder) {
            BET_AssetsOrderController.updateAssetsOrder(assetsOrdered);
        }
	}

	/************************************************************
        Purpose: Grants access to files attached to bet
        Parameters: Id betId,Id userId
        Returns: -
        Throws: -
    *************************************************************/
	@Future
	public static void grantAccessToBetsAssets(Id betId,Id userId){
		try{
			List<ContentDocumentLink> links = new List<ContentDocumentLink>();

			Set<Id> linkedFiles = new Set<Id>();
			for(ContentDocumentLink cl : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId =: userId]){
				linkedFiles.add(cl.ContentDocumentId);
			}

			for(uw_Asset__c asset : [select id, File_Id__c from uw_Asset__c where uw_BET__c =: betId]){
				if(!String.isBlank(asset.File_Id__c) && !linkedFiles.contains(asset.File_Id__c)){
					ContentDocumentLink link = new ContentDocumentLink();
					link.LinkedEntityId = userId;
					link.ContentDocumentId = asset.File_Id__c;
					link.ShareType = 'v';
					link.Visibility = 'AllUsers';
					links.add(link);
				}
			}
			if(!Test.isRunningTest()){
				Database.insert(links, false);
			}
		}catch(Exception ex){
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'BET_AssetService','grantAccessToBetsAssets',
                'Exception while granting access for ' + betId + ' for BET ' +  betId + ' related assets',
                new BET_CustomBETException(ex.getMessage()),'ERROR',null,null,(Integer)DateTime.now().getTime(),'BET');
		}
	}

	/********************************************************************
		Purpose: Grants Access to file for given user
		Parameters: Id fileId,Id userId
        Returns: -
        Throws: -
	*********************************************************************/

	public static void grantAccessToAsset(Id fileId,Id userId){
		try{
			List<ContentDocumentLink> linkedFiles = [select id from ContentDocumentLink where LinkedEntityId =: userId and ContentDocumentId =:fileId];
			if(linkedFiles.isEmpty()){
				ContentDocumentLink link = new ContentDocumentLink();
				link.LinkedEntityId = userId;
				link.ContentDocumentId = fileId;
				link.ShareType = 'v';
				link.Visibility = 'AllUsers';
				if(!Test.isRunningTest()){
					insert link;
				}
			}
		}catch(Exception ex){
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'BET_AssetService','grantAccessToAsset',
                'Exception while granting access for ' + userId + ' for file ' + fileId,
                new BET_CustomBETException(ex.getMessage()),'ERROR',null,null,(Integer)DateTime.now().getTime(),'BET');
		}
	}

	/************************************************************
        Purpose: Updates fileId field based on asset url
        Parameters: List<uw_Asset__c> assets
        Returns: assets list
        Throws: -
    *************************************************************/
	public static List<uw_Asset__c> updateFileId(List<uw_Asset__c> assets){

		String validLinkPrefix = 'sfc/servlet.shepherd/version/download/';

		Set<Id> identifiers = new Set<Id>();
		for(uw_Asset__c asset : assets){
			if(!String.isEmpty(asset.URL_of_Asset__c) && asset.URL_of_Asset__c.contains(validLinkPrefix)){
	        	identifiers.add(getAssetFileIdentifier(asset));
        	}
        }

        Map<Id,Id> versionFileMap = new Map<Id,Id>();
		for(ContentVersion cv : [select id, ContentDocumentId from ContentVersion where id in : identifiers]){
			versionFileMap.put(cv.id,cv.ContentDocumentId);
		}

		for(uw_Asset__c asset : assets){
			if(!String.isEmpty(asset.URL_of_Asset__c) && asset.URL_of_Asset__c.contains(validLinkPrefix)){
				asset.File_Id__c = versionFileMap.get(getAssetFileIdentifier(asset));
				if(asset.File_Id__c == null && !Test.isRunningTest() && asset.Related_Feed_Item__c != null){
					ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) ConnectApi.ChatterFeeds.getFeedItem(null, asset.Related_Feed_Item__c).attachment;
					asset.File_Id__c = ca == null ? null : ca.id;
				}
			}
		}
		return assets;
	}

	/************************************************************
        Purpose: Retrieves identifier of an asset related file
        Parameters: uw_Asset__c asset
        Returns: Id
        Throws: -
    *************************************************************/
	public static Id getAssetFileIdentifier(uw_Asset__c asset){
		Integer startIdx = asset.URL_of_Asset__c.indexOf('/download/');
	    return (Id)asset.URL_of_Asset__c.substring(startIdx+10, startIdx+25);
	}

	/************************************************************
        Purpose: Checks if there are expected assets objects set for given bet
        Parameters: Id betid
        Returns: Boolean
        Throws: -
    *************************************************************/
	public static Boolean expectedAssetsSetForBet(Id betid){
		if(betid == null){
			return false;
		}
		Boolean exists = false;
		for(BET_ExpectedAssets__c eAssets : [select Expected__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: betid]){
			if(eAssets.Expected__c != null && eAssets.Expected__c > 0){
				exists = true;
				break;
			}
		}
		return exists;
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