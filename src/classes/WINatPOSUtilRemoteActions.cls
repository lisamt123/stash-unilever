/**********************************************************************
Name: WINatPOSUtilRemoteActions
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a placeholder for all remote actions called from WINatPOS 
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          17/09/2014     INITIAL DEVELOPMENT
**********************************************************************/

public without sharing class WINatPOSUtilRemoteActions {
    
    /*******************************************************************
    Purpose: Method returns available values for Categories and Brands for 
    navigation menu on home page 
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper getMenu(){
         
         String communityName = WINatPOSUtil.getCommunityName();
        //create pattern to retrive url to brand logo
        String regexPattern='<img.+?src=[\"\'](.+?)[\"\'].+?>';
        Pattern logoPattern = Pattern.compile(regexPattern);
        //create list of all categories in system
        List<WINatPOSRemoteActionWrapper.MenuLineItemWrapper> categoryLineItems=new List<WINatPOSRemoteActionWrapper.MenuLineItemWrapper>(); 
        for(Category__c category: [select Id, Name, Parent_Category_Name__c,Category_Logo__c, Category_URL_Link__c, Category_URL_Link_2__c from Category__c where Parent_Category__c != null order by Name LIMIT 1000]){
            String urlToCategoryLogo=null;
            if(category.Category_Logo__c != null){
                Matcher logoMatcher=logoPattern.matcher(category.Category_Logo__c);
                if(logoMatcher.matches() && logoMatcher.groupCount() == 1){
                    urlToCategoryLogo=logoMatcher.group(1);
                }
                
                // for community users we have to add Commmunity prefix to URL
                //for internal users it have to be like it was oryginally 
                if(urlToCategoryLogo != null && WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
                    urlToCategoryLogo = urlToCategoryLogo.replace('/resource/', '/' + communityName + '/resource/');
                }
            }
            categoryLineItems.add(new WINatPOSRemoteActionWrapper.MenuLineItemWrapper(category.Name, String.valueOf(category.Id), urlToCategoryLogo, category.Parent_Category_Name__c, category.Category_URL_Link__c, category.Category_URL_Link_2__c));
        }
        
        //create list of all brands in system
        List<WINatPOSRemoteActionWrapper.MenuLineItemWrapper> brandLineItems=new List<WINatPOSRemoteActionWrapper.MenuLineItemWrapper>(); 
        for(Brand_Master__c brand: [select Id,Brand_Logo__c, Name from Brand_Master__c order by Name LIMIT 1000]){
            String urlToBrandLogo=null;
            if(brand.Brand_Logo__c != null){
                Matcher logoMatcher=logoPattern.matcher(brand.Brand_Logo__c);
                if(logoMatcher.matches() && logoMatcher.groupCount() == 1){
                    urlToBrandLogo=logoMatcher.group(1);
                    
                    // for community users we have to add Commmunity prefix to URL
		            //for internal users it have to be like it was oryginally 
		            if(urlToBrandLogo != null && WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
		            	urlToBrandLogo = urlToBrandLogo.replace('/resource/', '/' + communityName + '/resource/');
		            }
                }

            }
            
            
            brandLineItems.add(new WINatPOSRemoteActionWrapper.MenuLineItemWrapper(brand.Name,String.valueOf(brand.Id),urlToBrandLogo,null));
        }
        
        List<WINatPOSRemoteActionWrapper.MenuWrapper> menuWraps=new List<WINatPOSRemoteActionWrapper.MenuWrapper>{
            new WINatPOSRemoteActionWrapper.MenuWrapper('1','Categories',categoryLineItems),
            new WINatPOSRemoteActionWrapper.MenuWrapper('2','Brands',brandLineItems)
        };
        
        WINatPOSRemoteActionWrapper remoteWrapper=new WINatPOSRemoteActionWrapper('Category and Brands for menu','0',menuWraps,'');
        return remoteWrapper;
        
    }
    
    
    
    /*******************************************************************
    Purpose: Method  return list of assets which will be displayed in home Carusel
    Parameters: []
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/    
    public static WINatPOSRemoteActionWrapper getHomePageCarusel(){
        System.Debug('*** WINatPOS getHomePageCarusel ');
        List<File__c> filesWithoutThumbnailUrl=new List<File__c>();
        Set<String> uniqueTopics=new Set<String>();
        List<WINatPOSRemoteActionWrapper.AssetCaruselWrapper> caruselResults= new List<WINatPOSRemoteActionWrapper.AssetCaruselWrapper>();
        List<Asset__c> assetsList;
        if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
        	assetsList = WINatPOSUtil.getAssetsForHomePage();
        }else{
        	assetsList = [select id,Name,POS_Asset_Type__c,Description__c,LastModifiedDate, Video_URL_Link__c,
                                     (Select Feed_Thumbnail_URL__c,Feed_Id__c from Files__r where Is_Primary_Image__c=true),
                                     (select CommentCount, LikeCount,id from Feeds)
                                     From Asset__c where Carousel_Published__c=true
                                     ];
        }
        
        for(Asset__c asetItem : assetsList){
                                     	
            
            List<String> relatedFiles=new List<String>();                             
            if(asetItem.Files__r != null && !asetItem.Files__r.isEmpty()){
                if(asetItem.Files__r.get(0).Feed_Thumbnail_URL__c == null){
                    WINatPOSUtil.cacheFeedURL(asetItem.Files__r.get(0));
                    filesWithoutThumbnailUrl.add(asetItem.Files__r.get(0));
                }
                //add files to list
                /*
                String communityName = WINatPOSUtil.getCommunityName();
                String fileUrl = asetItem.Files__r.get(0).Feed_Thumbnail_URL__c;
                if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId()) && fileUrl != null){
                    if(!fileUrl.startsWith('/'+communityName) && !fileUrl.containsIgnoreCase('https')){
                        fileUrl = '/'+communityName+fileUrl;
                    }
                }else if(fileUrl != null && !fileUrl.containsIgnoreCase('https')){
                    fileUrl = fileUrl.replace('/' + communityName, '');
                }
				*/
                relatedFiles.add(WINatPOSUtil.urlRewrite(asetItem.Files__r.get(0).Feed_Thumbnail_URL__c));
            }
            asetItem.Description__c = WINatPOSUtil.convertHtmlToPlainText(asetItem.Description__c);                             
            Integer likeCount=0;
            Integer commentCount=0;
            uniqueTopics=new Set<String>();
            //Agregate likes and comments for each asset  
                                      
            for(Asset__Feed item: asetItem.Feeds){
                if(item != null){
                    likeCount += item.LikeCount;
                    commentCount += item.CommentCount;
                    
                    try{
                    	ConnectApi.TopicPage topicPage = ConnectApi.Topics.getTopics(null, item.id);
                    	for(ConnectApi.Topic topic: topicPage.topics){
	                        uniqueTopics.add(topic.name);
	                    }
                    }catch(Exception ex){
                    	System.debug('Probelm with Chatter files: ' + ex.getMessage());
                    }
                    
                    
                }
            }
            //convert dateTime to string to dislay in following format eg. September 16, 2014                             
            String convertedModifedDate = asetItem.LastModifiedDate.format('MMMMM d, yyyy');                                       
            WINatPOSRemoteActionWrapper.AssetCaruselWrapper assetCarusel=new  WINatPOSRemoteActionWrapper.AssetCaruselWrapper(asetItem.id, asetItem.name, asetItem.Description__c, asetItem.POS_Asset_Type__c, relatedFiles, likeCount, commentCount, uniqueTopics, convertedModifedDate, asetItem.Video_URL_Link__c);
            caruselResults.add(assetCarusel);                         
                                                                                                                                                           
        }
        System.Debug('*** WINatPOS getHomePageCarusel returned: ' + caruselResults);
        return  new WINatPOSRemoteActionWrapper('getHomePageCarusel','0',caruselResults,'');
        
        
        
    }
    
    /*******************************************************************
    Purpose: Method resposible for add user to follow the record
    Parameters: [String objectToFollowId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    static public void addFollower(String objectToFollowId) {
        System.Debug('*** WINatPOS addFollower input parameter: ' + objectToFollowId);
        EntitySubscription e = new EntitySubscription();
        e.subscriberId = UserInfo.getUserId();
        try{
            e.parentId = Id.valueOf(objectToFollowId);
            e.NetworkId = Network.getNetworkId();
            //Database.insert(e,false);
            insert e;
        }catch(Exception ex){
            System.Debug('*** WINatPOS addFollower returned error: ' + ex.getMessage());
        }
    }
    
    
    /*******************************************************************
    Purpose: Method resposible for unfollow the record
    Parameters: [String objectToFollowId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    static public void removeFollower(String objectToFollowId) {
        System.Debug('*** WINatPOS removeFollower input parameter: ' + objectToFollowId);
        try{
           delete [select id from EntitySubscription where ParentId =:objectToFollowId and SubscriberId =: UserInfo.getUserId()]; 
        }catch(Exception ex){
            System.Debug('*** WINatPOS removeFollower returned error: ' + ex.getMessage());
        }
        
    }
    
    /*******************************************************************
    Purpose: Method resposible for display memebers of WinAtPost chatter group
    Parameters: [String objectToFollowId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper retriveUserFromWinAtPosGroup(){
        WinAtPOSRemoteActions__c  remotActionConf=WinAtPOSRemoteActions__c.getValues('WinAtPOSRemoteActionConf');
        String winAtPosGroup=remotActionConf != null ? remotActionConf.WinAtPosGroup__c :'';
        if(System.Test.isRunningTest()){
            winAtPosGroup=WinAtPOSUtil.winAtPostChatterGroupForTest;
        }
        System.Debug('*** WINatPOS retriveUserFromWinAtPosGroup start retriving members');
        List<CollaborationGroup> colGroup=[SELECT Id,Name From CollaborationGroup where name =: winAtPosGroup limit 1];
        if(!colGroup.isEmpty()){
            Id winAtPosChatterId=colGroup.get(0).Id;
            //ConnectApi.ChatterGroup chatterGroup=ConnectApi.ChatterGroups.getGroup(null, winAtPosChatterId);
            ConnectApi.GroupMemberPage groupMember = ConnectApi.ChatterGroups.getMembers(null, winAtPosChatterId);
            List<WINatPOSRemoteActionWrapper.ChatterGroupMember> winAtPosMembers = new List<WINatPOSRemoteActionWrapper.ChatterGroupMember>();
            for(ConnectApi.GroupMember grMember: groupMember.members){
                winAtPosMembers.add(new WINatPOSRemoteActionWrapper.ChatterGroupMember(grMember.user.name,grMember.user.id));
            }
            system.debug('*** WINatPOS retriveUserFromWinAtPosGroup returned following results:'+Json.serialize(winAtPosMembers));
            return new WINatPOSRemoteActionWrapper('retriveUserFromWinAtPosGroup method','0',winAtPosMembers,'');
        }else{
            return new WINatPOSRemoteActionWrapper('retriveUserFromWinAtPosGroup method returned no results','0',null,'');
        }
        
    }
    
    /*******************************************************************
    Purpose: Method resposible for sharing Asset Record Feed
    Parameters: [String objectToFollowId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static void shareAssetFile(String assetFeedId,String userIdToShareWith){
        System.Debug('*** WINatPOS shareAssetFile input parameter: ' + assetFeedId + ' userIdToShareWith:'+userIdToShareWith);
        ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, assetFeedId);
        system.debug('Check id user can share this feed : '+fi.canShare);
        ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
        system.debug(ca.id);
        ContentDocumentLink shareFile = new ContentDocumentLink();
        shareFile.ContentDocumentId=ca.id;
        shareFile.LinkedEntityId=userIdToShareWith;
        shareFile.ShareType='V';
        shareFile.Visibility='AllUsers';
        try{
            upsert shareFile;
            System.Debug('*** WINatPOS shareAssetFile sharing was added for user '+ userIdToShareWith); 
        }catch(Exception ex){
            System.Debug('*** WINatPOS shareAssetFile returned error:' +ex.getMessage());
        }
    }
    
    
    
    public static void addRecordToDonwloadStatistics(String feedId,String fileId){
        System.Debug('*** WINatPOS addRecordToDonwloadStatistics input parameter: ' + feedId);
        try{
            Download_Statistics__c downloadStatistics = new Download_Statistics__c();
            ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, feedId);
            ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
            downloadStatistics.Content_Document_Id__c=ca.id;
            downloadStatistics.Content_Name__c=ca.title;
            downloadStatistics.Content_Size__c= Decimal.valueOf(ca.fileSize);
            downloadStatistics.Content_Type__c=ca.fileType;
            downloadStatistics.Content_Version_Id__c=ca.versionId;
            downloadStatistics.FileId__c=fileId;
            downloadStatistics.Downloaded_By__c=UserInfo.getUserId();
            downloadStatistics.Downloaded_in_Country__c=[select Country from User where id =: UserInfo.getUserId()].Country;
            downloadStatistics.Timestamp__c = DateTime.now();
            insert downloadStatistics;
            System.Debug('*** WINatPOS addRecordToDonwloadStatistics inserted with success');
        }catch(Exception ex){
            System.Debug('*** WINatPOS addRecordToDonwloadStatistics error: ' + ex.getMessage());
        }
        
    }
    
    /*******************************************************************
    Purpose: Method display asset details, accepting assetId or assetGroupId
    if signle asset selected on search page pass selected assetId 
    if assetGroup selected on search page pass selected assetGroupId
    Parameters: [Strin assetOrAssetGroupId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    
    public static void addRecordsToDonwloadStatistics(Map<String,String> mapOfFilesAndFeeds){
        //feedId,String fileId
        System.Debug('*** WINatPOS addRecordsToDonwloadStatistics input parameter: ' + mapOfFilesAndFeeds);
        List<Download_Statistics__c> filesAddedToStatistic=new List<Download_Statistics__c>();
        String userCountry=[select Country from User where id =: UserInfo.getUserId()].Country;
        try{
            for(String fileId: mapOfFilesAndFeeds.keySet()){
                //add to download statistics only if file have a feed id
                if(mapOfFilesAndFeeds.get(fileId) != null){
                    Download_Statistics__c downloadStatistics = new Download_Statistics__c();
                    ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, mapOfFilesAndFeeds.get(fileId));
                    ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
                    downloadStatistics.Content_Document_Id__c=ca.id;
                    downloadStatistics.Content_Name__c=ca.title;
                    downloadStatistics.Content_Size__c= Decimal.valueOf(ca.fileSize);
                    downloadStatistics.Content_Type__c=ca.fileType;
                    downloadStatistics.Content_Version_Id__c=ca.versionId;
                    downloadStatistics.FileId__c=fileId;
                    downloadStatistics.Downloaded_By__c=UserInfo.getUserId();
                    downloadStatistics.Downloaded_in_Country__c=userCountry;
                    downloadStatistics.Timestamp__c = DateTime.now();
                    filesAddedToStatistic.add(downloadStatistics);
                }    
            }
            if(!filesAddedToStatistic.isEmpty()){
                system.debug('check number of rows to insert '+filesAddedToStatistic.size());
                system.debug('statments which were called' + Limits.getDMLStatements());
                system.debug('total limit' + Limits.getLimitDMLStatements());
                system.debug(filesAddedToStatistic);
                
                insert filesAddedToStatistic;
                System.Debug('*** WINatPOS addRecordToDonwloadStatistics inserted with success');
            }
        }catch(Exception ex){
            System.Debug('*** WINatPOS addRecordToDonwloadStatistics error: ' + ex.getMessage());
        }
        
    }
    
    public static Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> retriveStatistics(String fileId, String AssetId){
        System.Debug('*** WINatPOS retriveStatistics input parameter: ' + fileId +' asset id: '+AssetId);
        Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> statistics = new Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>>();
        try{
            if(fileId != null && fileId != ''){
                List<Download_Statistics__c> downloadStats=[select Downloaded_By__r.Name,Downloaded_By__c from Download_Statistics__c where FileId__c =:fileId  order by Timestamp__c desc limit 5 ];
                
                Set<id> setOfUserIds=new Set<id>();
                for(Download_Statistics__c downStat: downloadStats){
                    setOfUserIds.add(downStat.Downloaded_By__c);
                }
                Map<id,String> userAvatarMap=new Map<id,String>();
                if(setOfUserIds.size()>0){
                    for(User u :[select id,SmallPhotoUrl from user where id in: setOfUserIds]){
                        userAvatarMap.put(u.id,u.SmallPhotoUrl);
                    }
                }
                
                List<WINatPOSRemoteActionWrapper.AssetDetailStats> downloadStatLisWrapper = new List<WINatPOSRemoteActionWrapper.AssetDetailStats>();
                for(Download_Statistics__c downStat: downloadStats){
                     //ConnectApi.Photo.url
                     String userFotorUrl=null;
                    /*
                     ConnectApi.Photo userAvatar=ConnectApi.ChatterUsers.getPhoto(null, downStat.Downloaded_By__c);
                    if(userAvatar != null){
                        userFotorUrl=userAvatar.smallPhotoUrl;
                    }
					*/
                    system.debug('*** WINatPOS user name '+downStat.Downloaded_By__r.Name);
                    
                    if(userAvatarMap.containsKey(downStat.Downloaded_By__c)){
                        userFotorUrl=userAvatarMap.get(downStat.Downloaded_By__c);
                    }
					
                    downloadStatLisWrapper.add(new WINatPOSRemoteActionWrapper.AssetDetailStats(downStat.Downloaded_By__r.Name,userFotorUrl));
                    system.debug(new WINatPOSRemoteActionWrapper.AssetDetailStats(downStat.Downloaded_By__r.Name,userFotorUrl));
                }
                statistics.put('downloadStatistics',downloadStatLisWrapper);
            }else{
                system.debug('*** WINatPOS retriveStatistics for download not returend results because file id is null');
                statistics.put('downloadStatistics',new List<WINatPOSRemoteActionWrapper.AssetDetailStats>()); 
            }
            
        }catch(Exception ex){
            system.debug('*** WINatPOS retriveStatistics there was problem to retrive download statistics: ' +ex.getMessage());
            statistics.put('downloadStatistics',new List<WINatPOSRemoteActionWrapper.AssetDetailStats>());
        }
        
        try{
            List<File__c> fileList=[select Feed_Id__c from File__c where id =:fileId];
            system.debug(fileList);
            List<WINatPOSRemoteActionWrapper.AssetDetailStats> shareStatLisWrapper = new List<WINatPOSRemoteActionWrapper.AssetDetailStats>();
            /*
            if(!fileList.isEmpty()){
                ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, fileList.get(0).Feed_Id__c);
                ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
                Set<Id> setOfUsers = new Set<Id>();
                for(ContentDocumentLink dockLink : [select ContentDocumentId, LinkedEntityId, ShareType, Visibility from ContentDocumentLink where ContentDocumentId =: ca.id order by SystemModstamp desc limit 20]){
                    setOfUsers.add(dockLink.LinkedEntityId);
                    if(setOfUsers.size()>4){
                        break;
                    }
                }
                
                for(User u : [select id,name from User where id in : setOfUsers]){
                    String userFotorUrl=null;
                    ConnectApi.Photo userAvatar=ConnectApi.ChatterUsers.getPhoto(null, u.id);
                    if(userAvatar != null){
                        userFotorUrl=userAvatar.smallPhotoUrl;
                    }
                    shareStatLisWrapper.add(new WINatPOSRemoteActionWrapper.AssetDetailStats(u.Name,userFotorUrl));    
                }  
            }
			*/
            statistics.put('shareStatistics',shareStatLisWrapper);
        }catch(Exception ex){
            system.debug('*** WINatPOS retriveStatistics there was problem to retrive share statistics: ' +ex.getMessage());
            statistics.put('shareStatistics',new List<WINatPOSRemoteActionWrapper.AssetDetailStats>());
        }
        try{
            List<WINatPOSRemoteActionWrapper.AssetDetailStats> followStatLisWrapper = new List<WINatPOSRemoteActionWrapper.AssetDetailStats>();
            Set<Id> subscriberSet = new Set<ID>();
            for(EntitySubscription subEntity:[select subscriberId,parentId from EntitySubscription where ParentId =:AssetId order by CreatedDate desc limit 5]){
                subscriberSet.add(subEntity.subscriberId);    
            }
            
            for(User u :[select name,id,SmallPhotoUrl from user where id in : subscriberSet]){
                /*
                String userFotorUrl=null;
                 ConnectApi.Photo userAvatar=ConnectApi.ChatterUsers.getPhoto(null, u.id);
                if(userAvatar != null){
                    userFotorUrl=userAvatar.smallPhotoUrl;
                }
                system.debug('*** WINatPOS user name '+u.name);
				*/
                followStatLisWrapper.add(new WINatPOSRemoteActionWrapper.AssetDetailStats(u.name,u.SmallPhotoUrl));
            }
            statistics.put('followStatistics',followStatLisWrapper);
        }catch(Exception ex){
            system.debug('*** WINatPOS retriveStatistics there was problem to retrive follow statistics: ' +ex.getMessage());
            statistics.put('followStatistics',new List<WINatPOSRemoteActionWrapper.AssetDetailStats>());
        }
        system.debug('*** WINatPOS retriveStatistics return : ' +statistics);
        return statistics;
    }
    
    /*******************************************************************
    Purpose: Method display asset details, accepting assetId or assetGroupId
    if signle asset selected on search page pass selected assetId 
    if assetGroup selected on search page pass selected assetGroupId
    Parameters: [String assetOrAssetGroupId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    
    public static WINatPOSRemoteActionWrapper getAssetDetailData(String assetOrAssetGroupId){
        System.Debug('*** WINatPOS getAssetDetailData input parameter: ' + assetOrAssetGroupId);
        String communityName = WINatPOSUtil.getCommunityName();
        Id entityId = null;
        try{
            entityId=Id.valueOf(assetOrAssetGroupId);
        }catch(Exception ex){
            system.debug('*** WINatPOS getAssetDetailData invalid assetOrAssetGroupId passed to method: '+ex.getMessage());
            return new WINatPOSRemoteActionWrapper('getAssetDetailData method return error','0',null,ex.getMessage());
        }
        List<WINatPOSRemoteActionWrapper.AssetDetailItem> assetDetailsList=new List<WINatPOSRemoteActionWrapper.AssetDetailItem>();
        List<Asset__c> assets=new List<Asset__c>();
        Boolean isUserFollowCollection = null;
        String assetGroupId = null;
        String objectAPIName ='';
        String assetGroupName='';
        //check if asset or assetGroup id was passed into the method
        if(entityId != null){
           objectAPIName=entityId.getSObjectType().getDescribe().getName();
        }
        
        if (objectAPIName == 'Asset_Group__c') {
            /*
            assets = [Select Owner.Name, Id, Asset_Group__c, Video_URL_Link__c, Asset_Group__r.Name, Name, Category__c,Touchpoint__c,Country__c,Category__r.Name, Brand__c, Brand__r.Name, Channels__c, Description__c, Placement__c, Market_Cluster__c,POS_Asset_Type__c, BET__c, BET__r.Name,Buy_Online_in_Europe__c, 
                             (Select Id, Name, Category__c, Category__r.Name, Type__c, Sub_Type__c, File_Button_Text__c, Is_Primary_Image__c, Feed_ID__c, Feed_URL__c,Feed_Thumbnail_URL__c 
                              From Files__r 
                              Order By Sort_Order__c ASC),
                             (select ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId())                
                      From Asset__c 
                      Where  Status__c = :WINatPOSUtil.APPROVED
                      And Asset_Group__c = :assetOrAssetGroupId 
                      Order By Name ASC];*/
            //added modification for asset group detail
            assets = WINatPOSUtil.getAssetsForAssetGroupDetailPage(assetOrAssetGroupId);
            if(!assets.isEmpty()){
               assetGroupId=assets.get(0).Asset_Group__c;
               assetGroupName=assets.get(0).Asset_Group__r.Name;
            }else{ 
                assetGroupId= assetOrAssetGroupId;
                Asset_Group__c assetGroupTmp=[select Name from Asset_Group__c where id =: assetOrAssetGroupId limit 1];
                assetGroupName=assetGroupTmp.Name;
            }
            if([select id from EntitySubscription where ParentId =:assetOrAssetGroupId and SubscriberId =: UserInfo.getUserId() limit 1].size()>0){
                isUserFollowCollection=true;
            }else{
                isUserFollowCollection=false;
            }
        } else {
            assets = [Select Owner.Name, Id, Name, Touchpoint__c, Video_URL_Link__c, Country__c, Category__c, Category__r.Name, Brand__c, Brand__r.Name, Channels__c, Description__c, Placement__c, Market_Cluster__c,POS_Asset_Type__c, BET__c, BET__r.Name,Buy_Online_in_Europe__c, 
                             (Select Id, Name, Category__c, Category__r.Name, Type__c, Sub_Type__c, File_Button_Text__c, Is_Primary_Image__c, Feed_ID__c, Feed_URL__c,Feed_Thumbnail_URL__c 
                              From Files__r 
                              Order By Sort_Order__c ASC),
                              (select ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId())
                      From Asset__c 
                      Where id= :assetOrAssetGroupId
                      Order By Name ASC];
        }                           
        
        // Next iterate through the assets and set the flags used by the UI to render the asset and file "buttons"
        system.debug(assets);
        Boolean firstAsset=true;
        for (Asset__c a : assets) {
            String primaryImageURL = '', downloadURL = '', aURL = '', pURL = '', peURL = '', diURL = '';
            String primaryImageFeedId='';
            String primaryFileId='';
            List<File__c> files = new List<File__c>();            
            for (File__c f : a.Files__r) {
                system.debug('check if see related files');
                if (f.Feed_URL__c == null) {
                    WINatPOSUtil.cacheFeedURL(f);  // Try to cache the download Url to optimize performance                    
                }          
                
                // Try to set the primary image for the asset
                //if ((f.Type__c != null) && (f.Type__c.equals(Label.WP_File_Type_Image))) {
                if (f.Is_Primary_Image__c) {
                    /*
                	if( f.Feed_Thumbnail_URL__c != null && !WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
                    	primaryImageURL = f.Feed_Thumbnail_URL__c.replace('/' + communityName, '');
                    }else{
                    	primaryImageURL = f.Feed_Thumbnail_URL__c;
                	}*/
                    primaryImageURL = WINatPOSUtil.urlRewrite(f.Feed_Thumbnail_URL__c);
                    primaryImageFeedId = f.Feed_ID__c;
                    primaryFileId=f.id;
                    downloadURL=WINatPOSUtil.urlRewrite(f.Feed_URL__c);
                }
                //}
                
                // Set the icons for the file panel - can only be one
                f.Show_Artwork__c = WINatPOSUtil.HIDDEN;  
                f.Show_Presentation__c = WINatPOSUtil.HIDDEN;
                f.Show_Production_Engineering__c = WINatPOSUtil.HIDDEN;
                f.Show_Download_Image__c = WINatPOSUtil.HIDDEN;       
                if (f.Sub_Type__c != null) {
                    if (f.Sub_Type__c.contains(WINatPOSUtil.ARTWORK)) {
                        // File is sub type artwork
                        f.Show_Artwork__c = WINatPOSUtil.VISIBLE; 
                        // Asset should enable artwork download from results page
                        aURL = WINatPOSUtil.urlRewrite(f.Feed_URL__c);
                    } else if (f.Sub_Type__c.contains(WINatPOSUtil.PRESENTATION)) {
                        // File is sub type presentation
                        f.Show_Presentation__c = WINatPOSUtil.VISIBLE;
                        // Asset should enable presentation download from results page
                        pURL = WINatPOSUtil.urlRewrite(f.Feed_URL__c);
                    } else if (f.Sub_Type__c.contains(WINatPOSUtil.PROD_ENGINEERING)) {
                        // File is sub type production engineering
                        f.Show_Production_Engineering__c = WINatPOSUtil.VISIBLE;
                        // Asset should enable production engineering download from results page
                        peURL = WINatPOSUtil.urlRewrite(f.Feed_URL__c);
                    } else if (f.Sub_Type__c.contains(WINatPOSUtil.DOWNLOAD_IMG)) {
                        // File is sub type download image
                        f.Show_Download_Image__c = WINatPOSUtil.VISIBLE;
                        // Asset should enable display image download from results page
                        diURL = WINatPOSUtil.urlRewrite(f.Feed_URL__c);
                    }                   
                }                
            }
            files.addAll(a.Files__r);
            files.add(new File__c(Name=Label.WP_Download_Item_Text,Feed_URL__c=Page.WinAtPOSPrintablePDFView.getUrl()+'?id='+a.Id,Type__c=Label.WP_File_Type_Generated,Show_Artwork__c=WINatPOSUtil.HIDDEN,Show_Presentation__c=WINatPOSUtil.HIDDEN,Show_Production_Engineering__c=WINatPOSUtil.HIDDEN,Show_Download_Image__c=WINatPOSUtil.VISIBLE));
            // The asset will only appear in the list if we have a primary image URL
            //if (primaryImageURL != '') {
                
                WINatPOSRemoteActionWrapper.AssetDetailItem tmpAssetItem=new WINatPOSRemoteActionWrapper.AssetDetailItem();
                tmpAssetItem.assetOwner=a.Owner.Name;
                tmpAssetItem.assetId=a.id;
                tmpAssetItem.assetName=a.name;
                tmpAssetItem.assetBrand=a.brand__r.Name;
                tmpAssetItem.assetCategory=a.category__r.Name;
                tmpAssetItem.assetChannels=a.Channels__c;
                tmpAssetItem.assetCountry=a.Country__c;
                tmpAssetItem.assetTouchpoint=a.Touchpoint__c;
                tmpAssetItem.assetDescription=WINatPOSUtil.convertHtmlToPlainText(a.Description__c);
                tmpAssetItem.assetType=a.POS_Asset_Type__c;
                tmpAssetItem.assetCluster=a.Market_Cluster__c;
                tmpAssetItem.assetPlacement=a.Placement__c;
                tmpAssetItem.primaryImageUrl = primaryImageURL;
                tmpAssetItem.artworkURL = aURL;
                tmpAssetItem.presentationURL = pURL;
                tmpAssetItem.productionEngineeringURL = peURL;
                tmpAssetItem.downloadImageURL = downloadURL;
                tmpAssetItem.assetFiles=files;
                //tmpAssetItem.brandExpirenceUrl = a.BET__c != null ? URL.getSalesforceBaseUrl().toExternalForm() + '/' + a.Id : null;
                
                // Added By ISzegedi
                tmpAssetItem.brandExpirenceUrl = a.BET__c != null ? URL.getSalesforceBaseUrl().toExternalForm() + '/' + a.BET__c : null;
                tmpAssetItem.buyOnlineInEuropeUrl = a.Buy_Online_in_Europe__c;
                system.debug('Check if asset is followed by user: '+a.FeedSubscriptionsForEntity);
                tmpAssetItem.userFollowAsset = a.FeedSubscriptionsForEntity.size()>0 ? true : false;
                tmpAssetItem.feedId=primaryImageFeedId;
                tmpAssetItem.assetPrimaryFileId=primaryFileId;
            	String commName = WINatPOSUtil.getCommunityName();
                String communityUrl = Network.getNetworkId() != null ? '/'+commName : '';
                tmpAssetItem.assetDownloadPdfUrl=URL.getSalesforceBaseUrl().toExternalForm() +communityUrl+ '/apex/WinAtPOSPrintablePDFView?id=' + a.Id;
                tmpAssetItem.videoUrl = a.Video_URL_Link__c;
                if(firstAsset){
                    
                    Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> statistics = retriveStatistics(primaryFileId, a.id);
                    //set download statistics
                    if(statistics.containsKey('downloadStatistics')){
                        tmpAssetItem.downloadStatistics=statistics.get('downloadStatistics');
                    }
                    //set share statistics
                    if(statistics.containsKey('shareStatistics')){
                        tmpAssetItem.shareStatistics=statistics.get('shareStatistics');
                    }
                    //setollow statistics followStatistics
                    if(statistics.containsKey('followStatistics')){
                        tmpAssetItem.followStatistics=statistics.get('followStatistics');
                    }
                    firstAsset=false;
                }
                assetDetailsList.add(tmpAssetItem);
            //}
        }
        Boolean showAssetView=objectAPIName=='Asset__c';
        Boolean showAssetGroupView=objectAPIName=='Asset_Group__c';
        String assetGroupdownloadPdfUrl=null;
        if(assetGroupId != null && assetGroupId != ''){
            assetGroupdownloadPdfUrl=URL.getSalesforceBaseUrl().toExternalForm() + '/apex/WinAtPOSPrintablePDFView?id=' + assetGroupId;
        }
        WINatPOSRemoteActionWrapper.AssetsDetaislWrapper assetDetailWrapp=new WINatPOSRemoteActionWrapper.AssetsDetaislWrapper(showAssetGroupView,showAssetView,assetDetailsList,isUserFollowCollection,assetGroupId,assetGroupdownloadPdfUrl,assetGroupName);
        system.debug('*** WINatPOS getAssetDetailData method returned: '+new WINatPOSRemoteActionWrapper('search method return results','0',new List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper>{assetDetailWrapp},''));
        return new WINatPOSRemoteActionWrapper('getAssetDetailData method return results','0',new List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper>{assetDetailWrapp},'');
    }
    
    /*******************************************************************
    Purpose: Method searching appropriate Files for Brand Id. 
    Parameters: [Strin brandId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper getFilesForBrandId(String brandId){
        System.Debug('*** WINatPOS getFilesForBrandId input parameter: ' + brandId);
        try{
            Id isIdInValidFormat=Id.valueOf(brandId);
        }catch(Exception ex){
            System.Debug('*** WINatPOS getFilesForBrandId returned following error: ' + ex.getMessage());
            return new WINatPOSRemoteActionWrapper('getFilesForBrandId method return error','1',null,ex.getMessage());
        }
        List<File__c> filesWithoutThumbnailUrl=new List<File__c>();
        List<File__c> fileList=new List<File__c>();
        for(File__c fileItem: [select  Brand__c,
                                       Feed_Thumbnail_URL__c, 
                                       Feed_URL__c,
                                       Feed_ID__c,
                                       Name,
                                       Number_Of_Downloads__c,
                                       POS_File_Type__c,
                                       Show_Artwork__c,
                                       Show_Download_Image__c,
                                       Show_Presentation__c,
                                       Show_Production_Engineering__c,
                                       Sub_Type__c, 
                                       Type__c,
                                       Is_Primary_Image__c 
                                       from File__c 
                                       where Brand__c =:brandId]){
            
            if(fileItem.Feed_Thumbnail_URL__c == null){
                WINatPOSUtil.cacheFeedURL(fileItem);
                filesWithoutThumbnailUrl.add(fileItem);
            }
            fileList.add(fileItem);                                                
                                    
        }
        if(!filesWithoutThumbnailUrl.isEmpty()){
            Database.SaveResult [] sr=Database.update(filesWithoutThumbnailUrl,false) ;
        }
        System.Debug('*** WINatPOS getFilesForBrandId returned: ' + new WINatPOSRemoteActionWrapper('getFilesForBrandId method','0',fileList,''));
        return new WINatPOSRemoteActionWrapper('getFilesForBrandId method','0',fileList,'');
    }
    
    /*******************************************************************
    Purpose: Method searching appropriate Files for Category Id. 
    Parameters: [Strin brandId]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper getFilesForCategoryId(String categoryId){
        System.Debug('*** WINatPOS getFilesForCategoryId input parameter categoryId: ' + categoryId);
        try{
            Id isIdInValidFormat=Id.valueOf(categoryId);
        }catch(Exception ex){
            //passed id is in appropriate format
            System.Debug('*** WINatPOS getFilesForCategoryId returned following error: ' + ex.getMessage());
            return new WINatPOSRemoteActionWrapper('getFilesForCategoryId method return error','1',null,ex.getMessage());
        }
        List<File__c> filesWithoutThumbnailUrl=new List<File__c>();
        List<File__c> fileList=new List<File__c>();
        for(File__c fileItem: [select  Category__c,
                                       Feed_Thumbnail_URL__c, 
                                       Feed_URL__c,
                                       Feed_ID__c,
                                       Name,
                                       Number_Of_Downloads__c,
                                       POS_File_Type__c,
                                       Show_Artwork__c,
                                       Show_Download_Image__c,
                                       Show_Presentation__c,
                                       Show_Production_Engineering__c,
                                       Sub_Type__c, 
                                       Type__c,
                                       Is_Primary_Image__c
                                       from File__c 
                                       where Category__c =:categoryId]){
            
            if(fileItem.Feed_Thumbnail_URL__c == null){
                WINatPOSUtil.cacheFeedURL(fileItem);
                filesWithoutThumbnailUrl.add(fileItem);
            }
                                           
            fileList.add(fileItem);                                                
                                    
        }
        if(!filesWithoutThumbnailUrl.isEmpty()){
            Database.SaveResult [] sr=Database.update(filesWithoutThumbnailUrl,false) ;
        }
        System.Debug('*** WINatPOS getFilesForCategoryId returned: ' +  new WINatPOSRemoteActionWrapper('getFilesForCategoryId method','0',fileList,''));
        return new WINatPOSRemoteActionWrapper('getFilesForCategoryId method','0',fileList,'');
    }
    
    /*******************************************************************
    Purpose: Method  return list of files for asset 
    Parameters: [Id]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    
    public static WINatPOSRemoteActionWrapper getFileListForAsset(String assetId){
        //method accepting only properly formatted asset id
        System.Debug('*** WINatPOS getFileListForAsset input paramter assetId: ' + assetId);
        try{
            Id.valueOf(assetId);
        }catch(Exception ex){
            System.Debug('*** WINatPOS getFileListForAsset returned following error: ' + ex.getMessage());
            return new WINatPOSRemoteActionWrapper('getFileListForAsset','1',null,ex.getMessage());
        }
        List<File__c> filesWithoutThumbnailUrl=new List<File__c>();
        List<File__c> fileList = new List<File__c>();
        for(File__c fileItem :[select  Asset__c, 
                                       Feed_Thumbnail_URL__c, 
                                       Feed_URL__c,
                                       Feed_ID__c,
                                       Name,
                                       Number_Of_Downloads__c,
                                       POS_File_Type__c,
                                       Show_Artwork__c,
                                       Show_Download_Image__c,
                                       Show_Presentation__c,
                                       Show_Production_Engineering__c,
                                       Sub_Type__c, 
                                       Type__c,
                                       Is_Primary_Image__c 
                                       from File__c 
                                       where Asset__c=:assetId]){
                                   
            if(fileItem.Feed_Thumbnail_URL__c == null){
                WINatPOSUtil.cacheFeedURL(fileItem);
                filesWithoutThumbnailUrl.add(fileItem);
            }
            fileList.add(fileItem);                           
                                   
        }
        
        if(!filesWithoutThumbnailUrl.isEmpty()){
            Database.SaveResult [] sr=Database.update(filesWithoutThumbnailUrl,false);
        }
        System.Debug('*** WINatPOS getFileListForAsset returned: ' + new WINatPOSRemoteActionWrapper('getFileListForAsset','0',fileList,''));
        return new WINatPOSRemoteActionWrapper('getFileListForAsset','0',fileList,'');
    }
    
    
    
    // Added By ISzegedi
    public static String processSearchTerms(String str) {
         String[] searchterms = str.split('[ \t]+');
         String searchtermsWithOR = '';
         Integer i = 0;
         Integer len = searchterms.size();
         for ( String s : searchterms) {
             if ( i < len -1 ) {
                searchtermsWithOR = searchtermsWithOR + s + ' OR ';
             }
             else {
                 searchtermsWithOR = searchtermsWithOR + s;
             }
             i++;
         }

         System.Debug('Search: ' + searchtermsWithOR); 
         return searchtermsWithOR;
    }
    
    public static String buildKeyword(String str){
        String[] searchterms = str.split('[ \t]+');
        String outPutKeyWord='';
        for(String s:searchterms){
            if(s.toLowerCase() == 'or'){
                outPutKeyWord += ' '+s;
            }else if(s == '*'){
                outPutKeyWord += ' '+s;
            }else{
                outPutKeyWord += ' "'+s+'"';
            }
        }
        system.debug(outPutKeyWord.trim());
        return outPutKeyWord.trim();
    }
    /*******************************************************************
    Purpose: Method is resposible for retun proper url for pdf page which will contain all asset results
    Parameterd Description:
    Parameters: [String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country,Boolean withAssetInfo]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper getSearchResultListPdf(String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country,Integer pageSize,Integer pageNumber,Boolean withAssetInfo){
        System.Debug('*** WINatPOS getSearchResultListPdf input parametes searchType: '+searchType+
                     ',brandId' +brandId+',categoryId: '+categoryId+',keyWord:'+keyWord+
                     ',assetType:'+assetType+',assetChannel:'+assetChannel+',assetCluster'+assetCluster+',assetPlacment:'+assetPlacment+',pageSize:'+pageSize+',pageNumber'+pageNumber);
        
        List<Asset__c> assetSearchList=new List<Asset__c>();
        List<Asset_Group__c> assetGroupSearchList=new List<Asset_Group__c>();
        WINatPOSRemoteActionWrapper gatheredResults = gatherResultsForSearch(searchType, brandId,categoryId,keyWord, assetType,assetChannel, assetCluster, assetPlacment,country);
        if(gatheredResults.status == '1'){
            return gatheredResults;
            
        }else if(gatheredResults.status == '0'){
            WINatPOSRemoteActionWrapper.SearchWrapper wrapperResponse= (WINatPOSRemoteActionWrapper.SearchWrapper)gatheredResults.data.get(0);
            assetSearchList = wrapperResponse.assetHelperResult;
            assetGroupSearchList = wrapperResponse.assetGroupHelperResult;
        }
        
        if(assetSearchList.isEmpty() && assetGroupSearchList.isEmpty()){
            system.debug('*** WINatPOS search method returned no results');
            //if no results don't return url pdf file and no error message.
            return new WINatPOSRemoteActionWrapper('getSearchResultListPdf method return no results','0',null,'');
        }else{
            //creating a map of assetSearchList
            Map<Id,Asset__c> mapAssetSearchList=new Map<Id,Asset__c>();
            Map<Id,Asset_Group__c> mapAssetGroupSearchList=new Map<Id,Asset_Group__c>();
            //create map of AssetGroup
            for(Asset__c assetItem : assetSearchList){
                if(assetItem.Asset_Group__c != null){
                    mapAssetGroupSearchList.put(assetItem.Asset_Group__c,null);
                }else{
                    //push only assets which not belongs to asset group
                    mapAssetSearchList.put(assetItem.id,assetItem);
                }    
            }
            
            //create map of AssetGroup
            for(Asset_Group__c assetGroupItem : assetGroupSearchList){
                mapAssetGroupSearchList.put(assetGroupItem.id,null);
            }
            system.debug('*** WINatPOS search check AssetGroupMap '+mapAssetGroupSearchList);
            //fetching files related with assets
            List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResultWrapper=new List<WINatPOSRemoteActionWrapper.AssetResultWrapper>();
            Map<Id,String> fileMapsForAsset=new Map<Id,String>(); //Map for Asset and related file images ulr
            Map<Id,String> fileFeedMapsForAsset=new Map<Id,String>(); //Map for Asset and related file feed id
            Map<Id,Decimal> fileSizeMapsForAsset=new Map<Id,Decimal>(); //Map for Asset and related file file Size
            Map<Id,String> fileIdMapsForAsset=new Map<Id,Id>(); //Map for Asset and related file Id 
            //Map<Id,List<Asset__c>> relatedAssetToAssetGroup= new Map<Id,List<Asset__c>>();
            //Map<Id,List<String>> fileMapsForAssetGroup=new Map<Id,List<String>>(); //Mape For AssetGroup and related file images
            
            //need to add field Is_Primary_Image__c to where clasue as for now condition not added to return more data for testing
            
            if(mapAssetSearchList.keySet().size()>0){
                mapAssetSearchList=new Map<Id,Asset__c>([select Name,Id,Description__c,Channels__c,Brand__r.Name,POS_Asset_Type__c from Asset__c where id in :mapAssetSearchList.keySet()]);
                for(File__c f: [select id,Is_Primary_Image__c,Asset__c,Asset_Group__c,Chatter_File_Id__c,Feed_ID__c,Feed_Thumbnail_URL__c,Feed_URL__c,File_Size_Bytes__c from File__c where Asset__c in: mapAssetSearchList.keySet() and Is_Primary_Image__c = true]){
                 
                    fileMapsForAsset.put(f.Asset__c,f.Feed_Thumbnail_URL__c); 
                    fileFeedMapsForAsset.put(f.Asset__c,f.Feed_ID__c);
                    fileSizeMapsForAsset.put(f.Asset__c,f.File_Size_Bytes__c);
                    fileIdMapsForAsset.put(f.Asset__c,f.id);
                }    
            }
            Map<id,List<Asset__c>> assetsRelatedWithAssetGroup = new Map<id,List<Asset__c>>();
            if(mapAssetGroupSearchList.keySet().size()>0){
                //assetGroupSearchList rebuilded added assetGroups wher asset belongs to asset group
                mapAssetGroupSearchList=new Map<Id,Asset_Group__c>([select Name, Id, Type__c, New_Indicator__c from Asset_Group__c where id in :mapAssetGroupSearchList.keySet()]);
                
                for(Asset__c a: [select Asset_Group__c,Name, Description__c,Channels__c,Brand__r.Name,id,POS_Asset_Type__c,(select Feed_ID__c, Feed_Thumbnail_URL__c, Feed_URL__c, Is_Primary_Image__c,File_Size_Bytes__c,id from Files__r where Is_Primary_Image__c = true) from Asset__c where Asset_Group__c in : mapAssetGroupSearchList.keySet() and Status__c =: WINatPOSUtil.assetTypeApproved order by name]){
                    for(File__c f: a.Files__r){
						
                        if(!fileMapsForAsset.containsKey(a.id)){
                            //totalImageSize +=WINatPOSUtil.getFileSize(f);
                            fileMapsForAsset.put(a.id,f.Feed_Thumbnail_URL__c); 
                            fileFeedMapsForAsset.put(a.id,f.Feed_ID__c);
                            fileSizeMapsForAsset.put(a.id,f.File_Size_Bytes__c);
                            fileIdMapsForAsset.put(a.id,f.id);
                        }
                           
                    }
                    if(assetsRelatedWithAssetGroup.containsKey(a.Asset_Group__c)){
                        List<Asset__c> lstOfRelatedAsset=assetsRelatedWithAssetGroup.get(a.Asset_Group__c);
                        lstOfRelatedAsset.add(a);
                    }else{
                        assetsRelatedWithAssetGroup.put(a.Asset_Group__c,new List<Asset__c>{a});
                    }
                        
                }
                
            }   
            //build final list of Results for asset which don't belongs to assetGroup
            for(Asset__c assetItem : mapAssetSearchList.values()){
               assetResultWrapper.add(new WINatPOSRemoteActionWrapper.AssetResultWrapper(assetItem,null,null,assetItem.Name));
            }
           
            for(Asset_Group__c assetGroupItem : mapAssetGroupSearchList.values()){
                //check if Asset group have a related file
                assetResultWrapper.add(new WINatPOSRemoteActionWrapper.AssetResultWrapper(null,null,assetGroupItem,assetGroupItem.Name)); 
            }
            
            assetResultWrapper.sort();
            List<WINatPOSRemoteActionWrapper.AssetDetailForPDF> finalResultsForPDF= new List<WINatPOSRemoteActionWrapper.AssetDetailForPDF>();
            Decimal totalImageSize=0;
            Decimal collectionSize=0;
            WinAtPOSRemoteActions__c  remotActionConf=WinAtPOSRemoteActions__c.getValues('WinAtPOSRemoteActionConf');
        	String defaultImageUrl=remotActionConf != null ? remotActionConf.Default_Image_Url__c :'';
            Decimal maxFileSize=remotActionConf != null ? remotActionConf.Max_file_size__c : 60;
            Decimal maxCollectionSize=remotActionConf != null ? remotActionConf.PDF_Asset_Collection_Limit__c  : 1000; // custom setting resposible for max collection size
            Decimal defaultImageSize=remotActionConf != null ? remotActionConf.Default_Image_Size__c : 0;
            for(WINatPOSRemoteActionWrapper.AssetResultWrapper assetDet : WinAtPOSUtil.getResultsForPDFPage(assetResultWrapper,pageSize,pageNumber)){
                if(assetDet.assetItem != null){
                    WINatPOSRemoteActionWrapper.AssetDetailForPDF assetPdfItem = new WINatPOSRemoteActionWrapper.AssetDetailForPDF();
                    assetPdfItem.assetName=assetDet.assetItem.Name;
                    assetPdfItem.assetDescription=WinAtPOSUtil.convertHtmlToPlainText(assetDet.assetItem.Description__c);
                    assetPdfItem.assetBrand=assetDet.assetItem.Brand__r != null ? assetDet.assetItem.Brand__r.Name : '';
                    assetPdfItem.assetChannel=assetDet.assetItem.Channels__c;
                    if(fileMapsForAsset.containsKey(assetDet.assetItem.id)){
                       assetPdfItem.assetPrimaryImage=fileMapsForAsset.get(assetDet.assetItem.id);
                       assetPdfItem.assetPrimaryFileId=fileIdMapsForAsset.get(assetDet.assetItem.id);
                       assetPdfItem.assetPrimaryFileFeedId=fileFeedMapsForAsset.get(assetDet.assetItem.id);  
                       if(fileSizeMapsForAsset.get(assetDet.assetItem.id) != null){
                           totalImageSize +=fileSizeMapsForAsset.get(assetDet.assetItem.id);  
                       }else{
                           //if file size is not set add default image size
                           totalImageSize += defaultImageSize; 
                       } 
                       
                    }else{
                        totalImageSize += defaultImageSize;
                        assetPdfItem.assetPrimaryImage=defaultImageUrl;
                    }
                    if(totalImageSize/1000000 > maxFileSize){
                        //Total Image size was exceded can't add another assets in to pdf
                        break;
                    }
                    collectionSize++;
                    if(collectionSize> maxCollectionSize){
                        //Search pdf page allow to display maximum 1000 records according to salesforce limit
                        //apex:repeat have such limitation page can't be in read only mode when download statistics
                        //functionality was introduced
                        break;
                    }
                    finalResultsForPDF.add(assetPdfItem);                    
                }else if(assetDet.assetGroupItem != null){
                    if(assetsRelatedWithAssetGroup.get(assetDet.assetGroupItem.id) != null){
                        for(Asset__c a:assetsRelatedWithAssetGroup.get(assetDet.assetGroupItem.id)){
                            WINatPOSRemoteActionWrapper.AssetDetailForPDF assetPdfItem = new WINatPOSRemoteActionWrapper.AssetDetailForPDF();
                            assetPdfItem.assetName=a.Name;
                            assetPdfItem.assetDescription=WinAtPOSUtil.convertHtmlToPlainText(a.Description__c);
                            assetPdfItem.assetBrand=a.Brand__r != null ? a.Brand__r.Name : '';
                            assetPdfItem.assetChannel=a.Channels__c;
                            if(fileMapsForAsset.containsKey(a.id)){
                               assetPdfItem.assetPrimaryImage=fileMapsForAsset.get(a.id);
                               assetPdfItem.assetPrimaryFileId=fileIdMapsForAsset.get(a.id);
                       		   assetPdfItem.assetPrimaryFileFeedId=fileFeedMapsForAsset.get(a.id); 
                                if(fileSizeMapsForAsset.get(a.id) != null){
                                   totalImageSize +=fileSizeMapsForAsset.get(a.id);  
                                }else{
                                   //add default image size if field is not set 
                                   totalImageSize += defaultImageSize;  
                                }  
                            }else{
                                totalImageSize += defaultImageSize;
                                assetPdfItem.assetPrimaryImage=defaultImageUrl;
                            }
                            if(totalImageSize/1000000 >maxFileSize){
                                //Total Image size was exceded can't add another assets in to pdf
                                break;
                            }
                            collectionSize++;
                            if(collectionSize> maxCollectionSize){
                                //Search pdf page allow to display maximum 1000 records according to salesforce limit
                                //apex:repeat have such limitation page can't be in read only mode when download statistics
                                //functionality was introduced
                                break;
                            }
                            finalResultsForPDF.add(assetPdfItem);
                        }
                	}
                }
            }
            WINatPOSRemoteActionWrapper response = new WINatPOSRemoteActionWrapper('','0',null,'');
            if(withAssetInfo){
                response.data=finalResultsForPDF;
            }
            
            response.urlToPdfFile=URL.getSalesforceBaseUrl().toExternalForm() + '/apex/WinAtPOSSearchPDFView?searchType=' + searchType+'&brandId='+brandId+'&categoryId='+categoryId+'&keyWord='+keyWord+'&assetType='+assetType+'&assetChannel='+assetChannel+
                '&assetCluster='+assetCluster+'&assetPlacment='+assetPlacment+'&country='+country+'&pageSize='+pageSize+'&pageNumber='+pageNumber;
            response.urlToPdfFile=response.urlToPdfFile.replace('null','');
            response.totalAttachedFileSize=String.valueOf(totalImageSize);
            response.status='0';
            response.message='getSearchResultListPdf method retuned following results';
            
            
            if((totalImageSize/1000000 >maxFileSize) || (collectionSize> maxCollectionSize)){
                response.status='-1';
                response.error='Attached file size exceed the limit narrow down the search results';
            }
            system.debug('*** WINatPOS getSearchResultListPdf method retuned following results: '+JSON.serialize(response));
            return response;
                        
        }
    }
    /*******************************************************************
    Purpose: Method is helper method for search engine. Method gather all assets for search
    wich meeting search criteria from asset and asset group objects.
    Parameterd Description:
    
    Parameters: [String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper gatherResultsForSearch(String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country){
        System.Debug('*** WINatPOS gatherResultsForSearch input parametes searchType: '+searchType+
                     ',brandId' +brandId+',categoryId: '+categoryId+',keyWord:'+keyWord+
                     ',assetType:'+assetType+',assetChannel:'+assetChannel+',assetCluster'+assetCluster+',assetPlacment:'+assetPlacment);
        String whereClauseForAsset = '';
        String whereClauseForTouchpoint = '';
        String whereClauseForAssetGroup = '';
        
        WINatPOSRemoteActionWrapper whereCaluseResponse=buildWhereClausesForSearch(searchType, brandId,categoryId,keyWord, assetType,assetChannel, assetCluster, assetPlacment,country);
        if(whereCaluseResponse.status == '1'){
            return whereCaluseResponse;
            
        }else if(whereCaluseResponse.status == '0'){
            WINatPOSRemoteActionWrapper.WhereClauseWrapper wrapperResponse= (WINatPOSRemoteActionWrapper.WhereClauseWrapper)whereCaluseResponse.data.get(0);
            whereClauseForAssetGroup = wrapperResponse.whereClauseForAssetGroup;
            whereClauseForAsset = wrapperResponse.whereClauseForAsset;
            whereClauseForTouchpoint = wrapperResponse.whereClauseForTouchpoint; 
        }
        
        //Start building final query
        Boolean isSoslQuery=false;
        String finalSoslQuery='';
        String finalSoqlQuery='select id,Name,Asset_Group__c,Brand__c,Category__c,Channels__c,Country__c,Description__c,Market_Cluster__c,Modern_Channels__c,Placement__c,POS_Asset_Type__c,Touchpoint__c, Video_URL_Link__c from Asset__c '+whereClauseForAsset;
        String finalSoqlQueryWithTouchPoint='select id,Name,Asset_Group__c,Brand__c,Category__c,Channels__c,Country__c,Description__c,Market_Cluster__c,Modern_Channels__c,Placement__c,POS_Asset_Type__c,Touchpoint__c, Video_URL_Link__c from Asset__c '+whereClauseForTouchpoint;
        String finalSoqlQueryAssetGroup='select id,Name,Brand__c,Category__c, New_Indicator__c, Market_Cluster__c,Type__c from Asset_Group__c '+whereClauseForAssetGroup;
        if(keyWord != null && keyWord !='' && keyWord.trim() !=''){ 
            // Added by ISzegedi
            //keyWord = processSearchTerms(keyword);
            
            finalSoslQuery +='FIND \''+keyWord+'\' ';
            isSoslQuery=true;
        }
        List<Asset__c> assetSearchList=new List<Asset__c>();
        List<Asset__c> assetSeatchByTouchpoint=new List<Asset__c>();
        List<Asset_Group__c> assetGroupSearchList=new List<Asset_Group__c>();
        if(isSoslQuery){
            if((assetChannel != null  && assetChannel != '') || (assetPlacment != null  && assetPlacment != '') || (country != null  && country != '')){
                system.debug('*** WINatPOS gatherResultsForSearch method final sosl query call without quering Asset_Group__c');
                finalSoslQuery +='IN ALL FIELDS RETURNING Asset__c (id,Name,Asset_Group__c,Brand__c,Category__c,Channels__c,Country__c,Description__c,Market_Cluster__c,Modern_Channels__c,Placement__c,POS_Asset_Type__c,Touchpoint__c, Video_URL_Link__c '+whereClauseForAsset+' order by Name)';
            }else{
                system.debug('*** WINatPOS gatherResultsForSearch method final sosl query call with quering Asset_Group__c');
                finalSoslQuery +='IN ALL FIELDS RETURNING Asset__c (id,Name,Asset_Group__c,Brand__c,Category__c,Channels__c,Country__c,Description__c,Market_Cluster__c,Modern_Channels__c,Placement__c,POS_Asset_Type__c,Touchpoint__c, Video_URL_Link__c '+whereClauseForAsset+' order by Name), '
                                                    + 'Asset_Group__c (id,Name,Brand__c,Category__c,Market_Cluster__c,Type__c, New_Indicator__c '+ whereClauseForAssetGroup+' order by Name)';
            }
             
            
            
            system.debug('*** WINatPOS gatherResultsForSearch method final soql query call: '+finalSoslQuery);
            //end of creating dynamic query call
            
            List<List<SObject>>searchList;
            
            if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
            	searchList = WINatPOSUtil.searchForCommunityUsers(finalSoslQuery);
            }else{
            	searchList = search.query(finalSoslQuery);
            }
            
            if(!searchList.isEmpty()){
                system.debug('*** WINatPOS gatherResultsForSearch method check searchList '+searchList);
                system.debug('*** WINatPOS gatherResultsForSearch method check searchList for asset '+searchList.get(0));
                assetSearchList = (List<Asset__c>)searchList.get(0);
                system.debug('*** WINatPOS gatherResultsForSearch method check number of records returned for assets '+searchList.get(0).size());
                if(searchList.size()>1){
                    assetGroupSearchList = (List<Asset_Group__c>)searchList.get(1);
                    system.debug('*** WINatPOS gatherResultsForSearch method check searchList for asset group '+searchList.get(1));
                }
            }
            if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
            	assetSeatchByTouchpoint = (List<Asset__c>)WINatPOSUtil.retrieveForCommunityUsers(finalSoqlQueryWithTouchPoint);
            }else{
            	assetSeatchByTouchpoint = Database.query(finalSoqlQueryWithTouchPoint);
            }
            //combine keyword search from sosl and soql for TouchPoint
            assetSearchList=WinAtPosUtil.combineAssetsLists(assetSearchList,assetSeatchByTouchpoint);
            
            
        }else{
        	if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
        		assetSearchList = (List<Asset__c>)WINatPOSUtil.retrieveForCommunityUsers(finalSoqlQuery);
        	}else{
            	assetSearchList = Database.query(finalSoqlQuery);
        	}
            system.debug('*** WINatPOS gatherResultsForSearch method final soql query call for Assets: '+finalSoqlQuery);
            if((assetChannel != null  && assetChannel != '') || (assetPlacment != null  && assetPlacment != '' || (country != null  && country != ''))){
                system.debug('*** WINatPOS search method channel or placment or country filter is selected do not search in asset group');
            }else{
            	if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
        			assetGroupSearchList = (List<Asset_Group__c>)WINatPOSUtil.retrieveForCommunityUsers(finalSoqlQueryAssetGroup);
	        	}else{
	            	assetGroupSearchList = Database.query(finalSoqlQueryAssetGroup);
	        	}

                system.debug('*** WINatPOS gatherResultsForSearch method final soql query call for AssetGroups: '+finalSoqlQueryAssetGroup);
            }
        }
        
        WINatPOSRemoteActionWrapper.SearchWrapper searchWrapper=new WINatPOSRemoteActionWrapper.SearchWrapper(null,null);
        searchWrapper.assetHelperResult=assetSearchList;
        searchWrapper.assetGroupHelperResult=assetGroupSearchList;
        system.debug('*** WINatPOS gatherResultsForSearch method retuned following results: '+JSON.serialize(SearchWrapper));
        return new WINatPOSRemoteActionWrapper('gatherResultsForSearch method return results','0',new List<WINatPOSRemoteActionWrapper.SearchWrapper>{searchWrapper},'');
        
    }
    
    /*******************************************************************
    Purpose: Method is unified method for searching appropriate assets in system.
    Parameterd Description:
    isBrandMaster- flag need to be set on true if user select brand from menu
    isCategoryMaster - flag need to be set on true if user select category from menu
    Parameters: [Boolean isBrandMaster,Boolean isCategoryMaster,String brandId,String categoryId,String assetType,String assetChannel,String assetCluster,String assetPlacment]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper search(String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country,Integer pageSize,Integer pageNumber,Boolean withFilters){
        System.Debug('*** WINatPOS search input parametes searchType: '+searchType+
                     ',brandId' +brandId+',categoryId: '+categoryId+',keyWord:'+keyWord+
                     ',assetType:'+assetType+',assetChannel:'+assetChannel+',assetCluster'+assetCluster+',assetPlacment:'+assetPlacment);
        //put debug info here
        String communityName = WINatPOSUtil.getCommunityName();
        List<Asset__c> assetSearchList=new List<Asset__c>();
        List<Asset_Group__c> assetGroupSearchList=new List<Asset_Group__c>();
        WINatPOSRemoteActionWrapper gatheredResults = gatherResultsForSearch(searchType, brandId,categoryId,keyWord, assetType,assetChannel, assetCluster, assetPlacment,country);
        if(gatheredResults.status == '1'){
            return gatheredResults;
            
        }else if(gatheredResults.status == '0'){
            WINatPOSRemoteActionWrapper.SearchWrapper wrapperResponse= (WINatPOSRemoteActionWrapper.SearchWrapper)gatheredResults.data.get(0);
            assetSearchList = wrapperResponse.assetHelperResult;
            assetGroupSearchList = wrapperResponse.assetGroupHelperResult;
        }
        
        //get brand name and category name from search parameters if are passed
        //need to get names fot serach statisctic perpous
        String brandName='';
        if(brandId != null && brandId != ''){
            List<Brand_Master__c> brandList =[select name from Brand_Master__c where id =: brandId];
            if(!brandList.isEmpty()){
                brandName=brandList.get(0).Name;
            }
        }
        String categoryName='';
        if(categoryId != null && categoryId != ''){
            List<Category__c> categoryList = [Select id, Name from Category__c where id =: categoryId];
            if(!categoryList.isEmpty()){
                categoryName=categoryList.get(0).Name;
            }
        }
        if(pageNumber != null && pageNumber == 1){
             //add to search statistics only if quering first time 
             WinAtPOSUtil.insertRecordToSearchStatistic(brandName,categoryName,assetChannel,assetCluster,keyWord,assetPlacment,assetType,country);
        }
        List<WINatPOSRemoteActionWrapper.FilterLineItemWrapper> filterList =new List<WINatPOSRemoteActionWrapper.FilterLineItemWrapper>();
        system.debug('*** WINatPOS search check of filter is turned on:' +withFilters);
        if(withFilters){
            system.debug('*** WINatPOS search start retrive filters');
            filterList=WINatPOSUtil.getFiltersForAsset(searchType,brandId,categoryId,assetType,assetChannel,assetCluster,assetPlacment,country,categoryName);
        }
        
        if(assetSearchList.isEmpty() && assetGroupSearchList.isEmpty()){
            system.debug('*** WINatPOS search method returned no results');
            WINatPOSRemoteActionWrapper.SearchWrapper searchWrapper=new WINatPOSRemoteActionWrapper.SearchWrapper(filterList,null);
            return new WINatPOSRemoteActionWrapper('search method return no results','0',new List<WINatPOSRemoteActionWrapper.SearchWrapper>{searchWrapper},'');
        }else{
            //creating a map of assetSearchList
            Map<Id,Asset__c> mapAssetSearchList=new Map<Id,Asset__c>();
            Map<Id,Asset_Group__c> mapAssetGroupSearchList=new Map<Id,Asset_Group__c>();
            //create map of AssetGroup
            for(Asset__c assetItem : assetSearchList){
                if(assetItem.Asset_Group__c != null){
                    mapAssetGroupSearchList.put(assetItem.Asset_Group__c,null);
                }else{
                    //push only assets which not belongs to asset group
                    mapAssetSearchList.put(assetItem.id,assetItem);
                }    
            }
            
            //create map of AssetGroup
            for(Asset_Group__c assetGroupItem : assetGroupSearchList){
                mapAssetGroupSearchList.put(assetGroupItem.id,null);
            }
            system.debug('*** WINatPOS search check AssetGroupMap '+mapAssetGroupSearchList);
            //fetching files related with assets
            List<File__c> filesWithoutThumbnailUrl=new List<File__c>();
            List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResultWrapper=new List<WINatPOSRemoteActionWrapper.AssetResultWrapper>();
            Map<Id,List<String>> fileMapsForAsset=new Map<Id,List<String>>(); //Map for Asset and related file images
            Map<Id,List<String>> fileMapsForAssetGroup=new Map<Id,List<String>>(); //Mape For AssetGroup and related file images
            //need to add field Is_Primary_Image__c to where clasue as for now condition not added to return more data for testing
            if(mapAssetSearchList.keySet().size()>0){
                for(File__c f: [select Is_Primary_Image__c,Asset__c,Asset_Group__c,Chatter_File_Id__c,Feed_ID__c,Feed_Thumbnail_URL__c,Feed_URL__c from File__c where Asset__c in: mapAssetSearchList.keySet() and Is_Primary_Image__c = true]){
                    //check if Thumbnail URL field is populated if not populate this field
                    if(f.Feed_Thumbnail_URL__c == null){
                        WINatPOSUtil.cacheFeedURL(f);
                        filesWithoutThumbnailUrl.add(f);
                    }
                    String convertedThumbnail = f.Feed_Thumbnail_URL__c;
                    
                    convertedThumbnail=convertedThumbnail != null ? convertedThumbnail.replace('THUMB720BY480','THUMB120BY90') : null;
                    convertedThumbnail = WINatPOSUtil.urlRewrite(convertedThumbnail);
                    /*
                    if( convertedThumbnail != null && !WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
                    	convertedThumbnail = convertedThumbnail.replace('/' + communityName, '');
                    }
					*/
                    
                    //fileMapsForAsset.put(f.Asset__c,new List<String>{f.Feed_Thumbnail_URL__c});
                    fileMapsForAsset.put(f.Asset__c,new List<String>{convertedThumbnail});     
                }    
            }
            
            if(mapAssetGroupSearchList.keySet().size()>0){
                //assetGroupSearchList rebuilded added assetGroups wher asset belongs to asset group
                mapAssetGroupSearchList=new Map<Id,Asset_Group__c>([select Name,Brand__c,Category__c, New_Indicator__c, Type__c,Id from Asset_Group__c where id in :mapAssetGroupSearchList.keySet()]);
                //[select Asset_Group__c,id,(select Feed_ID__c, Feed_Thumbnail_URL__c, Feed_URL__c, Is_Primary_Image__c from Files__r where Is_Primary_Image__c = true) from Asset__c where Asset_Group__c in : mapAssetGroupSearchList.keySet() and Status__c =: WINatPOSUtil.assetTypeApproved ]
                for(Asset__c a: WINatPOSUtil.getAssetsForAssetGroupForSearch(mapAssetGroupSearchList.keySet())){
                    for(File__c f: a.Files__r){
                        if(f.Feed_Thumbnail_URL__c == null){
                            WINatPOSUtil.cacheFeedURL(f);
                            filesWithoutThumbnailUrl.add(f);
                        }
                        String convertedThumbnail=f.Feed_Thumbnail_URL__c;
                    	convertedThumbnail=convertedThumbnail != null ? convertedThumbnail.replace('THUMB720BY480','THUMB120BY90') : null;
                        convertedThumbnail = WINatPOSUtil.urlRewrite(convertedThumbnail);
                        /*
                    	if( convertedThumbnail != null && !WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
	                    	convertedThumbnail = convertedThumbnail.replace('/' + communityName, '');
	                    }
						*/
                        if(fileMapsForAssetGroup.containsKey(a.Asset_Group__c)){
                            List<String> tmpList=fileMapsForAssetGroup.get(a.Asset_Group__c);
                            //tmpList.add(f.Feed_Thumbnail_URL__c);
                            tmpList.add(convertedThumbnail);
                        }else{
                            //fileMapsForAssetGroup.put(a.Asset_Group__c,new List<String>{f.Feed_Thumbnail_URL__c});
                            fileMapsForAssetGroup.put(a.Asset_Group__c,new List<String>{convertedThumbnail});
                        }
                    }
                }
            }   
            //build final list of Results for asset which don't belongs to assetGroup
            for(Asset__c assetItem : mapAssetSearchList.values()){
                //check if Asset group have a related file
                List<String> relatedForAsset=fileMapsForAsset.containsKey(assetItem.id) ? fileMapsForAsset.get(assetItem.id) : null;
                //add asset to search result
               assetResultWrapper.add(new WINatPOSRemoteActionWrapper.AssetResultWrapper(assetItem,relatedForAsset,null,assetItem.Name));
            }
           
            for(Asset_Group__c assetGroupItem : mapAssetGroupSearchList.values()){
                //check if Asset group have a related file
                List<String> relatedFileForGroup=fileMapsForAssetGroup.containsKey(assetGroupItem.id) ? fileMapsForAssetGroup.get(assetGroupItem.id) : null;
                //add asset group to search result
                assetResultWrapper.add(new WINatPOSRemoteActionWrapper.AssetResultWrapper(null,relatedFileForGroup,assetGroupItem,assetGroupItem.Name)); 
            }
            
            if(!filesWithoutThumbnailUrl.isEmpty()){
                //updating File Feed_Thumbnail_URL__c field
                Database.SaveResult [] sr=Database.update(filesWithoutThumbnailUrl,false) ;
            }
            assetResultWrapper.sort();
            WINatPOSRemoteActionWrapper.SearchWrapper searchWrapper=new WINatPOSRemoteActionWrapper.SearchWrapper(filterList,WinAtPOSUtil.getResultsForPage(assetResultWrapper,pageSize,pageNumber));
            system.debug('*** WINatPOS search method returned: '+new WINatPOSRemoteActionWrapper('search method return results','0',new List<WINatPOSRemoteActionWrapper.SearchWrapper>{searchWrapper},''));
            return new WINatPOSRemoteActionWrapper('search method return results','0',new List<WINatPOSRemoteActionWrapper.SearchWrapper>{searchWrapper},'');
        }
    }    
    
    /*******************************************************************
    Purpose: Method is helper method to search engine it's build where clauses for main search result.
    
    Parameters: [String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country]
    Returns: [WINatPOSRemoteActionWrapper]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper buildWhereClausesForSearch(String searchType, String brandId,String categoryId,String keyWord,String assetType,String assetChannel,String assetCluster,String assetPlacment,String country){
        System.Debug('*** WINatPOS buildWhereClausesForSearch input parametes searchType: '+searchType+
                     ',brandId' +brandId+',categoryId: '+categoryId+',keyWord:'+keyWord+
                     ',assetType:'+assetType+',assetChannel:'+assetChannel+',assetCluster'+assetCluster+',assetPlacment:'+assetPlacment);
        
        if(searchType == null || searchType ==''){
             return new WINatPOSRemoteActionWrapper('search method return no results','1',null,'serch type prarameter needs to be specified available values: '
                                                    +'\n categorySearch \n brandSearch \n innovationSearch \n bestPracticesSearch \n repetableSerach \n keywordSearch'
             );
        }
        //whereClauseForAsset
        //whereClause
        String whereClauseForAsset='where Status__c = \''+WINatPOSUtil.assetTypeApproved+'\'';
        String whereClauseForTouchpoint='';
        String whereClauseForAssetGroup='';
        
        Set<ID> categoriesForBrandIds=new Set<ID>();
        Set<ID> brandsForCategoryIds=new Set<ID>();
        
        //Start building where query clause
        try{
            if(brandId != null && brandId !='' ){
                Id isVailidId=Id.valueOf(brandId);//check for validation porpouse
                //brandsForCategoryIds.add(brandId);
                
                whereClauseForAsset += ' and Brand__c = \''+brandId+'\'';
                whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Brand__c = \''+brandId+'\'' : ' and Brand__c = \''+brandId+'\'';
            }
            
            if(categoryId != null  && categoryId !=''){
                id isVailidId=Id.valueOf(categoryId);//check for validation porpouse
                //categoriesForBrandIds.add(categoryId);
                whereClauseForAsset += ' and Category__c = \''+categoryId+'\'';
                whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Category__c = \''+categoryId+'\'' : ' and Category__c = \''+categoryId+'\'';
            }
        }catch(Exception ex){
            //IF Exception occured passed Id for category or brand is invalid
            return new WINatPOSRemoteActionWrapper('search method return error','1',null,ex.getMessage());
        }    
        
        if(assetType != null  && assetType != ''){
            String translatedValueFromUI='';
            if(WinAtPOSUtil.assetTypeTranslationFromUIToDb.containsKey(assetType)){
                translatedValueFromUI=WinAtPOSUtil.assetTypeTranslationFromUIToDb.get(assetType);
            }else{
                translatedValueFromUI=assetType;
            }
            //if where clasue is empty and where phase else and
            whereClauseForAsset += ' and POS_Asset_Type__c = \''+translatedValueFromUI+'\'';
            whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Type__c = \''+translatedValueFromUI+'\'' : ' and Type__c = \''+translatedValueFromUI+'\'';
        }
        
        if(searchType == WINatPOSUtil.bestPracticesSearch){
            //if where clasue is empty and where phase else and
            if(whereClauseForAsset.contains('POS_Asset_Type__c =')){
               return new WINatPOSRemoteActionWrapper('search method failed','1',null,'Method search was called with wrong parametes assetTypes can not be used in bestPracticesSearch');
            }
            whereClauseForAsset += ' and POS_Asset_Type__c = \''+WINatPOSUtil.assetTypeForBestPractisesSearch+'\'';
            whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Type__c = \''+WINatPOSUtil.assetTypeForBestPractisesSearch+'\'' : ' and Type__c = \''+WINatPOSUtil.assetTypeForBestPractisesSearch+'\'';
        }
        
        if(searchType == WINatPOSUtil.innovationSearch){
            //if where clasue is empty and where phase else and
            if(whereClauseForAsset.contains('POS_Asset_Type__c =')){
               return new WINatPOSRemoteActionWrapper('search method failed','1',null,'Method search was called with wrong parametes assetTypes can not be used in innovationSearch');
            }
            whereClauseForAsset += ' and POS_Asset_Type__c = \''+WINatPOSUtil.assetTypeForInnovationSearch+'\'';
            whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Type__c = \''+WINatPOSUtil.assetTypeForInnovationSearch+'\'' : ' and Type__c = \''+WINatPOSUtil.assetTypeForInnovationSearch+'\'';
        }
        if(searchType == WINatPOSUtil.repetableSearch){
            //if where clasue is empty and where phase else and
            if(whereClauseForAsset.contains('POS_Asset_Type__c =')){
               return new WINatPOSRemoteActionWrapper('search method failed','1',null,'Method search was called with wrong parametes assetTypes can not be used in repetableSerach');
            }
            whereClauseForAsset += ' and POS_Asset_Type__c = \''+WINatPOSUtil.assetTypeForRepetableSearch+'\'';
            whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Type__c = \''+WINatPOSUtil.assetTypeForRepetableSearch+'\'' : ' and Type__c = \''+WINatPOSUtil.assetTypeForRepetableSearch+'\'';
        }
        
        if(searchType == WINatPOSUtil.ctaSearch){
            //if where clasue is empty and where phase else and
            if(whereClauseForAsset.contains('POS_Asset_Type__c =')){
               return new WINatPOSRemoteActionWrapper('search method failed','1',null,'Method search was called with wrong parametes assetTypes can not be used in Call To Action Search');
            }
            whereClauseForAsset += ' and POS_Asset_Type__c = \''+WINatPOSUtil.assetTypeForCTISearch+'\'';
            whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Type__c = \''+WINatPOSUtil.assetTypeForCTISearch+'\'' : ' and Type__c = \''+WINatPOSUtil.assetTypeForCTISearch+'\'';
        }
        
        if(assetChannel != null  && assetChannel != ''){
            //if where clasue is empty and where phase else and
            whereClauseForAsset += ' and Channels__c includes (\''+assetChannel+'\')';
        }
        
        if(assetCluster != null  && assetCluster != ''){
            //if where clasue is empty and where phase else and
            whereClauseForAsset += ' and Market_Cluster__c = \''+assetCluster+'\'';
            whereClauseForAssetGroup += whereClauseForAssetGroup == ''? 'where Market_Cluster__c = \''+assetCluster+'\'' : ' and Market_Cluster__c = \''+assetCluster+'\'';
        }
        
        if(assetPlacment != null  && assetPlacment != ''){
            //if where clasue is empty and where phase else and
            whereClauseForAsset += ' and Placement__c =\''+assetPlacment+'\'';
        }
        if(country != null  && country != ''){
            //if where clasue is empty and where phase else and
            whereClauseForAsset += ' and Country__c =\''+country+'\'';
        }
        if(keyWord != null && keyWord != ''){
            //String kewordWithRemovedReseved=keyWord.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
            whereClauseForTouchpoint = whereClauseForAsset + ' and Touchpoint__c like\'%'+keyWord+'%\'';
        }
        //end building where query clause
        system.debug('*** WINatPOS buildWhereClausesForSearch method where query clause for Assets looks as following: '+whereClauseForAsset);
        system.debug('*** WINatPOS buildWhereClausesForSearch method where query clause for AssetsGroups looks as following: '+whereClauseForAssetGroup);
        system.debug('*** WINatPOS buildWhereClausesForSearch method where query clause for AssetsGroups looks as following: '+whereClauseForTouchpoint);
        List<WINatPOSRemoteActionWrapper.WhereClauseWrapper> whereCalueses=new List<WINatPOSRemoteActionWrapper.WhereClauseWrapper>{
                                                                                new WINatPOSRemoteActionWrapper.WhereClauseWrapper(whereClauseForAsset,whereClauseForAssetGroup,whereClauseForTouchpoint)};
        return new WINatPOSRemoteActionWrapper('search buildWhereClausesForSearch','0',whereCalueses,'');
    }
    
    /*******************************************************************
    Purpose: Method returns annaoucment for specified group or parent object
    navigation menu on home page 
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static WINatPOSRemoteActionWrapper getAnnouncementForGroup(String patentId){
        system.debug('*** WINatPOS getAnnouncementForGroup input parameter: '+patentId);
        try{
            WinAtPOSRemoteActions__c  remotActionConf=WinAtPOSRemoteActions__c.getValues('WinAtPOSRemoteActionConf');
            String winAtPosGroup=remotActionConf != null ? remotActionConf.WinAtPosGroup__c :'';
            if(System.Test.isRunningTest()){
                winAtPosGroup=WinAtPOSUtil.winAtPostChatterGroupForTest;
            }
            if(patentId == null || patentId == ''){
              String networkId = Network.getNetworkId(); 
              List<CollaborationGroup> colGroup=[SELECT Id,Name From CollaborationGroup where name =: winAtPosGroup and NetworkId =: networkId limit 1];  
              patentId=colGroup.get(0).Id;
            }
            List<FeedItem> annoucments=[select id,ParentId, Body,Title,LinkUrl,CreatedById,CreatedDate FROM FeedItem WHERE Type = 'AdvancedTextPost' and ParentId =:patentId order by CreatedDate desc limit 1];
            if(!annoucments.isEmpty()){
               
                FeedItem annouc=annoucments.get(0);
                WINatPOSRemoteActionWrapper.GroupAnnaucment annoucment=new WINatPOSRemoteActionWrapper.GroupAnnaucment();
                String userFotorUrl='';
                ConnectApi.Photo userAvatar=ConnectApi.ChatterUsers.getPhoto(null, annouc.CreatedById);
                if(userAvatar != null){
                    userFotorUrl=userAvatar.smallPhotoUrl;
                }
                annoucment.title=annouc.Title;
                annoucment.description=annouc.Body;
                annoucment.imageUrl=userFotorUrl;
                annoucment.announcementUrl=URL.getSalesforceBaseUrl().toExternalForm() + '/' + annouc.Id;
                String convertedCreatedDate = annouc.CreatedDate.format('MMMMM d, yyyy');   
                annoucment.announceDate=convertedCreatedDate;
                annoucment.authorName=[Select name from user where id =:annouc.CreatedById limit 1].get(0).name;
                annoucment.authorUrl=URL.getSalesforceBaseUrl().toExternalForm() + '/' + annouc.CreatedById;
                annoucment.groupName=winAtPosGroup;
                system.debug('*** WINatPOS getAnnouncementForGroup returned result:'+new WINatPOSRemoteActionWrapper('search getAnnouncementForGroup sucess','0',new List<WINatPOSRemoteActionWrapper.GroupAnnaucment> {annoucment},''));
                return new WINatPOSRemoteActionWrapper('search getAnnouncementForGroup sucess','0',new List<WINatPOSRemoteActionWrapper.GroupAnnaucment> {annoucment},'');
                
            }
             
            return new WINatPOSRemoteActionWrapper('search getAnnouncementForGroup returned no results','0',null,'');
        }catch(Exception ex){
            system.debug('*** WINatPOS getAccoucmentForGroup get exception : '+ex.getMessage());
            return new WINatPOSRemoteActionWrapper('search getAccoucmentForGroup returned error','1',null,ex.getMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method returns category or brand related files for sub carusel on home page
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    
    public static WINatPOSRemoteActionWrapper  getCaruselForBrandOrCategory(String searchType, String brandId,String categoryId,String keyWord){
        system.debug('*** WINatPOS getCaruselForBrandOrCategory input parameter searchType: '+searchType+',brandId: '+brandId+',categoryId:'+categoryId+',keyWord:'+keyWord);
        if(searchType == null || searchType ==''){
             return new WINatPOSRemoteActionWrapper('getCaruselForBrandOrCategory method return no results','1',null,'serchType prarameter needs to be specified available values: '
                                                    +'\n categorySearch \n brandSearch \n keywordSearch'
             );
        }
        List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> caruselList= new List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper>();
        
        if(searchType == WINatPOSUtil.brandSearch && brandId != null && brandId != ''){
            system.debug('*** WINatPOS getCaruselForBrandOrCategory inside brandSearch');
            List<Brand_Master__c> brandForCarusel;
            
            if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
            	brandForCarusel = WINatPOSUtil.getBrandForCaruselByList(new List<Brand_Master__c>{new Brand_Master__c(Id = brandId)});
            }else{
            	brandForCarusel=[select name,Brand_Logo__c,id,
                                                (select ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId()),
                                                (Select Feed_URL__c, Name,Feed_ID__c,id From Files__r order by Name asc)
                                                 from Brand_Master__c where id =: brandId];
            }
            
                                                 
            caruselList = getCaruselsForCategoryOrBrand(null,brandForCarusel,caruselList,WINatPOSUtil.brandSearch);
        }else if(searchType == WINatPOSUtil.categorySearch && categoryId != null && categoryId != ''){
            system.debug('*** WINatPOS getCaruselForBrandOrCategory inside categorySearch');
            
            List<Category__c> catForCarusel;
            if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
            	catForCarusel = WINatPOSUtil.getCatForCaruselByList(new List<Category__c>{new Category__c(Id = categoryId)});
            }else{
            	catForCarusel = [select name,Category_Logo__c,id,
                                                (select ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId()),
                                                (select Feed_URL__c, Name,Feed_ID__c,id From CategoryUploads__r order by Name asc) 
                                                 from Category__c where id =: categoryId];
            }
                                                 
            caruselList = getCaruselsForCategoryOrBrand(catForCarusel,null,caruselList,WINatPOSUtil.categorySearch);
            
        }else if(searchType == WINatPOSUtil.keywordSearch && keyWord != null && keyWord != ''){
            //keyWord = keyWord.replace('?','\\?').replace('&','\\&').replace('!','\\!').replace('{','\\{').replace('}','\\}').replace('[','\\[').replace('(','\\(').replace(')','\\)').replace('^','\\^').replace('~','\\~').replace(':','\\:').replace('\\','\\\\').replace('"','\\"').replace('\'','\\\'').replace('+','\\+').replace('-','\\\\-');
            String soslQuery='Find \''+keyWord+'\' IN Name FIELDS RETURNING Brand_Master__c(Name,id order by Name asc),Category__c(Name,id order by name asc)';
            
            List<List<SObject>> searchList;//=search.query(soslQuery);
            
            if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
            	searchList = WINatPOSUtil.searchForCommunityUsers(soslQuery);
            }else{
            	searchList = search.query(soslQuery);
            }
            List<Brand_Master__c> brands = (List<Brand_Master__c>)searchList.get(0);
            List<Category__c> categories = (List<Category__c>)searchList.get(1);
            WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper caruselWrap=null;
            if(brands.size() > 0){
            	
            	List<Brand_Master__c> brandForCarusel;
            	if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
            		brandForCarusel = WINatPOSUtil.getBrandForCaruselByList(brands);
            	}else{
            		brandForCarusel = [select name,Brand_Logo__c,id,
                                                (select ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId()),
                                                (Select Feed_URL__c, Name,Feed_ID__c,id From Files__r order by Name asc)
                                                 from Brand_Master__c where id in : brands order by name];
            	}
                
                                                 
               caruselList=getCaruselsForCategoryOrBrand(null,brandForCarusel,caruselList,WINatPOSUtil.brandSearch);    
            }
            WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper caruselWrap1=null;
            if(categories.size()>0){
            	List<Category__c> catForCarusel;
                
                if(WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
                	catForCarusel = WINatPOSUtil.getCatForCaruselByList(categories);
                }else{
                	catForCarusel = [select name,Category_Logo__c,id,
                                                (select ParentId, SubscriberId from FeedSubscriptionsForEntity where SubscriberId =: UserInfo.getUserId()),
                                                (Select Feed_URL__c, Name,Feed_ID__c,id From CategoryUploads__r order by Name asc)
                                                 from Category__c where id in : categories order by name];
                }
                
                                                 
               caruselList=getCaruselsForCategoryOrBrand(catForCarusel,null,caruselList,WINatPOSUtil.categorySearch);
                
            }
        }
        
        system.debug('*** WINatPOS getCaruselForBrandOrCategory returned following result:\n '+JSON.serialize(new WINatPOSRemoteActionWrapper('getCaruselForBrandOrCategory return  results','0',caruselList,'')));
        return new WINatPOSRemoteActionWrapper('getCaruselForBrandOrCategory return  results','0',caruselList,'');
    }
    
    /*******************************************************************
    Purpose: Method is helper method to get files for list of brands or categories 
    and related files
    Parameters: [optional]
    Returns: WINatPOSRemoteActionWrapper
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> getCaruselsForCategoryOrBrand(List<Category__c> listOfCategoryCarusel,List<Brand_Master__c> listOfBrandCarusel,List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> caruselWrapLst,String searchType){
        system.debug('*** WINatPOS getCaruselForBrandOrCategory input parameter listOfCategoryCarusel: '+listOfCategoryCarusel+'listOfBrandCarusel:'+listOfBrandCarusel+ ',caruselWrapLst: '+caruselWrapLst+',searchType:'+searchType);
        
        String communityName = WINatPOSUtil.getCommunityName();
        String regexPattern='<img.+?src=[\"\'](.+?)[\"\'].+?>';
        Pattern logoPattern = Pattern.compile(regexPattern);
        Boolean isFirst=true;
        List<Category__c> lstOfCategoryCarusel=null;
        List<Brand_Master__c> lstOfBrandCarusel=null;
        if(searchType == WINatPOSUtil.categorySearch){
            lstOfCategoryCarusel=listOfCategoryCarusel;
            for(Category__c cat : lstOfCategoryCarusel){
                //crate carusels for categories
                //select if user follow the category
                Boolean isUserFollowCategory=cat.FeedSubscriptionsForEntity == null? false : cat.FeedSubscriptionsForEntity.size()>0;
                //set logo for category
                String urlToLogo=null;
                if(cat.Category_Logo__c != null){
                        Matcher logoMatcher=logoPattern.matcher(cat.Category_Logo__c);
                        if(logoMatcher.matches() && logoMatcher.groupCount() == 1){
                            //retrive logo for category
                            urlToLogo=logoMatcher.group(1);
                            if( urlToLogo != null && WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
                            	urlToLogo = urlToLogo.replace('/resource/', '/' + communityName + '/resource/');
                            }
                        }
                }
                WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper caruselWrap=new WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper(cat.Name,urlToLogo,null,cat.id,isUserFollowCategory);
                //retrive files for category
                if(Network.getNetworkId() == null){
                    if(cat.CategoryUploads__r != null){
                        for(File__c f : cat.CategoryUploads__r){
                            if (f.Feed_URL__c == null) {
                                WINatPOSUtil.cacheFeedURL(f);  // Try to cache the download Url to optimize performance
                            }
                            if(caruselWrap.filesRelated == null){
                                caruselWrap.filesRelated= new List<WINatPOSRemoteActionWrapper.RelatedFiles>{new WINatPOSRemoteActionWrapper.RelatedFiles(f.Name,f.Feed_URL__c,f.id,f.Feed_ID__c)};
                            }else{
                                caruselWrap.filesRelated.add(new WINatPOSRemoteActionWrapper.RelatedFiles(f.Name,f.Feed_URL__c,f.id,f.Feed_ID__c));
                            }
                        }
                    }
                }    
                caruselWrapLst.add(caruselWrap);
            }
        }else if(searchType == WINatPOSUtil.brandSearch){
            lstOfBrandCarusel=listOfBrandCarusel;
            for(Brand_Master__c brand : lstOfBrandCarusel){
                //crate carusels for brands
                //check if user follow the brand
                Boolean isUserFollowBrand=brand.FeedSubscriptionsForEntity == null? false : brand.FeedSubscriptionsForEntity.size()>0;
                //set logo for brand
                String urlToLogo=null;
                if(brand.Brand_Logo__c != null){
                        Matcher logoMatcher=logoPattern.matcher(brand.Brand_Logo__c);
                        if(logoMatcher.matches() && logoMatcher.groupCount() == 1){
                            //retrive logo for brand
                            urlToLogo = logoMatcher.group(1);
                            if(urlToLogo != null && WINatPOSUtil.checkIsCommunityUser(UserInfo.getUserId(), UserInfo.getProfileId())){
                            	urlToLogo = urlToLogo.replace('/resource/', '/' + communityName + '/resource/');
                            }
                            
                        }
                }
                WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper caruselWrap=new WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper(brand.Name,urlToLogo,null,brand.id,isUserFollowBrand);
                //retrive files for brand
                if(Network.getNetworkId() == null){
                    if(brand.Files__r != null){
                        for(File__c f : brand.Files__r){
                            if (f.Feed_URL__c == null) {
                                WINatPOSUtil.cacheFeedURL(f);  // Try to cache the download Url to optimize performance
                            }
                            if(caruselWrap.filesRelated == null){
                                caruselWrap.filesRelated= new List<WINatPOSRemoteActionWrapper.RelatedFiles>{new WINatPOSRemoteActionWrapper.RelatedFiles(f.Name,f.Feed_URL__c,f.id,f.Feed_ID__c)};
                            }else{
                                caruselWrap.filesRelated.add(new WINatPOSRemoteActionWrapper.RelatedFiles(f.Name,f.Feed_URL__c,f.id,f.Feed_ID__c));
                            }
                        }
                    }
                }    
                caruselWrapLst.add(caruselWrap);
            }
            
        }
        system.debug('*** WINatPOS getCaruselForBrandOrCategory set following carusels for Sobjects:\n '+JSON.serialize(caruselWrapLst));
        return caruselWrapLst;
            
    }
    
    public static void getNumberOfContentDocument(){
        system.debug([SELECT Id FROM ContentVersion].size());
    }
    
    /*******************************************************************
	Purpose: Method is handlig granting sharings for Assets
	Parameters: [Asset__c myAsset]
	Returns: [void]
	Throws [Exceptions]: [optional] 
	********************************************************************/
	public static void handleAssetAgenciesShares(List<Asset__c> myAssetList){
		
		System.Debug('*** WINatPOS handleAssetAgenciesShares input parameter myAssetList: ' + myAssetList);
		
		List<Asset__Share> editSharesToInsert = new List<Asset__Share>();
		List<Asset__Share> viewSharesToInsert = new List<Asset__Share>();
		//List<Asset__Share> sharesToDelete = new List<Asset__Share>();
        Map<id,Asset_Group__Share> assetGroupSharesToInsert = new Map<Id,Asset_Group__Share>();
		Set<String> publicGroupsToAdd = new Set<String>();
		Map<Id, List<String>> assetIdToEditPublicGroupsList = new Map<Id, List<String>>();
		Map<Id, List<String>> assetIdToViewPublicGroupsList = new Map<Id, List<String>>();
		Map<String, Group> groupNameToObject = new Map<String, Group>();
		//Set<id> asseGroupIds = new Set<Id>();
        
		for(Asset__c myAsset : myAssetList){
			if(!String.isBlank(myAsset.Agency_Edit_Access_Text__c)){
				assetIdToEditPublicGroupsList.put(myAsset.Id, myAsset.Agency_Edit_Access_Text__c.split(';'));
				publicGroupsToAdd.addAll(myAsset.Agency_Edit_Access_Text__c.split(';'));
			}
			if(!String.isBlank(myAsset.Agency_Read_Access_Text__c)){
				assetIdToViewPublicGroupsList.put(myAsset.Id, myAsset.Agency_Read_Access_Text__c.split(';'));
				publicGroupsToAdd.addAll(myAsset.Agency_Read_Access_Text__c.split(';'));
			}
		}
		
		for(Group myTmpGroup : [SELECT Name, ID FROM Group WHERE Name IN :publicGroupsToAdd]){
			groupNameToObject.put(myTmpGroup.Name, myTmpGroup);
		}

		for(Asset__c myAsset : myAssetList){
			
			//get Groups that should be updated - edit
			if(assetIdToEditPublicGroupsList.containsKey(myAsset.Id)){
				for(String groupName : assetIdToEditPublicGroupsList.get(myAsset.Id)){
					if(groupNameToObject.containsKey(groupName)){
						editSharesToInsert.add(new Asset__Share(ParentId = myAsset.Id, UserOrGroupId = groupNameToObject.get(groupName).Id, AccessLevel = 'Edit'));
                        //add read share for asset groups
                        if(myAsset.Asset_Group__c != null){
                            assetGroupSharesToInsert.put(myAsset.Asset_Group__c,new Asset_Group__Share(ParentId = myAsset.Asset_Group__c, UserOrGroupId = groupNameToObject.get(groupName).Id, AccessLevel = 'Read'));
                        }
					}
				}
			}
			
			//get Groups that should be updated - view
			if(assetIdToViewPublicGroupsList.containsKey(myAsset.Id)){
				for(String groupName : assetIdToViewPublicGroupsList.get(myAsset.Id)){
					if(groupNameToObject.containsKey(groupName)){
						viewSharesToInsert.add(new Asset__Share(ParentId = myAsset.Id, UserOrGroupId = groupNameToObject.get(groupName).Id, AccessLevel = 'Read'));
                        if(myAsset.Asset_Group__c != null){
                            assetGroupSharesToInsert.put(myAsset.Asset_Group__c,new Asset_Group__Share(ParentId = myAsset.Asset_Group__c, UserOrGroupId = groupNameToObject.get(groupName).Id, AccessLevel = 'Read'));
                        }
					}
				}
			}
		}
		
		List<Group> winAtPosPublicGroups = [SELECT Name, Id FROM Group WHERE Name like 'Win@POS%' ORDER BY Name];
		
		Savepoint sp = Database.setSavepoint();
		
		try{
			//crean up old sharings for WinatPOS Public Groups
			delete [SELECT Id FROM Asset__Share WHERE ParentId IN :myAssetList AND UserOrGroupId IN :winAtPosPublicGroups];
			//clean up old sharing for asset groups
			delete [SELECT Id FROM Asset__Share WHERE ParentId IN :assetGroupSharesToInsert.keySet() AND UserOrGroupId IN :winAtPosPublicGroups];
			
			//insert new sharings
			insert viewSharesToInsert;
            system.debug('Assets share to insert '+viewSharesToInsert.size());
			insert editSharesToInsert;
            system.debug('Assets Group share to insert '+assetGroupSharesToInsert.size());
            insert assetGroupSharesToInsert.values();
		}catch(Exception ex){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        	// Rollback any changes
            Database.rollback(sp);
		}
		
	}
    
}