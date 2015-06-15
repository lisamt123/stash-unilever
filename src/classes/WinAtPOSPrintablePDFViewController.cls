/*===========================================================================
  Name:  WinAtPOSPrintablePDFViewController                                                       
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
   1.0 -  Karol Szepietowski   24/10/2014      INITIAL DEVELOPMENT               
  ===========================================================================*/
public with sharing class WinAtPOSPrintablePDFViewController {
	public Id entityId {get; set;}
    public List<File__c> files {get; set;}
    public List<WINatPOSRemoteActionWrapper.AssetDetailItem> assetDetailList{get;set;}
    private String objectAPIName;
    
    public WinAtPOSPrintablePDFViewController() {      
        
        entityId = ApexPages.currentPage().getParameters().get('id');
        //mode = ApexPages.currentPage().getParameters().get('mode');
        if(entityId != null){
           objectAPIName = entityId.getSObjectType().getDescribe().getName(); 
        }
        retrieveFiles();
                    
    }
    
    /*******************************************************************
	Purpose: Method retrive all related files with asset or asset group
	Parameters: []
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public void retrieveFiles() {
        files = new List<File__c>();
        String q = 'Select Id, Asset__r.Name, Asset__r.Description__c, Feed_ID__c, Feed_URL__c, Asset__r.Brand__r.Name, Asset__r.Channels__c From File__c Where Type__c = \'' + Label.WP_File_Type_Image + '\' And Is_Primary_Image__c = true  And ';
        
        if (objectAPIName.equals('Asset_Group__c')) {
            q = q + 'Asset__r.Asset_Group__c = \'' + entityId + '\' Order By Asset__r.Name ASC';
        }else if (objectAPIName.equals('Asset__c')) {
            q = q + 'Asset__c = \'' + entityId + '\' Order By Asset__r.Name ASC';
        }
        System.debug('q is ' + q);
        for (File__c f : Database.query(q)) {
            try {
                /*
                ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, f.Feed_ID__c);
                ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
                f.Feed_URL__c = ca.downloadUrl;
				*/
                files.add(f); 
				
            } catch (Exception e) {
                system.debug('WinAtPOSPrintablePDFViewController retrieveFiles Exception occured:'+e.getMessage());
            }
        }
        
        //retrive assets for pdf download
        WINatPOSRemoteActionWrapper remWrap= WINatPOSUtilRemoteActions.getAssetDetailData(entityId);
        List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper> detWrapper=(List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper>)remWrap.data;
        assetDetailList=detWrapper.get(0).assetItems;
        for(WINatPOSRemoteActionWrapper.AssetDetailItem assetItem : assetDetailList){
            if(assetItem.primaryImageUrl == null || assetItem.primaryImageUrl == ''){
                assetItem.primaryImageUrl='/resource/1415894165000/winatposapp/images/emptydetail.png';
            }
            assetItem.assetFiles=null;
        }
        
    }
    
    /*******************************************************************
	Purpose: Method add retrived files in pdf to download statistics
	Parameters: []
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public PageReference addFilesToDwonloadStats() {
        System.Debug('*** WINatPOS addFilesToDwonloadStats start processing');
        Map<String,String> filesForDonwloadStats=new Map<String,String>();
        for(File__c f:files){
            //get only files which feedId isn't null
            if(f.Feed_ID__c != null){
                filesForDonwloadStats.put(f.id,f.Feed_ID__c);
            }
        }
        WINatPOSUtilRemoteActions.addRecordsToDonwloadStatistics(filesForDonwloadStats);
        return null;
    }
}