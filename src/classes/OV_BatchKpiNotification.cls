/**********************************************************************
Name: OV_BatchKpiNotification
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Batch for sending notifications related to notifications
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             12/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
global with sharing class OV_BatchKpiNotification implements Database.Batchable<sObject> {
    String query;
    public static Integer testBatchSize; //variable used only in tests
    private static final String UPDATE_MESSAGE = 'Update';

    public static final String KPI_TRANSACTION_FIELD_RELATION_NAME = 'KPI_Transaction__r';
    public static final String TIMERANGE_FIELD_RELATION_NAME    = 'Time_Range__r';
    public static final String TIMERANGE_FIELD                  = 'Time_Range__c';
    public static final String KPI_NAME_FIELD_RELATION_NAME     = 'KPI_Name__r';

    global OV_BatchKpiNotification(String cQuery) {
        query = cQuery;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<OV_KPI_Transaction__c> scope) {
        Map<Id, OV_KPI_Transaction__c> kpiTransactionIdToTransaction = new Map<Id, OV_KPI_Transaction__c>();
        for(OV_KPI_Transaction__c kpiTransaction : scope){
            kpiTransactionIdToTransaction.put(kpiTransaction.Id, kpiTransaction);
        }

        Set<Id> kpiTransactionIdToTransactionKeySet = kpiTransactionIdToTransaction.keySet();
        System.debug('OV_BatchKpiNotification. Notifications related to transactions: '+kpiTransactionIdToTransactionKeySet);

        Map<String, OV_GetKPI_Mapping__c> customSettingsMapping = OV_KpiUtils.getKpiMapping();

        String query = 'SELECT Id, KPI_Transaction__c, User__c, User__r.User__c, Wants_Notifications__c, Chatter_Update_Message__c, KPI_Transaction__r.KPI_Name__r.Visible_Columns__c';

        for(OV_GetKPI_Mapping__c cSetting : customSettingsMapping.values()){
            String fieldApiName = cSetting.Field_API_Name__c;
            if(fieldApiName != null && fieldApiName != ''){
                String relatedNameFieldApiName = fieldApiName.replace('__c', '__r.Name');
            
                query += ', ' + KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+fieldApiName;
                query += ', ' + KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+relatedNameFieldApiName;
                //code only for timerange
                if(fieldApiName == TIMERANGE_FIELD){
                    String relatedNameFieldApiCode = fieldApiName.replace('__c', '__r.Code__c');
                    query += ', ' + KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+relatedNameFieldApiCode;
                }
            }
        }

        query += ' FROM OV_KPI_Transaction_Favorite__c WHERE KPI_Transaction__c IN :kpiTransactionIdToTransactionKeySet AND Wants_Notifications__c = true';

        List<OV_KPI_Transaction_Favorite__c> kpiTransactionFavs = Database.query(query);
        System.debug('OV_BatchKpiNotification. Favourites related to transactions: '+kpiTransactionFavs);

        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        List<List<ConnectApi.BatchInput>> listOfPacs = new List<List<ConnectApi.BatchInput>>();

        for(OV_KPI_Transaction_Favorite__c kpiTransactionFav : kpiTransactionFavs){
            ConnectApi.FeedItemInput input = OV_Utils.generateKpiNotification(kpiTransactionFav, UPDATE_MESSAGE);
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
            batchInputs.add(batchInput);
        }

        if( !batchInputs.isEmpty() ){
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
                    } else {
                        testBatchSize= batchInputs.size();
                    }
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('OV_BatchKpiNotification. End of batch');
    }
}