public class isll_CarouselController
{
    ApexPages.StandardController x_stdCtrl;
    
    public Attachment mediaAttachment {
	  get {
	      if (mediaAttachment == null)
	        mediaAttachment = new Attachment();
	      return mediaAttachment;
	    }
	  set;
  	}
  	
  	
  	public Attachment thumbnailAttachment {
	  get {
	      if (thumbnailAttachment == null)
	        thumbnailAttachment = new Attachment();
	      return thumbnailAttachment;
	    }
	  set;
  	}
  	
  	private ContentWorkspace workspace;
    
    // Empty constructor
    public isll_CarouselController()
    {
        
    }
    
    // Constructor with standard controller
    public isll_CarouselController(ApexPages.StandardController p_stdCtrl)
    {
        x_stdCtrl = p_stdCtrl;
        a_carouselId = p_stdCtrl.getId();
        
        List<ContentWorkspace>  wsList= [select Name from ContentWorkspace where name = 'Internal Sustainable Living Lab' Limit 1];
        if(null != wsList && wsList.size() == 1){
        	workspace = wsList[0];   
            
        }
    }
    
    // Url information of the origin page.
    public String a_prevPage
    {
        get
        {
            if(a_prevPage == null)
            {
                a_prevPage = '';
                
                String tmp_prevPage = ApexPages.currentPage().getParameters().get('retURL');
                
                if(tmp_prevPage != null)
                {
                    a_prevPage = tmp_prevPage;
                }
            }
            
            return a_prevPage;
        }
        
        set;
    }
    
    // Mode for the layout. (view or edit)
    public String a_mode
    {
        get
        {
            if(a_mode == null)
            {
                a_mode = 'view';
            }
            
            return a_mode;
        }
        
        set;
    }
    
    /* Carousel information <[ */
    // 
    public String a_carouselId
    {
        get
        {
            if(a_carouselId == null)
            {
                a_carouselId = '';
                
                if(a_carousel != null && a_carousel.Id != null)
                {
                    a_carouselId = a_carousel.Id;
                }
            }
            
            return a_carouselId;
        }
        set;
    }
    
    // 
    public String a_carouselName
    {
        get
        {
            if(a_carouselName == null)
            {
                a_carouselName = '';
            }
            
            if(a_carousel != null && a_carousel.Id != null)
            {
                a_carouselName = a_carousel.Name;
            }
            
            return a_carouselName;
        }
        
        set;
    }
    
    // The carousel record.
    public Carousel__c a_carousel
    {
        get
        {
            if(a_carousel == null)
            {
                a_carousel = new Carousel__c();
                
                if(a_carouselId != '')
                {
                    a_carousel = [SELECT Id, Name, RotateSpeed__c FROM Carousel__c WHERE Id =: a_carouselId Limit 1];
                }
                else if(a_carouselName != '')
                {
                    a_carousel = [SELECT Id, Name, RotateSpeed__c FROM Carousel__c WHERE Name =: a_carouselName Limit 1];
                }
            }
            
            return a_carousel;
        }
        
        set;
    }
    
    /* ]> Carousel information */
    
    /* Elements (image/video) <[ */
    // Map with the collection of elements in relation to the elements list.
    public Map<Id, CMS_Content__c> a_elementMap
    {
        get
        {
            if(a_elementMap == null)
            {
                a_elementMap = new Map<Id, CMS_Content__c>();
            }
            
            return a_elementMap;
        }
        
        set;
    }
    
    // List of elements.
    public CMS_Content__c[] a_elements
    {
        get
        {
            a_elements = new CMS_Content__c[]{};
            a_elementMap = new Map<Id, CMS_Content__c>();
            
            for(CMS_ContentToCarousel__c tmp_contentToCarousel : [SELECT Id, Order__c, CMS_Content__c, CMS_Content__r.Id, CMS_Content__r.Name, CMS_Content__r.Content__c, 
            															CMS_Content__r.ThumbnailLink__c, CMS_Content__r.MediaType__c, CMS_Content__r.MediaDescription__c, 
            															CMS_Content__r.Link__c, CMS_Content__r.ThumbnailText__c 
            													FROM CMS_ContentToCarousel__c 
            													WHERE Carousel__r.Name =: a_carouselName AND CMS_Content__c != null ORDER BY Order__c, CreatedDate
            													LIMIT :isll_Utility.notArchivedNewsAmount])
            {
                a_elements.add(tmp_contentToCarousel.CMS_Content__r);
                a_elementMap.put(tmp_contentToCarousel.CMS_Content__c, tmp_contentToCarousel.CMS_Content__r);
            }
            
            return a_elements;
        }
        
        set;
    }
    
