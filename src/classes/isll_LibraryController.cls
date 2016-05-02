/**********************************************************************
 Name:  isll_LibraryController
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:Manages My Library part of ISLL                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     16/07/2013        INITIAL DEVELOPMENT         Story id:USLL-182  
 
***********************************************************************/
public with sharing class isll_LibraryController {
    public String textArea{get;set;}
    public String libraryType {get;set;}
    public String colNumber{get;set;}
    public isll_ChatterComponentController chatterController{get;set;}
    public ID selectedDocToShare;
    private ContentWorkspace workspace;
    private Map<id,id> contentVersionDocIDMap;
    private boolean refreshUserLibrary;
    
    public static Decimal NEW_FILE_INDICATOR = ISLL_Custom_Settings__c.getValues('New File Indicator').Integer_Value__c;
    
    
    public String getSelectedDocToShare(){
    	return selectedDocToShare;
    }
    
     public void setSelectedDocToShare(String value){
    	system.debug('the value: '+value);
    	selectedDocToShare = value;
    }
    public isll_LibraryController(){
        
        //get the workspace id
        
        List<ContentWorkspace>  wsList= [select Name from ContentWorkspace where name = 'Internal Sustainable Living Lab' Limit 1];
        if(null != wsList && wsList.size() == 1){
         workspace = wsList[0];   
            
        }
        if(null != workspace)
    		libraryCount = [Select count() From ContentWorkspaceDoc Where ContentWorkspaceId = :workspace.id];
    	else
    		libraryCount = 0;
        chatterController = new isll_ChatterComponentController();   
        refreshUserLibrary = true;
    }
    
    
    private Map<Id, My_Library__c> usersLibraries{
        get{
        	if(refreshUserLibrary){
	            usersLibraries = new Map<Id, My_Library__c>();
	            for(My_Library__c myLib : [select id, ContentVersion__c, User__c from My_Library__c where User__c =: System.Userinfo.getUserId()]){
	                usersLibraries.put(myLib.ContentVersion__c, myLib);
	            }
        	}
            return usersLibraries;
        }
        set;
    }
    
    /*******************************************************************
       Purpose:  Adds a content version to the user library                                  
    ********************************************************************/
    public void addToLibrary(){
        Id contentVersionID  =  ApexPages.currentPage().getParameters().get('contentVersionID');
        if(usersLibraries.isEmpty() || (!usersLibraries.isEmpty() && !usersLibraries.containsKey(contentVersionID))){
            insert new My_Library__c(User__c = System.Userinfo.getUserId(), ContentVersion__c = contentVersionID);
        }
       // PageReference pageRef = ApexPages.currentPage();
       // pageRef.setRedirect(false);
       // return null;
    }
    
    /*******************************************************************
       Purpose:  removes a content version from the main library  or the users library                               
    ********************************************************************/
    public PageReference removeFromLibrary(){
        Id contentVersionID  =  ApexPages.currentPage().getParameters().get('contentVersionID');
        if(libraryType == 'All'){
            delete new ContentDocument(id = contentVersionDocIDMap.get(contentVersionID));
            
        }
        else if(libraryType == 'MyLibrary'){
            for(My_Library__c aLibrary : usersLibraries.values()){
                if(aLibrary.User__c == System.Userinfo.getUserId() && aLibrary.ContentVersion__c == contentVersionID){
                    delete aLibrary;
                    break;
                }
            }
                
            
        }
        system.debug('after remove: '+getContentsInIsllLibrary());
        return null;
    }
    
    /*******************************************************************
       Purpose:  Retrieves all the latest versions of the documents in the Internal Sustainable Living Lab library                                                         
       Returns:  List<ContentVersion>  - a list of the latest document versions...                                            
    ********************************************************************/
    
    private List<Id> contentDocumentIDs = new List<Id>();
    public Integer libraryCount {get;set;}
    
    public List<ContentVersionWrapper> getContentsInIsllLibrary(){
    	//get users library once;
    	usersLibraries = usersLibraries;
    	refreshUserLibrary = false;
         List<ContentVersionWrapper> contentInIsllLibrary = new List<ContentVersionWrapper>();
        if(null != workspace){
            Map <Id, Integer> contentViewedMap = new Map <Id, Integer>();

            //get the workspace docs
            List<ContentWorkspaceDoc> cwds = new List<ContentWorkspaceDoc>();
            if(libraryType == 'All'){
	            contentDocumentIDs = new List<Id>();
	            Integer offset = (librariesPageNumber - 1) * librariesPageSize;
	            cwds = [Select ContentDocumentId 
	                    From ContentWorkspaceDoc 
	                    Where ContentWorkspaceId = :workspace.id
	                    ORDER BY CreatedDate desc
	                    LIMIT :librariesPageSize
	                    OFFSET :offset];
            } 
            else {
            	cwds = [Select ContentDocumentId 
	                    From ContentWorkspaceDoc 
	                    Where ContentWorkspaceId = :workspace.id
	                    ORDER BY CreatedDate desc];
            }
            
            
            for(ContentWorkspaceDoc cwd : cwds){
                contentDocumentIDs.add(cwd.ContentDocumentId);
            }
            
            List<ContentVersion> contentVersionList =  [Select id, Title, Description, FileType, ContentDocumentId, ContentModifiedDate, CreatedDate
                                                        From ContentVersion 
                                                        Where ContentDocumentId IN :contentDocumentIDs And IsLatest = true ORDER BY CreatedDate desc];
            
            for(ContentVersionHistory cvh : [Select id, ContentVersionId 
                                            From ContentVersionHistory 
                                            Where Field = 'contentVersionDownloaded' And ContentVersionId IN : contentVersionList]){
                if(!contentViewedMap.containsKey(cvh.ContentVersionId)){
                    contentViewedMap.put(cvh.ContentVersionId, 0);
                }
                    contentViewedMap.put(cvh.ContentVersionId, contentViewedMap.get(cvh.ContentVersionId) +1); 
            }
            
            contentVersionDocIDMap = new Map<id,id>();
            for(ContentVersion cv : contentVersionList){
                contentVersionDocIDMap.put(cv.id, cv.ContentDocumentId);
                if(libraryType == 'All' || libraryType == 'TopViewSorted' ){
                    if(!usersLibraries.isEmpty()){
                        contentInIsllLibrary.add(new ContentVersionWrapper(usersLibraries.containsKey(cv.id), cv, contentViewedMap.containsKey(cv.id) ? contentViewedMap.get(cv.id) : 0));
                    }
                    else{
                        contentInIsllLibrary.add(new ContentVersionWrapper(false, cv, contentViewedMap.containsKey(cv.id) ? contentViewedMap.get(cv.id) : 0));
                    }   
                }
                else if(libraryType == 'MyLibrary'){
                    if(!usersLibraries.isEmpty() && usersLibraries.containsKey(cv.id)){
                        contentInIsllLibrary.add(new ContentVersionWrapper(true, cv, contentViewedMap.containsKey(cv.id) ? contentViewedMap.get(cv.id) : 0));
                    }
                }
                
            }
            if(libraryType == 'TopViewSorted'){
                contentInIsllLibrary.sort();
                if(contentInIsllLibrary.size() > 6){
                    List<ContentVersionWrapper> tempList = new List<ContentVersionWrapper>();
                    for(integer i = 0; i < 6; i++){
                        boolean isFlipper = false;
                        boolean isRowEnd = false;
                        if(i == 0 || math.mod(i, Integer.valueOF(colNumber)) == 0){
                            system.debug('isflipper');
                            isFlipper = true;
                        }
                        if(math.mod(i, Integer.valueOF(colNumber)) == 1){
                            isRowEnd = true;
                            system.debug('isRowEnd');
                        }
                        contentInIsllLibrary[i].setRowFlags(isFlipper, isRowEnd);
                        tempList.add(contentInIsllLibrary[i]);
                        
                    }
                    contentInIsllLibrary = tempList;
                }
                 
            }
                integer counter = 0;
                for(ContentVersionWrapper cvw : contentInIsllLibrary){
                    boolean isFlipper = false;
                    boolean isRowEnd = false;
                    counter ++;
                    if(counter == 1 || math.mod(counter-1, Integer.valueOF(colNumber)) == 0){
                            isFlipper = true;
                        }
                        if(math.mod(counter+1, Integer.valueOF(colNumber)) == 1){
                            isRowEnd = true;
                        }
                    cvw.setRowFlags(isFlipper, isRowEnd);
                    
                }
                refreshUserLibrary = true;
        }
        return contentInIsllLibrary;
    }
    
            
    public PageReference share(){ 
        chatterController.shareFile(selectedDocToShare);
        chatterController.postText = '';
        return null;
    }
        
    public Boolean isRemovable
    {
    	get
    	{
    		if(isRemovable == null)
    		{
    			isRemovable = (isll_Utility.isCurrentUserAdmin() || isll_Utility.isCurrentUserModerator());
    		}
    		
    		return isRemovable;
    	}
    	
    	set;
    }
    
    /*******************************************************************
       Purpose:  Pagination methods and properties                                                                                               
    ********************************************************************/
    
    public Integer librariesPageNumber {
    	get {
    		if (librariesPageNumber == null)
    			librariesPageNumber = 1;
    		return librariesPageNumber;
    	}
    	set;
    }
    
    public Integer librariesPageSize {
    	get {
    		Map<String, isllBrainResultsSettings__c> isllBrainResultSettings = isllBrainResultsSettings__c.getAll();
    		if (isllBrainResultSettings.containsKey('fullLibrariesPageSize'))
    			librariesPageSize = Integer.valueOf(isllBrainResultSettings.get('fullLibrariesPageSize').NumericValue__c);
    		if (librariesPageSize == null)
    			librariesPageSize = 20;
    		return librariesPageSize;
    	}
    	set;
    }
    
    public Integer offsetMax {
    	get {
    		Map<String, isllBrainResultsSettings__c> isllBrainResultSettings = isllBrainResultsSettings__c.getAll();
    		if (isllBrainResultSettings.containsKey('offsetMaxLimit'))
    			offsetMax = Integer.valueOf(isllBrainResultSettings.get('offsetMaxLimit').NumericValue__c);
    		if (offsetMax == null)
    			offsetMax = 2000;
    		return offsetMax;
    	}
    	set;
    }
    
    public Integer librariesLastPage {
    	get {
    		if (libraryCount > offsetMax) 
    			librariesLastPage = Integer.valueOf(Math.ceil(Double.valueOf(offsetMax) / Double.valueOf(librariesPageSize)));
    		else
    			librariesLastPage = Integer.valueOf(Math.ceil(Double.valueOf(libraryCount) / Double.valueOf(librariesPageSize)));
    		return librariesLastPage;
    	}
    	set;
    }
    
    public Boolean getHasFirstLibraries() {
    	return librariesPageNumber != 1;
    }
    
    public Boolean getHasPreviousLibraries() {
    	return librariesPageNumber > 1;
    }
    
    public Boolean getHasNextLibraries() {
    	return librariesPageNumber < librariesLastPage;
    }
    
    public void firstLibraries () {
    	librariesPageNumber = 1;
    }
    
    public void previousLibraries () {
	    librariesPageNumber--;
    }
    
    public void nextLibraries () {
    	librariesPageNumber++;
    }
    
    public void lastLibraries () {
    	librariesPageNumber = librariesLastPage;
    }
        
    /*******************************************************************
       Purpose:  Wrapper class for the Content Version                                                                                                 
    ********************************************************************/
    public class ContentVersionWrapper implements Comparable{
        public boolean alreadyInLibrary {get;set;}
        public ContentVersion contentVersion {get;set;}
        public integer numberOfDownloads {get;set;}
        public boolean rowFlipper {get;set;}
        public boolean rowEnd {get;set;}
        public String friendlyFileType { get; private set; }
        public String fileTypeStyle { get; private set; }
        public boolean isNewFile{get;set;}
        
        private Map<String, String> fileTypeMap = new Map<String, String>
        {
            'BMP' => 'Image (BMP)',
            'CSV' => 'Comma Separated Values (CSV)',
            'EXCEL' => 'Excel (XLS)',
            'EXCEL_X' => 'Excel 2007 (XLSX)',
            'EXE' => 'Executable (EXE)',
            'GIF' => 'Image (GIF)',
            'JPG' => 'Image (JPG)',
            'JPEG' => 'Image (JPG)',
            'LINK' => 'External Link',
            'MOV' => 'Video (MOV)',
            'WMV' => 'Video (WMV)',
            'MP4' => 'Video (MP4)',
            'PDF' => 'PDF',
            'PNG' => 'Image (PNG)',
            'POWER_POINT' => 'PowerPoint (PPT)',
            'POWER_POINT_X' => 'PowerPoint 2007 (PPTX)',
            'RTF' => 'Rich Text Format (RTF)',
            'TEXT' => 'Text',
            'UNKNOWN' => 'Unknown',
            'VISIO' => 'Visio (VSD)',
            'WORD' => 'Word (DOC)',
            'WORD_X' => 'Word 2007 (DOCX)',
            'XML' => 'XML',
            'ZIP' => 'Zip'
        };
       
        private Map<String, String> fileTypeStyleMap = new Map<String, String>
        {
            'BMP' => 'doctype_image_32',
            'CSV' => 'doctype_csv_32',
            'EXCEL' => 'doctype_excel_32',
            'EXCEL_X' => 'doctype_excel_32',
            'EXE' => 'doctype_exe_32',
            'GIF' => 'doctype_image_32',
            'JPG' => 'doctype_image_32',
            'JPEG' => 'doctype_image_32',
            'LINK' => 'doctype_link_32',
            'MOV' => 'doctype_video_32',
            'WMV' => 'doctype_video_32',
            'MP4' => 'doctype_mp4_32',
            'PDF' => 'doctype_pdf_32',
            'PNG' => 'doctype_image_32',
            'POWER_POINT' => 'doctype_ppt_32',
            'POWER_POINT_X' => 'doctype_ppt_32',
            'RTF' => 'doctype_rtf_32',
            'TEXT' => 'doctype_txt_32',
            'UNKNOWN' => 'doctype_unknown_32',
            'VISIO' => 'doctype_visio_32',
            'WORD' => 'doctype_word_32',
            'WORD_X' => 'doctype_word_32',
            'XML' => 'doctype_xml_32',
            'ZIP' => 'doctype_zip_32'
        };
        
        
        
        public ContentVersionWrapper(boolean alreadyInLibrary, ContentVersion contentVersion, Integer numberOfDownloads){
            this.alreadyInLibrary = alreadyInLibrary;
            this.contentVersion = contentVersion;
            this.numberOfDownloads = numberOfDownloads;
            this.friendlyFileType = fileTypeMap.get(contentVersion.FileType);
            this.fileTypeStyle = fileTypeStyleMap.get(contentVersion.FileType);
            long daysOld = (datetime.now().getTime()  - contentVersion.ContentModifiedDate.getTime())/(1000*60*60*24);
            if(daysOld <= NEW_FILE_INDICATOR){
                this.isNewFile = true;
            }
            else{
                this.isNewFile = false;
            }
            
            
            if(String.isEmpty(friendlyFileType) || String.isEmpty(fileTypeStyle)){
                this.friendlyFileType = fileTypeMap.get('UNKNOWN');
                this.fileTypeStyle = fileTypeStyleMap.get('UNKNOWN');
            }

        }
        
        public void setRowFlags(boolean rowFlipper, boolean rowEnd){
            this.rowFlipper = rowFlipper;
            this.rowEnd = rowEnd;
        }
        
        public Integer compareTo(Object compareTo) {
            ContentVersionWrapper compareToCVW = (ContentVersionWrapper)compareTo;
            if (numberOfDownloads == compareToCVW.numberOfDownloads) return 0;
            if (numberOfDownloads > compareToCVW.numberOfDownloads) return -1;
            return 1;  
        
        }

    }
}