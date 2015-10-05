@isTest
private class BET_Team_MemberHandlerClsHelperTest {
	
	@isTest static void addEntitiySubscriptionByTeamMemberTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c();
		member.BET__c = bet.id;
		member.Team_Member__c = UserInfo.getUserId();
		member.Role__c = BET_Team_MemberHandlerCls.MANAGERROLE;
		Test.startTest();
		EntitySubscription es = BET_Team_MemberHandlerClsHelper.addEntitiySubscriptionByTeamMember(member);
		Test.stopTest();
		System.assertEquals(es.parentId,bet.id,'Entity subscritpion parent should match bet id');
	}

	@isTest static void addShareByMemberTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c();
		member.BET__c = bet.id;
		member.Team_Member__c = UserInfo.getUserId();
		member.Role__c = BET_Team_MemberHandlerCls.MANAGERROLE;
		Test.startTest();
		uw_BET__Share share = BET_Team_MemberHandlerClsHelper.addShareByMember(member, BET_Team_MemberHandlerCls.MANAGERROLE);
		Test.stopTest();
		System.assertEquals(share.parentId,bet.id,'Bet share parent should match bet id');
	}

	@isTest static void createCollaborationGroupMemberByTeamMemberTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c();
		member.BET__c = bet.id;
		member.Team_Member__c = UserInfo.getUserId();
		member.Role__c = 'Manager';
		Test.startTest();
		CollaborationGroupMember gm = BET_Team_MemberHandlerClsHelper.createCollaborationGroupMemberByTeamMember(member, BET_Team_MemberHandlerCls.MANAGERROLE);
		Test.stopTest();
		System.assertEquals(gm.MemberId,UserInfo.getUserId(),'Group member field should match current user id');
	}
	
}