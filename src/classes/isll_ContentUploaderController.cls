/**********************************************************************
 Name:  isll_ContentUploaderController
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: Gives the ablility to load documents from a custom page                                                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:USLL-182  	
 
***********************************************************************/
public with sharing class isll_ContentUploaderController {
	private final ContentWorkspace cw = [select Name from ContentWorkspace where name = 'Internal Sustainable Living Lab'];
 	
 	 public isll_ContentUploaderController() {
        file = new ContentVersion();
    }
    
	public ContentVersion file { get; set; }
    
	public PageReference upload() {
		boolean errorFound = false;
    	try {
    		//link the content to the library
    		file.FirstPublishLocationId = cw.id;
	    	//insert the content version
	        insert file;
    	}
    	catch (DMLException e) {
    		errorFound = true;
      		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
   	 	} finally {
		  //clear the view state
	      file = new ContentVersion();
    	}
    	if(!errorFound){
	    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));		
    	}
    	
        return null;
        
    }
  
}