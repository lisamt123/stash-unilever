/***
Class: im_ImagemapTest
Description: Test class for im_ImageMap
**/
@isTest
private class im_ImagemapTest {
	
	static testMethod void testSubmit(){
		//create data for the test
		cp_System_Settings__c sysSetting = new cp_System_Settings__c();
	 	sysSetting.Salesforce_Instance__c = 'instance url';
	 	sysSetting.Issue_id_for__c = 'the issue id';

	 	insert sysSetting;

	 	im_imagemap controller = new im_imagemap();

	 	test.startTest();
	 	PageReference returnRef = controller.submit();
	 	test.stopTest();

	 	system.assertNotEquals(null, returnRef);
	 	system.assertEquals('instance url' + '/' + 'the issue id', returnRef.getUrl());

	}

}