@isTest
private class BET_LinkingServiceHelperTest {
	
	private static final String NO_BET_MEMBERS_MESSAGE = 'There should be no members for given BET';

	@isTest static void createMemberRequestForNewPLTest() {
		Id newPL = UserInfo.getUserId();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper newProject = new IPM_BETWrapper(BET_TestUtils.createIPMProject('Unit Test IPM Project'));
		Test.startTest();
		BET_LinkingServiceHelper.createMemberRequestForNewPL(newPL,bet,newProject);
		Test.stopTest();
		BET_Member_Request__c request = [select id , status__c from BET_Member_Request__c where Brand_Experience_Toolkit__c = : bet.id];
		System.assertEquals(request.Status__c,'Approved','Request should be approved');
	}

	@isTest static void removeOldPLFromMembersTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__c = bet.id, Team_Member__c = UserInfo.getUserId());
		insert member;
		Test.startTest();
		BET_LinkingServiceCleaner.removeOldPLFromMembers(UserInfo.getUserId(),bet);
		List<uw_BET_Team_Member__c> members = [select id from uw_BET_Team_Member__c where BET__c =: bet.id and Team_Member__c =: UserInfo.getUserId()];
		System.assert(members.isEmpty(),NO_BET_MEMBERS_MESSAGE);

		member = new uw_BET_Team_Member__c(BET__c = bet.id, Team_Member__c = UserInfo.getUserId());
		insert member;

		BET_LinkingServiceCleaner.removeOldPLFromMembers(UserInfo.getUserId(),bet,BET_TestUtils.createIPMProject('Unit Test Project').id);
		Test.stopTest();
		members = [select id from uw_BET_Team_Member__c where BET__c =: bet.id and Team_Member__c =: UserInfo.getUserId()];
		System.assert(members.isEmpty(),NO_BET_MEMBERS_MESSAGE);
	}
	
	@isTest static void removeOldBetOwnerFromMembersTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__c = bet.id, Team_Member__c = UserInfo.getUserId(),IsOwner__c = true);
		insert member;
		Test.startTest();
		BET_LinkingServiceCleaner.removeOldBetOwnerFromMembers(UserInfo.getUserId(),bet);
		Test.stopTest();
		List<uw_BET_Team_Member__c> members = [select id from uw_BET_Team_Member__c where BET__c =: bet.id and Team_Member__c =: UserInfo.getUserId()];
		System.assert(members.isEmpty(),NO_BET_MEMBERS_MESSAGE);
	}

	@isTest static void setNewLeadProjectAndOwnerTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject('Unit Test IPM Project'));
		IPM_BETWrapper oldProject = new IPM_BETWrapper(BET_TestUtils.createIPMProject('Old Unit Test IPM Project'));
		Test.startTest();
		uw_Bet__c modifiedBet = BET_LinkingServiceHelper.setNewLeadProjectAndOwner(bet,project,oldProject);
		Test.stopTest();
		System.assertEquals(modifiedBet.IPM_Project__c,project.ProjectId,'Bet should have new lead project set');
	}

	@isTest static void archiveAndUnLeadBetTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Test.startTest();
		BET_LinkingServiceHelper.archiveAndUnLeadBet(bet);
		Test.stopTest();
		uw_Bet__c modifiedBet = [select Is_Archived__c,IPM_Project__c from uw_Bet__c where id=:bet.id];
		System.assert(modifiedBet.Is_Archived__c,'Bet should be archived');
		System.assert(modifiedBet.IPM_Project__c == null,'Bet should have no lead project set');
	}

	@isTest static void getOtherFollowingProjectTest(){
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		IPM_Project__c projectfollowing = BET_TestUtils.createIPMProject('Unit Test IPM Project One');
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		project.BET__c = bet.id;
		projectfollowing.BET__c = bet.id;
		projectfollowing.IPM_Target_Launch_Dates__c = Date.newInstance(2015, 9, 4);
		update projectfollowing;
		update project;
		Id ProjectId = project.id;
		Id BetId = bet.id;
		Test.startTest();
		IPM_BETWrapper projectwrap= BET_LinkingServiceHelper.getOtherFollowingProject(ProjectId,BetId);
		Test.stopTest();
		System.assertEquals(projectwrap.ProjectId,projectfollowing.id,'Following project id must match');
	}
	
}