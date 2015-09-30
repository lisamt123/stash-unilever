/*************************************************************************************
Name : BET_AssetHandlerCls

Purpose : Implementation of ITrigger pattern class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-09-2015  Initial
*************************************************************************************/
public with sharing class BET_AssetHandlerCls {
	
	private BET_AssetHandlerCls() {}

	/************************************************************
        Purpose: Method updated actual assets number for bet
        Parameters: List<uw_Asset__c> deletedAssets
        Returns: -
        Throws: -
    *************************************************************/
	public static void updateActualAssetsNumberAfterDeletion(List<uw_Asset__c> deletedAssets){
		System.debug('Entering updateActualAssetsNumberAfterDeletion ' + deletedAssets);
		createExpectedAssetsRecordsIfNeecssary(BET_AssetService.getBetIdsFromAssets(deletedAssets));
		List<uw_Asset__c> deletedApprovedAssets = new List<uw_Asset__c>();
		for(uw_Asset__c asset : deletedAssets){
			if(asset.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
				deletedApprovedAssets.add(asset);
			}
		}
		decreaseActualAssetNumber(deletedApprovedAssets);
	}

	/************************************************************
        Purpose: Method updated actual assets number for bet
        Parameters: List<uw_Asset__c> newAssets
        Returns: -
        Throws: -
    *************************************************************/
	public static void updateActualAssetsNumber(List<uw_Asset__c> newAssets){
		System.debug('Entering updateActualAssetsNumber ' + newAssets);
		createExpectedAssetsRecordsIfNeecssary(BET_AssetService.getBetIdsFromAssets(newAssets));
		List<uw_Asset__c> approvedAssets = new List<uw_Asset__c>();
		for(uw_Asset__c asset : newAssets){
			if(asset.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
				approvedAssets.add(asset);
			}
		}
		increaseActualAssetNumber(approvedAssets);
	}

	/************************************************************
        Purpose: Method updated actual assets number for bet
        Parameters: List<uw_Asset__c> newAssets, Map<Id,uw_Asset__c> oldMap
        Returns: -
        Throws: -
    *************************************************************/
	public static void updateActualAssetsNumber(List<uw_Asset__c> newAssets, Map<Id,uw_Asset__c> oldMap){
		System.debug('Entering updateActualAssetsNumber ' + newAssets + ', ' + oldMap);
		createExpectedAssetsRecordsIfNeecssary(BET_AssetService.getBetIdsFromAssets(newAssets));
		List<uw_Asset__c> approvedAssets = new List<uw_Asset__c>();
		List<uw_Asset__c> unapprovedAssets = new List<uw_Asset__c>();
		for(uw_Asset__c asset : newAssets){
			if(asset.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED && oldMap.get(asset.id).Status__c != uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
				approvedAssets.add(asset);
			} else if(asset.Status__c != uw_CustomAssetUploadExtension.BET_ASSET_APPROVED && oldMap.get(asset.id).Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
				unapprovedAssets.add(asset);
			} else if(asset.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED && oldMap.get(asset.id).Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED 
					  && asset.Media_Type__c != oldMap.get(asset.id).Media_Type__c){
				approvedAssets.add(asset);
				unapprovedAssets.add(new uw_Asset__c(uw_BET__c = asset.uw_BET__c,Media_Type__c = oldMap.get(asset.id).Media_Type__c));
			}
		}
		increaseActualAssetNumber(approvedAssets);
		decreaseActualAssetNumber(unapprovedAssets);
	}

	/************************************************************
        Purpose: Method initiates Expected Assets REcords for bets
        Parameters: List<Id> betIds
        Returns: -
        Throws: -
    *************************************************************/
	private static void createExpectedAssetsRecordsIfNeecssary(List<Id> betIds){
		System.debug('Entering createExpectedAssetsRecordsIfNeecssary ' + betIds);
		Map<Id,Boolean> assetsExistsMap = BET_AssetService.betContainsExpectedAssetsRecord(betIds);
		List<Id> betsWithoutExpectedAssetsRecords = new List<Id>();
		for(Id betId : betIds){
			if(!assetsExistsMap.get(betId)){
				betsWithoutExpectedAssetsRecords.add(betId);
			}
		}
		BET_AssetService.createExpectedAssetsRecordsForBet(betsWithoutExpectedAssetsRecords);
	}

	/************************************************************
        Purpose: Method increases actual assets counter
        Parameters: List<uw_Asset__c> approvedAssets
        Returns: -
        Throws: -
    *************************************************************/
    @TestVisible
	private static void increaseActualAssetNumber(List<uw_Asset__c> approvedAssets){
		System.debug('Entering increaseActualAssetNumber ' + approvedAssets);
		List<BET_ExpectedAssets__c> toBeUpdated = new List<BET_ExpectedAssets__c>();
		Map<Id,List<BET_ExpectedAssets__c>> brandExpectedAssetsMap = getExpectedAssetsForRelatedBets(approvedAssets);
		for(uw_Asset__c asset : approvedAssets){
			List<BET_ExpectedAssets__c> eassets = brandExpectedAssetsMap.get(asset.uw_BET__c);
			if(eassets!=null){
				for(BET_ExpectedAssets__c easset : eassets){
					if(asset.Media_Type__c != null && asset.Media_Type__c == easset.Type__c && easset.Expected__c > 0){
						easset.Actual__c++;
						toBeUpdated.add(easset);
					}
				}
			}
		}
		update toBeUpdated;
	}

	/************************************************************
        Purpose: Method decreases actual assets counter
        Parameters: List<uw_Asset__c> unapprovedOrDeletedAssets
        Returns: -
        Throws: -
    *************************************************************/
    @TestVisible
	private static void decreaseActualAssetNumber(List<uw_Asset__c> unapprovedOrDeletedAssets){
		System.debug('Entering decreaseActualAssetNumber ' + unapprovedOrDeletedAssets);
		List<BET_ExpectedAssets__c> toBeUpdated = new List<BET_ExpectedAssets__c>();
		Map<Id,List<BET_ExpectedAssets__c>> brandExpectedAssetsMap = getExpectedAssetsForRelatedBets(unapprovedOrDeletedAssets);
		for(uw_Asset__c asset : unapprovedOrDeletedAssets){
			List<BET_ExpectedAssets__c> eassets = brandExpectedAssetsMap.get(asset.uw_BET__c);
			if(eassets!=null){
				for(BET_ExpectedAssets__c easset : eassets){
					if(asset.Media_Type__c != null && asset.Media_Type__c == easset.Type__c && easset.Expected__c > 0 && easset.Actual__c > 0){		
						easset.Actual__c--;
						toBeUpdated.add(easset);
					}
				}
			}
		}
		update toBeUpdated;
	}

	/************************************************************
        Purpose: Method retrieves records that holds approved assets counter
        Parameters: List<uw_Asset__c> assets
        Returns: Map<Id,List<BET_ExpectedAssets__c>>
        Throws: -
    *************************************************************/
    @TestVisible
	private static Map<Id,List<BET_ExpectedAssets__c>> getExpectedAssetsForRelatedBets(List<uw_Asset__c> assets){
		System.debug('Entering getExpectedAssetsForRelatedBets ' + assets);
		Set<Id> betIds = new Set<Id>();
		for(uw_Asset__c asset : assets){
			betIds.add(asset.uw_BET__c);
		}

		Map<Id,List<BET_ExpectedAssets__c>> brandExpectedAssetsMap = new Map<Id,List<BET_ExpectedAssets__c>>();

		for(BET_ExpectedAssets__c expectedAsset : [select Actual__c,Brand_Experience_Toolkit__c,Type__c,Expected__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c in: betIds]){
			if(brandExpectedAssetsMap.keySet().contains(expectedAsset.Brand_Experience_Toolkit__c)){
				brandExpectedAssetsMap.get(expectedAsset.Brand_Experience_Toolkit__c).add(expectedAsset);
			} else {
				brandExpectedAssetsMap.put(expectedAsset.Brand_Experience_Toolkit__c,new List<BET_ExpectedAssets__c>{expectedAsset});
			}
		}
		System.debug('Exit getExpectedAssetsForRelatedBets ' + brandExpectedAssetsMap);
		return brandExpectedAssetsMap;
	}

	/************************************************************
        Purpose: Method opens related assets
        Parameters: List<uw_Asset__c> newAssets
        Returns: -
        Throws: -
    *************************************************************/
	public static void handleOpenAssetInserts(List<uw_Asset__c> newAssets){ //Taken from uw_Asset_AfterInsertAfterUpdate
		System.debug('Entering handleOpenAssetInserts ' + newAssets);
		List <uw_Asset__c> assetsToOpen = new List<uw_Asset__c>();
		for (uw_Asset__c a : newAssets){
            if (a.promoted__c){
                assetsToOpen.add(a);
            }
        }
        uw_TriggerHandler handler = new uw_TriggerHandler();
        handler.handleAssets(assetsToOpen, true);
	}

	/************************************************************
        Purpose: Method opens/closes related assets
        Parameters: List<uw_Asset__c> newAssets, Map<Id,uw_Asset__c> oldMap
        Returns: -
        Throws: -
    *************************************************************/
	public static void handleOpenCloseAssetUpdates(List<uw_Asset__c> newAssets, Map<Id,uw_Asset__c> oldMap){ //Taken from uw_Asset_AfterInsertAfterUpdate
		System.debug('Entering handleOpenCloseAssetUpdates ' + newAssets + ', ' + oldMap);
		List <uw_Asset__c> assetsToOpen = new List<uw_Asset__c>();
		List <uw_Asset__c> assetsToClose = new List<uw_Asset__c>();

		for (uw_Asset__c a : newAssets){    
            uw_Asset__c oldAsset = oldMap.get(a.id);
            if (a.promoted__c && !oldAsset.promoted__c){
                assetsToOpen.add(a);
            } else if (!a.promoted__c && oldAsset.promoted__c) {
                assetsToClose.add(a);
            }
        }

        uw_TriggerHandler handler = new uw_TriggerHandler();
        handler.handleAssets(assetsToOpen, true);
        handler.handleAssets(assetsToClose, false);
	}
}