/**********************************************************************
Name: OV_ReportService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service for operations on report object.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             09/07/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_ReportService {
    public class OVException extends Exception {}
    /*******************************************************************
    Purpose: Method for adding reports to favourite
    Parameters: [String reportId, String shelfTileId]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void addReportToFavourites(String reportId, String shelfTileId){
        System.debug(LoggingLevel.DEBUG, 'Entering addReportToFavourites: ' + reportId + ' ' +shelfTileId);

        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf_Tile__c', new String [] {'Id', 'Tile_Colour__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c', new String [] {'Id'});
        OV_SecurityHelper.doPrivilegedOp('OV_Profile__c', new String [] {'Id'});
        /*SECURITY - CRUD/FLS Enforcement */ 

        OV_Shelf_Tile__c shelfTile = [SELECT Id, Tile_Colour__c FROM  OV_Shelf_Tile__c WHERE Id = :shelfTileId LIMIT 1];

        OV_Report__c report = [SELECT Id FROM OV_Report__c WHERE Id = :reportId LIMIT 1];

        Id userId = UserInfo.getUserId();
        OV_Profile__c profile = [SELECT Id FROM OV_Profile__c WHERE User__c =: userId];

        OV_Report_Favourite__c favourite = new OV_Report_Favourite__c();
        favourite.Favourite_From_Shelf_Tile__c = shelfTile.Id;
        favourite.Report__c = report.Id;
        favourite.User__c = profile.Id;
        favourite.Colour__c = shelfTile.Tile_Colour__c;

        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_Report_Favourite__c', new String [] {'Favourite_From_Shelf_Tile__c', 'Report__c', 'User__c', 'Colour__c'});
        /*SECURITY*/
        insert favourite;

        OV_ChatterServiceImpl chatterService = new OV_ChatterServiceImpl();
        chatterService.followFavouriteReport(favourite.Id);
        
        System.debug(LoggingLevel.DEBUG, 'Exiting addReportToFavourites');
    }

    /*******************************************************************
    Purpose: Method for deleting reports from favourite
    Parameters: [String reportId]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void deleteReportFromFavourites(String reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering deleteReportFromFavourites: ' + reportId);

        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_Profile__c', new String [] {'Id'});
        OV_SecurityHelper.doPrivilegedOp('OV_Report_Favourite__c', new String [] {'Id', 'User__c', 'Report__c'});
        /*SECURITY - CRUD/FLS Enforcement */ 

        Id userId = UserInfo.getUserId();
        OV_Profile__c profile = [SELECT Id FROM OV_Profile__c WHERE User__c =: userId];

        List<OV_Report_Favourite__c> favReports = [SELECT Id FROM OV_Report_Favourite__c WHERE User__c = :profile.Id AND Report__c = :reportId LIMIT 1];

        OV_ChatterServiceImpl chatterService = new OV_ChatterServiceImpl();

        Savepoint sp = Database.setSavepoint();
        try{
            if(favReports.size() == 1){
                chatterService.unfollowFavouriteReport(favReports[0].Id);
            }
            
            delete favReports;
        }catch(Exception ex){
            Database.rollback(sp);
            throw new OVException('Error occured.'+ ex.getMessage(), ex);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting deleteReportFromFavourites');
    }

    /*******************************************************************
    Purpose: Method for modifying views counter
    Parameters: [String reportId]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void increaseViewsCounter(String reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering increaseViewsCounter: ' + reportId);
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c', new String [] {'Id', 'Views__c'});
        /*SECURITY - CRUD/FLS Enforcement */ 

        OV_Report__c report = [SELECT Id, Views__c FROM OV_Report__c WHERE Id = :reportId LIMIT 1];

        OV_WithoutSharingService.increaseViewsCounter(report);
               
        System.debug(LoggingLevel.DEBUG, 'Exiting increaseViewsCounter');
    }
}