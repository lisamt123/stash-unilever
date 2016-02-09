/**********************************************************************
Name: OV_ReportUsageService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service with report usage methods
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             09/09/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_ReportUsageService {
    public static final String DEVICE_TABLET        = 'Tablet';
    public static final String DEVICE_MOBILE        = 'Mobile';
    public static final String DEVICE_DESKTOP       = 'Desktop';
    public static final String SOURCE_FAVORITE      = 'Favorite';
    public static final String SOURCE_SHELF_TILE    = 'Shelf Tile';
    public static final String MY_VIEW              = 'My View';

    /*******************************************************************
    Purpose: Method for saving usage entries
    Parameters: [String reportId, String shelfTile, String operationType, String deviceType, String versionNumber]
    Sonar Note: npath complexity issue. needs refactoring however leaving for now because of code readability and also for not it's too complicated and time consuming to refactor it.
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void saveUsageEntry(Id reportId, String shelfTile, String operationType, String deviceType, String versionNumber){
        System.debug(LoggingLevel.DEBUG, 'Entering saveUsageEntry service: ' + reportId + ' ' + shelfTile + ' ' + operationType + ' ' + deviceType + ' '+ versionNumber);

        List<OV_ShelfTileReport__c> shelfTileReports;
        String source = (shelfTile == null) ? SOURCE_FAVORITE : SOURCE_SHELF_TILE;
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_ShelfTileReport__c' , new List<String>{'Report__c', 'Shelf_Tile__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c' , new List<String>{'Name', 'Category__c', 'Reporting_Period__c', 'Function__c', 'Geography__c', 'Business_Owner__c', 'Publisher__c', 'Frequency__c', 'Desktop_Content_Proxy__c', 'Mobile_Content_Proxy__c', 'Colour_ltng__c', 'Icon_ltng__c', 'Tablet_Content_Proxy__c', 'Report_Heading__c', 'CreatedDate', 'Views__c', 'Report_Folder__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_Category__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Geography__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('User' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_ContentProxy__c' , new List<String>{'Url__c', 'Title__c', 'LatestContentVersionId__c', 'ContentDocumentId__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf_Tile__c' , new List<String>{'Name', 'Colour__c', 'ICON_Label__c', 'Tile_ICON__c', 'CreatedDate'});
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf__c' , new List<String>{'Id', 'Name', 'Colour__c', 'CreatedDate'});
        OV_SecurityHelper.doPrivilegedOp('OV_Unit__c' , new List<String>{'Name', 'Type__c'});
        /*SECURITY */
        if(shelfTile != null){
            shelfTileReports = [SELECT Report__c, Report__r.Name, Report__r.Category__c, Report__r.Category__r.Name, Report__r.Reporting_Period__c, Report__r.Function__c, Report__r.Geography__c, Report__r.Geography__r.Name,
                Report__r.Business_Owner__c, Report__r.Business_Owner__r.Name, Report__r.Publisher__c, Report__r.Publisher__r.Name, Report__r.Frequency__c,
                Report__r.Desktop_Content_Proxy__c, Report__r.Desktop_Content_Proxy__r.Url__c, Report__r.Desktop_Content_Proxy__r.Title__c,
                Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c, Report__r.Mobile_Content_Proxy__c, Report__r.Colour_ltng__c, Report__r.Icon_ltng__c,
                Report__r.Mobile_Content_Proxy__r.Url__c, Report__r.Mobile_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c, Report__r.Tablet_Content_Proxy__c,
                Report__r.Tablet_Content_Proxy__r.Url__c, Report__r.Tablet_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__r.ContentDocumentId__c, Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c, Report__r.Tablet_Content_Proxy__r.ContentDocumentId__c,
                Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c, Report__r.Report_Heading__c, Report__r.CreatedDate, Report__r.Views__c, Shelf_Tile__c,
                Shelf_Tile__r.Name, Shelf_Tile__r.Colour__c, Shelf_Tile__r.ICON_Label__c, Shelf_Tile__r.Tile_ICON__c, Shelf_Tile__r.Shelf__r.Id, Shelf_Tile__r.Shelf__r.Name,
                Shelf_Tile__r.Shelf__r.Colour__c, Shelf_Tile__r.CreatedDate,
                Shelf_Tile__r.Shelf__r.CreatedDate, Report__r.Report_Folder__c, Report__r.Unit__r.Name, Report__r.Unit__r.Type__c FROM OV_ShelfTileReport__c
                WHERE Report__c = :reportId AND Shelf_Tile__c = :shelfTile LIMIT 1];
        }else{
            shelfTileReports = [SELECT Report__c, Report__r.Name, Report__r.Category__c, Report__r.Category__r.Name, Report__r.Reporting_Period__c, Report__r.Function__c, Report__r.Geography__c, Report__r.Geography__r.Name,
            Report__r.Business_Owner__c, Report__r.Business_Owner__r.Name, Report__r.Publisher__c, Report__r.Publisher__r.Name, Report__r.Frequency__c,
            Report__r.Desktop_Content_Proxy__c, Report__r.Desktop_Content_Proxy__r.Url__c, Report__r.Desktop_Content_Proxy__r.Title__c,
            Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c, Report__r.Mobile_Content_Proxy__c, Report__r.Colour_ltng__c, Report__r.Icon_ltng__c,
            Report__r.Mobile_Content_Proxy__r.Url__c, Report__r.Mobile_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c, Report__r.Tablet_Content_Proxy__c,
            Report__r.Tablet_Content_Proxy__r.Url__c, Report__r.Tablet_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__r.ContentDocumentId__c, Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c, Report__r.Tablet_Content_Proxy__r.ContentDocumentId__c,
            Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c, Report__r.Report_Heading__c, Report__r.CreatedDate, Report__r.Views__c, Shelf_Tile__c,
            Shelf_Tile__r.Name, Shelf_Tile__r.Colour__c, Shelf_Tile__r.ICON_Label__c, Shelf_Tile__r.Tile_ICON__c, Shelf_Tile__r.Shelf__r.Id, Shelf_Tile__r.Shelf__r.Name,
            Shelf_Tile__r.Shelf__r.Colour__c, Shelf_Tile__r.CreatedDate,
            Shelf_Tile__r.Shelf__r.CreatedDate, Report__r.Report_Folder__c, Report__r.Unit__r.Name, Report__r.Unit__r.Type__c FROM OV_ShelfTileReport__c
            WHERE Report__c = :reportId LIMIT 1];
        }


        if( !shelfTileReports.isEmpty() ){
            OV_ShelfTileReport__c shelfTileReport = shelfTileReports[0];

            Id contentDocumentId;
            String device = deviceType;
            if(deviceType == OV_ReportUsageService.DEVICE_DESKTOP){
                contentDocumentId = shelfTileReport.Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c;
            }else if(deviceType == OV_ReportUsageService.DEVICE_MOBILE){
                contentDocumentId = shelfTileReport.Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c;
            }else if(deviceType == OV_ReportUsageService.DEVICE_TABLET){
                contentDocumentId = shelfTileReport.Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c;
            }else{
                device = OV_ReportUsageService.DEVICE_DESKTOP;
                contentDocumentId = shelfTileReport.Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c;
            }

            List<ContentVersion> cvs;
            /*SECURITY - CRUD/FLS Enforcement */
            OV_SecurityHelper.doPrivilegedOp('ContentVersion' , new List<String>{'Id', 'Title', 'VersionNumber', 'CreatedById', 'CreatedDate'});
            OV_SecurityHelper.doPrivilegedOp('User' , new List<String>{'Name'});
            /*SECURITY */
            if(versionNumber == null){
                cvs = [SELECT Id, Title, VersionNumber, CreatedById, CreatedDate, CreatedBy.Name FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId AND IsLatest = true LIMIT 1];
            }else{
                cvs = [SELECT Id, Title, VersionNumber, CreatedById, CreatedDate, CreatedBy.Name FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId AND VersionNumber = :versionNumber LIMIT 1];
            }
            if( !cvs.isEmpty() ){
                ContentVersion cv = cvs[0];

                OV_Report_Usage__c reportUsage      = new OV_Report_Usage__c();
                reportUsage.Accessed_Date__c        = Datetime.now();
                reportUsage.Device_Type__c          = device;
                reportUsage.File_Name_By_Version__c = cv.Title;
                reportUsage.File_Version__c         = cv.VersionNumber;
                reportUsage.File_Version_Upload_Date__c = cv.CreatedDate;
                reportUsage.File_Version_Uploaded_By__c = cv.CreatedById;
                reportUsage.File_Version_Uploaded_By_Name__c = cv.CreatedBy.Name;
                reportUsage.OneView_Report_Details_Category__c          = shelfTileReport.Report__r.Category__r.Name;
                reportUsage.OneView_Report_Details_Code__c              = shelfTileReport.Report__c;
                reportUsage.OneView_Report_Details_Frequency__c         = shelfTileReport.Report__r.Frequency__c;
                reportUsage.OneView_Report_Details_Geography__c         = shelfTileReport.Report__r.Geography__r.Name;
                reportUsage.OneView_Report_Details_Name__c              = shelfTileReport.Report__r.Name;
                reportUsage.OneView_Report_Details_Reporting_Period__c  = shelfTileReport.Report__r.Reporting_Period__c;
                reportUsage.OneView_Report_Details_Unit_Code__c = shelfTileReport.Report__r.Unit__c;
                reportUsage.Shelf_Code__c       = (shelfTile != null) ? String.valueOf(shelfTileReport.Shelf_Tile__r.Id) : MY_VIEW;
                reportUsage.Shelf_Name__c       = (shelfTile != null) ? shelfTileReport.Shelf_Tile__r.Shelf__r.Name : MY_VIEW;
                reportUsage.Shelf_Tile_Code__c  = (shelfTile != null) ? String.valueOf(shelfTileReport.Shelf_Tile__c) : MY_VIEW;
                reportUsage.Shelf_Tile_Name__c  = (shelfTile != null) ? shelfTileReport.Shelf_Tile__r.Name : MY_VIEW;
                reportUsage.Unit_Unit_Name__c   = shelfTileReport.Report__r.Unit__r.Name;
                reportUsage.Unit_Unit_Type__c   = shelfTileReport.Report__r.Unit__r.Type__c;
                reportUsage.User_Id__c          = UserInfo.getUserId();
                reportUsage.User_Name__c        = UserInfo.getName();
                reportUsage.Operation__c        = operationType;
                reportUsage.Source__c           = source;

                /*SECURITY - CRUD/FLS Enforcement */
                OV_SecurityHelper.doPrivilegedOp('OV_Report_Usage__c' , new List<String>{'Accessed_Date__c', 'Device_Type__c', 'File_Name_By_Version__c', 'File_Version__c', 'File_Version_Upload_Date__c', 'File_Version_Uploaded_By__c', 'File_Version_Uploaded_By_Name__c', 'OneView_Report_Details_Category__c', 'OneView_Report_Details_Code__c', 'OneView_Report_Details_Frequency__c', 'OneView_Report_Details_Geography__c', 'OneView_Report_Details_Name__c', 'OneView_Report_Details_Reporting_Period__c', 'OneView_Report_Details_Unit_Code__c', 'Shelf_Code__c', 'Shelf_Name__c ', 'Shelf_Tile_Code__c', 'Shelf_Tile_Name__c', 'Unit_Unit_Name__c', 'Unit_Unit_Type__c', 'User_Id__c', 'User_Name__c', 'Operation__c', 'Source__c'});
                /*SECURITY */
                insert reportUsage;
            }
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting saveUsageEntry service');
    }
}