    /* ]> Elements (image/video) */
    // Size information for vf page/component rendering.
    public Integer a_elementsSize
    {
        get
        {
            return a_elements.size();
        }
    }
    
    /* Image/video information <[ */
    // Id of the currently relevant image/video to edit or delete.
    public Id a_contentId
    {
        get;
        set;
    }
    
    // The image/video record.
    public CMS_Content__c a_content
    {
        get
        {
            if(a_content == null)
            {
                a_content = new CMS_Content__c();
            }
            
            return a_content;
        }
        
        set;
    }
    
    /* ]> Image/video information */
    
    private Map<Id, isll_LibraryController.ContentVersionWrapper> contentDocsMap {get; set;}
    
    public List<isll_LibraryController.ContentVersionWrapper> contentDocs{
    	get{
    		//get the workspace docs
            List<Id> contentDocumentIDs = new List<Id>();
            for(ContentWorkspaceDoc cwd : [Select ContentDocumentId 
                                            From ContentWorkspaceDoc 
                                            Where ContentWorkspaceId = :workspace.id ]){
                contentDocumentIDs.add(cwd.ContentDocumentId);
            }
            
            //get id of documents already used
            Set<Id> cvIds = new Set<Id>();
            for(CMS_ContentToCarousel__c ctc : [SELECT Id, CMS_Content__r.Content__c FROM CMS_ContentToCarousel__c WHERE Carousel__r.Name =: a_carouselName AND CMS_Content__c != null AND CMS_Content__r.MediaType__c = 'Document'])
            {
                cvIds.add(ctc.CMS_Content__r.Content__c);
            }
            
            contentDocsMap = new Map<Id, isll_LibraryController.ContentVersionWrapper>();
            contentDocs = new List<isll_LibraryController.ContentVersionWrapper>();
            for(ContentVersion cv : [Select id, Title, Description, FileType, ContentDocumentId, ContentModifiedDate, CreatedDate
                                                        From ContentVersion 
                                                        Where ContentDocumentId IN :contentDocumentIDs And Id NOT IN : cvIds
                                                        ORDER BY Title ASC]){
            	isll_LibraryController.ContentVersionWrapper doc = new isll_LibraryController.ContentVersionWrapper(false, cv, 0);
            	contentDocs.add(doc);
            	contentDocsMap.put(cv.Id, doc);
            }
            return contentDocs;
    	}
    	
    	set;
    }
    
    // Back button method to redirect the user to the previous page.
    // If no previous page set, it will redirect to the sfdc home page.
    public PageReference GoBack()
    {
        x_stdCtrl.save();
        
        PageReference tmp_pageRef = new PageReference('/home/home.jsp');
        
        if(a_prevPage != null && a_prevPage != '')
        {
            tmp_pageRef = new PageReference(EncodingUtil.urlDecode(a_prevPage, 'UTF-8'));
        }
        
        return tmp_pageRef;
    }
    
    public PageReference DoNext(){
    	
    	if(a_content.MediaType__c == 'Document'){
    		a_mode = 'edit-3';
    	} else {
    		a_mode = 'edit-2';
    	}
    	
    	return null;
    }
    
