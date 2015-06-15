/**********************************************************************
Name: BET_PresentationBatch 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class for populating presentation id for existing BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          21/01/2015      INITIAL DEVELOPMENT
**********************************************************************/
global class BET_PresentationBatch implements Database.Batchable<uw_BET__c> {
    global final String query;
    
    global Iterable<uw_BET__c> start(Database.batchableContext BC){
        System.Debug('***BET_SoslFieldsBatch start invoked***');
        // LIMIT value below in SOQL is subject to how many BETs we have in the Production system
        List<uw_BET__c> betList = [SELECT 
                Id, Presentation_id__c, 
                (SELECT Id, Related_Feed_Item__c
                    FROM Assets__r
                    WHERE 
                        Big_Think_Pack__c = true
                        AND promoted__c = true
                    ORDER BY Think_Big_Promotion_Date__c
                    DESC LIMIT 1)
            FROM uw_BET__c
            WHERE Presentation_id__c = null
            LIMIT 20000];  
        return betList; 
    }

    global void execute(Database.BatchableContext BC, List<uw_BET__c> scope) {
        //we have to create temporary private chatter group and shared modified feedItem attachments with this group.
        //in other case we will not ahve access to the contentVersion Object
        CollaborationGroup g = new CollaborationGroup(Name='groupNamasasasassasase1231231', CollaborationType='Private');
        g.OwnerId = UserInfo.getUserId() ;
        insert g;

        List<uw_BET__c> betList = new List<uw_BET__c>();
        Map<Id, Id> feedItemIdToContentVersionId = new Map<Id, Id>();
        Map<Id, Id> contentVersionIdToContentDocumentId = new Map<Id, Id>();
        Set<Id> feedItemIds = new Set<Id>();
        List<FeedItem> tmpFeedItems = new List<FeedItem>();
        for(uw_BET__c bet : scope){
            if(bet.assets__r != null && bet.assets__r.size()==1 && String.isNotBlank(bet.assets__r[0].Related_Feed_Item__c)) {
                feedItemIds.add(bet.assets__r[0].Related_Feed_Item__c);
            }
        }
system.debug(feedItemIds);
        //get content version Id object related to feed item
        for (CollaborationGroupFeed f: [SELECT Id, RelatedRecordId, Type FROM CollaborationGroupFeed WHERE Id =: feedItemIds AND Type = 'ContentPost']){
            if (f.RelatedRecordId == null) {
                continue;
            }
            tmpFeedItems.add(new FeedItem(
                RelatedRecordId= f.RelatedRecordId,
                Type = f.Type,
                parentId = g.Id
            ));
            feedItemIdToContentVersionId.put(f.Id, f.RelatedRecordId);
        }
        insert tmpFeedItems;
system.debug(feedItemIdToContentVersionId);
        //get content document id related to the contentVerion
        Set<Id> relatedRecordIds = new Set<id>();
        relatedRecordIds.addAll(feedItemIdToContentVersionId.values());
        for (ContentVersion cv : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: relatedRecordIds]) {
            contentVersionIdToContentDocumentId.put(cv.Id, cv.ContentDocumentId);
system.debug('-----in');            
        }

system.debug(contentVersionIdToContentDocumentId);       
        //populate presentation Id if there is a content Document object related to the feed item
        Id feedItemId;
        Id contentVersionId;
        for(uw_BET__c bet : scope){
            if(bet.assets__r != null && bet.assets__r.size()==1 && String.isNotBlank(bet.assets__r[0].Related_Feed_Item__c)) {
                feedItemId = bet.assets__r[0].Related_Feed_Item__c;
                if (feedItemIdToContentVersionId.containsKey(feedItemId)) {
                    contentVersionId = feedItemIdToContentVersionId.get(feedItemId);
                    if (contentVersionIdToContentDocumentId.containsKey(contentVersionId)) {
                        bet.Presentation_Id__c = contentVersionIdToContentDocumentId.get(contentVersionId);
                        betList.add(bet);
                    }
                }
            }
        }

        system.debug(betList);
        if (tmpFeedItems.size()>0) {
            delete tmpFeedItems;
        }
        delete g;
        try {
            update betList;
        }
        catch ( Exception e ) {
            System.Debug('Update BET Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }    
    
    global void finish(Database.BatchableContext BC) {
        System.Debug('***BET_SoslFieldsBatch finish invoked***');
    }
}