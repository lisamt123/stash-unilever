/**********************************************************************
 Name:  isll_LibraryControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The test class for the library controller                                                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:..  	
 
***********************************************************************/
@isTest
private class isll_LibraryControllerTest {
	
	private static List<ContentVersion> cvToInsert;

	static private void initData(integer numberOfDocs){

		ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
		chatterGroupName.String_Value__c 			= isll_TestData.ISLL_NAME;
		insert chatterGroupName;
		
		ContentWorkspace cw = [select Name from ContentWorkspace where name = :isll_TestData.ISLL_NAME];
		
		cvToInsert = new List<ContentVersion>();
		for (Integer i = 0; i < numberOfDocs; i++) {
			ContentVersion cv = isll_TestData.createContentVersion();
			cvToInsert.add(cv);
		}
        insert cvToInsert;
        
        cvToInsert = [Select ContentDocumentId From ContentVersion Where id IN : cvToInsert];
		
		List<ContentWorkspaceDoc> cwdToInsert = new List<ContentWorkspaceDoc>();
		for (ContentVersion cv : cvToInsert) {
			cwdToInsert.add(new ContentWorkspaceDoc(ContentDocumentId = cv.ContentDocumentId, ContentWorkspaceId = cw.id));
		}
		insert cwdToInsert;
		
		List<ContentVersionHistory> contentVersionHisList = new List<ContentVersionHistory>();
		for (ContentVersion cv : cvToInsert) {
			contentVersionHisList.add(new ContentVersionHistory (field = 'contentVersionDownloaded', ContentVersionId = cv.id));
		}
		insert contentVersionHisList;

		ISLL_Custom_Settings__c newFileInd 	= isll_TestData.createISLLCustomSetting(isll_TestData.FILE_INDICATOR);
		newFileInd.Integer_Value__c 		= 5;
		insert newFileInd;

	}

	static testMethod void getAllInLibrary() {
		initData(20);
		
		test.startTest();
			isll_LibraryController controller = new isll_LibraryController();
			controller.libraryType = 'All';
			controller.colNumber = '5';
			List<isll_LibraryController.ContentVersionWrapper> contentInLib = controller.getContentsInIsllLibrary();
		test.stopTest(); 
		
		system.assertEquals(contentInLib.size(), cvToInsert.size());
	 }
	 
	 static testMethod void getTopDownloadedInLibrary() {
		initData(20);
		
		test.startTest();
			isll_LibraryController controller = new isll_LibraryController();
			controller.libraryType = 'TopViewSorted';
			controller.colNumber = '5';
			List<isll_LibraryController.ContentVersionWrapper> contentInLib = controller.getContentsInIsllLibrary();
		test.stopTest(); 
		
		system.assertEquals(contentInLib[0].numberOfDownloads, 1);
	 }
	 
	/* static testMethod void getTopDownloadedInLibrary200() {
		initData(250);
		test.startTest();
		isll_LibraryController controller = new isll_LibraryController();
		controller.libraryType = 'TopViewSorted';
		controller.colNumber = '5';
		
		List<isll_LibraryController.ContentVersionWrapper> contentInLib = controller.getContentsInIsllLibrary();
		test.stopTest(); 
		system.assertEquals(contentInLib[0].numberOfDownloads, 1);
	 }*/
	 
	  static testMethod void getMyLibrary() {
		initData(20);
		
		isll_LibraryController controller = new isll_LibraryController();
		ApexPages.currentPage().getParameters().put(isll_TestData.PARAM_CONTENTVERSIONID,cvToInsert[0].id);
		controller.libraryType = 'MyLibrary';
		controller.colNumber = '5';
		controller.addToLibrary();
		
		test.startTest();	
			List<isll_LibraryController.ContentVersionWrapper> contentInLib = controller.getContentsInIsllLibrary();
			system.assertEquals(1,contentInLib.size());
		test.stopTest(); 
	 }
	 
	 static testMethod void getRemoveFromMyLibrary() {
		initData(20);
		
		isll_LibraryController controller = new isll_LibraryController();
		ApexPages.currentPage().getParameters().put(isll_TestData.PARAM_CONTENTVERSIONID,cvToInsert[0].id);
		controller.libraryType = 'MyLibrary';
		controller.colNumber = '5';
		controller.addToLibrary();
		
		test.startTest();
			
			List<isll_LibraryController.ContentVersionWrapper> contentInLib = controller.getContentsInIsllLibrary();
			system.assertEquals(1,contentInLib.size());
			
			ApexPages.currentPage().getParameters().put(isll_TestData.PARAM_CONTENTVERSIONID,cvToInsert[0].id);
			controller.removeFromLibrary();
			contentInLib = controller.getContentsInIsllLibrary();
			system.assertEquals(0,contentInLib.size());
			
		test.stopTest(); 
	 }
	 
	 static testMethod void testPagination() {
		initData(40);
		
		test.startTest();
			isll_LibraryController controller = new isll_LibraryController();
			controller.libraryType = 'All';
			controller.colNumber = '5';
			List<isll_LibraryController.ContentVersionWrapper> contentInLib = controller.getContentsInIsllLibrary();
			System.assert(controller.getHasNextLibraries());
			controller.nextLibraries();
			System.assert(controller.getHasPreviousLibraries());
			System.assert(controller.getHasFirstLibraries());
			controller.previousLibraries();
			System.assert(controller.getHasNextLibraries());
			controller.lastLibraries();
			System.assert(controller.getHasPreviousLibraries());
			System.assert(controller.getHasFirstLibraries());
			controller.firstLibraries();
			System.assert(controller.getHasNextLibraries());
		test.stopTest(); 
	 }
	 
	 static testMethod void testSettingsAndNullWorkspace() {
	 	initData(20);
		
		test.startTest();
			isll_LibraryController controller = new isll_LibraryController();
			createSettings();
			Map<String, isllBrainResultsSettings__c> settingsMap = isllBrainResultsSettings__c.getAll();
			System.assertEquals(Integer.valueOf(settingsMap.get(isll_TestData.PARAM_LIBRARYPAGESIZE).NumericValue__c), controller.librariesPageSize);
			System.assertEquals(Integer.valueOf(settingsMap.get(isll_TestData.PARAM_OFFSETMAX).NumericValue__c), controller.offsetMax);
			controller.libraryCount = controller.offsetMax + 1;
			System.assertEquals(controller.librariesLastPage, Integer.valueOf(Math.ceil(Double.valueOf(controller.offsetMax) / Double.valueOf(controller.librariesPageSize))));
		test.stopTest(); 
	 }
	 
	 private static void createSettings() {
	 	List<isllBrainResultsSettings__c> brainResultSettings = new List<isllBrainResultsSettings__c>();
		brainResultSettings.add(isll_TestData.createBrainResultSetting(isll_TestData.PARAM_LIBRARYPAGESIZE, 10));
		brainResultSettings.add(isll_TestData.createBrainResultSetting(isll_TestData.PARAM_OFFSETMAX, 2000));
		insert brainResultSettings;
	 }
}