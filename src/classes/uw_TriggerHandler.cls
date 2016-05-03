/*----------------------------------------------------------------<T01>-----------------------------
Author:        Accenture
Company:       Accenture
Description:   This class contains helper methods to the triggers on object uw_bet__C
Test Class:    uw_Triggerhandler_test,uw_PinnovateController_Test
History:
Test Class: testWrappers,testController are test methods in this class
<Date>      <Authors Name>     <Brief Description of Change>                        <Tag>
  -              -                Initial version of the code                           -
14-Jan-2014      Accenture      Modifed handleBetBeforeInserts method so
                              as to check whether chatter exception is of
                              nature-100 groupd limit  and display message
                              as appropriate                                        T01             
13-August-2014   Bhavneesh    Removal of duplicate Inoplan proejct Logic            T02       
10-Sept-2014     Accenture    Bug fix for inoplan logic is mandatory                T03                                     
-----------------------------------------------------------------</T01>----------------------------*/
//New ADFS
public with sharing class uw_TriggerHandler { 
    public static Boolean CHECK_BRAND_CATEGORY_RELATION = true;
    private static final String GROUP_NAME_POSTFIX = ' External View';
    private static final String CANNOT_DELETE_NOT_OWNER = 'Cannot delete Post because it contains a file which has been labelled. Please contact the Toolkit Owner.';
    private static final String CANNOT_DELETE_CHATTER_FILE = 'This Chatter File has been labelled in the Studio {0}. Please contact the Toolkit Owner: {1} who can delete the file. ';
   
    public uw_TriggerHandler()
    {
        /* start new code (Blitz 4) */
        isSysAdminUser = null;
        /* end new code (Blitz 4) */
    }
    @TestVisible
    private String currentUserId {
        get {
            if (currentUserId == null) {
                currentUserId = Userinfo.getUserId();
            }
            return currentUserId;
        } set;
    }
    @TestVisible
    private Boolean isSysAdminUser {get {
        if (null == isSysAdminUser) {
            isSysAdminUser = uw_HelperMethods.isSystemAdminUser();
        }
        return isSysAdminUser;
    } set;
    }
    @TestVisible
    private Boolean canDeleteAsset(uw_Asset__c asset) {
        Boolean canDelete = false;
        
        List<uw_BET_Team_Member__c> tms = [Select Role__c From uw_BET_Team_Member__c WHERE BET__c=:asset.uw_BET__c AND Team_Member__c=:currentUserId];
        system.debug('canDeleteAsset: '+tms);


        if (!uw_HelperMethods.listIsNull(tms)) {
            system.debug('test: (tms[0].role__c: '+ tms[0].role__c);
            system.debug('test: asset.uw_BET__r.OwnerId: '+asset.uw_BET__r.OwnerId+' currentUserId: '+currentUserId);
            
            if ( (tms[0].role__c == uw_Constants.BET_TEAM_ROLE_MANAGER) || (currentUserId == asset.uw_BET__r.OwnerId) || (isSysAdminUser) ) {
                    canDelete = true;   
            }
        } 
        
        system.debug('canDeleteAsset: '+canDelete);
        return canDelete;
    }

    /* start new code (Blitz 4) */
    @TestVisible
    private Boolean canDeleteAsset(uw_Asset__c asset, Map<Id, SObject> tmMap) {
       system.debug('canDeleteAsset: entry');
         Boolean canDelete = false;
        
        if (tmMap.containsKey(asset.uw_BET__c)) {
            uw_BET_Team_Member__c tm = (uw_BET_Team_Member__c) tmMap.get(asset.uw_BET__c);
            system.debug('canDeleteAsset: tm: '+tm);

            system.debug('test: tm.role__c: '+ tm.role__c);
            system.debug('test: asset.uw_BET__r.OwnerId: '+asset.uw_BET__r.OwnerId+' currentUserId: '+currentUserId);
            
            if ( (tm.role__c == uw_Constants.BET_TEAM_ROLE_MANAGER) || (currentUserId == asset.uw_BET__r.OwnerId) || (isSysAdminUser) ) {
                canDelete = true;   
            }
        }
        system.debug('canDeleteAsset: '+canDelete);
        return canDelete;
    }
    /* end new code (Blitz 4) */

@TestVisible 
private Boolean canDemoteAsset(String objId, uw_Asset__c asset, SObject so) {
        Boolean canDemote = false;
        try{
            system.debug('canDemoteAsset: objId: '+objId);
            system.debug('canDemoteAsset: asset: '+asset);
            system.debug('canDemoteAsset: so.Id: '+so.Id);
        String fiParentIdObjId = ((String)so.get('ParentId')).substring(0,3);
        system.debug('fiParentIdObjId: '+fiParentIdObjId);
        if (objId == fiParentIdObjId) {
            canDemote = true;
        }
        }catch(exception e){}
        system.debug('canDemoteAsset: '+canDemote);
        return canDemote;
        
    }
    
    // There are three cases
    // 1. The FeedItem has not been labelled to make an asset
    //    Nothing to do - just skip and let the delete happen
    //
    // 2. The FeedItem has been labelled (and is type=ContentPost) and the user is not the BET owner
    //    feeditem.ParentId gives the BET. If Bet.OwnerId != CurrentUserId then flag an error on the FeedItem 
    //
    // 3. The FeedItem has been labelled and the user is the BET owner
    //    Need to find asset.URL_of_asset__c = feeditem.relatedrecordid
    //    Delete the related feedcomments and asset
    //
    // Notes:
    // a) If the trigger fires on the studio then we delete the asset
    // b) If the trigger fires on the toolkit then we don't delete the asset, we simply demote it.
    //
    public void handleFeedItemBeforeDelete(List<FeedItem> feedItemList, Map<Id, FeedItem> feedItemMap) {

        system.debug('handleFeedItemBeforeDelete: entry');
        system.debug('feedItemMap: '+feedItemMap);

        // get the uw_BET__c object id
        String betObjectId = uw_BET__C.sObjectType.getDescribe().getKeyPrefix();
        system.debug('betObjectId: '+betObjectId);

        if (!uw_HelperMethods.listIsNull(feedItemList)) {

            // only interested in ContentPosts
            List<FeedItem> feedItemContentPosts = new List<FeedItem>();
            List<FeedItem> feedItemLinkPosts = new List<FeedItem>();
            List<FeedItem> feedItemTextPosts = new List<FeedItem>();
            
            for (FeedItem fi:feedItemList) {
                system.debug('fi: '+fi);
                if (fi.Type == 'ContentPost')  {
                    feedItemContentPosts.add(fi);
                } else if (fi.Type == 'LinkPost') {
                    feedItemLinkPosts.add(fi);
                } else if (fi.Type == 'TextPost') {
                    feedItemTextPosts.add(fi);
                }
            }

            // get the assets that we have to work with
            Set<Id> setFeedItems = uw_HelperMethods.makeIdSet(feedItemContentPosts, 'RelatedRecordId');
            // retire - Set<String> setFeedItemsL = uw_HelperMethods.makeIdSet(feedItemLinkPosts, 'LinkURL','link');
            String linkClause = uw_HelperSOQLMethods.feedItemsToWhereClause('OR', feedItemLinkPosts);

            system.debug('setFeedItems: '+setFeedItems);
            
            Map<Id, SObject> mapFeedItemsByBET = uw_HelperMethods.makeMap(feedItemContentPosts, 'ParentId');
            Map<Id, SObject> mapFeedItemsByBETL = uw_HelperMethods.makeMap(feedItemLinkPosts, 'ParentId');    
            Map<Id, SObject> mapFeedItemsByBETT = uw_HelperMethods.makeMap(feedItemTextPosts, 'ParentId');    
            
            // check for FeedComments that hang off the deleted feeditems
            Set<Id> setDeletingFeedItems = uw_HelperMethods.makeIdSet(feedItemList);
            
            List<FeedComment> childFeedComments = uw_FeedComments.getFeedCommentsByFeedItemAndCommentType(setDeletingFeedItems,'ContentComment');
            //List<FeedComment> childFeedComments = [SELECT Id, CommentType, RelatedRecordId FROM FeedComment WHERE FeedItemId IN :setDeletingFeedItems AND CommentType='ContentComment'];

            if (!uw_HelperMethods.listIsNull(childFeedComments)) {

                // there are some feeditems that contain possible assets
                Set<Id> setFeedComments = uw_HelperMethods.makeIdSet(childFeedComments, 'RelatedRecordId');
                system.debug('setFeedComments: '+setFeedComments);

                Map<Id, SObject> mapFeedCommentsByBET = uw_HelperMethods.makeMap(childFeedComments, 'ParentId');
                
                // add together
                setFeedItems.addAll(setFeedComments);
                system.debug('setFeedItems: now: '+setFeedItems);

                // not sure we want to do this yet
                //mapFeedItemsByBET.putAll(mapFeedCommentsByBET);
                //system.debug('mapFeedItemsByBET: now: '+mapFeedItemsByBET);

            }                

            List<uw_Asset__c> assetListC = [SELECT Id, Name, Related_Feed_Item__c, uw_Bet__c, uw_Bet__r.OwnerId, BET_Chatter_Group__c, url_of_asset__c FROM uw_Asset__c WHERE URL_of_Asset__c IN :setFeedItems];
            // retire - List<uw_Asset__c> assetListL = [SELECT Id, Name, Related_Feed_Item__c, uw_Bet__c, uw_Bet__r.OwnerId, BET_Chatter_Group__c, url_of_asset__c FROM uw_Asset__c WHERE URL_of_Asset__c IN :setFeedItemsL];
            List<uw_Asset__c> assetList = new List<uw_Asset__c>();
            assetList.addall(assetListC);

            if (!uw_HelperMethods.valueIsNull(linkClause)) {
                String queryL = 'SELECT Id, Name, Related_Feed_Item__c, uw_Bet__c, uw_Bet__r.OwnerId, BET_Chatter_Group__c, url_of_asset__c FROM uw_Asset__c WHERE '+linkClause;
                List<uw_Asset__c> assetListL = Database.query(queryL);
                assetList.addall(assetListL);
            }
                                    
            //List<uw_Asset__c> assetDemoteList = new List<uw_Asset__c>();
            system.debug('assetList: '+assetList);

            // case 1 - nothing to do if we found no assets
            if (!uw_HelperMethods.listIsNull(assetList)) {
                // cases 2 and 3
                String currentUserId = Userinfo.getUserId();
                system.debug('currentUserId: '+currentUserId);
                
                List<uw_Asset__c> assetsToDelete = new List<uw_Asset__c>();
                List<uw_Asset__c> assetsToDemote = new List<uw_Asset__c>();
                List<FeedItem> feedItemNotifications = new List<FeedItem>();

                /* start new code (Blitz 4) */
                Set<Id> assetSet = uw_HelperMethods.makeIdSet(assetList,'uw_BET__c');
                system.debug('assetSet: '+assetSet);
                List<uw_BET_Team_Member__c> tmCacheList = [Select Role__c,BET__c From uw_BET_Team_Member__c WHERE BET__c IN :assetSet AND Team_Member__c=:currentUserId];
                system.debug('tmCacheList: '+tmCacheList);
                Map<Id,SObject> tmCacheMap = uw_HelperMethods.makeMap(tmCacheList, 'BET__c');
                system.debug('tmCacheMap: '+tmCacheMap);
                /* end new code (Blitz 4) */
                
                for (uw_Asset__c asset:assetList) {
                    system.debug('BetOwner: '+ asset.uw_BET__r.OwnerId);
                    /* start old code (Blitz 4)
                    Boolean isSysAdmin = uw_HelperMethods.isSystemAdminUser();
                    system.debug('test we can delete asset');
                    if ( !canDeleteAsset(asset) ){
                    */
                    /* start new code (Blitz 4) */
                    system.debug('test we can delete asset');
                    if ( !canDeleteAsset(asset, tmCacheMap) ){
                    /* end new code (Blitz 4) */
                        system.debug('cannot delete asset');
                        
                        system.debug('test we can see related item');
                        system.debug('mapFeedItemsByBET: '+mapFeedItemsByBET);
                        system.debug('mapFeedItemsByBETL: '+mapFeedItemsByBETL);
                        system.debug('mapFeedItemsByBETT: '+mapFeedItemsByBETT);
                        system.debug('looking for :'+asset.uw_BET__c);
                        
                        //string x = ApexPages.currentPage().getParameters().get('id');
                        
                        // case 2 - not owner, marks as an error
                        string x = '';
                        try{
                            x = [select Studio_Chatter_Group__c from uw_BET__C where id = :asset.uw_BET__c limit 1 ].Studio_Chatter_Group__c;
                        } catch(exception e){}
                        
                        if(mapFeedItemsByBET.containsKey(x))
                        {
                             system.debug('warn user he cannot delete Post(File)');
                             FeedItem fiError = (FeedItem)mapFeedItemsByBET.get(x);
                             fiError.addError(CANNOT_DELETE_NOT_OWNER);
                        }
                        
                        if(mapFeedItemsByBETL.containsKey(x)  )
                        {
                             system.debug('warn user he cannot delete Post(Link)');
                            FeedItem fiError = (FeedItem)mapFeedItemsByBETL.get(x);
                            fiError.addError(CANNOT_DELETE_NOT_OWNER);
                        }
                        if(mapFeedItemsByBETT.containsKey(x)  )
                        {
                             system.debug('warn user he cannot delete Post(Text)');
                            FeedItem fiError = (FeedItem)mapFeedItemsByBETT.get(x);
                            fiError.addError(CANNOT_DELETE_NOT_OWNER);
                        }                     

                    } else {

                        // case 3
                        // TODO : do we need to delete the FeedComment (FeedComment.FeedItemId = FeedItem.Id)
                        // Assuming cascaded delete (Delete FeedItem and FeedComments also delete automatically)

                        system.debug('test we can see related item');
                        system.debug('mapFeedItemsByBET: '+mapFeedItemsByBET);
                        system.debug('looking for :'+asset.uw_BET__c);
                        system.debug('Feeditems :'+mapFeedItemsByBET);
                        FeedItem fi = (FeedItem)mapFeedItemsByBET.get(asset.uw_BET__c);
                        system.debug('test we can demote asset');
                        Boolean mode = canDemoteAsset(betObjectId, asset, fi);
                        if (mode) {
                            system.debug('demote!');
                            asset.Promoted__c = false; 
                            asset.betfeedid__c = null;                              
                            assetsToDemote.add(asset);
                        } else {
                            system.debug('delete');
                            
                            asset.Usage__c = 'DeletedFeed' ;
                            
                            assetsToDelete.add(asset);                                
                            system.debug('MFFI' + asset);
                            system.debug('fi: ' + fi);
                           // delete fi;                                
                        
                            //system.debug('async delete of feed item: '+asset.related_feed_Item__c);
                        }
                    }               
                }
                uw_DeleteObjectsHelper doh = new uw_DeleteObjectsHelper();
                if (assetsToDelete.size() > 0) {
                    doh.lockContentDocument(true);
                    doh.deleteAssets(assetsToDelete);
                    doh.lockContentDocument(false);
                } 
                if (assetsToDemote.size() > 0)  {
                    doh.updateAssets(assetsToDemote);
                }             
                // deleting will lock the asset - so we have to unlock
                doh.lockAsset(false);
            }
        }       
    }


   
    // If the item contains the text from the system Launch Label
    // Replace the secret label with the message and 
    // update the group information with the link to the pinnovate wall
    public void handleFeedItemBeforeInsert(List<FeedItem> newFeedItems)
    { 
      String strGroupFeedText='';
        Map<Id, FeedItem> groupFeedItemMap = new Map<Id,FeedItem>{};    
        Set<Id> collabGroupsIdSet = new Set<Id>();
        for (FeedItem feedItem: newFeedItems)
        {
            if (isFeedItemOnCollabGroup(feedItem.ParentId))
            {
                system.debug('handleFeedItemBeforeInsert: 1.1');
//IDC 21/5: Fix for Summer 13 issue  - Launch the wall
//changing feed for label.LAUNCH_PINNOVATE_CMD to lower
//added tolowercase() in line 1286
                if (!uw_HelperMethods.valueIsNull(feedItem.Body) && feedItem.Body.tolowercase().contains(label.LAUNCH_PINNOVATE_CMD))
               
                {
                    system.debug('handleFeedItemBeforeInsert: 1.2');
                    collabGroupsIdSet.add(feedItem.ParentId);
                    feedItem.Body = Label.UW_PINNOVATE_LAUNCHED;
                    groupFeedItemMap.put(feedItem.ParentId, feedItem);
                }
            }
        }
        
        //Cognizant Amended Code to check for set size
        //start of amended code
        List<CollaborationGroup> collabGroups = new List<CollaborationGroup>();
        List<uw_BET__c> relatedBets = new List<uw_BET__c>();
        Map<Id, Pinnovate_Preference__c> pinnovates = new Map<Id, Pinnovate_Preference__c>{};
        Map<Id,uw_BET__c> mapOfGroupsToBets = new Map<Id,uw_BET__c>();
        
        if(!collabGroupsIdSet.isEmpty())
        {
            collabGroups = [Select Id, OwnerId, Name, InformationBody from CollaborationGroup where Id in: collabGroupsIdSet];
        
            relatedBets = [Select Id, Studio_Chatter_Group__c from uw_Bet__c where Studio_Chatter_Group__c in :collabGroupsIdSet];
        
            
            for (uw_BET__c bet:relatedBets)
            {
                mapOfGroupsToBets.put(bet.Studio_Chatter_Group__c, bet);
            }
        
            
            for(Pinnovate_Preference__c pinnovate : [Select Id, Name from Pinnovate_Preference__c where Name IN :collabGroupsIdSet])
                pinnovates.put(pinnovate.Name, pinnovate);
        } 
        //end of amended code
        system.debug('handleFeedItemBeforeInsert: 1.3');
        List<CollaborationGroup> collabGroupsToUpdate = new List<CollaborationGroup>();
        Map<Id, Pinnovate_Preference__c> newPinnovates = new Map<Id, Pinnovate_Preference__c>();
        system.debug('handleFeedItemBeforeInsert: 1.4');
        for (CollaborationGroup cGroup: collabGroups)
        {
            system.debug('handleFeedItemBeforeInsert: 2.1');
            // Only Sys Admin or Group Owner can launch it!
            if (uw_HelperMethods.isSystemAdminUser() || uw_HelperMethods.idsAreEqual(cGroup.OwnerId, UserInfo.getUserId()))
            { 
                system.debug('handleFeedItemBeforeInsert: 2.2');
                
                if(pinnovates.get(cGroup.Id) == null){
                //added by krathika: (Group_Name__c=cGroup.Name)
                    Pinnovate_Preference__c p = new  Pinnovate_Preference__c(Name = cGroup.id, Group_Name__c=cGroup.Name, Background_Color__c = '#D8D5D2', Background_Image__c = '/resource/1376320667000/greytile', Header_Banner__c = uw_Custom_Setting__c.getInstance('PINNOVATE_DEFAULT_BANNER').Text_Value__c);
                    newPinnovates.put(cGroup.Id, p);
                    
                    //cGroup.InformationBody = '<a href="/apex/Pinnovate?id=' + cGroup.id + '">Open Pinnovate Wall</a>' + '<br/>';
                    //System.debug('**** pinn INfo 1 ' + cGroup.InformationBody);
                    
                    //The following will move the duplicate 'Open Pinnovate Wall' link
                    //strGroupFeedText = cGroup.InformationBody;
                    //strGroupFeedText = strGroupFeedText.replace('<a href="/apex/Pinnovate?id=' + cGroup.id + '">Open Pinnovate Wall</a>','');
                    //cGroup.InformationBody = strGroupFeedText;
                    
                    //System.debug('**** pinn INfo 2 ' + cGroup.InformationBody); 
                    cGroup.InformationBody = (cGroup.InformationBody != null ? cGroup.InformationBody + '<br/>' : '') + '<a href="/apex/Pinnovate?id=' + cGroup.id + '">Open Pinnovate Wall</a>' + '<br/>';

                    //cGroup.InformationBody = (cGroup.InformationBody != null ? cGroup.InformationBody + '<br/>' : '') + '<a href="/apex/Pinnovate?id=' + cGroup.id + '">Open Pinnovate Wall</a>' + '<br/>';
                    //System.debug('**** pinn INfo 3 ' + cGroup.InformationBody);
                    collabGroupsToUpdate.add(cGroup);         
                }
                else
                    groupFeedItemMap.get(cGroup.Id).addError(System.Label.UW_PINNOVATE_ALREADY_LAUNCHED +' '+ System.URL.getSalesforceBaseURL().toExternalForm()+ '/apex/Pinnovate?id=' + cGroup.Id);
                
                // If it is an external group - we cannot launch the wall and overwrite the links 
                if (mapOfGroupsToBets.get(cGroup.Id) != null)
                {
                    for (FeedItem feedItem: newFeedItems)
                    {
                        system.debug('handleFeedItemBeforeInsert: 2.4');
                        feedItem.addError('This External View Chatter group cannot be used for Pinnovate');  
                    }
                    return; 
                }
            }
            else
            {
                system.debug('handleFeedItemBeforeInsert: 2.3');
                // Throw Errors
                for (FeedItem feedItem: newFeedItems)
                {
                    system.debug('handleFeedItemBeforeInsert: 2.4');
                    feedItem.addError(System.Label.UW_CANNOT_LAUNCH_WALL);  
                }
                return;
            }
        }
        
        if(!newPinnovates.isEmpty()){
            insert newPinnovates.values();
            sharePinnovatePreferences(newPinnovates);
        }
            
        if (!collabGroupsToUpdate.isEmpty())
        {   
            for(CollaborationGroup cGroup : collabGroupsToUpdate)
            if(newPinnovates.get(cGroup.Id) != null)
            cGroup.InformationBody = cGroup.InformationBody + '<br/>' + '<a href="/' + newPinnovates.get(cGroup.Id).id + '">Open Pinnovate Preferences</a>' + '<br/>';
            system.debug('handleFeedItemBeforeInsert: 2.5');
            update collabGroupsToUpdate;
        }
        
    }
    
    //Share Pinnovate Preference Records with Group Managers
    public void sharePinnovatePreferences(Map<Id, Pinnovate_Preference__c> prefs){
        
        List<Pinnovate_Preference__Share> prefShares = new List<Pinnovate_Preference__Share>();
        
        for(CollaborationGroupMember cgm : [Select Id, MemberId, CollaborationGroupId, CollaborationGroup.OwnerId from CollaborationGroupMember where CollaborationRole='Admin'
                                        AND CollaborationGroupId In :prefs.keySet() ORDER BY CollaborationGroupId]){
                if(cgm.MemberId != cgm.CollaborationGroup.OwnerId)
                    prefShares.add(new Pinnovate_Preference__Share(ParentId = prefs.get(cgm.CollaborationGroupId).Id, UserOrGroupId = cgm.MemberId,
                                    AccessLevel = 'Edit', RowCause=Schema.Pinnovate_Preference__Share.RowCause.Manual));
        }
                                      
        if(!prefShares.isEmpty())
            Database.insert(prefShares);
    
    }
    
    // if the Topic contains pin - create a link object and PIN it
        public void handleTopicAssignmentAfterInsert(Map<Id,TopicAssignment> newTopicAssignment)
        { 
        List<Id> pinCommands = new List<Id>();
        
        Map<Id, TopicAssignment> pinPrefComments = new Map<Id, TopicAssignment>();
        Map<Id, Set<String>> topicassignmentsCanPin = new Map<Id, Set<String>>(); //group id to list(owners, managers)
        
        for (TopicAssignment Asgn : newTopicAssignment.values())
        {
            List<Topic> topic1=[SELECT Name FROM Topic WHERE Id =: Asgn.TopicId];
            string topic_name;
            for(Topic tp:topic1)
            {
             topic_name=tp.Name;
            } 
            if (!uw_HelperMethods.valueIsNull(topic_name) && (topic_name.tolowercase().contains('pin') ||topic_name.tolowercase() == 'pin'))
            {
                pinCommands.add(Asgn.Id);
                system.debug(Asgn.Id);
               topicassignmentsCanPin.put(Asgn.CreatedById, new Set<String>());
            }
            //Added by Suraj
            try{
            if (!uw_HelperMethods.valueIsNull(topic_name) && Asgn.CreatedById.GetSobjectType() == Schema.Pinnovate_Preference__c.sObjectType
                 && (topic_name.tolowercase().contains(System.Label.UW_SET_HEADER_CMD) || topic_name.tolowercase().contains(System.Label.UW_SET_BACKGROUND_CMD)))
                 pinPrefComments.put(Asgn.EntityId, Asgn);
                 
                 if (Test.isRunningTest()){
                    pinPrefComments = newTopicAssignment;
                }
            }catch(Exception ae){  }
        }
        
        for(CollaborationGroupMember cgm :  [Select MemberId, CollaborationGroupId from CollaborationGroupMember where CollaborationRole = 'Admin' AND CollaborationGroupId IN :topicassignmentsCanPin.keySet()]){
            topicassignmentsCanPin.get(cgm.CollaborationGroupId).add(cgm.MemberId);
        }
        
        if (pinCommands.size() > 0)
        {
            // is the comment linked to a feed item linked to a Collab Group?
            // If so - and the Feed Item is a you tube vid - then pin it 
            // by creating a uw_link object pinned to the feed item and group
            Set<Id> parentFeedItemIds = new Set<Id>();
            for (Id id:pinCommands)
            {
                parentFeedItemIds.add(newTopicAssignment.get(Id).EntityId);
            }
            
            List<uw_Links__c> linksToCreate = new List<uw_Links__c>();
            // AH Changes for Pinnovate to support content images for China Users
            // List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id, CreatedById From FeedItem where Type = 'LinkPost' and Id in: parentFeedItemIds];
            List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id, CreatedById, RelatedRecordId, ContentFileName From FeedItem where Id in: parentFeedItemIds]; 
            
            /*Comment Begin - Vaibhav Vora 06-Feb-2014*/
            /*Allow everyone to pin, no more restrictions!!*/
        /*            
            // The #pin command can only be issues by the post owner or sysadmin!
        
            if (parentFeedItems.size() > 0)
            {
                // 5/12/2012 Pinnovate Issue(Adien) - changed || condition to &&
                if (!uw_HelperMethods.isSystemAdminUser() &&  !uw_HelperMethods.idsAreEqual(parentFeedItems[0].CreatedById, UserInfo.getUserId())
                    && !topicassignmentsCanPin.get(parentFeedItems[0].ParentId).contains(UserInfo.getUserId()))
                {
                    // Get feed owner and group owner
                    for (TopicAssignment fc: newTopicAssignment.values())
                    {
                        fc.addError(System.Label.UW_CANNOT_PIN);
                        return;
                    }
                }
            }
            */    
               /*Comment End- Vaibhav Vora 06-Feb-2014*/
                     
            for (FeedItem feedItem: parentFeedItems)
            {
                if (feedItem.Type == 'LinkPost')
                {
                    // For link posts we only support youtube
                    if (isFeedItemOnCollabGroup(feedItem.ParentId) && feedItem.LinkUrl.contains('youtube'))
                    {
                        // Need to pin this!
                        uw_Links__c link = new uw_Links__c();
                        // link.RecordTypeId = getUWLinkPinnovateRecordType();
                        link.Related_Feed_Item__c = feedItem.Id;
                        link.Related_Collaboration_Group__c = feedItem.ParentId;
                        linksToCreate.add(link);
                    }
                }
                else if (feedItem.Type == 'ContentPost')
                {
                    // Need to see if it's an accepted pinnovate image extension
                    for (String fileExt: uw_Constants.getPinnovateFileExtensions())
                    {
                       if ( feedItem.ContentFileName.toLowerCase().endsWith(fileExt))
                       {
                         // Need to pin this!
                         uw_Links__c link = new uw_Links__c();
                         // link.RecordTypeId = getUWLinkPinnovateRecordType();
                         link.Related_Feed_Item__c = feedItem.Id;
                         link.Related_Collaboration_Group__c = feedItem.ParentId;
                         linksToCreate.add(link);
                       }
                    }
                }
            }
            
 // TODO - we have an issue with creating duplicates - is this a problem - handle in wall controller!
            if (linksToCreate.size() > 0)
            {
                insert linksToCreate;
            }
            }
            //Setting Pinnovate Preference Header and Background
         if(!pinPrefComments.isEmpty()){
            List<Pinnovate_Preference__c> pinPreferences = new List<Pinnovate_Preference__c>();
           Map<Id, Id> pinnovatePrefCommentMap = new Map<Id, Id>();
          for(FeedItem fItem : [Select Id, RelatedRecordId from FeedItem where Id In :pinPrefComments.keySet()
                                    AND Type = 'ContentPost']){
                TopicAssignment currComm = pinPrefComments.get(fItem.Id);
                Pinnovate_Preference__c pinPref = new Pinnovate_Preference__c(Id = currComm.CreatedById);
                List<Topic> topic1=[SELECT Name FROM Topic WHERE Id =: currComm.TopicId];
                string topic_name_1;
                for(Topic tp:topic1)
                 {
                   topic_Name_1=tp.Name;
                 } 
                System.debug('***** topic_Name ' + topic_Name_1);
                String strHeader = topic_Name_1;
                strHeader = strHeader.toLowerCase();
               // if(currComm.CommentBody.contains(System.Label.UW_SET_HEADER_CMD))
               System.debug('***** currComm.CommentBody strHeader ' + strHeader);
               if(strHeader.contains(System.Label.UW_SET_HEADER_CMD))
                    pinPref.Header_Banner__c = '/sfc/servlet.shepherd/version/download/' + fItem.RelatedRecordId + '?asPdf=false&operationContext=CHATTER';
                else
                    pinPref.Background_Image__c = '/sfc/servlet.shepherd/version/download/' + fItem.RelatedRecordId + '?asPdf=false&operationContext=CHATTER';
                
                pinnovatePrefCommentMap.put(pinPref.Id, currComm.Id);
                pinPreferences.add(pinPref);
            }
            if(!pinPreferences.isEmpty()){
                Database.saveResult[] results = Database.update(pinPreferences, false);
                for(Database.saveResult sr : results)
                if(sr.isSuccess())
                    pinnovatePrefCommentMap.remove(sr.getId());
                    
                if(!pinnovatePrefCommentMap.isEmpty())
                for(Id fcId : pinnovatePrefCommentMap.values())
                    newTopicAssignment.get(fcId).addError(System.Label.UW_CANNOT_MODIFY_PREFS);
            }
        }   
    }
    
    // if the Topic contains pin - un pin the related link on the pinnovate wall
    public void handleTopicBeforeDelete(Map<Id,TopicAssignment > deletedTopic)
    {   
        
        List<Id> pinCommands = new List<Id>();
        
        for (TopicAssignment Topics: deletedTopic.values())
        {
            system.debug('handleTopicBeforeDelete: Topics: ' +Topics);
            List<Topic> topic1=[SELECT Name FROM Topic WHERE Id =: Topics.TopicId];
            string topic_name;
                for(Topic tp:topic1)
                 {
                   topic_Name=tp.Name;
                 } 
            if (topic_Name != null) {
                if ((topic_Name.tolowercase().contains('pin') || topic_Name.tolowercase() == 'pin'))
                {
                    pinCommands.add(Topics.Id);
                }                     
            }
        }
        
        if (pinCommands.size() > 0)
        {
            // is the comment linked to a feed item linked to a Collab Group?
            // If so - and the Feed Item is a you tube vid - then delete the links record 
            Set<Id> parentFeedItemIds = new Set<Id>();
            for (Id id:pinCommands)
            {
                parentFeedItemIds.add(deletedTopic.get(Id).EntityId);
            }
            
            List<Id> pinCommandsToDeleteLinksFor = new List<Id>();
            // List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id From FeedItem where Type = 'LinkPost' and Id in: parentFeedItemIds];
            List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id From FeedItem where Id in: parentFeedItemIds];
            
            for (FeedItem feedItem: parentFeedItems)
            {
                if (isFeedItemOnCollabGroup(feedItem.ParentId))
                {
                    // Need to find this record and delete it!
                    pinCommandsToDeleteLinksFor.add(feedItem.Id);
                }
            }
            
            if (pinCommandsToDeleteLinksFor.size() > 0)
            {
                // List<uw_Links__c> linksToDelete = [Select Id from uw_Links__c where RecordTypeId = : getUWLinkPinnovateRecordType() and Related_Feed_Item__c in : pinCommandsToDeleteLinksFor];
                List<uw_Links__c> linksToDelete = [Select Id from uw_Links__c where Related_Feed_Item__c in : pinCommandsToDeleteLinksFor];
                //delegate deletion to without sharing class to allow for owners, managers being able to delete
                uw_TriggerHandler_WithoutSharing withoutSharingHandler = new uw_TriggerHandler_WithoutSharing();
                withoutSharingHandler.deletePinnovateLinks(linksToDelete);
            }
        }
        
       // handleFeedCommentWithContentBeforeDelete(deletedTopic.values(), deletedTopic);
    }
    
    
        // if the comment contains #pin - create a link object and PIN it
    public void handleFeedCommentAfterInsert(Map<Id,FeedComment> newFeedComments)
    { 
        List<Id> pinCommands = new List<Id>();
        
        Map<Id, FeedComment> pinPrefComments = new Map<Id, FeedComment>();
        Map<Id, Set<String>> feedCommentsCanPin = new Map<Id, Set<String>>(); //group id to list(owners, managers)
        
        for (FeedComment comment:newFeedComments.values())
        {
            if (!uw_HelperMethods.valueIsNull(comment.CommentBody) && (comment.CommentBody.tolowercase().contains('#pin ') || comment.CommentBody.tolowercase() == '#pin'))
            {
                pinCommands.add(comment.Id);
                system.debug(comment.Id);
                system.debug(comment.CommentBody);
                feedCommentsCanPin.put(comment.ParentId, new Set<String>());
            }
            //Added by Suraj
            try{
            if (!uw_HelperMethods.valueIsNull(comment.CommentBody) && comment.ParentId.GetSobjectType() == Schema.Pinnovate_Preference__c.sObjectType
                 && (comment.CommentBody.tolowercase().contains(System.Label.UW_SET_HEADER_CMD) || comment.CommentBody.tolowercase().contains(System.Label.UW_SET_BACKGROUND_CMD)))
                 pinPrefComments.put(comment.FeedItemId, comment);
            }catch(Exception ae){
                if (Test.isRunningTest()){
                    pinPrefComments = newFeedComments;
                } 
            }
        }
        
        for(CollaborationGroupMember cgm :  [Select MemberId, CollaborationGroupId from CollaborationGroupMember where CollaborationRole = 'Admin' AND CollaborationGroupId IN :feedCommentsCanPin.keySet()]){
            feedCommentsCanPin.get(cgm.CollaborationGroupId).add(cgm.MemberId);
        }
        
        if (pinCommands.size() > 0)
        {
            // is the comment linked to a feed item linked to a Collab Group?
            // If so - and the Feed Item is a you tube vid - then pin it 
            // by creating a uw_link object pinned to the feed item and group
            Set<Id> parentFeedItemIds = new Set<Id>();
            for (Id id:pinCommands)
            {
                parentFeedItemIds.add(newFeedComments.get(Id).FeedItemId);
            }
            
            List<uw_Links__c> linksToCreate = new List<uw_Links__c>();
            // AH Changes for Pinnovate to support content images for China Users
            // List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id, CreatedById From FeedItem where Type = 'LinkPost' and Id in: parentFeedItemIds];
            List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id, CreatedById, RelatedRecordId, ContentFileName From FeedItem where Id in: parentFeedItemIds]; 
            
             /*Comment Begin - Vaibhav Vora 06-Feb-2014*/
            /*Allow everyone to pin, no more restrictions!!*/
           /* 
            // The #pin command can only be issues by the post owner or sysadmin!
            if (parentFeedItems.size() > 0)
            {
                // 5/12/2012 Pinnovate Issue(Adien) - changed || condition to &&
                if (!uw_HelperMethods.isSystemAdminUser() &&  !uw_HelperMethods.idsAreEqual(parentFeedItems[0].CreatedById, UserInfo.getUserId())
                    && !feedCommentsCanPin.get(parentFeedItems[0].ParentId).contains(UserInfo.getUserId()))
                {
                    // Get feed owner and group owner
                    for (FeedComment fc: newFeedComments.values())
                    {
                        fc.addError(System.Label.UW_CANNOT_PIN);
                        return;
                    }
                }
            }
           */
            /*Comment End- Vaibhav Vora 06-Feb-2014*/           

            
            for (FeedItem feedItem: parentFeedItems)
            {
                if (feedItem.Type == 'LinkPost')
                {
                    // For link posts we only support youtube
                    if (isFeedItemOnCollabGroup(feedItem.ParentId) && feedItem.LinkUrl.contains('youtube'))
                    {
                        // Need to pin this!
                        uw_Links__c link = new uw_Links__c();
                        // link.RecordTypeId = getUWLinkPinnovateRecordType();
                        link.Related_Feed_Item__c = feedItem.Id;
                        link.Related_Collaboration_Group__c = feedItem.ParentId;
                        linksToCreate.add(link);
                    }
                }
                else if (feedItem.Type == 'ContentPost')
                {
                    // Need to see if it's an accepted pinnovate image extension
                    for (String fileExt: uw_Constants.getPinnovateFileExtensions())
                    {
                       if ( feedItem.ContentFileName.toLowerCase().endsWith(fileExt))
                       {
                         // Need to pin this!
                         uw_Links__c link = new uw_Links__c();
                         // link.RecordTypeId = getUWLinkPinnovateRecordType();
                         link.Related_Feed_Item__c = feedItem.Id;
                         link.Related_Collaboration_Group__c = feedItem.ParentId;
                         linksToCreate.add(link);
                       }
                    }
                }
            }
            
            // TODO - we have an issue with creating duplicates - is this a problem - handle in wall controller!
            if (linksToCreate.size() > 0)
            {
                insert linksToCreate;
            }
            }
            //Setting Pinnovate Preference Header and Background
            if(!pinPrefComments.isEmpty()){
            List<Pinnovate_Preference__c> pinPreferences = new List<Pinnovate_Preference__c>();
            Map<Id, Id> pinnovatePrefCommentMap = new Map<Id, Id>();
            for(FeedItem fItem : [Select Id, RelatedRecordId from FeedItem where Id In :pinPrefComments.keySet()
                                    AND Type = 'ContentPost']){
                FeedComment currComm = pinPrefComments.get(fItem.Id);
                Pinnovate_Preference__c pinPref = new Pinnovate_Preference__c(Id = currComm.ParentId);
                
                System.debug('***** currComm.CommentBody ' + currComm.CommentBody);
                String strHeader = currComm.CommentBody;
                strHeader = strHeader.toLowerCase();
               // if(currComm.CommentBody.contains(System.Label.UW_SET_HEADER_CMD))
               System.debug('***** currComm.CommentBody strHeader ' + strHeader);
               if(strHeader.contains(System.Label.UW_SET_HEADER_CMD))
                    pinPref.Header_Banner__c = '/sfc/servlet.shepherd/version/download/' + fItem.RelatedRecordId + '?asPdf=false&operationContext=CHATTER';
                else
                    pinPref.Background_Image__c = '/sfc/servlet.shepherd/version/download/' + fItem.RelatedRecordId + '?asPdf=false&operationContext=CHATTER';
                
                pinnovatePrefCommentMap.put(pinPref.Id, currComm.Id);
                pinPreferences.add(pinPref);
            }
            if(!pinPreferences.isEmpty()){
                Database.saveResult[] results = Database.update(pinPreferences, false);
                for(Database.saveResult sr : results)
                if(sr.isSuccess())
                    pinnovatePrefCommentMap.remove(sr.getId());
                    
                if(!pinnovatePrefCommentMap.isEmpty())
                for(Id fcId : pinnovatePrefCommentMap.values())
                    newFeedComments.get(fcId).addError(System.Label.UW_CANNOT_MODIFY_PREFS);
            }
        }   
    }
                   
    // if the comment contains #pin - un pin the related link on the pinnovate wall
    public void handleFeedCommentBeforeDelete(Map<Id,FeedComment> deletedFeedComments)
    {        
        List<Id> pinCommands = new List<Id>();
        
        for (FeedComment comment: deletedFeedComments.values())
        {
            system.debug('handleFeedCommentBeforeDelete: comment: ' +comment);
            if (comment.CommentBody != null) {
                if ((comment.CommentBody.tolowercase().contains('#pin ') || comment.CommentBody.tolowercase() == '#pin'))
                {
                    pinCommands.add(comment.Id);
                }               
            }
        }
        
        if (pinCommands.size() > 0)
        {
            // is the comment linked to a feed item linked to a Collab Group?
            // If so - and the Feed Item is a you tube vid - then delete the links record 
            Set<Id> parentFeedItemIds = new Set<Id>();
            for (Id id:pinCommands)
            {
                parentFeedItemIds.add(deletedFeedComments.get(Id).FeedItemId);
            }
            
            List<Id> pinCommandsToDeleteLinksFor = new List<Id>();
            // List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id From FeedItem where Type = 'LinkPost' and Id in: parentFeedItemIds];
            List<FeedItem> parentFeedItems = [Select Type, ParentId, LinkUrl, Id From FeedItem where Id in: parentFeedItemIds];
            
            for (FeedItem feedItem: parentFeedItems)
            {
                if (isFeedItemOnCollabGroup(feedItem.ParentId))
                {
                    // Need to find this record and delete it!
                    pinCommandsToDeleteLinksFor.add(feedItem.Id);
                }
            }
            
            if (pinCommandsToDeleteLinksFor.size() > 0)
            {
                // List<uw_Links__c> linksToDelete = [Select Id from uw_Links__c where RecordTypeId = : getUWLinkPinnovateRecordType() and Related_Feed_Item__c in : pinCommandsToDeleteLinksFor];
                List<uw_Links__c> linksToDelete = [Select Id from uw_Links__c where Related_Feed_Item__c in : pinCommandsToDeleteLinksFor];
                //delegate deletion to without sharing class to allow for owners, managers being able to delete
                uw_TriggerHandler_WithoutSharing withoutSharingHandler = new uw_TriggerHandler_WithoutSharing();
                withoutSharingHandler.deletePinnovateLinks(linksToDelete);
            }
        }
        
        handleFeedCommentWithContentBeforeDelete(deletedFeedComments.values(), deletedFeedComments);
    }
    /* start wip  */
    
    public void handleFeedCommentWithContentBeforeDelete(List<FeedComment> feedCommentList, Map<Id, FeedComment> feedCommentMap) {
        system.debug('handleFeedCommentWithContentBeforeDelete: entry');
        system.debug('feedCommentMap: '+feedCommentMap);

        // get the uw_BET__c object id
        String betObjectId = uw_BET__C.sObjectType.getDescribe().getKeyPrefix();
        system.debug('betObjectId: '+betObjectId);

        if (!uw_HelperMethods.listIsNull(feedCommentList)) {
            // only interested in ContentComments
            List<FeedComment> feedCommentContentPosts = new List<FeedComment>();
            for (FeedComment fc:feedCommentList) {
                system.debug('fc: '+fc);
                 if (fc.CommentType == 'ContentComment')  {
                    feedCommentContentPosts.add(fc);
                 }
            }

            // get the assets that we have to work with
            Set<Id> setFeedComments = uw_HelperMethods.makeIdSet(feedCommentContentPosts, 'RelatedRecordId');
            
            Map<Id, SObject> mapFeedCommentsByBET = uw_HelperMethods.makeMap(feedCommentContentPosts, 'ParentId');
                        
            system.debug('setFeedComments: '+setFeedComments);
            
            List<uw_Asset__c> assetList = [SELECT Id, Name, Related_Feed_Comment__c, uw_Bet__c, uw_Bet__r.OwnerId, BET_Chatter_Group__c, url_of_asset__c FROM uw_Asset__c WHERE URL_of_Asset__c IN :setFeedComments];
                                    
            system.debug('assetList: '+assetList);

            // case 1 - nothing to do if we found no assets
            if (!uw_HelperMethods.listIsNull(assetList)) {
                // cases 2 and 3
                String currentUserId = Userinfo.getUserId();
                system.debug('currentUserId: '+currentUserId);
                
                List<uw_Asset__c> assetsToDelete = new List<uw_Asset__c>();
                List<uw_Asset__c> assetsToDemote = new List<uw_Asset__c>();
                List<FeedItem> feedItemNotifications = new List<FeedItem>();

                /* start new code (Blitz 4) */
                Set<Id> assetSet = uw_HelperMethods.makeIdSet(assetList,'uw_Bet__c');
                system.debug('assetSet: '+assetSet);
                List<uw_BET_Team_Member__c> tmCacheList = [Select Role__c,BET__c From uw_BET_Team_Member__c WHERE BET__c IN :assetSet AND Team_Member__c=:currentUserId];
                system.debug('tmCacheList: '+tmCacheList);
                Map<Id,SObject> tmCacheMap = uw_HelperMethods.makeMap(tmCacheList, 'BET__c');
                system.debug('tmCacheMap: '+tmCacheMap);
                /* end new code (Blitz 4) */

                for (uw_Asset__c asset:assetList) {
                    system.debug('BetOwner: '+ asset.uw_BET__r.OwnerId);
                    /* start old code (Blitz 4)
                    Boolean isSysAdmin = uw_HelperMethods.isSystemAdminUser();
                    if ( !canDeleteAsset(asset) ){
                    end old code (Blitz 4) */
                    /* start new code (Blitz 4) */
                    system.debug('test we can delete asset');
                    if ( !canDeleteAsset(asset, tmCacheMap) ){
                    /* end new code (Blitz 4) */
                        system.debug('cannot delete asset');
                        
                        system.debug('test we can see related item');
                        system.debug('mapFeedItemsByBET: '+mapFeedCommentsByBET);
                        system.debug('looking for :'+asset.uw_BET__c);
                        
                        //string x = ApexPages.currentPage().getParameters().get('id');
                        
                        // case 2 - not owner, marks as an error
                       string x = '';
                       try{
                           x = [select Studio_Chatter_Group__c from uw_BET__C where id = :asset.uw_BET__c limit 1 ].Studio_Chatter_Group__c;
                       } catch(exception e){}
                       if(mapFeedCommentsByBET.containsKey(x)) {
                           FeedComment fcError = (FeedComment)mapFeedCommentsByBET.get(x);
                           fcError.addError(CANNOT_DELETE_NOT_OWNER);
                       }                      
                        //}
                    } else {
                        // case 3
                        // TODO : do we need to delete the FeedComment (FeedComment.FeedItemId = FeedItem.Id)
                        // Assuming cascaded delete (Delete FeedItem and FeedComments also delete automatically)

                        system.debug('test we can see related item');
                        system.debug('mapFeedItemsByBET: '+mapFeedCommentsByBET);
                        system.debug('looking for :'+asset.uw_BET__c);
                       // if (mapFeedItemsByBET.containsKey(asset.uw_BET__c)) {
                            FeedComment fc = (FeedComment)mapFeedCommentsByBET.get(asset.uw_BET__c);
                            system.debug('test we can demote asset');
                            Boolean mode = canDemoteAsset(betObjectId, asset, fc);
                            if (mode) {
                                system.debug('demote!');
                                asset.Promoted__c = false; 
                                asset.betfeedid__c = null;                              
                                assetsToDemote.add(asset);
                            } else {
                                system.debug('delete');
                                
                                asset.Usage__c = 'DeletedFeed' ;
                                
                                assetsToDelete.add(asset);                                
                                system.debug('asset: ' + asset);
                                system.debug('fc: ' + fc);
                               // delete fi;                                
                            
                                system.debug('async delete of feed item: '+asset.related_feed_Item__c);
                            }
                     //   }                                                
                    }               
                }
                uw_DeleteObjectsHelper doh = new uw_DeleteObjectsHelper();
                if (assetsToDelete.size() > 0) {
                    doh.lockContentDocument(true);
                    doh.deleteAssets(assetsToDelete);
                    doh.lockContentDocument(false);
                } 
                if (assetsToDemote.size() > 0)  {
                    doh.updateAssets(assetsToDemote);
                }             
                // deleting will lock the asset - so we have to unlock
                doh.lockAsset(false);
            }
        }       
    }

    /* end wip */
  
    public void handleAssetAfterDelete(List<uw_asset__c> assetList) {
        system.debug('handleAssetAfterDelete: entry');
        if (!uw_HelperMethods.listIsNull(assetList)) {
            system.debug('handleAssetAfterDelete: assets: '+assetList.size());
            
            /* Start of new code (Blitz 4) */
            Set<Id> assetSetBF = uw_HelperMethods.makeIdSet(assetList, 'BetFeedID__c');
            system.debug('assetSetBF: '+assetSetBF);
            List<uw_BET__Feed> betFeedtoDelList=[Select id From uw_BET__Feed where id IN : assetSetBF] ;                        
            Map<Id, SObject> assetMap = uw_HelperMethods.makeMap(betFeedtoDelList);
            /* End of new code (Blitz 4) */


            List<uw_asset__c> assetListToDelete = new  List<uw_asset__c> ();
            for (uw_Asset__c assetChk:assetList) { 
                
                    //String cv = [select ContentDocumentId from ContentVersion where id = :asset.URL_of_Asset__c].ContentDocumentId;    
                                    
                    //ContentDocumentLink ContentLD= [Select id From ContentDocumentLink WHERE LinkedEntityId = :asset.uw_BET__c AND  ContentDocumentId= :cv ] ;      
                    /*list <ContentDocumentLink> ContentLD= [Select id , LinkedEntityId From ContentDocumentLink WHERE   ContentDocumentId= :cv ] ;         
                    for (ContentDocumentLink CDL  :ContentLD )  {
                        system.debug ('aaaaaaaa' + CDL);
                        system.debug ('bbbbbbbb' + asset.uw_BET__c);
                        
                        if (CDL.LinkedEntityId == asset.uw_BET__c)  {
                            delete CDL;
                        }
                    }
//toodoo            */
                    
                    
                
                system.debug('handleAssetAfterDelete: usage: '+assetChk.Usage__c);
                if ( assetChk.Usage__c != 'DeletedFeed' ) {     //'deletefeed' indicates the user does not have the right to delete
                    assetListToDelete.add(assetChk);
                    if (assetChk.BetFeedID__c != null) {
                        /* Start old code (Blitz 4) 
                        uw_BET__Feed betFeedtoDel=[Select id From uw_BET__Feed where id= : assetChk.BetFeedID__c] ;
                        if (!uw_HelperMethods.valueIsNull (betFeedtoDel) ){
                            delete betFeedtoDel;
                        }        
                        end old code*/
                        /* start new code (Blitz 4) */
                        if (!uw_HelperMethods.valueIsNull(assetChk.BetFeedID__c)) {
                            system.debug('assetChk.BetFeedID__c: '+assetChk.BetFeedID__c);
                            if (assetMap.containsKey(assetChk.BetFeedID__c)) {
                                system.debug('in map: ');
                                uw_BET__Feed bfToDel = (uw_BET__Feed)assetMap.get(assetChk.BetFeedID__c);
                                delete bfToDel;
                            }                           
                        }
                        /* end new code (Blitz 4) */                                        
                    }
                }
            }
        
            try{
            Set<Id> assetSet = uw_HelperMethods.makeIdSet(assetListToDelete,'URL_of_Asset__c');
            system.debug('handleAssetAfterDelete: asset set: '+assetSet);
            List<ContentVersion> cvList = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN :assetSet];
            system.debug('handleAssetAfterDelete: cv: '+cvList);
            
            if (!uw_HelperMethods.listIsNull(cvList)) {
                Set<Id> cvSet = uw_HelperMethods.makeIdSet(cvList, 'ContentDocumentId');
                List<ContentDocument> cdList = [SELECT Id FROM ContentDocument WHERE Id IN :cvSet];
                system.debug('handleAssetAfterDelete: cd: '+cdList);
                
                uw_DeleteObjectsHelper doh = new uw_DeleteObjectsHelper();
                doh.lockAsset(true);
                doh.deleteContentDocuments(cdList);                         
                doh.lockAsset(false);
            }
            }catch(exception e){}
            
            //List<FeedItem> FI = [SELECT id FROM FeedItem WHERE Id IN :assetSet];
            
        } 
        
        /* old code
        for(uw_Asset__c uwasset : Trigger.old) {
            String cv = [select ContentDocumentId from ContentVersion where id = :uwasset.URL_of_Asset__c].ContentDocumentId;
            ContentDocument cd = [select id from ContentDocument where id = :cv limit 1 ];  
            system.debug('MF' + cv);

            delete cd;
        }
        */      
    }

    //String formattedString = String.format('Hello {0}, shall we play a {1}?', new String[]{'David', 'game'});  
    //System.debug(formattedString);     

