/**********************************************************************
Name: WINatPOS_TH_DeleteChatterFile
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to handle trigger before delete on File__c,
it  will delete the Chatter File and Post associated with the File__c record
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           17/09/2014     INITIAL DEVELOPMENT
***********************************************************************/
public class WINatPOS_TH_DeleteChatterFile {
    /*******************************************************************
    Purpose: Processing file records being deleted, 
             in order to delete the corresponding Chatter File and Post.
    Parameters: List of File__c
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public void processDeleteChatterFile(List<File__c> files){
         System.Debug('processDeleteChatterFile invoked.');       
         List<FeedItem> deleteFeedItemList = new List<FeedItem>();
         List<ContentDocument> deleteContentDocumentList = new List<ContentDocument>();
         
         //System.Debug('processDeleteChatterFile BEFORE FOR File size: ' + files.size());
          
         for (File__c file: files) {
             //System.Debug('processDeleteChatterFile BEFORE IF FEED ID: ' + file.Feed_ID__c); 
             if ( file.Feed_ID__c != null ) {
                FeedItem feedItem = new FeedItem();
                feedItem.Id = file.Feed_ID__c;
                System.Debug('feedItem Id: ' + feedItem.Id);
                deleteFeedItemList.add(feedItem);
         

                ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Feed_ID__c);                   
                if ( fi != null ) {
                    System.Debug('fi Id: ' + fi.Id);
                    ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;                              
                    if ( ca != null ) {
                       System.Debug('ca Id: ' + ca.Id);
                       ContentDocument contentDocument = new ContentDocument();
                       contentDocument.Id = ca.Id;
                       deleteContentDocumentList.add(contentDocument);
                    }
                }
              }
         }
                 
        // Force DML Exception for Delete operation
        if ( Test.isRunningTest() ) {
           List<File__c> dummyFileList = [SELECT Id FROM File__c WHERE Name = 'DummyFileForDMLDeleteExceptionTest' LIMIT 1];
           if ( dummyFileList.size() != 0 ) {
               List<FeedItem> dummyFeedItemList = [SELECT Id, Title FROM FeedItem WHERE ParentId = :dummyFileList[0].Id LIMIT 1];
               if ( dummyFeedItemList.size() != 0 ) {
                   delete dummyFeedItemList[0];
                   deleteFeedItemList.add(dummyFeedItemList[0]);
               }
           }
         }
         
         try {        
           if (deleteFeedItemList.size() > 0)
               delete deleteFeedItemList;
           if (deleteContentDocumentList.size() > 0)
               delete deleteContentDocumentList;
         }
         catch ( Exception e ) {
              System.Debug('Delete Generic Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
         }
               
         //try {
         //  if (deleteContentDocumentList.size() > 0)
         //      delete deleteContentDocumentList;
         //}
         //catch ( Exception e ) {
         //     System.Debug('Delete Generic Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
         //}
  
    }
}