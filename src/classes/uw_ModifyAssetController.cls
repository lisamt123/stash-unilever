/*****************************************************************************************************
Change History
--------------
Date          Author       version             Description                       Requested By       Tag
---------------------------------------------------------------------------------------------------------
02 June 2014   Jayashree    0.01               Fix for release of Brand Experience  Unilever        T0
                                               Presentation for other profiles
*************************************************************************************************************/                                               
public with sharing class uw_ModifyAssetController 
{
    public static final String STUDIO_ASSET_TYPE_PRESO = 'Brand Experience Presentation';
    public static final String STUDIO_ASSET_TYPE_DOC = 'Document';
    public static final String STUDIO_ASSET_TYPE_CREATIVE_W = 'Creative Work';
    public static final String ASSET_STATUS_WIP = 'Work In Progress';
    public static final String ASSET_STATUS_FINAL = 'Final';
     
    public Boolean isCreateMode = false;
    public uw_Asset__c uwAsset = null;
    public uw_BET__c bet = null;
    public String promoteAssetToToolkit{get;set;}
    public String fileInToolkit{get;set;}
    public String bestPractice{get;set;}
    public List<SelectOption> documentTypeItems = null;
    public List<SelectOption> mediaChannelItems = null;
    public List<SelectOption> localisationTypeItems = null;    
    public Boolean saveSuccessful = false;
    public Boolean Presentation_exist{get;set;}
    
    
       
    public uw_ModifyAssetController (Apexpages.Standardcontroller sc)
    {

       
        uwAsset = (uw_Asset__c)sc.getRecord();
        List<uw_Asset__c> uwAsset_presentation_toolkit;


        
        if (!uw_HelperMethods.valueIsNull(uwAsset.Id))
        {
                uwAsset = [Select uw_BET__c, thumbnail__c, Usage__c, URL_of_Asset__c, 
                Status__c, Promoted__c, Other_Media_Channel__c,  
                Name, Media_Type__c, Media_Channel_1__c, Location_Type__c,  Is_bucket_field__c, 
                Id, Description__c, Categorisation_3__c, 
                Big_Think_Pack__c, BET_Chatter_Group__c, 
                Agency__c, Studio_Asset_Type__c,
                Localisation_Requirement__c,  Related_Feed_Item__c From uw_Asset__c where Id = :uwAsset.Id];
                
                system.debug('Studio_Asset_Type__c!!!!!!!!!!' + uwAsset.Studio_Asset_Type__c);
              
                system.debug('uwAsset' + uwAsset.Id);
                
                system.debug('URL_of_Asset__c' + uwAsset.URL_of_Asset__c);
                
                
                bet = [Select Id, Name, Status__c from uw_Bet__c where Id = :uwAsset.uw_BET__c];
                
                isCreateMode = false;

        
                
                if (uwAsset.Promoted__c)
                {
                        promoteAssetToToolkit = 'Yes';
                        fileInToolkit = 'Yes';
                }
                else
                {
                        promoteAssetToToolkit = 'No';
                }
                
           
       
        }
        else
        {
                isCreateMode = true;
                bet = [Select Id, Name, Status__c from uw_Bet__c where Id = :getBetId()];
                initializeAssetFromFeedItem();
        }
        
    /* Code added by ACC-IDC-Srilakshmi for Incident ULHD00007290396 - 'Error in Brand Experience Presentation Release Mechanism' */

    
    uwAsset_presentation_toolkit=[ Select Id ,uw_BET__c,Big_Think_Pack__c,Promoted__c,Status__c,Studio_Asset_Type__c from uw_Asset__c where uw_BET__c =:bet.Id and Promoted__c=true and Studio_Asset_Type__c ='Brand Experience Presentation' and Big_Think_Pack__c =true LIMIT 1];

        System.debug('Value of BET Id'+getBetId());
        if(uwAsset_presentation_toolkit.size()>0)
        {
                Presentation_exist=true;
        }
        else 
        {
                Presentation_exist=false;
        }
       System.debug('Presentation exist value**********************'+Presentation_exist);

    /* Code added by ACC-IDC-Srilakshmi for Incident ULHD00007290396 - 'Error in Brand Experience Presentation Release Mechanism'Ends */

        isFileOver25MB = false;
        isPPTXFile = false;
    }
    
    

    public void initializeAssetFromFeedItem()
    {
        String feedItemId = Apexpages.currentPage().getParameters().get('feedItemId');
        String mediaType = ApexPages.currentpage().getparameters().get('MediaType');
        String thumb = ApexPages.currentpage().getparameters().get('thumb');
        
        String feedCommentId = ApexPages.currentpage().getparameters().get('feedcommentId');            
        
        system.debug('feedItemId: <' + feedItemId+'>');
        system.debug('feedcommentId: <' + feedCommentId+'>');
                
        Boolean isFeed;
        if (!uw_HelperMethods.valueIsNull(feedItemId))  {
            isFeed = true;
        } else if (!uw_HelperMethods.valueIsNull(feedCommentId)) {
            isFeed = false;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not label file as file was not from a Chatter File.'));
            return;
        }
                
        system.debug('mediaType' + mediaType);
        system.debug('thumb' + thumb);
        system.debug('isFeed: '+isFeed);
        
        if (uw_HelperMethods.isSystemAdminUser() || true)
        {
            if (feedItemId != null)
                feedItemId = String.escapeSingleQuotes(feedItemId);
            if (feedCommentId != null)
                feedCommentId = String.escapeSingleQuotes(feedCommentId);
            List<uw_Asset__c> searchAssets;
            if (isFeed) {
                system.debug('search by FeedItem');
                searchAssets = [Select uw_BET__c, thumbnail__c, Usage__c, URL_of_Asset__c,  
                    Status__c, Promoted__c, Other_Media_Channel__c,  
                    Name, Media_Type__c, Media_Channel_1__c, Location_Type__c, Is_bucket_field__c, 
                    Id, Description__c, Categorisation_3__c, 
                    Big_Think_Pack__c, BET_Chatter_Group__c, 
                    Agency__c, Studio_Asset_Type__c,
                    Localisation_Requirement__c, Related_Feed_Item__c From uw_Asset__c where Related_Feed_Item__c =:feedItemId LIMIT 1];                
            } else {
                system.debug('search by FeedComment');
                searchAssets = [Select uw_BET__c, thumbnail__c, Usage__c, URL_of_Asset__c,
                    Status__c, Promoted__c, Other_Media_Channel__c,
                    Name, Media_Type__c, Media_Channel_1__c, Location_Type__c, Is_bucket_field__c, 
                    Id, Description__c, Categorisation_3__c, 
                    Big_Think_Pack__c, BET_Chatter_Group__c, 
                    Agency__c, Studio_Asset_Type__c,
                    Localisation_Requirement__c, Related_Feed_Item__c From uw_Asset__c where Related_Feed_Comment__c = :feedCommentId LIMIT 1];             
            }
        
            if (searchAssets.size() == 1)
            {
                uwAsset = searchAssets.get(0);
                system.debug('uwAsset: '+uwAsset);                
                isCreateMode = false;
                
                if (uwAsset.Promoted__c)
                {
                        promoteAssetToToolkit = 'Yes';
                        fileInToolkit = 'Yes';
                }
                else
                {
                        promoteAssetToToolkit = 'No';
                }
                
                
               
                return;
            }
            
            
        }
        
        CollaborationGroupFeed feedItem = null;
        FeedComment feedComment = null;
        
        try
        {
            if (isFeed) {
                feedItem = [Select Type, LinkURL, title, body, ContentFileName, 
                            ContentDescription, relatedrecordid from CollaborationGroupFeed where id = : feedItemId];
                system.debug('feedItem: '+feedItem);
            } else {
                List<FeedComment> feedComments = uw_FeedComments.getFeedCommentById(feedCommentId);
                feedComment = (feedComments.size()==1) ? feedComments[0] : null;
                //[SELECT CommentBody, CommentType, FeedItemId, ParentId, RelatedRecordId FROM FeedComment WHERE id = :feedCommentId];
                system.debug('feedComment: '+feedComment);
            }
        }
        catch(Exception ex)
        {
            system.debug('Error in Selecting CollaborationGroupFeed/FeedComment; Exception: ' + ex);
        }
        
        if(feedItem != null)
        {
            if (feedItem.Type == 'ContentPost')
            {
                // uwAsset.URL_of_Asset__c = feedItem.relatedrecordid;
                uwAsset = getAssetInfoFromContentPost(isFeed, feedItem, feedComment, uwAsset);
            }
            else if (feedItem.Type == 'LinkPost')
            {
                //system.debug('ssssssssssssss' + feedItem.LinkURL);
                //uwAsset.URL_of_Asset__c = feedItem.LinkURL;
                uwAsset = getAssetInfoFromLinkPost(feedItem, uwAsset);
            }
        } else if (feedComment != null) {
            if (feedComment.CommentType == 'ContentComment')
            {
                // uwAsset.URL_of_Asset__c = feedItem.relatedrecordid;
                uwAsset = getAssetInfoFromContentPost(isFeed, feedItem, feedComment, uwAsset);
            }               
        }
        
        // uwAsset.Name = name;
        // TODO: feedComment
        if(feedItem != null)
        {
            if (!uw_HelperMethods.valueIsNull(feedItem.Title))
            {
                uwAsset.Name = feedItem.Title;
            }
        } else if (feedComment != null) {
            // should have already been set in getAssetInfoFromContentPost
            if (uw_HelperMethods.valueIsNull(uwAsset.Name)) {
                uwAsset.Name = 'Added by comment';
            }                           
        }
        
        if(uwAsset != null)
        {
            if (uw_HelperMethods.valueIsNull(uwAsset.Name))
            {
                uwAsset.Name = 'New Asset Name';
            }
        
            if (uwAsset.Name.length() > 80)
            {
                uwAsset.Name = uwAsset.Name.substring(0,79);
            }
            
        }
        
        if (isFeed) {
            uwAsset.Related_Feed_Item__c = feedItemId;
            uwAsset.Related_Feed_Comment__c = null;
        }
        else {
            uwAsset.Related_Feed_Comment__c = feedCommentId;
            uwAsset.Related_Feed_Item__c = null;
        }
        uwAsset.Media_Type__c = mediaType;
        
        if(feedItem != null)
        {
            uwAsset.Description__c= feedItem.body;
        } else if (feedComment != null) {
            uwAsset.Description__c = feedComment.CommentBody;
        }
        
        uwAsset.thumbnail__c = thumb;  
         
         try
         {
            if (uw_HelperMethods.valueIsNull(uwAsset.Id))
            {
                // If asset id is null - need to fill in md realationship value
               uwAsset.uw_BET__c = getBetId();
            }
         }
          catch(Exception ex)
        {
            system.debug('Error in assigning uwAsset.uw_BET__c; Exception: ' + ex);
        }
        system.debug('initializeAssetFromFeedItem: exit: asset: '+uwAsset);
    }
    private uw_Asset__c getAssetInfoFromLinkPost(CollaborationGroupFeed feedItem, uw_Asset__c asset)
    //public uw_Asset__c getAssetInfoFromLinkPost(CollaborationGroupFeed feedItem, uw_Asset__c asset)
    {   
        if (feedItem.LinkURL.contains ('sharepoint')) 
        {
                asset.Location_Type__c = 'Sharepoint';
                asset.URL_of_Asset__c = feedItem.LinkURL;
         }
         else if (feedItem.LinkURL.contains ('box.com')) 
         {
                asset.Location_Type__c = 'BOX';
                asset.URL_of_Asset__c = feedItem.LinkURL;
         }
         else if (feedItem.LinkURL.contains ('jwplayer')) 
         {
                asset.Location_Type__c = 'jwplayer';
                asset.URL_of_Asset__c = feedItem.LinkURL;
         }  
         else  if (feedItem.LinkURL.toLowerCase().contains ('youtube')) 
         {
                asset.Location_Type__c = 'Youtube';
                String videoId = uw_HelperMethods.parseYouTubeVideoIdPr(feedItem.LinkURL);
                
                if (uw_HelperMethods.valueIsNull(videoId))
                {
                        asset.URL_of_Asset__c = feedItem.LinkURL;
                }
                else
                {
                        String embed = 'https://www.youtube.com/embed/'+videoId +'?feature=player_detailpage&showinfo=0&wmode=transparent';
                        asset.URL_of_Asset__c = embed;
                        asset.thumbnail__c =  'https://i.ytimg.com/vi/' + videoId + '/default.jpg';
                }
         }
         else if (feedItem.LinkURL.contains ('vimeo.com')) 
         {
            asset.Location_Type__c = 'Vimeo';
            asset.thumbnail__c =  'http://cdn.slashgear.com/wp-content/uploads/2012/04/vimeo.jpg';
            
            String videoId = uw_HelperMethods.parseVimeoVideoIdPR(feedItem.LinkURL);
            if (uw_HelperMethods.valueIsNull(videoId))
            {
                asset.URL_of_Asset__c = feedItem.LinkURL;
            }
            else
            {
                asset.URL_of_Asset__c = 'https://player.vimeo.com/video/'+videoId;
            }
         }
         else
         {
            asset.Location_Type__c = 'Unknown';
            asset.URL_of_Asset__c = feedItem.LinkURL;
            asset.thumbnail__c = feedItem.LinkURL;
        }
        
        return asset;
    }
    private uw_Asset__c getAssetInfoFromContentPost(Boolean isFeed, CollaborationGroupFeed feedItem, FeedComment feedComment, uw_Asset__c asset)
    //public uw_Asset__c getAssetInfoFromContentPost(Boolean isFeed, CollaborationGroupFeed feedItem, FeedComment feedComment, uw_Asset__c asset)
    {
        // TODO - these shoudl be put in custom settings....
        List<String> jwPlayerVideoFiles = uw_Constants.getJwPlayerVideoFileExtensions();
        
        List<String> jwPlayerAudioFiles = uw_Constants.getJwPlayerAudioFileExtensions();
        
        List<String> chatterTypeFiles = uw_Constants.getChatterTypeFileExtensions();
        
        asset.Location_Type__c = 'other';
        uwAsset.URL_of_Asset__c = (isFeed) ? feedItem.RelatedRecordId : feedComment.RelatedRecordId;
                
        String fileName;
        
        if (isFeed) {
            fileName = feedItem.ContentFileName;
        } else {
            // TODO feedComment
            List<ContentVersion> cvList = [SELECT PathOnClient FROM ContentVersion WHERE id=:feedComment.RelatedRecordId];
            if (!uw_HelperMethods.listIsNull(cvList)) {
                fileName = cvList[0].PathOnClient;
            } else fileName = feedComment.CommentBody.subString(0,64);
            asset.Name = fileName;
        }     
                
        if (!uw_HelperMethods.valueIsNull(fileName))
        {
            for (String fileExt : jwPlayerAudioFiles)
            {
                if (fileName.toLowerCase().endsWith(fileExt))
                {
                        asset.Location_Type__c = 'jwplayeraudio';
                        return asset;
                }
            }
            
            for (String fileExt : jwPlayerVideoFiles)
            {
                if (fileName.toLowerCase().endsWith(fileExt))
                {
                    asset.Location_Type__c = 'jwplayervideo';
                    return asset;
                }
            }
            
            for (String fileExt : chatterTypeFiles)
            {
                if (fileName.toLowerCase().endsWith(fileExt))
                {
                    asset.Location_Type__c = 'Chatter';
                    return asset;
                }
            }
        }
            
        //if  (uw_HelperMethods.valueIsNull(asset.Media_Type__c)) {     //kj: added 6/10
        //      mediaType='Chatter';
        //}
        return asset;
    }
    
    public Boolean getIsSaveSuccessful()
    {
        return saveSuccessful;
    }
        
    public Boolean getIsCreateMode()
    {
        return isCreateMode;
    }
    
    public uw_BET__c getBet()
    {
        return bet;
    }
    
    public String getBetId()
    {
        if (isCreateMode)
        {
                return Apexpages.currentPage().getParameters().get('betid');
        }
        else
        {
                if (bet != null)
                {
                        return bet.Id;
                }
        }
        
        return null;
    }
    
    public  uw_Asset__c getAsset()
    {
        return uwAsset;         
    }
    
    public  void setAsset(uw_Asset__c a)
    {
        uwAsset = a;
    }
    
    public List<SelectOption> getStudioAssetTypeItems()
    {
        List<SelectOption> studioAssetTypeItems = new List<SelectOption>();
        studioAssetTypeItems.add(new SelectOption(STUDIO_ASSET_TYPE_PRESO,STUDIO_ASSET_TYPE_PRESO));
        studioAssetTypeItems.add(new SelectOption(STUDIO_ASSET_TYPE_CREATIVE_W,STUDIO_ASSET_TYPE_CREATIVE_W));
        studioAssetTypeItems.add(new SelectOption(STUDIO_ASSET_TYPE_DOC,STUDIO_ASSET_TYPE_DOC));
        return studioAssetTypeItems;
    }
    
    public List<SelectOption> getYesNoItems()
    {
        List<SelectOption> studioAssetTypeItems = new List<SelectOption>();
        studioAssetTypeItems.add(new SelectOption('','Please Select'));
        studioAssetTypeItems.add(new SelectOption('Yes','Yes'));
        studioAssetTypeItems.add(new SelectOption('No','No'));
        
        return studioAssetTypeItems;
    }
    
    public List<SelectOption> getStatusItems()
    {
        List<SelectOption> statusItems = new List<SelectOption>();
        statusItems.add(new SelectOption(ASSET_STATUS_WIP,ASSET_STATUS_WIP));
        statusItems.add(new SelectOption(ASSET_STATUS_FINAL,ASSET_STATUS_FINAL));
        
        return statusItems;
    }
    
    public String getLevel1CategoryFromLevel3()
    {
        try
        {
            Map<String,String> Level1CategoryMap = uw_Constants.getAssetCategorisationLevel3ToLevel1Map();
            
            if (!uw_HelperMethods.valueIsNull(uwAsset.Categorisation_3__c))
            {
                return Level1CategoryMap.get(uwAsset.Categorisation_3__c);
            }   
        }
        catch(Exception ex)
        {
            system.debug('Error from the method getLevel1CategoryFromLevel3; Error: ' + ex);
        }
        
        return '';
    }
    
    public String getToolkitSectionMessage()
    {
        try
        {
            Map<String,String> toolkitSectionMap = uw_Constants.getAssetCategorisationLevel3ToLevel2Map();
            
            if (!uw_HelperMethods.valueIsNull(uwAsset.Categorisation_3__c))
            {
                return toolkitSectionMap.get(uwAsset.Categorisation_3__c);
            }
            
            
        }
        catch (Exception ex)
        {
            system.debug('Error from the method getToolkitSectionMessage; Error: ' + ex);
        }
        
        return '';
    }
    
    public String getLocalisationMessage()
    {
        try
        {
            Map<String,String> localisationMessage = uw_Constants.getAssetLocalizationMessageMap();
         
            if (!uw_HelperMethods.valueIsNull(uwAsset.Localisation_Requirement__c))
            {
                    return localisationMessage.get(uwAsset.Localisation_Requirement__c);
            }
            
        }
        catch (Exception ex)
        {
            system.debug('Error from the method getLocalisationMessage; Error: ' + ex);     
        }
        
        return '';
    }
    
    public List<SelectOption> getMediaChannelItems()
    {
        if (mediaChannelItems == null)
        {
                mediaChannelItems = new List<SelectOption>();
        
                mediaChannelItems.add(new SelectOption('','Please Select Media Channel'));
                uw_Asset__c descObj = new uw_Asset__c();
                Sobject sObj = (Sobject)descObj;
                
                mediaChannelItems.addAll(uw_HelperMethods.getPickListValues(sObj, 'Media_Channel_1__c'));
                
                Boolean containsOther = false;
                for (SelectOption so: mediaChannelItems)
                {
                    if (so.getLabel() == 'Other')
                    {
                        containsOther = true;
                    }
                }
                
                if (!containsOther)
                {
                    mediaChannelItems.add(new SelectOption('Other','Other'));
                }
        }
        
        return mediaChannelItems;       
    }
    
    public List<SelectOption> getLocalisationRequirementTypeItems()
    {
        if (localisationTypeItems == null)
        {
            //added 12/10/2012
            localisationTypeItems = new List<SelectOption>();
            localisationTypeItems.add(new SelectOption('','Please Select Localisation Requirements'));
            ////
            
            uw_Asset__c descObj = new uw_Asset__c();
            Sobject sObj = (Sobject)descObj;
            localisationTypeItems.addAll(uw_HelperMethods.getPickListValues(sObj, 'Localisation_Requirement__c'));
            //localisationTypeItems = uw_HelperMethods.getPickListValues(sObj, 'Localisation_Requirement__c');
        
        }
        
        return localisationTypeItems;
    }
    
    public List<SelectOption> getDocumentTypeItems()
    {
        if (null == documentTypeItems)
        {
                Boolean containsOther = false;
                // TODO - use the helper methods call?
                uw_Asset__c describeAsset = new uw_Asset__c();
                Schema.sObjectType sobjectType = describeAsset.getSObjectType(); //get the sobject Type
                Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe(); //describe the Object
                Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap(); //get a map of fields for the Object
                List<Schema.PicklistEntry> picklistValues = fieldMap.get('Categorisation_3__c').getDescribe().getPickListValues();
                        
                        documentTypeItems = new List<SelectOption>();
                        documentTypeItems.add(new SelectOption('','Please select a document category'));
                        
                        for (Schema.PicklistEntry ple: picklistValues)
                        {
                                documentTypeItems.add(new SelectOption(ple.getValue(), ple.getLabel()));
                                if (ple.getLabel() == 'Other')
                                {
                                        containsOther = true;
                                }       
                        }
                        
                        if (!containsOther)
                {
                        documentTypeItems.add(new SelectOption('Other','Other'));
                }
                }
        
        return documentTypeItems;
    }
    
    private void validateAssetPart1()
    {
        if (uw_HelperMethods.valueIsNull(uwAsset.Name))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a name'));
        }
        
        if (uw_HelperMethods.valueIsNull(uwAsset.Description__c))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a description'));
        }
        
        if (uw_HelperMethods.valueIsNull(uwAsset.Studio_Asset_Type__c))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an asset type'));
        }
    }
      private void validateAssetPart2()
    //public void validateAssetPart2()
    {
        // We have an asset type..
        uwAsset.Big_Think_Pack__c = false;
        if (uwAsset.Studio_Asset_Type__c == STUDIO_ASSET_TYPE_PRESO)
        {
                /*Start- Gayatri ULHD00007465443: Link cannot be labelled as Brand Experience Presenatation.*/          
                System.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  ASSET FEED ITEM ID >>>>>>>>>>>>>>>>>>>>>>>>>>'+uwAsset.Related_Feed_Item__c);                                
                //Retreive the feed item type from the related feed item stored on Asset.
                List<FeedItem> FeedItem_Type=[Select Id,Type from FeedItem where Id = : uwAsset.Related_Feed_Item__c];                  
                System.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  FEED TYPE  >>>>>>>>>>>>>>>>>>>>>>>>>>'+FeedItem_Type[0].Type);
                if(FeedItem_Type[0].Type=='LinkPost')
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot label a Link as Brand Experience Presentation.'));
                    uwAsset.Studio_Asset_Type__c =null; // set it as null so that the BEP related message is not shown in the VF along with the error message.
                }
                else
                {
                /*End - Gayatri ULHD00007465443: Link cannot be labelled as Brand Experience Presenatation.*/
                    uwAsset.Big_Think_Pack__c = true;
                }
        }
        else if (uwAsset.Studio_Asset_Type__c == STUDIO_ASSET_TYPE_DOC)
        {
                // Type of Doc Required
                if (uw_HelperMethods.valueIsNull(uwAsset.Categorisation_3__c))
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a document category'));
                }
                else
                {
                        //uwAsset.Categorisation_2__c = getToolkitSectionMessage();
                        // Bucket fields is the new categorization 1 
                        // uwAsset.Bucket_Fields__c = getToolkitSectionMessage();
                        //uwAsset.Bucket_Fields__c = getLevel1CategoryFromLevel3();
                       
                }
        }
        else if (uwAsset.Studio_Asset_Type__c == STUDIO_ASSET_TYPE_CREATIVE_W)
        {
                // Media Channel - Other 
                if (uw_HelperMethods.valueIsNull(uwAsset.Media_Channel_1__c))
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a media channel'));
                }
                else
                {
                        if (uwAsset.Media_Channel_1__c == 'Other' && uw_HelperMethods.valueIsNull(uwAsset.Other_Media_Channel__c))
                        {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter other media channel'));
                        }
                }
                
                // Localisation requirement
                if (uw_HelperMethods.valueIsNull(uwAsset.Localisation_Requirement__c))
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please indicate the Localisation Requirements'));
                }
        }
        
       
        
        // Status is required for these 2 types
        if (uwAsset.Studio_Asset_Type__c == STUDIO_ASSET_TYPE_CREATIVE_W || uwAsset.Studio_Asset_Type__c == STUDIO_ASSET_TYPE_DOC)
        {
                if (uw_HelperMethods.valueIsNull(uwAsset.Status__c))
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a file status'));
                }
        }
        
        if (uw_HelperMethods.valueIsNull(promoteAssetToToolkit))
        {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please indicate whether or not this file should be moved to the toolkit'));
        }
        else
        {
                if (promoteAssetToToolkit == 'Yes')
                {
                        system.debug('Promoted__c: 1: true');
                        uwAsset.Promoted__c = true;
                        uwAsset.Think_Big_Promotion_Date__c=system.now();   //KJ: added 28/9; need date/time so that toolkit will get latest
                }
                else
                {
                        system.debug('Promoted__c: 2: false');
                        uwAsset.Promoted__c = false;
                }
        }
    }
    private void persistAsset()
    //public void persistAsset()
    {
        try{
                Database.Saveresult result = null;
                if (uw_HelperMethods.valueIsNull(uwAsset.Id))
                {
                        result = Database.insert(uwAsset,false);       
                }
                else
                {
                        result = Database.update(uwAsset,false);
                        if (uwAsset.Promoted__c==true)  {
                        }
                        if (uwAsset.Promoted__c==false) {
                        }
                }
                
                if (!result.isSuccess())
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Saving record '+result.getErrors()[0].getMessage()));
                }
                else
                {
                    // If the asset if promoted - and it is a contentPost with a content version
                    // we need to chatter it to the Bet to share it...
                    // If it is not promoted - it needs to have any chatter feed items on a bet deleted                
                    if (uwAsset.URL_of_Asset__c.startsWith('068'))
                    {
                        // This is a content link    
                       if (uwAsset.Promoted__c)
                       {
                        
                         
                         /* Code added by ACC-IDC-Srilakshmi for Incident ULHD00007290396 -Error in BET Presentation Release Mechanism */
              if(uwAsset.Studio_Asset_Type__c=='Brand Experience Presentation')
             {
                        System.debug('Inside Promoted************');
                         
                                    List<Id> Related_FeedItems_Ids_Group = new List<Id>();
                                    List<Id> Related_RecordIds = new List<Id>();
                                    List<FeedItem> delete_BET_FeedItems = new List<FeedItem>();
                                        List<Id> FeedItems_To_delete = new List<Id>();

                        try{
                                // Fetching all the 'Brand Experience Prsentation' records from the Asset which are promoted to Toolkit
                            
                                List<uw_Asset__c> assetlist = [select url_of_asset__c,Promoted__c, Related_Feed_Item__c, Related_Feed_Comment__c from uw_Asset__c where uw_BET__c=:bet.Id and Studio_Asset_Type__c='Brand Experience Presentation'and Promoted__c=true and Id!=:uwAsset.Id];
                          
                                for(uw_Asset__c a:assetlist)
                                            {
                                                        Related_FeedItems_Ids_Group.add(a.Related_Feed_Item__c);//Storing BET Chatter group FeedItem post Ids in List.
                                                        a.Promoted__c=false;
                                            }
                         
                                            //Fetching the RelatedRecordId[Chatter file] information from the FeedItem
                                List<FeedItem> FeedItemlist_Group=[Select Id,ParentId,RelatedRecordId from FeedItem where Id in:Related_FeedItems_Ids_Group];
                                            for(FeedItem fi:FeedItemlist_Group)
                                            {
                                                        Related_RecordIds.add(fi.RelatedRecordId);
                                            }
                          
                        
                                            //Fetching the BET Chatter posts which are related to the above retrieved chatter files.
                                           
                                            List<FeedItem> FeedItems_BET = uw_FetchFeedItems.fetchFeedOfBet(bet.id);//*****T0********
                                            
                                          
                               // List<FeedItem> FeedItems_BET=[Select Id,ParentId,RelatedRecordId from FeedItem where ParentId=:bet.Id];
                                            for(FeedItem f:FeedItems_BET)
                                             {
                                                        for(Id i:Related_RecordIds)
                                                        {
                                                                     if(f.RelatedRecordId==i)
                                                                    {
                                                                             FeedItems_To_delete.add(f.Id);
                                                                    }
                                                                
                                        }
                                                }
                                            delete_BET_FeedItems=[Select Id from FeedItem where Id in:FeedItems_To_delete];
                         
                                 //Deleting the BET Chatter posts 
               
                                List<Database.DeleteResult> result_delete_FeedItem = null;  
                                result_delete_FeedItem = Database.delete(delete_BET_FeedItems,false); 
                                 System.debug('Result of deleting BET Chatter posts**********'+result_delete_FeedItem);
                        
                                            //Updating asset to bring back the existing promoted 'Brand Experience Presentation 'records back to Studio */ 
               
                                 List<Database.Saveresult> result_update_asset = null;  
                                  result_update_asset = Database.Update(assetlist,false);
                                 System.debug('Result of Updating the assests**********'+result_update_asset); 
               
               
                          
                                             }
                          
 
                    catch(exception e ){} 
                         
                        } 
                         
                         
                        /* Code added by ACC-IDC-Srilakshmi for Incident ULHD00007290396 -Error in BET Presentation Release Mechanism Ends */
                        
                            createBETChatterPostForContent(uwAsset.URL_of_Asset__c);
                       }
                       else
                       {
                            deleteBETChatterPostForContent(uwAsset.URL_of_Asset__c);
                       }
                   }
                }
        } catch (Exception e)
        {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Saving record '+e));
        }
    }
    

    
    
    
    
    
    
    
    
    
     private void createBETChatterPostForContent(String contentVersionId)
    {
        system.debug('createBETChatterPostForContent: contentVersionId: '+ contentVersionId ) ;
        // Check is there one created already
        List<uw_BET__Feed> contentBetFeed = getBetChatterPostsForContent(contentVersionId);
        
        system.debug('createBETChatterPostForContent: contentBetFeed: '+ contentBetFeed ) ;
        
        if (contentBetFeed.size() == 0)
        {
            // No existing feed items - create one...
            FeedItem newFeedItem = new FeedItem();
            newFeedItem.Type = 'ContentPost';
            newFeedItem.RelatedRecordId = getLatestContentVersionId(contentVersionId);
            newFeedItem.ParentId = getBetId(); 
            
            system.debug('createBETChatterPostForContent: newFeedItem: '+newFeedItem);
            insert newFeedItem;         //toodoo
             system.debug('aaaaaaaaaa'+ newFeedItem ) ;
            uw_asset__c updateassetBetFeedID= getAsset();
            updateassetBetFeedID.BetFeedID__c=newFeedItem.id;
            update  updateassetBetFeedID;
             
        }
    }
    
    private void deleteBETChatterPostForContent(String contentVersionId)
    {
        // Find all posts for this version and delete them..
        List<uw_BET__Feed> contentBetFeed = getBetChatterPostsForContent(contentVersionId);
        
        if (contentBetFeed.size() > 0)
        {
            // TODO - expect errors! There are triggers preventing this?
            uw_DeleteObjectsHelper.assetLocked = true;
            delete contentBetFeed;
        }
    }
    
    private List<FeedComment> getBetChatterCommentsForContent() {
        return new List<FeedComment>();
    }
    
    // We start with a ContentVersionId
    // 1. Get the CV for that Id
    // 2. 
    private List<uw_BET__Feed> getBetChatterPostsForContent(String contentVersionId)
    {
        List<uw_BET__Feed> contentBetFeed = new List<uw_BET__Feed>();
        List<ContentVersion> cVersionsTest = [Select OwnerId, Id, ContentDocumentId From ContentVersion where id =:contentVersionId];
        
        if (cVersionsTest.size() == 0)
        {
            return contentBetFeed;
        }
        
        ContentVersion cVersion = [Select OwnerId, Id, ContentDocumentId From ContentVersion where id =:contentVersionId];
        
        ContentDocument cDoc = [Select OwnerId, Id From ContentDocument where Id = : cVersion.ContentDocumentId];
        
        List<ContentVersion> cVersions = [Select OwnerId, Id, ContentDocumentId From ContentVersion where ContentDocumentId = :cDoc.Id];
        
        Set<Id> allContentVersionIds = new Set<Id>();
        for (ContentVersion cv: cVersions)
        {
            allContentVersionIds.add(cv.id);
        }
        
        List<uw_BET__Feed> allBetFeed = [Select Type, RelatedRecordId, ParentId From uw_BET__Feed where ParentId =:getBetId() AND Type = 'ContentPost'];
        
        // RelatedRecordId Cannot be filtered in a query call!! 
        // Have to do this manually
        
        
        for (uw_BET__Feed feedItem: allBetFeed)
        {
           // if (uw_HelperMethods.idsAreEqual(feedItem.RelatedRecordId, contentVersionId))
           if (allContentVersionIds.contains(feedItem.RelatedRecordId))
           {
               contentBetFeed.add(feedItem);
           }
        }
        
        return contentBetFeed;
    }
    
    private String getLatestContentVersionId(String contentVersionId)
    {
        ContentVersion cv = [Select Id, ContentDocumentId from ContentVersion where Id =: contentVersionId];
        
        ContentDocument cDoc = [SELECT Id, LatestPublishedVersionId FROM ContentDocument WHERE Id =: cv.ContentDocumentId];
        
        return cDoc.LatestPublishedVersionId;
    }
    
    public PageReference saveChanges()
    {   
        system.debug('saveChanges: entry');
        saveSuccessful = false;
        // Check required fields

        system.debug('validateAssetPart1:');
        validateAssetPart1();
        
        if (ApexPages.hasMessages())
        {
                return null;
        }
        
        system.debug('validateAssetPart2:');
        validateAssetPart2();
        
        system.debug('hasMessages: 1');
        if (ApexPages.hasMessages())
        {
            return null;
        }
        
        system.debug('persistAsset:');
        persistAsset();
        
        system.debug('hasMessages: 2');
        if (ApexPages.hasMessages())
        {
            return null;
        }
        
        saveSuccessful = true;
        
        system.debug('saveChanges: exit');
        return null;
    }
    
    public PageReference cancel()
    {
        // Is there a button for this?
        return null;    
    }
    
    private static final String PPTX_EXTENSION = '.pptx';
    public Boolean isPPTXFile {get; private set;}
    private Boolean checkPPTXFile(ContentVersion cv) {
        isPPTXFile = cv.PathOnClient.endsWithIgnoreCase(PPTX_EXTENSION);
        system.debug('isPPTXFile: '+cv.PathOnClient+' :'+isPPTXFile);
        return isPPTXFile;
    }
    
    private static final Integer SIZE_25MB = 1024 * 1024 * 25;
    private static final Integer SIZE_50KB = 1024 * 50;
    public Boolean isFileOver25MB {get; private set;}
    public Boolean checkFileOver25MB(ContentVersion cv) {
        isFileOver25MB = (cv.ContentSize >= SIZE_25MB);
        system.debug('isFileOver25MB: '+cv.ContentSize+' :'+isFileOver25MB);
        return isFileOver25MB;
    }
    
    public PageReference fileTypeRadioButtonClick() {
        system.debug('fileTypeRadioButtonClick: call');

        if (null != uwAsset) {
            if (uwAsset.Studio_Asset_Type__c == 'Brand Experience Presentation') {
                List<ContentVersion> cvList = [SELECT Id,pathOnClient,ContentSize FROM ContentVersion WHERE Id =:uwAsset.URL_of_Asset__c];
                if (!uw_HelperMethods.listIsNull(cvList)) {
                    checkPPTXFile(cvList[0]);
                    checkFileOver25MB(cvList[0]);               
                }               
            }
        }


        return null;
    }
    @isTest
    public static void testControllerExistingAsset()
    {
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();
        insert brand;
        
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        
        uw_BET__c bet = uw_UnitTestDataFactory.createBet(brand, 'Test Bet'+Math.random(),inoPlanProject);
        
        insert bet;
        
        uw_BET__c testBet = [Select id, Name, Studio_Chatter_Group__c from uw_BET__c where Id = :bet.Id];
        
        // Create A group member
        User internalUser = uw_UnitTestDataFactory.initInternalUser('Alia', 'internal@unilevertest.com', 'Test User', 'internal@unilevertest.com');
        CollaborationGroupMember groupMember = new CollaborationGroupMember();
        groupMember.CollaborationGroupId  = testBet.Studio_Chatter_Group__c;
        groupMember.MemberId = internalUser.Id;
        
        insert groupMember;
        
        //Adding a Content post
        Blob b =Blob.valueOf('This is great doing.');
        FeedItem contentPost = new FeedItem();
        contentPost.ParentId = testBet.Studio_Chatter_Group__c;
        contentPost.Body = 'This is a test content post';
        contentPost.ContentData = b;
        contentPost.ContentFileName = 'sample.pdf';
        contentPost.Type='ContentPost';
        contentPost.CreatedById = internalUser.Id;
        insert contentPost;
        
        // Create 2 feed posts
        FeedItem feedLinkPost = new FeedItem();
        feedLinkPost.parentId = testBet.Studio_Chatter_Group__c;
        feedLinkPost.Type = 'LinkPost';
        feedLinkPost.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
        feedLinkPost.Title   = 'Test Title';
        feedLinkPost.Body    = 'Test Body';
        feedLinkPost.CreatedById = internalUser.Id;
        insert feedLinkPost;
        
        List<String> testLinks = new List<String>();
        testLinks.add('http://www.youtube.com/watch?v=cA5ifsMo194');
        testLinks.add('http://internal.sharepoint.unilever.com/spdoc');
        testLinks.add('http://uni.box.com/bdoc');
        testLinks.add('http://uni.jwplayer.com/jpdoc');
        testLinks.add('http://www.vimeo.com/1234568');
        testLinks.add('http://www.ireland.com/galway');
        
        
        List<FeedItem> feedItemLinkPosts = new List<FeedItem>();
        
        for (String l : testLinks)
        {
            FeedItem testFeedLinkPost = new FeedItem();
            testFeedLinkPost.parentId = testBet.Studio_Chatter_Group__c;
            testFeedLinkPost.Type = 'LinkPost';
            testFeedLinkPost.LinkUrl = l;
            testFeedLinkPost.Title   = 'Test Title';
            testFeedLinkPost.Body    = 'Test Body';
            feedItemLinkPosts.add(testFeedLinkPost);
        }
        
        insert feedItemLinkPosts;
        
        uw_Asset__c linkPostAsset = new uw_Asset__c();
        linkPostAsset.Name = 'Test Asset';
        linkPostAsset.uw_BET__c = testBet.Id;
        linkPostAsset.URL_of_Asset__c = feedLinkPost.LinkUrl;
        linkPostAsset.Studio_Asset_Type__c = 'Creative Work';
        linkPostAsset.Media_Channel_1__c = 'Online Video';
        linkPostAsset.Promoted__c = true; 
        linkPostAsset.Location_Type__c = 'youtube';
        linkPostAsset.Related_Feed_Item__c = feedLinkPost.Id;
       // linkPostAsset.Best_Practice__c = true;
        linkPostAsset.Big_Think_Pack__c = false;
        insert linkPostAsset;
        
        
        uw_ModifyAssetController controller = new uw_ModifyAssetController(new ApexPages.Standardcontroller(linkPostAsset));
        
        ApexPages.currentPage().getParameters().put('feedItemId',feedLinkPost.Id);
        ApexPages.currentPage().getParameters().put('MediaType','Vid');
        ApexPages.currentPage().getParameters().put('thumb','thumb');
        ApexPages.currentPage().getParameters().put('betid',bet.Id);
        
        controller.initializeAssetFromFeedItem();
        
        ApexPages.currentPage().getParameters().put('feedItemId',feedItemLinkPosts[0].Id);
        controller = new uw_ModifyAssetController(new ApexPages.Standardcontroller(new uw_Asset__c()));
        controller.initializeAssetFromFeedItem();
        
        controller.saveChanges();
        
        List<CollaborationGroupFeed> groupFeed = [select Id, CommentCount, Type, LinkURL, title, body, ContentFileName, ContentDescription, relatedrecordid from CollaborationGroupFeed 
        where Type IN ('ContentPost', 'LinkPost') AND  ParentID  = : testBet.Studio_Chatter_Group__c];
        
        feedComment feedCommTest = new feedComment();
        feedCommTest.CommentBody = 'Test Feed comment :test the method getAssetInfoFromContentPost with false condition';
        feedCommTest.CommentType ='TextComment';
        feedCommTest.FeedItemId =feedLinkPost.id;
        insert feedCommTest;
         
        for (CollaborationGroupFeed cgf: groupFeed)
        {
            if(cgf.Type=='LinkPost')
                controller.getAssetInfoFromLinkPost(cgf,new uw_Asset__c());
            if(cgf.Type=='ContentPost')
                controller.getAssetInfoFromContentPost(true, cgf, null, new uw_Asset__c());
                controller.getAssetInfoFromContentPost(false, cgf, feedCommTest, new uw_Asset__c());
        }
        
        controller.getIsSaveSuccessful();
        
        controller.getIsCreateMode();
        
        controller.getBet();
            
        controller.getBetId();
        
        controller.setAsset(controller.getAsset());
            
        controller.getStudioAssetTypeItems();
           
        controller.getYesNoItems();
            
        controller.getStatusItems();
            
        controller.getLevel1CategoryFromLevel3();
        controller.getToolkitSectionMessage();
        
        uw_Asset__c testAsset = controller.getAsset();
        testAsset.Categorisation_3__c = 'Test';
        controller.setAsset(testAsset);
        
        controller.getLevel1CategoryFromLevel3();
        controller.getToolkitSectionMessage();
            
        controller.getLocalisationMessage();
        
        testAsset.Localisation_Requirement__c = 'Test';
        controller.setAsset(testAsset);
        controller.getLocalisationMessage();
            
        // controller.getMediaChannelItemsOrig();
            
        controller.getMediaChannelItems();
           
        controller.getLocalisationRequirementTypeItems();
            
        controller.getDocumentTypeItems();
            
        controller.cancel();
        
        
        // Save Changes Tests
        testAsset.Name = '';
        testAsset.Description__c = '';
        testAsset.Studio_Asset_Type__c = '';
        controller.setAsset(testAsset);
        
        
        controller.saveChanges();
        
               
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL='http://www.google.com/';
        contentVersionObj.Title = 'Google.com';            
        insert contentVersionObj;
        controller.getBetChatterPostsForContent(contentVersionObj.id);
        controller.deleteBETChatterPostForContent(contentVersionObj.id);
        List<FeedComment> feedComments=controller.getBetChatterCommentsForContent();
        //controller.checkPPTXFile(contentVersionObj);
        controller.checkFileOver25MB(contentVersionObj);
        controller.getLatestContentVersionId(contentVersionObj.id);
        //controller.createBETChatterPostForContent(contentVersionObj.id);
        
    }
    @isTest(seeAllData=true)
    public static void testSaveChanges()
    {
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();
        insert brand;
        
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;                 
        
        uw_BET__c bet = uw_UnitTestDataFactory.createBet(brand, 'Test Bet'+Math.random(),inoPlanProject);        
        insert bet;
        
        ApexPages.currentPage().getParameters().put('betid',bet.Id);
        uw_Asset__c testAsset = new uw_Asset__c();
        testAsset.Name = 'Test';
        testAsset.uw_BET__c = bet.Id;
        insert testAsset;
        
        
        uw_Asset__c testAsset2 = new uw_Asset__c();
        testAsset2.Name = 'Test2';
        testAsset2.uw_BET__c = bet.Id;
        insert testAsset2;
        
        uw_ModifyAssetController controller = new uw_ModifyAssetController(new ApexPages.Standardcontroller(testAsset));
                
        FeedItem feedLinkPost = new FeedItem();
        feedLinkPost.parentId = bet.id;
        feedLinkPost.Type = 'LinkPost';
        feedLinkPost.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
        feedLinkPost.Title   = 'Test Title';
        feedLinkPost.Body    = 'Test Body';
        //feedLinkPost.CreatedById = internalUser.Id;
        insert feedLinkPost;
        
        uw_Asset__c linkPostAsset = new uw_Asset__c();
        linkPostAsset.Name = 'Test Asset';
        linkPostAsset.uw_BET__c = bet.Id;
        linkPostAsset.URL_of_Asset__c = feedLinkPost.LinkUrl;
        linkPostAsset.Studio_Asset_Type__c = uw_ModifyAssetController.STUDIO_ASSET_TYPE_PRESO;
        //linkPostAsset.Media_Channel_1__c = 'Online Video';
        linkPostAsset.Promoted__c = true; 
        linkPostAsset.Location_Type__c = 'youtube';
        linkPostAsset.Related_Feed_Item__c = feedLinkPost.Id;
       // linkPostAsset.Best_Practice__c = true;
        //linkPostAsset.Big_Think_Pack__c = false;
        insert linkPostAsset;
        
        //testAsset2.Description__c = 'DescBrandExperience';
        //testAsset2.Studio_Asset_Type__c = uw_ModifyAssetController.STUDIO_ASSET_TYPE_PRESO;
        //controller.setAsset(testAsset2); 
        
        controller.setAsset(linkPostAsset);        
        controller.validateAssetPart2();
        
        testAsset.Name = 'Name';
        testAsset.Description__c = 'Desc';
        testAsset.Studio_Asset_Type__c = uw_ModifyAssetController.STUDIO_ASSET_TYPE_DOC;
        controller.setAsset(testAsset);
        controller.validateAssetPart2();
        
        testAsset.Categorisation_3__c = 'Other';
        controller.setAsset(testAsset);
        controller.validateAssetPart2();
        
        testAsset.Studio_Asset_Type__c = uw_ModifyAssetController.STUDIO_ASSET_TYPE_CREATIVE_W;
        controller.setAsset(testAsset);
        controller.validateAssetPart2();
        
        testAsset.Media_Channel_1__c = 'Other';
        controller.setAsset(testAsset);
        controller.validateAssetPart2();
        
        testAsset.URL_of_Asset__c ='068testlink';
        testAsset.Promoted__c= true;
        controller.persistAsset();
        
        
        testAsset.Studio_Asset_Type__c = uw_ModifyAssetController.STUDIO_ASSET_TYPE_PRESO;
        controller.persistAsset();
        
        controller.saveChanges();
        controller.fileTypeRadioButtonClick();
    }

}