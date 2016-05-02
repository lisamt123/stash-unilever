/**********************************************************************
Name: OV_WithoutSharingService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service for operations on objects that user cant do because of sharing rules.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             13/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
public without sharing class OV_WithoutSharingService {
    /*******************************************************************
    Purpose: Method for modifying views counter
    Parameters: [String reportId]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void increaseViewsCounter(OV_Report__c report){
        System.debug(LoggingLevel.DEBUG, 'Entering increaseViewsCounter in class without sharing:');
        
        report.Views__c = (report.Views__c == null) ? 1 : report.Views__c + 1;
        update report;
               
        System.debug(LoggingLevel.DEBUG, 'Exiting increaseViewsCounter in class without sharing');
    }


    /*******************************************************************
    Purpose: Method for adding kpis to favourite
    Parameters: [List<OV_KPI_Transaction_Favorite__c> favourites]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void addKpisToFavorite(List<OV_KPI_Transaction_Favorite__c> favourites){
        System.debug(LoggingLevel.DEBUG, 'Entering addKpisToFavorite in class without sharing');
        
        insert favourites;
               
        System.debug(LoggingLevel.DEBUG, 'Exiting addKpisToFavorite in class without sharing');
    }

    /*******************************************************************
    Purpose: Method for deleting kpis from favourite
    Parameters: [List<OV_KPI_Transaction_Favorite__c> favourites]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void deleteFavoriteKpi(List<OV_KPI_Transaction_Favorite__c> favourites){
        System.debug(LoggingLevel.DEBUG, 'Entering deleteFavoriteKpi in class without sharing');
        
        delete favourites;
               
        System.debug(LoggingLevel.DEBUG, 'Exiting deleteFavoriteKpi in class without sharing');
    }

    /*******************************************************************
    Purpose: Method for updating kpis in favourite
    Parameters: [OV_KPI_Transaction_Favorite__c favourites]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void editKpiTransactionsFavorite(OV_KPI_Transaction_Favorite__c favourites){
        System.debug(LoggingLevel.DEBUG, 'Entering editKpiTransactionsFavorite in class without sharing');
        
        update favourites;
               
        System.debug(LoggingLevel.DEBUG, 'Exiting editKpiTransactionsFavorite in class without sharing');
    }
}