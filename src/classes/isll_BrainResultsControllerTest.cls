/**********************************************************************
 Name:  isll_BrainResultsControllerTest()
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:
Test class of controller 'isll_BrainResultsController'.        
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE                DETAIL                          Description
   1.0 - Marc Saelzler      14/08/2013          INITIAL DEVELOPMENT              
   
***********************************************************************/

@IsTest(SeeAllData=true) // ConnectApi methods are only supported with SeeAllData = true
public class isll_BrainResultsControllerTest
{
	// Initialise data for test methods
	private static void initData() 
	{
		// Constant values
		//String CHATTER_GROUP 	= 'ISLL Chatter Group';
		//String FILE_INDICATOR	= 'New File Indicator';
		//String ISLL_NAME		= 'Internal Sustainable Living Lab';

		// Custom Settings
		if (null ==  ISLL_Custom_Settings__c.getValues(isll_TestData.CHATTER_GROUP)) 
		{
			ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
			chatterGroupName.String_Value__c 			= isll_TestData.ISLL_NAME;
			insert chatterGroupName;
		}
		if (null ==  ISLL_Custom_Settings__c.getValues(isll_TestData.FILE_INDICATOR))
		{
			ISLL_Custom_Settings__c newFileInd 	= isll_TestData.createISLLCustomSetting(isll_TestData.FILE_INDICATOR);
			newFileInd.Integer_Value__c = 5;
			insert newFileInd;
		}

		// Chatter Group
		CollaborationGroup chatterGroup;
		List<CollaborationGroup> groupList = [select id from CollaborationGroup where Name = :isll_TestData.ISLL_NAME];
		if (groupList.size() > 0)
		{
			chatterGroup = groupList[0];
		}
		if (null == chatterGroup)
		{
			chatterGroup 					= isll_TestData.createChatterGroup(isll_TestData.ISLL_NAME);               
		   	try {
		   		insert chatterGroup;
		   	}
		   	catch (Exception e) {}
		}	    
	}
	
	private static void clearPaginationData()
	{
		List<isllBrainResultsSettings__c> pageSettings = [Select Id from isllBrainResultsSettings__c];
		delete pageSettings;
	}
	
	public static testmethod void isll_BrainResultsControllerTest()
	{
		initData();
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		
		Set<String> tmp_validDisplays = tmp_brainResultsController.x_validDisplays;
		
		//Boolean tmp_searchedIsllGroup...
		
		Id tmp_isllGroupId = tmp_brainResultsController.a_isllGroupId;
		
		isll_ChatterComponentController tmp_chatterComponentController = tmp_brainResultsController.a_chatterController;
		
		String tmp_displayContent = tmp_brainResultsController.a_displayContent;
		
		tmp_brainResultsController.a_displayContent = null;
		
		PageReference tmp_pageRef = Page.isll_BrainResults;
		
		tmp_pageRef.getParameters().put('display', 'people');
		
		Test.setCurrentPage(tmp_pageRef);
		
		tmp_brainResultsController.a_searchText = 'test';
		
		tmp_displayContent = tmp_brainResultsController.a_displayContent;
		
		
		ContentVersion tmp_contentVersion =  isll_TestData.createContentVersion();
		insert tmp_contentVersion;
		
		
		tmp_contentVersion = [SElECT ContentDocumentId FROM ContentVersion WHERE Id =: tmp_contentVersion.Id LIMIT 1];
		
		System.assert(tmp_contentVersion != null);
		
		System.assert(tmp_contentVersion.ContentDocumentId != null);
		
		
		/*
		REMOVED: Can't create a library using Apex - this fails if the library is not in the system
		Seems to have no impact on code coverage
		*/
		ContentWorkspaceDoc tmp_contentWorkspaceDoc = new ContentWorkspaceDoc();
		tmp_contentWorkspaceDoc.ContentDocumentId = tmp_contentVersion.ContentDocumentId;
		tmp_contentWorkspaceDoc.ContentWorkspaceId = tmp_brainResultsController.a_isllLibraryId;
		insert tmp_contentWorkspaceDoc;
		
		
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = tmp_contentVersion.id;
       	Test.setFixedSearchResults(fixedSearchResults);

		isll_BrainResultsController.ContentVersionWrapper[] tmp_libraries = tmp_brainResultsController.a_libraries;
		Integer a_libraries = tmp_brainResultsController.a_librarySize;
		
		User[] tmp_experts = tmp_brainResultsController.a_experts;
		
		User[] tmp_people = tmp_brainResultsController.a_people;
		
		Boolean tmp_showExperts = tmp_brainResultsController.a_showExperts;

	}

