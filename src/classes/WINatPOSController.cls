/*===========================================================================
  Name:  WINatPOSController                                                       
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: Controller for WIN@POS application                                                                  
  -------                                                                    
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Darren Sabey   22/10/2013      INITIAL DEVELOPMENT               
  ===========================================================================*/

public with sharing class WINatPOSController {
    
    public String page {get; set;}
    public String mode {get; set;}
    public Category__c cat {get; set;}
    public Brand_Master__c brand {get; set;}
    public String chatterEntityId  {get; set;}
    
    private static String APPROVED = 'Approved';
    private static String HIDDEN = 'hidden';
    private static String VISIBLE = 'visible';
    private static String ARTWORK = 'Artwork';
    private static String PRESENTATION = 'Presentation';
    private static String PROD_ENGINEERING = 'Production Engineering';
    private static String DOWNLOAD_IMG = 'Download Image';
    
    private static List<File__c> filesToUpdate = new List<File__c>();
        
    public WINatPOSController () {
        PageReference p = ApexPages.currentPage();
        if (p.getUrl().toLowerCase().contains(Label.WP_Masterbrand_Page.toLowerCase())) {
            page = Label.WP_Masterbrand_Page;
            mode = Label.WP_Masterbrand_Mode;
        } else if (p.getUrl().toLowerCase().contains(Label.WP_Innovations_Page.toLowerCase())) {
            page = Label.WP_Innovations_Page;
            mode = Label.WP_Innovations_Mode;
        } else if (p.getUrl().toLowerCase().contains(Label.WP_In_Store_Executions_Page.toLowerCase())) {
            page = Label.WP_In_Store_Executions_Page;
            mode = Label.WP_In_Store_Executions_Mode;
        } else if (p.getUrl().toLowerCase().contains(Label.WP_Repeatable_Models_Page.toLowerCase())) {
            page = Label.WP_Repeatable_Models_Page;
            mode = Label.WP_Repeatable_Models_Mode;
        }
        
        try {
            uw_BET__c bet = [Select uw_Brand__r.Name, Category_Level_2__c From uw_BET__c Where Id = :p.getParameters().get('betId')];
            cat = [Select Name From Category__c Where Name = :bet.Category_Level_2__c];
            brand = [Select Name From Brand_Master__c Where Name = :bet.uw_Brand__r.Name];
        } catch (Exception e) {
            cat = new Category__c(Name=Label.WP_Select_Category);
            brand = new Brand_Master__c(Name=Label.WP_Select_Brand);
        }
        chatterEntityId = UserInfo.getUserId();     
    }
   
    public PageReference updateChatterEntityId() {
        return null;        
    }

    @RemoteAction
    public static void upsertAppUsage() {
        Database.upsert(new Application_Usage__c(Unique_ID__c=UserInfo.getUserId()+'WIN@POS',User__c=UserInfo.getUserId(),Name=UserInfo.getUserName()+' - WIN@POS',Application__c='WIN@POS',Accessed__c=true,Last_Accessed_Date__c=System.now()), Application_Usage__c.Unique_ID__c);
    }
    
    @RemoteAction
    public static ChannelAndCategoryResult getChannelsAndCategories() //Need to define as a remote action as we will be calling this through javascript
    {
        List<Category__c> categories = new List<Category__c>();
        for (Category__c cat : [Select Id, Name, Parent_Category_Name__c From Category__c Order By Sort_Order__c ASC]) {
            categories.add(cat);
        }
            
        List<String> modernChannels = new List<String>();
        Schema.DescribeFieldResult fieldResult = Asset__c.Modern_Channels__c.getDescribe();
        for(Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            modernChannels.add(f.getValue());
        }       
        
        List<String> traditionalChannels = new List<String>();
        fieldResult = Asset__c.Traditional_Channels__c.getDescribe();
        for(Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            traditionalChannels.add(f.getValue());
        }
        
        return new ChannelAndCategoryResult(categories, modernChannels, traditionalChannels);
    }

    @RemoteAction
    public static Map<Id, Brand_Master__c> retrieveBrandsForCategory(String catId) //Need to define as a remote action as we will be calling this through javascript
    {
        Map<Id, Brand_Master__c> brands = new Map<Id, Brand_Master__c>();
        for (Category_Brands__c cb : [Select Brand__c, Brand__r.Name From Category_Brands__c Where Category__c = :catId]) {
            if (! brands.keyset().contains(cb.Brand__c)) {
                brands.put(cb.Brand__c, new Brand_Master__c(id=cb.Brand__c,Name=cb.Brand__r.Name));    
            }                        
        }
        return brands;
    }
    
    @RemoteAction
    public static AssetGroupResult retrieveAssetGroups(String brandId, String mode) //Need to define as a remote action as we will be calling this through javascript
    {
        List<Asset_Group__c> assetGroupList = new List<Asset_Group__c>();
        Set<String> clusters = new Set<String>();
        for (Asset_Group__c ag : [Select Id, Name, Description__c, Market_Cluster__c 
                                  From Asset_Group__c 
                                  Where Brand__c = :brandId 
                                  And Type__c = :mode
                                  Order By Name ASC]) {
            assetGroupList.add (ag);
            if (ag.Market_Cluster__c != null) {
                clusters.add(ag.Market_Cluster__c);
            }
        }
        return new AssetGroupResult(assetGroupList, clusters);
    }
            
    @RemoteAction
    public static AssetResult retrieveAssets(String assetGroupId, String categoryId, String brandId, String mode) //Need to define as a remote action as we will be calling this through javascript
    {
        List<WINatPOSAsset> assetList = new List<WINatPOSAsset>();
        List<Asset__c> assets;
        Set<String> placements = new Set<String>();
        Set<String> clusters = new Set<String>();
        
        // First retrieve the assets and their files, based on the params passed in (asset group id or brand)
        if (assetGroupId != null) {
            assets = [Select Id, Name, Category__c, Category__r.Name, Brand__c, Brand__r.Name, Channels__c, Description__c, Placement__c, Market_Cluster__c, BET__c, BET__r.Name, 
                             (Select Id, Name, Category__c, Category__r.Name, Type__c, Sub_Type__c, File_Button_Text__c, Is_Primary_Image__c, Feed_ID__c, Feed_URL__c 
                              From Files__r 
                              Order By Sort_Order__c ASC)
                      From Asset__c 
                      Where POS_Asset_Type__c = :mode
                      And Status__c = :APPROVED
                      And Asset_Group__c = :assetGroupId 
                      Order By Name ASC];
        } else {
            assets = [Select Id, Name, Category__c, Category__r.Name, Brand__c, Brand__r.Name, Channels__c, Description__c, Placement__c, Market_Cluster__c, BET__c, BET__r.Name, 
                             (Select Id, Name, Category__c, Category__r.Name, Type__c, Sub_Type__c, File_Button_Text__c, Is_Primary_Image__c, Feed_ID__c, Feed_URL__c 
                              From Files__r 
                              Order By Sort_Order__c ASC)
                      From Asset__c 
                      Where POS_Asset_Type__c = :mode
                      And Status__c = :APPROVED
                      And Category__c = :categoryId 
                      And (Brand__c = :brandId
                      Or Brand__c = null)
                      Order By Name ASC];
        }                           
        
        // Next iterate through the assets and set the flags used by the UI to render the asset and file "buttons"
        for (Asset__c a : assets) {
            String primaryImageURL = '', downloadURL = '', aURL = '', pURL = '', peURL = '', diURL = '';
            List<File__c> files = new List<File__c>();            
            for (File__c f : a.Files__r) {
            	if (f.Feed_URL__c == null) {
            		if (! cacheFeedURL(f)) continue; // Try to cache the download Url to optimize performance                    
            	}          
            	
            	// Try to set the primary image for the asset
                if ((f.Type__c != null) && (f.Type__c.equals(Label.WP_File_Type_Image))) {
                    if (f.Is_Primary_Image__c) {
                        primaryImageURL = f.Feed_URL__c;
                    }
                }
                
                // Set the icons for the file panel - can only be one
                f.Show_Artwork__c = HIDDEN;  
                f.Show_Presentation__c = HIDDEN;
                f.Show_Production_Engineering__c = HIDDEN;
                f.Show_Download_Image__c = HIDDEN;       
                if (f.Sub_Type__c != null) {
                    if (f.Sub_Type__c.contains(ARTWORK)) {
                    	// File is sub type artwork
                        f.Show_Artwork__c = VISIBLE; 
                        // Asset should enable artwork download from results page
                        aURL = f.Feed_URL__c;
                    } else if (f.Sub_Type__c.contains(PRESENTATION)) {
                    	// File is sub type presentation
                        f.Show_Presentation__c = VISIBLE;
                        // Asset should enable presentation download from results page
                        pURL = f.Feed_URL__c;
                    } else if (f.Sub_Type__c.contains(PROD_ENGINEERING)) {
                    	// File is sub type production engineering
                        f.Show_Production_Engineering__c = VISIBLE;
                        // Asset should enable production engineering download from results page
                        peURL = f.Feed_URL__c;
                    } else if (f.Sub_Type__c.contains(DOWNLOAD_IMG)) {
                    	// File is sub type download image
                        f.Show_Download_Image__c = VISIBLE;
                        // Asset should enable display image download from results page
                        diURL = f.Feed_URL__c;
                    }                   
                }                
            }
            files.addAll(a.Files__r);
            files.add(new File__c(Name=Label.WP_Download_Item_Text,Feed_URL__c=Page.WINatPOSPrintableView.getUrl()+'?id='+a.Id,Type__c=Label.WP_File_Type_Generated,Show_Artwork__c=HIDDEN,Show_Presentation__c=HIDDEN,Show_Production_Engineering__c=HIDDEN,Show_Download_Image__c=VISIBLE));
            // The asset will only appear in the list if we have a primary image URL
            if (primaryImageURL != '') {
                placements.add(a.Placement__c);
                clusters.add(a.Market_Cluster__c);
                assetList.add(new WINatPOSAsset(a, files, primaryImageURL, aURL, pURL, peURL, diURL));
            }
        }
        // Retrieving files for asset group or brand - not category
        List<File__c> downloadFiles = retrieveFiles(assetGroupId, null, brandId, null, mode);
        
        // Update any files for which we set the Feed URL
        if (! filesToUpdate.isEmpty()) Database.update(filesToUpdate);
        
        // Return the assets, files, placements and clusters
        return new AssetResult(assetList, downloadFiles, placements, clusters);
    }
    
    @RemoteAction
    public static List<File__c> retrieveFiles(String assetGroupId, String categoryId, String brandId, String assetId, String mode) //Need to define as a remote action as we will be calling this through javascript
    {
        // Method will be called as remote action to retrieve category level files. Called from controller to retrieve asset group and/or brand level files     
        List<File__c> fileList = new List<File__c>();
        List<File__c> files;
        
        if (assetGroupId != null) {
            files = [Select Id, Name, Category__c, Category__r.Name, Feed_ID__c, Feed_URL__c, Feed_Thumbnail_URL__c, Is_Primary_Image__c, Type__c, Sub_Type__c, File_Button_Text__c
                     From File__c
                     Where (Asset_Group__c = :assetGroupId Or (Brand__c != null And Brand__c = :brandId)) 
                     And Asset__c = null
                     And POS_File_Type__c = :mode
                     Order By Sort_Order__c ASC];
        } else {
            files = [Select Id, Name, Category__c, Category__r.Name, Feed_ID__c, Feed_URL__c, Feed_Thumbnail_URL__c, Is_Primary_Image__c, Type__c, Sub_Type__c, File_Button_Text__c
                     From File__c
                     Where Category__c = :categoryId
                     And Brand__c = :brandId 
                     And Asset__c = null
                     And POS_File_Type__c = :mode
                     Order By Sort_Order__c ASC];
        }
        for (File__c f : files) { 
            if (f.Feed_URL__c == null) {
                if (! cacheFeedURL(f)) continue; // Try to cache the download Url to optimize performance                    
            }          
		    if (f.Sub_Type__c != null) {
                if (f.Sub_Type__c.contains(ARTWORK)) 
                    f.Show_Artwork__c = VISIBLE; else f.Show_Artwork__c = HIDDEN;
                if (f.Sub_Type__c.contains(PRESENTATION)) 
                    f.Show_Presentation__c = VISIBLE; else f.Show_Presentation__c = HIDDEN;
                if (f.Sub_Type__c.contains(PROD_ENGINEERING)) 
                    f.Show_Production_Engineering__c = VISIBLE; else f.Show_Production_Engineering__c = HIDDEN;
                if (f.Sub_Type__c.contains(DOWNLOAD_IMG)) 
                    f.Show_Download_Image__c = VISIBLE; else f.Show_Download_Image__c = HIDDEN;                 
            }
            fileList.add (f);
        }
        
        if (assetGroupId != null) {
            fileList.add(new File__c(Name=Label.WP_Download_Range_Text,Feed_URL__c=Page.WINatPOSPrintableView.getUrl()+'?id='+assetGroupId,Type__c=Label.WP_File_Type_Generated,Show_Artwork__c=HIDDEN,Show_Presentation__c=HIDDEN,Show_Production_Engineering__c=HIDDEN,Show_Download_Image__c=VISIBLE));
        } else if (brandId != null) {
            fileList.add(new File__c(Name=Label.WP_Download_Range_Text,Feed_URL__c=Page.WINatPOSPrintableView.getUrl()+'?id='+brandId,Type__c=Label.WP_File_Type_Generated,Show_Artwork__c=HIDDEN,Show_Presentation__c=HIDDEN,Show_Production_Engineering__c=HIDDEN,Show_Download_Image__c=VISIBLE));
        }
        
        // Update any files for which we set the Feed URL
        if (! filesToUpdate.isEmpty()) Database.update(filesToUpdate);
        
        // Return the list of files
        return fileList;
    }
    
    // Store the download URL on the file record to avoid querying the API for every file access event
    private static Boolean cacheFeedURL(File__c f) {
    	try {
            ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, f.Feed_ID__c);
            ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
            f.Feed_URL__c = ca.downloadUrl;
            if (ca.renditionUrl != null) {
                f.Feed_Thumbnail_URL__c = ca.renditionUrl.replace('THUMB120BY90', 'THUMB720BY480');
            }
            filesToUpdate.add(f);
        } catch (Exception e) {
            return false;
        }    	
        return true;
    }
 
    public class ChannelAndCategoryResult {
        public List<Category__c> categories {get; set;}
        public List<String> modernChannels {get; set;}
        public List<String> traditionalChannels {get; set;}
        public ChannelAndCategoryResult(List<Category__c> c, List<String> mc, List<String> tc) {
            this.categories = c;
            this.modernChannels = mc;
            this.traditionalChannels = tc;
        }
    }
    
    public class AssetGroupResult {
        public List<Asset_Group__c> assetGroups {get; set;}
        public Set<String> clusters {get; set;}
        public AssetGroupResult(List<Asset_Group__c> assetGroups, Set<String> clusters) {
            this.assetGroups = assetGroups;
            this.clusters = clusters;
        }
    }
    
    public class AssetResult {
        public List<WINatPOSAsset> assets {get; set;}
        public List<File__c> files {get; set;}
        public Set<String> placements {get; set;}
        public Set<String> clusters {get; set;}
        public AssetResult(List<WINatPOSAsset> assets, List<File__c> files, Set<String> placements, Set<String> clusters) {
            this.assets = assets;
            this.files = files;
            this.placements = placements;
            this.clusters = clusters;
        }
    }
    
    public class WINatPOSAsset {
        public Asset__c sobj {get; set;}
        public List<File__c> files {get; set;}
        public String feedURL {get; set;}
        public String showArtwork {get; set;}
        public String showPresentation {get; set;}
        public String showProductionEngineering {get; set;}
        public String showDownloadImage {get; set;}
        public String artworkURL {get; set;}
        public String presentationURL {get; set;}
        public String productionEngineeringURL {get; set;}
        public String downloadImageURL {get; set;}
            
        public WINatPOSAsset(Asset__c a, List<File__c> files, String url, String aURL, String pURL, String peURL, String diURL) {
            this.sobj = a;
            this.files = files;
            this.feedURL = url;
            this.artworkURL = aURL;
            this.presentationURL = pURL;
            this.productionEngineeringURL = peURL;
            this.downloadImageURL = diURL;          
        }
        
    }
  
}