/**********************************************************************
Name: WINatPOSBatchCalculateDownloadStats_Test
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to test batch Apex methods to calculate File download statistics
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          03/10/2014      INITIAL DEVELOPMENT
**********************************************************************/

@isTest
public class WINatPOSBatchCalculateDownloadStats_Test {
    static testMethod void calculateDownloadStatsWithoutDownloadTime() { 
        // Create test data   
        WinatPOSBatchDownloadStats__c downloadStatsCustomSetting = new WinatPOSBatchDownloadStats__c();
        downloadStatsCustomSetting.Name = 'DownloadStatsConfig';
        downloadStatsCustomSetting.Last_Calculated_Download_Stats__c = null;
        insert downloadStatsCustomSetting;
        
        List<File__c> fileList = new List<File__c>();   
        File__c file1 = new File__c();
        file1.Number_Of_Downloads__c = 3;
        file1.Last_Download_Time__c = null;
        fileList.add(file1);
       
        File__c file2 = new File__c();
        file2.Number_Of_Downloads__c = 0;
        file2.Last_Download_Time__c = null;
        fileList.add(file2);

        insert fileList;
               
        List<Download_Statistics__c> dlStatsList = new List<Download_Statistics__c>();
        Download_Statistics__c dlStats1 = new Download_Statistics__c();
        dlStats1.Content_Name__c = 'Axe';
        dlStats1.Content_Size__c = 1024;
        dlStats1.Content_Type__c = 'JPEG';
        dlStats1.FileId__c = file1.id;
        dlStats1.Timestamp__c = DateTime.ValueOf('2014-10-02 01:00:00');
        dlStats1.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats1);
        
