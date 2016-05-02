/**********************************************************************
Name: WINatPOSChatterUploadController
Copyright © 2014 Unilever.
======================================================
==========================================================
Purpose: Apex controller to support content upload process
Used in: WINatPOSChatterUpload VisualForce page
==========================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/
public without sharing class WINatPOSChatterUploadController {
      public File__c file {get; set;}
      PageReference pageRef = null;
    
    /*****************************************************************************************
    Purpose: Constructor - Retrieves Asset field in case of a new File record is being created
             If the File record exists, it retrives the fields populated on the record
    Parameters: ApexPages StandardController
    Returns: Void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/   
      public WINatPOSChatterUploadController(ApexPages.StandardController sc) {
        pageRef = ApexPages.currentPage();
        file = (File__c) sc.getRecord();
        // New File record
        if (file.Id == null) {
          System.Debug('***File ID NULL');
          if (file.Asset__c != null) {
            // Set the POS file type
            Asset__c a = [SELECT Id, POS_Asset_Type__c FROM Asset__c WHERE Id = :file.Asset__c];            
            file.POS_File_Type__c = a.POS_Asset_Type__c; 
            } 
        } else {
        // File record already exists
          System.Debug('***File ID Not NULL: '+ file.Id);
          file = [SELECT Id, Name, Asset__c, Brand__c, Category__c, Asset_Group__c, Feed_ID__c, Feed_URL__c,
                      Feed_Thumbnail_URL__c, Type__c, Is_Primary_Image__c, Sub_Type__c, POS_File_Type__c, Sort_Order__c 
                  FROM File__c WHERE Id = :file.Id];                 
        }
    }
    
    /*****************************************************************************************
    Purpose: Links the Chatter post and the uploaded Chatter File to the custom File__c record 
    Parameters: ApexPages StandardController
    Returns: Void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference linkChatterContentPost() {
        System.Debug('linkChatterContentPost invoked');
        // Bugfix: No Chatter File Upload
        List<FeedItem> chatterContentPostList = [SELECT Id FROM FeedItem WHERE ParentId = :file.Id AND Type = 'ContentPost'                                      
                                       ORDER BY CreatedDate DESC LIMIT 1];
                                       
        if ( chatterContentPostList.size() == 0 ) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WinatPOS_Upload_Error_No_Chatter_File)); 
           return null;
        }  
        
        FeedItem chatterContentPost = chatterContentPostList[0];   
        // End of Bugfix: No Chatter File Upload
        
        //FeedItem chatterContentPost = [SELECT Id FROM FeedItem WHERE ParentId = :file.Id AND Type = 'ContentPost'                                      
        //                               ORDER BY CreatedDate DESC LIMIT 1];
        file.Feed_ID__c = chatterContentPost.Id;
        // Store the Download URL and Thumbnail URL on the file record to avoid invoking Connect API for every subsequent file access
        ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Feed_ID__c);      
        ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
        System.Debug('Feed ID: ' + file.Feed_ID__c);
        System.Debug('Feed URL: ' + ca.downloadURL);
        //file.Chatter_File_Id__c = ca.Id;
        file.Feed_URL__c = ca.downloadUrl;
        file.Feed_Thumbnail_URL__c = ca.renditionUrl;
        if (ca.renditionUrl != null) {
            file.Feed_Thumbnail_URL__c = ca.renditionUrl.replace('THUMB120BY90', 'THUMB720BY480');
        }
        file.File_Size_Bytes__c = ( ca.fileSize.equals('unkown') == true ) ? -1 : Integer.valueOf(ca.fileSize);
        
        // Force DML Exception for Update operation
        if ( Test.isRunningTest() ) {
           List<File__c> dummyFileList = [SELECT Id, Name FROM File__c WHERE Name = 'DummyFileForDMLUpdateException' LIMIT 1];
           if ( dummyFileList.size() != 0 ) {
               delete dummyFileList[0];
           }
        }

        try {
            update file;
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));  
          return null;
        }
        
        
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        if (retURL != null) {
            System.Debug('PageReference: ' + retURL);
            //return new PageReference('/' + retURL); 
            return new PageReference(retURL);         
        } else {
            System.Debug('ApexPages StandardController');
            return new ApexPages.StandardController(file).view(); 
        } 
        /*
        return new ApexPages.StandardController(file).view();
        */ 
    }
     
    /*****************************************************************************************
    Purpose: Creates or updates the File__c record 
    Parameters: ApexPages StandardController
    Returns: Void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference saveAndDisplayChatterFeed() { 
       System.Debug('saveEndDisplayChatterFeed invoked');         
       try {      
          // Upsert the existing record
          upsert file;  
       } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage())); return null;
          //return null;
       }  
       System.Debug('PageReference: ' + pageRef);   
       return pageRef;
    }    
}