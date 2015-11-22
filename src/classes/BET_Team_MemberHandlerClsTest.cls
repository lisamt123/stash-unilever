@isTest
private class BET_Team_MemberHandlerClsTest {
	
	@isTest static void runPostApprovalInsertTeamMemberOperationsTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		User testUser = getTestUser();
		
		uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
		teamMember.BET__c = bet.id;
		teamMember.Team_Member__c = testUser.id;
		teamMember.Role__c = BET_Team_MemberHandlerCls.MEMBERROLE;
		insert teamMember;
		teamMember = [select Role__c from uw_BET_Team_Member__c where id =: teamMember.id];
		System.assertEquals(teamMember.Role__c,BET_Team_MemberHandlerCls.MEMBERROLE,'Roles must match');
		Test.stopTest();
	}
	
 	@isTest static void runRoleModificationsTest() {
 		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

        User testUser = getTestUser();

		uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
		teamMember.BET__c = bet.id;
		teamMember.Team_Member__c = testUser.id;
		teamMember.Role__c = BET_Team_MemberHandlerCls.MEMBERROLE;
		insert teamMember;
		teamMember.Role__c = BET_Team_MemberHandlerCls.MANAGERROLE;
		update teamMember;
		teamMember = [select Role__c from uw_BET_Team_Member__c where id =: teamMember.id];
		System.assertEquals(teamMember.Role__c,BET_Team_MemberHandlerCls.MANAGERROLE,'Roles must match');
		Test.stopTest();
	}

	private static User getTestUser(){
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);
        return testUser;
	}
	
}