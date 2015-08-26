@isTest
private class BET_LinkingServiceHelperTest {
	
	@isTest static void createMemberRequestForNewPLTest() {
		Id newPL = UserInfo.getUserId();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper newProject = new IPM_BETWrapper(BET_TestUtils.createIPMProject('Unit Test IPM Project'));
		BET_LinkingServiceHelper.createMemberRequestForNewPL(newPL,bet,newProject);
		BET_Member_Request__c request = [select id , status__c from BET_Member_Request__c where Brand_Experience_Toolkit__c = : bet.id];
		System.assertEquals(request.Status__c,'Approved');
	}

	@isTest static void removeOldPLFromMembersTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__c = bet.id, Team_Member__c = UserInfo.getUserId());
		insert member;
		BET_LinkingServiceHelper.removeOldPLFromMembers(UserInfo.getUserId(),bet);
		List<uw_BET_Team_Member__c> members = [select id from uw_BET_Team_Member__c where BET__c =: bet.id and Team_Member__c =: UserInfo.getUserId()];
		System.assert(members.isEmpty());
	}
	
	@isTest static void removeOldBetOwnerFromMembersTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__c = bet.id, Team_Member__c = UserInfo.getUserId(),IsOwner__c = true);
		insert member;
		BET_LinkingServiceHelper.removeOldBetOwnerFromMembers(UserInfo.getUserId(),bet);
		List<uw_BET_Team_Member__c> members = [select id from uw_BET_Team_Member__c where BET__c =: bet.id and Team_Member__c =: UserInfo.getUserId()];
		System.assert(members.isEmpty());
	}

	@isTest static void setNewLeadProjectAndOwnerTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		IPM_BETWrapper oldProject = new IPM_BETWrapper(BET_TestUtils.createIPMProject('Old Unit Test IPM Project'));
		uw_Bet__c modifiedBet = BET_LinkingServiceHelper.setNewLeadProjectAndOwner(bet,project,oldProject);
		System.assertEquals(modifiedBet.IPM_Project__c,project.id);
	}

	@isTest static void archiveAndUnLeadBetTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_LinkingServiceHelper.archiveAndUnLeadBet(bet);
		uw_Bet__c modifiedBet = [select Is_Archived__c,IPM_Project__c from uw_Bet__c where id=:bet.id];
		System.assert(modifiedBet.Is_Archived__c);
		System.assert(modifiedBet.IPM_Project__c == null);
	}

	@isTest static void getOtherFollowingProjectsTest(){
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		IPM_Project__c projectfollowing = BET_TestUtils.createIPMProject('Unit Test IPM Project One');
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Follow_Request__c request = new BET_Follow_Request__c(Brand_Experience_Toolkit__c = bet.id,Project_Id__c=projectfollowing.id,Status__c = BET_LinkingService.FOLLOW_STATUS_APPROVED);
		insert request;
		Id ProjectId = project.id;
		Id BetId = bet.id;
		List<IPM_Project__c> projects = BET_LinkingServiceHelper.getOtherFollowingProjects(ProjectId,BetId);
		System.assert(!projects.isEmpty());
	}
	
}