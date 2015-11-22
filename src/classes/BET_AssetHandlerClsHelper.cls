public with sharing class BET_AssetHandlerClsHelper {

	private BET_AssetHandlerClsHelper() {}


	private static void brandPresentationCase(List<uw_Asset__c> approvedBrandPresentations, Set<Id> bpBetIds){

		List<uw_Asset__c> bpAssets = [select id, uw_BET__c from uw_Asset__c where 
										uw_BET__c =: bpBetIds 
										and Studio_Asset_Type__c =: uw_CustomAssetUploadExtension.BET_ASSET_TYPE_BEP 
										and Status__c =: uw_CustomAssetUploadExtension.BET_ASSET_APPROVED
										and id not in : approvedBrandPresentations];
			bpBetIds.clear();
			for(uw_Asset__c ass : bpAssets){
				bpBetIds.add(ass.uw_BET__c);
			}

			List<uw_Asset__c> relevantApprovedBrandPresentations = new List<uw_Asset__c>();

			for(uw_Asset__c ass : approvedBrandPresentations){
				if(!bpBetIds.contains(ass.uw_BET__c)){
					relevantApprovedBrandPresentations.add(ass); // single approved brand presentations for related bet;
				}
			}

			if(!relevantApprovedBrandPresentations.isEmpty()){
				List<uw_Bet__c> betsToUpdate = new List<uw_Bet__c>();
				for(uw_Asset__c asset : relevantApprovedBrandPresentations) {
					uw_Bet__c bet = new uw_Bet__c(Status__c = 'Unreleased', id = asset.uw_Bet__c);
					betsToUpdate.add(bet);
				}
				update betsToUpdate;
			}
	}

	private static void creativeWorkCase(List<uw_Asset__c> approvedCreativeWorks, Set<Id> cwBetIds){
			List<uw_Asset__c> cwAssets = [select id, uw_BET__c from uw_Asset__c where 
										uw_BET__c =: cwBetIds 
										and Studio_Asset_Type__c =: uw_CustomAssetUploadExtension.BET_ASSET_TYPE_CW 
										and Status__c =: uw_CustomAssetUploadExtension.BET_ASSET_APPROVED
										and Media_Type__c =: uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW 
										and id not in : approvedCreativeWorks];
			cwBetIds.clear();
			for(uw_Asset__c ass : cwAssets){
				cwBetIds.add(ass.uw_BET__c);
			}

			List<uw_Asset__c> relevantApprovedCreativeWorks = new List<uw_Asset__c>();
			Set<Id> betsCW = new Set<Id>();

			for(uw_Asset__c ass : approvedCreativeWorks){
				if(!cwBetIds.contains(ass.uw_BET__c)){
					relevantApprovedCreativeWorks.add(ass); // single approved creative works for related bet;
					betsCW.add(ass.uw_BET__c);
				}
			}

			if(!relevantApprovedCreativeWorks.isEmpty()){
				List<uw_Asset__c> bpAssets = [select id, uw_BET__c from uw_Asset__c where 
										uw_BET__c =: betsCW 
										and Studio_Asset_Type__c =: uw_CustomAssetUploadExtension.BET_ASSET_TYPE_BEP 
										and Status__c =: uw_CustomAssetUploadExtension.BET_ASSET_APPROVED];
				Set<Id> betsWithBrandPresentation = new Set<Id>();
				for(uw_Asset__c asset : bpAssets){
					betsWithBrandPresentation.add(asset.uw_BET__c);
				}

				List<uw_Bet__c> betsToUpdate = new List<uw_Bet__c>();

				for(uw_Asset__c asset : relevantApprovedCreativeWorks){
					if(betsWithBrandPresentation.contains(asset.uw_BET__c)){
						betsToUpdate.add(new uw_Bet__c(id = asset.uw_BET__c, Status__c = 'First release'));
					} else {
						betsToUpdate.add(new uw_Bet__c(id = asset.uw_BET__c, Status__c = 'Unreleased'));
					}
				}

				update betsToUpdate;
			}		
	}


	public static void updateBetStatus(List<uw_Asset__c> approvedBrandPresentations, List<uw_Asset__c> approvedCreativeWorks, Set<Id> bpBetIds,Set<Id> cwBetIds){
		if(!approvedBrandPresentations.isEmpty()){
			brandPresentationCase(approvedBrandPresentations,bpBetIds);
		}
		if(!approvedCreativeWorks.isEmpty()){
			creativeWorkCase(approvedCreativeWorks,cwBetIds);
		}
	}


}