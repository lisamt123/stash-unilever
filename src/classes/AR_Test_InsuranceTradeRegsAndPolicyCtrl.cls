/*
	Unilever

	Class Name: AR_Test_InsuranceTradeRegsAndPolicyCtrl

	Created by: Marc Saelzler | 2013-09-18

	Description: To get test coverage for AR_InsuranceTradeRegsAndPolicyController.

	Timeline
	Date 					| Name 				| Description
	2013-09-18 17:06 (CET)	| Marc Saelzler 	| Initial development.
*/
@isTest(SeeAllData=true)
private class AR_Test_InsuranceTradeRegsAndPolicyCtrl
{
	static testMethod void AR_Test_SupplierInfoController()
	{
		Test.startTest();
		
		ar_Application__c test_app = TestDataFactory.getApplication();
		
		insert test_app;
		
		Test.setCurrentPage(Page.AR_SupplierInfo);
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		AR_InsuranceTradeRegsAndPolicyController test_controller = new AR_InsuranceTradeRegsAndPolicyController();
		
		test_controller.InitPage();
		
		// check if data was loaded
        system.assertNotEquals(null, test_controller.application.getId(), 'Application data was not loaded');
        
        AR_ObjectSelectHandler2 tmp_dataHandler = new AR_ObjectSelectHandler2(test_controller.application.getId());
        
        String RTInsurance = tmp_DataHandler.currentRTMap.get('ar_Insurance_and_Policy__c').get('Insurance').Id;
        
        System.assertNotEquals(null, RTInsurance, 'Record type for Insurance not found.');
        
        ar_Insurance_and_Policy__c ctr_insurance = (ar_Insurance_and_Policy__c) test_controller.insuranceObject.obj;
		ctr_insurance.Insurance_Type__c = 'TestInsuranceType';
		ctr_insurance.Description__c = 'TestInsuranceDescription';
		
		test_controller.addRowToInsuranceObjectList();
		
		String RTCompanyPolicies = tmp_DataHandler.currentRTMap.get('ar_Insurance_and_Policy__c').get('Company_Policies').Id;
		
		System.assertNotEquals(null, RTCompanyPolicies, 'Record type for Policy not found.');
		
		ar_Insurance_and_Policy__c ctr_policy = (ar_Insurance_and_Policy__c) test_controller.policyObject.obj;
		ctr_policy.Policy__c = 'TestPolicy';
		
		test_controller.policyObject.getFiles().put('one', new Attachment(Name = 'TestAttachment', Body = Blob.valueOf('TestBody')));
		test_controller.policyObject.SetFiletoInsert('one');
		
		test_controller.addRowToPolicyObjectList();
		
		String RTTradeRegulatoryBodies	= tmp_DataHandler.currentRTMap.get('ar_Insurance_and_Policy__c').get('Trade_and_Regulatory_Bodies').Id;
		
		System.assertNotEquals(null, RTTradeRegulatoryBodies, 'Record type for Trade Regulatory not found.');
        
        ar_Insurance_and_Policy__c ctr_tradeRegulatory = (ar_Insurance_and_Policy__c) test_controller.tradeRegulatoryObject.obj;
		ctr_tradeRegulatory.Organisation__c = 'TestOrganisation';
		ctr_tradeRegulatory.Date_First_joined__c = Date.today();
		
		test_controller.addRowToTradeRegulatoryObjectList();
		
		test_controller.saveMyData();
		
		ar_Insurance_and_Policy__c[] tmp_insuranceList = [SELECT Id, Insurance_Type__c, Description__c FROM ar_Insurance_and_Policy__c WHERE Insurance_Type__c = 'TestInsuranceType' AND Application__c =: test_app.Id AND RecordTypeId =: RTInsurance];
        
        System.assert(!tmp_insuranceList.isEmpty(), 'No Insurance record found.');
        
        ar_Insurance_and_Policy__c tmp_insurance = tmp_insuranceList.get(0);
        
        System.assertEquals('TestInsuranceDescription', tmp_insurance.Description__c, 'Save failed. Description__c is not \'TestInsuranceDescription\'');
        
        ar_Insurance_and_Policy__c[] tmp_policyList = [SELECT Id, Policy__c FROM ar_Insurance_and_Policy__c WHERE Policy__c = 'TestPolicy' AND Application__c =: test_app.Id AND RecordTypeId =: RTCompanyPolicies];
        
        System.assert(!tmp_policyList.isEmpty(), 'No Policy record found.');
        
        ar_Insurance_and_Policy__c[] tmp_tradeRegulatoryList = [SELECT Id, Organisation__c, Date_First_joined__c FROM ar_Insurance_and_Policy__c WHERE Application__c =: test_app.Id AND RecordTypeId =: RTTradeRegulatoryBodies];
        
        System.assert(!tmp_tradeRegulatoryList.isEmpty(), 'No Trade Regulatory record found.');
        
        ar_Insurance_and_Policy__c tmp_tradeRegulatory = tmp_tradeRegulatoryList.get(0);
        
        System.assertEquals('TestOrganisation', tmp_tradeRegulatory.Organisation__c, 'Save failed. Organisation__c is not \'TestOrganisation\'');
        System.assertEquals(Date.today(), tmp_tradeRegulatory.Date_First_joined__c, 'Save failed. Date_First_joined__c is not date of today');
        
        Test.stopTest();
	}
}