/*************************************************************************************
Name : BET_ExpectedAssetsController

Purpose : Controller for BET_ExpectedAssetsComponent

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-09-2015  Initial
*************************************************************************************/
public with sharing class BET_ExpectedAssetsController {

	public Id betIdentifier {
		get{
			return betIdentifier;
		}
		set{
			betIdentifier = value;
			initializeExpectedAssetsData();
		}
	}

	public List<ExpectedAssetsWrapper> expectedAssetsForBET {get;set;}


	/************************************************************
        Purpose: Component controller constructor
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public BET_ExpectedAssetsController() {}

	/************************************************************
        Purpose: Initialize displayed data
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	private void initializeExpectedAssetsData(){
		System.debug('Entering initializeExpectedAssetsData');
		if(expectedAssetsForBET == null) {
			expectedAssetsForBET = new List<ExpectedAssetsWrapper>();
			List<BET_ExpectedAssets__c> expectedAssetsData = getExpectedAssetsDataForBet();
			Boolean hasSavedExpectedAssetsData = !expectedAssetsData.isEmpty();
			if(hasSavedExpectedAssetsData) {
				for(BET_ExpectedAssets__c exAsset : expectedAssetsData){
					expectedAssetsForBET.add(new ExpectedAssetsWrapper(exAsset.Type__c,Integer.valueOf(exAsset.Expected__c),exAsset.id));
				}
			} else {
				for(String mediaType : getAvailableMediaTypes()){
					expectedAssetsForBET.add(new ExpectedAssetsWrapper(mediaType,0));
				}
			}
		}
	}

	/************************************************************
        Purpose: Retrieves existing Expected Assets data
        Parameters: -
        Returns: List of BET_ExpectedAssets__c type records
        Throws: -
    *************************************************************/
	private List<BET_ExpectedAssets__c> getExpectedAssetsDataForBet(){
		System.debug('Entering getExpectedAssetsDataForBet : ' + betIdentifier);
		List<BET_ExpectedAssets__c> eAssets = [select Actual__c,Expected__c,Type__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: betIdentifier];
		System.debug('Exit getExpectedAssetsDataForBet : ' + eAssets);
		return eAssets;
	}

	/************************************************************
        Purpose: Retrieves media types data
        Parameters: -
        Returns: List of strings representing types
        Throws: -
    *************************************************************/
	private List<String> getAvailableMediaTypes(){
		System.debug('Entering getAvailableMediaTypes');
		return BET_AssetService.getAvailableMediaTypes(); 
	}

	/************************************************************
        Purpose: Upserts expected assets data
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public void upsertExceptedAssets(){
		System.debug('Entering upsertExceptedAssets');
		List<BET_ExpectedAssets__c> expectedAssetsData = new List<BET_ExpectedAssets__c>();

		Map<String,Integer> assetNumberMap = BET_AssetService.approvedAssetTypesNumerMap(betIdentifier);

		for(ExpectedAssetsWrapper wrapper : expectedAssetsForBET){
			System.debug(wrapper.assetTypeName + ' : ' + wrapper.assetTypeNameExpectedNumber);
			Integer actual = assetNumberMap.get(wrapper.assetTypeName) == null ? 0 : assetNumberMap.get(wrapper.assetTypeName);
			if(wrapper.assetTypeNameExpectedNumber == 0){
				actual = 0;
			}
			expectedAssetsData.add(new BET_ExpectedAssets__c(id = wrapper.relatedObjectId,
											Expected__c = wrapper.assetTypeNameExpectedNumber,
											Actual__c = actual,
											Type__c = wrapper.assetTypeName,
											Brand_Experience_Toolkit__c = betIdentifier));
		}
		upsert expectedAssetsData;
	}

	/************************************************************
        Purpose: Wrapper class for expected assets
    *************************************************************/
	public class ExpectedAssetsWrapper {
		public String assetTypeName{get;set;}
		public Integer assetTypeNameExpectedNumber{get;set;}
		public Id relatedObjectId {get;set;}

		public ExpectedAssetsWrapper(String name, Integer count){
			assetTypeName = name;
			assetTypeNameExpectedNumber = count;
		}

		public ExpectedAssetsWrapper(String name, Integer count, Id objectId){
			assetTypeName = name;
			assetTypeNameExpectedNumber = count;
			relatedObjectId = objectId;
		}
	}

}