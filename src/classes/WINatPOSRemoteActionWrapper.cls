/**********************************************************************
Name: WINatPOSRemoteActionWrapper
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a wrapper which keeps all wrapper classes for all remote actions called from WINatPOS 
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          17/09/2014     INITIAL DEVELOPMENT
**********************************************************************/


/*******************************************************************
	Purpose: Main wrapper class which is returend for all RemoteActions executed
	in WinAtPOS application on home page 
	********************************************************************/
public class WINatPOSRemoteActionWrapper {
    
    public String message=null;
    public String status=null;
    public List<object> data=null;
    public String error=null;
    public String urlToPdfFile{get;set;}
    public String totalAttachedFileSize{get;set;}
    public WINatPOSRemoteActionWrapper(String cMessage,String cStatus,List<object> cData,String cError){
        this.message=cMessage;
        this.status=cStatus;
        this.data=cData;
        this.error=cError;
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper for brand and categories items in 
	navigation menu in WinAtPOS application 
	********************************************************************/
    public class MenuWrapper{
        public String recNumber;
        public String name=null;
        public List<object> items=null;
        
        public MenuWrapper(String cRecNumber,String cName, List<object> cItems){
            this.recNumber=cRecNumber;
            this.name=cName;
            this.items=cItems;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper for annoucement for chatter  
	********************************************************************/
    public class GroupAnnaucment{
        public String title;
        public String description;
        public String imageUrl;
        public String announcementUrl;
        public String announceDate;
        public String authorName;
        public String authorUrl;
        public String groupName;
        public String annouceTitle;
        public GroupAnnaucment(){}
        
        
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper for chatter group members  
	********************************************************************/
    public class ChatterGroupMember{
        public String userName;
        public String userId;
        public ChatterGroupMember(String cUserName,String cUserId){
            this.userName=cUserName;
            this.userId=cUserId;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper which is used in search method
    to build applicable where clauses
	********************************************************************/
    public class WhereClauseWrapper{
        public String whereClauseForAsset;
        public String whereClauseForTouchpoint;
        public String whereClauseForAssetGroup;
        
        public WhereClauseWrapper(String cWhereClauseForAsset,String cWhereClauseForAssetGroup,String cWhereClauseForTouchpoint){
            this.whereClauseForAsset=cWhereClauseForAsset;
            this.whereClauseForAssetGroup=cWhereClauseForAssetGroup;
            this.whereClauseForTouchpoint=cWhereClauseForTouchpoint;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper for brand or categories items in 
	navigation menu in WinAtPOS application 
	********************************************************************/
    public class MenuLineItemWrapper{
        public String name=null;
        public String itemId=null;
        public String image=null;
        public String parentCategory;
        public String categoryUrl = null;
        public String categoryUrl2 = null;
        
        public MenuLineItemWrapper(String cName,String cItemId, String cImage,String cParentCategory){
            this.name=cName;
            this.itemId=cItemId;
            this.image=cImage;
            this.parentCategory=cParentCategory;
        }
        
        public MenuLineItemWrapper(String cName, String cItemId, String cImage, String cParentCategory, String cCategoryUrl, String cCategoryUrl2){
            this.name = cName;
            this.itemId = cItemId;
            this.image = cImage;
            this.parentCategory = cParentCategory;
            this.categoryUrl = cCategoryUrl;
            this.categoryUrl2 = cCategoryUrl2;
        }
        
        
    }
    
    /* moved to phase 2 
    public class UserPreferencesWrapper{
        public List<UserPreferencesLineItemWrapper> userCategoryPreferences=null;
        public List<UserPreferencesLineItemWrapper> userBrandPreferences=null;
        
        public UserPreferencesWrapper(List<UserPreferencesLineItemWrapper> cUserCategoryPreferences,List<UserPreferencesLineItemWrapper> cUserBrandPreferences){
            this.userCategoryPreferences=cUserCategoryPreferences;
            this.userBrandPreferences=cUserBrandPreferences;
        }
        
    }
    
    public class UserPreferencesLineItemWrapper{
        public String optionName=null;
        public String checked;
        public UserPreferencesLineItemWrapper(String cOptionName, String cChecked){
            this.optionName=cOptionName;
            this.checked=cChecked;
        }
        
    }
	*/
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in serch method resposible
	for returnig applicable values in filters
	********************************************************************/
    public class FilterLineItemWrapper{
        
        public String filterName=null;
        public Boolean isMultiselect=null;
        List<FilterOptions> filterValues=null;
        String selectedValue;
        public FilterLineItemWrapper(String cFilterName,Boolean cIsMultiselect,List<FilterOptions> cFilterValues,String cSelectedValue){
            
            this.filterName=cFilterName;
            this.isMultiselect=cIsMultiselect;
            this.filterValues=cFilterValues;
            this.selectedValue=cSelectedValue;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in FilterLineItemWrapper class resposible
	for returnig applicable values for each filter
	********************************************************************/
    public class FilterOptions{
        String value;
        String label;
        String parentCategory;
        public FilterOptions(String cValue,String cLabel, String cParentCategory){
            this.value=cValue;
            this.label=cLabel;
            this.parentCategory=cParentCategory;
            
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in search method is placeholder
    of search results
	********************************************************************/
    public class SearchWrapper{
        public List<FilterLineItemWrapper> searchFilters;
        public List<AssetResultWrapper> assetSearchResult;
        public List<Asset__c> assetHelperResult{get;set;}
        public List<Asset_Group__c> assetGroupHelperResult{get;set;}
        public SearchWrapper(List<FilterLineItemWrapper> cSearchFilters,List<AssetResultWrapper> cAssetSearchResult){
            this.searchFilters=cSearchFilters;
            this.assetSearchResult=cAssetSearchResult;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in getAssetDetail method is placeholder
    of assetDetail results
	********************************************************************/
    public class AssetsDetaislWrapper{
        Boolean showAssetGroupView;
        Boolean showAssetDetailView;
        Boolean userFollowTheCollection;
        String assetGroupdownloadPdfUrl;
        public String assetGroupId;
        public String assetGroupName;
        public List<AssetDetailItem> assetItems; 
        
        public AssetsDetaislWrapper(Boolean cShowAssetGroupView,Boolean cShowAssetDetailView,List<AssetDetailItem> cAssetItems,Boolean cUserFollowTheCollection,String cAssetGroupId,String cAssetGroupdownloadPdfUrl,String cAssetGroupName){
            this.showAssetGroupView=cShowAssetGroupView;
            this.showAssetDetailView=cShowAssetDetailView;
            this.assetItems=cAssetItems;
            this.userFollowTheCollection=cUserFollowTheCollection;
            this.assetGroupId=cAssetGroupId;
            this.assetGroupdownloadPdfUrl=cAssetGroupdownloadPdfUrl;
            this.assetGroupName=cAssetGroupName;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in getAssetDetail method and 
    is responsible for presenting statistics on AssetDetail page
	********************************************************************/
    public class AssetDetailStats{
        String userName;
        String userPhotoUrl;
        public AssetDetailStats(String cUserName,String cUserPhotoUrl){
            this.userName=cUserName;
            this.userPhotoUrl=cUserPhotoUrl;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in getAssetDetail method and 
    is responsible for presenting data for single Asset record
	********************************************************************/
    public class AssetDetailItem{
        public String assetId{get;set;}
        public String assetName{get;set;}
        public String assetBrand{get;set;}
        public String assetCategory{get;set;}
        public String assetChannels{get;set;}
        public String assetCountry{get;set;}
        public String assetPlacement{get;set;}
        public String assetTouchpoint{get;set;}
        public String assetDescription{get;set;}
        public String assetOwner{get;set;}
        public String assetType{get;set;}
        public String assetCluster{get;set;}
        public String brandExpirenceUrl{get;set;}
        public String primaryImageUrl{get;set;}
        public String artworkURL{get;set;}
        public String presentationURL{get;set;}
        public String productionEngineeringURL{get;set;}
        public String downloadImageURL{get;set;}
        public String buyOnlineInEuropeUrl{get;set;}
        public Boolean userFollowAsset{get;set;}
        public String feedId{get;set;}
        public String assetPrimaryFileId{get;set;}
        public String assetDownloadPdfUrl{get;set;}
        public String videoUrl{get;set;}
        public List<AssetDetailStats> downloadStatistics;
        public List<AssetDetailStats> shareStatistics;
        public List<AssetDetailStats> followStatistics;
        public List<File__c> assetFiles;
        public AssetDetailItem(){}
        /*
        public AssetDetailItem(String cAssetOwner,String cAssetId,String cAssetName,String cAssetBrand,String cAssetCategory,
                               String cAssetChannels,String cAssetCountry,
                               String cAssetPlacement,String cAssetTouchpoint,String cAssetDescription,
                               List<File__c> cAssetFiles,String cPrimaryImageUrl, String aURL, 
                               String pURL, String peURL, String diURL,String cBrandExpirenceUrl,String cBuyOnlineInEuropeUrl,
                               Boolean cUserFollowAsset,String cFeedId,String cAssetPrimaryFileId,
                               List<AssetDetailStats> cDownloadStatistics,List<AssetDetailStats> cShareStatistics){
            this.assetOwner=cAssetOwner;                       
            this.assetId=cAssetId;
            this.assetName=cAssetName;
            this.assetBrand=cAssetBrand;
            this.assetCategory=cAssetCategory;
            this.assetChannels=cAssetChannels;
            this.assetCountry=cAssetCountry;
            this.assetTouchpoint=cAssetTouchpoint;
            this.assetDescription=cAssetDescription;                       
            this.assetFiles=cAssetFiles;
            this.primaryImageUrl = cPrimaryImageUrl;
            this.artworkURL = aURL;
            this.presentationURL = pURL;
            this.productionEngineeringURL = peURL;
            this.downloadImageURL = diURL;
            this.brandExpirenceUrl=cBrandExpirenceUrl;
            this.buyOnlineInEuropeUrl=cBuyOnlineInEuropeUrl;
            this.userFollowAsset=cUserFollowAsset;
            this.feedId=cFeedId;
            this.assetPrimaryFileId=cAssetPrimaryFileId;
            this.downloadStatistics=cDownloadStatistics;
            this.shareStatistics=cShareStatistics;
                                   
        }
		*/
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in to present applicable data
	for carusel on home page
	********************************************************************/
    public class AssetCaruselWrapper {
        public String assetId=null;
        public String assetName=null;
        public String assetDescription=null;
        public String assetType=null; 
        public List<String> relatedFiles=null;
        public Integer likeCount;
        public Integer commentCount;
        public Set<String> topics;
        public String modifyDate;
        public String videoUrl;
        public AssetCaruselWrapper(String cAssetId,String cAssetName,String cAssetDescription,String cAssetType, List<String> cRelatedFiles,Integer cLikeCount,Integer cCommentCount,Set<String> cTopics,String cModifyDate, String cVideoUrl){
            this.assetId=cAssetId;
            this.relatedFiles=cRelatedFiles;
            this.assetName=cAssetName;
            this.assetType=cAssetType;
            this.assetDescription=cAssetDescription;
            this.likeCount=cLikeCount;
            this.commentCount=cCommentCount;
            this.topics=cTopics;
            this.modifyDate=cModifyDate;
            this.videoUrl = cVideoUrl;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used in to present data for search
	method each intance of object represent signle result which can be asset or
    asset group
	********************************************************************/
    public class AssetResultWrapper implements Comparable{
        public Asset__c assetItem=null;
        public List<String> relatedFiles=null;
        public Asset_Group__c assetGroupItem=null;
        public String itemName='';
        public AssetResultWrapper(Asset__c cAssetItem, List<String> cRelatedFiles,Asset_Group__c cAssetGroupItem,String cItemName){
            this.relatedFiles=cRelatedFiles;
            if(cAssetItem != null){
                this.assetItem=cAssetItem;
                this.itemName=cAssetItem.Name;
            }else if(cAssetGroupItem != null){
                this.assetGroupItem=cAssetGroupItem;
                this.itemName=cAssetGroupItem.Name;
            }
        }
        
        /*******************************************************************
        Purpose: Method responsible for sorting search result in correct order 
        navigation menu on home page 
        Parameters: [Object ]
        Returns: WINatPOSRemoteActionWrapper
        ********************************************************************/
        public Integer compareTo(Object compareTo) {
    		AssetResultWrapper compareToAssResult = (AssetResultWrapper)compareTo;
            //Sorting in asc order
            //Set weight of the sorting order
            String compereToElemenType=compareToAssResult.assetItem !=null ? compareToAssResult.assetItem.POS_Asset_Type__c : compareToAssResult.assetGroupItem.Type__c;
            String currentElemenType=assetItem !=null ? assetItem.POS_Asset_Type__c : assetGroupItem.Type__c;
            Integer compereToElemenWeight=WINatPOSUtil.getWeightForSorting(compereToElemenType);
            Integer currentElemenWeight=WINatPOSUtil.getWeightForSorting(currentElemenType);
            
            if(currentElemenWeight<compereToElemenWeight){
                return 1;
            }else if(currentElemenWeight == compereToElemenWeight){
                //if type of asset or asset group is equal sort aplhabetically
                return itemName.compareTo(compareToAssResult.itemName);
            }else{
                return -1;
            }
            
		}
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper used  to present data for sub carusel on 
    home page for selected category or brand
	********************************************************************/
    
    public class BrandCategoryCaruselWrapper{
		public String name;
        public String logoUrl;
        public String recordId;
        public Boolean isUserFollowRecord;
        public List<RelatedFiles> filesRelated;    
        public BrandCategoryCaruselWrapper(String cName,String cLogoUrl,List<RelatedFiles> cfilesRelated,String cRecordId,Boolean cIsUserFollowRecord){
            this.name=cName;
            this.logoUrl=cLogoUrl;
            this.filesRelated=cfilesRelated;
            this.recordId=cRecordId;
            this.isUserFollowRecord=cIsUserFollowRecord;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper to keep information about files 
    wrapper used for sub carusel on home page for 
	********************************************************************/
    
    public class RelatedFiles{
		public String fileName;
        public String downloadUrl;
        public String fileId;
        public String feedId;
        public RelatedFiles(String cFileName,String cDownloadUrl,String cFileId,String cFeedId){
            this.fileName=cFileName;
            this.downloadUrl=cDownloadUrl;
            this.fileId=cFileId;
            this.feedId=cFeedId;
        }
    }
    
    /*******************************************************************
	Purpose: Sub class which is a wrapper to keep information about assets 
	for searched assets on main search used in pdf 
	********************************************************************/
    public class AssetDetailForPDF{
        public String assetName{get;set;}
        public String assetDescription{get;set;}
        public String assetBrand{get;set;}
        public String assetChannel{get;set;}
        public String assetPrimaryImage{get;set;}
        public String assetPrimaryFileId{get;set;}
        public String assetPrimaryFileFeedId{get;set;}
    }
}