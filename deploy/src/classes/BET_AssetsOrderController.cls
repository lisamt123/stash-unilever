/*************************************************************************************
Name : BET_AssetsOrderController

Purpose : Order asset page controller

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  21-10-2015  Initial
*************************************************************************************/
global with sharing class BET_AssetsOrderController {
	public Id betId {get;set;}

	public BET_AssetsOrderController() {
		betId = (Id)ApexPages.currentPage().getParameters().get('betid');
	}

	public List<uw_Asset__c> liAssets{
		get{
			if (liAssets == null){
				liAssets = new List<uw_Asset__c>();
				for(uw_Asset__c asset : [select id, name, Order_Of_Display__c, Media_Type__c, Country__c, Studio_Asset_Type__c
							from uw_Asset__c where uw_BET__c = :betId and Status__c = 'Approved'
							order by Order_Of_Display__c asc]){
					if(asset.Country__c != null && asset.Country__c.indexOf(';') != -1){
						asset.Country__c = 'Multi';
					}
					liAssets.add(asset);
				}
			}
			return liAssets;
		}
		set;
	}

	@RemoteAction
	global static void updateAssetsOrder(List<String> orderedAssets){
		System.debug('Entering updateAssetsOrder : ' + orderedAssets);
		List<uw_Asset__c> assets = new List<uw_Asset__c>();
		Integer index = 1;
		for(String orderdId : orderedAssets){
			assets.add(new uw_Asset__c(Id = orderdId,Order_Of_Display__c = index));
			index++;
		}
		update assets;
		System.debug('Exit updateAssetsOrder');
	}
}