	private static testmethod void resetElementListTest(){
		initData();
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		tmp_brainResultsController.ResetElementList();
	}

	private static testmethod void updateLibraryListTest(){
		initData();
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		tmp_brainResultsController.updateLibraryList();
	}

	private static testmethod void a_orderFieldsTest(){
		initData();
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		system.assert(tmp_brainResultsController.a_orderFields.size() > 0);
	}


	private static testmethod void a_searchTest(){
		initData();
		ApexPages.CurrentPage().GetParameters().put('search','searchText');
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		system.assertEquals('searchText', tmp_brainResultsController.a_searchText);
	}

	private static testmethod void a_orderDirectionTest(){
		initData();
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		system.assert(tmp_brainResultsController.a_orderDirection.size() > 0);
	}

	private static testmethod void varTest(){
		initData();
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		system.assertNotEquals(null, tmp_brainResultsController.a_contents);
		system.assertNotEquals(null, tmp_brainResultsController.a_postText);
		system.assertNotEquals(null, tmp_brainResultsController.a_contentVersionId);
		system.assertNotEquals(null, tmp_brainResultsController.a_contentVersionDocIDMap);
		system.assertNotEquals(null, tmp_brainResultsController.a_contentVersionToLibraryMap);
		system.assertNotEquals(null, tmp_brainResultsController.a_usersLibraryMap);
		system.assertNotEquals(null, tmp_brainResultsController.a_contentInUserLibraryMap);
		system.assertNotEquals(null, tmp_brainResultsController.a_showShare);
		system.assertNotEquals(null, tmp_brainResultsController.a_userInfoMap);
		system.assertNotEquals(null, tmp_brainResultsController.a_files);
		system.assertNotEquals(null, tmp_brainResultsController.a_followingUserMap);
		system.assertNotEquals(null, tmp_brainResultsController.a_userId);
		system.assertNotEquals(null, tmp_brainResultsController.a_postSucceeded);
		system.assertNotEquals(null, tmp_brainResultsController.a_contentVersionFileTypeMap);	
	}

	// This method requires SeeAllData=true as controller.Follow() is using ConnectApi
	private static testmethod void followUserTest(){
		initData();
		User aUser = isll_TestData.createUser(Userinfo.getProfileId());
		insert aUser;

		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		tmp_brainResultsController.a_userId = aUser.id;


		test.startTest();
			tmp_brainResultsController.Follow();
			tmp_brainResultsController.a_userId = aUser.id;
			tmp_brainResultsController.Unfollow();
		test.stopTest();

	}

	// This method requires SeeAllData=true
	// uw_TriggerHandler.isFeedItemOnCollabGroup: line 1644, column 1 throws a "null pointer Exception" otherwise
	private static testmethod void postTest(){
		initData();
		
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		tmp_brainResultsController.a_postText = 'sometest';

		test.startTest();
			tmp_brainResultsController.Post();
		test.stopTest();

		system.assert(tmp_brainResultsController.a_postSucceeded);
	}

	private static testmethod void AddToMyLibraryTest(){	
		initData();
		ContentVersion cv 	= isll_TestData.createContentVersion();
		insert cv;

		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();

	    tmp_brainResultsController.a_contentVersionId = cv.id;

	    test.startTest();
	    	tmp_brainResultsController.AddToMyLibrary();
	    	tmp_brainResultsController.RemoveFromLibrary();
	    test.stopTest();

	}

	private static testmethod void shareTest(){
		initData();
		ContentVersion cv 	= isll_TestData.createContentVersion();
		insert cv;

		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();

	    tmp_brainResultsController.a_contentVersionId = cv.id;
	    
	    test.startTest();
		    tmp_brainResultsController.Share();
		    tmp_brainResultsController.ShowSharePopup();
		    system.assert(tmp_brainResultsController.a_showShare);
		    tmp_brainResultsController.HideSharePopUp();
		    system.assert(!tmp_brainResultsController.a_showShare);
	    test.stopTest();
	}
	
	private static testmethod void SetUserFollowedMapTest(){
		initData();
		User aUser = isll_TestData.createUser(Userinfo.getProfileId());
		insert aUser;

		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();

		test.startTest();
			tmp_brainResultsController.SetUserFollowedMap(new Set<id>{aUser.id});
		test.stopTest();

	}		

