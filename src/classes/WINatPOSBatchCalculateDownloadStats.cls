/**********************************************************************
Name: WINatPOSBatchCalculateDownloadStats
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to calculate File download statistics
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          03/10/2014      INITIAL DEVELOPMENT
**********************************************************************/


global class WINatPOSBatchCalculateDownloadStats implements Database.Batchable<Download_Statistics__c>, Database.Stateful  {
     private DateTime lastDownloadTime, startTime;
     private WinatPOSBatchDownloadStats__c downloadstatsCustomSettings; 
     
     
    /*******************************************************************
    Purpose: Method to generate the list of Download_Statistics to be processed
    Parameters: Void
    Returns: List of Download_Statistics
    Throws [Exceptions]: [optional]
    ********************************************************************/
    
    global Iterable<Download_Statistics__c> start(Database.BatchableContext BC) {
           System.Debug('***Invoke start***');
           String UNIX_EPOCH = '1970-01-01 00:00:00';
           startTime = System.now();
        
           downloadstatsCustomSettings = WinatPOSBatchDownloadStats__c.getValues('DownloadStatsConfig');   
           lastDownloadTime = downloadstatsCustomSettings.Last_Calculated_Download_Stats__c;
           lastDownloadTime = ( lastDownloadTime == null ) ? DateTime.ValueOf(UNIX_EPOCH): lastDownloadTime;
           System.Debug('Last Download Time: ' + lastDownloadTime);
           
           List<Download_Statistics__c> downloadStatsList = [SELECT Id, FileId__c, Timestamp__c FROM Download_Statistics__c WHERE Timestamp__c > : lastDownloadTime];

           return downloadStatsList;

    }
     
     
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to calculate File download stats from Download_Statistics
    Parameters: Database.BatchableContext, list of stats for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
     global void execute(Database.BatchableContext BC, List<Download_Statistics__c> scope){ 
         Map<Id, Integer> downloadsbyFile = new Map<Id, Integer>();
         Map<Id, DateTime> lastDownloadbyFile = new Map<Id, DateTime>();
         
         System.Debug('***Invoke execute***');
         List<Download_Statistics__c> downloadStatsList = new List<Download_Statistics__c>();
         
         for ( Download_Statistics__c ds : scope ) {
             Integer count = downloadsbyFile.get(ds.FileId__c);
             //System.Debug('count: ' + count);
             if ( count == null ) {
                downloadsbyFile.put(ds.FileId__c, 1);
             }
             else {
                downloadsbyFile.put(ds.FileId__c, count + 1);
             }
             
             DateTime downloadTime = lastDownloadbyFile.get(ds.FileId__c);
             //System.Debug('downloadTime: ' + downloadTime);
             //System.Debug('CreatedDate: ' + ds.Timestamp__c); 
             if ( downloadTime == null || downloadTime < ds.Timestamp__c ) {              
                lastDownloadbyFile.put(ds.FileId__c, ds.Timestamp__c);
             }
         }  

         List<File__c> fileList = [SELECT Id, Number_Of_Downloads__c, Last_Download_Time__c FROM File__c WHERE Id IN :downloadsbyFile.keyset()];
         List<File__c> updateFileList = new List<File__c>();

         //System.Debug('filesList size: ' + filesList.size());
 
         for ( File__c file : fileList ) {
              Integer count = Integer.ValueOf(file.Number_Of_Downloads__c);
              count = ( count == null ) ? 0 : count;
              DateTime lastDownloadTime = file.Last_Download_Time__c;
              Integer newDownloads = downloadsbyFile.get(file.Id);
              File__c f = new File__c();
              f.Id = file.Id;
              //System.Debug('***** File__Count : ' + count);
              //System.Debug('***** File__C NewDownloads: ' + newDownloads);
              f.Number_Of_Downloads__c = count + newDownloads;                      
              if ( lastDownloadTime == null || lastDownloadTime < lastDownloadbyFile.get(file.Id) )
              {
                 f.Last_Download_Time__c = lastDownloadbyFile.get(file.Id);
              }

              updateFileList.add(f);
         }
         
         try {
             update updateFileList;
         }
         catch ( Exception e ) {
              System.Debug('Delete File Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
     }
     
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to calculate download statistics
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
     global void finish(Database.BatchableContext BC){
         System.Debug('***Invoke finish***');
         // Update Custom Settings
         downloadstatsCustomSettings.Last_Calculated_Download_Stats__c = startTime;
         try {
             update downloadstatsCustomSettings;
         }
         catch ( Exception e ) {
             System.Debug('Delete File Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
         }
     } 
}