/**********************************************************************
Name: OV_KpiController
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Class is a wrapper which keeps all wrapper classes for KPI remote/aura actions called from OneView application.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       02/10/2015          INITIAL DEVELOPMENT
1.1 -   Maciej Krol           18/10/2015          MANY MODIFICATIONS
**********************************************************************/
public with sharing class OV_KpiController {
    public static final String SUCCESS_CODE         = '0';
    public static final String EXCEPTION_CODE       = '-1';

    public static final String FILTER_BRAND                 = 'brand';
    public static final String FILTER_BUSINESS_UNIT         = 'businessUnit';
    public static final String FILTER_CHANNEL               = 'channel';
    public static final String FILTER_CUSTOMER              = 'customer';
    public static final String FILTER_GEOGRAPHY             = 'geography';
    public static final String FILTER_PRODUCT_CATEGORY      = 'productCategory';

    public static final String RESULTS                      = 'Results';

    public static final String DEVICE_DESKTOP      = 'Desktop';
    
    public static OV_KpiTransactionFavoriteService kpiFavoriteService = new OV_KpiTransactionFavoriteServiceImpl();

    public OV_KpiController(){
             
    }
    
    /*******************************************************************
    Purpose: Method resposible for returning filters 
    Parameters: [OV_Wrapper]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getFilters(){
        System.debug(LoggingLevel.DEBUG, 'Entering getFilters2');

        Map<String, Object> resultMap = new Map<String, Object>();
        Map<String, OV_GetKPI_Mapping__c> filterNameToApiMap = OV_KpiUtils.getKpiMapping();
        
        try{
            List<OV_KpiWrapper.KPIMappingWrapper> kpiMappingList = new List<OV_KpiWrapper.KPIMappingWrapper>();
            for(OV_GetKPI_Mapping__c myElement : filterNameToApiMap.values()){
                if(myElement.Name != 'kpiName'){
                    kpiMappingList.add(new OV_KpiWrapper.KPIMappingWrapper(myElement));
                }                
            }
            kpiMappingList.sort();

            for(OV_KpiWrapper.KPIMappingWrapper cFilter : kpiMappingList){
                Map<String, Object> node = new Map<String, Object>();
                node.put('Name', cFilter.mapping.Header__c);
                node.put('Icon', cFilter.mapping.Icon__c);
                node.put('Items', OV_KpiUtils.getSortedNestedFilters(cFilter.mapping.Name, cFilter.mapping.IsHierarchical__c, cFilter.mapping.Object_API_Name__c));
                
                resultMap.put(cFilter.mapping.Name+'Filters',node);
            }
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0001, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }
        System.debug(LoggingLevel.DEBUG, 'Exiting getFilters2');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning KPI Names 
    Parameters: []
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getKpiNames(){
        System.debug(LoggingLevel.DEBUG, 'Entering getKpiNames');

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            List<OV_KpiDimensionWrapper> res = OV_KpiDimensionServiceSoql.getKpiNames();
            resultMap.put('kpiNames', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: KPI0002, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0003, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getKpiNames: ' + resultMap);
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning KPI transactions 
    Parameters: [String dimensions, Integer pageSize, Integer pageNumber]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getKPITransactions(String dimensions){
        System.debug(LoggingLevel.DEBUG, 'OV_KpiController Entering getKPITransactions: ' + dimensions);
        Map<String, Object> resultMap = new Map<String, Object>();
        try{ 
            Map<String, Set<Id>> convertedDimensions = (Map<String, Set<Id>>)JSON.deserialize(dimensions, Map<String, Set<Id>>.class);         
            resultMap = OV_KpiTransactionServiceImpl.getKPITransactions(convertedDimensions);      
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: KPI0004, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0005, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getKPITransactions: ' + resultMap);
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }
    
    
    /*******************************************************************
    Purpose: Method resposible adding KPI Transaction to my KPI
    Parameters: [String transactions]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper addKpiTransactionsToFavorite(String transactions){
        System.debug(LoggingLevel.DEBUG, 'Entering addKpiTransactionToFavorite: '+ transactions);
        
        try{
            List<OV_Wrapper.KpiFavouriteTransactionWrapper> favouriteTransactions = (List<OV_Wrapper.KpiFavouriteTransactionWrapper>)JSON.deserialize(transactions, List<OV_Wrapper.KpiFavouriteTransactionWrapper>.class);
                        
            kpiFavoriteService.addKpisToFavorite(favouriteTransactions);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: KPI0006, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0007, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting addKpiTransactionToFavorite');
        
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, null);
    }

    /*******************************************************************
    Purpose: Method resposible editing my KPI Transaction
    Parameters: [String kpiTransactionFavouriteId, Boolean wantsNotification, String reportId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper editKpiTransactionsFavorite(String kpiTransactionFavouriteId, Boolean wantsNotification, String reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering editKpiTransactionsToFavorite: '+ kpiTransactionFavouriteId + ' ' + wantsNotification + ' '+reportId);
        
        try{
            kpiFavoriteService.editKpiTransactionsFavorite(kpiTransactionFavouriteId, wantsNotification, reportId);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: KPI0008, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0009, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting editKpiTransactionsFavorite');
        
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, null);
    }

    /*******************************************************************
    Purpose: Method resposible removing KPI Transaction from my KPI
    Parameters: [String transactions]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper deleteKpiTransactionFromFavorite(String transactionId){
        System.debug(LoggingLevel.DEBUG, 'Entering deleteKpiTransactionFromFavorite: '+ transactionId);        
        try{
            kpiFavoriteService.deleteFavoriteKpi(transactionId);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: KPI0010, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0011, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting deleteKpiTransactionFromFavorite');
        
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, null);
    }

    /*******************************************************************
    Purpose: Method resposible for returning favourite KPI transactions 
    Parameters: []
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getFavouriteKPITransactions(){
        System.debug(LoggingLevel.DEBUG, 'Entering getFavouriteKPITransactions ');
        Map<String, Object> resultMap = new Map<String, Object>();
        try{ 
            List<Map<String, String>> res = kpiFavoriteService.listFavorites();
            resultMap.put('kpis', res);   
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: KPI0012, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0013, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getFavouriteKPITransactions: ' + resultMap);
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for calling batch job for notification purpose
    Parameters: [OV_Wrapper]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper fireNotifictions(String dataTag, String fileVersion){
        System.debug(LoggingLevel.DEBUG, 'Entering fireNotifictions');
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            /*SECURITY - CRUD/FLS Enforcement */
            OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction__c', new List<String>{'Id', 'Data_Tag__c', 'File_Version__c'});
            OV_SecurityHelper.doPrivilegedOp('OV_Profile__c', new List<String>{'Id', 'User__c'});
            OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction_Favorite__c', new List<String>{'Id', 'KPI_Transaction__c', 'User__c', 'Wants_Notifications__c', 'Chatter_Update_Message__c'});
            OV_SecurityHelper.doPrivilegedOp('OV_KPI_Dimension_KPI_Name__c', new List<String>{'Visible_Columns__c'});

            List<String> favFieldsToCheck = new List<String>{'Id'};

            Map<String, OV_GetKPI_Mapping__c> customSettingsMapping = OV_KpiUtils.getKpiMapping();

            for(OV_GetKPI_Mapping__c cSetting : customSettingsMapping.values()){
                String fieldApiName = cSetting.Field_API_Name__c;
                if(fieldApiName != null && fieldApiName != ''){
                    favFieldsToCheck.add(fieldApiName);
                }
            }

            OV_SecurityHelper.doPrivilegedOp('OV_KPI_Transaction__c', favFieldsToCheck);
            /*SECURITY - CRUD/FLS Enforcement */

            String query = 'SELECT Id FROM OV_KPI_Transaction__c WHERE Fire_Notification__c = true AND Data_Tag__c = \''+String.escapeSingleQuotes(dataTag)+'\' AND File_Version__c=\''+String.escapeSingleQuotes(fileVersion)+'\'';
            OV_BatchKpiNotification batchApex = new OV_BatchKpiNotification(query);
            if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
                Database.executeBatch(batchApex,5);
            }else{
                return new OV_Wrapper('Code: KPI0014, Message: Maximum number of batch Apex jobs queued or active concurrently exceeded', EXCEPTION_CODE, null);
            }
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0015, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting fireNotifictions');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible returning my favourite reports
    Parameters: []
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getMyFavouritesReports(){
        System.debug(LoggingLevel.DEBUG, 'Entering getMyFavouritesReports');

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            Map<String, List<OV_Wrapper.ReportWrapper>> res = OV_SearchService2.getMyFavouritesReports(null, null, null, false, DEVICE_DESKTOP);
            
            resultMap.put('reports', res);
        }catch(Exception ex){
            return new OV_Wrapper('Code: KPI0016, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getMyFavouritesReports');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }
}