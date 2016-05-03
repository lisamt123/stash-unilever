/*===========================================================================
  Name:  WINatPOSTest                                                       
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: Test methods for WIN@POS application                                                                  
  -------                                                                    
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Darren Sabey   22/10/2013      INITIAL DEVELOPMENT               
  ===========================================================================*/

// Need to set SeeAllData to true so that Apex Connect methods can be invoked
@isTest(SeeAllData=true)
private class WINatPOSTest {

    static Profile padmin;
    static Profile pviewer;
    static User admin;
    static User viewer;
    static User publisher;
    static List<Category__c> categories;
    static List<Brand_Master__c> brands;
    static List<Category_Brands__c> categoryBrands;
    static List<Asset_Group__c> assetGroups;
    static List<Asset__c> assets;
    static List<File__c> files;
    static File__c f1;
    static File__c f2;
    static File__c f3;
    static File__c f4;
    static File__c f5;
     
    static void setupData() {
        padmin = [Select Id From Profile Where Name='System Administrator'];
        pviewer = [Select Id From Profile Where UserLicense.Name = 'Salesforce Platform' Limit 1]; 
        
        admin = new User(Alias = 'newUser', Email='wpadmin@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='TestingAdmin123', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = padmin.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='wpadmin@testorg.com');
        insert admin;
        
        publisher = new User(Alias = 'newUser', Email='wppublisher@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='TestingPublisher123', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = pviewer.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='wppublisher@testorg.com');
        insert publisher;
        
        viewer = new User(Alias = 'newUser', Email='wpuser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='TestingViewer123', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = pviewer.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='wpuser@testorg.com');
        insert viewer;
        
        // Categories
        categories = new List<Category__c>();
        for (Integer i = 0; i < 20; i++) {
            categories.add(new Category__c(name='cat' + i,Type__c='Category'));
        }
        insert categories;
         
        // Brands
        brands = new List<Brand_Master__c>();
        for (Integer i = 0; i < 20; i++) {
           brands.add(new Brand_Master__c(name='brand' + i,Apps__c='WINatPOS'));
        }
        insert brands;
         
        // Category brands
        categoryBrands = new List<Category_Brands__c>();
        for (Integer i = 0; i < 20; i++) {
        categoryBrands.add(new Category_Brands__c(name='Cat ' + i + ' - ' + 'Brand ' + i,Category__c=categories[i].Id,Brand__c=brands[i].Id));
        }
        insert categoryBrands;
        
        // Asset groups
        assetGroups = new List<Asset_Group__c>();
        Asset_Group__c assetGroup1 = new Asset_Group__c();
        assetGroup1.Name = 'New Asset Group';
        assetGroup1.Type__c = 'Innovation';
        insert assetGroup1;
        assetGroups.add(assetGroup1);
        
        assets = new List<Asset__c>(); 
        Asset__c asset1 = new Asset__c();
        asset1.Name = 'New Asset';
        asset1.Category__c = categories[0].Id;
        asset1.Brand__c = brands[0].Id;
        asset1.Channels__c = 'Supermarkets';
        asset1.Placement__c = 'Primary';
        asset1.POS_Asset_Type__c = 'Masterbrand';
        asset1.Status__c = 'Approved';
        insert asset1;
        assets.add(asset1);
        
        Asset__c asset2 = new Asset__c();
        asset2.Name = 'New Asset';
        asset2.Asset_Group__c = assetGroups[0].Id;
        asset2.Category__c = categories[0].Id;
        asset2.Brand__c = brands[0].Id;
        asset2.Channels__c = 'Supermarkets';
        asset2.Placement__c = 'Primary';
        asset2.POS_Asset_Type__c = 'Innovation';
        asset2.Status__c = 'Approved';
        insert asset2;
        assets.add(asset2);
        
    }

    static testMethod void  runTests() {

        // Setup data and run the tests
        setupData();
        Test.startTest();
        System.runAs(admin){ 
        testWINatPOSUserAdmin();
        }
        System.runAs(publisher) {
            testWINatPOSUpload();
        }
        System.runAs(viewer) {
            testWINatPOS();
            testWINatPOSPrintableView();
        }
        Test.stopTest();
        
    }
    
    static void testWINatPOSUserAdmin() {
    
        Test.setCurrentPage(Page.WINatPOSUserAdmin);
        WINatPOSUserAdminController c = new WINatPOSUserAdminController();
        
        // Search without entering sufficient search criteria
        c.searchString = '';
        PageReference p = c.search();
        
        // Error will be handled
        System.assertEquals(2, ApexPages.getMessages().size());
        System.assert(ApexPages.getMessages()[1].getDetail().contains('Search term must be longer than 2 characters'));
        
        // Search for the publisher user and add the permission set (add viewer permission set too so we can test the ranking logic)
        c.searchString = 'TestingPublisher123';
        
        // Need to set fixed search results for SOSL search
        List<Id> searchResultIds = new List<Id>{publisher.Id};
        Test.setFixedSearchResults(searchResultIds);
        p = c.search();
        
        // Search finds one user record
        System.assertEquals(null, p);
        System.assertEquals(1, c.users.size());
        
        // Select the user record
        c.users[0].selected = true;
      
        // Add the viewer permission set
        c.permissionSetId = c.permissionSetOptions[1].getValue();
        p = c.applyUpdates();
        
        // Then add the publisher permission set
        c.permissionSetId = c.permissionSetOptions[2].getValue();
        p = c.applyUpdates();
        
        // The publisher permission set should be the one displayed in the page (i.e. ranking is higher than viewer permission set)
        System.assertEquals(c.permissionSetOptions[2].getValue(), c.users[0].ps.id);
        
        // In the backend, the user will still be assigned both permission sets
        List<Id> permissionSetIds = new List<Id>{c.permissionSetOptions[1].getValue(), c.permissionSetOptions[2].getValue()};
        List<PermissionSetAssignment> psas = [Select Id From PermissionSetAssignment Where AssigneeId = :publisher.Id And PermissionSetId In : permissionSetIds];
        System.assertEquals(2, psas.size());
        
        p = c.clear();
        System.assertEquals('', c.searchString);
        
        // Search for the viewer user and add the permission set
        c.searchString = 'TestingViewer123';
        
        searchResultIds = new List<Id>{viewer.Id};
        Test.setFixedSearchResults(searchResultIds);
        p = c.search();
        
        // Search finds one user record
        System.assertEquals(null, p);
        System.assertEquals(1, c.users.size());
        
        // Select the user record
        c.users[0].selected = true;
        
        // Add the viewer permission set
        c.permissionSetId = c.permissionSetOptions[1].getValue();
        p = c.applyUpdates();
        
        // Only one permission set assigned to the user record
        psas = [Select Id From PermissionSetAssignment Where AssigneeId = :viewer.Id And PermissionSetId = :c.permissionSetOptions[1].getValue()];
       System.assertEquals(1, psas.size());
        
        // Remove the permission set to test this part of the code
        c.permissionSetId = c.permissionSetOptions[0].getValue();
        p = c.applyUpdates();
        
        // Permission set has been removed
        psas = [Select Id From PermissionSetAssignment Where AssigneeId = :viewer.Id And PermissionSetId = :c.permissionSetOptions[1].getValue()];
        System.assertEquals(0, psas.size());
        
        // Give the permission set back again so we can run remaining tests as this user
        c.permissionSetId = c.permissionSetOptions[1].getValue();
        p = c.applyUpdates();
        System.assertEquals(null, p);
        
        // Viewer permission set has been added back
        psas = [Select Id From PermissionSetAssignment Where AssigneeId = :viewer.Id And PermissionSetId = :c.permissionSetOptions[1].getValue()];
        System.assertEquals(1, psas.size());
    
    }    
    
    static void testWINatPOSUpload() {
        
        // Category file
        f1 = new File__c(Category__c=categories[0].Id);
        // Brand file
        f2 = new File__c(Brand__c=brands[0].Id);
        // Files for Masterbrand asset
        f3 = new File__c(Asset__c=assets[0].Id);
        f4 = new File__c(Asset__c=assets[0].Id);
        // Files for Innovation asset
        f5 = new File__c(Asset__c=assets[1].Id);
        
        Test.setCurrentPage(Page.WINatPOSUpload);
        
        // Create a category file
        WINatPOSUploadController c = new WINatPOSUploadController(new ApexPages.StandardController(f1));
        c.f.Type__c = Label.WP_File_Type_Download;
        c.f.Sub_Type__c = 'Presentation';
        c.f.Is_Primary_Image__c = false;
        c.f.POS_File_Type__c = 'Masterbrand';
        c.d.Name = 'STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG STRING TOO LONG ';
        c.d.Body = Blob.valueOf('Body Content');
        PageReference pr = c.saveAndUpload();
       
        // Fails because file name is too long 
        System.assertEquals(4, ApexPages.getMessages().size());
        System.assert(ApexPages.getMessages()[2].getDetail().contains('data value too large'));
        
        // And again...
        c.d.Name = 'NAME IS FINE';
        c.d.Body = Blob.valueOf('Body Content');
        pr = c.saveAndUpload();
        
        // This time it works, there are no additional error messages
        System.assertEquals(4, ApexPages.getMessages().size());
        
        // Create a brand file
        c = new WINatPOSUploadController(new ApexPages.StandardController(f2));
        c.f.Type__c = Label.WP_File_Type_Download;
        c.f.Sub_Type__c = 'Presentation';
        c.f.POS_File_Type__c = 'Masterbrand';
        c.f.Is_Primary_Image__c = false;
        c.f.Name = 'Download Presentation2';
        c.d.Name = 'Download Presentation2';
        c.d.Body = Blob.valueOf('Body Content');
        pr = c.saveAndUpload();
        
        // No additional error messages
        System.assertEquals(4, ApexPages.getMessages().size());
        
        // Create an asset file
        c = new WINatPOSUploadController(new ApexPages.StandardController(f3));
        c.f.Type__c = Label.WP_File_Type_Image;
        c.f.Sub_Type__c = 'Download Image';
        c.f.Is_Primary_Image__c = true;
        c.f.POS_File_Type__c = 'Masterbrand';
        c.f.Name = 'Normal3';
        c.d.Name = 'Normal3';
        c.d.Body = Blob.valueOf('Body Content');
        pr = c.saveAndUpload();
        
        // No additional error messages
        System.assertEquals(4, ApexPages.getMessages().size());
        
        // Create a second asset file
        c = new WINatPOSUploadController(new ApexPages.StandardController(f4));
        c.f.Type__c = Label.WP_File_Type_Download;
        c.f.Sub_Type__c = 'Presentation';
        c.f.Is_Primary_Image__c = false;
        c.f.POS_File_Type__c = 'Masterbrand';
        c.f.Name = 'Normal4';
        c.d.Name = 'Normal4';
        c.d.Body = Blob.valueOf('Body Content');
        pr = c.saveAndUpload();
        
        // No additional error messages
        System.assertEquals(4, ApexPages.getMessages().size());
        
        // Try to update a file
        c = new WINatPOSUploadController(new ApexPages.StandardController(f4));
        c.f.Name = 'Normal2';
        pr = c.saveAndUpload();
        System.assertEquals(4, ApexPages.getMessages().size());
        
        // Create a file for the Innovation asset
        c = new WINatPOSUploadController(new ApexPages.StandardController(f5));
        c.f.Type__c = Label.WP_File_Type_Image;
        c.f.Sub_Type__c = 'Download Image';
        c.f.Is_Primary_Image__c = true;
        c.f.POS_File_Type__c = 'Innovation';
        c.f.Name = 'Normal5';
        c.d.Name = 'Normal5';
        c.d.Body = Blob.valueOf('Body Content');
        pr = c.saveAndUpload();

        // No additional error messages
        System.assertEquals(4, ApexPages.getMessages().size());
        
    }     

    static void testWINatPOS() {
        
        // Test the WIN@POS page and controller
        Test.setCurrentPage(Page.WINatPOS_Masterbrand);
        WINatPOSController c = new WINatPOSController();
        WINatPOSController.getChannelsAndCategories();         
        WINatPOSController.retrieveBrandsForCategory(categories[0].Id);
        WINatPOSController.AssetResult res = WINatPOSController.retrieveAssets(null, categories[0].Id, brands[0].Id, 'Masterbrand');
        
        // Confirm just one asset displayed
        System.assertEquals(1, res.assets.size());
        
        Test.setCurrentPage(Page.WINatPOS_Innovations);
        c = new WINatPOSController();
        WINatPOSController.getChannelsAndCategories();
        WINatPOSController.retrieveBrandsForCategory(categories[0].Id);
        WINatPOSController.retrieveAssetGroups(brands[0].Id, 'Innovation');
        res = WINatPOSController.retrieveAssets(assetGroups[0].Id, null, null, 'Innovation');
        
        // Confirm just one asset displayed
        System.assertEquals(1, res.assets.size());
        
        Test.setCurrentPage(Page.WINatPOS_InStoreExecutions);
        c = new WINatPOSController();
        
        Test.setCurrentPage(Page.WINatPOS_RepeatableModels);
        c = new WINatPOSController();
        
    }

    static void testWINatPOSPrintableView() {
    
        Test.setCurrentPage(Page.WINatPOS_Masterbrand);
        WINatPOSController c = new WINatPOSController();
        WINatPOSController.getChannelsAndCategories();
        WINatPOSController.retrieveBrandsForCategory(categories[0].Id);
        
        PageReference pr = Page.WINatPOSPrintableView;
        pr.getParameters().put('id', String.valueOf(brands[0].Id));
        pr.getParameters().put('mode', 'Masterbrand');
        Test.setCurrentPage(pr);
        WINatPOSPrintableViewController pvc = new WINatPOSPrintableViewController();
        
        // Check size of the files list
        System.assertEquals(1, pvc.files.size());
        
        pr = Page.WINatPOSPrintableView;
        pr.getParameters().put('id', String.valueOf(assets[0].Id));
        pr.getParameters().put('mode', 'Masterbrand');
        Test.setCurrentPage(pr);
        pvc = new WINatPOSPrintableViewController();
        
        // Check size of the files list
        System.assertEquals(1, pvc.files.size());
        
    }
        
}