    // Save button method to insert or update a (new) record.
    public PageReference DoSave()
    {
        a_mode = 'view';
        
        upsert a_content;
        
        boolean hasMediaAttached = false;
        boolean hasThumbnailAttached = false;
        List<Attachment> attachmentsToInsert = new List<Attachment>();
        List<Attachment> attachmentsToDelete = new List<Attachment>();
        
        List<Attachment> currentAttachments = [select id, ParentId, description from Attachment where ParentId = : a_content.id];
        system.debug('current attachments: '+currentAttachments);
         
        //check if there is any thumbnail or media attachment
        system.debug('mediaAttachment: '+mediaAttachment);
        if(null != mediaAttachment && String.isNotBlank(mediaAttachment.name)){
        	if(mediaAttachment.ParentId == null){
        		mediaAttachment.ParentId = a_content.id;
        	}
        	mediaAttachment.Description = 'media source';
        	attachmentsToInsert.add(mediaAttachment);
        	hasMediaAttached = true;
        	//delete old media source attachment if one exsists
        	for(Attachment attachment : currentAttachments){
        		if(attachment.Description == 'media source'){
        			attachmentsToDelete.add(attachment);
        			break;
        		}
        	}
        }
		   system.debug('thumbnailAttachment: '+thumbnailAttachment);
		if(null != thumbnailAttachment && String.isNotBlank(thumbnailAttachment.name)){
			if(thumbnailAttachment.ParentId == null){
				thumbnailAttachment.ParentId = a_content.id;
			}
			thumbnailAttachment.Description = 'thumbnail';
			attachmentsToInsert.add(thumbnailAttachment);
			hasThumbnailAttached = true;
			//delete old media source attachment if one exsists
        	for(Attachment attachment : currentAttachments){
        		if(attachment.Description == 'thumbnail'){
        			attachmentsToDelete.add(attachment);
        			break;
        		}
        	}
		}
		
		insert attachmentsToInsert;
		delete attachmentsToDelete;
        
        if(hasMediaAttached){
	        a_content.Content__c = '/servlet/servlet.FileDownload?file='+mediaAttachment.Id;
        }
        
        if(hasThumbnailAttached){
	       a_content.ThumbnailLink__c = '/servlet/servlet.FileDownload?file='+thumbnailAttachment.Id;
        }

                
       	upsert a_content;
        if(a_contentId == null)
        {
            CMS_ContentToCarousel__c tmp_contentToCarousel = new CMS_ContentToCarousel__c(Carousel__c = a_carouselId, CMS_Content__c = a_content.Id);
            
            insert tmp_contentToCarousel;
        }
        
        a_elementMap = null;
        a_contentId = null;
        
        thumbnailAttachment = new Attachment();
        mediaAttachment = new Attachment();
        return null;
    }
    
  //  public String cvId {get; set;}
    public PageReference DoAddDocument(){
    	a_mode = 'view';
    	
    	String cvId = Apexpages.currentPage().getParameters().get('cvid');
    	system.debug('cvId--->>>'+cvId);
    	ContentVersion cv = [Select id, Title, Description, FileType, ContentDocumentId, ContentModifiedDate, CreatedDate
                                                        From ContentVersion 
                                                        Where Id = :cvId];
    	isll_LibraryController.ContentVersionWrapper doc = new isll_LibraryController.ContentVersionWrapper(false, cv, 0);
    	a_content.Content__c = cvId;
    	a_content.ThumbnailLink__c = '/sfc/images/docicons/' + doc.fileTypeStyle + '.png';
    	a_content.ThumbnailText__c = cv.Title;
    	a_content.MediaDescription__c = cv.Title;
    	upsert a_content;
    	if(a_contentId == null)
        {
            CMS_ContentToCarousel__c tmp_contentToCarousel = new CMS_ContentToCarousel__c(Carousel__c = a_carouselId, CMS_Content__c = a_content.Id);
            
            insert tmp_contentToCarousel;
        }
    	
    	return null;
    }
    
    // Edit (or add!) a new image/video.
    public PageReference DoEdit()
    {
        a_mode = 'edit-1';
        
        a_content = null;
        
        if(a_contentId != null)
        {
            a_content = a_elementMap.get(a_contentId);
        }
        
        return null;
    }
    
    // 
    public PageReference DoCancel()
    {
        a_mode = 'view';
        
        a_contentId = null;
        
        return null;
    }
    
