/**********************************************************************
Name: OV_Wrapper
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Common wrapper 
Sonar report: Excessive Public Count. Issue because class is used as a container for other wrappers.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             25/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_Wrapper {
    @AuraEnabled
    public String message = null;

    @AuraEnabled
    public String status = null;

    @AuraEnabled
    public Map<String, Object> data = null;

    public OV_Wrapper(String cMessage, String cStatus, Map<String, Object> cData) {
        this.message = cMessage;
        this.status = cStatus;
        this.data = cData;
    }

    /*
    Sonar report: Too Many Fields issue. ReportWrapper used for transporting data between frontend and backend through remote actions. Refactoring is not required.
    */
    public class ReportWrapper implements Comparable {
        @AuraEnabled
        public Id reportId;
        @AuraEnabled
        public String reportTitle;
        @AuraEnabled
        public String reportGeographyId;
        @AuraEnabled
        public String reportCategoryId;
        @AuraEnabled
        public String reportFunctionId;
        @AuraEnabled
        public Id reportBusinessOwnerId;
        @AuraEnabled
        public String reportBusinessOwnerName;
        @AuraEnabled
        public String reportBusinessOwnerImage;
        @AuraEnabled
        public Id reportPublisherId;
        @AuraEnabled
        public String reportPublisherName;
        @AuraEnabled
        public String reportPublisherImage;
        @AuraEnabled
        public String reportDescription;
        @AuraEnabled
        public ShelfWrapper reportShelf;
        @AuraEnabled
        public ShelfTileWrapper reportTile;
        @AuraEnabled
        public String reportUrl;
        @AuraEnabled
        public String reportFrequency;
        @AuraEnabled
        public String reportPeriod;
        @AuraEnabled
        public Decimal reportValue;
        @AuraEnabled
        public OV_Wrapper.ReportDocumentWrapper reportDocument;
        @AuraEnabled
        public Boolean reportIsFavourite;
        @AuraEnabled
        public Boolean reportIsStatic;
        @AuraEnabled
        public String reportColourLtng;
        @AuraEnabled
        public String reportIconLtng;
        @AuraEnabled
        public String reportHeading;
        @AuraEnabled
        public Datetime reportCreatedDate;
        @AuraEnabled
        public Decimal reportViews;
        @AuraEnabled
        public Decimal reportComments;
        @AuraEnabled
        public String reportFolder;
        @AuraEnabled
        public Decimal reportSortOrder;
        @AuraEnabled
        public List<ContentVersion> reportContentVersions;

        /*
        Sonar Note: Excessive Parameter List issue. Needs refactoring however leaving for now because it's too complicated and time consuming
        */
        public ReportWrapper(String cReportId, String cReportTitle, String cReportReportingPeriod, String cColorLtng, 
                                String cIconLtng, String cHeading, String cFolder, Datetime cReportCreatedDate, Decimal cViews, Boolean cIsFavourite, Boolean cIsStatic){

            this.reportId = cReportId;
            this.reportTitle = cReportTitle;
            this.reportPeriod = cReportReportingPeriod;
            this.reportColourLtng = cColorLtng;
            this.reportIconLtng = cIconLtng;
            this.reportHeading = cHeading;
            this.reportFolder = cFolder;
            this.reportCreatedDate = cReportCreatedDate;
            this.reportViews = cViews;
            this.reportIsFavourite = cIsFavourite;
            this.reportIsStatic = cIsStatic;
        }

        /*
        Sonar Note: Excessive Parameter List issue. Needs refactoring however leaving for now because it's too complicated and time consuming
        */
        public ReportWrapper(String cReportId, String cReportTitle, String cReportReportingPeriod, String cColorLtng, 
                                String cIconLtng, String cHeading, String cFolder, Datetime cReportCreatedDate, Decimal cViews, Decimal cSortOrder, Boolean cIsFavourite, Boolean cIsStatic){

            this.reportId = cReportId;
            this.reportTitle = cReportTitle;
            this.reportPeriod = cReportReportingPeriod;
            this.reportColourLtng = cColorLtng;
            this.reportIconLtng = cIconLtng;
            this.reportHeading = cHeading;
            this.reportFolder = cFolder;
            this.reportCreatedDate = cReportCreatedDate;
            this.reportViews = cViews;
            this.reportIsFavourite = cIsFavourite;
            this.reportIsStatic = cIsStatic;
            this.reportSortOrder = cSortOrder;
        }

        /*
        Sonar Note: Excessive Parameter List issue. Needs refactoring however leaving for now because it's too complicated and time consuming
        */
        public ReportWrapper(OV_ShelfTileReport__c obj, OV_Wrapper.ReportDocumentWrapper cReportDocument, List<ContentVersion> cContentVersions, Boolean cIsFavourite, Boolean cIsStatic){
            this.reportId = obj.Report__c;
            this.reportTitle = obj.Report__r.Name;
            this.reportGeographyId = obj.Report__r.Geography__c;
            this.reportCategoryId = obj.Report__r.Category__c;
            this.reportFunctionId = obj.Report__r.Function__c;
            this.reportBusinessOwnerId = obj.Report__r.Business_Owner__c;
            this.reportBusinessOwnerName = obj.Report__r.Business_Owner__r.Name;
            this.reportBusinessOwnerImage = obj.Report__r.Business_Owner__r.SmallPhotoUrl;
            this.reportPublisherId = obj.Report__r.Publisher__c;
            this.reportPublisherName = obj.Report__r.Publisher__r.Name;
            this.reportPublisherImage = obj.Report__r.Publisher__r.SmallPhotoUrl;
            this.reportDescription = obj.Report__r.Description__c;
            this.reportShelf = new ShelfWrapper(obj.Shelf_Tile__r.Shelf__c, obj.Shelf_Tile__r.Shelf__r.Name, obj.Shelf_Tile__r.Shelf__r.Colour__c, obj.Report__r.CreatedDate);
            this.reportTile = new ShelfTileWrapper(obj.Shelf_Tile__c, obj.Shelf_Tile__r.Name, obj.Shelf_Tile__r.Colour__c, obj.Shelf_Tile__r.Tile_ICON__c, obj.Shelf_Tile__r.ICON_Label__c, obj.Shelf_Tile__r.Shelf__c, obj.Report__r.CreatedDate);
            this.reportFrequency = obj.Report__r.Frequency__c;
            this.reportPeriod = obj.Report__r.Reporting_Period__c;
            this.reportValue = obj.Report__r.Value__c;
            this.reportDocument = cReportDocument;
            this.reportCreatedDate = obj.Report__r.CreatedDate;
            this.reportViews = obj.Report__r.Views__c;            
            this.reportIsFavourite = cIsFavourite; 
            this.reportIsStatic = cIsStatic; 
            this.reportContentVersions = cContentVersions;          
        }

        public ReportWrapper(String cReportId, String cReportTitle){
            this.reportId = cReportId;
            this.reportTitle = cReportTitle;
        }

        public void increaseCommentsCounter(Decimal increaseBy){
            this.reportComments = (this.reportComments == null) ? 0 : this.reportComments;
            this.reportComments = this.reportComments + increaseBy;
        }

        public Integer compareTo(Object compareTo) {
            ReportWrapper compareToEmp = (ReportWrapper)compareTo;
            if (reportCreatedDate == compareToEmp.reportCreatedDate) return 0;
            if (reportCreatedDate > compareToEmp.reportCreatedDate) return 1;
            return -1;       
        }
    }

    public class ReportDocumentWrapper{
        @AuraEnabled
        public Id reportDocumentId;
        @AuraEnabled
        public String reportDocumentTitle;
        @AuraEnabled
        public String reportDocumentFileExtension;
        @AuraEnabled
        public String reportDocumentFileType;
        @AuraEnabled
        public Id reportDocumentContentDocumentId;
        @AuraEnabled
        public String reportDocumentPreviewUrl;
        @AuraEnabled
        public String reportDocumentPreviewLink;
        @AuraEnabled
        public String reportDocumentDownloadLink;
        @AuraEnabled
        public String reportDocumentLastModifiedDate;
        @AuraEnabled
        public Boolean reportDocumentIsPreview;
        @AuraEnabled
        public Id reportShelfTileId;
        @AuraEnabled
        public Id reportId;

        public ReportDocumentWrapper(ContentVersion obj, String deviceType){
            this.reportDocumentId = obj.Id;
            this.reportDocumentTitle = obj.Title;
            this.reportDocumentFileExtension = obj.FileExtension;
            this.reportDocumentFileType = obj.FileType;
            this.reportDocumentContentDocumentId = obj.ContentDocumentId;
            this.reportDocumentLastModifiedDate =  obj.LastModifiedDate.format();
            this.reportDocumentPreviewUrl = OV_ThumbnailPreviewBuilder.prepareURL(deviceType, obj.Id);
            this.reportDocumentPreviewLink = OV_ThumbnailPreviewBuilder.prepareURL(deviceType, obj);
            this.reportDocumentDownloadLink = OV_ThumbnailPreviewBuilder.prepareDownloadURL(obj.Id);
            this.reportDocumentIsPreview = OV_ThumbnailPreviewBuilder.isPreviewAvailable(obj);           
        }

        public ReportDocumentWrapper(String name, String url){        
            this.reportDocumentTitle = name;
            this.reportDocumentPreviewUrl = url;          
        }

        public void setReportShelfTileReportId(Id cShelfTileId, Id cReportId){
            this.reportShelfTileId = cShelfTileId;
            this.reportDocumentPreviewLink = this.reportDocumentPreviewLink + '&shelfTileId=' + cShelfTileId + '&reportId='+cReportId;
        }
    }

    public class ShelfWrapper implements Comparable {
        @AuraEnabled
        public Id shelfId;
        @AuraEnabled
        public String shelfTitle;
        @AuraEnabled
        public String shelfColour;
        @AuraEnabled
        public Datetime shelfCreatedDate;
        @AuraEnabled
        public List<ShelfTileWrapper> shelfTiles;
        public Map<Id, ShelfTileWrapper> shelfTilesMap;

        public ShelfWrapper(String cShelfId, String cShelfTitle, String cShelfColour, Datetime cShelfCreatedDate){
            this.shelfId = cShelfId;
            this.shelfTitle = cShelfTitle;
            this.shelfColour = cShelfColour;
            this.shelfCreatedDate = cShelfCreatedDate;
            this.shelfTiles = new List<ShelfTileWrapper>();
            this.shelfTilesMap = new Map<Id, ShelfTileWrapper>();
        }

        public ShelfWrapper(OV_Shelf__c obj){
            this.shelfId = obj.Id;
            this.shelfTitle = obj.Name;
            this.shelfColour = obj.Colour__c;
            this.shelfTiles = new List<ShelfTileWrapper>();
            this.shelfTilesMap = new Map<Id, ShelfTileWrapper>();
        }

        public void addTiles(List<OV_Wrapper.ShelfTileWrapper> cShelfTiles){
            this.shelfTiles = cShelfTiles;
        }

        public void addTile(OV_Wrapper.ShelfTileWrapper cShelfTile){
            this.shelfTiles.add(cShelfTile);
            //this.shelfTiles.sort();
            this.shelfTilesMap.put(cShelfTile.shelfTileId, cShelfTile);
        }

        public List<OV_Wrapper.ShelfTileWrapper> getTiles(){
            return this.shelfTiles;
        }

        public Integer compareTo(Object compareTo) {
            ShelfWrapper compareToEmp = (ShelfWrapper)compareTo;
            if (shelfCreatedDate == compareToEmp.shelfCreatedDate) return 0;
            if (shelfCreatedDate > compareToEmp.shelfCreatedDate) return 1;
            return -1;       
        }
    }
    
    public class ShelfTileWrapper implements Comparable {
        @AuraEnabled
        public Id shelfTileId;
        @AuraEnabled
        public String shelfTileTitle;
        @AuraEnabled
        public String shelfTileColour;
        @AuraEnabled
        public String shelfTileIcon;
        @AuraEnabled
        public String shelfTileIconName;
        @AuraEnabled
        public String shelfTileShelfId;
        @AuraEnabled
        public Datetime shelfTileCreatedDate;
        @AuraEnabled
        public List<OV_Wrapper.ReportWrapper> shelfTileReports;

        public ShelfTileWrapper(String cShelfTileId, String cShelfTileTitle, String cShelfTileColor, String cShelfTileIcon, String cShelfTileIconName, String cShelfTileShelfId, Datetime cShelfTileCreatedDate){
            this.shelfTileId = cShelfTileId;
            this.shelfTileTitle = cShelfTileTitle;
            this.shelfTileColour = cShelfTileColor;
            this.shelfTileIcon = cShelfTileIcon;
            this.shelfTileIconName = cShelfTileIconName;
            this.shelfTileShelfId = cShelfTileShelfId;
            this.shelfTileCreatedDate = cShelfTileCreatedDate;
            this.shelfTileReports = new List<OV_Wrapper.ReportWrapper>();
        }

        public ShelfTileWrapper(OV_Shelf_Tile__c obj){
            this.shelfTileId = obj.Id;
            this.shelfTileTitle = obj.Name;
            this.shelfTileColour = obj.Colour__c;
            this.shelfTileIcon = obj.Tile_ICON__c;
            this.shelfTileIconName = obj.ICON_Label__c;
            this.shelfTileShelfId = obj.Shelf__c;
            this.shelfTileReports = new List<OV_Wrapper.ReportWrapper>();
        }

        public void setReports(List<OV_Wrapper.ReportWrapper> cShelfTileReports){
            this.shelfTileReports = cShelfTileReports;
        }

        public void addReport(OV_Wrapper.ReportWrapper cShelfTileReport){
            this.shelfTileReports.add(cShelfTileReport);
        }

        public List<OV_Wrapper.ReportWrapper> getReports(){
            return this.shelfTileReports;
        }

        public Integer compareTo(Object compareTo) {
            ShelfTileWrapper compareToEmp = (ShelfTileWrapper)compareTo;
            if (shelfTileCreatedDate == compareToEmp.shelfTileCreatedDate) return 0;
            if (shelfTileCreatedDate > compareToEmp.shelfTileCreatedDate) return 1;
            return -1;       
        }
    }

    public class KPINameWrapper{
        @AuraEnabled
        public Id kpiNameId;
        @AuraEnabled
        public String kpiNameName;
        @AuraEnabled
        public ReportWrapper kpiReport;

        public KPINameWrapper(String cKpiNameId, String cKpiNameName){
            this.kpiNameId = cKpiNameId;
            this.kpiNameName = cKpiNameName;
        }
    }

    /*
    Sonar report: Too Many Fields issue. ReportWrapper used for transporting data between frontend and backend through remote actions. Refactoring is not required.
    */
    public class KPIElementWrapper{
        @AuraEnabled
        public Id kpiElementId;
        @AuraEnabled
        public String kpiElementName;
        @AuraEnabled
        public Id kpiElementBrandId;
        @AuraEnabled
        public String kpiElementBrandName;
        @AuraEnabled
        public Id kpiElementBrandComparatorId;
        @AuraEnabled
        public String kpiElementBrandComparatorName;
        @AuraEnabled
        public Id kpiElementCategoryId;
        @AuraEnabled
        public String kpiElementCategoryName;
        @AuraEnabled
        public Id kpiElementFunctionId;
        @AuraEnabled
        public String kpiElementFunctionName;
        @AuraEnabled
        public Id kpiElementGeographyId;
        @AuraEnabled
        public String kpiElementGeographyName;
        @AuraEnabled
        public String kpiElementReportId;
        @AuraEnabled
        public String kpiElementReportName;
        @AuraEnabled
        public Id kpiElementKpiNameId;
        @AuraEnabled
        public String kpiElementKpiNameName;
        @AuraEnabled
        public String kpiElementChannel;
        @AuraEnabled
        public String kpiElementDirection;
        @AuraEnabled
        public Decimal kpiElementRoundedValue;
        @AuraEnabled
        public Decimal kpiElementTarget;
        @AuraEnabled
        public String kpiElementTimeSpan;
        @AuraEnabled
        public Id kpiElementCustomer;
        @AuraEnabled
        public String kpiElementCustomerName;

        public KPIElementWrapper(String cKpiElementName, String cKpiElementId, String cKpiElementFunctionId, String cKpiElementCategoryId, String cKpiElementGeographyId, String cKpiElementBrandId, String cKpiElementBrandComparatorId, String cKpiElementReportId, String cKpiElementKpiNameId, String cKpiElementChannel, String cKpiElementTimeSpan, String cKpiElementCustomer){
            this.kpiElementId = cKpiElementId;
            this.kpiElementName = cKpiElementName;
            this.kpiElementFunctionId = cKpiElementFunctionId;
            this.kpiElementCategoryId = cKpiElementCategoryId;
            this.kpiElementGeographyId = cKpiElementGeographyId;
            this.kpiElementBrandId = cKpiElementBrandId;
            this.kpiElementBrandComparatorId = cKpiElementBrandComparatorId;
            this.kpiElementReportId = cKpiElementReportId;     
            this.kpiElementKpiNameId = cKpiElementKpiNameId;   
            this.kpiElementChannel = cKpiElementChannel;   
            this.kpiElementTimeSpan = cKpiElementTimeSpan;
            this.kpiElementCustomer = cKpiElementCustomer;
        }

        /*
        Sonar Note: Excessive Parameter List issue. Needs refactoring however leaving for now because it's too complicated and time consuming
        */
        public KPIElementWrapper(String cKpiElementName, String cKpiElementId, String cKpiElementBrandId, String cKpiElementBrandName, String cKpiElementBrandComparatorId, String cKpiElementBrandComparatorName, String cKpiElementCategoryId, String cKpiElementCategoryName, String cKpiElementFunctionId, String cKpiElementFunctionName, String cKpiElementGeographyId, String cKpiElementGeographyName, String cKpiElementReportId, String cKpiElementReportName, String cKpiElementKpiNameId, String cKpiElementKpiNameName, String cKpiElementChannel, String cKpiElementDirection, Decimal cKpiElementRoundedValue, Decimal cKpiElementTarget, String cKpiElementTimeSpan, String cKpiElementCustomerId, String cKpiElementCustomerName){
            this.kpiElementId = cKpiElementId;
            this.kpiElementName = cKpiElementName;
            this.kpiElementBrandId = cKpiElementBrandId;
            this.kpiElementBrandName = cKpiElementBrandName;
            this.kpiElementBrandComparatorId = cKpiElementBrandComparatorId;
            this.kpiElementBrandComparatorName = cKpiElementBrandComparatorName;
            this.kpiElementCategoryId = cKpiElementCategoryId;
            this.kpiElementCategoryName = cKpiElementCategoryName;
            this.kpiElementFunctionId = cKpiElementFunctionId;
            this.kpiElementFunctionName = cKpiElementFunctionName;
            this.kpiElementGeographyId = cKpiElementGeographyId;
            this.kpiElementGeographyName = cKpiElementGeographyName;
            this.kpiElementReportId = cKpiElementReportId; 
            this.kpiElementReportName = cKpiElementReportName; 
            this.kpiElementKpiNameId = cKpiElementKpiNameId;
            this.kpiElementKpiNameName = cKpiElementKpiNameName;
            this.kpiElementChannel = cKpiElementChannel;
            this.kpiElementDirection = cKpiElementDirection;
            this.kpiElementRoundedValue = cKpiElementRoundedValue;
            this.kpiElementTarget = cKpiElementTarget;
            this.kpiElementTimeSpan = cKpiElementTimeSpan;
            this.kpiElementCustomer = cKpiElementCustomerId;
            this.kpiElementCustomerName = cKpiElementCustomerName;
        }
    }

    public class FunctionWrapper{
        @AuraEnabled
        public Id functionId;
        @AuraEnabled
        public String functionName;
        @AuraEnabled
        public List<OV_Wrapper.FunctionWrapper> functionChilds;

        public FunctionWrapper(String cFunctionId, String cFunctionName){
            this.functionId = cFunctionId;
            this.functionName = cFunctionName;
            this.functionChilds = new List<OV_Wrapper.FunctionWrapper>();
        }

        public void addChild(OV_Wrapper.FunctionWrapper cFunction){
            this.functionChilds.add(cFunction);
        }
    }

    public class CustomerWrapper{
        @AuraEnabled
        public Id customerId;
        @AuraEnabled
        public String customerName;
        @AuraEnabled
        public List<OV_Wrapper.CustomerWrapper> customerChilds;

        public CustomerWrapper(String cCustomerId, String cCustomerName){
            this.customerId = cCustomerId;
            this.customerName = cCustomerName;
            this.customerChilds = new List<OV_Wrapper.CustomerWrapper>();
        }

        public void addChild(OV_Wrapper.CustomerWrapper cCustomer){
            this.customerChilds.add(cCustomer);
        }
    }

    public class TimespanWrapper{
        @AuraEnabled
        public String timespanName;
        
        public TimespanWrapper(String cTimespanName){
            this.timespanName = cTimespanName;
        }
    }

    public class ChannelWrapper{
        @AuraEnabled
        public String channelName;
        
        public ChannelWrapper(String cChannelName){
            this.channelName = cChannelName;
        }
    }

    public class HeadingWrapper{
        @AuraEnabled
        public String headingName;
        
        public HeadingWrapper(String cHeadingName){
            this.headingName = cHeadingName;
        }
    }

    public class GeographyWrapper{
        @AuraEnabled
        public Id geographyId;
        @AuraEnabled
        public String geographyName;
        @AuraEnabled
        public List<OV_Wrapper.GeographyWrapper> geographyChilds;

        public GeographyWrapper(String cGeographyId, String cGeographyName){
            this.geographyId = cGeographyId;
            this.geographyName = cGeographyName;
            this.geographyChilds = new List<OV_Wrapper.GeographyWrapper>();
        }

        public void addChild(OV_Wrapper.GeographyWrapper cGeography){
            this.geographyChilds.add(cGeography);
        }
    }

    public class CategoryWrapper{
        @AuraEnabled
        public Id categoryId;
        @AuraEnabled
        public String categoryName;
        @AuraEnabled
        public List<OV_Wrapper.CategoryWrapper> categoryChilds;

        public CategoryWrapper(String cCategoryId, String cCategoryName){
            this.categoryId = cCategoryId;
            this.categoryName = cCategoryName;
            this.categoryChilds = new List<OV_Wrapper.CategoryWrapper>();
        }

        public void addChild(OV_Wrapper.CategoryWrapper cCategory){
            this.categoryChilds.add(cCategory);
        }
    }

    public class BrandWrapper{
        @AuraEnabled
        public Id brandId;
        @AuraEnabled
        public String brandName;

        public BrandWrapper(String cBrandId, String cBrandName){
            this.brandId = cBrandId;
            this.brandName = cBrandName;
        }
    }

    public class ComparatorWrapper{
        @AuraEnabled
        public Id comparatorId;
        @AuraEnabled
        public String comparatorName;

        public ComparatorWrapper(String cComparatorId, String cComparatorName){
            this.comparatorId = cComparatorId;
            this.comparatorName = cComparatorName;
        }
    }

    public class FolderLevelWrapper{
        @AuraEnabled
        public List<Object> folderLevelMembers;
        public Map<String, Object> folderLevelMembersMap;

        public FolderLevelWrapper(){
            this.folderLevelMembers = new List<Object>();
            this.folderLevelMembersMap = new Map<String, Object>();
        }

        public void addMember(Object cMember, Boolean isFolder){
            this.folderLevelMembers.add(cMember);    
            if(isFolder){
                OV_Wrapper.FolderWrapper f = (OV_Wrapper.FolderWrapper) cMember;
                this.folderLevelMembersMap.put( f.folderName, f);  
            }    
        }
    }

    public class FolderWrapper{
        @AuraEnabled
        public String folderName;
        @AuraEnabled
        public List<Object> folderMembers;
        public Map<Id, Object> folderMembersMap;

        public FolderWrapper(String cFolderName){
            this.folderName = cFolderName;
            this.folderMembers = new List<OV_Wrapper.ReportWrapper>();
            this.folderMembersMap = new Map<Id, OV_Wrapper.ReportWrapper>();
        }

        public void addMember(OV_Wrapper.ReportWrapper cMember){
            this.folderMembers.add(cMember);           
            this.folderMembersMap.put(cMember.reportId, cMember);
        }
    }

    public class KpiFavouriteTransactionWrapper{
        @AuraEnabled
        public Id kpiTransactionId;
        @AuraEnabled
        public Boolean shouldBeNotified;
        @AuraEnabled
        public Id reportId;

        public KpiFavouriteTransactionWrapper(Id kpiTransactionId, Boolean shouldBeNotified, Id reportId){
            this.kpiTransactionId = kpiTransactionId;
            this.shouldBeNotified = shouldBeNotified;
            this.reportId = reportId;
        }

        public KpiFavouriteTransactionWrapper(OV_KPI_Transaction_Favorite__c obj){
            this.kpiTransactionId = obj.KPI_Transaction__c;
            this.shouldBeNotified = obj.Wants_Notifications__c;
            this.reportId = obj.Report__c;
        }
    }
}