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
1.0 -   Istvan Szegedi          18/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WINatPOSPurgeStats_Test { 
    /*******************************************************************
    Purpose: Method to test purging statistical records using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void purgeStats(){
        // Create test data
        Download_Statistics__c dlstats1 = new Download_Statistics__c();
        dlstats1.Content_Name__c = 'Axe';
        dlstats1.Content_Size__c = 1024;
        dlstats1.Content_Type__c = 'JPEG';
        dlstats1.Timestamp__c = System.now();
        
        Download_Statistics__c dlstats2 = new Download_Statistics__c();
        dlstats2.Content_Name__c = 'Rexona';
        dlstats2.Content_Size__c = 1024;
        dlstats2.Content_Type__c = 'PNG';
        dlstats2.Timestamp__c = System.now() - 1;
        
        Download_Statistics__c dlstats3 = new Download_Statistics__c();
        dlstats3.Content_Name__c = 'Dove';
        dlstats3.Content_Size__c = 2048;
        dlstats3.Content_Type__c = 'JPEG';
        dlstats3.Timestamp__c = System.now() - 50;
        
        Download_Statistics__c dlstats4 = new Download_Statistics__c();
        dlstats4.Content_Name__c = 'Magnum';
        dlstats4.Content_Size__c = 2048;
        dlstats4.Content_Type__c = 'JPEG';
        dlstats4.Timestamp__c = System.now() - 32;
        
        Download_Statistics__c dlstats5 = new Download_Statistics__c();
        dlstats5.Content_Name__c = 'Cif';
        dlstats5.Content_Size__c = 4096;
        dlstats5.Content_Type__c = 'PNG';
        dlstats5.Timestamp__c = System.now() - 32;
        
        List<Download_Statistics__c> dlstatsList = new List<Download_statistics__c>();
        dlstatsList.add(dlstats1);
        dlstatsList.add(dlstats2);
        dlstatsList.add(dlstats3);
        dlstatsList.add(dlstats4);
        dlstatsList.add(dlstats5);
        
        insert dlstatsList;
        
        // Run the code that we want to test     
        Test.startTest();
        WINatPOSPurgeStats batchPurge = new WINatPOSPurgeStats('Download_Statistics__c', 'Timestamp__c', 30);
        Database.executeBatch(batchPurge, 200);
        Test.stopTest(); 
                
        Integer numberOfStats = [SELECT count() FROM Download_Statistics__c];
        List<Download_Statistics__c> dlList1 = [SELECT Id FROM Download_Statistics__c WHERE Content_Name__c = 'Axe'];
        List<Download_Statistics__c> dlList2 = [SELECT Id FROM Download_Statistics__c WHERE Content_Name__c = 'Rexona'];
        List<Download_Statistics__c> dlList3 = [SELECT Id FROM Download_Statistics__c WHERE Content_Name__c = 'Dove'];
        List<Download_Statistics__c> dlList4 = [SELECT Id FROM Download_Statistics__c WHERE Content_Name__c = 'Magnum'];
        List<Download_Statistics__c> dlList5 = [SELECT Id FROM Download_Statistics__c WHERE Content_Name__c = 'Cif'];
        
         // Assert test results
        System.assertEquals(2, numberOfStats);
        System.assertEquals(1, dlList1.size());
        System.assertEquals(1, dlList2.size());
        System.assertEquals(0, dlList3.size());
        System.assertEquals(0, dlList4.size());
        System.assertEquals(0, dlList5.size());
    }
    
    
      /*******************************************************************
    Purpose: Method to test purging statistical records using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void purgeStatsWithDMLDeleteException(){
        // Create test data
        Download_Statistics__c dlstats1 = new Download_Statistics__c();
        dlstats1.Content_Name__c = 'Axe';
        dlstats1.Content_Size__c = 1024;
        dlstats1.Content_Type__c = 'JPEG';
        dlstats1.Timestamp__c = System.now() - 50;
        
        
        List<Download_Statistics__c> dlstatsList = new List<Download_statistics__c>();
        dlstatsList.add(dlstats1);
        
        insert dlstatsList;
        
        // Run the code that we want to test     
        Test.startTest();
        WINatPOSPurgeStats batchPurge = new WINatPOSPurgeStats('Download_Statistics__c', 'Timestamp__c', 30);
        Database.executeBatch(batchPurge, 200);
        Test.stopTest(); 
                
        List<Download_Statistics__c> dlList1 = [SELECT Id FROM Download_Statistics__c];
        
         // Assert test results
        System.assertEquals(0, dlList1.size());
    }
}