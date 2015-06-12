/**********************************************************************
 Name:  isll_SustainExpComponentControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The test class for the Sustain Exp Component Controller                                                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:..  	
 
***********************************************************************/

@isTest
private class isll_SustainExpComponentControllerTest {
	static List<User> users;
	
	private static void initData(){

		ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
		chatterGroupName.String_Value__c 			= isll_TestData.ISLL_NAME + ' TestSEC';
		insert chatterGroupName;

		CollaborationGroup grp = isll_TestData.createChatterGroup(isll_TestData.ISLL_NAME + ' TestSEC');
		insert grp;

		List<CollaborationGroupMember> memberList = new List<CollaborationGroupMember>(); 
		users = isll_TestData.createBulkUser(Userinfo.getProfileId(), 5);
		for (User curr : users) {
			curr.Sustainability_Expert__c = true;
		}
		insert users;

		for (User curr : users) {
	    	memberList.add(isll_TestData.createCollaborationGroupMember(curr.Id, grp.Id));
	    }
	    insert memberList;

	}

	static testMethod void wrappedExpertsTest() {
		initData();
		isll_SustainExpComponentController controller = new isll_SustainExpComponentController();

		system.assert(controller.wrappedExperts.size() >= 1);

	}

	static testMethod void allUsersInGroupTest() {
		initData();

		isll_SustainExpComponentController controller = new isll_SustainExpComponentController();
		controller.SMEMode = false;

		system.assertNotEquals(null, controller.allUsersInGroup);
		ApexPages.currentPage().getParameters().put('returnPage', 'http://www.google.com');
		/*
		NOTE: Not sure what this is trying to test as allUSersInGroup will always be empty if SMEMode = false 
		userMap is only querying for user with Sustainability_Expert__c = true;

		SelectOption a = controller.allUsersInGroup[0];
		controller.allUsersInGroup.remove(0);
		controller.selectedUsers  = new List<SelectOption> ();
		controller.selectedUsers.add(a);*/
		controller.updateUsers();
		controller.filter();
		controller.getShowEditLink();
	}

	static testMethod void allUsersInGroupTestSME() {
		initData();
		users[0].isll_SME__c = true;
		update users;

		isll_SustainExpComponentController controller = new isll_SustainExpComponentController();
		controller.SMEMode = true;

		system.assertNotEquals(null, controller.allUsersInGroup);
		ApexPages.currentPage().getParameters().put('returnPage', 'http://www.google.com');
		SelectOption a = controller.allUsersInGroup[0];
		controller.allUsersInGroup.remove(0);
		controller.selectedUsers  = new List<SelectOption> ();
		controller.selectedUsers.add(a);
		controller.updateUsers();

		controller.filter();
		controller.getShowEditLink();

	}

}