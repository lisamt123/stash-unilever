/**********************************************************************
 Name:  isll_BrainResultsController()
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: Controller of page 'isll_BrainResults'.
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE                DETAIL                          Description
   1.0 - Marc Saelzler      30/07/2013          INITIAL DEVELOPMENT             CSR: 
   
***********************************************************************/
public class isll_BrainResultsController
{
    // Static Block
    public static Decimal NEW_FILE_INDICATOR = ISLL_Custom_Settings__c.getValues('New File Indicator').Integer_Value__c;
    public static final string CHATTER_GROUP_NAME = ISLL_Custom_Settings__c.getValues('ISLL Chatter Group').String_Value__c;
        
    // Set of valid viewable sections within the vf page.
    public Set<String> x_validDisplays = new Set<String>{
        'library', 'people', 'chatter'
    };
    
    // Identifier if the isll chatter group already has been searched.
    private Boolean x_searchedIsllGroup = false;
    
    private Map<String, String> x_fileTypeStyleMap = new Map<String, String>
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
    
    public isll_ChatterComponentController a_chatterController
    {
        get
        {
            if(a_chatterController == null)
            {
                a_chatterController = new isll_ChatterComponentController();
            }
            
            return a_chatterController;
        }
        
        set;
    }
    
    
    // Non-Static Variables
    
    
    
    // Constructors
    public isll_BrainResultsController() {
        loadLibraries();
    }
    
        
    // getter & setter methods
    // Input value of which section will be currently displayed.
    public String a_displayContent
    {
        get
        {
            if(a_displayContent == null)
            {
                a_displayContent = 'library';
                
                if(ApexPages.CurrentPage().GetParameters().ContainsKey('display'))
                {
                    String tmp_display = ApexPages.CurrentPage().GetParameters().get('display').ToLowerCase();
                    
                    if(x_validDisplays.contains(tmp_display))
                    {
                        a_displayContent = tmp_display;
                    }
                }
            }
            system.debug(loggingLevel.error, '******a_displayContent: '+a_displayContent);
            return a_displayContent;
        }
        
        set;
    }
    
    public void loadLibraries() {
        a_libraries = new List<ContentVersionWrapper>();

        if(a_searchText != '' && a_isllLibraryId != null)
        {
            String tmp_searchText = '*' + a_searchText.trim() + '*';
            
            String tmp_validSearchText = a_searchText.replace(' ', '');
                
            if(tmp_validSearchText.length() > 1)
            {
                String orderClause = '';
                if(a_selectedOrderField != null && a_selectedOrderField != 'Relevance')
                    orderClause = ' ORDER BY ' + a_selectedOrderField + ' ' + a_selectedOrderDirection;

                String searchquery = 'FIND :tmp_searchText IN ALL FIELDS RETURNING ContentVersion (id where ContentDocument.ParentId = :a_isllLibraryId and isLatest = true ' + orderClause + ') Limit :SOSLLimit'; 
                List<List<SObject>> tmp_searchResult = search.query(searchquery);
                ContentVersion[]  tmp_contentVersionList = (ContentVersion[]) tmp_searchResult.get(0);
                tmp_contentVersionIdSet = new Set<Id>();
                Integer lastIteration = 0;
                for(Integer i = (librariesBatchNumber-1)*offsetMax; i < librariesBatchNumber*offsetMax; i++)
                {
                    if (i >= tmp_contentVersionList.size())
                        break;
                    tmp_contentVersionIdSet.add(tmp_contentVersionList[i].Id);
                    lastIteration = i + 1;
                }
                if (lastIteration < tmp_contentVersionList.size())
                    hasNextLibrariesBatch = true;
                else
                    hasNextLibrariesBatch = false;
                processLibraries();
            }
        }
    }
    
    public Set<Id> tmp_contentVersionIdSet {
    	get {
    		if (tmp_contentVersionIdSet == null)
    			tmp_contentVersionIdSet = new Set<Id>();
    		return tmp_contentVersionIdSet;
    	}
    	set;
    }
    
