/**********************************************************************
Name: OV_KpiTransactionServiceImpl
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Class implements OV_KpiTransactionServiceImpl interface
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       02/10/2015          INITIAL DEVELOPMENT
1.1 -   Maciej Krol           18/10/2015          MANY MODIFICATIONS
**********************************************************************/
public with sharing class OV_KpiTransactionServiceImpl {

    public static final String FILTER_BRAND                 = 'brand';
    public static final String FILTER_BUSINESS_UNIT         = 'businessUnit';
    public static final String FILTER_CHANNEL               = 'channel';
    public static final String FILTER_CUSTOMER              = 'customer';
    public static final String FILTER_GEOGRAPHY             = 'geography';
    public static final String FILTER_ORG_UNIT              = 'organisationalUnit';
    public static final String FILTER_PRODUCT_CATEGORY      = 'productCategory';
    public static final String FILTER_TIME_RANGE            = 'timeRange';
    public static final String FILTER_WL_GROUP              = 'wlGroup';
    public static final String FILTER_KPI_NAME              = 'kpiName';

    /*NORTH AMERICA*/
    public static final String FILTER_BRAND_NA              = 'brandNA';
    public static final String FILTER_OPCO_NA               = 'opcoNA';
    public static final String FILTER_PRODUCT_CATEGORY_NA   = 'productCategoryNA';
    public static final String FILTER_SALES_ORG_NA          = 'salesOrgNA';

    public static final String DIRECTION_SENTIMENT_FIELD     = 'Direction_Sentiment__c';
    public static final String KPI_NAME_FIELD_RELATION_NAME  = 'KPI_Name__r';
    public static final String TIMERANGE_FIELD_RELATION_NAME = 'Time_Range__r';
    public static final String TIMERANGE_FIELD               = 'Time_Range__c';

    private static Set<String> getVisibileColumns(Id kpiNameId, Map<String, OV_GetKPI_Mapping__c> kpiMappingMap){
        OV_KPI_Dimension_KPI_Name__c kpiName = [SELECT Visible_Columns__c FROM OV_KPI_Dimension_KPI_Name__c WHERE Id = :kpiNameId LIMIT 1];
        Set<String> columns = new Set<String>();
        if (!String.isEmpty(kpiName.Visible_Columns__c)){
            List<String> vFields = kpiName.Visible_Columns__c.split(';');
            for(String visibleField :  vFields){
                if(!String.isEmpty(visibleField) && kpiMappingMap.containsKey(visibleField)){
                    columns.add(visibleField);
                }else if(!String.isEmpty(visibleField)){
                    System.debug(LoggingLevel.WARN, 'OV_KpiTransactionServiceImpl getVisibileColumns. NO DIMENSION CALLED: '+visibleField+'IN CUSTOM SETTINGS FOR KPINAMEID: ' + kpiNameId);
                }
            }
        }

        return columns;
    }

    /*******************************************************************
    Purpose: Method for returning KPI transactions
    Parameters: [Map<String, List<Id>> dimensions,  Integer pageSize, Integer pageNumber]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static Map<String, Object> getKPITransactions(Map<String, Set<Id>> dimensions){
        System.debug(LoggingLevel.DEBUG, 'OV_KpiTransactionServiceImpl Entering getKPITransactions: ' + dimensions);

        Map<String, String> filterNameToApiMap = new Map<String, String>();
        Map<String, String> fieldApiNameToHeader = new Map<String, String>();

        String query = 'SELECT Id, Direction__c, Value_Prefix_Formatted__c, Value_Suffix_Formatted__c, Value_Current_Period__c, Value_Prefix_Previous_Formatted__c, Value_Suffix_Previous_Formatted__c, Value_Previous_Period__c, Current_Time_Period__c, '+KPI_NAME_FIELD_RELATION_NAME+'.Value_Type__c, '+KPI_NAME_FIELD_RELATION_NAME +'.'+ DIRECTION_SENTIMENT_FIELD+' ';
        String countQuery = 'SELECT count()';
        /*SECURITY - CRUD/FLS Enforcement */
        List<String> favFieldsToCheck = new List<String>{'Id', 'Direction__c', 'Value_Prefix_Formatted__c', 'Value_Suffix_Formatted__c', 'Value_Current_Period__c', 'Value_Prefix_Previous_Formatted__c', 'Value_Suffix_Previous_Formatted__c', 'Value_Previous_Period__c', 'Current_Time_Period__c'};
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
            
            query += ', ' + fieldApiName;
            query += ', ' + relatedNameFieldApiName;
            //need code only for timerange
            if(fieldApiName == TIMERANGE_FIELD){
                String relatedNameFieldApiCode = fieldApiName.replace('__c', '__r.Code__c');
                query += ', ' + relatedNameFieldApiCode;
            }
            
            if(cSetting.mapping.Name != 'kpiName'){
                fieldApiNameToHeader.put(cSetting.mapping.Name, cSetting.mapping.Header__c);
            }

            filterNameToApiMap.put(cSetting.mapping.Name, fieldApiName);
            favFieldsToCheck.add(fieldApiName);
        }

        query += ' FROM OV_KPI_Transaction__c WHERE Id != \'\'';
        countQuery += ' FROM OV_KPI_Transaction__c WHERE Id != \'\'';

        //fields which are always present in the system
        Set<String> standardFields = new Set<String>{FILTER_BRAND,FILTER_BUSINESS_UNIT,FILTER_CHANNEL,FILTER_CUSTOMER,FILTER_GEOGRAPHY,FILTER_ORG_UNIT,FILTER_PRODUCT_CATEGORY,FILTER_TIME_RANGE,FILTER_WL_GROUP,FILTER_KPI_NAME,FILTER_BRAND_NA,FILTER_OPCO_NA,FILTER_PRODUCT_CATEGORY_NA,FILTER_SALES_ORG_NA};
        Set<Id> brandIds = new Set<Id>();
        Set<Id> businessUnitIds = new Set<Id>();
        Set<Id> channelIds = new Set<Id>();
        Set<Id> customerIds = new Set<Id>();
        Set<Id> geographyIds = new Set<Id>();
        Set<Id> organizationalUnitIds = new Set<Id>();
        Set<Id> productCategoryIds = new Set<Id>();
        Set<Id> timeRangeIds = new Set<Id>();
        Set<Id> wlGroupIds = new Set<Id>();
        Set<Id> kpiNameIds = new Set<Id>();
        Set<Id> brandNAIds = new Set<Id>();
        Set<Id> opcoNAIds = new Set<Id>();
        Set<Id> productCategoryNAIds = new Set<Id>();
        Set<Id> salesOrgNAIds = new Set<Id>();

        if(dimensions.containsKey(FILTER_BRAND)){
            brandIds = dimensions.get(FILTER_BRAND);
            query += ' AND ' + filterNameToApiMap.get(FILTER_BRAND) + ' != null AND '+ filterNameToApiMap.get(FILTER_BRAND) +' IN :brandIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_BRAND) + '!= null AND '+ filterNameToApiMap.get(FILTER_BRAND) +' IN :brandIds';
        }
        if(dimensions.containsKey(FILTER_BUSINESS_UNIT)){
            businessUnitIds = dimensions.get(FILTER_BUSINESS_UNIT);
            query += ' AND ' + filterNameToApiMap.get(FILTER_BUSINESS_UNIT) + ' != null AND '+ filterNameToApiMap.get(FILTER_BUSINESS_UNIT) + ' IN :businessUnitIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_BUSINESS_UNIT) + '!= null AND '+ filterNameToApiMap.get(FILTER_BUSINESS_UNIT) + ' IN :businessUnitIds';
        }
        if(dimensions.containsKey(FILTER_CHANNEL)){
            channelIds = dimensions.get(FILTER_CHANNEL);
            query += ' AND ' + filterNameToApiMap.get(FILTER_CHANNEL) + ' != null AND '+ filterNameToApiMap.get(FILTER_CHANNEL) + ' IN :channelIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_CHANNEL) + '!= null AND '+ filterNameToApiMap.get(FILTER_CHANNEL) + ' IN :channelIds';
        }
        if(dimensions.containsKey(FILTER_CUSTOMER)){
            customerIds = dimensions.get(FILTER_CUSTOMER);
            query += ' AND ' + filterNameToApiMap.get(FILTER_CUSTOMER) + ' != null AND '+ filterNameToApiMap.get(FILTER_CUSTOMER) +' IN :customerIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_CUSTOMER) + '!= null AND '+ filterNameToApiMap.get(FILTER_CUSTOMER) + ' IN :customerIds';
        }
        if(dimensions.containsKey(FILTER_GEOGRAPHY)){
            geographyIds = dimensions.get(FILTER_GEOGRAPHY);
            query += ' AND ' + filterNameToApiMap.get(FILTER_GEOGRAPHY) + ' != null AND '+ filterNameToApiMap.get(FILTER_GEOGRAPHY) + ' IN :geographyIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_GEOGRAPHY) + ' != null AND '+ filterNameToApiMap.get(FILTER_GEOGRAPHY) + ' IN :geographyIds';
        }
        if(dimensions.containsKey(FILTER_ORG_UNIT)){
            organizationalUnitIds = dimensions.get(FILTER_ORG_UNIT);
            query += ' AND ' + filterNameToApiMap.get(FILTER_ORG_UNIT) + ' != null AND '+ filterNameToApiMap.get(FILTER_ORG_UNIT) + ' IN :organizationalUnitIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_ORG_UNIT) + '!= null AND '+ filterNameToApiMap.get(FILTER_ORG_UNIT) + ' IN :organizationalUnitIds';
        }
        if(dimensions.containsKey(FILTER_PRODUCT_CATEGORY)){
            productCategoryIds = dimensions.get(FILTER_PRODUCT_CATEGORY);
            query += ' AND ' + filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY) + ' != null AND '+ filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY) + ' IN :productCategoryIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY) + ' != null AND '+ filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY) + ' IN :productCategoryIds';
        }
        if(dimensions.containsKey(FILTER_TIME_RANGE)){
            timeRangeIds = dimensions.get(FILTER_TIME_RANGE);
            query += ' AND ' + filterNameToApiMap.get(FILTER_TIME_RANGE) + ' != null AND '+ filterNameToApiMap.get(FILTER_TIME_RANGE) + ' IN :timeRangeIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_TIME_RANGE) + ' != null AND '+ filterNameToApiMap.get(FILTER_TIME_RANGE) + ' IN :timeRangeIds';
        }
        if(dimensions.containsKey(FILTER_WL_GROUP)){
            wlGroupIds = dimensions.get(FILTER_WL_GROUP);
            query += ' AND ' + filterNameToApiMap.get(FILTER_WL_GROUP) + ' != null AND '+ filterNameToApiMap.get(FILTER_WL_GROUP) + ' IN :wlGroupIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_WL_GROUP) + ' != null AND '+ filterNameToApiMap.get(FILTER_WL_GROUP) + ' IN :wlGroupIds';
        }

        if(dimensions.containsKey(FILTER_BRAND_NA)){
            brandNAIds = dimensions.get(FILTER_BRAND_NA);
            query += ' AND ' + filterNameToApiMap.get(FILTER_BRAND_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_BRAND_NA) + ' IN :brandNAIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_BRAND_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_BRAND_NA) + ' IN :brandNAIds';
        }

        if(dimensions.containsKey(FILTER_OPCO_NA)){
            opcoNAIds = dimensions.get(FILTER_OPCO_NA);
            query += ' AND ' + filterNameToApiMap.get(FILTER_OPCO_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_OPCO_NA) + ' IN :opcoNAIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_OPCO_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_OPCO_NA) + ' IN :opcoNAIds';
        }

        if(dimensions.containsKey(FILTER_PRODUCT_CATEGORY_NA)){
            productCategoryNAIds = dimensions.get(FILTER_PRODUCT_CATEGORY_NA);
            query += ' AND ' + filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY_NA) + ' IN :productCategoryNAIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_PRODUCT_CATEGORY_NA) + ' IN :productCategoryNAIds';
        }

        if(dimensions.containsKey(FILTER_SALES_ORG_NA)){
            salesOrgNAIds = dimensions.get(FILTER_SALES_ORG_NA);
            query += ' AND ' + filterNameToApiMap.get(FILTER_SALES_ORG_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_SALES_ORG_NA) + ' IN :salesOrgNAIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_SALES_ORG_NA) + ' != null AND '+ filterNameToApiMap.get(FILTER_SALES_ORG_NA) + ' IN :salesOrgNAIds';
        }

        if(dimensions.containsKey(FILTER_KPI_NAME)){
            kpiNameIds = dimensions.get(FILTER_KPI_NAME);
            query += ' AND ' + filterNameToApiMap.get(FILTER_KPI_NAME) + ' != null AND '+ filterNameToApiMap.get(FILTER_KPI_NAME) + ' IN :kpiNameIds';
            countQuery += ' AND ' + filterNameToApiMap.get(FILTER_KPI_NAME) + ' != null AND '+ filterNameToApiMap.get(FILTER_KPI_NAME) + ' IN :kpiNameIds';

            //there is alawys max one kpiNameId
            Id kpiNameId = new List<Id> (kpiNameIds).get(0);
            Set<String> visibleColumns = getVisibileColumns(kpiNameId, customSettingsMapping);

            //if empty then show all, if not then only these which are mentioned in the Visible_Columns__c field
            if( !visibleColumns.isEmpty() ){
                for(String key : fieldApiNameToHeader.keySet()){
                    if(! visibleColumns.contains(key)){
                        fieldApiNameToHeader.remove(key);
                    }
                }
            }
        }
        //fields added by admins

        //gather all ids in one set
        Set<Id> allOtherIds = new Set<Id>();
        for(String key : dimensions.keySet() ){
            if(key != null && filterNameToApiMap.containsKey(key) && !standardFields.contains(key) ){
                for(Id idk : dimensions.get(key)){
                    allOtherIds.add(idk);
                }
            }
        }

        String glue = ' AND ';
        for(String key : dimensions.keySet() ){
            if(key != null && filterNameToApiMap.containsKey(key) && !standardFields.contains(key)){
                query += glue + filterNameToApiMap.get(key) + ' IN  :allOtherIds';
                countQuery += glue + filterNameToApiMap.get(key) + ' IN  :allOtherIds';
            }
        }

        //dont return these which are favourite
        Set<Id> favouritesIds = getFavouriteKPIIds();
        if(!favouritesIds.isEmpty()){
            query += ' AND Id NOT IN :favouritesIds';
            countQuery += ' AND Id NOT IN  :favouritesIds';
        }

        String orderGlue = ' ORDER BY ';
        for(OV_KpiWrapper.KPIMappingWrapper cSetting : kpiMappingList){
            query += orderGlue + cSetting.mapping.Field_API_Name__c + ' ASC NULLS LAST';
            orderGlue = ', ';
        }

        OV_KPI_Config__c customSettings = OV_KPI_Config__c.getInstance();
        query += ' LIMIT '+Integer.valueOf(customSettings.Max__c+1);

        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction__c', favFieldsToCheck);
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Dimension_KPI_Name__c', new List<String>{'Direction_Sentiment__c'});
        /*SECURITY */

        Integer tSize = Database.countQuery(countQuery);        

        Map<String, Object> resultMap = new Map<String, Object>();
        
        if(tSize > customSettings.Max__c){
            resultMap.put('showResults', false);
            resultMap.put('headerMapping', fieldApiNameToHeader);
            resultMap.put('msg', customSettings.TooManyResultsMsg__c);
        }else{
            System.debug('_____________Query for transactions:'+query);
            List<OV_KPI_Transaction__c> transactions = Database.query(query);

            List<OV_KpiWrapper.KPITransactionWrapper> resultTrans = getWrappedResultsForPageWithoutPaging(transactions, filterNameToApiMap);
            resultTrans.sort();
            
            List<Map<String,String>> resultTransactions = new List<Map<String,String>>();
            for(OV_KpiWrapper.KPITransactionWrapper r : resultTrans){
                resultTransactions.add((Map<String,String>)r.transact);
            }

            resultMap.put('showResults', true);
            resultMap.put('transactions', resultTransactions);
        }
        resultMap.put('count', tSize);
        resultMap.put('headerMapping', fieldApiNameToHeader);

        System.debug(LoggingLevel.DEBUG, 'Exiting getKPITransactions');

        return resultMap;
    }

    private static Set<Id> getFavouriteKPIIds(){
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction_Favorite__c', new List<String>{'Id', 'Report__c'});
        /*SECURITY */

        Id userId = UserInfo.getUserId();
        List<OV_KPI_Transaction_Favorite__c> favouritesList = [SELECT Id, KPI_Transaction__c FROM OV_KPI_Transaction_Favorite__c WHERE User__r.User__c = :userId];
        Set<Id> favouritesId = new Set<Id>();
        for(OV_KPI_Transaction_Favorite__c kpiTransFav : favouritesList){
            favouritesId.add(kpiTransFav.KPI_Transaction__c);
        }

        return favouritesId;
    }

    private static List<OV_KpiWrapper.KPITransactionWrapper> getWrappedResultsForPageWithoutPaging(List<OV_KPI_Transaction__c> searchResults, Map<String, String> filterNameToApiMap){
        List<OV_KpiWrapper.KPITransactionWrapper> results =new List<OV_KpiWrapper.KPITransactionWrapper>();
        if(!searchResults.isEmpty()){
            Map<String, OV_GetKPI_Mapping__c> customSetting = OV_KpiUtils.getKpiMapping();
            for(OV_KPI_Transaction__c res : searchResults){
                results.add( new OV_KpiWrapper.KPITransactionWrapper(generateWrappedTransaction(res, filterNameToApiMap), customSetting));
            }
            return results;
        }else{
            return new List<OV_KpiWrapper.KPITransactionWrapper>();
        }
    }

    private static Map<String, String> generateWrappedTransaction(OV_KPI_Transaction__c kpiTransaction, Map<String, String> filterNameToApiMap){
        Map<String, String> fieldsMap = new Map<String, String>();

        fieldsMap.put('id', String.valueOf(kpiTransaction.get('Id')));
        fieldsMap.put('kpiTransactionCurrentTimePeriod', String.valueOf(kpiTransaction.get('Current_Time_Period__c')));
        fieldsMap.put('kpiTransactionDirection', String.valueOf(kpiTransaction.get('Direction__c')));
        fieldsMap.put('kpiTransactionValue', String.valueOf(kpiTransaction.get('Value_Current_Period__c')));
        fieldsMap.put('kpiTransactionValuePrefix', String.valueOf(kpiTransaction.get('Value_Prefix_Formatted__c')));
        fieldsMap.put('kpiTransactionValueSuffix', String.valueOf(kpiTransaction.get('Value_Suffix_Formatted__c')));
        fieldsMap.put('kpiTransactionPreviousValue', String.valueOf(kpiTransaction.get('Value_Previous_Period__c')));
        fieldsMap.put('kpiTransactionPreviousValuePrefix', String.valueOf(kpiTransaction.get('Value_Prefix_Previous_Formatted__c')));
        fieldsMap.put('kpiTransactionPreviousValueSuffix', String.valueOf(kpiTransaction.get('Value_Suffix_Previous_Formatted__c')));

        for(String fieldApiName : filterNameToApiMap.keySet()){
            if(filterNameToApiMap.containsKey(fieldApiName)){
                String relatedNameFieldApiName = filterNameToApiMap.get(fieldApiName).replace('__c', '__r');

                if(kpiTransaction.getSObject(relatedNameFieldApiName) != null){
                    fieldsMap.put(fieldApiName, String.valueOf(kpiTransaction.getSObject(relatedNameFieldApiName).get('Name')));
                    fieldsMap.put(fieldApiName+'Id', String.valueOf(kpiTransaction.get(filterNameToApiMap.get(fieldApiName))));

                    if(relatedNameFieldApiName == KPI_NAME_FIELD_RELATION_NAME){
                        fieldsMap.put('kpiDirectionSentiment', String.valueOf(kpiTransaction.getSObject(relatedNameFieldApiName).get(DIRECTION_SENTIMENT_FIELD)));
                        fieldsMap.put('kpiTransactionValueType', String.valueOf(kpiTransaction.getSObject(relatedNameFieldApiName).get('Value_Type__c')));
                    }

                    if(relatedNameFieldApiName == TIMERANGE_FIELD_RELATION_NAME){
                        fieldsMap.put('timeRangeCode', String.valueOf(kpiTransaction.getSObject(relatedNameFieldApiName).get('Code__c')));
                    }
                }
            }

        }

        return fieldsMap;
    }
}