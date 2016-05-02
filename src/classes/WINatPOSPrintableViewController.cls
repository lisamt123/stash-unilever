/*===========================================================================
  Name:  WINatPOSPrintableViewController                                                       
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: Controller for WIN@POS printable view page                                                                  
  -------                                                                    
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Darren Sabey   22/10/2013      INITIAL DEVELOPMENT               
  ===========================================================================*/

public with sharing class WINatPOSPrintableViewController {

    public Id entityId {get; set;}
    public String mode {get; set;}
    public List<File__c> files {get; set;}
    
    private String objectAPIName;
    
    public WINatPOSPrintableViewController() {      
        
        entityId = ApexPages.currentPage().getParameters().get('id');
        mode = ApexPages.currentPage().getParameters().get('mode');
        objectAPIName = entityId.getSObjectType().getDescribe().getName();
        retrieveFiles();
                    
    }
    
    private void retrieveFiles() {
        
        files = new List<File__c>();
        String q = 'Select Id, Asset__r.Name, Asset__r.Description__c, Feed_ID__c, Feed_URL__c, Asset__r.Brand__r.Name, Asset__r.Channels__c From File__c Where Type__c = \'' + Label.WP_File_Type_Image + '\' And Is_Primary_Image__c = true And POS_File_Type__c = \'' + mode + '\' And ';
        
        if (objectAPIName.equals('Asset_Group__c')) {
            q = q + 'Asset__r.Asset_Group__c = \'' + entityId + '\' Order By Asset__r.Name ASC';
        } else if (objectAPIName.equals('Brand_Master__c')) {
            q = q + 'Asset__r.Brand__c = \'' + entityId + '\' Order By Asset__r.Name ASC';  
        } else if (objectAPIName.equals('Asset__c')) {
            q = q + 'Asset__c = \'' + entityId + '\' Order By Asset__r.Name ASC';
        }
        System.debug('q is ' + q);
        for (File__c f : Database.query(q)) {
            try {
                ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, f.Feed_ID__c);
                ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
                f.Feed_URL__c = ca.downloadUrl;
                files.add(f);            
            } catch (Exception e) {}
        }
        
    }
    
}