/**********************************************************************

 Name:  OV_ContentProxyHandler()

 Copyright © 2015  Salesforce

 ======================================================

======================================================

Purpose:    Test class for OV_ContentProxyHandler                                                          

-------                                                            

======================================================

======================================================

History                                                            

-------                                                            

VERSION  AUTHOR            DATE              DETAIL            Description

1.0   Pawel Niedziela    25/09/2015      INITIAL DEVELOPMENT   Test class for OV_ContentProxyHandler 

***********************************************************************/
@isTest
private class OV_ContentProxyHandler_Test {
    static final String reportLabel = 'Report 1';
    static final String titleLabel = 'some sample title';

    public static final String DESKTOP_LABEL    = 'Desktop';
    
    @isTest
    static void contentProxyHandler_Test() {
        
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentProxy__c = true;
        insert triggerSwitchCustomSetting;
        
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion1.Id, 'www.google.com', true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReport(reportLabel, category1, function1, geography1, DESKTOP_LABEL, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = titleLabel;
        contentVersion.PathOnClient = '/some sample title.txt';
        contentVersion.versionData = Blob.valueOf(titleLabel);
        contentVersion.ContentDocumentId  = document1.Id;
        contentVersion.ReasonForChange = 'test purposese';
        insert contentVersion;

        proxy.Title__c = 'proxy test title the second';
        proxy.LatestContentVersionId__c = contentVersion.Id;
        update proxy;

        system.assertEquals(contentVersion.Id, [SELECT LatestContentVersionId__c FROM OV_ContentProxy__c where Id = :proxy.Id].LatestContentVersionId__c);
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
    }
    
    @isTest
    static void contentProxyHandlerAfterUpdate_Test(){        
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentProxy__c = true;
        insert triggerSwitchCustomSetting;
        
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion1.Id, 'www.google.com', true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);
        

        OV_Report__c report1 = OV_TestingHelper.initReport(reportLabel, category1, function1, geography1, DESKTOP_LABEL, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;
        
        OV_Report__c report2 = OV_TestingHelper.initReport(reportLabel, category1, function1, geography1, DESKTOP_LABEL, false);
        report2.Mobile_Content_Proxy__c = proxy.Id;
        insert report2;
        
        OV_Report__c report3 = OV_TestingHelper.initReport(reportLabel, category1, function1, geography1, DESKTOP_LABEL, false);
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
        
        EntitySubscription entitySubscription1 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report1.Id, true);
        EntitySubscription entitySubscription2 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report2.Id, true);
        EntitySubscription entitySubscription3 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report3.Id, true);
        EntitySubscription entitySubscription4 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), favouriteReport.Id, true);

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = titleLabel;
        contentVersion.PathOnClient = '/some sample title.txt';
        contentVersion.versionData = Blob.valueOf(titleLabel);
        contentVersion.ContentDocumentId  = document1.Id;
        contentVersion.ReasonForChange = 'test purposese';
        insert contentVersion;

        proxy.Title__c = 'proxy test title the second';
        proxy.LatestContentVersionId__c = contentVersion.Id;
        update proxy;

        system.assertEquals(contentVersion.Id, [SELECT LatestContentVersionId__c FROM OV_ContentProxy__c where Id = :proxy.Id].LatestContentVersionId__c);
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
    }
}