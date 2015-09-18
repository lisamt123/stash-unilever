@isTest
private class BET_AccessServiceTest {
	
	@isTest static void HasUserAccessNoAccessTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(IsOwner__c = true,Team_Member__c = UserInfo.getUserId(),BET__c = bet.id);
		insert member;
		System.assertEquals(BET_AccessService.HasUserAccess(UserInfo.getUserId(),bet.id),'Owner');
	}

	@isTest static void getStatusOwnerTest(){
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(IsOwner__c = true);
		System.assertEquals(BET_AccessService.getStatus(member),'Owner');
	}

	@isTest static void getManagerTest(){
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(Role__c = 'Manager');
		System.assertEquals(BET_AccessService.getStatus(member),'Manager');
	}

	@isTest static void getMemberTest(){
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(Role__c = 'Member');
		System.assertEquals(BET_AccessService.getStatus(member),'Member');
	}

	@isTest static void checkIfRequestAccessIsPendingTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Member_Request__c memberR = new BET_Member_Request__c(Status__c = 'New', UserId__c = UserInfo.getUserId(),Brand_Experience_Toolkit__c = bet.id);
		insert memberR;
		System.assert(BET_AccessService.checkIfRequestAccessIsPending(UserInfo.getUserId(),bet.id));
	}

	@isTest static void checkIfRequestExternalAccessIsPendingTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Member_Request__c memberR = new BET_Member_Request__c(Status__c = 'New', External_User_Email__c = 'm.bluj@polsource.com',Brand_Experience_Toolkit__c = bet.id);
		insert memberR;
		System.assert(BET_AccessService.checkIfRequestExternalAccessIsPending(bet.id,'m.bluj@polsource.com'));
	}
	
	@isTest static void RequestAccessTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_BETWrapper.MemberRequest mRequest = new BET_BETWrapper.MemberRequest();
		mRequest.UserId = UserInfo.getUserId();
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject('TEST_PROJECT_NAME'));
		List<Id> ids = BET_AccessService.RequestAccess(new List<BET_BETWrapper.MemberRequest>{mRequest},bet.id,project.projectId);
		System.assertEquals(ids.size(),1);
	}

	@isTest static void RequestExternalUserAccessTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id requestId = BET_AccessService.RequestExternalUserAccess('m.bluj@polsource.com',bet.id);
		System.assert(requestId != null);
	}

	@isTest static void GetBetUsersTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.assertEquals(BET_AccessService.GetBetUsers(bet.id).size(),1);
	}

	@isTest static void GetBetUsersBetNotExistsTest(){
		try{
			BET_AccessService.GetBetUsers(null);
			system.assert(false);
		}catch(Exception e){
			system.assert(true);
		}
	}
	
}