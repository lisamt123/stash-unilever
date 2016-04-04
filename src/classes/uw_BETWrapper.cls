/**********************************************************************
Name: uw_BETSearchService
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a wrapper which keeps all wrapper classes for all remote actions called from Bet 
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             26/11/2014      INITIAL DEVELOPMENT
1.1 -   Piotr Czechumski        10/09/2015      Add to BetSearchItem fields Group category, category, brand position, brand
**********************************************************************/

/*******************************************************************
    Purpose: Main wrapper class which is returend for all RemoteActions executed
    in Bet application on home page 
    ********************************************************************/
public with sharing class uw_BETWrapper {
    public String message=null;
    public String status=null;
    public Map<String, Object> data=null;
    public String error=null;   

    public uw_BETWrapper(String cMessage, String cStatus, Map<String, Object> cData, String cError) {
        this.message = cMessage;
        this.status = cStatus;
        this.data = cData;
        this.error = cError;
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in search method is placeholder
    of search results
    ********************************************************************/
    public class SearchWrapper{
        public List<FilterLineItemWrapper> searchFilters;
        public List<BetSearchItem> betSearchResult;
        public SearchWrapper(List<FilterLineItemWrapper> cSearchFilters,List<BetSearchItem> cBetSearchResult){
            this.searchFilters=cSearchFilters;
            this.betSearchResult=cBetSearchResult;
        }
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in search method is placeholder
    of search results
    ********************************************************************/
    public class DetailWrapper{
        public BetSearchItem bet;
        public MemberItem memberSetting;
        
        public DetailWrapper(BetSearchItem cBetItem, MemberItem cMemberSetting, Integer cRelatedGroup){
            this.bet=cBetItem;
            this.memberSetting = cMemberSetting;
        }
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in search method is placeholder
    of search results
    ********************************************************************/
    public class AssetWrapper{
        public List<FilterLineItemWrapper> searchFilters;
        public List<AssetItem> assetResult;
        public AssetWrapper(List<FilterLineItemWrapper> cSearchFilters,List<AssetItem> cAssetResult){
            this.searchFilters=cSearchFilters;
            this.assetResult=cAssetResult;
        }
    }

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
        public FilterOptions(String cValue,String cLabel){
            this.value=cValue;
            this.label=cLabel;            
        }
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in to present data for search
    method each intance of object represent signle result which can be BET
    ********************************************************************/
    public class BetResultWrapper{
        public BetSearchItem betItem=null;
        public List<String> relatedFiles=null;
        public BetResultWrapper(BetSearchItem cBetItem, List<String> cRelatedFiles){
            this.relatedFiles=cRelatedFiles;
            if(cBetItem != null){
                this.betItem=cBetItem;
            }
        }
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in getBETAssets method and 
    is responsible for presenting data for single Asset record
    ********************************************************************/
    public class AssetItem{
        public String assetId;
        public String assetName;
        public String assetMediaType;
        public String assetCountry;
        public Datetime assetLastModifiedDate;
        public String assetDescription;
        public String assetDownloadLink;
        public Boolean assetOwner;
        public Integer displayOrder;
        public String assetPreviewLink;

        public String validLinkPrefix = 'sfc/servlet.shepherd/version/download/';
       
        public AssetItem(uw_Asset__c asset, Boolean aOwner){            
            this.assetId = asset.Id;
            this.assetName = asset.Name;
            this.assetMediaType = asset.Media_Type__c;
            this.assetCountry = asset.Country__c;
            this.assetLastModifiedDate = asset.LastModifiedDate;
            this.assetDescription = asset.Description__c;
            this.assetDownloadLink = asset.Url_of_asset__c;  
            this.assetOwner = aOwner;    
            this.displayOrder = (Integer)asset.Order_Of_Display__c;

            if(asset.File_Id__c != null){
                this.assetPreviewLink = '/apex/BET_AssetDispatcher?fileId='+asset.File_Id__c+'&type='+BET_AssetDispatcherController.PREVIEW;
                this.assetDownloadLink = '/apex/BET_AssetDispatcher?fileId='+asset.File_Id__c+'&type='+BET_AssetDispatcherController.DOWNLOAD+'&downloadLink='+this.assetDownloadLink;
            } else {
                if(this.assetDownloadLink != null && this.assetDownloadLink.contains(validLinkPrefix)){ 
                    Integer startIdx = asset.URL_of_Asset__c.indexOf('/download/'); 
                    if(startIdx > -1){
                        this.assetPreviewLink = '/'+this.assetDownloadLink.substring(startIdx+10, startIdx+25);
                    }
                } else if(this.assetDownloadLink != null){
                    this.assetPreviewLink = this.assetDownloadLink;
                }
            }
        }
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in getBETFeeds method and 
    is responsible for presenting data for single Feed record
    ********************************************************************/
    public class DraftItem{
        public String draftId;
        public String draftName;
        public Datetime draftCreatedDate;     
        public String draftCreatedByName;   
       
        public DraftItem(CollaborationGroupFeed feed){            
            this.draftId = feed.Id;
            this.draftName = feed.ContentFileName;
            this.draftCreatedDate = feed.CreatedDate;
            this.draftCreatedByName = feed.CreatedBy.Name;
        }
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in getBET method and 
    is responsible for presenting data for single BET record
    ********************************************************************/
    public class MemberItem{
        public Id memberId;
        public Id memberBetId;
        public Boolean memberBetEnabled;
        public Boolean memberEditing;
        public Boolean memberPending;
        public String memberEmail;
        public Boolean memberIsOwner;
        public String memberRole;
        public Boolean memberStudioEnabled;
        public Id memberTeamMemberId;

        public MemberItem(uw_BET_Team_Member__c cMember){
            this.memberId = cMember.Id;
            this.memberBetId = cMember.BET__c;
            this.memberBetEnabled = cMember.BETEnabled__c;
            this.memberEditing = cMember.Editing__c;
            this.memberPending = cMember.Pending_Request__c;
            this.memberEmail = cMember.Email__c;
            this.memberIsOwner = cMember.IsOwner__c;
            this.memberRole = cMember.Role__c;
            this.memberStudioEnabled = cMember.StudioEnabled__c;
            this.memberTeamMemberId = cMember.Team_Member__c;
        }
    }

    /*******************************************************************
    Purpose: Sub class which is a wrapper used in getBET method and 
    is responsible for presenting data for single BET record
    ********************************************************************/
    public class BetSearchItem{
        public String betId;
        public String betName;
        public String betDescription;
        public String betBrandName;
        public String betRegion;
        public String betProjectName;
        public String betProjectId;
        public String betIPMProjectName;
        public String betIPMProjectId;
        public String betStatus;
        public Datetime betLastUpdated;
        public Boolean betActive;
        public Boolean betHasAccess;
        public Boolean betHasAccessPending;
        public Boolean betOwner;
        public Boolean betIsPublic;
        public String betOwnerName;
        public String betBrandKeyword;
        public String betCategoryKeyword;
        public String betOwnerKeyword;
        public String betRegionKeyword;
        public String betInfoprojectKeyword;  
        public String betChatterGroupId;  
        public Datetime betFirstRelease;  
        public Datetime betFinalRelease;  
        public Datetime betFirstReleaseDueDate;  
        public Datetime betFinalReleaseDueDate;
        public String betPresentationId;
        public String betBackgroundColor;
        public String betBannerLocation;
        public String betFontColor;
        public String betBannerColor;
        public String betBorderColor;
        public String betIconLocation; 
        public Datetime betLaunchDate;
        public String betOwnerId;
        public String betVisibility;


        public String groupCategory;
        public String category;
        public String brandPosition;
        public String brand;
        public String betBrandPositionName;

        public Boolean currentUserHasAccessToIPM;

        public Boolean archived;

        public Boolean completedFirstAfterDueDate = false;
        public Boolean completedFinalAfterDueDate = false;

        public Integer totalActualAssets;
        public Integer totalExpectedAssets;

        public Boolean beforeFinalDueDate;
        public Boolean beforeFirstDueDate;

        public Boolean expectedAssetsProvided {get;set;}

        public Boolean assetPrioritySet {get;set;}
        
        public BetSearchItem(String betId, String betName, String betChatterGroupId, Datetime betFinalRelease, String betPresentationId, String betIconLocation, String betDescription, String betBrandName, String betRegion, String betProjectName,
            String betIPMProjectName,  
            String betStatus, Datetime betLastUpdated, String betOwnerName, Boolean betActive, Boolean betHasAccess, Boolean betOwner, String betBrandKeyword, 
            String betCategoryKeyword, String betOwnerKeyword, String betRegionKeyword, String betInfoprojectKeyword){
            
            this.betId = betId;
            this.betName = betName;
            this.betDescription = betDescription;
            this.betBrandName = betBrandName;
            this.betRegion = betRegion; 
            this.betProjectName = betProjectName;
            this.betIPMProjectName = betIPMProjectName;
            if(!String.isBlank(this.betIPMProjectName)){
                this.betProjectName = this.betIPMProjectName;
            }
            this.betStatus = betStatus;
            this.betLastUpdated = betLastUpdated;
            this.betActive = betActive;
            this.betHasAccess = betHasAccess;  
            this.betOwner = betOwner;     
            this.betOwnerName = betOwnerName;   
            this.betBrandKeyword = betBrandKeyword;
            this.betCategoryKeyword = betCategoryKeyword;
            this.betOwnerKeyword = betOwnerKeyword;
            this.betRegionKeyword = betRegionKeyword;
            this.betInfoprojectKeyword = betInfoprojectKeyword;
            this.betChatterGroupId = betChatterGroupId;
            this.betFinalRelease = betFinalRelease;
            this.betPresentationId = betPresentationId;
            this.betIconLocation = betIconLocation;
            this.betIsPublic = false;
            this.archived = !betActive;
        }

        public BetSearchItem(uw_BET__c bet, Boolean betPending, Boolean betActive, Boolean betHasAccess, Boolean betOwner){            
            this.betId = bet.Id;
            this.betName = bet.Name;
            this.betDescription = bet.Description__c;
            this.betBrandName = bet.Product_Brand__r.Name;
            this.betRegion = bet.Region__c; 
            this.betProjectName = bet.Inoplan_Project__r.Name;
            this.betProjectId = bet.Inoplan_Project__c;
            this.betIPMProjectName = String.isBlank(bet.IPM_Project__r.Name) ? bet.Inoplan_Project_Keyword_Search__c : bet.IPM_Project__r.Name;
            this.betIPMProjectId = bet.IPM_Project__c;
            this.betVisibility=bet.sharing__C;
            if(!String.isBlank(this.betIPMProjectId)){
                this.betProjectName = this.betIPMProjectName;
            }
            this.betStatus = bet.Status__c;
            this.betLastUpdated = bet.LastModifiedDate;
            this.betActive = betActive; 
            this.betHasAccess = betHasAccess;  
            this.betOwner = betOwner;     
            this.betOwnerName = bet.Owner.Name;
            this.betOwnerId = bet.OwnerId;   
            this.betBrandKeyword = bet.Brand_Keyword_Search__c;
            this.betCategoryKeyword = bet.Category_Keyword_Search__c;
            this.betOwnerKeyword = bet.Owner_Keyword_Search__c;
            this.betRegionKeyword = bet.Region_Keyword_Search__c;
            this.betInfoprojectKeyword = bet.Inoplan_Project_Keyword_Search__c;
            this.betHasAccessPending = betPending;
            this.betChatterGroupId = bet.Studio_Chatter_Group__c;
            this.betFirstRelease = bet.FirstReleaseDate__c;
            this.betFinalRelease = bet.FinalReleaseDate__c;
            this.betFirstReleaseDueDate = bet.First_Release_Due_Date__c;
            this.betFinalReleaseDueDate = bet.Final_Release_Due_Date__c;
            this.betPresentationId = bet.Presentation_Id__c;
            this.betIconLocation = bet.Icon_Location__c;

            this.betBannerLocation = bet.Banner_1_Location__c;
            this.betBackgroundColor = bet.Background_Colour__c;
            this.betBannerColor = bet.Banner_Colour__c;
            this.betBorderColor = bet.Border_Colour__c;
            this.betFontColor = bet.Font_Colour__c;
            this.betIsPublic = bet.sharing__c == 'Public';
            this.betLaunchDate = bet.Launch_Date__c;

            this.groupCategory          = bet.Category_Group__c;
            this.category               = bet.Product_Category__c;
            this.brandPosition          = bet.Brand_Position__c;
            this.brand                  = bet.Product_Brand__c;
            this.archived               = bet.Is_Archived__c;
            this.betBrandPositionName   = bet.Brand_Position__r.name;

            this.totalActualAssets      = bet.Total_Actual_Assets__c != null ? Integer.valueOf(bet.Total_Actual_Assets__c) : 0;
            this.totalExpectedAssets    = bet.Total_Expected_Assets__c != null ? Integer.valueOf(bet.Total_Expected_Assets__c) : 0;


            if(this.betFirstRelease != null && this.betFirstReleaseDueDate != null ){
                this.completedFirstAfterDueDate = this.betFirstRelease >  this.betFirstReleaseDueDate;
            }
            
            if(this.betFinalRelease != null && this.betFinalReleaseDueDate != null ){
                this.completedFinalAfterDueDate = this.betFinalRelease >  this.betFinalReleaseDueDate;
            }

            if(this.betFinalReleaseDueDate != null) {
                this.beforeFinalDueDate = Date.today() <= this.betFinalReleaseDueDate;
            }

            if(this.betFirstReleaseDueDate != null) {
                this.beforeFirstDueDate = Date.today() <= this.betFirstReleaseDueDate;
            }
        }
    }
}