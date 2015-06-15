/*
	Unilever

	Class Name: AR_Test_SupplierInfoController

	Created by: Marc Saelzler | 2013-09-18

	Description: To get test coverage for AR_SupplierInfoController.

	Timeline
	Date 					| Name 				| Description
	2013-09-18 16:49 (CET)	| Marc Saelzler 	| Initial development.
*/
@isTest(SeeAllData=true)
private class AR_Test_SupplierInfoController
{
	static testMethod void AR_Test_SupplierInfoController()
	{
		Test.startTest();
		
		ar_Application__c test_app = TestDataFactory.getApplication();
		
		insert test_app;
		
		Test.setCurrentPage(Page.AR_SupplierInfo);
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		AR_SupplierInfoController test_controller = new AR_SupplierInfoController();
		
		test_controller.InitPage();
		
		// check if data was loaded
        system.assertNotEquals(null, test_controller.application.getId(), 'Application data was not loaded');
        
        ar_Supplier_Info__c ctr_supplierInfo = (ar_Supplier_Info__c) test_controller.supplierInfoObject.obj;
		ctr_supplierInfo.Name = 'SupplierName';
		ctr_supplierInfo.Rates_Negotiated__c = 'Yes';
		
		test_controller.supplierInfoObject.getFiles().put('one', new Attachment(Name = 'TestAttachment', Body = Blob.valueOf('TestBody')));
		test_controller.supplierInfoObject.SetFiletoInsert('one');
		
		test_controller.addNewSupplierInfoObject();
		
		ar_Supplier_Info__c[] tmp_supplierInfoList = [SELECT Id, Name, Rates_Negotiated__c FROM ar_Supplier_Info__c WHERE Application__c =: test_app.Id];
        
        System.assert(!tmp_supplierInfoList.isEmpty(), 'No ar_Supplier_Info__c record found.');
        
        ar_Supplier_Info__c tmp_supplierInfo = tmp_supplierInfoList.get(0);
        
        System.assertEquals('SupplierName', tmp_supplierInfo.Name, 'Save failed. Name is not \'SupplierName\'');
        System.assertEquals('Yes', tmp_supplierInfo.Rates_Negotiated__c, 'Save failed. Rates_Negotiated__c is not \'Yes\'');
        
        test_controller.supplierInfoObjectList.get(0).remove();
        
        test_controller.saveMyData();
        
        Test.stopTest();
        
        tmp_supplierInfoList = [SELECT Id FROM ar_Supplier_Info__c WHERE Application__c =: test_app.Id];
        
        System.assert(tmp_supplierInfoList.isEmpty(), 'ar_Supplier_Info__c record found, but should be deleted.');
	}
}