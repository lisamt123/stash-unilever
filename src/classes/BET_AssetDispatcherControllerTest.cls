/*************************************************************************************
Name : BET_AssetDispatcherControllerTest

Purpose : Unit test class for BET_AssetDispatcherController

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  25-01-2016  Initial
*************************************************************************************/
@isTest
private class BET_AssetDispatcherControllerTest {
	
	private static final String PAGE_REF_NOT_NULL = 'Page Reference should not be null';

	@isTest static void grantAccessPreviewTest() {
		Test.setCurrentPageReference(new PageReference('BET_AssetDispatcher'));
		System.currentPageReference().getParameters().put(BET_AssetDispatcherController.TYPE_PARAM,BET_AssetDispatcherController.PREVIEW);
		System.currentPageReference().getParameters().put(BET_AssetDispatcherController.FILEID_PARAM,UserInfo.getUserId());
		BET_AssetDispatcherController controller = new BET_AssetDispatcherController();
		Test.startTest();
		System.assert(controller.grantAccess() != null,PAGE_REF_NOT_NULL);
		Test.stopTest();
	}
	
	@isTest static void grantAccessDownloadTest() {
		Test.setCurrentPageReference(new PageReference('BET_AssetDispatcher'));
		System.currentPageReference().getParameters().put(BET_AssetDispatcherController.TYPE_PARAM,BET_AssetDispatcherController.DOWNLOAD);
		System.currentPageReference().getParameters().put(BET_AssetDispatcherController.DOWNLOADLINK_PARAM,'https://login.salesforce.com');
		BET_AssetDispatcherController controller = new BET_AssetDispatcherController();
		Test.startTest();
		System.assert(controller.grantAccess() != null,PAGE_REF_NOT_NULL);
		Test.stopTest();
	}
	
}