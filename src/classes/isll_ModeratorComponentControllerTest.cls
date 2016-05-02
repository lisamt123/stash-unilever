/**********************************************************************
 Name:  isll_ModeratorComponentControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:the test class for isll_ModeratorComponentController                                                        
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     27/08/2013        INITIAL DEVELOPMENT          	
 
***********************************************************************/
@IsTest
private class isll_ModeratorComponentControllerTest {
	static List<User> users;
	
	private static void initData(){
		
		ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
		chatterGroupName.String_Value__c 			= isll_TestData.ISLL_NAME + ' TestMCC';
		insert chatterGroupName;

		CollaborationGroup grp = isll_TestData.createChatterGroup(isll_TestData.ISLL_NAME + ' TestMCC');
		insert grp;

		List<CollaborationGroupMember> memberList = new List<CollaborationGroupMember>(); 
		users = isll_TestData.createBulkUser(Userinfo.getProfileId(), 5);
		for (User curr : users) {
			curr.is_isll_moderator__c = true;
		}
		insert users;
		for (User curr : users) {
	    	memberList.add(isll_TestData.createCollaborationGroupMember(curr.Id, grp.Id));
	    }
	    insert memberList;

	}

	static testmethod void constructorTest(){
		initData();
		isll_ModeratorComponentController controller = new isll_ModeratorComponentController();
		system.debug('controller.listOfPotentialMods.size(): '+controller.listOfPotentialMods.size());
		system.assert(controller.listOfPotentialMods.size() > 5);
	}
	    
	static testmethod void updateModTest(){
		initData();
		isll_ModeratorComponentController controller = new isll_ModeratorComponentController();
		ApexPages.currentPage().getParameters().put('returnPage', 'http://www.google.com');
		controller.newMod = users[0].id; 
		controller.updateMod();

		User aUser = [select is_isll_moderator__c from User where id = : users[0].id];
		system.assert(aUser.is_isll_moderator__c);

	}

	static testmethod void cancelTest(){
		initData();
		isll_ModeratorComponentController controller = new isll_ModeratorComponentController();
		ApexPages.currentPage().getParameters().put('returnPage', 'http://www.google.com');
		controller.newMod = users[0].id; 
		PageReference returnUrl = controller.goBack();
		
		system.assertEquals('http://www.google.com', returnUrl.getUrl());

		boolean isEditable = controller.getShowEditLink();

	}

}