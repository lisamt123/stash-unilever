/**********************************************************************
Name: OV_KpiDimensionServiceSoql
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Class for retrieving KPI Name data from database
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       02/10/2015          INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_KpiDimensionServiceSoql implements OV_KpiDimensionService {

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
    
    public OV_KpiDimensionServiceSoql() {
        
    }

    /*******************************************************************

        Purpose:  Method for gathering KPI Names.  
        
        Parameters: [void]

        Returns: [List<OV_KpiWrapper.KpiNameWrapper>]

        Throws [Exceptions]: [optional]                                                          

    ********************************************************************/
    public static List<OV_KpiDimensionWrapper> getKpiNames(){
        System.debug(LoggingLevel.DEBUG, 'Entering getKpiNames');

        List<OV_KpiDimensionWrapper> wrappedReports = new List<OV_KpiDimensionWrapper>();
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Dimension_KPI_Name__c', new List<String>{'Id', 'Name '});
        /*SECURITY */
        for(OV_KPI_Dimension_KPI_Name__c myKpiName : [SELECT Id, Name FROM OV_KPI_Dimension_KPI_Name__c ORDER BY Name ASC LIMIT 2000]){
            wrappedReports.add(new OV_KpiDimensionWrapper(myKpiName.Id, myKpiName.Name));
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getKpiNames: ' + wrappedReports);
        return wrappedReports;
    }
}