    public Integer librariesPageNumber {
        get {
            if (librariesPageNumber == null)
                librariesPageNumber = 1;
            return librariesPageNumber;
        }
        set;
    }
    
    public Integer librariesBatchNumber {
        get {
            if (librariesBatchNumber == null)
                librariesBatchNumber = 1;
            return librariesBatchNumber;
        }
        set;
    }
    
    public Integer librariesPageSize {
        get {
            Map<String, isllBrainResultsSettings__c> isllBrainResultSettings = isllBrainResultsSettings__c.getAll();
            if (isllBrainResultSettings.containsKey('librariesPageSize'))
                librariesPageSize = Integer.valueOf(isllBrainResultSettings.get('librariesPageSize').NumericValue__c);
            if (librariesPageSize == null)
                librariesPageSize = 15;
            return librariesPageSize;
        }
        set;
    }
    
    public Integer offsetMax {
        get {
            Map<String, isllBrainResultsSettings__c> isllBrainResultSettings = isllBrainResultsSettings__c.getAll();
            if (isllBrainResultSettings.containsKey('offsetMax'))
                offsetMax = Integer.valueOf(isllBrainResultSettings.get('offsetMax').NumericValue__c);
            if (offsetMax == null)
                offsetMax = 150;
            return offsetMax;
        }
        set;
    }
    
    public Integer SOSLLimit  {
        get {
            Map<String, isllBrainResultsSettings__c> isllBrainResultSettings = isllBrainResultsSettings__c.getAll();
            if (isllBrainResultSettings.containsKey('SOSLLimit'))
                SOSLLimit = Integer.valueOf(isllBrainResultSettings.get('SOSLLimit').NumericValue__c);
            if (SOSLLimit == null)
                SOSLLimit = 2000;
            return SOSLLimit;
        }
        set;
    }
    
    public Integer librariesLastPage {
        get {
            if (tmp_contentVersionIdSet.size() > offsetMax) {
                librariesLastPage = Integer.valueOf(Math.ceil(Double.valueOf(offsetMax) / Double.valueOf(librariesPageSize)));
            }
            else {
                librariesLastPage = Integer.valueOf(Math.ceil(Double.valueOf(tmp_contentVersionIdSet.size()) / Double.valueOf(librariesPageSize)));
            }
            return librariesLastPage;
        }
        set;
    }
    
    public Boolean getHasFirstLibraries() {
        return librariesPageNumber != 1;
    }
    
    public Boolean getHasPreviousLibraries() {
        return librariesPageNumber > 1 || librariesBatchNumber > 1;
    }
    
    public Boolean getHasNextLibraries() {
        return librariesPageNumber < librariesLastPage;
    }
    
    public Boolean hasNextLibrariesBatch {get;set;}
    
    public void firstLibraries () {
        librariesPageNumber = 1;
        processLibraries();
    }
    
    public void previousLibraries () {
        if (librariesPageNumber == 1 && librariesBatchNumber > 1) {
            librariesBatchNumber--;
            librariesPageNumber = Integer.valueOf(Math.ceil(Double.valueOf(offsetMax) / Double.valueOf(librariesPageSize)));
            loadLibraries();
        }
        else {  
            librariesPageNumber--;
            processLibraries();
        }
    }
    
    public void nextLibraries () {
        librariesPageNumber++;
        processLibraries();
    }
    
    public void lastLibraries () {
        librariesPageNumber = librariesLastPage;
        processLibraries();
    }
    
    public void previousLibrariesBatch () {
        librariesPageNumber = 1;
        librariesBatchNumber--;
        loadLibraries();
    }
    
    public void nextLibrariesBatch () {
        librariesPageNumber = 1;
        librariesBatchNumber++;
        loadLibraries();
    }
    
