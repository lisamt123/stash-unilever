/**********************************************************************
Name: OV_RemoteController
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class is a wrapper which keeps all wrapper classes for all remote/aura actions called from OneView application
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             18/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_RemoteController {
    public static final String SUCCESS_CODE         = '0';
    public static final String EXCEPTION_CODE       = '-1';
    public static final String FILTER_FUNCTION      = 'function';
    public static final String FILTER_CATEGORY      = 'category';
    public static final String FILTER_GEOGRAPHY     = 'geography';
    public static final String FILTER_CUSTOMER      = 'customer';

    public static final String DEVICE_DESKTOP      = 'Desktop';
    public static final String DEVICE_TABLET       = 'Tablet';
    public static final String DEVICE_MOBILE       = 'Mobile';

    public static final String RESULTS             = 'Results';

    private static Object getValueFromMap(Map<String, String> providedMap, String key, Boolean isBoolean){
        if(isBoolean){
           return (providedMap.containsKey(key) && !String.isEmpty(providedMap.get(key))) ? Boolean.valueOf(providedMap.get(key)) : false;
        }else{
            return (providedMap.containsKey(key) && !String.isEmpty(providedMap.get(key))) ? providedMap.get(key) : '';
        }
    }

    private static String isDevice(String deviceType){
        String device    = deviceType;
        if(device != OV_RemoteController.DEVICE_DESKTOP && device != OV_RemoteController.DEVICE_TABLET && device != OV_RemoteController.DEVICE_MOBILE){
            device = OV_RemoteController.DEVICE_DESKTOP;
        }
        return device;
    }

    /*******************************************************************
    Purpose: Search engine method resposible for returning applicable shelf, tiles and report (structure)
    Parameters: [String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String deviceType, Boolean filtersFromCache]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper search(String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String deviceType, Boolean filtersFromCache){
        System.debug(LoggingLevel.DEBUG, 'Entering search: ' + geographyId + ' ' + categoryId + ' ' + functionId + ' ' + mineOnly + ' ' + recordTypeName + ' ' + deviceType + ' '+filtersFromCache);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            String geography = geographyId;
            String category  = categoryId;
            String function  = functionId;
            Boolean mine     = mineOnly;
            String device    = isDevice(deviceType);

            if(filtersFromCache){
                Map<String, String> savedFilters = OV_Utils.getSavedFiltersFromObject();
                geography = String.valueOf(getValueFromMap(savedFilters, 'geographyId', false));
                category  = String.valueOf(getValueFromMap(savedFilters, 'categoryId', false));
                function  = String.valueOf(getValueFromMap(savedFilters, 'functionId', false));
                mine      = Boolean.valueOf(getValueFromMap(savedFilters, 'mineOnly', true));
                resultMap.put('filters', savedFilters);
            }else{
                OV_Utils.saveFilters(geography, category, function, mine);
            }

            List<OV_Wrapper.ShelfWrapper> res = OV_SearchService2.search(geography, category, function, mine, recordTypeName, device);
            resultMap.put('shelfs', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0001, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0002, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting search: ' + resultMap);
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning reports for shelf tile id
    Parameters: [String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String shelfTileId, String deviceType]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getTileReports2(String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String shelfTileId, String deviceType){
        System.debug(LoggingLevel.DEBUG, 'Entering getTileReports: '  + geographyId + ' ' + categoryId + ' ' + functionId + ' ' + mineOnly + ' ' + recordTypeName + ' ' + shelfTileId + ' ' + deviceType);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            String device    = isDevice(deviceType);

            Map<String, Object> res = OV_SearchService2.getTileReports2(geographyId, categoryId, functionId, mineOnly, recordTypeName, shelfTileId, device);
            resultMap.put('structure', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0003, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0004, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getTileReports: ' + resultMap);
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning report details
    Parameters: [String reportId, String shelfTileId, String deviceType]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getReport(String reportId, String shelfTileId, String deviceType){
        System.debug(LoggingLevel.DEBUG, 'Entering getReport: ' + reportId + ' ' + shelfTileId + ' ' + deviceType);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            String device    = isDevice(deviceType);

            OV_Wrapper.ReportWrapper res = OV_SearchService2.getReportDetails(reportId, shelfTileId, device);

            resultMap.put('report', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0005, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0006, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getReport: ' + resultMap);
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning kpinames objects
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getKPINames(){
        System.debug(LoggingLevel.DEBUG, 'Entering getKPINames');

        Map<String, Object> resultMap = new Map<String, Object>();
        List<OV_Wrapper.KPINameWrapper> res = OV_KPIService.getKPINames();
        resultMap.put('kpiNames', res);

        System.debug(LoggingLevel.DEBUG, 'Exiting getKPINames');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning kpinames objects
    Parameters: [String kpiNameId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getKPIReports(String kpiNameId){
        System.debug(LoggingLevel.DEBUG, 'Entering getReports:' +kpiNameId);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            List<OV_Wrapper.ReportWrapper> res = OV_KPIService.getReports(kpiNameId);

            resultMap.put('kpiReports', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0007, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0008, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getReports');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning kpielements
    Parameters: [String kpiNameId, reportId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getKPIElements(String kpiNameId, String reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering getKPIElements: '+ kpiNameId + ' '+ reportId);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            List<OV_Wrapper.KPIElementWrapper> res = OV_KPIService.getKPIElements(kpiNameId, reportId);

            resultMap.put('kpiElements', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0009, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0010, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getKPIElements');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible adding KPI Element to my KPI
    Parameters: [String kpiElementId, reportId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper addKPIElementToMyKPIs(String kpiElementIds, Boolean shouldBeNotified){
        System.debug(LoggingLevel.DEBUG, 'Entering addKPIElementToMyKPIs: '+ kpiElementIds + ' ' + shouldBeNotified);
        try{
            OV_KPIService.addKPIElementToMyKPIs(kpiElementIds, shouldBeNotified);

        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0011, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0012, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting addKPIElementToMyKPIs');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, null);
    }

    /*******************************************************************
    Purpose: Method resposible adding KPI Element to my KPI
    Parameters: [String kpiElementId, reportId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper deleteMyKPI(String kpiElementId){
        System.debug(LoggingLevel.DEBUG, 'Entering deleteMyKPI: ' + kpiElementId);
        try{
            OV_KPIService.deleteMyKPI(kpiElementId);

        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0013, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0014, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting deleteMyKPI');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, null);
    }

    /*******************************************************************
    Purpose: Method resposible for returning my kpielements
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getMyKPIElements(String geographyId, String categoryId, String functionId, Boolean mineOnly){
        System.debug(LoggingLevel.DEBUG, 'Entering getMyKPIElements');

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            List<OV_Wrapper.KPIElementWrapper> res = OV_KPIService.getMyKPIElements(geographyId, categoryId, functionId, mineOnly);
            resultMap.put('kpiElements', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0015, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0016, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getMyKPIElements');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for returning filters
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getFilters(){
        System.debug(LoggingLevel.DEBUG, 'Entering getFilters');

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            List<Object> functionFiltersList = OV_Utils.getSortedNestedFilters(FILTER_FUNCTION);
            List<Object> categoryFiltersList = OV_Utils.getSortedNestedFilters(FILTER_CATEGORY);
            List<Object> geographyFiltersList = OV_Utils.getSortedNestedFilters(FILTER_GEOGRAPHY);
            List<Object> customerFiltersList = OV_Utils.getSortedNestedFilters(FILTER_CUSTOMER);
            List<Object> timespanFiltersList = OV_Utils.getTimespans();
            List<Object> brandFiltersList = OV_Utils.getBrands();
            List<Object> comparatorFiltersList = OV_Utils.getComparators();
            List<Object> channelFiltersList = OV_Utils.getChannels();

            resultMap.put('functionFilters', functionFiltersList);
            resultMap.put('categoryFilters', categoryFiltersList);
            resultMap.put('geographyFilters', geographyFiltersList);
            resultMap.put('customerFilters', customerFiltersList);
            resultMap.put('brandFilters', brandFiltersList);
            resultMap.put('timespanFilters', timespanFiltersList);
            resultMap.put('comparatorFilters', comparatorFiltersList);
            resultMap.put('channelFilters', channelFiltersList);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0017, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }
        System.debug(LoggingLevel.DEBUG, 'Exiting getFilters');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible adding report to my favourite list
    Parameters: [String reportId, String shelfTileId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper addReportToFavourites(String reportId, String shelfTileId){
        System.debug(LoggingLevel.DEBUG, 'Entering addReportToFavourites: '+ reportId + ' ' +shelfTileId);
        try{
            OV_ReportService.addReportToFavourites(reportId, shelfTileId);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0018, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0019, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting addReportToFavourites');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, null);
    }

    /*******************************************************************
    Purpose: Method resposible adding report to my favourite list
    Parameters: [String reportId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper deleteReportFromFavourites(String reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering deleteReportFromFavourites: '+reportId);
        try{
            OV_ReportService.deleteReportFromFavourites(reportId);

        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0020, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0021, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting deleteReportFromFavourites');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, null);
    }

    /*******************************************************************
    Purpose: Method resposible for returning my favourite reports
    Parameters: [String deviceType]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper getMyFavouritesReports(String geographyId, String categoryId, String functionId, Boolean mineOnly, String deviceType){
        System.debug(LoggingLevel.DEBUG, 'Entering getMyFavouritesReports: '+ deviceType);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            String device    = isDevice(deviceType);
            Map<String, List<OV_Wrapper.ReportWrapper>> res = OV_SearchService2.getMyFavouritesReports(geographyId, categoryId, functionId, mineOnly, device);

            resultMap.put('reports', res);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0022, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0023, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getMyFavouritesReports');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method resposible for increasing views counter
    Parameters: [String reportId]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper increaseViewsCounter(String reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering increaseViewsCounter: '+ reportId);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            OV_ReportService.increaseViewsCounter(reportId);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0024, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0025, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting increaseViewsCounter');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    /*******************************************************************
    Purpose: Method responsible for saving report usage entries
    Parameters: [String reportId, String shelfTileId, String operationType, String deviceType, String versionNumber]
    Returns: OV_Wrapper
    ********************************************************************/
    @AuraEnabled
    public static OV_Wrapper saveUsageEntry(Id reportId, String shelfTileId, String operationType, String deviceType, String versionNumber){
        System.debug(LoggingLevel.DEBUG, 'Entering saveUsageEntry: ' + reportId + ' ' + shelfTileId + ' ' + operationType + ' ' + deviceType + ' ' + versionNumber);

        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            OV_ReportUsageService.saveUsageEntry(reportId, shelfTileId, operationType, deviceType, versionNumber);
        }catch(NoAccessException ex){
            return new OV_Wrapper('Code: RC0026, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }catch(Exception ex){
            return new OV_Wrapper('Code: RC0027, Message: '+ex.getMessage(), EXCEPTION_CODE, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting saveUsageEntry');
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, resultMap);
    }

    @AuraEnabled
    public static OV_Wrapper addPostLink(Map<String, String> params){
        ConnectApi.LinkCapabilityInput linkInput                             = new ConnectApi.LinkCapabilityInput();
        linkInput.url                                                        = params.get('link');
        linkInput.urlName                                                    = params.get('linkName');

        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.link                                    = linkInput;

        ConnectApi.FeedItemInput input                                       = new ConnectApi.FeedItemInput();
        input.capabilities                                                   = feedElementCapabilitiesInput;

        ConnectApi.FeedElement feedElement                                   = ConnectApi.ChatterFeeds.updateFeedElement(null, params.get('id'), input);
        return new OV_Wrapper(RESULTS, SUCCESS_CODE, new Map<String, Object>{'feedElement' => feedElement});
    }
}