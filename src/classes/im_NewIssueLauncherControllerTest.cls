/***
Class: im_NewIssueLauncherControllerTest
Description: test for the im_NewIssueLauncherController, 
**/

@isTest
private class im_NewIssueLauncherControllerTest {
	
	private static testMethod void testIssueObjectPrefix() {

		im_NewIssueLauncherController controller = new im_NewIssueLauncherController();

		Test.startTest();
		String prefix = controller.issueObjectPrefix;
		Test.stopTest();

		system.assertEquals(Schema.getGlobalDescribe().get('im_Issue__c').getDescribe().getKeyPrefix(), prefix);
	}		
}