	private static testmethod void SetContentInLibraryMapTest(){
		initData();
		ContentVersion cv 	= isll_TestData.createContentVersion();
		insert cv;

		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();

	    test.startTest();
			tmp_brainResultsController.SetContentInLibraryMap(new Set<id>{cv.id});
		test.stopTest();
	}

	private static testmethod void GetFileTypeIconUrlTest(){
		initData();
		
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		String fileType;
		String fileType2;
		
		test.startTest();
			fileType =  tmp_brainResultsController.GetFileTypeIconUrl('BMP');
			fileType2 =  tmp_brainResultsController.GetFileTypeIconUrl('BMP1');
		test.stopTest();
		
		system.assertEquals('doctype_image_32',fileType);
		system.assertEquals('doctype_unknown_32',fileType2);
	}

	private static testmethod void SetUserInfoMapTest(){
		initData();
		User aUser = isll_TestData.createUser(Userinfo.getProfileId());
		insert aUser;

		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();

		test.startTest();
			tmp_brainResultsController.SetUserInfoMap(new Set<id>{aUser.id});
		test.stopTest();

	}

	private static testmethod void SetContentVersionFileTypeMapTest(){
		initData();
		ContentVersion cv 	= isll_TestData.createContentVersion();
		insert cv;

		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();

	    test.startTest();
			tmp_brainResultsController.SetContentVersionFileTypeMap(new Set<id>{cv.id});
		test.stopTest();
		
		system.assertNotEquals(null, tmp_brainResultsController.a_contentVersionFileTypeMap);
	}
	
	private static isll_BrainResultsController initPagination(Integer recordsTocreate) {
		initData();
		
		PageReference tmp_pageRef = Page.isll_BrainResults;
		
		tmp_pageRef.getParameters().put('display', 'people');
		tmp_pageRef.getParameters().put('search', 'water');
		
		Test.setCurrentPage(tmp_pageRef);
		
		List<ContentVersion> tmp_contentVersionList =  new List<ContentVersion>();
		
		for (Integer i = 0; i<recordsTocreate; i++) {
			ContentVersion tmp_contentVersion = isll_TestData.createContentVersion('test ' + i);
			tmp_contentVersionList.add(tmp_contentVersion);
		}
		
		insert tmp_contentVersionList;
		System.debug(tmp_contentVersionList);
		Set<Id> idSet = new Set<Id>();
		for (ContentVersion cvTemp : tmp_contentVersionList) {
       		idSet.add(cvTemp.id);
		}
		
		isll_BrainResultsController tmp_brainResultsController = new isll_BrainResultsController();
		tmp_brainResultsController.tmp_contentVersionIdSet = idSet;
		tmp_brainResultsController.processLibraries();
		System.assertEquals(tmp_brainResultsController.tmp_contentVersionIdSet.size(), recordsTocreate);
		System.assertEquals(tmp_brainResultsController.a_libraries.size(), tmp_brainResultsController.librariesPageSize);
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 1);
		System.assert(!tmp_brainResultsController.getHasFirstLibraries());
		System.assert(tmp_brainResultsController.getHasNextLibraries());
		System.assert(!tmp_brainResultsController.getHasPreviousLibraries());
		return tmp_brainResultsController;
	}
	
	public static testmethod void isll_BrainResultsControllerTestLibraryPagination()
	{
		isll_BrainResultsController tmp_brainResultsController = initPagination(150);
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 1);
		tmp_brainResultsController.nextLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 2);
		tmp_brainResultsController.previousLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 1);
		tmp_brainResultsController.lastLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, tmp_brainResultsController.librariesLastPage);
		tmp_brainResultsController.firstLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 1);
	}
	
	public static testmethod void isll_BrainResultsControllerTestLibraryPaginationDefaults()
	{
		clearPaginationData();
		isll_BrainResultsController tmp_brainResultsController = initPagination(200);
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 1);
		tmp_brainResultsController.nextLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 2);
		tmp_brainResultsController.previousLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 1);
		tmp_brainResultsController.lastLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, tmp_brainResultsController.librariesLastPage);
		tmp_brainResultsController.firstLibraries();
		System.assertEquals(tmp_brainResultsController.librariesPageNumber, 1);
		tmp_brainResultsController.nextLibrariesBatch();
		System.assertEquals(tmp_brainResultsController.librariesBatchNumber, 2);
		tmp_brainResultsController.previousLibraries();
		System.assertEquals(tmp_brainResultsController.librariesBatchNumber, 1);
		tmp_brainResultsController.nextLibrariesBatch();
		tmp_brainResultsController.previousLibrariesBatch();
	}
	
}