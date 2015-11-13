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
        Purpose: Method updates BET status when Assets is deleted
        Parameters: List<uw_Asset__c> deletedAssets
        Returns: -
        Throws: -
    *************************************************************/
	public static void updateBETStatusAccordingly(List<uw_Asset__c> deletedAssets){
		List<uw_Asset__c> deletedApprovedBrandPresentations = new List<uw_Asset__c>();
		List<uw_Asset__c> deletedApprovedCreativeWorks = new List<uw_Asset__c>();
		Set<Id> bpBetIds = new Set<Id>();
		Set<Id> cwBetIds = new Set<Id>();
		for(uw_Asset__c asset : deletedAssets){
			if(asset.Studio_Asset_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_TYPE_BEP 
				&& asset.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED ){
				deletedApprovedBrandPresentations.add(asset);
				bpBetIds.add(asset.uw_BET__c);
			} else if (asset.Studio_Asset_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_TYPE_CW 
						&& asset.Media_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW 
						&& asset.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
				deletedApprovedCreativeWorks.add(asset);
				cwBetIds.add(asset.uw_BET__c);
			} 
		}
		BET_AssetHandlerClsHelper.updateBetStatus(deletedApprovedBrandPresentations,deletedApprovedCreativeWorks,bpBetIds,cwBetIds);
	}

	/************************************************************
        Purpose: Method updates BET status when Assets changes
        Parameters: List<uw_Asset__c> newAssets, Map<Id,uw_Asset__c> oldMap
        Returns: -
        Throws: -
    *************************************************************/
	public static void updateBETStatusAccordingly(List<uw_Asset__c> newAssets, Map<Id,uw_Asset__c> oldMap){
		List<uw_Asset__c> modifiedApprovedBrandPresentations = new List<uw_Asset__c>();
		List<uw_Asset__c> modifiedApprovedCreativeWorks = new List<uw_Asset__c>();
		Set<Id> bpBetIds = new Set<Id>();
		Set<Id> cwBetIds = new Set<Id>();
		for(uw_Asset__c asset : newAssets){
			if(asset.Studio_Asset_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_TYPE_BEP 
				&& asset.Status__c != uw_CustomAssetUploadExtension.BET_ASSET_APPROVED 
				&& oldMap.get(asset.id).Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED ){
				modifiedApprovedBrandPresentations.add(asset);
				bpBetIds.add(asset.uw_BET__c);
			} else if (asset.Studio_Asset_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_TYPE_CW 
						&& asset.Media_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW 
						&& asset.Status__c != uw_CustomAssetUploadExtension.BET_ASSET_APPROVED
						&& oldMap.get(asset.id).Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
				modifiedApprovedCreativeWorks.add(asset);
				cwBetIds.add(asset.uw_BET__c);
			} 
		}
		BET_AssetHandlerClsHelper.updateBetStatus(modifiedApprovedBrandPresentations,modifiedApprovedCreativeWorks,bpBetIds,cwBetIds);
	}

	/************************************************************
        Purpose: Method updated assets ordering
        Parameters: List<uw_Asset__c> newAssets
        Returns: -
        Throws: -
    *************************************************************/
	public static void updateAssetOrdering(List<uw_Asset__c> newAssets){
		System.debug('Entering updateAssetOrdering : ' + newAssets);
		Set<Id> betsIds = new Set<Id>();
		Map<Id,Integer> betNewAssetNo = new Map<Id,Integer>();
		for(uw_Asset__c asset : newAssets){
			if(asset.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
				if(betNewAssetNo.keySet().contains(asset.uw_BET__c)){
					betNewAssetNo.put(asset.uw_BET__c,betNewAssetNo.get(asset.uw_BET__c)+1);
				} else {
					betNewAssetNo.put(asset.uw_BET__c,1);
				}
				asset.Order_Of_Display__c = betNewAssetNo.get(asset.uw_BET__c);
				betsIds.add(asset.uw_BET__c);
			}
		}

		List<uw_Asset__c> assets = new List<uw_Asset__c>();
		Map<Id,Integer> betNullPriorityAssetIndex = new Map<Id,Integer>();
		for(uw_Asset__c existingAsset : [select id,Order_Of_Display__c,uw_BET__c from uw_Asset__c where uw_BET__c in : betsIds]) {
			if(existingAsset.Order_Of_Display__c == null){
				if(betNullPriorityAssetIndex.keySet().contains(existingAsset.uw_BET__c)){
					betNullPriorityAssetIndex.put(existingAsset.uw_BET__c,betNullPriorityAssetIndex.get(existingAsset.uw_BET__c) + 1);
				} else {
					betNullPriorityAssetIndex.put(existingAsset.uw_BET__c,betNewAssetNo.get(existingAsset.uw_BET__c));
				}
				existingAsset.Order_Of_Display__c = betNullPriorityAssetIndex.get(existingAsset.uw_BET__c) + 1;
			} else {
				existingAsset.Order_Of_Display__c = existingAsset.Order_Of_Display__c + betNewAssetNo.get(existingAsset.uw_BET__c);
			}
			assets.add(existingAsset);
		}

		update assets;
		System.debug('Exit updateAssetOrdering : ' + assets);
	}

	/************************************************************
        Purpose: Method updated actual assets number for bet
        Parameters: List<uw_Asset__c> deletedAssets
        Returns: -
        Throws: -
    *************************************************************/
	public static void updateActualAssetsNumberAfterDeletion(List<uw_Asset__c> deletedAssets){
		System.debug('Entering updateActualAssetsNumberAfterDeletion ' + deletedAssets);
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