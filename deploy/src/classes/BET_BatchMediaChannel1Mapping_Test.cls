/**********************************************************************
Name: BET_BatchMediaChannel1Mapping_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for  BET_BatchMediaChannel1Mapping_Test
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchMediaChannel1Mapping_Test { 
    /*******************************************************************
    Purpose: Method to test mapping assets using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapMediaChannel1(){
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
          bet.Category_Level_2__c = 'Deodorants & Fragrances';
          bet.Inoplan_Project__c = inoProject.id;
          bet.Name = 'bet1';
          insert bet;
         
         
         uw_Asset__c asset1 = new uw_Asset__c();
         asset1.Name ='Asset1';
         asset1.uw_BET__c = bet.id;
         asset1.Media_Channel_1__c = 'Interactive TV';
         assetList.add(asset1);
         
         uw_Asset__c asset2 = new uw_Asset__c();
         asset2.Name ='Asset2';
         asset2.uw_BET__c = bet.id;
         asset2.Media_Channel_1__c = 'Print';
         assetList.add(asset2);
         
         uw_Asset__c asset3 = new uw_Asset__c();
         asset3.Name ='Asset3';
         asset3.uw_BET__c = bet.id;
         asset3.Media_Channel_1__c = 'In Store';
         assetList.add(asset3);
         
         uw_Asset__c asset4 = new uw_Asset__c();
         asset4.Name ='Asset4';
         asset4.uw_BET__c = bet.id;
         asset4.Media_Channel_1__c = '';
         assetList.add(asset4);
         
         uw_Asset__c asset5 = new uw_Asset__c();
         asset5.Name ='Asset5';
         asset5.uw_BET__c = bet.id;
         asset5.Media_Channel_1__c = null;
         assetList.add(asset5);
         
         uw_Asset__c asset6 = new uw_Asset__c();
         asset6.Name ='Asset6';
         asset6.uw_BET__c = bet.id;
         asset6.Media_Channel_1__c = 'Mobile';
         assetList.add(asset6);
         insert assetList;
         
         // Start test
         Test.startTest();
         BET_BatchMediaChannel1Mapping batchMapping = new  BET_BatchMediaChannel1Mapping();
         Database.executeBatch(batchMapping, 200);
         Test.stopTest();
         
         // Assert test result
         //asset1 = [SELECT Id, Name, Media_Channel_1__c FROM uw_Asset__c WHERE Name = 'Asset1'];
         //asset2 = [SELECT Id, Name, Media_Channel_1__c FROM uw_Asset__c WHERE Name = 'Asset2'];
         //asset3 = [SELECT Id, Name, Media_Channel_1__c FROM uw_Asset__c WHERE Name = 'Asset3'];
         asset1 = [SELECT Id, Name, Media_Type__c FROM uw_Asset__c WHERE Name = 'Asset1'];
         asset2 = [SELECT Id, Name, Media_Type__c FROM uw_Asset__c WHERE Name = 'Asset2'];
         asset3 = [SELECT Id, Name, Media_Type__c FROM uw_Asset__c WHERE Name = 'Asset3'];
         asset4 = [SELECT Id, Name, Media_Type__c FROM uw_Asset__c WHERE Name = 'Asset4'];
         asset5 = [SELECT Id, Name, Media_Type__c FROM uw_Asset__c WHERE Name = 'Asset5'];
         asset6 = [SELECT Id, Name, Media_Type__c FROM uw_Asset__c WHERE Name = 'Asset6'];
         
         //System.assertEquals('TVC', asset1.Media_Channel_1__c);
         //System.assertEquals('In-Store', asset2.Media_Channel_1__c);
         //System.assertEquals('In-Store', asset3.Media_Channel_1__c);
         System.assertEquals('TVC', asset1.Media_Type__c);
         System.assertEquals('In-Store', asset2.Media_Type__c);
         System.assertEquals('In-Store', asset3.Media_Type__c);
         System.assertEquals(null, asset4.Media_Type__c);
         System.assertEquals(null, asset5.Media_Type__c);
         System.assertEquals('Mobile', asset6.Media_Type__c);
    }
}