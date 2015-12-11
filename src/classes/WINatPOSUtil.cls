/**********************************************************************
Name: WINatPOSUtil
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class is a placeholder for helper methods in WINatPOS 
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          17/09/2014     INITIAL DEVELOPMENT
**********************************************************************/

public with sharing class WINatPOSUtil {
    
    public static final String assetTypeApproved='Approved';
    public static final String USER_LICENSE_PARTNER_COMMUNITY = 'Partner Community';
    public static final String USER_PROFILE_AGENCY_PORTAL_USER = 'AF - Agency Portal User';
    
    //available search types in applications
    public static final String categorySearch='categorySearch';
    public static final String brandSearch='brandSearch';
    public static final String innovationSearch='innovationSearch';
    public static final String repetableSearch='repetableSearch';
    public static final String keywordSearch='keywordSearch';
    public static final String bestPracticesSearch = 'bestPracticesSearch';
    public static final String ctaSearch = 'ctaSearch';
    public static final String assetTypeForBestPractisesSearch = 'Best Practices';
    public static final String assetTypeForInnovationSearch='Innovation';
    public static final String assetTypeForRepetableSearch='Repeatable Model';
    public static final String assetTypeForCTISearch='Call To Action';
    
    public static final String APPROVED = 'Approved';
    public static final String HIDDEN = 'hidden';
    public static final String VISIBLE = 'visible';
    public static final String ARTWORK = 'Artwork';
    public static final String PRESENTATION = 'Presentation';
    public static final String PROD_ENGINEERING = 'Production Engineering';
    public static final String DOWNLOAD_IMG = 'Download Image';
    public static final String winAtPostChatterGroupForTest='global Win@POS unique 12345678';
        
    //definition of aplicable filters for each searchType
    public static final Map<String, List<String>> mapOfAvailableFilters=new Map<String,List<String>>{
        keywordSearch    => new List<String>{'Categories','Asset Types','Channels','Clusters','Placement'},
        categorySearch   => new List<String>{'Brands','Asset Types','Channels','Clusters','Placement'},
        brandSearch      => new List<String>{'Categories','Asset Types','Channels','Clusters','Placement'},
        bestPracticesSearch		=> new List<String>{'Categories','Brands','Clusters','Countries'},
        innovationSearch => new List<String>{'Categories','Brands'},
        repetableSearch  => new List<String>{},
        ctaSearch => new List<String>{'Categories','Brands','Channels','Clusters','Placement'}    
    };
        
    //asset type translations from data model values to UI designe names      
    public static final Map<String,String> assetTypeTranslationFromDbToUI = new Map<String,String>{
		'Masterbrand' => 'Brand Guideline',
        'Innovation'  => 'Innovation Guidelines',
        'Best Practices' => 'Best Practices',
        'Repeatable Model' =>'Repeatable Models',
        'Call To Action' => 'Call To Action'    
    };
        
    //asset type translations from UI designe names to dat model values   
    public static final Map<String,String> assetTypeTranslationFromUIToDb = new Map<String,String>{
		'Brand Guideline' => 'Masterbrand',
        'Innovation Guidelines' => 'Innovation',
        'Best Practices' => 'Best Practices',
        'Repeatable Models' => 'Repeatable Model',
        'Call To Action' => 'Call To Action'    
    };
    
	 /*******************************************************************
	Purpose: Method return filters for asset used in search page 
	Parameters: [String,String]
	Returns: [String]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<WINatPOSRemoteActionWrapper.FilterLineItemWrapper> getFiltersForAsset(String searchType,String brandId,String categoryId,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country,String categoryName){
        //System.Debug('*** WINatPOS getFiltersForAsset input parameter: ' + brandId);
        
        List<WINatPOSRemoteActionWrapper.FilterLineItemWrapper> filterInfoList=new List<WINatPOSRemoteActionWrapper.FilterLineItemWrapper>();
        
        if(WINatPOSUtil.keywordSearch == searchType || WINatPOSUtil.brandSearch == searchType || WINatPOSUtil.bestPracticesSearch == searchType || WINatPOSUtil.innovationSearch == searchType || WINatPOSUtil.ctaSearch == searchType){
            List<WINatPOSRemoteActionWrapper.FilterOptions> categoryFilterOptions=new List<WINatPOSRemoteActionWrapper.FilterOptions>();
            categoryFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All Categories',null));
            system.debug('*** WINatPOS getFiltersForAsset creating category filter');
            if(brandId != null && brandId != ''){
                //use where clause only when brandId is selected
                for(Category_Brands__c cat: [select Category__r.Name,Category__c,Category__r.Parent_Category_Name__c from Category_Brands__c where Brand__c =:brandId order by Category__r.Name asc LIMIT 5000]){
                    categoryFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(cat.Category__c,cat.Category__r.Name,cat.Category__r.Parent_Category_Name__c));
                }
            }else{
                Map<String,String> mapOfUniqCat=new Map<String,String>();
                for(Category_Brands__c cat: [select Category__r.Name,Category__c,Category__r.Parent_Category_Name__c from Category_Brands__c order by Category__r.Name asc LIMIT 5000]){
                    if(!mapOfUniqCat.containsKey(cat.Category__c)){
                    	categoryFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(cat.Category__c,cat.Category__r.Name,cat.Category__r.Parent_Category_Name__c));
                        mapOfUniqCat.put(cat.Category__c,cat.Category__r.Name);
                    }    
                }
            }
            String categoriesSelectedValue=categoryId == null ? '':categoryId;
            filterInfoList.add(new WINatPOSRemoteActionWrapper.FilterLineItemWrapper('Categories', false,categoryFilterOptions,categoriesSelectedValue));
            
        }
        
        
        if(WINatPOSUtil.categorySearch == searchType || WINatPOSUtil.bestPracticesSearch == searchType || WINatPOSUtil.innovationSearch == searchType || WINatPOSUtil.keywordSearch == searchType || WINatPOSUtil.ctaSearch == searchType){
            List<WINatPOSRemoteActionWrapper.FilterOptions> brandFilterOptions=new List<WINatPOSRemoteActionWrapper.FilterOptions>();
            Boolean bestPractisesSearchWithCategory = false;
            if((WINatPOSUtil.bestPracticesSearch == searchType || WINatPOSUtil.ctaSearch == searchType) && categoryId != null){
                bestPractisesSearchWithCategory = true;
            }
            if(bestPractisesSearchWithCategory){
                brandFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All '+categoryName+' Brands',null));
            }else{
                brandFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All Brands',null));
            }
            system.debug('*** WINatPOS getFiltersForAsset creatring brand filter');
            if(categoryId != null && categoryId != ''){
                //use where clause only when brandId is selected
                for(Category_Brands__c brand: [select Brand__r.Name,Brand__c from Category_Brands__c where Category__c =:categoryId order by Brand__r.Name asc LIMIT 5000]){
                    brandFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(brand.Brand__c,brand.Brand__r.Name,null));
                }
            }else{
                Map<String,String> mapOfUniqBrand=new Map<String,String>();
                for(Category_Brands__c brand: [select Brand__r.Name,Brand__c from Category_Brands__c order by Brand__r.Name asc LIMIT 5000]){
                    if(!mapOfUniqBrand.containsKey(brand.Brand__c)){
                    	brandFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(brand.Brand__c,brand.Brand__r.Name,null));
                        mapOfUniqBrand.put(brand.Brand__c,brand.Brand__r.Name);
                    }    
                }
            }    
            String brandsSelectedValue=brandId == null ? '':brandId;
            filterInfoList.add(new WINatPOSRemoteActionWrapper.FilterLineItemWrapper('Brands', false,brandFilterOptions,brandsSelectedValue));
            
        }
        
        if(WINatPOSUtil.keywordSearch == searchType || WINatPOSUtil.categorySearch == searchType || WINatPOSUtil.brandSearch == searchType){
            List<WINatPOSRemoteActionWrapper.FilterOptions> assetTypesFilterOptions=new List<WINatPOSRemoteActionWrapper.FilterOptions>();
            assetTypesFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All Assets',null));
            Schema.DescribeFieldResult fieldResultType = Asset__c.POS_Asset_Type__c.getDescribe();
            for(Schema.PicklistEntry f : fieldResultType.getPicklistValues()) {
                if(!assetTypeTranslationFromDbToUI.containsKey(f.getValue())){
                	assetTypesFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(f.getValue(),f.getLabel(),null));
                }else{
                    String translatedAssetType=assetTypeTranslationFromDbToUI.get(f.getValue());
                    assetTypesFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(translatedAssetType,translatedAssetType,null));
                }    
            }
            String assetTypeSelectedValue=assetType == null ? '':assetType;
            filterInfoList.add(new WINatPOSRemoteActionWrapper.FilterLineItemWrapper('Asset Types', false,assetTypesFilterOptions,assetTypeSelectedValue));
        }
        
        if(WINatPOSUtil.keywordSearch == searchType || WINatPOSUtil.categorySearch == searchType || WINatPOSUtil.brandSearch == searchType || WINatPOSUtil.ctaSearch == searchType){
            List<WINatPOSRemoteActionWrapper.FilterOptions> channelsFilterOptions=new List<WINatPOSRemoteActionWrapper.FilterOptions>();
            channelsFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All Channels',null));
            Schema.DescribeFieldResult fieldResultChannels = Asset__c.Channels__c.getDescribe();
            for(Schema.PicklistEntry f : fieldResultChannels.getPicklistValues()) {
                channelsFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(f.getValue(),f.getLabel(),null));
            }
            String channelSelectedValue=assetChannel==null ? '': assetChannel;
            filterInfoList.add(new WINatPOSRemoteActionWrapper.FilterLineItemWrapper('Channels', true,channelsFilterOptions,channelSelectedValue));
        }
		
		if(WINatPOSUtil.keywordSearch == searchType || WINatPOSUtil.categorySearch == searchType || WINatPOSUtil.brandSearch == searchType || WINatPOSUtil.bestPracticesSearch == searchType || WINatPOSUtil.ctaSearch == searchType){        
            List<WINatPOSRemoteActionWrapper.FilterOptions> clustersFilterOptions=new List<WINatPOSRemoteActionWrapper.FilterOptions>();
            clustersFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All Clusters',null));
            Schema.DescribeFieldResult fieldResultMarket = Asset__c.Market_Cluster__c.getDescribe();
            for(Schema.PicklistEntry f : fieldResultMarket.getPicklistValues()) {
               clustersFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(f.getValue(),f.getLabel(),null));
            }
            String clusterSelectedValue=assetCluster == null ? '':assetCluster;
            filterInfoList.add(new WINatPOSRemoteActionWrapper.FilterLineItemWrapper('Clusters', false,clustersFilterOptions,clusterSelectedValue ));
        }
        
        if( WINatPOSUtil.categorySearch == searchType || WINatPOSUtil.brandSearch == searchType || WINatPOSUtil.ctaSearch == searchType){
            List<WINatPOSRemoteActionWrapper.FilterOptions> placementsFilterOptions=new List<WINatPOSRemoteActionWrapper.FilterOptions>();
            placementsFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All Placements',null));
            Schema.DescribeFieldResult fieldResultPlacement = Asset__c.Placement__c.getDescribe();
            for(Schema.PicklistEntry f : fieldResultPlacement.getPicklistValues()) {
                placementsFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(f.getValue(),f.getLabel(),null));
            }
            String placmentsSelectedValue=assetPlacment == null ? '':assetPlacment;
            filterInfoList.add(new WINatPOSRemoteActionWrapper.FilterLineItemWrapper('Placements', false,placementsFilterOptions,placmentsSelectedValue ));
        }
        
        if(WINatPOSUtil.bestPracticesSearch == searchType){
            List<WINatPOSRemoteActionWrapper.FilterOptions> assetCountriesFilterOptions=new List<WINatPOSRemoteActionWrapper.FilterOptions>();
            assetCountriesFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions('','All Countries',null));
            Schema.DescribeFieldResult fieldResultCountry = Asset__c.Country__c.getDescribe();
            for(Schema.PicklistEntry f : fieldResultCountry.getPicklistValues()) {
                assetCountriesFilterOptions.add(new WINatPOSRemoteActionWrapper.FilterOptions(f.getValue(),f.getLabel(),null));
            }
            String coutriesSelectedValue=country == null ? '' : country;
            filterInfoList.add(new WINatPOSRemoteActionWrapper.FilterLineItemWrapper('Countries', false,assetCountriesFilterOptions,coutriesSelectedValue));
        }
        
        
        return filterInfoList;
        
    }
    /*******************************************************************
	Purpose: Store the download URL on the file record to avoid querying the API for every file access event 
	Parameters: [File__c]
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static void cacheFeedURL(File__c f) {
        try {
            ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, f.Feed_ID__c);
            ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
            f.Feed_URL__c = ca.downloadUrl;
            if (ca.renditionUrl != null) {
                f.Feed_Thumbnail_URL__c = ca.renditionUrl.replace('THUMB120BY90', 'THUMB720BY480');
            }
        } catch (Exception e) {
            system.debug('********Exception in method cacheFeedURL'+e.getMessage());
        }       
    }
    
    /*******************************************************************
	Purpose: Method resposible for inserting records to search statistics object 
    used for reports porpouse
	Parameters: [String brand,String category,String channels,String clusters,String keyword,String placement]
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static void insertRecordToSearchStatistic(String brand,String category,String channels,String clusters,String keyword,String placement,String assetType,String country){
        
        String defineSearchType='';
        if(keyword != null && keyword != ''){
            if((brand != null && brand != '') || (category != null && category != '') || (channels != null && channels != '')  
               || (clusters != null && clusters != '')|| (placement != null && placement != '')
               || (assetType != null && assetType != '') || (country != null && country != '')){
            	defineSearchType  ='Combined';
            }else{
                defineSearchType = 'Keyword';
            }
               
        }else{
            defineSearchType = 'Search Filter';
        }
        insert new Search_Statistics__c(Brand__c=brand,Category__c=category,Channels__c=channels,
                                        Clusters__c=clusters,Keyword__c=keyword,Placement__c=placement,
                                        Type__c=defineSearchType,Searched_By__c=UserInfo.getUserId(),
                                        Timestamp__c=DateTime.now(),Asset_Type__c=assetType,Country__c=country
                                       );
    }
    
    
    /*******************************************************************
	Purpose: Method resposible for paging search results 
    used for reports porpouse
	Parameters: [List<WINatPOSRemoteActionWrapper.AssetResultWrapper> searchResults, Integer pageSize,Integer pageNumber]
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<WINatPOSRemoteActionWrapper.AssetResultWrapper> getResultsForPage(List<WINatPOSRemoteActionWrapper.AssetResultWrapper> searchResults, Integer pageSize,Integer pageNumber){
        System.Debug('*** WINatPOS getResultsForPage input parameter pageSize: ' + pageSize +' pageNumber: ' +pageNumber);
        if(!searchResults.isEmpty()){
            if(pageNumber<1){
                //set page on first page
                pageNumber=1;
            }
            Integer startIndex=pageSize*(pageNumber-1);
            system.debug('*** WINatPOS getResultsForPage start Index: '+startIndex);
            List<WINatPOSRemoteActionWrapper.AssetResultWrapper> pagedResults=new List<WINatPOSRemoteActionWrapper.AssetResultWrapper>();
            Boolean firstIteration=true;
            for(Integer i=startIndex;i<startIndex+pageSize;i++){
                if(searchResults.size() > i){
                    pagedResults.add(searchResults[i]);
                }
            }
            System.Debug('*** WINatPOS getResultsForPage number of items which will be returned:' +pagedResults.size());
            return pagedResults;
        }else{
            //list of results is empty then return empty list
            return searchResults;
        }
    }
	
	/*******************************************************************
	Purpose: Method resposible for returning applicable results to pdf search page  
    used for reports porpouse
	Parameters: [List<WINatPOSRemoteActionWrapper.AssetResultWrapper> searchResults, Integer pageSize,Integer pageNumber]
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<WINatPOSRemoteActionWrapper.AssetResultWrapper> getResultsForPDFPage(List<WINatPOSRemoteActionWrapper.AssetResultWrapper> searchResults, Integer pageSize,Integer pageNumber){
        System.Debug('*** WINatPOS getResultsForPDFPage input parameter pageSize: ' + pageSize +' pageNumber: ' +pageNumber);
        if(!searchResults.isEmpty()){
            if(pageNumber<1){
                //set page on first page
                pageNumber=1;
            }
            Integer startIndex=pageSize*(pageNumber-1);
            system.debug('*** WINatPOS getResultsForPDFPage start Index: '+startIndex);
            List<WINatPOSRemoteActionWrapper.AssetResultWrapper> pagedResults=new List<WINatPOSRemoteActionWrapper.AssetResultWrapper>();
            Boolean firstIteration=true;
            for(Integer i=0;i<startIndex+pageSize;i++){
                if(searchResults.size() > i){
                    pagedResults.add(searchResults[i]);
                }
            }
            System.Debug('*** WINatPOS getResultsForPDFPage number of items which will be returned:' +pagedResults.size());
            return pagedResults;
        }else{
            //list of results is empty then return empty list
            return searchResults;
        }
    }
    
    /*******************************************************************
	Purpose: Helper method for sorting results in correct order under search resutl page 
    used for reports porpouse
	Parameters: [List<WINatPOSRemoteActionWrapper.AssetResultWrapper> searchResults, Integer pageSize,Integer pageNumber]
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static Integer getWeightForSorting(String type){
        if(type == null || type== ''){
            //if type is not specified always will be at the end of results
            return -2;
        }else if(type == 'Innovation'){
            return 4;
        }else if(type == 'Repeatable Model'){
            return 3;
        }else if(type == 'Masterbrand'){
            return 2;
        }else if(type == 'Best Practices'){
            return 1;
        }else if(type == WINatPOSUtil.assetTypeForCTISearch){
            return 0;
        }
        return -2;//if value is not specified always will be displayed at the end of results
    }
    
    /*******************************************************************
	Purpose: Method is helper method to combine two list into one uniq list of assets.
	Parameters: [List<Asset__c firstList,List<Asset__c> secondList]
	Returns: [WINatPOSRemoteActionWrapper]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<Asset__c> combineAssetsLists(List<Asset__c> firstList,List<Asset__c> secondList){
        System.Debug('*** WINatPOS combineAssetsLists input parameter first list: ' + firstList +' second list: ' +secondList);
        Map<id,Asset__c> finalListOfAssets=new Map<id,Asset__c>();
        for(Asset__c assetItem : firstList){
            if(!finalListOfAssets.containsKey(assetItem.id)){
                finalListOfAssets.put(assetItem.id,assetItem);
            }
        }
        
        for(Asset__c assetItem : secondList){
            if(!finalListOfAssets.containsKey(assetItem.id)){
                finalListOfAssets.put(assetItem.id,assetItem);
            }
        }
        System.Debug('*** WINatPOS combineAssetsLists returned list: ' + finalListOfAssets.values());
        return finalListOfAssets.values();
    }
    
    /*******************************************************************
	Purpose: Method is helper method to convert html text to plain text without
    any html tags 
	Parameters: [String html]
	Returns: [String]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static string convertHtmlToPlainText(String html){
        //System.Debug('*** WINatPOS convertHtmlToPlainText input parameter html: ' + html);
         //first replace all <BR> tags with \n to support new lines
        if(html != null){
            string result = html.replaceAll('<br/>', '\n');
            result = result.replaceAll('<br />', '\n');
            
            //regular expression to match all HTML/XML tags
            string HTML_TAG_PATTERN = '<.*?>';
            
            // compile the pattern     
            pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
            
            // get your matcher instance
            matcher myMatcher = myPattern.matcher(result);
            
            //remove the tags     
            result = myMatcher.replaceAll('');
            //System.Debug('*** WINatPOS convertHtmlToPlainText converted text: ' + html);
            return result;
        }else{
            return null;
        }
        
    }
    
    /*******************************************************************
	Purpose: Method is querying for Assets of Community user ( with sharing )
	Parameters: [String query]
	Returns: [List<Asset__c>]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<sObject> retrieveForCommunityUsers(String query){
    	System.Debug('*** WINatPOS retrieveForCommunityUsers input parameter query: ' + query );
    	return Database.query(query);
    }
    
    /*******************************************************************
	Purpose: Method is searching for Community user ( with sharing )
	Parameters: [String query]
	Returns: [List<List<SObject>>]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<List<SObject>> searchForCommunityUsers(String query){
    	System.Debug('*** WINatPOS searchForCommunityUsers input parameter query: ' + query );
    	return Search.query(query);
    }
    
     /*******************************************************************
	Purpose: Method is querying for Brands for Community user ( with sharing )
	Parameters: [List<Brand_Master__c> brands]
	Returns: [List<Brand_Master__c>]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<Brand_Master__c> getBrandForCaruselByList(List<Brand_Master__c> brands){
    	System.Debug('*** WINatPOS searchForCommunityUsers input parameter brands: ' + brands );
    		
		return [select name,Brand_Logo__c,id,
                    (select ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId()),
                    (Select Feed_URL__c, Name,Feed_ID__c,id From Files__r order by Name asc)
                     from Brand_Master__c where id in : brands order by name];
	}
    
    /*******************************************************************
	Purpose: Method is querying for files for assets belongs to asset group
	Parameters: [Set<Id> brands]
	Returns: [List<Asset__c>]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<Asset__c> getAssetsForAssetGroupForSearch(Set<Id> assetIds){
    	System.Debug('*** WINatPOS getAssetsForAssetGroupForSearch with sharing input parameter brands: ' + assetIds );
    		
		return [SELECT Asset_Group__c,id,
               (select Feed_ID__c, Feed_Thumbnail_URL__c, Feed_URL__c, Is_Primary_Image__c FROM Files__r where Is_Primary_Image__c = true) 
               FROM Asset__c 
               WHERE Asset_Group__c in : assetIds and Status__c =: WINatPOSUtil.assetTypeApproved ];
	}
    
    
    /*******************************************************************
	Purpose: Method is querying for asset group detail page
	Parameters: [Set<Id> brands]
	Returns: [List<Asset__c>]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<Asset__c> getAssetsForAssetGroupDetailPage(Id assetGroupId){
    	System.Debug('*** WINatPOS getAssetsForAssetGroupDetailPage with sharing input parameter brands: ' + assetGroupId );
    		
		return [SELECT Owner.Name, Id, Asset_Group__c, Video_URL_Link__c, Asset_Group__r.Name, Name, Category__c,Touchpoint__c,Country__c,Category__r.Name, Brand__c, Brand__r.Name, Channels__c, Description__c, Placement__c, Market_Cluster__c,POS_Asset_Type__c, BET__c, BET__r.Name,Buy_Online_in_Europe__c, 
               (SELECT Id, Name, Category__c, Category__r.Name, Type__c, Sub_Type__c, File_Button_Text__c, Is_Primary_Image__c, Feed_ID__c, Feed_URL__c,Feed_Thumbnail_URL__c 
               FROM Files__r 
               Order BY Sort_Order__c ASC),
               (SELECT ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId())                
               FROM Asset__c 
               WHERE  Status__c = :WINatPOSUtil.APPROVED
               AND Asset_Group__c = :assetGroupId 
               Order By Name ASC];
	}
	
	
	/*******************************************************************
	Purpose: Method is querying for Categories for Community user ( with sharing )
	Parameters: [List<Category__c> categories]
	Returns: [List<Category__c>]
	Throws [Exceptions]: [optional] 
	********************************************************************/	
	public static List<Category__c> getCatForCaruselByList(List<Category__c> categories){
		System.Debug('*** WINatPOS searchForCommunityUsers input parameter categories: ' + categories );
		
		return [SELECT name,Category_Logo__c,id,
                    (SELECT ParentId, SubscriberId FROM FeedSubscriptionsForEntity WHERE SubscriberId =: UserInfo.getUserId()),
                    (SELECT Feed_URL__c, Name,Feed_ID__c,id FROM CategoryUploads__r ORDER BY Name ASC)
                     FROM Category__c WHERE Id IN : categories ORDER BY name];
	}
	
	/*******************************************************************
	Purpose: Method is querying for Assets for Home page for Community user ( with sharing )
	Parameters: [optional]
	Returns: [List<Category__c>]
	Throws [Exceptions]: [optional] 
	********************************************************************/	
	public static List<Asset__c> getAssetsForHomePage(){
		System.Debug('*** WINatPOS getAssetsForHomePage ' );
		return [select id,Name,POS_Asset_Type__c,Description__c,LastModifiedDate, Video_URL_Link__c,
                                     (Select Feed_Thumbnail_URL__c,Feed_Id__c from Files__r where Is_Primary_Image__c=true),
                                     (select CommentCount, LikeCount,id from Feeds)
                                     From Asset__c where Carousel_Published__c=true
                                     ];
	}
	
	/*******************************************************************
	Purpose: Method returns Community name specified in Custom Setting
	Returns: [String]
	Throws [Exceptions]: [optional] 
	********************************************************************/	
	public static String getCommunityName(){
		System.Debug('*** WINatPOS getCommunityName ' );
		
		WinAtPos_General_Settings__c myCustomSetting = WinAtPos_General_Settings__c.getOrgDefaults();
		
		String communityName = '';
		
		if(myCustomSetting != null && myCustomSetting.Community_Name__c != null){
			communityName = myCustomSetting.Community_Name__c;
		}
		
		return communityName;
	}
   
   /*******************************************************************
	Purpose: Method is checking wheather given user is a Community User or not
	Parameters: [String myUser]
	Returns: [Boolean]
	Throws [Exceptions]: [optional] 
	********************************************************************/
   public static Boolean checkIsCommunityUser(Id userId, Id userProfileId){
   		System.Debug('*** WINatPOS checkIsCommunityUser input parameter userId: ' + userId + ' userProfileId: ' + userProfileId );
   		/*
		List<User> tmpUser = [SELECT User_License__c, ProfileId FROM User WHERE Id=:userId AND ProfileId =:userProfileId  LIMIT 1];
		//List<Profile> tmpProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId LIMIT 1];
		
		//if(!tmpUser.isEmpty() && !tmpProfile.isEmpty()){
		if(!tmpUser.isEmpty()){
			//if(tmpUser[0].User_License__c == WINatPOSUtil.USER_LICENSE_PARTNER_COMMUNITY && tmpProfile[0].Name == WINatPOSUtil.USER_PROFILE_AGENCY_PORTAL_USER){
			if(tmpUser[0].User_License__c == WINatPOSUtil.USER_LICENSE_PARTNER_COMMUNITY ){
				return true;
			}
		}*/
		
		return Network.getNetworkId() != null;
   }
   
   
    
    /*******************************************************************
	Purpose: Method is handlig url rewriting basing on who uploaded the file
	Parameters: [Asset__c myAsset]
	Returns: [void]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    
    public static String urlRewrite(String originUrl){
        System.Debug('*** WINatPOS urlRewrite input parameter originUrl: ' + originUrl);
        String communityName = WINatPOSUtil.getCommunityName();
        String fileUrl = originUrl;
        if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId()) && fileUrl != null){
            if(!fileUrl.startsWith('/'+communityName) && !fileUrl.containsIgnoreCase('https')){
                fileUrl = '/'+communityName+fileUrl;
            }else if(fileUrl.containsIgnoreCase('https')){
                Integer startIndex = fileUrl.indexOf('/sfc/servlet');
                if(startIndex != -1){
                    fileUrl = '/' + communityName+fileUrl.substring(fileUrl.indexOf('/sfc/servlet'),fileUrl.length());
                }
			
            }
        }else if(fileUrl != null && !fileUrl.containsIgnoreCase('https')){
            fileUrl = fileUrl.replace('/' + communityName, '');
        }
        System.debug('*** WINatPOS urlRewrite input parameter originUrl: ' + fileUrl);
        return fileUrl;
    }
}