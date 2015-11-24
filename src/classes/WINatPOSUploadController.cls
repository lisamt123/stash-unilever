/*===========================================================================
  Name:  WINatPOSUploadController                                                       
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: Controller for WINatPOSUpload page                                                                  
  -------                                                                    
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Darren Sabey   22/10/2013      INITIAL DEVELOPMENT               
  ===========================================================================*/

public with sharing class WINatPOSUploadController {

    public File__c f {get; set;}
    public Document d {get; set;}
    
    public WINatPOSUploadController(ApexPages.StandardController sc) {
        f = (File__c) sc.getRecord();
        if (f.Id == null) {
        	if (f.Asset__c != null) {
        		// Set the POS file type
        		Asset__c a = [Select Id, POS_Asset_Type__c
        		              From Asset__c 
        		              Where Id = :f.Asset__c];
                f.POS_File_Type__c = a.POS_Asset_Type__c; 
            } 
        } else {
        	f = [Select Id, Name, Asset__c, Brand__c, Category__c, Asset_Group__c, Feed_ID__c, Feed_URL__c,
        	            Feed_Thumbnail_URL__c, Type__c, Is_Primary_Image__c, Sub_Type__c, POS_File_Type__c, Sort_Order__c 
        	     From File__c 
        	     Where Id = :f.Id];
        }
        d = new Document();
    }
    
    public PageReference saveAndUpload() {
    	
    	// Start transaction control
        Savepoint sp = Database.setSavepoint();
    	    
    	try {
    		
    		// Upsert the existing record
    		upsert f;
            
            if (d.Name != null && d.Body != null) {
                // Create the Chatter feed items and link to the file record
            	FeedItem post = new FeedItem();
                post.ParentId = f.Id; 
                post.Body = d.Name;
                post.ContentData = d.Body;
                post.ContentFileName = d.Name;
                post.Title = d.Name;
                insert post;
            
                // Link the file record to the Chatter feed item
                f.Feed_ID__c = post.Id;
                upsert f;            
            }
    	} catch (Exception e) {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        	// Rollback any changes
            Database.rollback(sp);
            // Remove the file record id from the sobject 
            f = f.clone(false, true, true, true);
            // Clear the viewstate
            d.Body = null;
            d = new Document();
    		return null;
    	} finally {
    		// Clear the viewstate
            d.body = null; 
            d = new Document();
        }
        
        // Navigate user to the asset record
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        if (retURL != null) {
            return new PageReference(retURL);        	
        } else {
            return new ApexPages.StandardController(f).view(); 
        }        
    }
    
}