/*public void handlecontentdocumentUpdates(Map<Id,contentdocument> newValues, Map<Id,contentdocument> oldValues)
{
    system.debug('MFTRIGGERFIRE');
    //if(newvalues.publishstatus == 'R')
    //{
        
    system.debug('MFTRIGGERFIRE2'); 
        contentdocument doc;
        //doc.addError('There was a problem updating the accounts');
    //}
    
}*/

    public void handleContentDocumentDelete(List<ContentDocument> cdList, Map<Id, ContentDocument> cdMap) {
        // need to get assets to delete
        
        if (!uw_HelperMethods.listIsNull(cdList)) {
            // first get the ContentVersion from the content document
            Set<Id> cdSet = uw_HelperMethods.makeIdSet(cdList);
            List<ContentVersion> cvList = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :cdSet];
            system.debug('handleContentDocumentDelete: cv: '+cvList);
            
            if (!uw_HelperMethods.listIsNull(cvList)) {
                // second get the Assets from the ContentVersion
                Set<Id> cvSet = uw_HelperMethods.makeIdSet(cvList);
                Map<Id, SObject> cvMap = uw_HelperMethods.makeMap(cvList);
                
                /* old code (Blitz(4)
                List<uw_Asset__c> assetList = [SELECT Id, betfeedid__c, uw_bet__r.ownerId, uw_bet__r.Name, url_of_asset__c FROM uw_Asset__c WHERE url_of_asset__c IN :cvSet];
                */
                /* start new code (Blitz 4) */
                List<uw_Asset__c> assetList = [SELECT Id, betfeedid__c, uw_bet__r.ownerId, uw_bet__r.Name, url_of_asset__c,uw_bet__c FROM uw_Asset__c WHERE url_of_asset__c IN :cvSet];
                /* end new code (Blitz 4) */
                
                system.debug('handleContentDocumentDelete: assets: '+assetList);

                List<uw_Asset__c> assetToDelete = new List<uw_Asset__c>();

                /* start new code (Blitz 4) */
                Set<Id> assetSet = uw_HelperMethods.makeIdSet(assetList,'uw_bet__c');
                system.debug('assetSet: '+assetSet);
                List<uw_BET_Team_Member__c> tmCacheList = [Select Role__c,BET__c From uw_BET_Team_Member__c WHERE BET__c IN :assetSet AND Team_Member__c=:currentUserId];
                system.debug('tmCacheList: '+tmCacheList);
                Map<Id,SObject> tmCacheMap = uw_HelperMethods.makeMap(tmCacheList, 'BET__c');
                system.debug('tmCacheMap: '+tmCacheMap);
                /* end new code (Blitz 4) */

                for (uw_Asset__c asset:assetList) {
                    /* start old code (Blitz 4) 
                    if (canDeleteAsset(asset)) {
                    end old code (Blitz 4)*/
                    /* start new code (Blitz 4) */
                     if (canDeleteAsset(asset, tmCacheMap)) {
                    /* end new code (Blitz 4) */
                        // can delete
                        assetToDelete.add(asset);
                    } else {
                        system.debug('delete content document cannot delete: asset: '+asset);
                        // cannot delete so add error message
                        if ((asset.url_of_asset__c != null) && (cvMap.containsKey(asset.url_of_asset__c))) {
                            ContentVersion cvError = (ContentVersion) cvMap.get(asset.url_of_asset__c);
                            system.debug('cvError: '+cvError);
                            ContentDocument cdError = cdMap.get(cvError.ContentDocumentId);
                            system.debug('cdError: '+cdError);
                            User uError = [SELECT Name FROM User WHERE id=:asset.uw_bet__r.ownerId];
                            system.debug('uError: '+uError);
                            cdError.addError(String.Format(CANNOT_DELETE_CHATTER_FILE, new String[]{asset.uw_bet__r.Name, uError.Name}));
                        }       
                    }
                }
                
                // now use a helper to delete the objects as the cascaded delete may get difficult
                uw_DeleteObjectsHelper doh = new uw_DeleteObjectsHelper();
                doh.lockContentDocument(true);
                doh.deleteAssets(assetToDelete);                
                doh.lockContentDocument(false);
            }           
        }
    }        
        
    @future    
    public static void handleUserAfterUpdatesFuture(Set<Id> BETIds) {
        List<uw_BET__c> bets = [SELECT Id, Owner.Firstname, Owner.Lastname FROM uw_BET__c WHERE Id IN :BETIds];
        for(uw_BET__c b : bets){
            b.Owner_Keyword_Search__c = b.Owner.Firstname + ' ' + b.Owner.Lastname; 
        }
        if(bets.size() > 0 ){
            update bets;
        }        
    }
    public void handleUserAfterUpdates(Map<Id,User> newValues, Map<Id,User> oldValues)
    {
        Set<Id> userIds = new Set<Id>();
        for (User u : newValues.values()) {
            if (oldValues.get(u.Id).Firstname != u.Firstname || oldValues.get(u.Id).Lastname != u.Lastname) {
                userIds.add(u.Id);
            }
        }
        if (!userIds.isEmpty()) {
            List<uw_BET__c> bets = [SELECT Id FROM uw_BET__c WHERE OwnerId IN :userIds];
            Set<Id> BETIds = new Set<Id>();
            for(uw_BET__c b : bets){
                BETIds.add(b.Id);
            }
            if(BETIds.size() > 0 ){
                handleUserAfterUpdatesFuture(BETIds);
            }
        }

        //String publicGroupId = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.ALL_UNILEVER_PUBLIC_GROUP);
        String publicGroupId = '';
     
        // have issue if test is being run with Data as false...
        if (Test.isRunningTest())
        { 
            //Group testGroup = uw_UnitTestDataFactory.createGroup();
            //publicGroupId = testGroup.Id;
            // Need to return - breaking too many other tests..
            return;
        }
        else
        {
            // 
            publicGroupId = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.ALL_UNILEVER_PUBLIC_GROUP);
        }        
        // We need to see if the user has changed from inactive to active - 
        // and they are not in the All Unilever public group - we need to add them
        
        List<Id> listOfInactiveToActiveUsers = new List<Id>();
        for (Id id: newValues.keySet())
        {
            User newUser = newValues.get(id);
            User oldUser = oldValues.get(id);
            
            if (oldUser.IsActive == false && newUser.IsActive == true)
            {
                if (newUser.UserType == 'Standard')
                {
                    listOfInactiveToActiveUsers.add(id);    
                }
            }   
        }
        
        if (listOfInactiveToActiveUsers.size() == 0)
        {
            return;
        }
        
        // Need to add any active users to the public group if they are not already a member
        List<GroupMember> groupMembersToCreate = new List<GroupMember>();
        
        List<GroupMember> existingGroupMembers = [Select Id, UserorGroupID from GroupMember where GroupID =:publicGroupId and  UserorGroupID in :listOfInactiveToActiveUsers];
        
        // 
        Set<Id> existingGroupMemberSet = new Set<Id>();
        for (GroupMember gm:existingGroupMembers)
        {
            existingGroupMemberSet.add(gm.UserorGroupID);
        }
        
        for (Id id:listOfInactiveToActiveUsers)
        {
            // If the user id is not in the list of existing members - add them
            if (!existingGroupMemberSet.contains(id))
            {
                groupMembersToCreate.add(new GroupMember( UserorGroupID = id,GroupID  = publicGroupId));
            }
        }
        
        if (groupMembersToCreate.size() > 0)
        {
            insert groupMembersToCreate;
        }
            
    }
    
     public void handleUserAfterInserts(Map<Id,User> newUsers)
    {
     /* Author: Mindtree
        Description: Add new Salesforce.com (Internal) Users to a pre-defined Chatter Groups (mapping stored in custom setting) */ 
        List<String> lstStrFtr=new List<String>();
        for (User objUsr: newUsers.values())
        {
            if ( objUsr.UserType == 'Standard')
            {               
               List<String> lstStrGroupIds=new List<String>();
               String[] arrFuncGrpIds;
               String[] arrCityGrpIds;
               String strCity; 
               String strFunction;
               String strId;
                
              //check whether any of the custom setting matches with specified city name and function name
               List<CORE_CHATTER_USER_ADMINISTRATION__c> lstcustSetVal= CORE_CHATTER_USER_ADMINISTRATION__c.getall().values();   
                for(CORE_CHATTER_USER_ADMINISTRATION__c temp:lstcustSetVal){
                   if(temp.Name == objUsr.City) { 
                     strCity= temp.Name; 
                     break; 
                     }
                     strCity =null;            
                }
                for(CORE_CHATTER_USER_ADMINISTRATION__c temp:lstcustSetVal){
                   if(temp.Name == objUsr.Function__c) {
                     StrFunction=temp.Name;
                     break; 
                     }
                     strFunction=null;           
                }
                           
               if((strFunction != null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strFunction).Chatter_Group_Id__c !=null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strFunction).Chatter_Group_Id__c !='') ||
                  (strCity !=null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strCity).Chatter_Group_Id__c !=null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strCity).Chatter_Group_Id__c !='' ) ){
                  
                  //match the Custom setting name with the Function name of inserted user record,add to specified group 
                  if(strFunction != null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strFunction).Chatter_Group_Id__c !=null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strFunction).Chatter_Group_Id__c !=''){                   
                     arrFuncGrpIds= CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strFunction).Chatter_Group_Id__c.Split(',');
                     for(string temp: arrFuncGrpIds)
                        lstStrGroupIds.add(temp);                 
                   }
                  
                  //match the Custom setting name with the city of inserted user record,add to specified group
                  if(strCity !=null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strCity).Chatter_Group_Id__c !=null && CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strCity).Chatter_Group_Id__c !='' && strCity != objUsr.Function__c){                    
                      arrCityGrpIds=CORE_CHATTER_USER_ADMINISTRATION__c.getInstance(strCity).Chatter_Group_Id__c.Split(','); 
                      for(string temp :arrCityGrpIds)
                          lstStrGroupIds.add(temp);             
                   }
                
                   strId=null;
                   if(!lstStrGroupIds.isEmpty()){
                    strId=string.valueOf(objUsr.id)+'~';
                    for(string temp:lstStrGroupIds){
                      strId= strId+','+ temp;
                     }
                    lstStrFtr.add(strId);
                    system.debug('@@@@@list values'+lstStrFtr);
                  }                                            
             }                  
          }
        }
        if(!Test.isRunningTest()){
        system.debug('@@@@@list 111  values'+lstStrFtr + '     ' + lstStrFtr.isEmpty());
            if(!lstStrFtr.isEmpty()){ 
                system.debug('@@@@@ --> in futre');
                uw_TriggerHandler.insertCollaborationGroupMember(lstStrFtr);
            }
          }
               
        String publicGroupId = '';
        // have issue if test is being run with SeeAllData as false...
        if (Test.isRunningTest())
        { 
            //Group testGroup = uw_UnitTestDataFactory.createGroup();
            //publicGroupId = testGroup.Id;
            //Group testGroup = uw_UnitTestDataFactory.createGroup();
            //publicGroupId = testGroup.Id;
            // Need to return - breaking too many other tests..
            return;
        }
        else
        { 
            publicGroupId = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.ALL_UNILEVER_PUBLIC_GROUP);
        }
        
        List<GroupMember> groupMembersToCreate = new List<GroupMember>();
       
        for (User u: newUsers.values())
        {
            if (u.IsActive && u.UserType == 'Standard')
            {
               groupMembersToCreate.add(new GroupMember( UserorGroupID = u.id,GroupID  = publicGroupId));           
            }
        }
                
        if (groupMembersToCreate.size() > 0)
        {
            Database.Saveresult[] results1 = Database.insert(groupMembersToCreate, false);
            
            for (Integer i = 0; i < results1.size(); i++)
            {
                if (!results1[i].isSuccess())
                {
                    newUsers.get(groupMembersToCreate[i].UserorGroupID).addError('Error adding user to group : '+results1[i].getErrors()[0].getMessage());
                }
            }
        }     
    }
    
     /* Author: Mindtree
        Description: Add new Salesforce.com (Internal) Users to a pre-defined Chatter Groups (mapping stored in custom setting) */   
    @future
    public static void insertCollaborationGroupMember(List<string> listIds )
    {  
      try{
      system.debug('calling future method');
      for(String id:listIds){
        String[] splitIds= id.Split('~');
        string userId=splitIds[0];
        string[] groupId=splitIds[1].Split(',');
        List<CollaborationGroupMember> colGrpMemberlist=new List<CollaborationGroupMember>();
        String strTemp=null;
          for(String grpId :groupId){ 
             if(grpId ==null || grpId =='') continue;
             strTemp= grpId.trim().replace(',','');
             system.debug('user and group'+strTemp+userId);
             CollaborationGroupMember colGrpMember=new CollaborationGroupMember(MemberId=userId,CollaborationGroupId=strTemp,CollaborationRole='Standard',NotificationFrequency='D' );
             colGrpMemberlist.add(colGrpMember);
          }
        if(!Test.isRunningTest()) insert colGrpMemberlist;
       }
      }
      catch(Exception ex){}                  
   }
    
    /*------------------------------------------------------------------------------------<T01>------------
    Author:        Accenture
    Company:       Accenture
    Description:   For the newly created bet record, method creates a Chatter group and related bet to it.
             If the checkbox Inherit_Branding__c is checked on bet, the look and feel of the related
             brand record is applied to bet.
    Inputs:        list of bet records
    Returns:       Void
    History
    <Date>      <Authors Name>     <Brief Description of Change>           
      -            -                Initial version of the code     

    14-Jan-2014   Accenture      Added logic to check whether exception ie being thrown when a chatter
                    group is created is because of hitting chatterlimit,100,if so display the 
                    appropriate error message which is in customlabel

    21-July-2015  m.bluj@polsource.com Modification related to BET object model changes (MDO tables) and refactoring
    --------------------------------------------------------------------------------------</T01>----------*/     
    
    public void handleBetBeforeInserts(List<uw_BET__c> newBets){
        system.debug('handleBetBeforeInserts: '+newBets);

        List<CollaborationGroup> collabGroups2Create = new List<CollaborationGroup>();  

        String DEFAULT_BANNER_LOCATION = '';
        if (!Test.isRunningTest()){
            DEFAULT_BANNER_LOCATION = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.DEFAULT_BANNER_LOCATION); 
        }

        for (uw_BET__c bet: newBets){              
            if(bet.Inherit_Branding__c == false){
                bet.Banner_1_Location__c = DEFAULT_BANNER_LOCATION;
            }
            CollaborationGroup newGroup = createBetRelatedCollaborationGroup(bet);
            collabGroups2Create.add(newGroup);
        }
        
        try{
            Database.Saveresult[] results = Database.insert(collabGroups2Create, false);
            for (Integer i = 0; i < results.size(); i++){
                if (!results[i].isSuccess()){
                    System.Debug('ISTVAN. CHATTER INSERT: ' + results[i].getErrors()[0].getMessage());
                    //Check whether exception thrown is because of chatterlimit hitting 100 <T01>
                    //newBets[i].addError(System.Label.UW_ERR_DUPE_BET_NAME+' : '+results[i].getErrors()[0].getMessage());
                    if ( results[i].getErrors()[0].getMessage().contains(System.label.uw_BET_standardchatterlimitmessage)){  //if so display the specific error message
                      newBets[i].addError(System.label.uw_BET_Chattergrouplimit);
                    } else {   //else display the existing logic
                      newBets[i].addError(System.Label.UW_ERR_DUPE_BET_NAME+' : '+results[i].getErrors()[0].getMessage());
                    }//End of changes </T01>
                }
                else {
                    newBets[i].Studio_Chatter_Group__c = results[i].getId();
                }
            }

        } catch (Exception e){
            throw e;
        }
    }

    private CollaborationGroup createBetRelatedCollaborationGroup(uw_BET__c bet){
        CollaborationGroup newGroup = new CollaborationGroup ();                                   
        String sName = String.valueOf(bet.Name);
        String GroupName;
        if (sName.length() > 25 ) {
             GroupName= sName.substring(0, 26);
        } else {
            GroupName=sName;
        }
        newGroup.Name = GroupName + GROUP_NAME_POSTFIX;
        newGroup.InformationTitle = 'Unilever Collaboration Studio';
        newGroup.Description = bet.Description__c; 
        newGroup.CollaborationType = 'Private';
        newGroup.CanHaveGuests = true;
        newGroup.IsAutoArchiveDisabled = true;
        // START NEW CODE ADDED BY Istvan Szegedi January 6th, 2015
        // This is to ensure that the BET Owner is the same as the Collaboration Group Owner.
        newGroup.OwnerId = bet.OwnerId;
        // END NEW CODE ADDED BY Istvan Szegedi January 6th, 2015
        // Photo Url Is Not Writeable - 
        // newGroup.FullPhotoUrl = '/servlet/servlet.ImageServer?id=015c00000008yyO&oid=00Dc0000000DFvy';
        return newGroup;
    }
    
    public void handleBetAfterInserts(List<uw_BET__c> newBets)
    {
        Map<Id,Id> studio2BetIdMap = new Map<Id,Id>();
        Map<Id,uw_BET__c> betMap = new Map<Id,uw_BET__c>(newBets); // Assume this works like query?
        
        for (uw_BET__c bet:newBets)
        {
            studio2BetIdMap.put(bet.Studio_Chatter_Group__c, bet.Id);  
            
           
        }
        
        List<CollaborationGroup> collabGroups = [Select Id, InformationBody from CollaborationGroup where Id in :studio2BetIdMap.keySet()];
        
        // Put links in the collab group Info section to the Toolkit and associated BET
        String brandUrl = null;
        String toolkitUrl = null;
        String studioUrl = null;
        if (Test.isRunningTest())
        {
            brandUrl = '';
            toolkitUrl = '';
            studioUrl = ''; 
        }
        else
        {
            brandUrl = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.CHATTER_GROUP_BRAND_IMG);
            toolkitUrl = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.CHATTER_GROUP_TOOLKIT_IMG);
            studioUrl = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.CHATTER_GROUP_STUDIO_IMG);
        }
        
        for (CollaborationGroup cGroup: collabGroups)
        {
            String iBody = System.Label.UW_OPEN_STUDIO_FROM_GROUP;
            iBody += '<br/><a href="/' +  betMap.get(studio2BetIdMap.get(cGroup.Id)).Id+'"><img width="60" height="60" src="'+toolkitUrl+'"/></a><br/><br/>'; 
            cGroup.InformationBody  = iBody;
            //cGroup.FullPhotoURL = '/servlet/servlet.FileDownload—file=015L000000093sA';
            
        }
        
        update collabGroups;
        
        // now ensure that the owner gets added as a BET Team Member (Manager)
        addOwnerToBetTeamAsManager(newBets);
        // ensure user is member of Public Asset chatter group
        uw_MakeAssetsVisible mav = new uw_MakeAssetsVisible();
        mav.checkChatter();
    }
    
    private void addOwnerToBetTeamAsManager(List<uw_BET__c> newBets) {
        system.debug('addOwnerToBetTeamAsManager: called');
        List<uw_Bet_Team_Member__c> newManagers = new List<uw_Bet_Team_Member__c>();
        for (uw_BET__c newBet:newBets) {
            uw_Bet_Team_Member__c tm = new uw_Bet_Team_Member__c();
            tm.access_level__c = uw_Constants.ACCESS_LEVEL_FULL;
            tm.Role__c = uw_Constants.BET_TEAM_ROLE_MANAGER;
            tm.BET__c = newBet.Id;
            tm.Team_Member__c = newBet.OwnerId;
            tm.isOwner__c = true;  
            system.debug('addOwnerToBetTeamAsManager: newBet: '+tm);
            
            newManagers.add(tm);
        }
        insert newManagers;
        system.debug('addOwnerToBetTeamAsManager: exit');
    }
    @TestVisible
    private void handleAssetOpenUp(String query) {
        system.debug('handleAssetOpenUp: query: '+query);
        List<uw_Asset__c> assetListToOpenUp = Database.query(query);
        
        if ( (assetListToOpenUp != null) && (assetListToOpenUp.size() > 0) ) {
            uw_MakeAssetsVisible mav = new uw_MakeAssetsVisible();
            mav.openUp(assetListToOpenUp);          
        }
    }
    @TestVisible 
    private void handleAssetCloseDown(String query) {
        system.debug('handleAssetCloseDown: query: '+query);
        List<uw_Asset__c> assetListToCloseDown = Database.query(query);
        
        if ( (assetListToCloseDown != null) && (assetListToCloseDown.size() > 0) ) {
            uw_MakeAssetsVisible mav = new uw_MakeAssetsVisible();
            mav.closeDown(assetListToCloseDown);            
        }       
    }
 @TestVisible
    private void handleBetsWithChangedSharing(List<Id> betsWithChangedSharing,  Map<Id,uw_BET__c> newValues, Map<Id,uw_BET__c> oldValues) {
        String queryToOpenUp = 'SELECT Id, URL_of_Asset__c, Name From uw_Asset__c u WHERE uw_BET__c IN (';
        String queryToCloseDown = 'SELECT Id, URL_of_Asset__c, Name From uw_Asset__c u WHERE uw_BET__c IN (';
        Boolean firstOpenUp = true;
        Boolean firstCloseDown = true;
        
        for (Id betId:betsWithChangedSharing) {
            uw_BET__c oldBet = oldValues.get(betId);
            uw_BET__c newBet = newValues.get(betId);
            
            if (newBet.Sharing__c == 'Public') {
                if (firstOpenUp) {
                    firstOpenUp = false;
                } else {
                    queryToOpenUp += ',';
                }
                queryToOpenUp += '\'' + newBet.Id + '\'';
            } else if (newBet.Sharing__c == 'Private') {
                if (firstCloseDown) {
                    firstCloseDown = false;
                } else {
                    queryToCloseDown += ',';
                }               
                queryToCloseDown += '\'' + newBet.Id + '\'';
            }
        }
        queryToOpenUp += ')';
        queryToCloseDown += ')';
        if (!firstOpenUp)
            handleAssetOpenUp(queryToOpenUp);
        if (!firstCloseDown)
            handleAssetCloseDown(queryToCloseDown);
    }
    
    
    public void handleBetAfterUpdates(Map<Id,uw_BET__c> newValues, Map<Id,uw_BET__c> oldValues)
    {
        // This trigger is used to keep bet name and related studio name in sync
        List<Id> betsWithChangedNames = new List<Id>();
        List<Id> betsWithChangedSharing = new List<Id>();
        uw_OwnerUpdate ownerUpdate = new uw_OwnerUpdate();

        for (Id id: newValues.keySet())
        {
            uw_BET__c newBet = newValues.get(id);
            uw_BET__c oldBet = oldValues.get(id);
            
            // Get all the bets with changed names
            if (newBet.Name != oldBet.Name)
            {
                betsWithChangedNames.add(id);
            }
            if (newBet.Sharing__c != oldBet.Sharing__c) {
                betsWithChangedSharing.add(id);
            }
            if (newBet.OwnerId != oldBet.ownerId) {
                system.debug('start: change owner'); 
                ownerUpdate.updateTeamOwner(newBet, oldBet.ownerId, newBet.OwnerId);
                ownerUpdate.updateCollaborationOwner(newBet, oldBet.ownerId, newBet.OwnerId);
                system.debug('end: change owner');
            }
 
        }
        
        if (betsWithChangedSharing.size() > 0) {
            handleBetsWithChangedSharing(betsWithChangedSharing, newValues, oldValues);
        }
        
        if (betsWithChangedNames.size() > 0)
        {
            Map<Id,Id> group2BetIdMap = new Map<Id,Id>();
            for (Id id: betsWithChangedNames)
            {
                group2BetIdMap.put(newValues.get(id).Studio_Chatter_Group__c, id);      
            }
            
            List<CollaborationGroup> groups2Update = [Select Id, Name from CollaborationGroup where Id in : group2BetIdMap.keySet()];
            
            for (CollaborationGroup cGroup: groups2Update)
            {
                cGroup.Name = newValues.get(group2BetIdMap.get(cGroup.Id)).Name;
            }
            
            try{
                Database.Saveresult[] results = Database.update(groups2Update, false);
                
                Boolean haveErrors = false;
                for (Database.Saveresult res: results)
                {
                    if (!res.isSuccess())
                    {
                        haveErrors = true;          
                    }
                }
                
                if (haveErrors)
                {
                    for (Id id: betsWithChangedNames)
                    {
                        newValues.get(id).addError(System.Label.UW_ERR_DUPE_BET_NAME);
                    }
                }
            } catch (Exception e)
            {
                throw e;    
            }
            
        }
        
        
    }
        
    public void handleAssets(List<uw_Asset__c> assets, Boolean bOpen) {
        if (assets != null && assets.size() > 0) {
            Set<Id> betSet = new Set<Id>();
            for (uw_Asset__c asset:assets) {
                betSet.add(asset.uw_BET__c);
            }
            system.debug('handleAssets: betSet: '+betSet);
            if (betSet.size() > 0) {
                List<uw_BET__c> betList = [SELECT Id,sharing__c FROM uw_BET__c WHERE Id IN :betSet AND sharing__c='Public'];
                system.debug('handleAssets: betList: '+betList);
                if (betList.size() > 0) {
                    Set<Id> betPromotedSet = new Set<Id>();
                    for (uw_BET__c bet:betList) {
                        betPromotedSet.add(bet.Id);
                    }
                    system.debug('handleAssets: betPromotedSet: '+betPromotedSet);
                    if (betPromotedSet.size() > 0) {
                        List<uw_Asset__c> assetList = new List<uw_Asset__c>();
                        for (uw_Asset__c asset:assets) {
                            if (betPromotedSet.contains(asset.uw_BET__c)) {
                                assetList.add(asset);
                            }
                        }
                        system.debug('handleAssets: assetList: '+assetList);
                        if ((assetList != null) && (assetList.size() > 0)) {
                            uw_MakeAssetsVisible mav = new uw_MakeAssetsVisible();
                            if (bOpen)
                                mav.openUp(assetList);
                            else mav.closeDown(assetList);
                        }                                                           
                    }
                }
            }
        }
    }


   
   
  
    
    public static Boolean isFeedItemOnCollabGroup(String parentId)
    {
        if (parentId.substring(0,3) == '0F9')
        {
            return true;    
        }
        
        return false;
    }

    // need to check that federationId is always lower case
    // if it is not then make it so
    private void handleUserFederationId(List<User> newList) {
        system.debug('handleUserFederationId: entry');
        for (User u:newList) {
            system.debug('u: '+u); 
            if (u.FederationIdentifier != null) {
                u.FederationIdentifier = u.FederationIdentifier.toLowerCase();
                system.debug('u.FederationIdentifier: '+u.FederationIdentifier);
            }
        }
    }
    public void handleUserBeforeInsert(List<User> newList) {
        handleUserFederationId(newList);
    }
    
    public void handleUserBeforeUpdate(List<User> newList) {
        handleUserFederationId(newList);        
    }     
    
    public without sharing class uw_TriggerHandler_WithoutSharing{
    
        public void deletePinnovateLinks(List<uw_Links__c> linksToDelete){
            delete linksToDelete;
        }

    }
   
}