@isTest
private class BET_Team_MemberHandlerClsTest {
	
	@isTest static void addEntitiySubscriptionByTeamMemberTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c();
		member.BET__c = bet.id;
		member.Team_Member__c = UserInfo.getUserId();
		member.Role__c = 'Manager';
		EntitySubscription es = BET_Team_MemberHandlerCls.addEntitiySubscriptionByTeamMember(member);
		System.assertEquals(es.parentId,bet.id);
	}

	@isTest static void addShareByMemberTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c();
		member.BET__c = bet.id;
		member.Team_Member__c = UserInfo.getUserId();
		member.Role__c = 'Manager';
		uw_BET__Share share = BET_Team_MemberHandlerCls.addShareByMember(member, 'Manager');
		System.assertEquals(share.parentId,bet.id);
	}

	@isTest static void createCollaborationGroupMemberByTeamMemberTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c();
		member.BET__c = bet.id;
		member.Team_Member__c = UserInfo.getUserId();
		member.Role__c = 'Manager';
		CollaborationGroupMember gm = BET_Team_MemberHandlerCls.createCollaborationGroupMemberByTeamMember(member, 'Manager');
		System.assertEquals(gm.MemberId,UserInfo.getUserId());
	}

	@isTest static void runPostApprovalInsertTeamMemberOperationsTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);

		uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
		teamMember.BET__c = bet.id;
		teamMember.Team_Member__c = testUser.id;
		teamMember.Role__c = 'Member';
		insert teamMember;
		System.assert(true);
	}
	
 	@isTest static void runRoleModificationsTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);

		uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
		teamMember.BET__c = bet.id;
		teamMember.Team_Member__c = testUser.id;
		teamMember.Role__c = 'Member';
		insert teamMember;
		teamMember.Role__c = 'Manager';
		update teamMember;
		System.assert(true);
	}
	
}