    public void processLibraries() {
        if(!tmp_contentVersionIdSet.isEmpty())
        {
            a_libraries = null;

            String tmp_query = 'SELECT Id, Title, Description, FileType, ContentDocumentId, CreatedDate, ContentModifiedDate FROM ContentVersion WHERE Id IN : tmp_contentVersionIdSet';
            
            if(a_selectedOrderField != null && a_selectedOrderField != 'Relevance')
                tmp_query = tmp_query + ' ORDER BY ' + a_selectedOrderField + ' ' + a_selectedOrderDirection;
            
            Integer offset = (librariesPageNumber - 1)*librariesPageSize;

            tmp_query = tmp_query + ' Limit ' + librariesPageSize + ' OFFSET ' + offset;
            
            Map<Id, ContentVersion> tmp_libraryMap = new Map<Id, ContentVersion>();
            
            System.Debug('#tmp_query: ' + tmp_query);
            
            for(ContentVersion tmp_contentVersion : (ContentVersion[]) Database.Query(tmp_query))
            {
                tmp_contentVersion.ExternalDocumentInfo1 = GetFileTypeIconUrl(tmp_contentVersion.FileType);
                tmp_libraryMap.put(tmp_contentVersion.Id, tmp_contentVersion);
                a_contentInUserLibraryMap.put(tmp_contentVersion.Id, false);
                a_libraries.add(new ContentVersionWrapper(tmp_contentVersion));
            }
            
            SetContentInLibraryMap(tmp_libraryMap.keySet());
        }
    }
    
    // 
    public ContentVersionWrapper[] a_libraries
    {
        get
        {
            if(a_libraries == null)
                a_libraries = new List<ContentVersionWrapper>();
            return a_libraries;
        }
        
        set;
    }
    
    // 
    public Integer a_librarySize
    {
        get
        {
            return a_libraries.size();
        }
    }
    
    // Collection map of peole which are within the isll chatter group.
    public Map<Id, User> a_peopleMap
    {
        get
        {
            if(a_peopleMap == null)
            {
                a_peopleMap = new Map<Id, User>();
                
                if(a_searchText != '')
                {
                    String tmp_searchText = a_searchText.trim();
                    
                    Map<Id, User> tmp_peopleMap = new Map<Id, User>([SELECT Id, Name, Title, SmallPhotoUrl, isll_SME__c, FullPhotoUrl, LocaleSidKey FROM User WHERE Id IN : getA_userIdSet() AND (Name LIKE : '%' + tmp_searchText + '%' OR AboutMe LIKE : '%' + tmp_searchText + '%')]);
                    
                    if(tmp_peopleMap != null && !tmp_peopleMap.isEmpty())
                    {
                        a_peopleMap = tmp_peopleMap;
                    }
                }
            }
            
            return a_peopleMap;
        }
        
        set;
    }
    
    // Collection list of peole which are within the isll chatter group.
    public User[] a_people
    {
        get
        {
            if(a_people == null)
            {
                a_people = new User[]{};
                
                if(a_peopleMap != null && !a_peopleMap.isEmpty())
                {
                    for(User tmp_user : a_peopleMap.values())
                    {
                        if(tmp_user.isll_SME__c)
                        {
                            a_experts.add(tmp_user);
                        }
                        else
                        {
                            a_people.add(tmp_user);
                        }
                    }
                    
                    SetUserFollowedMap(a_peopleMap.keySet());
                }
            }
            
            return a_people;
        }
        
        set;
    }
    
    // 
    public User[] a_experts
    {
        get
        {
            if(a_experts == null)
            {
                a_experts = new User[]{};
            }
            
            return a_experts;
        }
        
        set;
    }
    
    // 
    public Boolean a_showExperts
    {
        get
        {
            System.Debug(a_people);
            
            return !a_experts.isEmpty();
        }
    }
    
    public ConnectApi.FeedItemPage tmp_feedItemPage {get;set;}
    
