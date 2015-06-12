/**********************************************************************
Name: WINatPOSPurgeStats_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOSPurgeStats
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          26/10/2014      INITIAL DEVELOPMENT
***********************************************************************/
@IsTest(SeeAllData=true)
public class WinAtPOSPrintablePDFViewController_Test {
    /*******************************************************************
    Purpose: Method to test retrive file data for asset
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testRetriveFileDataForAsset(){
        // Create test data           
        Category__c mainCat = new Category__c();
        mainCat.Name = 'Personal Care';
        mainCat.Type__c = 'Category Group';
        insert mainCat;
        
        Category__c cat = new Category__c();
        cat.Name = 'Deodorants';     
        cat.Type__c = 'Category';
        cat.Parent_Category__c = mainCat.Id;
        insert cat;
        
        Asset_Group__c assetGroup=new Asset_Group__c();
        assetGroup.Name='TestAssetGroup';
        assetGroup.Type__c='Masterbrand';
        assetGroup.Category__c=cat.Id;
        insert assetGroup;
        
        Asset__c asset = new Asset__c();
        asset.Name = 'TestAsset';
        asset.Asset_Group__c=assetGroup.id;
        asset.Category__c = cat.Id;
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Status__c = 'ToDelete';
        //asset.Scheduled_Delete_Date__c = System.today();
        insert asset;
        
        File__c file = new File__c();
        file.Name = 'TestFile';
        file.Asset__c = asset.Id;
        file.Type__c = 'Image';
        file.Is_Primary_Image__c=true;
        insert file;
        
        FeedItem feedItem = new FeedItem();
        feedItem.Type = 'ContentPost';
        feedItem.parentId = file.Id;
        feedItem.Title = 'Dove';
        feedItem.ContentFileName = 'Dove.jpeg';
        feedItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem.Body = 'Promo is the UK';
        insert feedItem;
        
        system.debug('File befor update:'+ file.Feed_ID__c);
        file.Feed_ID__c = feedItem.Id;
        update file;
        system.debug('file feed id after update: '+ file.Feed_ID__c);
        
        Test.startTest();
        PageReference winAtPosPDF=Page.WinAtPOSPrintablePDFView;
        winAtPosPDF.getParameters().put('id',asset.id);
        Test.setCurrentPage(winAtPosPDF);
        WinAtPOSPrintablePDFViewController cont=new WinAtPOSPrintablePDFViewController();
        cont.retrieveFiles();
        cont.addFilesToDwonloadStats();
        Test.stopTest();
        
        //check if proper file was retived for asset
        system.assertEquals(1, cont.files.size(), 'there should be found 1 primary file for asset');
        //check if file was added to download statistics
        List<Download_Statistics__c> downStats=[select id FROM Download_Statistics__c WHERE FileId__c =: cont.files.get(0).id];
        system.assertEquals(1, downStats.size(), 'file should be added to download statistics'); 
    }
    
    /*******************************************************************
    Purpose: Method to test retrive file data for asset group
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testRetriveFileDataForAssetGroup(){
        // Create test data           
        Category__c mainCat = new Category__c();
        mainCat.Name = 'Personal Care';
        mainCat.Type__c = 'Category Group';
        insert mainCat;
        
        Category__c cat = new Category__c();
        cat.Name = 'Deodorants';     
        cat.Type__c = 'Category';
        cat.Parent_Category__c = mainCat.Id;
        insert cat;
        
        Asset_Group__c assetGroup=new Asset_Group__c();
        assetGroup.Name='TestAssetGroup';
        assetGroup.Type__c='Masterbrand';
        assetGroup.Category__c=cat.Id;
        insert assetGroup;
        
        Asset__c asset = new Asset__c();
        asset.Name = 'TestAsset';
        asset.Asset_Group__c=assetGroup.id;
        asset.Category__c = cat.Id;
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Status__c = 'ToDelete';
        //asset.Scheduled_Delete_Date__c = System.today();
        insert asset;
        
        File__c file = new File__c();
        file.Name = 'TestFile';
        file.Asset__c = asset.Id;
        file.Type__c = 'Image';
        file.Is_Primary_Image__c=true;
        insert file;
        
        FeedItem feedItem = new FeedItem();
        feedItem.Type = 'ContentPost';
        feedItem.parentId = file.Id;
        feedItem.Title = 'Dove';
        feedItem.ContentFileName = 'Dove.jpeg';
        feedItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem.Body = 'Promo is the UK';
        insert feedItem;
        
        file.Feed_ID__c = feedItem.Id;
        update file;
        
        Test.startTest();
        PageReference winAtPosPDF=Page.WinAtPOSPrintablePDFView;
        winAtPosPDF.getParameters().put('id',assetGroup.id);
        Test.setCurrentPage(winAtPosPDF);
        WinAtPOSPrintablePDFViewController cont=new WinAtPOSPrintablePDFViewController();
        cont.retrieveFiles();
        cont.addFilesToDwonloadStats();
        Test.stopTest();
        
        //check if proper file was retived for assetGroup
        system.assertEquals(1, cont.files.size(), 'there should be found 1 primary file for asset');
        //check if file was added to download statistics
        List<Download_Statistics__c> downStats=[select id FROM Download_Statistics__c WHERE FileId__c =: cont.files.get(0).id];
        system.assertEquals(1, downStats.size(), 'file should be added to download statistics'); 
    }
    

}