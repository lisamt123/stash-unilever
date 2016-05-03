/**********************************************************************
Name: uw_BETDetailService
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a placeholder for remote actions called from Bet application - detail page
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             08/12/2014      INITIAL DEVELOPMENT
**********************************************************************/

public with sharing class uw_BETDetailService {
    private static Map<String, String> fieldToLabel = new Map<String, String>{
        'assetName'         =>  'Name',
        'assetMediaType'    =>  'Media_Type__c',
        'assetCountry'      =>  'Country__c',
        'assetLastUpdated'  =>  'LastModifiedDate',
        'displayOrder'      =>  'Order_Of_Display__c'
    };

    private static Map<String, String> feedFieldToLabel = new Map<String, String>{
        'draftName'         =>  'ContentFileName',
        'draftCreatedDate'  =>  'CreatedDate'
    };

    public class BetException extends Exception {}

    /*******************************************************************
    Purpose: Method returns BET
    Parameters: [String betId]
    Returns: uw_BET__c
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    private static uw_BET__c getBet(String betId){
        try { 
            uw_BET__c bet = [ SELECT Id, Name, Background_Colour__c, Banner_1_Location__c, Banner_2_Location__c, Banner_Colour__c, 
                                Border_Colour__c, CollaborationGroupId__c, Date_Published__c,Description__c, FirstReleaseDate__c, 
                                FinalReleaseDate__c,Final_Release_Due_Date__c,First_Release_Due_Date__c, Font_Colour__c, Icon_Location__c, Inoplan_Project__c, Inoplan_Project__r.Name,
                                Launch_Date__c, Presentation_Id__c, Region__c, Status__c, Sharing__c, LastModifiedDate, CreatedDate, 
                                Studio_Chatter_Group__c, OwnerId, Owner.Name, Brand_Keyword_Search__c, Category_Keyword_Search__c, 
                                Owner_Keyword_Search__c, Region_Keyword_Search__c, 
                                Inoplan_Project_Keyword_Search__c,Product_Brand__c, Product_Brand__r.name, IPM_Project__c, IPM_Project__r.name, 
                                Category_Group__c, Product_Category__c, Brand_Position__c ,is_Archived__c, Brand_Position__r.name,
                                Total_Actual_Assets__c,Total_Expected_Assets__c
                                FROM uw_BET__c WHERE Id = :betId ];
            return bet;
        }catch(QueryException qe) {
            throw new BetException('No BET found.');
        }  
    }

    /*******************************************************************
    Purpose: Method returns concrete Asset which belongs to concrete BET
    Parameters: [String betId, String assetId]
    Returns: uw_Asset__c
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    private static uw_Asset__c getBetAsset(String betId, String assetId){
        try {
            uw_Asset__c asset = [ SELECT Id, Name, Media_Type__c, Studio_Asset_Type__c, uw_BET__c, CreatedDate, LastModifiedDate, Description__c, Url_of_asset__c, Related_Feed_Item__c, Related_Feed_Comment__c, Order_Of_Display__c FROM uw_Asset__c WHERE Id = :assetId AND uw_BET__c = :betId ];
            return asset;
        }catch(QueryException qe) {
            throw new BetException('No Asset found.');
        }  
    }
    
    public static uw_BETWrapper.DetailWrapper getBETDetails(String betId, String currentUserId){
        BET_CommonService.checkAccessForPublicBET(betId, currentUserId);
        uw_BET__c bet = uw_BETDetailService.getBet(betId);


        List<uw_BET_Team_Member__c> member = [SELECT Id, Access_Level__c, BET__c, BETEnabled__c, Editing__c, Pending_Request__c,
                                        Email__c, IsOwner__c, Role__c, StudioEnabled__c, Team_Member__c 
                                        FROM uw_BET_Team_Member__c WHERE BET__c =:betId AND Team_Member__c =:currentUserId LIMIT 1];

        uw_BETWrapper.DetailWrapper detailWrapper;
        uw_BETWrapper.BetSearchItem betItem;
        if(member.size() > 0){
            betItem = new uw_BETWrapper.BetSearchItem(bet, member[0].Pending_Request__c, true, true, member[0].IsOwner__c);
            uw_BETWrapper.MemberItem memberItem = new uw_BETWrapper.MemberItem(member[0]);
            detailWrapper = new uw_BETWrapper.DetailWrapper(betItem, memberItem, 0); 
        }else{
            betItem = new uw_BETWrapper.BetSearchItem(bet, false, true, false, false); 
            detailWrapper = new uw_BETWrapper.DetailWrapper(betItem, null, 0);
        }

        return detailWrapper;
    }

    private static String buildWhereClauses(String betId, String mediaType, String countryName, String subFunctionType){
        String whereClauseForBet = 'WHERE uw_BET__c = \''+betId+'\'';
        if(subFunctionType != null  && subFunctionType != ''){                
            if(subFunctionType == 'Brand Development'){
                whereClauseForBet += ' AND Status__c = \'Approved\'';
            }else if(subFunctionType == 'Brand Building'){
                whereClauseForBet += ' AND Status__c = \'Shared\'';
            }else{
                //@TODO: validate if not this: whereClauseForBet += ' AND (Status__c = \'Draft\' AND Sub_Function__c = \'Brand Development\')';
                whereClauseForBet += ' AND Status__c = \'Draft\'';
            }
        }

        if(mediaType != null && mediaType != '' ){                                
            whereClauseForBet += ' AND Media_Type__c = \''+mediaType+'\'';
        }

        if(countryName != null  && countryName != ''){
            whereClauseForBet += ' AND Country__c includes (\''+countryName+'\')';
        }  
                   
        return whereClauseForBet; 
    }

    private static List<uw_Asset__c> gatherResults(String betId, String mediaType, String countryName, String subFunctionType, Integer pageSize, Integer pageNumber, Boolean sortAsc, String sortField){
        Integer startIndex = pageSize * (pageNumber-1);

        String whereClauseForBet = uw_BETDetailService.buildWhereClauses(betId, mediaType, countryName, subFunctionType);

        if( sortField != null && sortField.trim() != '' && uw_BETDetailService.fieldToLabel.containsKey(sortField.trim())){
            sortField = uw_BETDetailService.fieldToLabel.get(sortField.trim());
        }else{
            sortField = 'LastModifiedDate';  
        }
 
        String orderDir = sortAsc ? 'ASC' : 'DESC';

        String finalSoqlQuery = 'SELECT Id, Name, Media_Type__c, Country__c, LastModifiedDate, Description__c, Url_of_asset__c, CreatedById, Order_Of_Display__c, File_Id__c FROM uw_Asset__c ' + whereClauseForBet + ' ORDER BY '+ sortField + ' ' + orderDir +' LIMIT '+pageSize+' OFFSET '+startIndex ;
        List<uw_Asset__c> assetList = new List<uw_Asset__c>();

        assetList = Database.query(finalSoqlQuery);        
        
        return assetList;   
    }

    public static uw_BETWrapper.AssetWrapper getBETAssets(String betId, String mediaType, String countryName, String subFunctionType, Integer pageSize, Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){
        List<uw_Asset__c> assetsList = uw_BETDetailService.gatherResults(betId, mediaType, countryName, subFunctionType, pageSize, pageNumber, sortAsc, sortField); 

        List<uw_BETWrapper.FilterLineItemWrapper> filterList = new List<uw_BETWrapper.FilterLineItemWrapper>();
        if(withFilters){
            filterList = uw_BETUtil.getFiltersForAsset(mediaType, countryName, subFunctionType);
        }

        uw_BETWrapper.AssetWrapper assetWrapper;       
        if(assetsList.isEmpty()){
            assetWrapper = new uw_BETWrapper.AssetWrapper(filterList,null);
        }else{
            Id currentUserId = UserInfo.getUserId();

            List<uw_BETWrapper.AssetItem> assetResultWrapper=new List<uw_BETWrapper.AssetItem>();
            for(uw_Asset__c asset : assetsList){
                if(asset.CreatedById == currentUserId){
                    assetResultWrapper.add(
                        new uw_BETWrapper.AssetItem(asset, true)
                    );
                }else{
                    assetResultWrapper.add(
                        new uw_BETWrapper.AssetItem(asset, false)
                    );
                }                
            }
            assetWrapper=new uw_BETWrapper.AssetWrapper(filterList,assetResultWrapper);
        }

        return assetWrapper;
    }

    /*******************************************************************
    Purpose: Method for deleting concrete Asset which belongs to concrete BET
    Parameters: [String betId, String assetId]
    Returns:
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static Boolean deleteBETAsset(String betId, String assetId){
        uw_Asset__c asset = uw_BETDetailService.getBetAsset(betId, assetId);

        Boolean presentationRemoved = false;
        Savepoint sp = Database.setSavepoint();
        try{  

            if(asset.Related_Feed_Item__c != null){
                List<Feeditem> feedList = [SELECT Id FROM Feeditem WHERE Id = :asset.Related_Feed_Item__c LIMIT 1];
                if(feedList.size() == 1){
                    delete feedList[0];
                }
            }

            if(asset.Studio_Asset_Type__c == 'Brand Experience Presentation'){
                List<uw_Asset__c> assetList = [SELECT Id FROM uw_Asset__c WHERE Studio_Asset_Type__c = 'Brand Experience Presentation'
                                                AND uw_BET__c = : asset.uw_BET__c AND LastModifiedDate > :asset.LastModifiedDate LIMIT 1];

                if(assetList.size() == 0 ){
                    List<uw_BET__c> betList = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: asset.uw_BET__c LIMIT 1];
                    if(betList.size() > 0 ){
                        betList[0].Presentation_Id__c = null;
                        presentationRemoved = true;
                        update betList;
                    }                    
                }
            }            

            delete asset;
            return presentationRemoved;

        }catch(Exception qe) {
            Database.rollback(sp);
            throw new BetException('Problem with deleting asset: '+qe.getMessage());
        }
    }

    public static List<uw_BETWrapper.DraftItem> getBETChatterFiles(String betId, Integer pageSize, Integer pageNumber, Boolean sortAsc, String sortField){
        Integer startIndex = pageSize * (pageNumber-1);

        uw_BET__c bet = uw_BETDetailService.getBet(betId);
        List<uw_Asset__c> assetList = [SELECT Id, Related_Feed_Item__c FROM uw_Asset__c WHERE uw_BET__c = :bet.Id];

        Set<Id> feedIds = new Set<Id>();
        for(uw_Asset__c a : assetList){
            feedIds.add(a.Related_Feed_Item__c);
        }

        if( sortField != null && sortField.trim() != '' && uw_BETDetailService.feedFieldToLabel.containsKey(sortField.trim())){
            sortField = uw_BETDetailService.feedFieldToLabel.get(sortField.trim());
        }else{
            sortField = 'CreatedDate';  
        }
        String orderDir = sortAsc ? 'ASC' : 'DESC';

        String groupId = bet.Studio_Chatter_Group__c;
        String query = 'SELECT Id, ContentFileName, CreatedDate, CreatedBy.Name FROM CollaborationGroupFeed WHERE Type=\'ContentPost\' AND ParentId = :groupId AND Id NOT IN :feedIds ORDER BY ' +sortField+ ' ' +orderDir +' LIMIT ' +pageSize+'  OFFSET ' +startIndex;
        system.debug('--------============-----------');
        system.debug(query);
        system.debug(groupId);
        system.debug(feedIds);
        List<CollaborationGroupFeed> feedList = Database.query(query);
        List<uw_BETWrapper.DraftItem> draftList = new List<uw_BETWrapper.DraftItem>();
        for(CollaborationGroupFeed f : feedList){
            draftList.add(new uw_BETWrapper.DraftItem(f));
        }
        return draftList;
    }

    public static Id chatterFileToDraftAsset(String betId, String feedId){
        try{            
            FeedItem feed = [SELECT Id, ContentFileName, Title, CreatedDate FROM FeedItem WHERE Id = :feedId LIMIT 1];        
            uw_Asset__c file = new uw_Asset__c();
            file.Related_Feed_Item__c = feedId;
            file.uw_BET__c = betId;
            file.Status__c = 'Draft';
            file.Name = feed.ContentFileName;
            if ( ! Test.isRunningTest()) {
                ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Related_Feed_Item__c);      
                ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
                if(ca != null){
                    file.URL_of_Asset__c = ca.downloadUrl;
                    file.thumbnail__c = ca.renditionUrl;
                    file.File_Id__c = ca.Id;
                }else{
                    throw new BetException('Can\'t find attachment for Feed');
                } 
            }else{
                file.URL_of_Asset__c = BET_TestingHelper.UT_ASSETDOWNLOADLINK;
                file.thumbnail__c = BET_TestingHelper.UT_ASSETTHUMBLINK;
            }

            try{  
                insert file;
                return file.Id;
            }catch(Exception qe) {throw new BetException('Problem with creating asset: '+qe.getMessage());}
        }catch(Exception qe){throw new BetException('Problem with creating asset: '+qe.getMessage());}          
    }

    public static void deleteChatterFileDraft(String feedId){
        try{            
            FeedItem feed = [SELECT Id, Title, CreatedDate FROM FeedItem WHERE Id = :feedId LIMIT 1];        
            delete feed;
        }catch(Exception qe){
            throw new BetException('Problem with deleting feed: '+qe.getMessage());
        }          
    }
}