    public Integer moreChatterCounter {
        get {
            if (moreChatterCounter == null)
                moreChatterCounter = 1;
            return moreChatterCounter;
        }
        set;
    }
    
    private Integer chattersPageSize {
        get {
            Map<String, isllBrainResultsSettings__c> isllBrainResultSettings = isllBrainResultsSettings__c.getAll();
            if (isllBrainResultSettings.containsKey('chattersPageSize'))
                chattersPageSize = Integer.valueOf(isllBrainResultSettings.get('chattersPageSize').NumericValue__c);
            if (chattersPageSize == null)
                chattersPageSize = 5;
            return chattersPageSize;
        }
        set;
    }
    
    public Integer chattersPagesToClear {
        get {
            Map<String, isllBrainResultsSettings__c> isllBrainResultSettings = isllBrainResultsSettings__c.getAll();
            if (isllBrainResultSettings.containsKey('chattersPagesToClear'))
                chattersPagesToClear = Integer.valueOf(isllBrainResultSettings.get('chattersPagesToClear').NumericValue__c);
            if (chattersPagesToClear == null)
                chattersPagesToClear = 5;
            return chattersPagesToClear;
        }
        set;
    }
    
    public Boolean getFindMoreChatterDisable () {
        if (tmp_feedItemPage == null)
            return false;
        if (tmp_feedItemPage.nextPageToken == null)
            return false;
        else
            return Math.mod(moreChatterCounter,chattersPagesToClear) != 0;
    }
    
    public Boolean getClearAndFindMoreChatterDisable () {
        if (tmp_feedItemPage == null)
            return false;
        if (tmp_feedItemPage.nextPageToken == null)
            return false;
        else
            return Math.mod(moreChatterCounter,chattersPagesToClear) == 0;
    }

    public void findMoreChatter () {
        moreChatterCounter ++;
        paginateChatter(tmp_feedItemPage.nextPageToken);
    }
    
    public void clearAndFindMoreChatter () {
        a_contents = new List<ConnectApi.FeedItem>();
        a_files = new List<ConnectApi.ContentAttachment>();
        moreChatterCounter ++;
        paginateChatter(tmp_feedItemPage.nextPageToken);
    }

    public void clearChatter () {
        moreChatterCounter = 1;
        a_contents = null;
        a_files = null;
    }
    
    public void paginateChatter(String pageToken) {     
        String tmp_searchText  = a_searchText.trim();
        tmp_feedItemPage = ConnectApi.ChatterFeeds.searchFeedItemsInFeed(null, ConnectApi.FeedType.Record, a_isllGroupId, pageToken, chattersPageSize, null, '*' + tmp_searchText + '*');
        
        ConnectApi.FeedItem[] tmp_feedItems = tmp_feedItemPage.items;
        
        if(tmp_feedItems != null && !tmp_feedItems.isEmpty())
        {
            SetContent(tmp_feedItems);
        }
    }
    
    // Collection of the isll chatter group (feed) content. 
    public ConnectApi.FeedItem[] a_contents {
        get {
            if(a_contents == null)
            {
                system.debug('getting contents');
                a_contents = new ConnectApi.FeedItem[]{};
                
                if(a_searchText != '' && a_isllGroupId != null)
                {
                    system.debug('****: '+a_searchText+'--'+a_isllGroupId);
                    String tmp_searchText  = a_searchText.trim();
                    
                    tmp_feedItemPage = ConnectApi.ChatterFeeds.searchFeedItemsInFeed(null, ConnectApi.FeedType.Record, a_isllGroupId, null, chattersPageSize, null, '*' + tmp_searchText + '*');
                    
                    ConnectApi.FeedItem[] tmp_feedItems = tmp_feedItemPage.items;
                    
                    if(tmp_feedItems != null && !tmp_feedItems.isEmpty())
                    {
                        SetContent(tmp_feedItems);
                    }
                }
            }
            system.debug('returning a_contents: '+a_contents);
            return a_contents;
        }
        set;
    }
    
