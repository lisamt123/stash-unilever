@isTest
private class BET_AccessServiceTest {
	
	@isTest static void HasUserAccessNoAccessTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(IsOwner__c = true,Team_Member__c = UserInfo.getUserId(),BET__c = bet.id);
		insert member;
		System.assertEquals(BET_AccessService.HasUserAccess(UserInfo.getUserId(),bet.id),'Owner');
		Test.stopTest();
	}

	@isTest static void getStatusOwnerTest(){
		Test.startTest();
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(IsOwner__c = true);
		System.assertEquals(BET_AccessService.getStatus(member),'Owner');
		Test.stopTest();
	}

	@isTest static void getManagerTest(){
		Test.startTest();
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(Role__c = 'Manager');
		System.assertEquals(BET_AccessService.getStatus(member),'Manager');
		Test.stopTest();
	}

	@isTest static void getMemberTest(){
		Test.startTest();
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(Role__c = 'Member');
		System.assertEquals(BET_AccessService.getStatus(member),'Member');
		Test.stopTest();
	}

	@isTest static void checkIfRequestAccessIsPendingTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Member_Request__c memberR = new BET_Member_Request__c(Status__c = 'New', UserId__c = UserInfo.getUserId(),Brand_Experience_Toolkit__c = bet.id);
		insert memberR;
		System.assert(BET_AccessService.checkIfRequestAccessIsPending(UserInfo.getUserId(),bet.id));
		Test.stopTest();
	}

	@isTest static void checkIfRequestExternalAccessIsPendingTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Member_Request__c memberR = new BET_Member_Request__c(Status__c = 'New', External_User_Email__c = 'm.bluj@polsource.com',Brand_Experience_Toolkit__c = bet.id);
		insert memberR;
		System.assert(BET_AccessService.checkIfRequestExternalAccessIsPending(bet.id,'m.bluj@polsource.com'));
		Test.stopTest();
	}
	
	@isTest static void RequestAccessTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_BETWrapper.MemberRequest mRequest = new BET_BETWrapper.MemberRequest();
		mRequest.UserId = UserInfo.getUserId();
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject('TEST_PROJECT_NAME'));
		List<Id> ids = BET_AccessService.RequestAccess(new List<BET_BETWrapper.MemberRequest>{mRequest},bet.id,project.projectId);
		System.assertEquals(ids.size(),1);
		Test.stopTest();
	}

	@isTest static void RequestExternalUserAccessTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id requestId = BET_AccessService.RequestExternalUserAccess('m.bluj@polsource.com',bet.id);
		System.assert(requestId != null);
		Test.stopTest();
	}

	@isTest static void GetBetUsersTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.assertEquals(BET_AccessService.GetBetUsers(bet.id).size(),1);
		Test.stopTest();
	}

	@isTest static void GetBetUsersBetNotExistsTest(){
		Test.startTest();
		try{
			BET_AccessService.GetBetUsers(null);
			throw new BET_CustomBETException('Unit test');
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),'BET record not found for given id null');
		}
		Test.stopTest();
	}
	
}