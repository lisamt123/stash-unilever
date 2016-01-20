/**********************************************************************
Name: BET_BatchCategoryMapping_Test
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
public class BET_BatchCategoryMapping_Test { 
    /*******************************************************************
    Purpose: Method to test mapping brands using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapCategories(){
          List<uw_BET__c> betList = new List<uw_BET__c>();
         // Create Test data    
          uw_Brand__c brand = new uw_Brand__c();
          brand.Name = 'Dove';                   
          insert brand;
          
          BET_Category__c cat1 = new BET_Category__c();
          cat1.Name = 'Personal Care';
          cat1.BET_Parent_Category__c = null;
          insert cat1;
          
          BET_Category__c cat2 = new BET_Category__c();
          cat2.Name = 'Skin Cleansing';
          cat2.BET_Parent_Category__c = cat1.id;
          insert cat2;
                
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
          //betList.add(bet1);
          insert bet1;

           // Create BET
          uw_BET__c bet2 = new uw_BET__c();
          bet2.uw_Brand__c = brand.Id;        // Dove
          bet2.Status__c = 'First release';
          bet2.Sharing__c = 'Private';
          bet2.Product_Category_Sub_Division__c = 'Cross Category';
          bet2.Category_Level_2__c = '';
          bet2.Inoplan_Project__c = inoProject.id;
          bet2.Name = 'bet2';
          insert bet2;
          //betList.add(bet2);
          
          // Create BET
          //uw_BET__c bet3 = new uw_BET__c();
          //bet3.uw_Brand__c = brand.Id;        // Dove
          //bet3.Status__c = 'First release';
          //bet3.Sharing__c = 'Private';
          //bet3.Product_Category_Sub_Division__c = 'Personal Care excl Skin';
          //bet3.Category_Level_2__c = '';
          //bet3.Inoplan_Project__c = inoProject.id;
          //bet3.Name = 'bet3';
          //insert bet3;
          
           // Create BET
          uw_BET__c bet4 = new uw_BET__c();
          bet4.uw_Brand__c = brand.Id;        // Dove
          bet4.Status__c = 'First release';
          bet4.Sharing__c = 'Private';
          bet4.Product_Category_Sub_Division__c = '';
          bet4.Category_Level_2__c = '';
          bet4.Inoplan_Project__c = inoProject.id;
          bet4.Name = 'bet4';
          insert bet4;
          
          //betList.add(bet3);
          
  //        insert betList;

          
         // Start test
         Test.startTest();
         BET_BatchCategoryMapping batchMapping = new  BET_BatchCategoryMapping();
         Database.executeBatch(batchMapping, 200);
         Test.stopTest();
         
         // Assert test result
         bet1 = [SELECT Product_Category_Sub_Division__c,Category_Level_2__c,Category_Level_3__c,Category__c,Sub_Category__c, Id, Name  FROM uw_BET__c WHERE Name = 'bet1'];
         bet2 = [SELECT Product_Category_Sub_Division__c,Category_Level_2__c,Category_Level_3__c,Category__c,Sub_Category__c, Id, Name  FROM uw_BET__c WHERE Name = 'bet2'];
         //bet3 = [SELECT Product_Category_Sub_Division__c,Category_Level_2__c,Category_Level_3__c,Category__c,Sub_Category__c, Id, Name  FROM uw_BET__c WHERE Name = 'bet3'];
         bet4 = [SELECT Product_Category_Sub_Division__c,Category_Level_2__c,Category_Level_3__c,Category__c,Sub_Category__c, Id, Name  FROM uw_BET__c WHERE Name = 'bet4'];
         
         System.assertEquals(cat1.id, bet1.Category__c);
         System.assertEquals(cat2.id, bet1.Sub_Category__c);
         
         // Cross Category BETs are manually handled, the Batch job ignores them
         System.assertEquals(null, bet2.Category__c);
         System.assertEquals(null, bet2.Category__c);
         
         
         //System.assertEquals(cat1.id, bet3.Category__c);
         //System.assertEquals(null, bet3.Sub_Category__c);
         
         System.assertEquals(null, bet4.Category__c);
         System.assertEquals(null, bet4.Sub_Category__c);
         
    }
}