    // Input value of the search request.
    public String a_searchText
    {
        get
        {
            if(a_searchText == null)
            {
                a_searchText = '';
                
                String tmp_searchText = ApexPages.CurrentPage().GetParameters().get('search');
                
                if(tmp_searchText != null)
                {
                    a_searchText = tmp_searchText.replace('*','');
                }
            }
            
            return a_searchText;
        }
        
        set;
    }
    
    // Collection of files.
    public ConnectApi.ContentAttachment[] a_files
    {
        get
        {
            if(a_files == null)
            {
                a_files = new ConnectApi.ContentAttachment[]{};
            }
            
            return a_files;
        }
        
        set;
    }
    
    // Information to define the field to order by.
    public SelectOption[] a_orderFields
    {
        get
        {
            if(a_orderFields == null)
            {
                a_orderFields = new SelectOption[]
                {
                    new SelectOption('Relevance', 'Relevance'),
                    new SelectOption('Title', 'Title'),
                    new SelectOption('RatingCount', 'Most Popular'),
                    new SelectOption('CreatedDate', 'Most Recent'),
                    new SelectOption('ContentModifiedDate', 'Last Modified')
                };
            }
            
            return a_orderFields;
        }
        
        set;
    }
    
    // Input value of which order direction has been selected.
    public String a_selectedOrderField
    {
        get;
        set;
    }
    
    // Information to define the order direction.
    public SelectOption[] a_orderDirection
    {
        get
        {
            if(a_orderDirection == null)
            {
                a_orderDirection = new SelectOption[]
                {
                    new SelectOption('ASC', 'Ascending'),
                    new SelectOption('DESC', 'Descending')
                };
            }
            
            return a_orderDirection;
        }
        
        set;
    }
    
    // Input value of which order direction has been selected.
    public String a_selectedOrderDirection
    {
        get;
        set;
    }
    
    // Collection of users with the information if the current user is following another or not.
    public Map<Id, Boolean> a_followingUserMap
    {
        get
        {
            if(a_followingUserMap == null)
            {
                a_followingUserMap = new Map<Id, Boolean>();
            }
            
            return a_followingUserMap;
        }
        
        set;
    }
    
    // Input value of a selected user.
    public String a_userId
    {
        get
        {
            if(a_userId == null)
            {
                a_userId = '';
            }
            
            return a_userId;
        }
        
        set;
    }
    
    // Input value for the post text.
    public String a_postText
    {
        get
        {
            if(a_postText == null)
            {
                a_postText = '';
            }
            
            return a_postText;
        }
        
        set;
    }
    
    // 
    public Boolean a_postSucceeded
    {
        get
        {
            if(a_postSucceeded == null)
            {
                a_postSucceeded = false;
            }
            
            return a_postSucceeded;
        }
        
        set;
    }
    
    // 
    public String a_contentVersionId
    {
        get
        {
            if(a_contentVersionId == null)
            {
                a_contentVersionId = '';
            }
            
            return a_contentVersionId;
        }
        
        set;
    }
    
    // 
    public Map<Id, Id> a_contentVersionDocIDMap
    {
        get
        {
            if(a_contentVersionDocIDMap == null)
            {
                a_contentVersionDocIDMap = new Map<Id, Id>();
            }
            
            return a_contentVersionDocIDMap;
        }
        
        set;    
    }
    
    //
    public Map<Id, Id> a_contentVersionToLibraryMap
    {
        get
        {
            if(a_contentVersionToLibraryMap == null)
            {
                a_contentVersionToLibraryMap = new Map<Id, Id>();
            }
            
            return a_contentVersionToLibraryMap;
        }
        
        set;
    }
    
    // 
    public Map<Id, My_Library__c> a_usersLibraryMap
    {
        get
        {
            if(a_usersLibraryMap == null)
            {
                a_usersLibraryMap = new Map<Id, My_Library__c>();
            }
            
            return a_usersLibraryMap;
        }
        
        set;
    }
    
