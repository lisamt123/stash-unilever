/*
	Unilever

	Class Name: AR_Test_Login

	Created by: Marc Saelzler | 2013-09-20

	Description: Controller for the page AR_Login.

	Timeline
	Date 					| Name 				| Description
	2013-09-20 16:25 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
public class AR_Test_Login
{
	static testMethod void AR_Test_Login()
	{
		Test.startTest();
		
		Test.setCurrentPage(Page.AR_Login);
		
		AR_Login test_controller = new AR_Login();
		
		test_controller.login();
		
		Test.stopTest();
	}
}