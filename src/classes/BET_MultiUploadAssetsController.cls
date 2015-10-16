/*************************************************************************************
Name : BET_MultiUploadAssetsController

Purpose : Controller for BET_MultiUploadAssets

History

VERSION  AUTHOR                			DATE        DETAIL   Description
1.0      pczechumski@salesforce.com 	05-10-2015  Initial
*************************************************************************************/
global class BET_MultiUploadAssetsController {

	public static final String BRAND_DEVELOPMENT = 'Brand Development';
	public static final String BRAND_BUILDING = 'Brand Building';

	public Id chatterGroupId {get;set;}
	public Id betId {get;set;}
    public String status {get;set;}

	public BET_MultiUploadAssetsController() {
		chatterGroupId = (Id)ApexPages.currentPage().getParameters().get('parent');
		betId = (Id)ApexPages.currentPage().getParameters().get('betid');
        String tab = (String)ApexPages.currentPage().getParameters().get('status');
        status = uw_CustomAssetUploadExtension.tabRelatedStatusMap.get(tab);
	}

	/************************************************************
        Purpose: Retrieves media types data
        Parameters: -
        Returns: List of strings representing types
        Throws: -
    *************************************************************/
	public String getAvailableMediaTypes(){
		System.debug('Entering getAvailableMediaTypes');
		return JSON.serialize(BET_AssetService.getAvailableMediaTypes()); 
	}

	/************************************************************
        Purpose: Retrieves media types data
        Parameters: -
        Returns: List of strings representing types
        Throws: -
    *************************************************************/
	public String getAvailableCountries(){
		System.debug('Entering getAvailableCounties');
		return JSON.serialize(BET_AssetService.getAvailableAssetsCountries()); 
	}

	/************************************************************
        Purpose: Retrieves media types data
        Parameters: -
        Returns: List of strings representing types
        Throws: -
    *************************************************************/
	public String getAvailableStatus(){
		System.debug('Entering getAvailableStatus');
		return JSON.serialize(BET_AssetService.getAvailableAssetsStatus()); 
	}

	/************************************************************
        Purpose: Checks id bet is visual approved already
        Parameters: Id betid
        Returns: boolean
        Throws: -
    *************************************************************/
	public static boolean isVisualApproved(Id betid){
        for(uw_Asset__c flist : [SELECT Name, Is_bucket_field__c, Id, uw_BET__c, Related_Feed_Item__c,Media_Type__c,Status__c FROM uw_Asset__c WHERE uw_bet__c =: betid]){
            if(flist.Media_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW && flist.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
                return true;
            }
        }
        return false;
    }

    /************************************************************
        Purpose: Creates feed attachemnt related asset
        Parameters: String feedid, String assetName,String mediaType,String country,String status, String betId
        Returns: String
        Throws: -
    *************************************************************/
	@RemoteAction
	global static String saveFileAndConnect(String feedid, String assetName,String mediaType,String country,String status, String betId){

		uw_Asset__c file = new uw_Asset__c(name = assetName,uw_BET__c = betId,Status__c = status,Studio_Asset_Type__c = uw_CustomAssetUploadExtension.BET_ASSET_TYPE_CW,Media_Type__c = mediaType, Country__c = country);

		uw_Bet__c bet = [select id, Status__c from uw_bet__c where id =: betId];

        if(BET_CommonService.canModify(bet.Id)){
            file.Sub_Function__c = BRAND_DEVELOPMENT;
        }else{
            file.Sub_Function__c = BRAND_BUILDING;
            file.Status__c = uw_CustomAssetUploadExtension.BET_ASSET_SHARED;
        }

        Boolean brandExperiencePresnetationIsThere = false;
        
        List<FeedItem> chatterContentPostList = [SELECT Id, RelatedRecordId, ContentDescription, Type, ContentFileName FROM FeedItem WHERE Id = :feedid LIMIT 1];
          
        FeedItem chatterContentPost = chatterContentPostList[0];   
        file.Related_Feed_Item__c = chatterContentPost.Id;        
        ConnectApi.FeedItem fi;
        ConnectApi.ContentAttachment ca;
        
        fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Related_Feed_Item__c);      
        ca = (ConnectApi.ContentAttachment) fi.attachment;
        file.URL_of_Asset__c = ca.downloadUrl;
        file.thumbnail__c = ca.renditionUrl;
        
        Boolean updateBet = false;
        if(file.Sub_Function__c == 'Brand Development' && file.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){
            if(file.Media_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW && bet.Status__c == 'First release'){
                bet.Status__c = 'Final release';
                updateBet = true;
            }
            if(file.Media_Type__c == uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW && file.Status__c == uw_CustomAssetUploadExtension.BET_ASSET_APPROVED){ // IPM-BET US43
                brandExperiencePresnetationIsThere = ![select Media_Type__c,Status__c,Studio_Asset_Type__c from uw_Asset__c 
                                                          where Studio_Asset_Type__c =: uw_CustomAssetUploadExtension.BET_ASSET_TYPE_BEP
                                                          and Status__c =: uw_CustomAssetUploadExtension.BET_ASSET_APPROVED
                                                          and uw_bet__c =: bet.id].isEmpty();
                if(brandExperiencePresnetationIsThere) {
                    bet.FinalReleaseDate__c = date.today();
                    updateBet = true;
                }
            }
        }

        if (String.isEmpty(file.Name)) {
            file.Name = chatterContentPost.ContentFileName;
        }
        Savepoint sp = Database.setSavepoint();
        try {
            insert file;
            if (updateBet) {
                BET_CommonService.updateBET(bet);
            }
        } catch (Exception e) {
            Database.rollback(sp);
            delete chatterContentPostList[0];
            return e.getMessage();
        }           
        return null;      
	}
}