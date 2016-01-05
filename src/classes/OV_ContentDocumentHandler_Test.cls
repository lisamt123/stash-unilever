/**********************************************************************

 Name:  OV_ContentDocumentHandler_Test()

 Copyright © 2015  Salesforce

 ======================================================

======================================================

Purpose:    Test class for OV_ContentDocumentHandler                                                          

-------                                                            

======================================================

======================================================

History                                                            

-------                                                            

VERSION  AUTHOR            DATE              DETAIL            Description

1.0   Pawel Niedziela    25/09/2015      INITIAL DEVELOPMENT   Test class for OV_ContentDocumentHandler 

***********************************************************************/
@isTest
private class OV_ContentDocumentHandler_Test {
    static final String category1Label = 'Category 1';
    static final String function1Label = 'Function 1';
    static final String geography1Label = 'Geography 1';
    static final String test1Label = 'Test 1';
    static final String titleLabel = 'proxy test title';
    static final String report1Label = 'Report 1';

    public static final String SAMPLE_URL = 'www.salesforce.com';
    public static final String DEVICE_DESKTOP = 'Desktop';
    public static final String DEVICE_TABLET = 'Tablet';
    public static final String DEVICE_MOBILE = 'Mobile';
    
    @isTest
    static void handleDocumentContentDeleteTest() {
        
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = true;
        insert triggerSwitchCustomSetting;

        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(report1Label, category1, function1, geography1, DEVICE_DESKTOP, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        delete document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(0, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }

    @isTest
    static void handleDocumentConenteUndeleteTest() {
        
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = true;
        insert triggerSwitchCustomSetting;
        
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);

        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(report1Label, category1, function1, geography1, DEVICE_DESKTOP, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        delete document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(0, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());

        undelete document1;
        //verify undelete
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }
    
    @isTest
    static void handleDocumentContentDeleteWithEntitiesTest() {
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = true;
        insert triggerSwitchCustomSetting;
        
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        
        
        OV_Report__c report1 = OV_TestingHelper.initReport(report1Label, category1, function1, geography1, DEVICE_DESKTOP, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;
        
        OV_Report__c report2 = OV_TestingHelper.initReport(report1Label, category1, function1, geography1, DEVICE_MOBILE, false);
        report2.Mobile_Content_Proxy__c = proxy.Id;
        insert report2;
        
        OV_Report__c report3 = OV_TestingHelper.initReport(report1Label, category1, function1, geography1, DEVICE_TABLET, false);
        report3.Tablet_Content_Proxy__c = proxy.Id;
        insert report3;
        
        OV_Shelf__c shelf = new OV_Shelf__c(Sort_Order__c = 1);
        insert shelf;

        OV_Shelf_Tile__c shelfTile = new OV_Shelf_Tile__c(Shelf__c = shelf.Id, Sort_Order__c = 2);
        insert shelfTile;

        OV_Profile__c profile = new OV_Profile__c(User__c = UserInfo.getUserId());
        insert profile;

        OV_Report_Favourite__c favouriteReport = new OV_Report_Favourite__c(Report__c = report1.Id, Favourite_From_Shelf_Tile__c = shelfTile.Id, User__c = profile.id, Colour__c = 'color');
        insert favouriteReport;

        EntitySubscription entitySubscription = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report1.Id, true);
        EntitySubscription entitySubscription1 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report2.Id, true);
        EntitySubscription entitySubscription2 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report3.Id, true);
        EntitySubscription entitySubscription3 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), favouriteReport.Id, true);
        
        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        delete document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(0, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }
    
    @isTest
    static void handleDocumentContentDeleteTriggerDisabledTest() {
        
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = false;
        insert triggerSwitchCustomSetting;
        
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(report1Label, category1, function1, geography1, DEVICE_DESKTOP, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        delete document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }

    /*@isTest
    static void handleDocumentContentUpdateTriggerTest() {
        
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = true;
        insert triggerSwitchCustomSetting;
        
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(report1Label, category1, function1, geography1, DEVICE_DESKTOP, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        
        ContentVersion newVersion = new ContentVersion(ContentDocumentId = document1.id, ContentUrl = SAMPLE_URL);
        insert newVersion;
        
        update document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }*/
  
}