    // 
    public PageReference DoDelete()
    {
        if(a_contentId != null)
        {
            delete (new CMS_Content__c(Id = a_contentId));
        }
        
        a_elementMap = null;
        a_contentId = null;
        
        return null;
    }
    
    public void DoUp(){
    	Map<Id, CMS_ContentToCarousel__c> ctcToUpdate = new Map<Id, CMS_ContentToCarousel__c>();
    	CMS_ContentToCarousel__c prewCtc;
    	Integer i = 0;
    	for(CMS_ContentToCarousel__c ctc : [SELECT Id, Order__c, CMS_Content__c
            													FROM CMS_ContentToCarousel__c 
        													WHERE Carousel__r.Name =: a_carouselName AND CMS_Content__c != null ORDER BY Order__c, CreatedDate])
        {
        	if(ctc.CMS_Content__c == a_contentId && i != 0 && prewCtc != null){
        		ctc.Order__c = i - 1;
        		prewCtc.Order__c = i;
        		ctcToUpdate.put(ctc.Id, ctc);
        		ctcToUpdate.put(prewCtc.Id, prewCtc);
        	} else if(ctc.Order__c != i){
        		ctc.Order__c = i;
        		ctcToUpdate.put(ctc.Id, ctc);
        	}
        	
        	prewCtc = ctc;
        	i++;
        }
        
        if(!ctcToUpdate.isEmpty()){
        		update ctcToUpdate.values();
        	}
    }
    
    public void DoDown(){
    	Map<Id, CMS_ContentToCarousel__c> ctcToUpdate = new Map<Id, CMS_ContentToCarousel__c>();
    	CMS_ContentToCarousel__c prewCtc;
    	Integer i = 0;
    	Boolean changed = false;
    	List<CMS_ContentToCarousel__c> ctcList = [SELECT Id, Order__c, CMS_Content__c
            													FROM CMS_ContentToCarousel__c 
        													WHERE Carousel__r.Name =: a_carouselName AND CMS_Content__c != null ORDER BY Order__c, CreatedDate];
    	for(CMS_ContentToCarousel__c ctc : ctcList)
        {
        	if(ctc.CMS_Content__c == a_contentId && i != ctcList.size() - 1){
        		ctc.Order__c = i + 1;
        		ctcToUpdate.put(ctc.Id, ctc);
        		changed = true;
        	} else if(changed){
        		ctc.Order__c = i - 1;
        		ctcToUpdate.put(ctc.Id, ctc);
        		changed = false;
        	} else if(ctc.Order__c != i){
        		ctc.Order__c = i;
        		ctcToUpdate.put(ctc.Id, ctc);
        	}
        	
        	i++;
        }
        
        if(!ctcToUpdate.isEmpty()){
        		update ctcToUpdate.values();
        	}
    }
    
    public Boolean getShowEditLink()
    {
		Boolean res = isll_Utility.isCurrentUserAdmin();
		
		return res;
	}
	
	private Map<Id, My_Library__c> usersLibraries{
        get{
        	
            usersLibraries = new Map<Id, My_Library__c>();
            for(My_Library__c myLib : [select id, ContentVersion__c, User__c from My_Library__c where User__c =: System.Userinfo.getUserId()]){
                usersLibraries.put(myLib.ContentVersion__c, myLib);
            }
            return usersLibraries;
        }
        set;
    }
	
	/*******************************************************************
       Purpose:  Adds a content version to the user library                                  
    ********************************************************************/
    public PageReference addToLibrary(){
        Id contentVersionID  =  ApexPages.currentPage().getParameters().get('cvidf');
        system.debug('contentVersionID---->>>>'+contentVersionID);
        Map<Id, My_Library__c> usersLibrariesL = usersLibraries;
        system.debug('usersLibrariesL---->>>>'+usersLibrariesL);
        if(usersLibrariesL.isEmpty() || (!usersLibrariesL.isEmpty() && !usersLibrariesL.containsKey(contentVersionID))){
        	 system.debug('insert--->>>');
            insert new My_Library__c(User__c = System.Userinfo.getUserId(), ContentVersion__c = contentVersionID);
        }
       
        return null;
    }
}