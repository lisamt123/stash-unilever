/**********************************************************************

 Name:  OV_ContentProxyHandler()

 Copyright © 2015  Salesforce

 ======================================================

======================================================

Purpose:    Trigger Handler for the OV_ContentProxy__c SObject. This class implements the OV_Trigger
            interface to help ensure the trigger code is bulkified and all in one place.

-------

======================================================

======================================================

History

-------

VERSION  AUTHOR            DATE              DETAIL            Description

1.0   Pawel Niedziela    24/09/2015      INITIAL DEVELOPMENT   Trigger Handler for the OV_ContentProxy__c SObject.

***********************************************************************/
public with sharing class OV_ContentProxyHandler implements OV_Trigger{

    private Set<Id> contentProxyIds = new Set<Id>();
    private Map<Id, List<OV_Report__c>> contentProxyToReportsMap = new Map<Id, List<OV_Report__c>>();

    private Map<Id, List<OV_Report_Favourite__c>> reportIdToReportsFavouritesMap = new Map<Id, List<OV_Report_Favourite__c>>();
    
    Map<Id, OV_Report__c> reportsMap = new Map<Id, OV_Report__c>();
    Map<Id, OV_Report_Favourite__c> reportsFavouriteMap = new Map<Id, OV_Report_Favourite__c>();

    List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
    List<List<ConnectApi.BatchInput>> listOfPacs = new List<List<ConnectApi.BatchInput>>();

    // Constructor
    public OV_ContentProxyHandler(){
        System.debug(LoggingLevel.DEBUG, 'Entering OV_ContentProxyHandler');
    }

    /*******************************************************************

        Purpose:  This method is called prior to execution of a BEFORE trigger. Use this to cacheany data required into maps prior execution of the trigger.

        Parameters: [optional]

        Returns: [optional]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    /**
     * This method is required due to implementation of the OV_Trigger interface
     * @return void
     */
    public void bulkBefore(){
        System.debug(LoggingLevel.DEBUG, 'Entering bulkBefore');
    }


    /*******************************************************************

        Purpose:  This method is called prior to execution of an AFTER trigger. Use this to cache any data required into maps prior execution of the trigger.

        Parameters: [optional]

        Returns: [optional]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    public void bulkAfter(){

        System.debug('Entering bulkAfter');

        if(Trigger.isUpdate){
            initChangedContentProxies();
        }

        System.debug('Exiting andFinally');
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

        if(contentProxyToReportsMap.containsKey(so.Id)){
            List<OV_Report__c> tmpReports = contentProxyToReportsMap.get(so.Id);

            for(OV_Report__c tmpr : tmpReports){
                if(reportIdToReportsFavouritesMap.containsKey(tmpr.Id)){
                    for(OV_Report_Favourite__c tmprepfav : reportIdToReportsFavouritesMap.get(tmpr.Id)){
          
                        ConnectApi.FeedItemInput input = createReportUpdateNotification(tmprepfav);

                        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
                        batchInputs.add(batchInput);                        
                    }
                }
            }
        }

        System.debug('Exiting afterUpdate');
    }


    /*******************************************************************

        Purpose: This method is called iteratively for each record deleted during an AFTER trigger.

       Parameters: [SObject ]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void afterDelete(SObject so){
        System.debug(LoggingLevel.DEBUG, 'Entering afterDelete');
    }


    /*******************************************************************

        Purpose: This method is called iteratively for each record undeleted during an AFTER trigger.

       Parameters: [SObject ]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void afterUndelete(SObject so){
        System.debug(LoggingLevel.DEBUG, 'Entering afterUndelete');
    }

    /*******************************************************************

        Purpose: This method is called once all records have been processed by the trigger. Use this
                    method to accomplish any final operations such as creation or updates of other records.

       Parameters: [SObject ]

       Returns: [void]

       Throws [Exceptions]: [optional]

    ********************************************************************/
    public void andFinally(){

        System.debug('Entering andFinally');

        if( batchInputs.size()>0 ){
            Integer dmlLimit = Limits.getLimitDmlStatements();
            List<ConnectApi.BatchInput> pack = new List<ConnectApi.BatchInput>();
            for(Integer j = 0 ; j < batchInputs.size() ; j++){
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
        System.debug('Exiting andFinally');
    }

    /*******************************************************************

        Purpose:  Collects data that will be needed during execution of trigger.

        Parameters: [optional]

        Returns: [void]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private void initChangedContentProxies(){

        System.debug('Entering initChangedContentProxies');

        for(Integer i=0; i < Trigger.new.size(); i++){
            OV_ContentProxy__c newRecord = (OV_ContentProxy__c)Trigger.new[i];
            OV_ContentProxy__c oldRecord = (OV_ContentProxy__c)Trigger.old[i];

            if(oldRecord.LatestContentVersionId__c != newRecord.LatestContentVersionId__c){
                contentProxyIds.add(newRecord.Id);
            }
        }

        reportsMap = new Map<Id, OV_Report__c>([SELECT Id, Chatter_Update_Message__c, Chatter_Delete_Message__c, Desktop_Content_Proxy__c, Mobile_Content_Proxy__c, Tablet_Content_Proxy__c FROM OV_Report__c WHERE Desktop_Content_Proxy__c IN :contentProxyIds OR Mobile_Content_Proxy__c IN :contentProxyIds OR Tablet_Content_Proxy__c IN :contentProxyIds]);

        //create Content Proxy to Report Map
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

        reportsFavouriteMap = new Map<Id, OV_Report_Favourite__c>([SELECT Id, Chatter_Update_Message__c, Chatter_Delete_Message__c, Report__c, User__r.User__c FROM OV_Report_Favourite__c WHERE Report__c IN :reportsMap.keySet()]);

        for(OV_Report_Favourite__c tmpReportFavourite : reportsFavouriteMap.values()){
            if(reportIdToReportsFavouritesMap.containsKey(tmpReportFavourite.Report__c)){
                reportIdToReportsFavouritesMap.get(tmpReportFavourite.Report__c).add(tmpReportFavourite);
            }else{
                List<OV_Report_Favourite__c> reps = new List<OV_Report_Favourite__c>{tmpReportFavourite};
                reportIdToReportsFavouritesMap.put(tmpReportFavourite.Report__c, reps);
            }
        }
        
        System.debug('Exiting initChangedContentProxies');
    }


    /*******************************************************************

        Purpose:  Creates Chatter Feed Item which will be posted.

        Parameters: [OV_Report_Favourite__c reportFavourite]

        Returns: [ConnectApi.FeedItemInput]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private ConnectApi.FeedItemInput createReportUpdateNotification(OV_Report_Favourite__c reportFavourite) {

        System.debug('Entering createReportUpdateNotification: ' + ' reportFavourite: ' + reportFavourite);

        return createReportNotification(reportFavourite, 'Update');
    }


    /*******************************************************************

        Purpose:  Creates Chatter Feed Item which will be posted.

        Parameters: [OV_Report_Favourite__c reportFavourite, String type]

        Returns: [ConnectApi.FeedItemInput]

        Throws [Exceptions]: [optional]

    ********************************************************************/
    private ConnectApi.FeedItemInput createReportNotification(OV_Report_Favourite__c reportFavourite, String type) {

        System.debug('Entering createReportNotification: ' + ' reportFavourite: ' + reportFavourite + ' type: ' + type);

        String field;
        if(type == 'Update'){
           field = reportFavourite.Chatter_Update_Message__c;
        }else{
            field = reportFavourite.Chatter_Delete_Message__c;
        }

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.subjectId = reportFavourite.Report__c;

        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = reportFavourite.User__r.User__c;
        body.messageSegments.add(mentionSegment);

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();

        textSegment.text = '\n ' + field;

        body.messageSegments.add(textSegment);

        input.body = body;

        System.debug('Exiting getKpiElementInterests: ' + input);

        return input;

    }
}