/**********************************************************************

 Name:  OV_ContentDocumentHandler()

 Copyright © 2015  Salesforce

 ======================================================

======================================================

Purpose:    Trigger Handler for the ContentDocument SObject. This class implements the OV_Trigger
            interface to help ensure the trigger code is bulkified and all in one place.
-------

======================================================

======================================================

History

-------

VERSION  AUTHOR            DATE              DETAIL            Description
1.0   Pawel Niedziela    24/09/2015      INITIAL DEVELOPMENT   Trigger Handler for the ContentDocument SObject.

***********************************************************************/
public with sharing class OV_ContentDocumentHandler implements OV_Trigger{

    List<OV_ContentProxy__c> contentProxiesToDML = new List<OV_ContentProxy__c>();

    Map<Id, ContentVersion> contentVersionIdToObjectMap = new Map<Id, ContentVersion>();
    Map<Id, ContentVersion> contentDocumentToContentVersionsByCdIdMap = new Map<Id, ContentVersion>();

    Map<Id, OV_ContentProxy__c> contentProxyIdToObject = new Map<Id, OV_ContentProxy__c>();
    Map<Id, OV_ContentProxy__c> contentDocumentToContentProxiesMap = new Map<Id, OV_ContentProxy__c>();

    Map<Id, OV_Report__c> reportsMap = new Map<Id, OV_Report__c>();
    Map<Id, OV_Report_Favourite__c> reportsFavouriteMap = new Map<Id, OV_Report_Favourite__c>();
    private Map<Id, List<OV_Report_Favourite__c>> reportIdToReportsFavouritesMap = new Map<Id, List<OV_Report_Favourite__c>>();
    private Map<Id, List<OV_Report__c>> contentProxyToReportsMap = new Map<Id, List<OV_Report__c>>();

    List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
    List<List<ConnectApi.BatchInput>> listOfPacs = new List<List<ConnectApi.BatchInput>>();

    //this handler is never expected to work in bulk mode during non dataload scenarios; due to the nature of CRM content
    public static final Integer QUERY_LIMIT  = 30;


    // Constructor
    public OV_ContentDocumentHandler(){
        System.debug(LoggingLevel.DEBUG, 'Entering OV_ContentDocumentHandler');
    }


    /*******************************************************************

        Purpose:  This method is called prior to execution of a BEFORE trigger. Use this to cacheany data required into maps prior execution of the trigger.

        Parameters: [optional]

        Returns: [optional]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    public void bulkBefore(){
        System.debug(LoggingLevel.DEBUG, 'Entering bulkBefore');
    }

    /*
    This handler is never expected to work in bulk mode during non dataload scenarios; due to the nature of CRM content

    This limit protects against a bulk upload of content scenario, in which case the handler does not need to run.
    In addition <insert custom setting name> allows configuration to disable this handler.

    */
    private Boolean allowQuery(){
        if(Limits.getQueries() < QUERY_LIMIT){
            return true;
        }else{
            return false;
        }
    }

    /*******************************************************************

        Purpose:  This method is called prior to execution of an AFTER trigger. Use this to cache any data required into maps prior execution of the trigger.

        Parameters: [optional]

        Returns: [optional]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    public void bulkAfter(){

        System.debug('Entering bulkAfter');

        if( Trigger.isUndelete){
            if(allowQuery()){
                initRelatedContentVersionWithGivenDocumentIds(Trigger.newMap.keySet());
            }

        }else if( Trigger.isDelete){
            if(allowQuery()){
                initRelatedContentVersionWithGivenDocumentIds(Trigger.oldMap.keySet());
                initRelatedContentProxies(Trigger.oldMap.keySet());

                initRelatedReports();
                initRelatedReportsFavourites();
            }
        }else if( Trigger.isUpdate){
            // start dh temp change for preprod issue:
            // end dh temp change
            if(allowQuery()){
                initRelatedContentVersionAfterUpdate();
                initRelatedContentProxies(Trigger.newMap.keySet());

                initRelatedReports();
                initRelatedReportsFavourites();
            }
        }

        System.debug('Exiting bulkAfter');
    }


    /*******************************************************************

       Purpose:  This method is called iteratively for each record to be inserted during a BEFORE trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.

       Parameters: [SObject]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void beforeInsert(SObject so){
        System.debug(LoggingLevel.DEBUG, 'Entering beforeInsert');
    }


    /*******************************************************************

       Purpose: This method is called iteratively for each record to be updated during a BEFORE trigger.

       Parameters: [SObject, SObject]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void beforeUpdate(SObject oldSo, SObject so){
        System.debug(LoggingLevel.DEBUG, 'Entering beforeUpdate');
    }


    /*******************************************************************

       Purpose: This method is called iteratively for each record to be deleted during a BEFORE trigger.

       Parameters: [SObject]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void beforeDelete(SObject so){
        System.debug(LoggingLevel.DEBUG, 'Entering beforeDelete');
    }


    /*******************************************************************

        Purpose: This method is called iteratively for each record inserted during an AFTER
        trigger. Always put field validation in the 'After' methods in case another trigger
        has modified any values. The record is 'read only' by this point.

       Parameters: [SObject]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void afterInsert(SObject so){
        System.debug(LoggingLevel.DEBUG, 'Entering afterInsert');
    }


    /*******************************************************************

        Purpose: This method is called iteratively for each record updated during an AFTER trigger.

       Parameters: [SObject, SObject]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void afterUpdate(SObject oldSo, SObject so){
        System.debug('Entering afterUpdate: ' + ' oldSo: ' + oldSo + ' so: ' + so);
        // start dh temp change for preprod issue:
        System.debug(LoggingLevel.WARN, 'afterUpdate - entry');
        // end dh temp change

        Id oneViewRecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get('One View').getRecordTypeId();

        ContentDocument newRecord = (ContentDocument)so;
        ContentDocument oldRecord = (ContentDocument)oldSo;

        if(newRecord != null && contentVersionIdToObjectMap.containsKey(newRecord.LatestPublishedVersionId) && contentVersionIdToObjectMap.get(newRecord.LatestPublishedVersionId).RecordTypeId == oneViewRecordTypeId){

            // start dh temp change for preprod issue:
            System.debug(LoggingLevel.WARN, 'afterUpdate - is One View Content');
            // end dh temp change


            ContentVersion tmpContentVersion;
            OV_ContentProxy__c proxy;

            if(oldRecord != null && oldRecord.LatestPublishedVersionId == null && oldRecord.LatestPublishedVersionId != newRecord.LatestPublishedVersionId && newRecord.PublishStatus == 'P'){
                tmpContentVersion = contentVersionIdToObjectMap.get(newRecord.LatestPublishedVersionId);
                    //new proxy
                if(contentDocumentToContentProxiesMap.containsKey(newRecord.Id)){
                    proxy = contentDocumentToContentProxiesMap.get(newRecord.Id);
                }else{
                    proxy = new OV_ContentProxy__c();
                }

            }else if(oldRecord != null && oldRecord.PublishStatus == 'R' && newRecord.PublishStatus == 'P'){
                tmpContentVersion = contentVersionIdToObjectMap.get(newRecord.LatestPublishedVersionId);
                proxy = new OV_ContentProxy__c();
            }else if(newRecord.PublishStatus == 'P'){
                tmpContentVersion = contentVersionIdToObjectMap.get(newRecord.LatestPublishedVersionId);
                    //update proxy
                proxy = contentDocumentToContentProxiesMap.get(newRecord.Id);
            }else{
                tmpContentVersion = null;
                proxy = null;
            }

            if(proxy != null){
                proxy.Name = tmpContentVersion.Title.abbreviate(80);
                proxy.Url__c = (tmpContentVersion != null && tmpContentVersion.ContentUrl != null && tmpContentVersion.ContentUrl != '') ? tmpContentVersion.ContentUrl : '';
                proxy.Title__c = tmpContentVersion.Title;
                proxy.LatestContentVersionId__c = newRecord.LatestPublishedVersionId;
                proxy.ContentDocumentId__c = newRecord.Id;

                contentProxiesToDML.add(proxy);
            }
        }

        System.debug('Exiting afterUpdate');
    }


    /*******************************************************************

        Purpose: This method is called iteratively for each record undeleted during an AFTER trigger.

       Parameters: [SObject ]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void afterUndelete(SObject so){

        System.debug('Entering afterUndelete: ' + ' so: ' + so);

        Id oneViewRecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get('One View').getRecordTypeId();
        System.debug('Entering afterUndelete: rec type' +contentDocumentToContentVersionsByCdIdMap.containsKey(so.Id));

        if(contentDocumentToContentVersionsByCdIdMap.containsKey(so.Id) && contentDocumentToContentVersionsByCdIdMap.get(so.Id).RecordTypeId == oneViewRecordTypeId){
            ContentVersion tmpContentVersion = contentDocumentToContentVersionsByCdIdMap.get(so.Id);
            OV_ContentProxy__c proxy = new OV_ContentProxy__c();
            proxy.Name = tmpContentVersion.Title.abbreviate(80);
            proxy.Url__c = (tmpContentVersion != null && tmpContentVersion.ContentUrl != null && tmpContentVersion.ContentUrl != '') ? tmpContentVersion.ContentUrl : '';
            proxy.Title__c = tmpContentVersion.Title;
            proxy.LatestContentVersionId__c = tmpContentVersion.Id;
            proxy.ContentDocumentId__c = tmpContentVersion.ContentDocumentId;
            contentProxiesToDML.add(proxy);
            System.debug('afterUndelete: contentProxiesToDML:' + contentProxiesToDML);
        }
        System.debug('Exiting afterUndelete');

    }


    /*******************************************************************

        Purpose: This method is called iteratively for each record deleted during an AFTER trigger.

       Parameters: [SObject ]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void afterDelete(SObject so){
        System.debug('Entering afterDelete: ' + ' so: ' + so);

        Id oneViewRecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get('One View').getRecordTypeId();
        System.debug('afterDelete contentDocumentToContentVersionsByCdIdMap: ' + contentDocumentToContentVersionsByCdIdMap);
        OV_ContentProxy__c tmpContentProxy = contentDocumentToContentProxiesMap.get(so.Id);

        if(tmpContentProxy != null){
            contentProxiesToDML.add(tmpContentProxy);

            List<OV_Report__c> tmpReports = contentProxyToReportsMap.get(tmpContentProxy.Id);

            for(OV_Report__c tmpr : tmpReports){
                if(reportIdToReportsFavouritesMap.containsKey(tmpr.Id)){
                    for(OV_Report_Favourite__c tmprepfav : reportIdToReportsFavouritesMap.get(tmpr.Id)){
                        ConnectApi.FeedItemInput input = OV_Utils.generateReportNotification(tmprepfav, 'Delete');

                        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
                        batchInputs.add(batchInput);
                    }
                }
            }
        }


        System.debug('afterDelete contentProxiesToDML: ' + contentProxiesToDML);
        System.debug('afterDelete batchInputs: ' + batchInputs);

        System.debug('Exiting afterDelete');

    }

    /*******************************************************************

        Purpose: This method is called once all records have been processed by the trigger. Use this
                    method to accomplish any final operations such as creation or updates of other records.

       Parameters: [SObject ]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void andFinally(){

        System.debug('Entering andFinally ');

        // start dh temp change for preprod issue:
        System.debug(LoggingLevel.WARN, 'andFinally - entry');
        // end dh temp change

        if(Trigger.isAfter && Trigger.isUpdate){
            upsert contentProxiesToDML;
        }

        if(Trigger.isAfter && Trigger.isDelete){

            System.debug('andFinally contentProxiesToDML: ' + contentProxiesToDML);
            System.debug('andFinally batchInputs: ' + batchInputs);

            if( ! batchInputs.isEmpty() ){
                Integer dmlLimit = Limits.getLimitDmlStatements();
                List<ConnectApi.BatchInput> pack = new List<ConnectApi.BatchInput>();
                for(Integer j = 0; j < batchInputs.size() ; j++){
                    pack.add(batchInputs[j]);
                    if( j > 0  && Math.mod(j, 500) == 0 ){
                        listOfPacs.add(pack);
                        pack = new List<ConnectApi.BatchInput>();
                    }
                }
                if(pack.size() < 500){
                    listOfPacs.add(pack);
                }

                System.debug('andFinally listOfPacs: ' + listOfPacs);

                for(List<ConnectApi.BatchInput> p : listOfPacs){
                    if(Limits.getDmlStatements() < dmlLimit){
                        if(! Test.isRunningTest()){
                            ConnectApi.BatchResult[] result = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), p);
                            System.debug('andFinally result: ' + result);
                        }
                    }
                }
            }

            delete contentProxiesToDML;

        }

        if(Trigger.isAfter && Trigger.isUnDelete){
            System.debug('andFinally AFTER UNDELETE contentProxiesToDML: ' + contentProxiesToDML);

            insert contentProxiesToDML;
        }

        System.debug('Exiting andFinally');
    }


    /*
        ===========Helper methods===================
    */

    /*******************************************************************

        Purpose:  Gathers ContentDocument to ContentVersion map

        Parameters: [contentDocumentIds]

        Returns: [void]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private void initRelatedContentVersionWithGivenDocumentIds(Set<Id> contentDocumentIds){
        System.debug('Entering initRelatedContentVersionWithGivenDocumentIds: ' + ' contentDocumentIds: ' + contentDocumentIds);

        //Set<Id> contentDocumentIds = Trigger.newMap.keySet();

        List<ContentVersion> tmpContentVersions = [SELECT Id, Title, ContentUrl, ContentDocumentId, RecordTypeId FROM ContentVersion WHERE IsLatest = true AND ContentDocumentId IN  :contentDocumentIds];
        System.debug('initRelatedContentVersionWithGivenDocumentIds: tmpContentVersions:  ' + tmpContentVersions);

        for(ContentVersion tmpContentVersion : tmpContentVersions){
            System.debug('initRelatedContentVersionWithGivenDocumentIds: tmpContentVersion:  ' + tmpContentVersion);
            contentDocumentToContentVersionsByCdIdMap.put(tmpContentVersion.ContentDocumentId, tmpContentVersion );

        }

        System.debug('initRelatedContentVersionWithGivenDocumentIds: contentDocumentToContentVersionsByCdIdMap:  ' + contentDocumentToContentVersionsByCdIdMap);

        System.debug('Exiting initRelatedContentVersionWithGivenDocumentIds');
    }

    /*******************************************************************

        Purpose:  Gathers ContentVersion map

        Parameters: [optional]

        Returns: [void]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private void initRelatedContentVersionAfterUpdate(){

        System.debug('Entering initRelatedContentVersionAfterUpdate');

        Set<Id> contentVersionIds = new Set<Id>();

        for(Integer i = 0 ; i < Trigger.new.size() ; i++){
            ContentDocument newRecord = (ContentDocument)Trigger.new[i];
            ContentDocument oldRecord = (ContentDocument)Trigger.old[i];

            if(newRecord != null && ((oldRecord != null && oldRecord.LatestPublishedVersionId == null && oldRecord.LatestPublishedVersionId != newRecord.LatestPublishedVersionId) || newRecord.PublishStatus == 'P')){
                contentVersionIds.add(newRecord.LatestPublishedVersionId);
            }
        }

        List<ContentVersion> tmpContentVersions = [SELECT Id, Title, ContentUrl, ContentDocumentId, RecordTypeId FROM ContentVersion WHERE Id IN :contentVersionIds];

        for(ContentVersion tmpContentVersion : tmpContentVersions){

            contentVersionIdToObjectMap.put(tmpContentVersion.Id, tmpContentVersion);
        }

        System.debug('Exiting initRelatedContentVersionAfterUpdate');

    }


    /*******************************************************************

        Purpose:  Gathers ContentDocument to OV_ContentProxy__c map

        Parameters: [Set<Id> contentDocumentIds]

        Returns: [void]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private void initRelatedContentProxies(Set<Id> contentDocumentIds){
        System.debug('Entering initRelatedContentProxies: ' + ' contentDocumentIds: ' + contentDocumentIds);

        contentProxyIdToObject = new Map<Id, OV_ContentProxy__c>([SELECT Id, ContentDocumentId__c FROM OV_ContentProxy__c WHERE ContentDocumentId__c IN :contentDocumentIds]);

        for(OV_ContentProxy__c tmpContentProxy : contentProxyIdToObject.values()){

            contentDocumentToContentProxiesMap.put(tmpContentProxy.ContentDocumentId__c, tmpContentProxy);

        }


        System.debug('Exiting initRelatedContentProxies ' + ' contentProxyIdToObject: ' + contentProxyIdToObject + ' contentDocumentToContentProxiesMap: ' + contentDocumentToContentProxiesMap);
    }

    /*******************************************************************

        Purpose:  Gathers Reports map and Content Proxy to Reports Map

        Parameters: [optional]

        Returns: [void]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private void initRelatedReports(){
        System.debug('Entering initRelatedReports');

        reportsMap = new Map<Id, OV_Report__c>([SELECT Id, Chatter_Delete_Message__c, Desktop_Content_Proxy__c, Mobile_Content_Proxy__c, Tablet_Content_Proxy__c FROM OV_Report__c WHERE Desktop_Content_Proxy__c IN :contentProxyIdToObject.keySet() OR Mobile_Content_Proxy__c IN :contentProxyIdToObject.keySet() OR Tablet_Content_Proxy__c IN :contentProxyIdToObject.keySet()]);

        System.debug('initRelatedReports reportsMap: ' + reportsMap);

        for(OV_Report__c tmpReport : reportsMap.values()){
            if(tmpReport.Desktop_Content_Proxy__c != null){
                if(contentProxyToReportsMap.containsKey(tmpReport.Desktop_Content_Proxy__c)){
                    contentProxyToReportsMap.get(tmpReport.Desktop_Content_Proxy__c).add(tmpReport);
                }else{
                    List<OV_Report__c> reps = new List<OV_Report__c>{tmpReport};
                    contentProxyToReportsMap.put(tmpReport.Desktop_Content_Proxy__c, reps);

                }
            }else if(tmpReport.Mobile_Content_Proxy__c != null){
                if(contentProxyToReportsMap.containsKey(tmpReport.Mobile_Content_Proxy__c)){
                    contentProxyToReportsMap.get(tmpReport.Mobile_Content_Proxy__c).add(tmpReport);
                }else{
                    List<OV_Report__c> reps = new List<OV_Report__c>{tmpReport};
                    contentProxyToReportsMap.put(tmpReport.Mobile_Content_Proxy__c, reps);
                }
            }else if(tmpReport.Tablet_Content_Proxy__c != null){
                if(contentProxyToReportsMap.containsKey(tmpReport.Tablet_Content_Proxy__c)){
                    contentProxyToReportsMap.get(tmpReport.Tablet_Content_Proxy__c).add(tmpReport);
                }else{
                    List<OV_Report__c> reps = new List<OV_Report__c>{tmpReport};
                    contentProxyToReportsMap.put(tmpReport.Tablet_Content_Proxy__c, reps);
                }
            }
        }

        System.debug('initRelatedReports contentProxyToReportsMap: ' + contentProxyToReportsMap);

        System.debug('Exiting initRelatedReports');
    }

    /*******************************************************************

        Purpose:  Gathers Reports favourites map

        Parameters: [optional]

        Returns: [void]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private void initRelatedReportsFavourites(){
        System.debug('Entering initRelatedReportsFavourites');

        reportsFavouriteMap = new Map<Id, OV_Report_Favourite__c>([SELECT Id, Chatter_Update_Message__c, Chatter_Delete_Message__c, Report__c, User__r.User__c, Favourite_From_Shelf_Tile__c, Favourite_From_Shelf_Tile__r.Tile_Colour__c, Favourite_From_Shelf_Tile__r.ICON_Label__c, Favourite_From_Shelf_Tile__r.Id FROM OV_Report_Favourite__c WHERE Report__c IN :reportsMap.keySet()]);
        System.debug('initRelatedReportsFavourites reportsFavouriteMap : ' + reportsFavouriteMap );

        for(OV_Report_Favourite__c tmpReportFavourite : reportsFavouriteMap.values()){
            if(reportIdToReportsFavouritesMap.containsKey(tmpReportFavourite.Report__c)){
                reportIdToReportsFavouritesMap.get(tmpReportFavourite.Report__c).add(tmpReportFavourite);
            }else{
                List<OV_Report_Favourite__c> reps = new List<OV_Report_Favourite__c>{tmpReportFavourite};
                reportIdToReportsFavouritesMap.put(tmpReportFavourite.Report__c, reps);
            }
        }

        System.debug('initRelatedReportsFavourites reportIdToReportsFavouritesMap: ' + reportIdToReportsFavouritesMap);

        System.debug('Exiting initRelatedReportsFavourites');
    } 
}