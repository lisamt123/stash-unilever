/**********************************************************************
Name: OV_KpiTransactionFavoriteServiceImpl
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Class implements OV_KpiTransactionFavoriteService interface used for methods used agains KPIs (favourites)
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             15/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_KpiTransactionFavoriteServiceImpl implements OV_KpiTransactionFavoriteService {
    public class OVException extends Exception {}

    public static final String DIRECTION_SENTIMENT_FIELD        = 'Direction_Sentiment__c';
    public static final String KPI_NAME_FIELD_RELATION_NAME     = 'KPI_Name__r';
    public static final String TIMERANGE_FIELD_RELATION_NAME    = 'Time_Range__r';
    public static final String TIMERANGE_FIELD                  = 'Time_Range__c';
    public static final String KPI_TRANSACTION_FIELD_RELATION_NAME = 'KPI_Transaction__r';


    private static List<OV_KPI_Transaction__c> getKPITransactions(Set<Id> kpiTransactionId){
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction__c', new List<String>{'Id'});
        /*SECURITY */
        List<OV_KPI_Transaction__c> transactions = [SELECT Id FROM OV_KPI_Transaction__c WHERE Id IN :kpiTransactionId];

        return transactions;
    }



    /*******************************************************************
    Purpose: Method for editing KPIs in favourites
    Parameters: [String kpiTransactionFavouriteId, Boolean wantsNotification, String reportId]
    Returns:
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public void editKpiTransactionsFavorite(String kpiTransactionFavouriteId, Boolean wantsNotification, String reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering editKpiTransactionsFavorite : ' + kpiTransactionFavouriteId + ' '+ wantsNotification + ' ' +reportId);

        Savepoint sp = Database.setSavepoint();
        try{
            Id userId = UserInfo.getUserId();
            /*SECURITY - CRUD/FLS Enforcement */
            OV_SecurityHelper.doPrivilegedOp('OV_Profile__c', new List<String>{'User__c'});
            /*SECURITY */
            OV_Profile__c profile = [SELECT Id FROM OV_Profile__c WHERE User__c =: userId];

            /*SECURITY - CRUD/FLS Enforcement */
            OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction_Favorite__c', new List<String>{'Wants_Notifications__c', 'Report__c', 'Id', 'KPI_Transaction__c'});
            /*SECURITY */
            OV_KPI_Transaction_Favorite__c favorite = [SELECT Id, Report__c, Wants_Notifications__c, KPI_Transaction__c FROM OV_KPI_Transaction_Favorite__c WHERE User__c = :profile.Id AND Id = :kpiTransactionFavouriteId LIMIT 1];

            favorite.Wants_Notifications__c = wantsNotification;
            favorite.Report__c = reportId;

            List<OV_KPI_Transaction__c> transactions = getKPITransactions(new Set<Id>{favorite.KPI_Transaction__c});
            if(transactions.size() == 1){
                OV_WithoutSharingService.editKpiTransactionsFavorite(favorite);
            }else{
                throw new OVException('Error occured. Insufficient privileges.');
            }
        }catch(Exception ex){
            Database.rollback(sp);
            throw new OVException('Error occured.'+ ex.getMessage(), ex);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting editKpiTransactionsFavorite');
    }


    /*******************************************************************
    Purpose: Method for adding KPIs to favourites
    Parameters: [List<OV_Wrapper.KpiFavouriteTransactionWrapper>]
    Returns:
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public void addKpisToFavorite(List<OV_Wrapper.KpiFavouriteTransactionWrapper> favouriteTransactions){
        System.debug(LoggingLevel.DEBUG, 'Entering addKpisToFavorite favouriteTransactions: ' + favouriteTransactions);

        Savepoint sp = Database.setSavepoint();
        try{
            Id userId = UserInfo.getUserId();
            /*SECURITY - CRUD/FLS Enforcement */
            OV_SecurityHelper.doPrivilegedOp('OV_Profile__c', new List<String>{'User__c'});
            /*SECURITY */
            OV_Profile__c profile = [SELECT Id FROM OV_Profile__c WHERE User__c =: userId];

            Set<Id> transactionIds = new Set<Id>();

            List<OV_KPI_Transaction_Favorite__c> favorites = new List<OV_KPI_Transaction_Favorite__c>();
            OV_KPI_Transaction_Favorite__c transactionFavorite;
            for(OV_Wrapper.KpiFavouriteTransactionWrapper  fTransaction : favouriteTransactions){
                transactionIds.add(fTransaction.kpiTransactionId);

                transactionFavorite = new OV_KPI_Transaction_Favorite__c();
                transactionFavorite.KPI_Transaction__c = fTransaction.kpiTransactionId;
                transactionFavorite.User__c = profile.Id;
                transactionFavorite.Wants_Notifications__c = fTransaction.shouldBeNotified;
                if(fTransaction.reportId != null){
                    transactionFavorite.Report__c = fTransaction.reportId;
                }

                favorites.add(transactionFavorite);
            }

            if( !favorites.isEmpty() ){
                /*SECURITY - CRUD/FLS Enforcement */
                OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction_Favorite__c', new List<String>{'KPI_Transaction__c', 'User__c', 'Wants_Notifications__c', 'Report__c'});
                /*SECURITY */

                //check if has read access
                List<OV_KPI_Transaction__c> transactions = getKPITransactions(transactionIds);
                if(transactions.size() == favorites.size()){
                    OV_WithoutSharingService.addKpisToFavorite(favorites);
                }else{
                    System.debug(LoggingLevel.DEBUG, 'transactions size: ' + transactions.size());
                    System.debug(LoggingLevel.DEBUG, 'favourite request size: ' + favorites.size());

                    throw new OVException('Error occured. Insufficient privileges.');
                }
            }
        }catch(Exception ex){
            Database.rollback(sp);
            throw new OVException('Error occured.'+ ex.getMessage(), ex);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting addKpisToFavorite');
    }

    /*******************************************************************
    Purpose: Method for deleting KPIs from favourites
    Parameters: [String kpiTransactionId]
    Returns:
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public void deleteFavoriteKpi(String kpiTransactionId){
        System.debug(LoggingLevel.DEBUG, 'Entering deleteFavoriteKpi kpiTransactionId: ' + kpiTransactionId);

        Id kPiTransId =  Id.valueOf(kpiTransactionId);

        Id userId = UserInfo.getUserId();

        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction_Favorite__c', new List<String>{'KPI_Transaction__c', 'User__c'});
        /*SECURITY */

        List<OV_KPI_Transaction_Favorite__c> kpiFavoriteTransaction = [SELECT Id, KPI_Transaction__c FROM OV_KPI_Transaction_Favorite__c WHERE KPI_Transaction__c = :kPiTransId AND User__r.User__c = :userId];

        Savepoint sp = Database.setSavepoint();

        try{
            List<OV_KPI_Transaction__c> transactions = getKPITransactions(new Set<Id>{kPiTransId});
            if(transactions.size() == 1){
                OV_WithoutSharingService.deleteFavoriteKpi(kpiFavoriteTransaction);
            }else{
                throw new OVException('Error occured. Insufficient privileges.');
            }
        }catch(Exception ex){
            Database.rollback(sp);
            throw new OVException('Error occured.'+ ex.getMessage(), ex);
        }
        System.debug(LoggingLevel.DEBUG, 'Exiting deleteFavoriteKpi');
    }

    /*******************************************************************
    Purpose: Method for listing favourite KPIs. Returns list of maps because of dynamic fields (depend on custom settings)
    Parameters: []
    Returns:
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public List<Map<String, String>> listFavorites(){
        System.debug(LoggingLevel.DEBUG, 'Entering listFavorites');

        Id userId = UserInfo.getUserId();

        Map<String, String> filterNameToApiMap = new Map<String, String>();
        Map<String, String> fieldApiNameToHeader = new Map<String, String>();

        String query = 'SELECT Id, Wants_Notifications__c, Report__c, '+KPI_TRANSACTION_FIELD_RELATION_NAME + '.Value_Current_Period__c, '+KPI_TRANSACTION_FIELD_RELATION_NAME + '.Value_Prefix_Formatted__c, ' +KPI_TRANSACTION_FIELD_RELATION_NAME +'.Value_Suffix_Formatted__c, '+KPI_TRANSACTION_FIELD_RELATION_NAME + '.Value_Previous_Period__c, ' +KPI_TRANSACTION_FIELD_RELATION_NAME + '.Value_Prefix_Previous_Formatted__c, ' +KPI_TRANSACTION_FIELD_RELATION_NAME + '.Value_Suffix_Previous_Formatted__c, ' +KPI_TRANSACTION_FIELD_RELATION_NAME + '.Current_Time_Period__c, ' + KPI_TRANSACTION_FIELD_RELATION_NAME+'.Id, Report__r.Id, '+KPI_TRANSACTION_FIELD_RELATION_NAME+'.Direction__c, '+KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+ KPI_NAME_FIELD_RELATION_NAME +'.Value_Type__c, '+KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+ KPI_NAME_FIELD_RELATION_NAME +'.'+ DIRECTION_SENTIMENT_FIELD +' ';

        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction__c', new List<String>{'Id', 'Direction__c', 'Value_Prefix_Formatted__c', 'Value_Suffix_Formatted__c', 'Value_Current_Period__c', 'Value_Prefix_Previous_Formatted__c', 'Value_Suffix_Previous_Formatted__c', 'Value_Previous_Period__c', 'Current_Time_Period__c'});
        List<String> favFieldsToCheck = new List<String>{'Id', 'KPI_Transaction__c', 'User__c', 'Report__c'};
        /*SECURITY */

        List<OV_KpiWrapper.KPIMappingWrapper> kpiMappingList = new List<OV_KpiWrapper.KPIMappingWrapper>();
        Map<String, OV_GetKPI_Mapping__c> customSettingsMapping = OV_KpiUtils.getKpiMapping();
        for(OV_GetKPI_Mapping__c myElement : customSettingsMapping.values()){
            kpiMappingList.add(new OV_KpiWrapper.KPIMappingWrapper(myElement));
        }
        kpiMappingList.sort();

        for(OV_KpiWrapper.KPIMappingWrapper cSetting : kpiMappingList){
            String fieldApiName = cSetting.mapping.Field_API_Name__c;

            String relatedNameFieldApiName = fieldApiName.replace('__c', '__r.Name');
        
            query += ', ' + KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+fieldApiName;
            query += ', ' + KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+relatedNameFieldApiName;
            //code only for timerange
            if(fieldApiName == TIMERANGE_FIELD){
                String relatedNameFieldApiCode = fieldApiName.replace('__c', '__r.Code__c');
                query += ', ' + KPI_TRANSACTION_FIELD_RELATION_NAME+'.'+relatedNameFieldApiCode;
            }
            
            fieldApiNameToHeader.put(cSetting.mapping.Name, cSetting.mapping.Header__c);
            filterNameToApiMap.put(cSetting.mapping.Name, fieldApiName);
            favFieldsToCheck.add(fieldApiName);
        }

        query += ' FROM OV_KPI_Transaction_Favorite__c WHERE User__r.User__c = :userId ORDER BY KPI_Transaction__r.KPI_Name__r.Name ASC, CreatedDate ASC';

        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction_Favorite__c', favFieldsToCheck);
        /*SECURITY */

        List<OV_KPI_Transaction_Favorite__c> favourites = Database.query(query);

        Map<Id, OV_Report_Favourite__c> myFavouritesReports = OV_SearchService2.getFavouritereports();

        List<Map<String, String>> wrappedFavorites = new List<Map<String, String>>();

        for(OV_KPI_Transaction_Favorite__c favourite : favourites){
            Map<String, String> dynamicMap = generateWrappedTransaction(favourite, filterNameToApiMap);

            if(favourite.Report__c != null && myFavouritesReports.containsKey(favourite.Report__c)){
                dynamicMap.put('kpiReportId', favourite.Report__c);
                dynamicMap.put('kpiShelfTileId', myFavouritesReports.get(favourite.Report__c).Favourite_From_Shelf_Tile__r.Id);
                dynamicMap.put('kpiShelfTileIcon', myFavouritesReports.get(favourite.Report__c).Favourite_From_Shelf_Tile__r.ICON_Label__c);
                dynamicMap.put('kpiShelfTileColour', myFavouritesReports.get(favourite.Report__c).Colour_ltng__c);
            }
            wrappedFavorites.add(dynamicMap);
        }
        System.debug(LoggingLevel.DEBUG, 'Exiting listFavorites wrappedFavorites: ' + wrappedFavorites );

        return wrappedFavorites;
    }

    private static Map<String, String> generateWrappedTransaction(OV_KPI_Transaction_Favorite__c kpiTransactionFavourite, Map<String, String> filterNameToApiMap){
        Map<String, String> fieldsMap = new Map<String, String>();
        if(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME) != null){

            fieldsMap.put('kpiWantsNotification', String.valueOf(kpiTransactionFavourite.Wants_Notifications__c));
            fieldsMap.put('kpiTransactionFavouriteId', String.valueOf(kpiTransactionFavourite.Id));

            fieldsMap.put('kpiTransactionCurrentTimePeriod', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Current_Time_Period__c')));

            fieldsMap.put('kpiTransactionValue', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Value_Current_Period__c')));
            fieldsMap.put('kpiTransactionValuePrefix', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Value_Prefix_Formatted__c')));
            fieldsMap.put('kpiTransactionValueSuffix', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Value_Suffix_Formatted__c')));

            fieldsMap.put('kpiTransactionPreviousValue', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Value_Previous_Period__c')));
            fieldsMap.put('kpiTransactionPreviousValuePrefix', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Value_Prefix_Previous_Formatted__c')));
            fieldsMap.put('kpiTransactionPreviousValueSuffix', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Value_Suffix_Previous_Formatted__c')));

            fieldsMap.put('kpiTransactionId', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Id')));
            fieldsMap.put('kpiTransactionDirection', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).get('Direction__c')));
        }

        if(kpiTransactionFavourite.getSObject('Report__r') != null){
            fieldsMap.put('kpiTransactionReportId', String.valueOf(kpiTransactionFavourite.getSObject('Report__r').get('Id')));
        }

        for(String fieldApiName : filterNameToApiMap.keySet()){
            String relatedNameFieldApiName = filterNameToApiMap.get(fieldApiName).replace('__c', '__r');
            if(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME) != null && kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).getSObject(relatedNameFieldApiName) != null){
                fieldsMap.put(fieldApiName, String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).getSObject(relatedNameFieldApiName).get('Name')));

                if(relatedNameFieldApiName == KPI_NAME_FIELD_RELATION_NAME){
                    fieldsMap.put('kpiDirectionSentiment', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).getSObject(relatedNameFieldApiName).get(DIRECTION_SENTIMENT_FIELD)));
                    fieldsMap.put('kpiTransactionValueType', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).getSObject(relatedNameFieldApiName).get('Value_Type__c')));
                }

                if(relatedNameFieldApiName == TIMERANGE_FIELD_RELATION_NAME){
                    fieldsMap.put('timeRangeCode', String.valueOf(kpiTransactionFavourite.getSObject(KPI_TRANSACTION_FIELD_RELATION_NAME).getSObject(relatedNameFieldApiName).get('Code__c')));
                }
            }
        }

        return fieldsMap;
    }
}