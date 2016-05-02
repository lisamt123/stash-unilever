/**********************************************************************
Name: BET_BatchBETStatusMapping_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_BatchCategoryMapping_Test 
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          22/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchBETStatusMapping_Test { 
    /*******************************************************************
    Purpose: Method to test mapping brands using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapStatus(){
         List<uw_BET__c> betList = new List<uw_BET__c>();
         // Create Test data    
          uw_Brand__c brand = new uw_Brand__c();
          brand.Name = 'Dove';                   
          insert brand;
          
          // Create an Inoplan Project
          uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
          inoProject.name = 'No Inoplan Project' + Math.random();
          insert inoProject;
                
          // Create BET
          uw_BET__c bet1 = new uw_BET__c();
          bet1.uw_Brand__c = brand.Id;        // Dove
          bet1.Status__c = 'First release';
          bet1.Sharing__c = 'Private';
          bet1.Product_Category_Sub_Division__c = 'Skin';
          bet1.Category_Level_2__c = 'Skin Cleansing';
          bet1.Inoplan_Project__c = inoProject.id;
          bet1.Name = 'bet1';  
          betList.add(bet1);
          //insert bet1;
          
          // Create BET
          uw_BET__c bet2 = new uw_BET__c();
          bet2.uw_Brand__c = brand.Id;        // Dove
          bet2.Status__c = 'In Studio';
          bet2.Sharing__c = 'Private';
          bet2.Product_Category_Sub_Division__c = 'Skin';
          bet2.Category_Level_2__c = 'Skin Cleansing';
          bet2.Inoplan_Project__c = inoProject.id;
          bet2.Name = 'bet2';
          betList.add(bet2);  
          
          insert betList;
          
         // Start test
         Test.startTest();
         BET_BatchBETStatusMapping batchMapping = new  BET_BatchBETStatusMapping();
         Database.executeBatch(batchMapping, 200);
         Test.stopTest();
         
         // Assert test result
         bet1 = [SELECT Id, Name, Status__c  FROM uw_BET__c WHERE Name = 'bet1'];
         bet2 = [SELECT Id, Name, Status__c  FROM uw_BET__c WHERE Name = 'bet2'];
         
         System.assertEquals('First release', bet1.Status__c);
         System.assertEquals('Unreleased', bet2.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test exceptionv handling when mapping brands using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapStatusException(){
         List<uw_BET__c> betList = new List<uw_BET__c>();
         // Create Test data    
          uw_Brand__c brand = new uw_Brand__c();
          brand.Name = 'Dove';                   
          insert brand;
          
          // Create an Inoplan Project
          uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
          inoProject.name = 'No Inoplan Project' + Math.random();
          insert inoProject;

          // Create BET
          uw_BET__c bet2 = new uw_BET__c();
          bet2.uw_Brand__c = brand.Id;        // Dove
          bet2.Status__c = 'In Studio';
          bet2.Sharing__c = 'Private';
          bet2.Product_Category_Sub_Division__c = 'Skin';
          bet2.Category_Level_2__c = 'Skin Cleansing';
          bet2.Inoplan_Project__c = inoProject.id;
          bet2.Name = 'scjh647cwfwi73g6fr';
          betList.add(bet2);  
          
          insert betList;
          
         // Start test
         Test.startTest();
         BET_BatchBETStatusMapping batchMapping = new  BET_BatchBETStatusMapping();
         Database.executeBatch(batchMapping, 200);
         Test.stopTest();
         
         // Assert test result
         bet2 = [SELECT Id, Name, Status__c  FROM uw_BET__c WHERE Name = 'scjh647cwfwi73g6fr'];
         
         System.assertEquals('In Studio', bet2.Status__c);
    }
}