    // 
    public Map<Id, Boolean> a_contentInUserLibraryMap
    {
        get
        {
            if(a_contentInUserLibraryMap == null)
            {
                a_contentInUserLibraryMap = new Map<Id, Boolean>();

            }
            
            return a_contentInUserLibraryMap;
        }
        
        set;
    }
    
    //
    public Boolean a_showShare
    {
        get
        {
            if(a_showShare == null)
            {
                a_showShare = false;
            }
            
            return a_showShare;
        }
        
        set;
    }
    
    // (added 2013-08-11)
    // 
    public Map<Id, User> a_userInfoMap
    {
        get
        {
            if(a_userInfoMap == null)
            {
                a_userInfoMap = new Map<Id, User>();
            }
            
            return a_userInfoMap;
        }
        
        set;
    }
    
    //
    public Map<Id, String> a_contentVersionFileTypeMap
    {
        get
        {
            if(a_contentVersionFileTypeMap == null)
            {
                a_contentVersionFileTypeMap = new Map<Id, String>();
            }
            
            return a_contentVersionFileTypeMap;
        }
        
        set;
    }
    
    
    // Action Methods
    // 
    public PageReference ResetElementList()
    {
        system.debug('**** in ResetElementList: '+a_displayContent);
        a_displayContent = ApexPages.currentPage().getParameters().get('firstParam');
        a_libraries = null;
        a_contents = null;
        a_files = null;
        a_people = null;
        a_experts = null;
        a_followingUserMap = null;
        a_usersLibraryMap = null;
        a_userInfoMap = null;
        a_contentVersionFileTypeMap = null;
        
        return null;
    }
    
    // 
    public PageReference UpdateLibraryList()
    {
        a_libraries = null;
        
        librariesPageNumber = 1;
        librariesBatchNumber = 1;
        loadLibraries();
        return null;
    }
    
    // Method to follow a selected user.
    public PageReference Follow()
    {
        if(a_userId != '')
        {
            ConnectApi.Subscription tmp_subscription = ConnectApi.ChatterUsers.follow('internal', UserInfo.getUserId(), a_userId);
            
            a_followingUserMap.put(a_userId, true);
            
            a_userId = null;
        }
        
        return null;
    }
    
    // Method to unfollow a selected user.
    public PageReference Unfollow()
    {
        if(a_userId != '')
        {
            EntitySubscription tmp_entSub = [SELECT ParentId FROM EntitySubscription WHERE SubscriberId =: UserInfo.getUserId() AND ParentId =: a_userId LIMIT 1];
            
            if(tmp_entSub != null)
            {
                delete tmp_entSub;
                
                a_followingUserMap.put(a_userId, false);
            }
            
            a_userId = null;
        }
        
        return null;
    }
    
    // 
    public PageReference Post()
    {
        if(a_postText != '' && a_postText != 'Ask the group...')
        {
            a_postSucceeded = null;
            
            FeedItem tmp_post = new FeedItem();
            
            tmp_post.ParentId = a_isllGroupId;
            tmp_post.Body = a_postText + '\r\n#AskSLL';
            
            insert tmp_post;
            
            if(tmp_post.Id != null)
            {
                a_postSucceeded = true;
            }
            
            a_postText = null;
        }
        
        return null;
    }
    
    /*******************************************************************
        Purpose:  Adds a content version to the user library                                  
    ********************************************************************/
    public PageReference AddToMyLibrary()
    {
        if(a_usersLibraryMap.isEmpty() || (!a_usersLibraryMap.isEmpty() && !a_usersLibraryMap.containsKey(a_contentVersionId)))
        {
            My_Library__c tmp_myLibrary = new My_Library__c(User__c = Userinfo.getUserId(), ContentVersion__c = a_contentVersionId);
            
            insert tmp_myLibrary;
            
            a_usersLibraryMap.put(a_contentVersionId, tmp_myLibrary);
            a_contentInUserLibraryMap.put(a_contentVersionId, true);
        }
        
        return null;
    }
    
