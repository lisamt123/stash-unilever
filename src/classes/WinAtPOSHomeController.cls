/**********************************************************************
Name: WinAtPOSHomeController
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a Controller for WinAtPOSHomePage
============================================================================
============================================================================
History
-------
VERSION AUTHOR                     DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          17/09/2014     INITIAL DEVELOPMENT
2.0 -   Accenture IDC               17/11/2015     Addtion for Report Enhancement
**********************************************************************/

public with sharing  class WinAtPOSHomeController {
    public String entityId{get;set;}  
    public String winAtPosGroupId{get;set;} 
    public Boolean isCommunityUser{get;set;}
    public String keyWord{get;set;}
    
    //Controller cunstructor
    public WinAtPOSHomeController(){
        winAtPosGroupId=getWinAtPOSGroupId();
        isCommunityUser= Network.getNetworkId() != null;
        system.debug('check if community user'+isCommunityUser);
    }
    
    public PageReference updateChatterFeed(){
        if(entityId != null && entityId!=''){
            winAtPosGroupId=entityId;
        }
        return (null); 
    }
    
    /*******************************************************************
    Purpose: Method returns WinAtPOS chatter group name  
    Parameters: [none]
    Returns: String
    ********************************************************************/
    public String getWinAtPOSGroupName(){
        system.debug('*** WINatPOS getWinAtPOSGroupId method initialized');
        
        WinAtPOSRemoteActions__c  remotActionConf=WinAtPOSRemoteActions__c.getValues('WinAtPOSRemoteActionConf');
        String winAtPosGroup=remotActionConf != null ? remotActionConf.WinAtPosGroup__c :'';
        system.debug('*** WINatPOS getWinAtPOSGroupName method retuned: '+winAtPosGroup);
        return winAtPosGroup;
    }
    /*******************************************************************
    Purpose: Method returns WinAtPOS chatter group id  
    Parameters: [none]
    Returns: String
    ********************************************************************/
    public String getWinAtPOSGroupId(){
        system.debug('*** WINatPOS getWinAtPOSGroupId method initialized');
        /*
        if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
            return null;
        }
		*/
        
        WinAtPOSRemoteActions__c  remotActionConf=WinAtPOSRemoteActions__c.getValues('WinAtPOSRemoteActionConf');
        String winAtPosGroup=remotActionConf != null ? remotActionConf.WinAtPosGroup__c :'';
        if(System.Test.isRunningTest()){
            winAtPosGroup=WinAtPOSUtil.winAtPostChatterGroupForTest;
        }
        String networkId = Network.getNetworkId();
        List<CollaborationGroup> colGroup=[SELECT Id,Name,NetworkId From CollaborationGroup where name =: winAtPosGroup and NetworkId =: networkId limit 1];
        if(!colGroup.isEmpty()){
            system.debug('*** WINatPOS getWinAtPOSGroupId method returned: '+colGroup.get(0).Id);
            return colGroup.get(0).Id;
        }
        system.debug('*** WINatPOS getWinAtPOSGroupId method retuned: null');
        return null;
        
    }
    
    /*******************************************************************
    Purpose: Method returns WinAtPOS_URLS__c custom setting list in JSON format
    Parameters: [none]
    Returns: String
    ********************************************************************/
    public String getWinAtPOSUrlJson(){
        return JSON.serializePretty(WinAtPOS_URLS__c.getAll().values());
    }
    
    /*******************************************************************
    Purpose: Method add or update record for application usage porpouse  
    Parameters: [optional]
    Returns: PageReference
    ********************************************************************/
   @RemoteAction
    public static void upsertAppUsage() {
      user usr=[select id,function__c from user where id=:userInfo.getUserId()];
      Database.upsert(new Application_Usage__c(Unique_ID__c=UserInfo.getUserId()+'WIN@POS'+system.today().month(),User__c=UserInfo.getUserId(),Name=UserInfo.getUserName()+' - WIN@POS',Application__c='WIN@POS',Accessed__c=true,Last_Accessed_Date__c=System.now(),Application_Login_Month__c=System.today(),Job_Function__c=usr.function__c), Application_Usage__c.Unique_ID__c);
   
    }
    
    /*******************************************************************
    Purpose: Method return brands and categories for navigation menu  
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getMenu(){
        return WINatPOSUtilRemoteActions.getMenu();
    }
    
    /*
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getRelatedGroupAssests(String assetId){
        return WINatPOSUtilRemoteActions.getRelatedGroupAssests(assetId);
    }
    
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getAssestsForAssetsGroup(String groupId){
        return WINatPOSUtilRemoteActions.getAssestsForAssetsGroup(groupId);
    }
    */
    
    /*******************************************************************
    Purpose: Method return assets for main home carusel  
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getHomePageCarusel(){
        return WINatPOSUtilRemoteActions.getHomePageCarusel();
    }
    
    /*******************************************************************
    Purpose: Search engine method resposible for returning applicable asset and 
    asset group records
    Parameters: [String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacement,String country,Integer pageSize,Integer pageNumber,Boolean withFilters]
    Returns: WINatPOSRemoteActionWrapper 
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper search(String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacement,String country,Integer pageSize,Integer pageNumber,Boolean withFilters){
        return  WINatPOSUtilRemoteActions.search(searchType,brandId,categoryId,keyWord,assetType,assetChannel,assetCluster,assetPlacement,country,pageSize,pageNumber,withFilters);
    }
    
    /*******************************************************************
    Purpose: Method resposible for returning applicable asset details
    Parameters: [String assetOrAssetGroupId]
    Returns: WINatPOSRemoteActionWrapper
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getAssetDetailData(String assetOrAssetGroupId){
        return  WINatPOSUtilRemoteActions.getAssetDetailData(assetOrAssetGroupId);
    }
    
    /*******************************************************************
    Purpose: Method resposible for returning applicable statistics for each asset
    Parameters: [String fileId, String AssetId]
    Returns: Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> 
    ********************************************************************/
    @RemoteAction
    public static Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> retriveStatistics(String fileId, String AssetId){
         return  WINatPOSUtilRemoteActions.retriveStatistics(fileId,AssetId);
    }
    
    /*******************************************************************
    Purpose: Method resposible for adding records to download statistics
    Parameters: [none]
    Returns: none
    ********************************************************************/
    @RemoteAction
    public static void addRecordToDonwloadStatistics(String feedId,String fileId){
        WINatPOSUtilRemoteActions.addRecordToDonwloadStatistics(feedId,fileId);
    }
    
    /*******************************************************************
    Purpose: Method resposible for adding user to follow specified object id
    Parameters: [String objectToFollowId]
    Returns: none
    ********************************************************************/
    @RemoteAction
    static public void addFollower(String objectToFollowId) {
        WINatPOSUtilRemoteActions.addFollower(objectToFollowId);
    }
    
    /*******************************************************************
    Purpose: Method resposible for unfollow specified object id
    Parameters: [String objectToFollowId]
    Returns: none
    ********************************************************************/
    @RemoteAction
    static public void removeFollower(String objectToFollowId) {
        WINatPOSUtilRemoteActions.removeFollower(objectToFollowId);
    }
    
    /*******************************************************************
    Purpose: Method reposible for sharing a file with other user
    Parameters: [String assetFeedId,String userIdToShareWith]
    Returns: none
    ********************************************************************/
    @RemoteAction
    public static void shareAssetFile(String assetFeedId,String userIdToShareWith){
        WINatPOSUtilRemoteActions.shareAssetFile(assetFeedId,userIdToShareWith);
    }
    
    /*******************************************************************
    Purpose: Method return peoples form WinAtPOS chatter group
    Parameters: [String assetFeedId,String userIdToShareWith]
    Returns: WINatPOSRemoteActionWrapper
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper retriveUserFromWinAtPosGroup(){
        return WINatPOSUtilRemoteActions.retriveUserFromWinAtPosGroup();
    }
    
    /*******************************************************************
    Purpose: Method return the newest annoucement for WinAtPOS chattet group
    Parameters: [String assetFeedId,String userIdToShareWith]
    Returns: WINatPOSRemoteActionWrapper
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getAnnouncementForGroup(String patentId){
        return WINatPOSUtilRemoteActions.getAnnouncementForGroup(patentId);
    }
    
    /*******************************************************************
    Purpose: Method returns category or brand related files for sub carusel on home page
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getCaruselForBrandOrCategory(String searchType, String brandId,String categoryId,String keyWord){
        return WINatPOSUtilRemoteActions.getCaruselForBrandOrCategory(searchType, brandId,categoryId,keyWord);
    }
    
    /*******************************************************************
    Purpose: Method returns information if pdf file can be genarate for search 
    and return pdf file url if image size isn't too big
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    @RemoteAction
    public static WINatPOSRemoteActionWrapper getSearchResultListPdf(String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country,Integer pageSize,Integer pageNumber){
        return WINatPOSUtilRemoteActions.getSearchResultListPdf(searchType,brandId,categoryId,keyWord,assetType,assetChannel,assetCluster,assetPlacment,country,pageSize,pageNumber,false);
    }
}