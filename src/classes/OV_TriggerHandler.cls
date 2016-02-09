/**********************************************************************
Name: OV_TriggerHandler
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Trigger handler for OV_KPI_Element__c object. Class is depracated!!! Not in use because of new pattern of writing triggers
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             25/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_TriggerHandler {
    public Static Boolean disableTrigger = false;

    public void handleKPIElementAfterUpdates(List<OV_KPI_Element__c> newValues, List<OV_KPI_Element__c> oldValues) {
        Set<Id> kpiElementIds = new Set<Id>();    
        for(Integer i=0; i< newValues.size(); i++){
            OV_KPI_Element__c newRecord = newValues[i];
            kpiElementIds.add(newRecord.Id);
        }
        
        List<OV_KPI_Element_Interest__c> kpiElementInterests = [SELECT Id, KPI_Element__c, User__r.User__c, Wants_Notifications__c, Chatter_Message__c FROM OV_KPI_Element_Interest__c WHERE KPI_Element__c IN :kpiElementIds AND Wants_Notifications__c = true];
        Map<Id, List<OV_KPI_Element_Interest__c> > elementIdToInterests = new Map<Id, List<OV_KPI_Element_Interest__c> >();
        
        for(OV_KPI_Element_Interest__c interest : kpiElementInterests){
            if(elementIdToInterests.containsKey(interest.KPI_Element__c)){
                List<OV_KPI_Element_Interest__c> interests = elementIdToInterests.get(interest.KPI_Element__c);
                interests.add(interest);
            }else{
                List<OV_KPI_Element_Interest__c> interests = new List<OV_KPI_Element_Interest__c>();
                interests.add(interest);
                elementIdToInterests.put(interest.KPI_Element__c, interests);
            }            
        }

        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

        Integer dmlLimit = Limits.getLimitDmlStatements();
        for(Integer i=0; i< newValues.size(); i++){
            OV_KPI_Element__c newRecord = newValues[i];

            if(elementIdToInterests.containsKey(newRecord.Id)){
                List<OV_KPI_Element_Interest__c> eList = elementIdToInterests.get(newRecord.Id);

                for(OV_KPI_Element_Interest__c e : eList){

                    ConnectApi.FeedItemInput input = createKpiUpdateNotification(e);

                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
                    batchInputs.add(batchInput);         
                }
            }
        }  

        List<List<ConnectApi.BatchInput>> listOfPacs = new List<List<ConnectApi.BatchInput>>();
        List<ConnectApi.BatchInput> pack = new List<ConnectApi.BatchInput>();
        for(Integer j=0;j<batchInputs.size();j++){
            pack.add(batchInputs[j]);
            if( j > 0  && Math.mod(j, 500) == 0 ){
                listOfPacs.add(pack);
                pack = new List<ConnectApi.BatchInput>();
            }
        }
        if(pack.size() < 500){
            listOfPacs.add(pack);
        }
        

        for(List<ConnectApi.BatchInput> p : listOfPacs){
            if(Limits.getDmlStatements() < dmlLimit){
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), p);
            }
        }
    }

    private ConnectApi.FeedItemInput createKpiUpdateNotification(OV_KPI_Element_Interest__c interest) {

        //experimental 
        /*
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        ConnectApi.ContentCapabilityInput contentCapabilityInput = new ConnectApi.ContentCapabilityInput();
        feedElementCapabilitiesInput.content = contentCapabilityInput;
        contentCapabilityInput.contentDocumentId = '069c0000000Ajz4';
        */

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.subjectId = interest.Id;

        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        // Maciej, I put the mention first
        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = interest.User__r.User__c;
        body.messageSegments.add(mentionSegment);

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        // Maciej I changed this
        //textSegment.text = 'KPI Element '+ newRecord.Id + ' modified.';
        textSegment.text = '\n ' + interest.Chatter_Message__c;

        body.messageSegments.add(textSegment);

        input.body = body;

        //experimental
        //input.capabilities = feedElementCapabilitiesInput;

        return input;
    }

    public void handleNewVersionOfReport(List<OV_ContentProxy__c> newValues, List<OV_ContentProxy__c> oldValues) {
        Set<Id> contentVersionIds = new Set<Id>();
        Set<Id> contentProxyIds = new Set<Id>();

        for(Integer i=0; i< newValues.size(); i++){
            OV_ContentProxy__c newRecord = newValues[i];
            OV_ContentProxy__c oldRecord = oldValues[i];

            if(oldRecord.LatestContentVersionId__c != newRecord.LatestContentVersionId__c){
                contentVersionIds.add(newRecord.LatestContentVersionId__c);
                contentProxyIds.add(newRecord.Id);
            }
        }

        List<OV_Report__c> reports = [SELECT Id, Chatter_Update_Message__c, Chatter_Delete_Message__c FROM OV_Report__c WHERE Desktop_Content_Proxy__c IN :contentProxyIds OR Mobile_Content_Proxy__c IN :contentProxyIds OR Tablet_Content_Proxy__c IN :contentProxyIds];
        Set<Id> reportsIds = new Set<Id>();
        for(OV_Report__c r : reports){
            reportsIds.add(r.Id);
        }

        List<OV_Report_Favourite__c> reportsFavourites = [SELECT Id, Chatter_Update_Message__c, Chatter_Delete_Message__c FROM OV_Report_Favourite__c WHERE Report__c IN :reportsIds];

        Map<Id, OV_Report_Favourite__c> favouriteMap = new Map<Id, OV_Report_Favourite__c>();
        for(OV_Report_Favourite__c repFav : reportsFavourites){
            favouriteMap.put(repFav.Id, repFav);
        }
        

        List<EntitySubscription> myEntities = [SELECT ParentId, SubscriberId FROM EntitySubscription WHERE ParentId IN :favouriteMap.keySet() LIMIT 1000];
        Set<Id> myEntitiesReportsIds = new Set<Id>();
        
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

        Integer dmlLimit = Limits.getLimitDmlStatements(); 
        for(EntitySubscription e : myEntities){
            ConnectApi.FeedItemInput input = createReportUpdateNotification(e, favouriteMap);

            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
            batchInputs.add(batchInput);      
        }

        List<List<ConnectApi.BatchInput>> listOfPacs = new List<List<ConnectApi.BatchInput>>();
        List<ConnectApi.BatchInput> pack = new List<ConnectApi.BatchInput>();
        for(Integer j=0;j<batchInputs.size();j++){
            pack.add(batchInputs[j]);
            if( j > 0  && Math.mod(j, 500) == 0 ){
                listOfPacs.add(pack);
                pack = new List<ConnectApi.BatchInput>();
            }
        }
        if(pack.size() < 500){
            listOfPacs.add(pack);
        }
        

        for(List<ConnectApi.BatchInput> p : listOfPacs){
            if(Limits.getDmlStatements() < dmlLimit){
                if(! Test.isRunningTest()){ 
                    ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), p);
                }
            }
        }        
    }    

    private ConnectApi.FeedItemInput createReportNotification(EntitySubscription entity,  Map<Id, OV_Report_Favourite__c> favouriteMap, String type) {
        String field;
        if(type == 'Update'){
           field = favouriteMap.get(entity.ParentId).Chatter_Update_Message__c; 
        }else{
            field = favouriteMap.get(entity.ParentId).Chatter_Delete_Message__c; 
        }

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.subjectId = entity.ParentId;

        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = entity.subscriberId;
        body.messageSegments.add(mentionSegment);

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();

        textSegment.text = '\n ' + field;

        body.messageSegments.add(textSegment);

        input.body = body;

        return input;

    }

    private ConnectApi.FeedItemInput createReportDeleteNotification(EntitySubscription entity,  Map<Id, OV_Report_Favourite__c> favouriteMap) {
        return createReportNotification(entity, favouriteMap, 'Delete');
    }

    private ConnectApi.FeedItemInput createReportUpdateNotification(EntitySubscription entity,  Map<Id, OV_Report_Favourite__c> favouriteMap) {
        return createReportNotification(entity, favouriteMap, 'Update');
    }

    public void handleContentDocumentChanges(List<ContentDocument> newValues, List<ContentDocument> oldValues) { 
        if(disableTrigger){
            return;
        }
        Set<Id> contentVersionIds = new Set<Id>();
        Set<Id> contentDocumentIds = new Set<Id>();

        Id oneViewRecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get('One View').getRecordTypeId();

        for(Integer i=0; i< newValues.size(); i++){
            ContentDocument newRecord = newValues[i];
            ContentDocument oldRecord = oldValues[i];

            if(newRecord != null && ((oldRecord != null && oldRecord.LatestPublishedVersionId == null && oldRecord.LatestPublishedVersionId != newRecord.LatestPublishedVersionId) || newRecord.PublishStatus == 'P')){
                contentVersionIds.add(newRecord.LatestPublishedVersionId);
                contentDocumentIds.add(newRecord.Id);
            }
        }

        List<ContentVersion> contentVersions = [SELECT Id, Title, ContentUrl, RecordTypeId, FirstPublishLocationId FROM ContentVersion WHERE Id IN :contentVersionIds];
        Map<Id, ContentVersion> contentVersionsMap = new Map<Id, ContentVersion>();
        for(ContentVersion cv : contentVersions){
            contentVersionsMap.put(cv.Id, cv);
        }

        List<OV_ContentProxy__c> contentProxies = [SELECT Id, ContentDocumentId__c FROM OV_ContentProxy__c WHERE ContentDocumentId__c IN :contentDocumentIds];
        Map<Id, OV_ContentProxy__c> contentProxiesMap = new Map<Id, OV_ContentProxy__c>();
        for(OV_ContentProxy__c cp : contentProxies){
            contentProxiesMap.put(Id.valueOf(cp.ContentDocumentId__c), cp);
        }

        List<OV_ContentProxy__c> proxiesToUpsert = new List<OV_ContentProxy__c>();
        for(Integer i=0; i< newValues.size(); i++){
            ContentDocument newRecord = newValues[i];
            ContentDocument oldRecord = oldValues[i];
           
            if(newRecord != null && contentVersionsMap.containsKey(newRecord.LatestPublishedVersionId) && contentVersionsMap.get(newRecord.LatestPublishedVersionId).RecordTypeId == oneViewRecordTypeId){

                ContentVersion tmpContentVersion;
                OV_ContentProxy__c proxy;

                if(oldRecord != null && oldRecord.LatestPublishedVersionId == null && oldRecord.LatestPublishedVersionId != newRecord.LatestPublishedVersionId && newRecord.PublishStatus == 'P'){
                    tmpContentVersion = contentVersionsMap.get(newRecord.LatestPublishedVersionId);
                    //new proxy
                    proxy = new OV_ContentProxy__c();
                   
                }else if(newRecord.PublishStatus == 'P'){
                    tmpContentVersion = contentVersionsMap.get(newRecord.LatestPublishedVersionId);
                    //update proxy
                    proxy = contentProxiesMap.get(newRecord.Id);
                }else{
                    tmpContentVersion = null;
                    proxy = null;
                }

                if(proxy != null){
                    proxy.Name = tmpContentVersion.Title.abbreviate(80);
                    proxy.Url__c = (tmpContentVersion.ContentUrl != null && tmpContentVersion.ContentUrl != '') ? tmpContentVersion.ContentUrl : '';
                    proxy.Title__c = tmpContentVersion.Title;
                    proxy.LatestContentVersionId__c = newRecord.LatestPublishedVersionId;   
                    proxy.ContentDocumentId__c = newRecord.Id;
                    proxiesToUpsert.add(proxy);
                }        
            }            
        }

        upsert proxiesToUpsert;

        /* commented because of Content_Proxy_ID__c field has been removed
        List<ContentVersion> contentVersionListToUpdate = new List<ContentVersion>();
        for(OV_ContentProxy__c uProxy : proxiesToUpsert){
            if(contentVersionsMap.containsKey(Id.valueOf(uProxy.LatestContentVersionId__c))){
                ContentVersion cVersion = contentVersionsMap.get(Id.valueOf(uProxy.LatestContentVersionId__c));
                cVersion.Content_Proxy_ID__c = uProxy.Id;
                contentVersionListToUpdate.add(cVersion);
                system.debug('___________'+cVersion);
            }
        }
        disableTrigger = true;
        system.debug('_______________________BEFORE '+contentVersionListToUpdate);
        update contentVersionListToUpdate;
        disableTrigger = false;
        */
    }   

    public void handleContentDocumentDelete(List<ContentDocument> oldValues) { 
        Set<Id> contentDocumentIds = new Set<Id>();

        for(Integer i=0; i< oldValues.size(); i++){
            contentDocumentIds.add(oldValues[i].Id);
        }

        List<OV_ContentProxy__c> contentProxies = [SELECT Id FROM OV_ContentProxy__c WHERE ContentDocumentId__c IN :contentDocumentIds];
        Set<Id> contentProxiesIds = new Set<Id>();
        for(OV_ContentProxy__c c : contentProxies){
            contentProxiesIds.add(c.Id);
        }
        ////notification
        List<OV_Report__c> reports = [SELECT Id, Chatter_Delete_Message__c FROM OV_Report__c WHERE Desktop_Content_Proxy__c IN :contentProxiesIds OR Mobile_Content_Proxy__c IN :contentProxiesIds OR Tablet_Content_Proxy__c IN :contentProxiesIds];

        Set<Id> reportsIds = new Set<Id>();
        for(OV_Report__c r : reports){
            reportsIds.add(r.Id);
        }

        List<OV_Report_Favourite__c> reportsFavourites = [SELECT Id, Chatter_Update_Message__c, Chatter_Delete_Message__c FROM OV_Report_Favourite__c WHERE Report__c IN :reportsIds];

        Map<Id, OV_Report_Favourite__c> favouriteMap = new Map<Id, OV_Report_Favourite__c>();
        for(OV_Report_Favourite__c repFav : reportsFavourites){
            favouriteMap.put(repFav.Id, repFav);
        }

        List<EntitySubscription> myEntities = [SELECT ParentId, SubscriberId FROM EntitySubscription WHERE ParentId IN :favouriteMap.keySet() LIMIT 1000];
        Set<Id> myEntitiesReportsIds = new Set<Id>();
        
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

        Integer dmlLimit = Limits.getLimitDmlStatements(); 
        for(EntitySubscription e : myEntities){
            ConnectApi.FeedItemInput input = createReportDeleteNotification(e, favouriteMap);

            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
            batchInputs.add(batchInput);      
        }

        List<List<ConnectApi.BatchInput>> listOfPacs = new List<List<ConnectApi.BatchInput>>();
        List<ConnectApi.BatchInput> pack = new List<ConnectApi.BatchInput>();
        for(Integer j=0;j<batchInputs.size();j++){
            pack.add(batchInputs[j]);
            if( j > 0  && Math.mod(j, 500) == 0 ){
                listOfPacs.add(pack);
                pack = new List<ConnectApi.BatchInput>();
            }
        }
        if(pack.size() < 500){
            listOfPacs.add(pack);
        }
        

        for(List<ConnectApi.BatchInput> p : listOfPacs){
            if(Limits.getDmlStatements() < dmlLimit){
                if(! Test.isRunningTest()){ 
                    ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), p);
                }
            }
        }      

        delete contentProxies;
    }

    public void handleContentDocumentUndelete(List<ContentDocument> newValues) { 
        Set<Id> contentDocumentIds = new Set<Id>();
        for(Integer i=0; i< newValues.size(); i++){
            contentDocumentIds.add(newValues[i].Id);
        }

        List<ContentVersion> contentVersionListToUpdate = [SELECT Id, Title, ContentUrl, ContentDocumentId FROM ContentVersion WHERE IsLatest = true AND ContentDocumentId = :contentDocumentIds];

        List<OV_ContentProxy__c> proxies = new List<OV_ContentProxy__c>();
        for(ContentVersion c : contentVersionListToUpdate){
            OV_ContentProxy__c proxy = new OV_ContentProxy__c();
            proxy.Name = c.Title.abbreviate(80);
            proxy.Url__c = (c != null && c.ContentUrl != null && c.ContentUrl != '') ? c.ContentUrl : '';
            proxy.Title__c = c.Title;
            proxy.LatestContentVersionId__c = c.Id;   
            proxy.ContentDocumentId__c = c.ContentDocumentId;
            proxies.add(proxy);
        }

        insert proxies;

        Map<Id, Id> idContentVersionToIdProxyMap = new Map<Id, Id>();
        for(OV_ContentProxy__c p : proxies){
            idContentVersionToIdProxyMap.put(p.LatestContentVersionId__c, p.Id);
        }

        /* commented because of Content_Proxy_ID__c field has been removed
        for(ContentVersion c : contentVersionListToUpdate){
            c.Content_Proxy_ID__c = idContentVersionToIdProxyMap.get(c.Id);
        }
        */

        update contentVersionListToUpdate;
    }
}