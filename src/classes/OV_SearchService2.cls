/**********************************************************************
Name: OV_SearchService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service for searching purpose
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             18/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_SearchService2 {
    public static final String STATIC_REPORT         = 'Static Reports';
    public static final String DYNAMIC_REPORT        = 'Dynamic Report';

    public static final String SUBJECTS              = 'Subjects';
    public static final String MOMENTS               = 'Moments';

    public class OVException extends Exception {}

    /*******************************************************************
    Purpose: Private method for parsing input parameters and build WHERE clause of SOQL query
    Parameterd Description:
    Parameters: [String geographyId, String categoryId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String deviceType]
    Sonar Note: npath complexity issue. not refactored beacuse of code readability
    Returns: [String]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    private static String buildWhereClausesForSearch(String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String shelfTileId, String deviceType){
        String whereClause = 'WHERE Id != \'\'';
        try{
            Id validId;
            if(geographyId != null && geographyId != '' ){
                validId = Id.valueOf(geographyId);

                whereClause += ' AND (Report__r.Geography__c = \''+validId+
                    '\' OR Report__r.Geography__r.Parent_Geography__c = \'' +validId+
                    '\' OR Report__r.Geography__r.Parent_Geography__r.Parent_Geography__c = \'' +validId+
                    '\' OR Report__r.Geography__r.Parent_Geography__r.Parent_Geography__r.Parent_Geography__c = \'' +validId+ '\')';
            }

            if(categoryId != null  && categoryId != ''){
                validId = Id.valueOf(categoryId);

                whereClause += ' AND (Report__r.Category__c = \''+validId+
                '\' OR Report__r.Category__r.Parent_Category__c = \''+validId+
                '\' OR Report__r.Category__r.Parent_Category__r.Parent_Category__c = \''+validId+
                '\' OR Report__r.Category__r.Parent_Category__r.Parent_Category__r.Parent_Category__c = \''+validId+ '\')';
            }

            if(functionId != null  && functionId != ''){
                validId = Id.valueOf(functionId);

                whereClause += ' AND (Report__r.Function__c = \''+validId+
                '\' OR Report__r.Function__r.Parent_Function__c = \''+validId+
                '\' OR Report__r.Function__r.Parent_Function__r.Parent_Function__c = \''+validId+
                '\' OR Report__r.Function__r.Parent_Function__r.Parent_Function__r.Parent_Function__c = \''+validId+ '\')';
            }

            if(mineOnly){
                Id currentUserId = UserInfo.getUserId();
                whereClause += ' AND Report__r.OwnerId = \''+currentUserId+'\'';
            }

            if(shelfTileId != null  && shelfTileId != ''){
                validId = Id.valueOf(shelfTileId);

                whereClause += ' AND Shelf_Tile__c = \''+validId+'\'';
            }

            if(deviceType != null && deviceType != ''){
                whereClause += ' AND Report__r.Show_on_Devices__c INCLUDES  (\''+deviceType+'\')';
            }

            if(recordTypeName != null && recordTypeName != ''){
                Id recordTypeId = Schema.SObjectType.OV_Shelf__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                whereClause += ' AND Shelf_Tile__r.Shelf__r.RecordTypeId = \''+recordTypeId+'\'';
            }
        }catch(Exception ex){
            throw new OVException('Search method returns no results. Invalid parameters to build query', ex);
        }

        return whereClause;
    }

    /*******************************************************************
    Purpose: Private method for building SOQL query
    Parameterd Description:
    Parameters: [String geographyId, String categoryId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName]
    Sonar Note: npath complexity issue. not refactored beacuse of code readability
    Returns: [List<OV_ShelfTileReport__c>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    private static List<OV_ShelfTileReport__c> gatherResultsForSearch(String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String shelfTileId, String deviceType){
        String whereClauseForBet = buildWhereClausesForSearch(geographyId, categoryId, functionId, mineOnly, recordTypeName, shelfTileId, deviceType);

        String query = 'SELECT Report__c, Report__r.Name, Report__r.Category__c, Report__r.Reporting_Period__c, Report__r.Function__c, Report__r.Geography__c,'
        +' Report__r.Business_Owner__c, Report__r.Business_Owner__r.Name, Report__r.Publisher__c, Report__r.Publisher__r.Name,'
        +' Report__r.Desktop_Content_Proxy__c, Report__r.Desktop_Content_Proxy__r.Url__c, Report__r.Desktop_Content_Proxy__r.Title__c, Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c, Report__r.Mobile_Content_Proxy__c, Report__r.Colour_ltng__c, Report__r.Icon_ltng__c,'
        +' Report__r.Mobile_Content_Proxy__r.Url__c, Report__r.Mobile_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c, Report__r.Tablet_Content_Proxy__c, Report__r.Tablet_Content_Proxy__r.Url__c, Report__r.Tablet_Content_Proxy__r.Title__c, Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c, Report__r.Report_Heading__c, Report__r.CreatedDate, Report__r.Views__c, Shelf_Tile__c,'
        +' Shelf_Tile__r.Name, Shelf_Tile__r.Colour__c, Shelf_Tile__r.ICON_Label__c, Shelf_Tile__r.Tile_ICON__c, Shelf_Tile__r.Shelf__r.Id, Shelf_Tile__r.Shelf__r.Name,'
        +' Shelf_Tile__r.Shelf__r.Colour__c, Shelf_Tile__r.CreatedDate,'
        +' Shelf_Tile__r.Shelf__r.CreatedDate, Report__r.Report_Folder__c, Report__r.Unit__r.Name FROM OV_ShelfTileReport__c ' + whereClauseForBet + ' ORDER BY Shelf_Tile__r.Shelf__r.Sort_Order__c ASC NULLS LAST, Shelf_Tile__r.Shelf__r.Name, Shelf_Tile__r.Sort_Order__c ASC NULLS LAST, Shelf_Tile__r.Name, Report__r.Report_Heading_Sorting_Field__c ASC NULLS FIRST, Report__r.Report_Folder_Sorting_Field__c ASC NULLS LAST, Report__r.Unit__r.Name ASC NULLS LAST, Sort_Order__c, Report__r.Name, Report__r.CreatedDate';


        List<OV_ShelfTileReport__c> ovSearchList = new List<OV_ShelfTileReport__c>();
        
        System.debug(LoggingLevel.DEBUG, 'query: ' + query);

        /*SECURITY - CRUD/FLS Enforcement */
        String [] shelfTileReportAccessFields = new String [] {'Report__c', 'Shelf_Tile__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_ShelfTileReport__c', shelfTileReportAccessFields);

        String [] reportAccessFields = new String [] {'Name', 'Category__c', 'Reporting_Period__c', 'Function__c', 'Geography__c', 'Business_Owner__c', 'Publisher__c', 
                                                    'Desktop_Content_Proxy__c', 'Colour_ltng__c', 'Icon_ltng__c', 'Mobile_Content_Proxy__c', 'Tablet_Content_Proxy__c', 'Views__c', 'Report_Folder__c',
                                                    'Report_Heading__c', 'Unit__c', 'Report_Heading_Sorting_Field__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c', reportAccessFields);

        String [] shelfTileAccessFields = new String [] {'Id', 'Name', 'Colour__c', 'Tile_ICON__c', 'ICON_Label__c', 'Shelf__c', 'Sort_Order__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf_Tile__c', shelfTileAccessFields);

        String [] shelfAccessFields = new String [] {'Id', 'Name', 'Colour__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf__c', shelfAccessFields);

        String [] contentProxyAccessFields = new String [] {'Url__c', 'Title__c', 'LatestContentVersionId__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_ContentProxy__c', contentProxyAccessFields);
        /*SECURITY */
        
        ovSearchList = Database.query(query);
        return ovSearchList;
    }

    /*******************************************************************
    Purpose: Method is unified method for searching appropriate reports and returning structure of shelfs, tiles.
    Parameterd Description:
    Parameters: [String geographyId, String categoryId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String deviceType]
    Returns: [List<OV_Wrapper.ShelfWrapper>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static List<OV_Wrapper.ShelfWrapper> search(String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String deviceType){
        System.debug(LoggingLevel.DEBUG, 'Entering search: ' + geographyId + ' ' + categoryId + ' ' + functionId + ' ' + mineOnly + ' ' + recordTypeName + ' ' + deviceType);

        List<OV_ShelfTileReport__c> searchResults = gatherResultsForSearch(geographyId, categoryId, functionId, mineOnly, recordTypeName, null, deviceType);

        List<OV_Wrapper.ShelfWrapper> shelvesList = new List<OV_Wrapper.ShelfWrapper>();
        Map<Id, OV_Wrapper.ShelfWrapper> mapShelfIdToShelf = new Map<Id, OV_Wrapper.ShelfWrapper>();

        OV_Wrapper.ShelfWrapper shelf;

        Set<Id> contentVersionIds = new Set<Id>();
        for(OV_ShelfTileReport__c junction : searchResults){
            if (deviceType == OV_RemoteController.DEVICE_DESKTOP && junction.Report__r.Desktop_Content_Proxy__c != null) {
               contentVersionIds.add(junction.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c);
            }

            if (deviceType == OV_RemoteController.DEVICE_MOBILE && junction.Report__r.Mobile_Content_Proxy__r != null) {
               contentVersionIds.add(junction.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c);
            }

            if (deviceType == OV_RemoteController.DEVICE_TABLET && junction.Report__r.Tablet_Content_Proxy__r != null) {
               contentVersionIds.add(junction.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c);
            }
        }

        Map<Id, ContentVersion> idToContentVersionMap = getContentVersions(contentVersionIds);

        for(OV_ShelfTileReport__c junction : searchResults){
            if (deviceType == OV_RemoteController.DEVICE_DESKTOP
                &&
                (junction.Report__r.Desktop_Content_Proxy__c == null
                    || (junction.Report__r.Desktop_Content_Proxy__c != null
                        && !idToContentVersionMap.containsKey(junction.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c)
                        )
                ) ) {
               continue;
            }

            if (deviceType == OV_RemoteController.DEVICE_MOBILE
                &&
                (junction.Report__r.Mobile_Content_Proxy__c == null
                    || (junction.Report__r.Mobile_Content_Proxy__c != null
                        && !idToContentVersionMap.containsKey(junction.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c)
                        )
                ) ) {
               continue;
            }

            if (deviceType == OV_RemoteController.DEVICE_TABLET
                &&
                (junction.Report__r.Tablet_Content_Proxy__c == null
                    || (junction.Report__r.Tablet_Content_Proxy__c != null
                        && !idToContentVersionMap.containsKey(junction.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c)
                        )
                ) ) {
               continue;
            }

            Id shelfId = junction.Shelf_Tile__r.Shelf__c;
            Id shelfTileId = junction.Shelf_Tile__c;
            Boolean shelfAlreadyExists = shelfExists( shelfId, mapShelfIdToShelf );

            if (shelfAlreadyExists) {
                OV_Wrapper.ShelfTileWrapper tile;
                shelf = getShelf(shelfId, mapShelfIdToShelf);

                Boolean tileIsAlreadyOnShelf = isShelfTileOnShelf( shelfTileId, shelf );
                if (tileIsAlreadyOnShelf) {
                    tile = getShelfTileFromShelf(shelfTileId, shelf);
                }else{
                    tile = createShelfTile(junction);
                    shelf.addTile(tile);
                }
            }else{
                shelf = createShelf(junction);

                OV_Wrapper.ShelfTileWrapper tile = createShelfTile(junction);
                shelf.addTile(tile);

                addShelf(shelfId, shelf, mapShelfIdToShelf);
                shelvesList.add(shelf);
            }
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting search: ' + shelvesList);
        return shelvesList;
    }

    /*******************************************************************
    Purpose: Method for returning content versions for shelftilereports
    Parameters: [Set<Id> shelfTileReports]
    Returns: [Map<Id, ContentVersion>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    private static Map<Id, ContentVersion> getContentVersions(Set<Id> contentVersionIds){
        /*SECURITY - CRUD/FLS Enforcement */
        String [] accessFields = new String [] {'Id', 'Title', 'FileType', 'FileExtension', 'ContentDocumentId', 'LastModifiedDate', 'ContentSize'};
        OV_SecurityHelper.doPrivilegedOp('ContentVersion', accessFields);
        /*SECURITY */

        Map<Id, ContentVersion> idToContentVersionMap = new Map<Id, ContentVersion>();
        List<ContentVersion> contentVersions = [SELECT Id, Title, FileType, FileExtension, ContentDocumentId, LastModifiedDate, ContentSize FROM ContentVersion WHERE Id IN :contentVersionIds AND IsLatest = true];
        for(ContentVersion c : contentVersions){
            idToContentVersionMap.put(c.Id, c);
        }

        return idToContentVersionMap;
    }

    /*******************************************************************
    Purpose: Method for returning user's favourite reports
    Returns: [Set<Id>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static Map<Id, OV_Report_Favourite__c> getFavouritereports(){
        /*SECURITY - CRUD/FLS Enforcement */
        String [] accessFields = new String [] {'Id', 'Colour__c', 'Colour_ltng__c', 'User__c', 'Report__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_Report_Favourite__c', accessFields);

        String [] shelfTileAccessFields = new String [] {'Id', 'ICON_Label__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf_Tile__c', shelfTileAccessFields);
        /*SECURITY */

        Id userId = UserInfo.getUserId();
        OV_Profile__c profile = [SELECT Id FROM OV_Profile__c WHERE User__c =: userId];
        List<OV_Report_Favourite__c> favReports = [SELECT Id, Colour__c, Colour_ltng__c, Favourite_From_Shelf_Tile__c, Favourite_From_Shelf_Tile__r.Id, Favourite_From_Shelf_Tile__r.ICON_Label__c, Report__c, User__c FROM OV_Report_Favourite__c WHERE User__c = :profile.Id];

        Map<Id, OV_Report_Favourite__c> favReportsMap = new Map<Id, OV_Report_Favourite__c>();
        for(OV_Report_Favourite__c f : favReports){
            favReportsMap.put(f.Report__c, f);
        }
        return favReportsMap;
    }

    /*******************************************************************
    Purpose: Method for returning reports basing on shelf tile ID
    Parameters: [String geographyId, String categoryId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String shelfTileId, String deviceType]
    Returns: [List<OV_Wrapper.ReportWrapper>]
    Sonar Note: npath complexity issue. needs refactoring however leaving for now because of too complicated and time consuming.
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static Map<String, Object> getTileReports2(String geographyId, String categoryId, String functionId, Boolean mineOnly, String recordTypeName, String shelfTileId, String deviceType){
        System.debug(LoggingLevel.DEBUG, 'Entering getTileReports: ' + geographyId + ' ' + categoryId + ' ' + functionId + ' ' + mineOnly + ' ' + recordTypeName + ' ' + shelfTileId + ' ' + deviceType);

        Map<Id, OV_Wrapper.ReportWrapper> idToReport = new Map<Id, OV_Wrapper.ReportWrapper>();

        Map<Id, OV_Report_Favourite__c> myReportsMap = getFavouritereports();

        List<OV_ShelfTileReport__c> shelfTileReports = gatherResultsForSearch(geographyId, categoryId, functionId, mineOnly, recordTypeName, shelfTileId, deviceType);
        
        System.debug(LoggingLevel.DEBUG, 'shelfTileReports: ' + shelfTileReports);
        
        Set<Id> contentVersionIds = new Set<Id>();
        for(OV_ShelfTileReport__c str : shelfTileReports){
            if(deviceType == OV_RemoteController.DEVICE_DESKTOP && str.Report__r.Desktop_Content_Proxy__c != null && str.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c != null){
                contentVersionIds.add(str.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c);
            }

            if(deviceType == OV_RemoteController.DEVICE_TABLET && str.Report__r.Tablet_Content_Proxy__c != null && str.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c != null){
                contentVersionIds.add(str.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c);
            }

            if(deviceType == OV_RemoteController.DEVICE_MOBILE && str.Report__r.Mobile_Content_Proxy__c != null && str.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c != null){
                contentVersionIds.add(str.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c);
            }
        }
        Map<Id, ContentVersion> idToContentVersionMap = getContentVersions(contentVersionIds);

        List<OV_Wrapper.ReportWrapper> wrappedReports = new List<OV_Wrapper.ReportWrapper>();
        for(OV_ShelfTileReport__c str : shelfTileReports){
            Boolean isFavourite = myReportsMap.containsKey(str.Report__c);


            OV_Wrapper.ReportWrapper report;
            if(deviceType == OV_RemoteController.DEVICE_DESKTOP
                && str.Report__r.Desktop_Content_Proxy__c != null
                && idToContentVersionMap.containsKey(str.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c) ){
                Boolean isStatic = (str.Report__r.Desktop_Content_Proxy__r.Url__c == null || str.Report__r.Desktop_Content_Proxy__r.Url__c == '');

                report = createReportTile(str, isFavourite, isStatic);
                idToReport.put(str.Report__c, report);
                if(isStatic){
                    ContentVersion contentVersionItem = idToContentVersionMap.get(str.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c);
                    report.reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVersionItem, OV_ThumbnailPreviewBuilder.DESKTOP);
                }else{
                    report.reportDocument = new OV_Wrapper.ReportDocumentWrapper(str.Report__r.Desktop_Content_Proxy__r.Title__c, str.Report__r.Desktop_Content_Proxy__r.Url__c);
                }
                wrappedReports.add(report);
            }

            if(deviceType == OV_RemoteController.DEVICE_TABLET
                && str.Report__r.Tablet_Content_Proxy__c != null
                && idToContentVersionMap.containsKey(str.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c) ){
                Boolean isStatic = (str.Report__r.Tablet_Content_Proxy__r.Url__c == null || str.Report__r.Tablet_Content_Proxy__r.Url__c == '');

                report = createReportTile(str, isFavourite, isStatic);
                idToReport.put(str.Report__c, report);
                if(isStatic){
                    ContentVersion contentVersionItem = idToContentVersionMap.get(str.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c);
                    report.reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVersionItem, OV_ThumbnailPreviewBuilder.TABLET);
                }else{
                    report.reportDocument = new OV_Wrapper.ReportDocumentWrapper(str.Report__r.Tablet_Content_Proxy__r.Title__c, str.Report__r.Tablet_Content_Proxy__r.Url__c);
                }
                wrappedReports.add(report);
            }

            if(deviceType == OV_RemoteController.DEVICE_MOBILE
                && str.Report__r.Mobile_Content_Proxy__c != null
                && idToContentVersionMap.containsKey(str.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c) ){
                Boolean isStatic = (str.Report__r.Mobile_Content_Proxy__r.Url__c == null || str.Report__r.Mobile_Content_Proxy__r.Url__c == '');

                report = createReportTile(str, isFavourite, isStatic);
                idToReport.put(str.Report__c, report);
                if(isStatic){
                    ContentVersion contentVersionItem = idToContentVersionMap.get(str.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c);
                    report.reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVersionItem, OV_ThumbnailPreviewBuilder.MOBILE);
                }else{
                    report.reportDocument = new OV_Wrapper.ReportDocumentWrapper(str.Report__r.Mobile_Content_Proxy__r.Title__c, str.Report__r.Mobile_Content_Proxy__r.Url__c);
                }
                
                System.debug(LoggingLevel.DEBUG, 'report: ' + report);
                
                wrappedReports.add(report);
            }
        }
        
        /*SECURITY - CRUD/FLS Enforcement */
        String [] accessFields = new String [] {'Id', 'ParentId', 'Title', 'ContentType', 'CommentCount', 'LikeCount', 'RelatedRecordId'};
        OV_SecurityHelper.doPrivilegedOp('OV_Report__Feed', accessFields);
        /*SECURITY */  

        List<OV_Report__Feed> reportFeeds = [SELECT Id, ParentId, Title, ContentType, CommentCount, LikeCount, RelatedRecordId from OV_Report__Feed WHERE ParentId IN :idToReport.keySet()];
        for(OV_Report__Feed r : reportFeeds){
            if(idToReport.containsKey(r.ParentId)){
                idToReport.get(r.ParentId).increaseCommentsCounter(1+r.CommentCount);
            }
        }

        Map<String, Object> result = generateHeadingFolderStructure(wrappedReports);
        
        System.debug(LoggingLevel.DEBUG, 'Exiting getTileReports: ' + result);
        return result;
    }

    /*******************************************************************
    Purpose: Method for generating structure for reports/folders/headings
    Parameters: [List<OV_Wrapper.ReportWrapper> wrappedReports]
    Returns: [Map<String, Object>]
    Sonar Note: npath complexity issue. not refactored beacuse of code readability
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static Map<String, Object> generateHeadingFolderStructure(List<OV_Wrapper.ReportWrapper> wrappedReports){
        System.debug(LoggingLevel.DEBUG, 'Entering generateHeadingFolderStructure: ' + wrappedReports);

        Map<String, Object> structure = new Map<String, Object>();
        for(OV_Wrapper.ReportWrapper r : wrappedReports){
            if(structure.containsKey(r.reportHeading)){
                if(r.reportFolder != null){
                    //list of object/reports
                    OV_Wrapper.FolderLevelWrapper foldersLevel = (OV_Wrapper.FolderLevelWrapper) structure.get(r.reportHeading);
                    if(foldersLevel.folderLevelMembersMap.containsKey(r.reportFolder)){
                        OV_Wrapper.FolderWrapper folder = (OV_Wrapper.FolderWrapper) foldersLevel.folderLevelMembersMap.get(r.reportFolder);
                        folder.addMember(r);
                    }else{
                        OV_Wrapper.FolderWrapper folder = new OV_Wrapper.FolderWrapper(r.reportFolder);
                        folder.addMember(r);
                        foldersLevel.addMember(folder, true);
                    }
                }else{
                    OV_Wrapper.FolderLevelWrapper foldersLevel = (OV_Wrapper.FolderLevelWrapper) structure.get(r.reportHeading);
                    foldersLevel.addMember(r, false);
                }
            }else{
                //if no heading then add to map list of folders
                OV_Wrapper.FolderLevelWrapper foldersLevel = new OV_Wrapper.FolderLevelWrapper();

                if(r.reportFolder != null){
                    OV_Wrapper.FolderWrapper folder = new OV_Wrapper.FolderWrapper(r.reportFolder);
                    folder.addMember(r);
                    foldersLevel.addMember(folder, true);
                }else{
                    foldersLevel.addMember(r, false);
                }

                structure.put(r.reportHeading, foldersLevel);
            }
        }

        List<String> headingList = new List<String>();
        headingList.add('Global');

        List<String> structureList = new List<String>(structure.keySet());
        structureList.sort();
        for(String s : structureList){
            if(s != 'Global'){
                headingList.add(s);
            }
        }

        Map<String, Object> structure2 = new Map<String, Object>();
        for(String structureHeaderName : headingList){
            if(structure.containsKey(structureHeaderName)){
                OV_Wrapper.FolderLevelWrapper structureMembersList = (OV_Wrapper.FolderLevelWrapper)structure.get(structureHeaderName);

                for(Integer i=0; i<structureMembersList.folderLevelMembers.size(); i++){
                    if(structureMembersList.folderLevelMembers[i] instanceof OV_Wrapper.FolderWrapper){
                        OV_Wrapper.FolderWrapper structureFolderWrapped = (OV_Wrapper.FolderWrapper)structureMembersList.folderLevelMembers[i];
                        if( structureFolderWrapped.folderMembers.size() == 1){
                            structureMembersList.folderLevelMembers[i] = (Object)structureFolderWrapped.folderMembers[0];
                        }
                    }
                }

                // folders go first, then reports
                OV_Wrapper.FolderLevelWrapper tmpMemberList = new OV_Wrapper.FolderLevelWrapper();
                for(Integer i=0; i<structureMembersList.folderLevelMembers.size(); i++){
                    if(structureMembersList.folderLevelMembers[i] instanceof OV_Wrapper.FolderWrapper){
                        tmpMemberList.folderLevelMembers.add(structureMembersList.folderLevelMembers[i]);
                    }
                }
                // now add reports
                for(Integer i=0; i<structureMembersList.folderLevelMembers.size(); i++){
                    if(!(structureMembersList.folderLevelMembers[i] instanceof OV_Wrapper.FolderWrapper)) {
                        tmpMemberList.folderLevelMembers.add(structureMembersList.folderLevelMembers[i]);
                    }
                }

                structureMembersList = tmpMemberList;

                structure2.put(structureHeaderName, structureMembersList);
            }
        }
        return structure2;
    }


    /*******************************************************************
    Purpose: Method for sorting contentversions by version number
    Parameterd Description: created due to fact that versionumber is STRING field
    Parameters: [List<ContentVersion> contentVersions]
    Returns: [List<ContentVersion>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    private static List<ContentVersion> getSortedContentVersions(List<ContentVersion> contentVersions){
        List<Integer> order = new List<Integer>();
        Map<Integer, ContentVersion> cVMap = new Map<Integer, ContentVersion>();
        for(ContentVersion cV : contentVersions){
            cVMap.put(Integer.valueOf(cV.VersionNumber), cV);
            order.add(Integer.valueOf(cV.VersionNumber));
        }
        //ASC ORDER
        order.sort();

        //Because of DESC order
        List<ContentVersion> sortedContentVersions = new List<ContentVersion>();
        for(Integer i = order.size()-1; i>=0;i--){
            sortedContentVersions.add(cVMap.get(order.get(i)));
        }

        return sortedContentVersions;
    }

    /*******************************************************************
    Purpose: Method for returning report data.
    Parameterd Description:
    Parameters: [String reportId, String shelfTileId, String deviceType]
    Returns: [OV_Wrapper.ReportWrapper]
    Sonar Note: npath complexity issue. needs refactoring however leaving for now because of too complicated and time consuming.
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static OV_Wrapper.ReportWrapper getReportDetails(String reportId, String shelfTileId, String deviceType){
        System.debug(LoggingLevel.DEBUG, 'Entering getReportDetails: ' + reportId + ' '+ shelfTileId + ' ' + deviceType);

        Map<Id, OV_Report_Favourite__c> myReportsMap = getFavouritereports();

        OV_ShelfTileReport__c reportTile;
        OV_Wrapper.ReportDocumentWrapper reportDocument;
        List<ContentVersion> reportContentVersions;

        Boolean isStatic;
        try{
            String query = 'SELECT Report__c, Report__r.Name, Report__r.Geography__c, Report__r.Category__c, Report__r.Function__c, Report__r.Business_Owner__c,'
                    +'Report__r.Business_Owner__r.Name, Report__r.Publisher__c, Report__r.Publisher__r.Name, Report__r.Description__c, Report__r.Publisher__r.SmallPhotoUrl,'
                    +'Report__r.Business_Owner__r.SmallPhotoUrl, Report__r.Url__c, Report__r.Frequency__c, Report__r.Reporting_Period__c, Report__r.Value__c,'
                    +'Report__r.Desktop_Content_Proxy__c, Report__r.Desktop_Content_Proxy__r.Url__c, Report__r.Desktop_Content_Proxy__r.Title__c, Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c,'
                    +'Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c, Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c, Report__r.Tablet_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__c, Report__r.Mobile_Content_Proxy__r.Url__c, Report__r.Tablet_Content_Proxy__c, Report__r.Tablet_Content_Proxy__r.Url__c, '
                    +'Shelf_Tile__c, Shelf_Tile__r.Name, Shelf_Tile__r.Colour__c, Shelf_Tile__r.Tile_ICON__c, Shelf_Tile__r.ICON_Label__c,'
                    +'Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c, Report__r.Mobile_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__r.ContentDocumentId__c, Report__r.Tablet_Content_Proxy__r.ContentDocumentId__c,'
                    +'Shelf_Tile__r.Shelf__r.Id, Shelf_Tile__r.Shelf__r.Name, Shelf_Tile__r.Shelf__r.Colour__c, Report__r.CreatedDate, Report__r.Views__c, Report__r.Report_Folder__c FROM OV_ShelfTileReport__c WHERE Report__c = :reportId';

            if(shelfTileId != null && shelfTileId != ''){
                String whereClause = ' AND Shelf_Tile__c = :shelfTileId LIMIT 1';
                query = query+whereClause;
            }else{
                String whereClause = ' LIMIT 1';
                query = query+whereClause;
            }

            /*SECURITY - CRUD/FLS Enforcement */
            String [] shelfTileReportAccessFields = new String [] {'Report__c', 'Shelf_Tile__c'};
            OV_SecurityHelper.doPrivilegedOp('OV_ShelfTileReport__c', shelfTileReportAccessFields);

            String [] reportAccessFields = new String [] {'Name', 'Geography__c', 'Category__c', 'Function__c', 'Business_Owner__c', 'Publisher__c', 'Description__c', 'Desktop_Content_Proxy__c',
                                                        'Mobile_Content_Proxy__c', 'Tablet_Content_Proxy__c', 'Mobile_Content_Proxy__c', 'Views__c', 'Report_Folder__c'};
            OV_SecurityHelper.doPrivilegedOp('OV_Report__c', reportAccessFields);

            String [] shelfTileAccessFields = new String [] {'Id', 'Name', 'Colour__c', 'Tile_ICON__c', 'ICON_Label__c', 'Shelf__c'};
            OV_SecurityHelper.doPrivilegedOp('OV_Shelf_Tile__c', shelfTileAccessFields);

            String [] shelfAccessFields = new String [] {'Id', 'Name', 'Colour__c'};
            OV_SecurityHelper.doPrivilegedOp('OV_Shelf__c', shelfAccessFields);

            String [] contentProxyAccessFields = new String [] {'Url__c', 'Title__c', 'LatestContentVersionId__c'};
            OV_SecurityHelper.doPrivilegedOp('OV_ContentProxy__c', contentProxyAccessFields);
            /*SECURITY */

            reportTile = Database.query(query);

            if(deviceType == OV_RemoteController.DEVICE_MOBILE && reportTile.Report__r.Mobile_Content_Proxy__c != null && reportTile.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c != null){
                isStatic = (reportTile.Report__r.Mobile_Content_Proxy__r.Url__c == null || reportTile.Report__r.Mobile_Content_Proxy__r.Url__c == '');
                if(isStatic){
                    ContentVersion contentVer = [SELECT Id, Title, FileType, FileExtension, ContentDocumentId, LastModifiedDate, ContentSize FROM ContentVersion WHERE Id = :reportTile.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c AND IsLatest = true LIMIT 1];
                    reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVer, OV_ThumbnailPreviewBuilder.MOBILE);
                }else{
                    reportDocument = new OV_Wrapper.ReportDocumentWrapper(reportTile.Report__r.Mobile_Content_Proxy__r.Title__c, reportTile.Report__r.Mobile_Content_Proxy__r.Url__c);
                }
                reportDocument.setReportShelfTileReportId(shelfTileId, reportTile.Report__c);
                List<ContentVersion> reportContentVersionsTmp = [select Id, Title, ContentDocumentId, IsLatest, VersionNumber, LastModifiedDate from ContentVersion where ContentDocumentId = :reportTile.Report__r.Mobile_Content_Proxy__r.ContentDocumentId__c order by VersionNumber desc];
                reportContentVersions = getSortedContentVersions(reportContentVersionsTmp);
            }

            if(deviceType == OV_RemoteController.DEVICE_DESKTOP && reportTile.Report__r.Desktop_Content_Proxy__c != null && reportTile.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c != null){
                isStatic = (reportTile.Report__r.Desktop_Content_Proxy__r.Url__c == null || reportTile.Report__r.Desktop_Content_Proxy__r.Url__c == '');
                if(isStatic){
                    ContentVersion contentVer = [SELECT Id, Title, FileType, FileExtension, ContentDocumentId, LastModifiedDate, ContentSize FROM ContentVersion WHERE Id = :reportTile.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c AND IsLatest = true LIMIT 1];
                    reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVer, OV_ThumbnailPreviewBuilder.DESKTOP);
                }else{
                    reportDocument = new OV_Wrapper.ReportDocumentWrapper(reportTile.Report__r.Desktop_Content_Proxy__r.Title__c, reportTile.Report__r.Desktop_Content_Proxy__r.Url__c);
                }   
                reportDocument.setReportShelfTileReportId(shelfTileId, reportTile.Report__c);
                List<ContentVersion> reportContentVersionsTmp = [select Id, Title, ContentDocumentId, IsLatest, VersionNumber, LastModifiedDate from ContentVersion where ContentDocumentId = :reportTile.Report__r.Desktop_Content_Proxy__r.ContentDocumentId__c order by VersionNumber desc];                 
                reportContentVersions = getSortedContentVersions(reportContentVersionsTmp);
            }

            if(deviceType == OV_RemoteController.DEVICE_TABLET && reportTile.Report__r.Tablet_Content_Proxy__c != null && reportTile.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c != null){
                isStatic = (reportTile.Report__r.Tablet_Content_Proxy__r.Url__c == null || reportTile.Report__r.Tablet_Content_Proxy__r.Url__c == '');
                if(isStatic){
                    ContentVersion contentVer = [SELECT Id, Title, FileType, FileExtension, ContentDocumentId, LastModifiedDate, ContentSize FROM ContentVersion WHERE Id = :reportTile.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c AND IsLatest = true LIMIT 1];
                    reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVer, OV_ThumbnailPreviewBuilder.TABLET);
                }else{
                    reportDocument = new OV_Wrapper.ReportDocumentWrapper(reportTile.Report__r.Tablet_Content_Proxy__r.Title__c, reportTile.Report__r.Tablet_Content_Proxy__r.Url__c);
                }
                reportDocument.setReportShelfTileReportId(shelfTileId, reportTile.Report__c);
                List<ContentVersion> reportContentVersionsTmp = [select Id, Title, ContentDocumentId, IsLatest, VersionNumber, LastModifiedDate from ContentVersion where ContentDocumentId = :reportTile.Report__r.Tablet_Content_Proxy__r.ContentDocumentId__c order by VersionNumber desc];
                reportContentVersions = getSortedContentVersions(reportContentVersionsTmp);
           }
        }catch(Exception ex){
            throw new OVException('No results for this id.', ex);
        }

        Boolean isFavourite = myReportsMap.containsKey(reportTile.Report__c);
        OV_Wrapper.ReportWrapper wrappedReport = new OV_Wrapper.ReportWrapper(reportTile, reportDocument, reportContentVersions, isFavourite, isStatic);
        if(isFavourite){
            wrappedReport.reportColourLtng = myReportsMap.get(reportTile.Report__c).Colour_ltng__c;
        }

        /*SECURITY - CRUD/FLS Enforcement */
        String [] accessFields = new String [] {'Id', 'ParentId', 'Title', 'ContentType', 'CommentCount', 'LikeCount', 'RelatedRecordId'};
        OV_SecurityHelper.doPrivilegedOp('OV_Report__Feed', accessFields);
        /*SECURITY */                

        List<OV_Report__Feed> reportFeeds = [SELECT Id, ParentId, Title, ContentType, CommentCount, LikeCount, RelatedRecordId from OV_Report__Feed WHERE ParentId = :reportId];
        for(OV_Report__Feed r : reportFeeds){
            wrappedReport.increaseCommentsCounter(1+r.CommentCount);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getReportDetails: ' + wrappedReport);
        return wrappedReport;
    }
    
    /*******************************************************************
    Purpose: Method for returning favourite
    Parameters: [String deviceType]
    Returns: [List<OV_Wrapper.ReportWrapper>]
    Sonar Note: npath complexity issue. needs refactoring however leaving for now because of too complicated and time consuming.
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static Map<String, List<OV_Wrapper.ReportWrapper>> getMyFavouritesReports(String geographyId, String categoryId, String functionId, Boolean mineOnly, String deviceType){
        System.debug(LoggingLevel.DEBUG, 'Entering getMyFavouritesReports: deviceType ' + deviceType);

        Map<Id, OV_Report_Favourite__c> myReportsMap = getFavouritereports();
        Set<Id> myReportsIds = myReportsMap.keySet();

        String whereClause = buildWhereClausesForSearch(geographyId, categoryId, functionId, mineOnly, null, null, deviceType);

        String query = 'SELECT Report__c, Report__r.Name, Report__r.Category__c, Report__r.Reporting_Period__c, Report__r.Function__c, Report__r.Geography__c,'
        +' Report__r.Business_Owner__c, Report__r.Business_Owner__r.Name, Report__r.Publisher__c, Report__r.Publisher__r.Name,'
        +' Report__r.Desktop_Content_Proxy__c, Report__r.Desktop_Content_Proxy__r.Url__c, Report__r.Desktop_Content_Proxy__r.Title__c, Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c, Report__r.Mobile_Content_Proxy__c, Report__r.Colour_ltng__c, Report__r.Icon_ltng__c,'
        +' Report__r.Mobile_Content_Proxy__r.Url__c, Report__r.Mobile_Content_Proxy__r.Title__c, Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c, Report__r.Tablet_Content_Proxy__c, Report__r.Tablet_Content_Proxy__r.Url__c, Report__r.Tablet_Content_Proxy__r.Title__c, Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c, Report__r.Report_Heading__c, Report__r.CreatedDate, Report__r.Views__c, Shelf_Tile__c,'
        +' Report__r.Favourite_From_Shelf_Tile__c, Report__r.Favourite_From_Shelf_Tile__r.Id, Shelf_Tile__r.Id, Shelf_Tile__r.Name, Shelf_Tile__r.Colour__c, Shelf_Tile__r.ICON_Label__c, Shelf_Tile__r.Tile_ICON__c, Shelf_Tile__r.Shelf__r.Id, Shelf_Tile__r.Shelf__r.Name,'
        +' Shelf_Tile__r.Shelf__r.Colour__c, Shelf_Tile__r.CreatedDate, Shelf_Tile__r.Shelf__r.RecordTypeId, Sort_Order__c, Report__r.Unit__r.Name,'
        +' Shelf_Tile__r.Shelf__r.CreatedDate, Report__r.Report_Folder__c FROM OV_ShelfTileReport__c ' + whereClause + ' AND Report__c IN :myReportsIds ORDER BY Shelf_Tile__r.Shelf__r.Sort_Order__c ASC NULLS LAST, Shelf_Tile__r.Shelf__r.Name, Shelf_Tile__r.Sort_Order__c ASC NULLS LAST, Shelf_Tile__r.Name, Report__r.Report_Heading_Sorting_Field__c ASC NULLS FIRST, Report__r.Report_Folder_Sorting_Field__c ASC NULLS LAST, Report__r.Unit__r.Name ASC NULLS LAST, Sort_Order__c, Report__r.Name, Report__r.CreatedDate';

        /*SECURITY - CRUD/FLS Enforcement */
        String [] shelfTileReportAccessFields = new String [] {'Report__c', 'Shelf_Tile__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_ShelfTileReport__c', shelfTileReportAccessFields);

        String [] reportAccessFields = new String [] {'Name', 'Category__c', 'Reporting_Period__c', 'Function__c', 'Geography__c', 'Business_Owner__c', 'Publisher__c', 
                                                                'Desktop_Content_Proxy__c', 'Mobile_Content_Proxy__c', 'Colour_ltng__c', 'Icon_ltng__c', 'Tablet_Content_Proxy__c',
                                                                'Report_Heading__c', 'Views__c', 'Unit__c', 'Report_Folder__c', 'Report_Heading_Sorting_Field__c', 'Report_Folder_Sorting_Field__c'
                                                                };
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c', reportAccessFields);

        String [] shelfTileAccessFields = new String [] {'Id', 'Name', 'Colour__c', 'ICON_Label__c', 'Shelf__c', 'Sort_Order__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf_Tile__c', shelfTileAccessFields);

        String [] shelfAccessFields = new String [] {'Id', 'Name', 'Colour__c', 'RecordTypeId', 'Sort_Order__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_Shelf__c', shelfAccessFields);

        String [] contentProxyAccessFields = new String [] {'Url__c', 'Title__c', 'LatestContentVersionId__c'};
        OV_SecurityHelper.doPrivilegedOp('OV_ContentProxy__c', contentProxyAccessFields);
        /*SECURITY */

        List<OV_ShelfTileReport__c> shelfTileReportsList = Database.query(query);
                
        List<OV_ShelfTileReport__c> filteredShelfTileReportsList = new List<OV_ShelfTileReport__c>();
        for(OV_ShelfTileReport__c r : shelfTileReportsList){
            if(r.Shelf_Tile__r.Id == myReportsMap.get(r.Report__c).Favourite_From_Shelf_Tile__r.Id){
                filteredShelfTileReportsList.add(r);
            }
        }
                
        Set<Id> contentVersionIds = new Set<Id>();
        for(OV_ShelfTileReport__c filteredShelfTileReport : filteredShelfTileReportsList){
            if(deviceType == OV_RemoteController.DEVICE_DESKTOP && filteredShelfTileReport.Report__r.Desktop_Content_Proxy__c != null && filteredShelfTileReport.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c != null){
                contentVersionIds.add(filteredShelfTileReport.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c);
            }

            if(deviceType == OV_RemoteController.DEVICE_TABLET && filteredShelfTileReport.Report__r.Tablet_Content_Proxy__c != null && filteredShelfTileReport.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c != null){
                contentVersionIds.add(filteredShelfTileReport.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c);
            }

            if(deviceType == OV_RemoteController.DEVICE_MOBILE && filteredShelfTileReport.Report__r.Mobile_Content_Proxy__c != null && filteredShelfTileReport.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c != null){
                contentVersionIds.add(filteredShelfTileReport.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c);
            }
        }

        Map<Id, ContentVersion> idToContentVersionMap = getContentVersions(contentVersionIds);

        Map<String, List<OV_Wrapper.ReportWrapper>> resultsMap = new Map<String, List<OV_Wrapper.ReportWrapper>>();
        resultsMap.put(SUBJECTS, new List<OV_Wrapper.ReportWrapper>());
        resultsMap.put(MOMENTS, new List<OV_Wrapper.ReportWrapper>());
        
        Id subjectRecordTypeId = Schema.SObjectType.OV_Shelf__c.getRecordTypeInfosByName().get('Subject').getRecordTypeId();

        Map<Id, OV_Wrapper.ReportWrapper> idToReport = new Map<Id, OV_Wrapper.ReportWrapper>();
        for(OV_ShelfTileReport__c shelfTileReport : filteredShelfTileReportsList){
            if(deviceType == OV_RemoteController.DEVICE_MOBILE
                && shelfTileReport.Report__r.Mobile_Content_Proxy__c != null
                && shelfTileReport.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c != null
                && idToContentVersionMap.containsKey(shelfTileReport.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c) ){
                Boolean isStatic = (shelfTileReport.Report__r.Mobile_Content_Proxy__r.Url__c == null || shelfTileReport.Report__r.Mobile_Content_Proxy__r.Url__c == '');
                OV_Wrapper.ReportWrapper wrappedReport = createFavouriteReport(shelfTileReport, isStatic, myReportsMap.get(shelfTileReport.Report__c));
                idToReport.put(wrappedReport.reportId, wrappedReport);

                if(isStatic){
                    ContentVersion contentVer = idToContentVersionMap.get(shelfTileReport.Report__r.Mobile_Content_Proxy__r.LatestContentVersionId__c);
                    wrappedReport.reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVer, OV_ThumbnailPreviewBuilder.MOBILE);
                }else{
                    wrappedReport.reportDocument = new OV_Wrapper.ReportDocumentWrapper(shelfTileReport.Report__r.Mobile_Content_Proxy__r.Title__c, shelfTileReport.Report__r.Mobile_Content_Proxy__r.Url__c);
                }
                if(shelfTileReport.Shelf_Tile__r.Shelf__r.RecordTypeId == subjectRecordTypeId){
                    resultsMap.get(SUBJECTS).add(wrappedReport);
                }else{
                    resultsMap.get(MOMENTS).add(wrappedReport);
                }
            }

            if(deviceType == OV_RemoteController.DEVICE_TABLET
                && shelfTileReport.Report__r.Tablet_Content_Proxy__c != null
                && shelfTileReport.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c != null
                && idToContentVersionMap.containsKey(shelfTileReport.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c) ){
                Boolean isStatic = (shelfTileReport.Report__r.Tablet_Content_Proxy__r.Url__c == null || shelfTileReport.Report__r.Tablet_Content_Proxy__r.Url__c == '');
                OV_Wrapper.ReportWrapper wrappedReport = createFavouriteReport(shelfTileReport, isStatic, myReportsMap.get(shelfTileReport.Report__c));
                idToReport.put(wrappedReport.reportId, wrappedReport);

                if(isStatic){
                    ContentVersion contentVer = idToContentVersionMap.get(shelfTileReport.Report__r.Tablet_Content_Proxy__r.LatestContentVersionId__c);
                    wrappedReport.reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVer, OV_ThumbnailPreviewBuilder.TABLET);
                }else{
                    wrappedReport.reportDocument = new OV_Wrapper.ReportDocumentWrapper(shelfTileReport.Report__r.Tablet_Content_Proxy__r.Title__c, shelfTileReport.Report__r.Tablet_Content_Proxy__r.Url__c);
                }
                if(shelfTileReport.Shelf_Tile__r.Shelf__r.RecordTypeId == subjectRecordTypeId){
                    resultsMap.get(SUBJECTS).add(wrappedReport);
                }else{
                    resultsMap.get(MOMENTS).add(wrappedReport);
                }
            }

            if(deviceType == OV_RemoteController.DEVICE_DESKTOP
                && shelfTileReport.Report__r.Desktop_Content_Proxy__c != null
                && shelfTileReport.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c != null
                && idToContentVersionMap.containsKey(shelfTileReport.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c) ){
                Boolean isStatic = (shelfTileReport.Report__r.Desktop_Content_Proxy__r.Url__c == null || shelfTileReport.Report__r.Desktop_Content_Proxy__r.Url__c == '');
                OV_Wrapper.ReportWrapper wrappedReport = createFavouriteReport(shelfTileReport, isStatic, myReportsMap.get(shelfTileReport.Report__c));
                idToReport.put(wrappedReport.reportId, wrappedReport);

                if(isStatic){
                    ContentVersion contentVer = idToContentVersionMap.get(shelfTileReport.Report__r.Desktop_Content_Proxy__r.LatestContentVersionId__c);
                    wrappedReport.reportDocument = new OV_Wrapper.ReportDocumentWrapper(contentVer, OV_ThumbnailPreviewBuilder.DESKTOP);
                }else{
                    wrappedReport.reportDocument = new OV_Wrapper.ReportDocumentWrapper(shelfTileReport.Report__r.Desktop_Content_Proxy__r.Title__c, shelfTileReport.Report__r.Desktop_Content_Proxy__r.Url__c);
                }

                if(shelfTileReport.Shelf_Tile__r.Shelf__r.RecordTypeId == subjectRecordTypeId){
                    resultsMap.get(SUBJECTS).add(wrappedReport);
                }else{
                    resultsMap.get(MOMENTS).add(wrappedReport);
                }
            }
        }

        List<OV_Report__Feed> reportFeeds = [SELECT Id, ParentId, Title, ContentType, CommentCount, LikeCount, RelatedRecordId from OV_Report__Feed WHERE ParentId IN :idToReport.keySet()];
        for(OV_Report__Feed r : reportFeeds){
            if(idToReport.containsKey(r.ParentId)){
                idToReport.get(r.ParentId).increaseCommentsCounter(1+r.CommentCount);
            }
        }
        
        System.debug(LoggingLevel.DEBUG, 'Exiting getMyFavouritesReports: ' + resultsMap);
        return resultsMap;
    }

    private static OV_Wrapper.ReportWrapper createReportTile(OV_ShelfTileReport__c shelfTileReport, Boolean isFavourite, Boolean isStatic){
        return new OV_Wrapper.ReportWrapper(
            shelfTileReport.Report__c,
            shelfTileReport.Report__r.Name,
            shelfTileReport.Report__r.Reporting_Period__c,
            shelfTileReport.Report__r.Colour_ltng__c,
            shelfTileReport.Report__r.Icon_ltng__c,
            shelfTileReport.Report__r.Report_Heading__c,
            shelfTileReport.Report__r.Report_Folder__c,
            shelfTileReport.Report__r.CreatedDate,
            shelfTileReport.Report__r.Views__c,
            isFavourite,
            isStatic
        );
    }

    private static OV_Wrapper.ReportWrapper createFavouriteReport(OV_ShelfTileReport__c shelfTileReport, Boolean isStatic, OV_Report_Favourite__c favObject){
        return new OV_Wrapper.ReportWrapper(
            shelfTileReport.Report__r.Id,
            shelfTileReport.Report__r.Name,
            shelfTileReport.Report__r.Reporting_Period__c,
            favObject.Colour_ltng__c,
            shelfTileReport.Report__r.Icon_ltng__c,
            shelfTileReport.Report__r.Report_Folder__c,
            shelfTileReport.Report__r.Report_Heading__c,
            shelfTileReport.Report__r.CreatedDate,
            shelfTileReport.Report__r.Views__c,
            shelfTileReport.Sort_Order__c,
            true,
            isStatic
        );
    }

    private static Boolean shelfExists(Id shelfId, Map<Id, OV_Wrapper.ShelfWrapper> shelfIdToShelf){
        return shelfIdToShelf.containsKey( shelfId );
    }

    private static OV_Wrapper.ShelfWrapper getShelf(Id shelfId, Map<Id, OV_Wrapper.ShelfWrapper> shelfIdToShelf){
        return shelfIdToShelf.get( shelfId );
    }

    private static void addShelf(Id shelfId, OV_Wrapper.ShelfWrapper shelf, Map<Id, OV_Wrapper.ShelfWrapper> shelfIdToShelf){
        shelfIdToShelf.put(shelfId, shelf);
    }

    private static Boolean isShelfTileOnShelf(Id tileId, OV_Wrapper.ShelfWrapper shelf){
        return shelf.shelfTilesMap.containsKey(tileId);
    }

    private static OV_Wrapper.ShelfTileWrapper getShelfTileFromShelf(Id shelfTileId, OV_Wrapper.ShelfWrapper shelf){
        return shelf.shelfTilesMap.get(shelfTileId);
    }

    private static OV_Wrapper.ShelfTileWrapper createShelfTile(OV_ShelfTileReport__c shelfTileReport){
        return new OV_Wrapper.ShelfTileWrapper(shelfTileReport.Shelf_Tile__c, shelfTileReport.Shelf_Tile__r.Name, shelfTileReport.Shelf_Tile__r.Colour__c, shelfTileReport.Shelf_Tile__r.Tile_ICON__c, shelfTileReport.Shelf_Tile__r.ICON_Label__c, shelfTileReport.Shelf_Tile__r.Shelf__c, shelfTileReport.Shelf_Tile__r.CreatedDate);
    }

    private static OV_Wrapper.ShelfWrapper createShelf(OV_ShelfTileReport__c shelfTileReport){
        return new OV_Wrapper.ShelfWrapper(shelfTileReport.Shelf_Tile__r.Shelf__c, shelfTileReport.Shelf_Tile__r.Shelf__r.Name, shelfTileReport.Shelf_Tile__r.Shelf__r.Colour__c, shelfTileReport.Shelf_Tile__r.Shelf__r.CreatedDate);
    }
}