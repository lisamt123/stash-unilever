/**********************************************************************
Name: BET_BatchAssetStatusMapping_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for  BET_BatchAssetStatusMapping
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchAssetStatusMapping_Test { 
    /*******************************************************************
    Purpose: Method to test mapping assets status using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapAssetStatus(){
          List<uw_Asset__c> assetList = new List<uw_Asset__c>();
         // Create Test data
          uw_Brand__c brand = new uw_Brand__c();
          brand.Name = 'brand1';
          insert brand;
          
          // Create an Inoplan Project
          uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
          inoProject.name = 'No Inoplan Project' + Math.random();
          insert inoProject;
                
          // Create a BET
          uw_BET__c bet = new uw_BET__c();
          bet.uw_Brand__c = brand.Id;
          bet.Status__c = 'First release';
          bet.Sharing__c = 'Private';
          bet.Product_Category_Sub_Division__c = 'Deodorants';
          bet.Category_Level_2__c ='Deodorants & Fragrances';
          bet.Inoplan_Project__c = inoProject.id;
          bet.Name = 'bet1';
          insert bet;
         
         
         uw_Asset__c asset1 = new uw_Asset__c();
         asset1.Name ='Asset1';
         asset1.uw_BET__c = bet.id;
         asset1.Status__c = 'Work In Progress';
         asset1.Studio_Asset_Type__c = 'Creative Work';
         assetList.add(asset1);
         
         uw_Asset__c asset2 = new uw_Asset__c();
         asset2.Name ='Asset2';
         asset2.uw_BET__c = bet.id;
         asset2.Status__c = 'Work In Progress';
         asset2.Studio_Asset_Type__c = 'Document';
         assetList.add(asset2);
         
         uw_Asset__c asset3 = new uw_Asset__c();
         asset3.Name ='Asset3';
         asset3.uw_BET__c = bet.id;
         asset3.Status__c = 'Final';
         asset3.Studio_Asset_Type__c = 'Brand Experience Presentation';
         assetList.add(asset3);
         
         uw_Asset__c asset4 = new uw_Asset__c();
         asset4.Name ='Asset4';
         asset4.uw_BET__c = bet.id;
         asset4.Status__c = null;
         asset4.Studio_Asset_Type__c = null;
         assetList.add(asset4);
         
         uw_Asset__c asset5 = new uw_Asset__c();
         asset5.Name ='Asset5';
         asset5.uw_BET__c = bet.id;
         asset5.Status__c = '';
         asset5.Studio_Asset_Type__c = '';
         assetList.add(asset5);
         
         insert assetList;
         
         // Start test
         Test.startTest();
         BET_BatchAssetStatusMapping batchMapping = new  BET_BatchAssetStatusMapping();
         Database.executeBatch(batchMapping, 200);
         Test.stopTest();
         
         // Assert test result
         asset1 = [SELECT Id, Name, Status__c, Studio_Asset_Type__c FROM uw_Asset__c WHERE Name = 'Asset1'];
         asset2 = [SELECT Id, Name, Status__c, Studio_Asset_Type__c FROM uw_Asset__c WHERE Name = 'Asset2'];
         asset3 = [SELECT Id, Name, Status__c, Studio_Asset_Type__c FROM uw_Asset__c WHERE Name = 'Asset3'];
         asset4 = [SELECT Id, Name, Status__c, Studio_Asset_Type__c FROM uw_Asset__c WHERE Name = 'Asset4'];
         asset5 = [SELECT Id, Name, Status__c, Studio_Asset_Type__c FROM uw_Asset__c WHERE Name = 'Asset5'];
         
         System.assertEquals('Draft', asset1.Status__c);
         System.assertEquals('Draft', asset2.Status__c);
         //System.assertEquals('Final', asset3.Status__c);
         System.assertEquals('Approved', asset3.Status__c);
         System.assertEquals('Draft', asset4.Status__c);
         System.assertEquals('Draft', asset5.Status__c);
         
         
         System.assertEquals('Creative Work', asset1.Studio_Asset_Type__c);
         System.assertEquals('Creative Work', asset2.Studio_Asset_Type__c);
         System.assertEquals('Brand Experience Presentation', asset3.Studio_Asset_Type__c);
         System.assertEquals(null, asset4.Studio_Asset_Type__c);
         System.assertEquals(null, asset5.Studio_Asset_Type__c);
    }

    /*******************************************************************
    Purpose: Method to test exceptionv handling when mapping assets status using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapAssetStatusException(){
        List<uw_Asset__c> assetList = new List<uw_Asset__c>();
        // Create Test data
        uw_Brand__c brand = new uw_Brand__c();
        brand.Name = 'brand1';
        insert brand;
          
        // Create an Inoplan Project
        uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
        inoProject.name = 'No Inoplan Project' + Math.random();
        insert inoProject;
               
        // Create a BET
        uw_BET__c bet = new uw_BET__c();
        bet.uw_Brand__c = brand.Id;
        bet.Status__c = 'First release';
        bet.Sharing__c = 'Private';
        bet.Product_Category_Sub_Division__c = 'Deodorants';
        bet.Category_Level_2__c ='Deodorants & Fragrances';
        bet.Inoplan_Project__c = inoProject.id;
        bet.Name = 'bet1';
        insert bet;
         
         
        uw_Asset__c asset1 = new uw_Asset__c();
        asset1.Name ='Test Asset';
        asset1.uw_BET__c = bet.id;
        asset1.Status__c = 'Work In Progress';
        asset1.Studio_Asset_Type__c = 'Creative Work';
        assetList.add(asset1);
         
        insert assetList;
         
        // Start test
        Test.startTest();
        BET_BatchAssetStatusMapping batchMapping = new  BET_BatchAssetStatusMapping();
        Database.executeBatch(batchMapping, 200);
        Test.stopTest();

        // Assert test result
        asset1 = [SELECT Id, Name, Status__c, Studio_Asset_Type__c FROM uw_Asset__c WHERE Name = 'Test Asset'];
         
        System.assertNotEquals('Draft', asset1.Status__c);
    }

}