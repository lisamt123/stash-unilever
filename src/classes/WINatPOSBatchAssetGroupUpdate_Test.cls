/**********************************************************************
Name: WINatPOSBatchAssetUpdateGroup_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOSBatchAssetGroupUpdate
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          08/12/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WINatPOSBatchAssetGroupUpdate_Test { 
    /*******************************************************************
    Purpose: Method to test deleting assets using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void updateAssetGroups(){
   
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
        
        Asset_Group__c assetGroup = new Asset_Group__c();
        assetGroup.Name = 'TestAssetGroup';
        assetGroup.Category__c = cat.Id;
        assetGroup.Type__c = 'Repeatable Model';
        assetGroup.Market_Cluster__c = 'Global';
        insert assetGroup;
        
        // Run the code that we want to test
        
        Test.startTest();
        WINatPOSBatchAssetGroupUpdate batchUpdate = new WINatPOSBatchAssetGroupUpdate();
        Database.executeBatch(batchUpdate, 200);
        Test.stopTest();
        
        List<Asset_Group__c> assetGroupList = [SELECT Id, Name, Category_Name_for_KeyWord_Search__c,Market_Cluster_for_KeyWord_Search__c,Type_for_Keyword_Search__c FROM Asset_Group__c WHERE Id = :assetGroup.Id];
        
         // Assert test results
        System.assertEquals('Deodorants', assetGroupList[0].Category_Name_for_KeyWord_Search__c);
        System.assertEquals('Global', assetGroupList[0].Market_Cluster_for_KeyWord_Search__c);
        System.assertEquals('Repeatable Model', assetGroupList[0].Type_for_KeyWord_Search__c);
   
    }
    
    /*******************************************************************
    Purpose: Method to test deleting assets using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void updateAssetGroupswithDMLException(){
   
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
        
        Asset_Group__c assetGroup = new Asset_Group__c();
        assetGroup.Name = 'DummyAssetGroupForDMLUpdateException';
        assetGroup.Category__c = cat.Id;
        assetGroup.Type__c = 'Repeatable Model';
        assetGroup.Market_Cluster__c = 'Global';
        insert assetGroup;
        
        // Run the code that we want to test
        
        Test.startTest();
        WINatPOSBatchAssetGroupUpdate batchUpdate = new WINatPOSBatchAssetGroupUpdate();
        Database.executeBatch(batchUpdate, 200);
        Test.stopTest();
        
        List<Asset_Group__c> assetGroupList = [SELECT Id, Name, Category_Name_for_KeyWord_Search__c,Market_Cluster_for_KeyWord_Search__c,Type_for_Keyword_Search__c FROM Asset_Group__c WHERE Id = :assetGroup.Id];
        
         // Assert test results
        System.assertEquals(0, assetGroupList.size());
   
    }

}