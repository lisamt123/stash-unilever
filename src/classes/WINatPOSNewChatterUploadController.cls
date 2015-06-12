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
public without sharing class WINatPOSNewChatterUploadController {
    public File__c file {get; set;}
    PageReference pageRef = null;
    public Boolean isAssetEditable{get;set;}
    public Boolean isAssetTypeEditable{get;set;}
    public Boolean isCategoryEditable{get;set;}
    public Boolean isBrandEditable{get;set;}
    public Boolean isAssetGroupEditable{get;set;}
    public Boolean isPrimaryImageDisabled{get;set;}
    /*****************************************************************************************
    Purpose: Constructor - Retrieves Asset field in case of a new File record is being created
             If the File record exists, it retrives the fields populated on the record
    Parameters: ApexPages StandardController
    Returns: Void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/   
      public WINatPOSNewChatterUploadController(ApexPages.StandardController sc) {
        pageRef = ApexPages.currentPage();
        file = (File__c) sc.getRecord();
        // New File record
        if (file.Id == null) {
            System.Debug('***File ID NULL');
            file.OwnerId=UserInfo.getUserId();
            if (file.Asset__c != null) {
                // Set the POS file type
                Asset__c a = [SELECT Id, POS_Asset_Type__c,Name FROM Asset__c WHERE Id = :file.Asset__c limit 1] ;            
                file.POS_File_Type__c = a.POS_Asset_Type__c; 
                file.Name=a.Name;
            }else if(file.Brand__c != null){
                Brand_Master__c b=[select name from Brand_Master__c where id =: file.Brand__c limit 1];
                //file.Name=b.Name;
                file.POS_File_Type__c='Masterbrand';
            }else if(file.Asset_Group__c != null){
                Asset_Group__c ag=[select name,Type__c from Asset_Group__c where id =: file.Asset_Group__c limit 1];
                file.name=ag.name;
                file.POS_File_Type__c=ag.Type__c;
            }else if(file.Category__c != null){
                Category__c c=[select name from Category__c where id =: file.Category__c limit 1];
                //file.Name=c.Name;
                file.POS_File_Type__c='Masterbrand';
            }
            //always set file type to Download by default while creating file
            file.Type__c=System.Label.WP_File_Type_Download;
            setFieldsAccessibility(file);
        } else {
        // File record already exists
            System.Debug('***File ID Not NULL: '+ file.Id);
            file = [SELECT Id,OwnerId, Name, Asset__c, Brand__c, Category__c, Asset_Group__c, Feed_ID__c, Feed_URL__c,
                    Feed_Thumbnail_URL__c, Type__c, Is_Primary_Image__c, Sub_Type__c, POS_File_Type__c, Sort_Order__c 
                    FROM File__c WHERE Id = :file.Id];
            if(file.Sub_Type__c != null){
                if(file.Sub_Type__c.split(';').size()>0){
                    file.Sub_Type__c=file.Sub_Type__c.split(';').get(0);
                }
            }
            setFieldsAccessibility(file);
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
        List<FeedItem> chatterContentPostList = [SELECT Id FROM FeedItem WHERE ParentId = :file.Id AND Type = 'ContentPost'                                      
                                       ORDER BY CreatedDate DESC LIMIT 1];
                                       
        if ( chatterContentPostList.size() == 0 ) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WinatPOS_Upload_Error_No_Chatter_File)); 
           return null;
        }  
        
        FeedItem chatterContentPost = chatterContentPostList[0];                            
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
        } catch (DmlException ex) {
          ApexPages.addMessages(ex); 
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
          if(!checkIfFileCanBeMarkedAsPrimaryImage(file) || !checkIfFileSubTypeWasSet(file)){
               return null;
           }
           // Upsert the existing record
          upsert file;  
       } catch (DmlException ex) {
          ApexPages.addMessages(ex); return null;
          //return null;
       }  
       System.Debug('PageReference: ' + pageRef);   
       return pageRef;
    }  
    
    /*****************************************************************************************
    Purpose: Creates or updates the File__c record 
    Parameters: ApexPages StandardController
    Returns: Void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference save() { 
       System.Debug('saveEndDisplayChatterFeed invoked');         
       try {      
          // Upsert the existing record
           if(!checkIfFileCanBeMarkedAsPrimaryImage(file) || !checkIfFileSubTypeWasSet(file)){
               system.debug('error message should be added');
               return null;
           }
          upsert file;  
       } catch (DmlException ex) {
          ApexPages.addMessages(ex); return null;
          //return null;
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
    }
    
    /*******************************************************************
    Purpose: Method return list of categries
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getCategories() {
         List<selectOption> options = new List<selectOption>(); 
         
         options.add(new selectOption('', '- None - '));
         for (Category__c cat : [SELECT Id, Name FROM Category__c order by name asc limit 1000]) {
             options.add(new selectOption(cat.Id, cat.Name));
         }
         return options;
    }
    
    /*******************************************************************
    Purpose: Method return  list of brands 
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getBrands() {
         List<selectOption> options = new List<selectOption>();
         
         options.add(new selectOption('', '- None -')); 
         for (Brand_Master__c brand : [SELECT Id, Name FROM Brand_Master__c order by name asc limit 1000]) { 
            options.add(new selectOption(brand.Id, brand.Name)); 
         }
         return options;
    }
    
    /*******************************************************************
    Purpose: Method return  list of Asset Groups 
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getAssetGroups() {
         List<selectOption> options = new List<selectOption>();
         
         options.add(new selectOption('', '- None -')); 
         for (Asset_Group__c assetGroup : [SELECT Id, Name FROM Asset_Group__c order by name asc limit 1000]) { 
            options.add(new selectOption(assetGroup.Id, assetGroup.Name)); 
         }
         return options;
    }
    
    public Boolean checkIfFileCanBeMarkedAsPrimaryImage(File__c f){
        if(f.Asset__c != null && f.Is_Primary_Image__c){
            if([Select Count() from File__c where Asset__c =: f.Asset__c and Is_Primary_Image__c = true and id != :f.id]>=1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WinatPOS_File_Error_primary_image)); 
                return false;
            }
        }
        return true;
    }
    
    public Boolean checkIfFileSubTypeWasSet(File__c f){
        if(f.Sub_Type__c == null || f.Sub_Type__c == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WinatPOS_File_empty_file_type)); 
            return false;
        }
        return true;
    }
    
    /*******************************************************************
    Purpose: Method return  all items from file sub type field 
    Parameters: [optional]
    Returns: List<selectOption>
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public List<selectOption> getFileSubType() {
         List<selectOption> options = new List<selectOption>(); 
         Schema.DescribeFieldResult fieldResultType = File__c.Sub_Type__c.getDescribe();
         options.add(new selectOption('', '- None - '));
         for(Schema.PicklistEntry f : fieldResultType.getPicklistValues()) {
             options.add(new selectOption(f.getValue(), f.getLabel()));
         }
         return options;
    }
    
    /*******************************************************************
    Purpose: Method setting fields to editable or read only 
    Parameters: [optional]
    Returns: 
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public void setFieldsAccessibility(File__c f){
        if(f.Asset__c != null){
            //file alinged to Asset__c object
            this.isAssetEditable=false;
            this.isAssetTypeEditable=false;
            this.isCategoryEditable=false;
            this.isBrandEditable=false;
            this.isAssetGroupEditable=false;
            this.isPrimaryImageDisabled=false;
        }else if(f.Asset_Group__c != null){
            this.isAssetEditable=false;
            this.isAssetTypeEditable=true;
            this.isCategoryEditable=false;
            this.isBrandEditable=false;
            this.isAssetGroupEditable=false;
            this.isPrimaryImageDisabled=false;
        }else if(f.Category__c != null){
            this.isAssetEditable=false;
            this.isAssetTypeEditable=true;
            this.isCategoryEditable=false;
            this.isBrandEditable=false;
            this.isAssetGroupEditable=false;
            this.isPrimaryImageDisabled=true;
        }else if(f.Brand__c != null){
            this.isAssetEditable=false;
            this.isAssetTypeEditable=true;
            this.isCategoryEditable=false;
            this.isBrandEditable=false;
            this.isAssetGroupEditable=false;
            this.isPrimaryImageDisabled=true;
        }else{
            this.isAssetEditable=true;
            this.isAssetTypeEditable=true;
            this.isCategoryEditable=true;
            this.isBrandEditable=true;
            this.isAssetGroupEditable=true;
            this.isPrimaryImageDisabled=true;
        }
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('check url');
        system.debug(retUrl);
        Schema.DescribeSObjectResult r = File__c.sObjectType.getDescribe();
		String fileKeyPrefix = r.getKeyPrefix();
        
        Profile p = [select Name from Profile where id =: UserInfo.getProfileId() limit 1];
        if(p != null && p.Name == 'System Administrator' && retUrl != null && retUrl.contains('/'+fileKeyPrefix+'/o')){
            this.isAssetEditable=true;
            this.isAssetTypeEditable=true;
            this.isCategoryEditable=true;
            this.isBrandEditable=true;
            this.isAssetGroupEditable=true;
        }
    }
    
    /*******************************************************************
    Purpose: Method rerender primary image field 
    Parameters: [optional]
    Returns: 
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public PageReference rerenderFieldAccessiblity(){
        system.debug('method for rerender was called');
        setFieldsAccessibility(this.file);
        return null;
    }
    
}