    /*******************************************************************
       Purpose:  removes a content version from the main library  or the users library                               
    ********************************************************************/
    public PageReference RemoveFromLibrary()
    {
        if(a_usersLibraryMap.containsKey(a_contentVersionId))
        {
            delete (new My_Library__c(Id = a_usersLibraryMap.get(a_contentVersionId).Id));
            
            a_usersLibraryMap.remove(a_contentVersionId);
            a_contentInUserLibraryMap.put(a_contentVersionId, false);
        }
        
        return null;
    }
    
    public PageReference Share()
    {
        a_chatterController.shareFile(a_contentVersionId);
        
        HideSharePopUp();
        
        return null;
    }
    
    public PageReference ShowSharePopup()
    {
        a_showShare = true;
        
        return null;
    }
    
    public PageReference HideSharePopUp()
    {
        a_showShare = false;
        
        a_contentVersionId = null;
        
        return null;
    }
    
    
    // Logical Methods
    // Method to fill a collection of users with the information if the current user is following another or not.
    public void SetUserFollowedMap(Set<Id> p_userIdSet)
    {
        if(p_userIdSet != null && !p_userIdSet.isEmpty())
        {
            for(Id tmp_userId : p_userIdSet)
            {
                a_followingUserMap.put(tmp_userId, false);
            }
            
            for(EntitySubscription tmp_entSub : [SELECT ParentId FROM EntitySubscription WHERE SubscriberId =: UserInfo.getUserId() AND ParentId IN : p_userIdSet])
            {
                a_followingUserMap.put(tmp_entSub.ParentId, true);
            }
        }
    }
    
    // 
    public void SetContentInLibraryMap(Set<Id> p_contentVersionIdSet)
    {
        if(p_contentVersionIdSet != null && !p_contentVersionIdSet.isEmpty())
        {
            for(Id tmp_contentVersionId : p_contentVersionIdSet)
            {
                a_contentInUserLibraryMap.put(tmp_contentVersionId, false);
            }
            
            for(My_Library__c tmp_library : [SELECT Id, ContentVersion__c, User__c FROM My_Library__c WHERE ContentVersion__c IN : p_contentVersionIdSet AND User__c =: Userinfo.getUserId()])
            {
                a_usersLibraryMap.put(tmp_library.ContentVersion__c, tmp_library);
                a_contentInUserLibraryMap.put(tmp_library.ContentVersion__c, true);
            }
        }
    }
    
    public String GetFileTypeIconUrl(String p_fileType)
    {
        if(x_fileTypeStyleMap.containsKey(p_fileType))
        {
            return x_fileTypeStyleMap.get(p_fileType);
        }
        
        return 'doctype_unknown_32';
    }
    
    public void SetContent(ConnectApi.FeedItem[] p_feedItemList)
    {
        Set<Id> tmp_userIdSet = new Set<Id>();
        
        Set<Id> tmp_contentVersionIdSetInternal = new Set<Id>();
        
        for(ConnectApi.FeedItem tmp_feedItem : p_feedItemList)
        {
            a_contents.add(tmp_feedItem);
            
            if(tmp_feedItem.actor.type == 'user' || tmp_feedItem.actor.type == 'unauthenticateduser')
            {
                ConnectApi.ActorWithId tmp_actor = (ConnectApi.ActorWithId) tmp_feedItem.actor;
                
                tmp_userIdSet.add(tmp_actor.Id);
            }
            
            if(tmp_feedItem.attachment != null)
            {
                if(tmp_feedItem.attachment instanceof ConnectApi.ContentAttachment)
                {
                    ConnectApi.ContentAttachment tmp_contentAttachment = (ConnectApi.ContentAttachment) tmp_feedItem.attachment;
                    
                    a_files.add(tmp_contentAttachment);
                    
                    tmp_contentVersionIdSetInternal.add(tmp_contentAttachment.versionId);
                }
            }
        }
        
        SetContentInLibraryMap(tmp_contentVersionIdSetInternal);
        SetContentVersionFileTypeMap(tmp_contentVersionIdSetInternal);
        SetUserFollowedMap(tmp_userIdSet);
        SetUserInfoMap(tmp_userIdSet);
    }
    
