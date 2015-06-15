/**********************************************************************
Name: WINatPOSBatchAssetUpdate_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOSBatchAssetUpdate
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          08/12/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WINatPOSBatchAssetUpdate_Test { 
    /*******************************************************************
    Purpose: Method to test deleting assets using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void updateAssets(){
   
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
        
        Asset__c asset = new Asset__c();
        asset.Name = 'TestAsset';
        asset.Category__c = cat.Id;
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Status__c = 'Approved';
        insert asset;
        
        // Run the code that we want to test
        
        Test.startTest();
        WINatPOSBatchAssetUpdate batchUpdate = new WINatPOSBatchAssetUpdate();
        Database.executeBatch(batchUpdate, 200);
        Test.stopTest();
        
        List<Asset__c> assetList = [SELECT Id, Name, Category_Name_for_KeyWord_Search__c,Market_Cluster_for_KeyWord_Search__c,POS_Asset_Type_for_KeyWord_Search__c FROM Asset__c WHERE Id = :asset.Id];
        
         // Assert test results
        System.assertEquals('Deodorants', assetList[0].Category_Name_for_KeyWord_Search__c);
        System.assertEquals('Global', assetList[0].Market_Cluster_for_KeyWord_Search__c);
        System.assertEquals('Masterbrand', assetList[0].POS_Asset_Type_for_KeyWord_Search__c);
   
    }
    
    
    static testmethod void updateAssetswithDMLException(){
   
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
        
        Asset__c asset = new Asset__c();
        asset.Name = 'DummyAssetForDMLUpdateException';
        asset.Category__c = cat.Id;
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Status__c = 'Approved';
        insert asset;
        
        // Run the code that we want to test
        
        Test.startTest();
        WINatPOSBatchAssetUpdate batchUpdate = new WINatPOSBatchAssetUpdate();
        Database.executeBatch(batchUpdate, 200);
        Test.stopTest();
        
        List<Asset__c> assetList = [SELECT Id, Name, Category_Name_for_KeyWord_Search__c,Market_Cluster_for_KeyWord_Search__c,POS_Asset_Type_for_KeyWord_Search__c FROM Asset__c WHERE Id = :asset.Id];
        
         // Assert test results
        System.assertEquals(0, assetList.size());

    }
}