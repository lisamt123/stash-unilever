/**********************************************************************
Name: BET_BatchBrandMapping_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_BatchBrandMapping_Test 
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchBrandMapping_Test { 
    /*******************************************************************
    Purpose: Method to test mapping brands using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void mapBrands(){
          List<uw_Brand__c> brandList = new List<uw_Brand__c>();
          List<uw_Asset__c> assetList = new List<uw_Asset__c>();
         // Create Test data
          uw_Brand__c brand1 = new uw_Brand__c();
          brand1.Name = 'Knorrox';
          brandList.add(brand1);
          
          uw_Brand__c brand2 = new uw_Brand__c();
          brand2.Name = 'Knorr Knorrox';
          brandList.add(brand2); 
          
          uw_Brand__c brand3 = new uw_Brand__c();
          brand3.Name = 'Babycare';
          brandList.add(brand3);
          
          uw_Brand__c brand4 = new uw_Brand__c();
          brand4.Name = 'Zwitsal';
          brandList.add(brand4);
          
          uw_Brand__c brand5 = new uw_Brand__c();
          brand5.Name = 'Axe';
          brandList.add(brand5);
                   
          insert brandList;
          
          // Create an Inoplan Project
          uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
          inoProject.name = 'No Inoplan Project' + Math.random();
          insert inoProject;
                
          // Create BETs
          List<uw_BET__c> betList = new List<uw_BET__c>();
          uw_BET__c bet1 = new uw_BET__c();  
          bet1.uw_Brand__c = brand1.Id;        // Knorr
          bet1.Status__c = 'First release';
          bet1.Sharing__c = 'Private';
          bet1.Product_Category_Sub_Division__c = 'Cooking Products';
          bet1.Category_Level_2__c ='Savoury';
          bet1.Inoplan_Project__c = inoProject.id;
          bet1.Name = 'bet1';
          betList.add(bet1);
          
          uw_BET__c bet2 = new uw_BET__c();
          bet2.uw_Brand__c = brand3.Id;        // Babycare
          bet2.Status__c = 'First release';
          bet2.Sharing__c = 'Private';
          bet2.Product_Category_Sub_Division__c = '';
          bet2.Category_Level_2__c ='Skin Care';
          bet2.Inoplan_Project__c = inoProject.id;
          bet2.Name = 'bet2';
          betList.add(bet2);
          
          uw_BET__c bet3 = new uw_BET__c();
          bet3.uw_Brand__c = brand5.Id;        // Axe
          bet3.Status__c = 'First release';
          bet3.Sharing__c = 'Private';
          bet3.Product_Category_Sub_Division__c = 'Deodorants';
          bet3.Category_Level_2__c ='Deodorants & Fragrances';
          bet3.Inoplan_Project__c = inoProject.id;
          bet3.Name = 'bet3';
          betList.add(bet3);
          
          uw_BET__c bet4 = new uw_BET__c();
          bet4.uw_Brand__c = null;        // Empty
          bet4.Status__c = 'First release';
          bet4.Sharing__c = 'Private';
          bet4.Product_Category_Sub_Division__c = 'Deodorants';
          bet4.Category_Level_2__c ='Deodorants & Fragrances';
          bet4.Inoplan_Project__c = inoProject.id;
          bet4.Name = 'bet4';
          betList.add(bet4);
          
          uw_BET__c bet5 = new uw_BET__c();
          bet5.uw_Brand__c = null;        // Empty
          bet5.Status__c = 'First release';
          bet5.Sharing__c = 'Private';
          bet5.Product_Category_Sub_Division__c = 'Deodorants';
          bet5.Category_Level_2__c ='Deodorants & Fragrances';
          bet5.Inoplan_Project__c = inoProject.id;
          bet5.Name = 'bet5';
          betList.add(bet5);
           
          insert betList;
          
         // Start test
         Test.startTest();
         BET_BatchBrandMapping batchMapping = new  BET_BatchBrandMapping();
         Database.executeBatch(batchMapping, 200);
         Test.stopTest();
         
         // Assert test result
         bet1 = [SELECT Id, Name, uw_Brand__c FROM uw_BET__c WHERE Name = 'bet1'];
         bet2 = [SELECT Id, Name, uw_Brand__c FROM uw_BET__c WHERE Name = 'bet2'];
         bet3 = [SELECT Id, Name, uw_Brand__c FROM uw_BET__c WHERE Name = 'bet3'];
         bet4 = [SELECT Id, Name, uw_Brand__c FROM uw_BET__c WHERE Name = 'bet4'];
         bet5 = [SELECT Id, Name, uw_Brand__c FROM uw_BET__c WHERE Name = 'bet5'];
         
         System.assertEquals(brand2.id, bet1.uw_Brand__c);
         System.assertEquals(brand4.id, bet2.uw_Brand__c);
         System.assertEquals(brand5.id, bet3.uw_Brand__c);
         System.assertEquals(null, bet4.uw_Brand__c);
         System.assertEquals(null, bet5.uw_Brand__c);

    }
}