    // (added 2013-08-11)
    // 
    public void SetUserInfoMap(Set<Id> p_userIdSet)
    {
        for(User tmp_user : [SELECT Id, SmallPhotoUrl, FullPhotoUrl, LocaleSidKey FROM User WHERE Id IN : p_userIdSet])
        {
            a_userInfoMap.put(tmp_user.Id, tmp_user);
        }
    }
    
    public void SetContentVersionFileTypeMap(Set<Id> tmp_contentVersionIdSetInternal)
    {
        for(ContentVersion tmp_contentVersion : [SELECT Id, FileType FROM ContentVersion WHERE Id IN : tmp_contentVersionIdSetInternal])
        {
            a_contentVersionFileTypeMap.put(tmp_contentVersion.Id, GetFileTypeIconUrl(tmp_contentVersion.FileType));
        }
    }
    
    
    // Inner Classes and Functions
    
    
    
    // Id of the isll chatter group.
    public Id a_isllGroupId
    {
        get
        {
            if(!x_searchedIsllGroup && a_isllGroupId == null)
            {
                x_searchedIsllGroup = true;
                
                CollaborationGroup[] tmp_group = [SELECT Id, Name FROM CollaborationGroup WHERE Name = :CHATTER_GROUP_NAME];
                
                if(tmp_group != null && !tmp_group.isEmpty())
                {
                    a_isllGroupId = tmp_group.get(0).Id;
                }
            }
            
            return a_isllGroupId;
        }
        
        set;
    }
    
    // Identifier if the isll library already has been searched.
    private Boolean x_searchedIsllLibrary = false;
    
    // Id of the isll library.
    public Id a_isllLibraryId
    {
        get
        {
            if(!x_searchedIsllLibrary)
            {
                x_searchedIsllLibrary = true;
                
                ContentWorkspace[] tmp_library = [SELECT Id, Name FROM ContentWorkspace  WHERE Name = 'Internal Sustainable Living Lab'];
                if(tmp_library != null && !tmp_library.isEmpty())
                {
                    a_isllLibraryId = tmp_library.get(0).Id;
                }
            }
            return a_isllLibraryId;
        }
        
        set;
    }
    
    // Collection set of user ids which have a member relation to the isll chatte group.
    public transient Set<Id> a_userIdSet;
        
    public Set<Id> getA_userIdSet()
    {
        if(a_userIdSet == null)
        {
            a_userIdSet = new Set<Id>();
            
            Set<Id> a_memberIdSet = new Set<Id>();
            
            for(CollaborationGroupMember tmp_groupMember : [SELECT MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId =: a_isllGroupId])
            {
                a_memberIdSet.add(tmp_groupMember.MemberId);
            }
            
            if(a_memberIdSet != null && !a_memberIdSet.isEmpty())
            {
                a_userIdSet = a_memberIdSet;
            }
        }
        
        return a_userIdSet;
    }
        
    public void setA_userIdSet(Set<Id> value) {
        a_userIdSet = value;
    }
    
    public class ContentVersionWrapper{
        public ContentVersion contentVersion {get;set;}
        public boolean isNewFile{get;set;}
        
        public ContentVersionWrapper(ContentVersion contentVersion){
            this.contentVersion = contentVersion;
           
         
            long daysOld = (datetime.now().getTime()  - contentVersion.ContentModifiedDate.getTime())/(1000*60*60*24);
            if(daysOld <= NEW_FILE_INDICATOR){
                this.isNewFile = true;
            }
            else{
                this.isNewFile = false;
            }
        }
    }
}