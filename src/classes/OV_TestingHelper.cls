/**********************************************************************
Name: OV_TestingHelper
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test helper with common methods
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             25/05/2015      INITIAL DEVELOPMENT
**********************************************************************/

@isTest
global with sharing class OV_TestingHelper {
    //admin and standard user profiles
    public static Profile AdminProfile;
    public static Profile UserProfile;

    /**
     * Creates user
     * @param  {Profile} uProfile      Profile object
     * @param  {String}  uAlias        alias
     * @param  {String}  uEmail        email 
     * @param  {String}  uLastName     lastname
     * @return {User}
     */

    public static User createUser(Profile uProfile, String uAlias, String uEmail, String uLastName) {
        User u = new User(
            alias = uAlias,  
            email = uEmail, 
            lastname = uLastName,
            profileId = uProfile.Id,
            username = uEmail + '.sfdcbetUT',
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US', 
            localesidkey = 'en_US',
            timezonesidkey='America/Los_Angeles'
        );

        //TODO dh: update the username to be .sfdcovUT or similar (didn't change incase break UT)

        insert u;

        u = [SELECT Id, Name, alias, email, firstname, lastname, profileId, username, emailencodingkey, languagelocalekey, localesidkey, timezonesidkey
                FROM User WHERE Id =: u.Id LIMIT 1];

        return u;
    }

    /**
     * Returns system administrator Profile
     * @return {Profile} 
     */
    public static Profile getAdminProfile() {
        if (AdminProfile == null) {
            AdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        }
        return AdminProfile;
    }

    /**
     * Returns marketing user Profile
     * @return {Profile} 
     */
    public static Profile getUserProfile() {
        if (UserProfile == null) {
            UserProfile = [SELECT Id FROM Profile WHERE Name='Unilever - Force MultiApp Marketing' LIMIT 1]; 
        }
        return UserProfile;
    }



    /**
     * Creates administrator user
     * @param  {String} uAlias        alias
     * @param  {String} uEmail        email
     * @param  {String} uLastName     lastname
     * @return {User}
     */
    public static user createAdminUser(String uAlias, String uEmail, String uLastName) {
        return createUser(getAdminProfile(), uAlias, uEmail, uLastName);
    }



    /**
     * Creates category object
     * @param  {String}  categoryName  category name
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @return {OV_Category__c}
     */
    public static OV_Category__c initCategory(String categoryName, Boolean insertFlag) {
        return initCategory(categoryName, null, insertFlag);
    }

    /**
     * Creates category object
     * @param  {String}             categoryName    category name
     * @param  {OV_Category__c}    parentCategory  parent category
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Category__c}
     */
    public static OV_Category__c initCategory(String categoryName, OV_Category__c parentCategory, Boolean insertFlag) {
        OV_Category__c category = new OV_Category__c();
        category.Name = categoryName;
        if (parentCategory != null) {
            category.Parent_Category__c = parentCategory.Id;
        }

        if (insertFlag) {
            insert category;
            // requery to pick up anything that was added by triggers
            category = [SELECT Id, Name, Parent_Category__c FROM OV_Category__c WHERE Id =: category.Id];
        }       
        
        return category;
    }

    /**
     * Creates customer
     * @param  {String}  customer Name  customer name
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @return {OV_Customer__c}
     */
    public static OV_Customer__c initCustomer(String customerName, Boolean insertFlag) {
        return initCustomer(customerName, null, insertFlag);
    }

    /**
     * Creates geography object
     * @param  {String}             geography    geography name
     * @param  {OV_Geography__c}    parentCategory  parent geography
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Geography__c}
     */
    public static OV_Customer__c initCustomer(String customerName, OV_Customer__c parentCustomer, Boolean insertFlag) {
        OV_Customer__c customer = new OV_Customer__c();
        customer.Name = customerName;
        if (parentCustomer != null) {
            customer.Parent_Customer__c = parentCustomer.Id;
        }

        if (insertFlag) {
            insert customer;
            // requery to pick up anything that was added by triggers
            customer = [SELECT Id, Name, Parent_Customer__c FROM OV_Customer__c WHERE Id =: customer.Id];
        }       
        
        return customer;
    }


    /**
     * Creates geography
     * @param  {String}  geography Name  category name
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @return {OV_Geography__c}
     */
    public static OV_Geography__c initGeography(String geographyName, Boolean insertFlag) {
        return initGeography(geographyName, null, insertFlag);
    }

    /**
     * Creates geography object
     * @param  {String}             geography    geography name
     * @param  {OV_Geography__c}    parentCategory  parent geography
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Geography__c}
     */
    public static OV_Geography__c initGeography(String geographyName, OV_Geography__c parentGeography, Boolean insertFlag) {
        OV_Geography__c geography = new OV_Geography__c();
        geography.Name = geographyName;
        if (parentGeography != null) {
            geography.Parent_Geography__c = parentGeography.Id;
        }

        if (insertFlag) {
            insert geography;
            // requery to pick up anything that was added by triggers
            geography = [SELECT Id, Name, Parent_Geography__c FROM OV_Geography__c WHERE Id =: geography.Id];
        }       
        
        return geography;
    }

    /**
     * Creates function
     * @param  {String}  function Name  function name
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @return {OV_Function__c}
     */
    public static OV_Function__c initFunction(String functionName, Boolean insertFlag) {
        return initFunction(functionName, null, insertFlag);
    }

    /**
     * Creates function object
     * @param  {String}             function    function name
     * @param  {OV_Function__c}    parentFunction  parent function
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Function__c}
     */
    public static OV_Function__c initFunction(String functionName, OV_Function__c parentFunction, Boolean insertFlag) {
        OV_Function__c ovFunction = new OV_Function__c();
        ovFunction.Name = functionName;
        if (parentFunction != null) {
            ovFunction.Parent_Function__c = parentFunction.Id;
        }

        if (insertFlag) {
            insert ovFunction;
            // requery to pick up anything that was added by triggers
            ovFunction = [SELECT Id, Name, Parent_Function__c FROM OV_Function__c WHERE Id =: ovFunction.Id];
        }       
        
        return ovFunction;
    }

    /**
     * Creates shelfs object
     * @param  {String} shelfName shelf name
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Shelf__c}
     */
    public static OV_Shelf__c initShelf(String shelfName, String recordTypeName, Boolean insertFlag) {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.OV_Shelf__c; 
        Map<String,Schema.RecordTypeInfo> shelfRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();

        Id shelfRecordTypeId = shelfRecordTypeInfo.get(recordTypeName).getRecordTypeId();

        OV_Shelf__c shelf = new OV_Shelf__c();
        shelf.Name = shelfName;
        shelf.RecordTypeId = shelfRecordTypeId; 
        shelf.Sort_Order__c = 1;      

        if (insertFlag) {
            insert shelf;
            // requery to pick up anything that was added by triggers
            shelf = [SELECT Id, Name FROM OV_Shelf__c WHERE Id =: shelf.Id];
        }       
        
        return shelf;
    }
    
    /**
     * Creates shelfs object
     * @param  {String} shelfName shelf name
     * @param  {String} colour shelf colour
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Shelf__c}
     */
    public static OV_Shelf__c initShelfWithColour(String shelfName, String colour, String recordTypeName, Boolean insertFlag) {
        OV_Shelf__c shelf = OV_TestingHelper.initShelf(shelfName, recordTypeName, false);
        shelf.Colour__c = colour;
        
        if (insertFlag) {
            insert shelf;
            // requery to pick up anything that was added by triggers
            shelf = [SELECT Id, Name, Colour__c FROM OV_Shelf__c WHERE Id =: shelf.Id];
        }       
        
        return shelf;
    }

    /**
     * Creates shelf tile object
     * @param  {String} shelfTileName    shelf Tile Name name
     * @param  {String} shelfTileColour    shelf Tile color
     * @param  {String} shelfTileBackground    shelf Tile background
     * @param  {OV_Shelf__c} parentShelf
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Shelf_Tile__c}
     */
    public static OV_Shelf_Tile__c initShelfTile(String shelfTileName, String shelfTileColour, String shelfTileIcon, OV_Shelf__c parentShelf, Boolean insertFlag) {
        OV_Shelf_Tile__c shelfTile = new OV_Shelf_Tile__c();
        shelfTile.Name = shelfTileName;
        shelfTile.Colour__c = shelfTileColour;
        shelfTile.Tile_ICON__c = shelfTileIcon;   
        shelfTile.Sort_Order__c = 1;  

        if (parentShelf != null) {
            shelfTile.Shelf__c = parentShelf.Id;
        }

        if (insertFlag) {
            insert shelfTile;
            // requery to pick up anything that was added by triggers
            shelfTile = [SELECT Id, Name, Colour__c, ICON_Label__c, Shelf__c, Tile_ICON__c FROM OV_Shelf_Tile__c WHERE Id =: shelfTile.Id];
        }       
        
        return shelfTile;
    }


    public static OV_Unit__C initUnit(String unitName, Boolean insertFlag) {
        OV_Unit__C unit = new OV_Unit__C();
        unit.Name = unitName;
      
        if (insertFlag) {
            insert unit;
            // requery to pick up anything that was added by triggers
            unit = [SELECT Id, Name FROM OV_Unit__C WHERE Id =: unit.Id];
        }       
        
        return unit;
    }
    
    public static OV_Unit__C initUnitWithType(String unitName, String unitType, Boolean insertFlag) {
        OV_Unit__C unit = OV_TestingHelper.initUnit(unitName, false);
        unit.Type__c = unitType;
      
        if (insertFlag) {
            insert unit;
            // requery to pick up anything that was added by triggers
            unit = [SELECT Id, Name, Type__c FROM OV_Unit__C WHERE Id =: unit.Id];
        }       
        
        return unit;
    }

    /**
     * Creates report object
     * @param  {String} reportName    shelf Tile Name name
     * @param  {OV_Category__c}    parentFunction  parent function
     * @param  {OV_Function__c}    parentFunction  parent function
     * @param  {OV_Geography__c}    parentFunction  parent function
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_Report__c}
     */
    public static OV_Report__c initReport(String reportName, OV_Category__c reportCategory, OV_Function__c reportFunction, OV_Geography__c reportGeography, String deviceType, Boolean insertFlag) {
        OV_Unit__C unit = initUnit('test', true);
        OV_Report__c report = new OV_Report__c();
        report.Name = reportName;
        report.Category__c = reportCategory.Id;
        report.Function__c = reportFunction.Id;
        report.Geography__c = reportGeography.Id;
        report.Show_on_Devices__c = deviceType;
        report.Url__c = 'http://test.com';
        report.Unit__c = unit.Id;
        
        if (insertFlag) {
            insert report;
            // requery to pick up anything that was added by triggers
            report = [SELECT Id, Name, Category__c, Function__c, Geography__c, Url__c FROM OV_Report__c WHERE Id =: report.Id];
        }       
        
        return report;
    }

    /*
    Sonar Note: Excessive Parameter List issue. Method used only in test classes. Easy to use. Refactoring is no needed.
    */
    public static OV_Report__c initReportWithProxyHeaderFolder(String reportName, OV_Category__c reportCategory, OV_Function__c reportFunction, OV_Geography__c reportGeography, String deviceType, Id proxyId, String header, String folder, Boolean insertFlag) {
        OV_Report__c report = initReportWithProxy(reportName, reportCategory, reportFunction, reportGeography, deviceType, proxyId, false);

        report.Report_Heading__c = header;
        report.Report_Folder__c = folder;
                
        if (insertFlag) {
            insert report;
            // requery to pick up anything that was added by triggers
            report = [SELECT Id, Name, Category__c, Desktop_Content_Proxy__c, Desktop_Content_Proxy__r.Url__c, Mobile_Content_Proxy__c, Mobile_Content_Proxy__r.Url__c, Tablet_Content_Proxy__c, Tablet_Content_Proxy__r.Url__c, Function__c, Geography__c, Report_Heading__c, Report_Folder__c FROM OV_Report__c WHERE Id =: report.Id];
        }       
        
        return report;
    }

    public static OV_Report__c initReportWithProxy(String reportName, OV_Category__c reportCategory, OV_Function__c reportFunction, OV_Geography__c reportGeography, String deviceType, Id proxyId, Boolean insertFlag) {
        OV_Unit__C unit = initUnit('test', true);
        OV_Report__c report = new OV_Report__c();
        report.Name = reportName;
        report.Category__c = reportCategory.Id;
        report.Function__c = reportFunction.Id;
        report.Geography__c = reportGeography.Id;
        report.Show_on_Devices__c = deviceType;
        report.Desktop_Content_Proxy__c = proxyId;
        report.Mobile_Content_Proxy__c = proxyId;
        report.Tablet_Content_Proxy__c = proxyId;
        report.Unit__c = unit.Id;

        if (insertFlag) {
            insert report;
            // requery to pick up anything that was added by triggers
            report = [SELECT Id, Name, Category__c, Desktop_Content_Proxy__c, Desktop_Content_Proxy__r.Url__c, Mobile_Content_Proxy__c, Mobile_Content_Proxy__r.Url__c, Tablet_Content_Proxy__c, Tablet_Content_Proxy__r.Url__c, Function__c, Geography__c FROM OV_Report__c WHERE Id =: report.Id];
        }       
        
        return report;
    }
    
    public static OV_Report__c initReportWithProxyAndUnit(String reportName, OV_Category__c reportCategory, OV_Function__c reportFunction, OV_Geography__c reportGeography, String deviceType, Id proxyId, Id unitId, String frequency, String icon, String reportHeading, Integer views, String reportFolder, Boolean insertFlag) {
        OV_Report__c report = initReportWithProxy( reportName, reportCategory, reportFunction, reportGeography, deviceType, proxyId, false);
        report.Unit__c = unitId;
        report.Frequency__c = frequency;
        report.Icon__c = icon;
        report.Report_Heading__c = reportHeading;
        report.Views__c = views;
        report.Report_Folder__c = reportFolder;
        report.Value__c = 10;
        
        if (insertFlag) {
            insert report;
            // requery to pick up anything that was added by triggers
            report = [SELECT Id, Name, Category__c, Unit__c, Frequency__c, Icon__c, Report_Heading__c, Views__c, Report_Folder__c, Desktop_Content_Proxy__c, Desktop_Content_Proxy__r.Url__c, Mobile_Content_Proxy__c, Mobile_Content_Proxy__r.Url__c, Tablet_Content_Proxy__c, Tablet_Content_Proxy__r.Url__c, Function__c, Geography__c FROM OV_Report__c WHERE Id =: report.Id];
        }       
        
        return report;
    }

    public static OV_Report__c initReport(String reportName, OV_Category__c reportCategory, OV_Function__c reportFunction, OV_Geography__c reportGeography, String contentDocumentId, String deviceType, Boolean insertFlag) {
        OV_Unit__C unit = initUnit('test', true);
        OV_Report__c report = new OV_Report__c();
        report.Name = reportName;
        report.Category__c = reportCategory.Id;
        report.Function__c = reportFunction.Id;
        report.Geography__c = reportGeography.Id;
        report.Show_on_Devices__c = deviceType;
        report.Unit__c = unit.Id;

        if (insertFlag) {
            insert report;
            // requery to pick up anything that was added by triggers
            report = [SELECT Id, Name, Category__c, Function__c, Geography__c FROM OV_Report__c WHERE Id =: report.Id];
        }       
        
        return report;
    }

    /**
     * Creates report junction shelftile object
     * @param  {OV_Report__c} report
     * @param  {OV_Shelf_Tile__c}   tile
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_ShelfTileReport__c}
     */
    public static OV_ShelfTileReport__c initReportToShelfTile(OV_Report__c report, OV_Shelf_Tile__c shelfTile, Boolean insertFlag) {
        OV_ShelfTileReport__c reportToTile = new OV_ShelfTileReport__c();
        reportToTile.Report__c = report.Id;
        reportToTile.Shelf_Tile__c = shelfTile.Id;
        reportToTile.Sort_Order__c = 1;  
        
        if (insertFlag) {
            insert reportToTile;
            // requery to pick up anything that was added by triggers
            reportToTile = [SELECT Id, Report__c, Shelf_Tile__c FROM OV_ShelfTileReport__c WHERE Id =: reportToTile.Id];
        }       
        
        return reportToTile;
    }

    /**
     * Creates KPI 
     * @param  {String} name
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_KPI_Name__c}
     */
    public static OV_KPI_Name__c initKPIName(String name, Boolean insertFlag) {
        OV_KPI_Name__c kpiName = new OV_KPI_Name__c();
        kpiName.Name = name;
        
        if (insertFlag) {
            insert kpiName;
            // requery to pick up anything that was added by triggers
            kpiName = [SELECT Id, Name FROM OV_KPI_Name__c WHERE Id =: kpiName.Id];
        }       
        
        return kpiName;
    }

    /**
     * Creates KPI 
     * @param  {String} name
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {OV_KPI_Name__c}
     * Sonar Note: Excessive Parameter List issue. Method used only in test classes. Easy to use. Refactoring is no needed.
     */
    public static OV_KPI_Element__c initKPIElement(String name, OV_Brand__c brand, OV_Comparator__c comparator, OV_Category__c category, String direction, OV_Function__c function, OV_Geography__c geography, OV_KPI_Name__c kpiName, Decimal kpiValue, OV_Report__c report, Decimal target, String timeSpan, Boolean insertFlag) {
        OV_KPI_Element__c kpiElement = new OV_KPI_Element__c();
        kpiElement.Name = name;
        kpiElement.Brand__c = brand.Id;
        kpiElement.Brand_Comparator__c = comparator.Id;
        kpiElement.Category__c = category.Id;
        kpiElement.Direction__c = direction;
        kpiElement.Function__c = function.Id;
        kpiElement.Geography__c = geography.Id;
        kpiElement.KPI__c = kpiName.Id;
        kpiElement.KPI_Value__c = kpiValue;
        kpiElement.Report__c = report.Id;
        kpiElement.Target__c = target;
        kpiElement.TimeSpan__c = timeSpan;
        
        if (insertFlag) {
            insert kpiElement;
            // requery to pick up anything that was added by triggers
            kpiElement = [SELECT Id, Name, Brand__c, Brand_Comparator__c, Category__c, Direction__c, Function__c, Geography__c, KPI__c, KPI_Value__c, Report__c, Target__c, TimeSpan__c FROM OV_KPI_Element__c WHERE Id =: kpiElement.Id];
        }       
        
        return kpiElement;
    }

    /**
     * Creates brand object
     * @param  {String} brandName brand name 
     * @param  {Boolean} insertFlag      if true, insert object into database
     * @return {OV_Brand__c}
     */
    public static OV_Brand__c initBrand(String brandName, Boolean insertFlag) {
        OV_Brand__c brand = new OV_Brand__c();
        brand.Name = brandName;

        if (insertFlag) {
            insert brand;
            // requery to pick up anything that was added by triggers
            brand = [SELECT Id, Name FROM OV_Brand__c WHERE Id =: brand.Id];
        }       
        
        return brand;
    }

    /**
     * Creates brand comparator object
     * @param  {String} comparatorName brand comparator name 
     * @param  {Boolean} insertFlag      if true, insert object into database
     * @return {OV_Comparator__c}
     */
    public static OV_Comparator__c initBrandComparator(String comparatorName, Boolean insertFlag) {
        OV_Comparator__c comparator = new OV_Comparator__c();
        comparator.Name = comparatorName;

        if (insertFlag) {
            insert comparator;
            // requery to pick up anything that was added by triggers
            comparator = [SELECT Id, Name FROM OV_Comparator__c WHERE Id =: comparator.Id];
        }       
        
        return comparator;
    }

    /**
     * Creates profile
     * @param  {String} profileName profile name 
     * @param  {Boolean} insertFlag      if true, insert object into database
     * @return {OV_Profile__c}
     */
    public static OV_Profile__c initProfile(String profileName, User user, Boolean insertFlag) {
        OV_Profile__c profile = new OV_Profile__c();
        profile.Name = profileName;
        profile.User__c = user.Id;

        if (insertFlag) {
            insert profile;
            // requery to pick up anything that was added by triggers
            profile = [SELECT Id, Name FROM OV_Profile__c WHERE Id =: profile.Id];
        }       
        
        return profile;
    }

    /**
     * Creates ContentVersion
     * @param  {String} profileName profile name 
     * @param  (Id) contentDocumentId (optional) - if supplied the ContentVersions will be a new version of the given Content Document
     * @param  {Boolean} insertFlag      if true, insert object into database
     * @return {OV_Profile__c}
     */
     public static ContentVersion initContentVersion(String title, Id contentDocumentId, Boolean insertFlag) {

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = title;
        contentVersion.PathOnClient = '/' + title + '.txt';
        contentVersion.versionData = Blob.valueOf(title);

        if(insertFlag)
        {
            insert contentVersion;
            contentVersion = [SELECT Id, Title, ContentDocumentId, PathOnClient, IsLatest, FileExtension, ContentSize FROM ContentVersion where Id = :contentVersion.Id];
        }
        
        return contentVersion;
    }


        /**
     * Creates ContentVersion
     * @param  {String} profileName profile name 
     * @param  {Boolean} insertFlag      if true, insert object into database
     * @return {OV_Profile__c}
     */
     public static ContentVersion initContentVersion(String title, Boolean insertFlag) {

        return initContentVersion(title, null, insertFlag);
    }


    /**
     * Creates ContentProxy
     * @param  {String} content document Id 
     * @param  {String} Title 
     * @param  {String} last content version of document
     * @param  {String} url
     * @param  {Boolean} should be inserted
     */
     public static OV_ContentProxy__c initContentProxy(String contentDocumentId, String title, String lastContentVerId, String url, Boolean insertFlag) {
        ContentVersion contentVersion;
        if(String.isEmpty(contentDocumentId)) {
            contentVersion = OV_TestingHelper.initContentVersion('sample title for test', true);
        }else{
            contentVersion = null;
        }
        
        OV_ContentProxy__c proxy = new OV_ContentProxy__c();
        proxy.ContentDocumentId__c = String.isEmpty(contentDocumentId) ? contentVersion.ContentDocumentId : contentDocumentId;
        proxy.Title__c = 'sample title test';
        proxy.LatestContentVersionId__c = String.isEmpty(lastContentVerId) ? contentVersion.Id : lastContentVerId;
        if(url != ''){
            proxy.Url__c = url;
        }        

        if(insertFlag) {
            insert proxy;
            proxy = [SELECT Id, ContentDocumentId__c, Title__c, LatestContentVersionId__c, Url__c FROM OV_ContentProxy__c WHERE Id = :proxy.Id];
        }

        return proxy;
     }
     
     /**
     * Creates EntitySubscription
     * @param  userIdOfFollower - user ID
     * @param  sobjectToFollowId - object which will be followed 
     * @param  insertFlag - indicates if record should be inserted
     * @return {EntitySubscription}
     */
     public static EntitySubscription initEntitySubscription(Id userIdOfFollower, Id sobjectToFollowId, Boolean insertFlag){
        
         try {
            EntitySubscription subsciption = new EntitySubscription();
            subsciption.subscriberId = userIdOfFollower;
            subsciption.parentId = sobjectToFollowId;

            if(insertFlag){
                insert subsciption;
                return subsciption;
            }else{
                return subsciption;
            }
            
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, 'follow catch block:' + e);
            return null;
            // TODO - what can we do to handle an @future exception
        }
     }


}