        Download_Statistics__c dlStats2 = new Download_Statistics__c();
        dlStats2.Content_Name__c = 'Axe';
        dlStats2.Content_Size__c = 1024;
        dlStats2.Content_Type__c = 'JPEG';
        dlStats2.FileId__c = file1.id;
        dlStats2.Timestamp__c = DateTime.ValueOf('2014-10-02 01:01:00');
        dlStats2.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats2);
        
        Download_Statistics__c dlStats3 = new Download_Statistics__c();
        dlStats3.Content_Name__c = 'Dove';
        dlStats3.Content_Size__c = 2048;
        dlStats3.Content_Type__c = 'JPEG';
        dlStats3.FileId__c = file2.id;
        dlStats3.Timestamp__c = DateTime.ValueOf('2014-10-02 01:02:00');
        dlStats3.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats3);
        
        insert dlStatsList;

        Test.startTest();
        WINatPOSBatchCalculateDownloadStats batchCalc = new WINatPOSBatchCalculateDownloadStats();
        Database.executeBatch(batchCalc, 200);
        Test.stopTest();
        
        
        List<File__c> fList = [SELECT Id, Number_Of_Downloads__c FROM File__c];
        
        for ( File__c file : fList ) {
            if ( file.id == file1.id ) 
                System.assertEquals(file.Number_Of_Downloads__c, 5);
            else if ( file.id == file2.id ) 
                System.assertEquals(file.Number_Of_Downloads__c, 1);
        }
    }
    
    static testMethod void calculateDownloadStatsWithDownloadTime() { 
          // Create test data   
        WinatPOSBatchDownloadStats__c downloadStatsCustomSetting = new WinatPOSBatchDownloadStats__c();
        downloadStatsCustomSetting.Name = 'DownloadStatsConfig';
        downloadStatsCustomSetting.Last_Calculated_Download_Stats__c = DateTime.ValueOf('2014-10-02 00:00:00');
        insert downloadStatsCustomSetting;
        
        List<File__c> fileList = new List<File__c>();   
        File__c file1 = new File__c();
        file1.Number_Of_Downloads__c = 0;
        file1.Last_Download_Time__c = null;
        fileList.add(file1);
       
        File__c file2 = new File__c();
        file2.Number_Of_Downloads__c = 4;
        file2.Last_Download_Time__c = null;
        fileList.add(file2);

        insert fileList;
               
        List<Download_Statistics__c> dlStatsList = new List<Download_Statistics__c>();
        Download_Statistics__c dlStats1 = new Download_Statistics__c();
        dlStats1.Content_Name__c = 'Axe';
        dlStats1.Content_Size__c = 1024;
        dlStats1.Content_Type__c = 'JPEG';
        dlStats1.FileId__c = file1.id;
        dlStats1.Timestamp__c = DateTime.ValueOf('2014-10-02 01:00:00');
        dlStats1.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats1);
        
        Download_Statistics__c dlStats2 = new Download_Statistics__c();
        dlStats2.Content_Name__c = 'Axe';
        dlStats2.Content_Size__c = 1024;
        dlStats2.Content_Type__c = 'JPEG';
        dlStats2.FileId__c = file1.id;
        dlStats2.Timestamp__c = DateTime.ValueOf('2014-10-02 01:01:00');
        dlStats2.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats2);
        
        Download_Statistics__c dlStats3 = new Download_Statistics__c();
        dlStats3.Content_Name__c = 'Dove';
        dlStats3.Content_Size__c = 2048;
        dlStats3.Content_Type__c = 'JPEG';
        dlStats3.FileId__c = file2.id;
        dlStats3.Timestamp__c = DateTime.ValueOf('2014-10-02 01:02:00');
        dlStats3.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats3);
        
        Download_Statistics__c dlStats4 = new Download_Statistics__c();
        dlStats4.Content_Name__c = 'Dove';
        dlStats4.Content_Size__c = 2048;
        dlStats4.Content_Type__c = 'JPEG';
        dlStats4.FileId__c = file2.id;
        dlStats4.Timestamp__c = DateTime.ValueOf('2014-09-30 01:02:00');
        dlStats4.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats4);
        
        insert dlStatsList;

        Test.startTest();
        WINatPOSBatchCalculateDownloadStats batchCalc = new WINatPOSBatchCalculateDownloadStats();
        Database.executeBatch(batchCalc, 200);
        Test.stopTest();
        
        
        List<File__c> fList = [SELECT Id, Number_Of_Downloads__c FROM File__c];
        
        for ( File__c file : fList ) {
            if ( file.id == file1.id ) 
                System.assertEquals(file.Number_Of_Downloads__c, 2);
            else if ( file.id == file2.id ) 
                System.assertEquals(file.Number_Of_Downloads__c, 5);
        }
    }
    
    static testMethod void calculateDownloadStatsNoFileToUpdateException() { 
          // Create test data   
        WinatPOSBatchDownloadStats__c downloadStatsCustomSetting = new WinatPOSBatchDownloadStats__c();
        downloadStatsCustomSetting.Name = 'DownloadStatsConfig';
        downloadStatsCustomSetting.Last_Calculated_Download_Stats__c = DateTime.ValueOf('2014-10-02 00:00:00');
        insert downloadStatsCustomSetting;
        
        List<File__c> fileList = new List<File__c>();   
        File__c file1 = new File__c();
        file1.Number_Of_Downloads__c = 0;
        file1.Last_Download_Time__c = null;
        fileList.add(file1);

       // insert fileList;
               
        List<Download_Statistics__c> dlStatsList = new List<Download_Statistics__c>();
        Download_Statistics__c dlStats1 = new Download_Statistics__c();
        dlStats1.Content_Name__c = 'Axe';
        dlStats1.Content_Size__c = 1024;
        dlStats1.Content_Type__c = 'JPEG';
        dlStats1.FileId__c = null;
        dlStats1.Timestamp__c = DateTime.ValueOf('2014-10-02 01:00:00');
        dlStats1.Downloaded_By__c = UserInfo.getUserId();
        dlStatsList.add(dlStats1);
           
        insert dlStatsList;

        Test.startTest();
        WINatPOSBatchCalculateDownloadStats batchCalc = new WINatPOSBatchCalculateDownloadStats();
        Database.executeBatch(batchCalc, 200);
        Test.stopTest();
              
        List<File__c> fList = [SELECT Id, Number_Of_Downloads__c FROM File__c];
        System.assertEquals(fList.size(), 0);
    }
}