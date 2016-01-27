/**********************************************************************
Name: BET_BatchBrandDelete_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_BatchBrandDelete_Test 
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchBrandDelete_Test { 
    /*******************************************************************
    Purpose: Method to test deleting assets using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void deleteAssets(){
        List<uw_Brand__c> brandList = new List<uw_Brand__c>();
         // Create Test data
         uw_Brand__c brand1= new uw_Brand__c();
         brand1.Name = 'Chef';
         brandList.add(brand1);
         
         uw_Brand__c brand2= new uw_Brand__c();
         brand2.Name = 'Other Foods';
          brandList.add(brand2);
         
         uw_Brand__c brand3 = new uw_Brand__c();
         brand3.Name ='Axe';
         brandList.add(brand3);
         
         insert brandList;
         
         // Start test
         Test.startTest();
         BET_BatchBrandDelete batchDelete = new  BET_BatchBrandDelete();
         Database.executeBatch(batchDelete, 200);
         Test.stopTest();
         
         // Assert test result
         List<uw_Brand__c> remainingBrandList = [SELECT Id, Name FROM uw_Brand__c limit 3];
         System.assertEquals(1, remainingBrandList.size());
    }
    
    static testmethod void deleteAssetsWithDeleteDMLException(){
         // Create Test data
         uw_Brand__c brand= new uw_Brand__c();
         brand.Name = 'Test Brand';
         
         insert brand;
         
         // Start test
         Test.startTest();
         BET_BatchBrandDelete batchDelete = new  BET_BatchBrandDelete();
         Database.executeBatch(batchDelete, 200);
         Test.stopTest();
         
         // Assert test result
         List<uw_Brand__c> remainingBrandList = [SELECT Id, Name FROM uw_Brand__c limit 1];
         System.assertEquals(0, remainingBrandList.size());
    }
}