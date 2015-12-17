@isTest(seeAllData=false)
private class BET_AccessServiceTest {
	
	private static final String EXCEPTION_MSG = 'There should be exception thrown';
	private static final String EMAIL_TEST = 'm.bluj@polsource.com';

	@isTest static void HasUserAccessNoAccessTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(IsOwner__c = true,Team_Member__c = UserInfo.getUserId(),BET__c = bet.id);
		insert member;
		System.assertEquals(BET_AccessService.HasUserAccess(UserInfo.getUserId(),bet.id),'Owner','User should be BET owner');
		Test.stopTest();
	}

	@isTest static void getStatusOwnerTest(){
		Test.startTest();
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(IsOwner__c = true);
		System.assertEquals(BET_AccessService.getStatus(member),'Owner','User should be BET owner');
		Test.stopTest();
	}

	@isTest static void getManagerTest(){
		Test.startTest();
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(Role__c = 'Manager');
		System.assertEquals(BET_AccessService.getStatus(member),'Manager','User should be BET manager');
		Test.stopTest();
	}

	@isTest static void getMemberTest(){
		Test.startTest();
		uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(Role__c = 'Member');
		System.assertEquals(BET_AccessService.getStatus(member),'Member','User should be BET member');
		Test.stopTest();
	}

	@isTest static void checkIfRequestAccessIsPendingTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Member_Request__c memberR = new BET_Member_Request__c(Status__c = 'New', UserId__c = UserInfo.getUserId(),Brand_Experience_Toolkit__c = bet.id);
		insert memberR;
		System.assert(BET_AccessService.checkIfRequestAccessIsPending(UserInfo.getUserId(),bet.id),'There should be pending member request');
		Test.stopTest();
	}

	@isTest static void checkIfRequestExternalAccessIsPendingTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Member_Request__c memberR = new BET_Member_Request__c(Status__c = 'New', External_User_Email__c = EMAIL_TEST,Brand_Experience_Toolkit__c = bet.id);
		insert memberR;
		System.assert(BET_AccessService.checkIfRequestExternalAccessIsPending(bet.id,EMAIL_TEST),'There should be pending member request for external user');
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
		System.assertEquals(ids.size(),1,'Number of an access requests should be equal to 1');
		Test.stopTest();
	}

	@isTest static void RequestAccessExceptionTest() {
		BET_BETWrapper.MemberRequest mRequest = new BET_BETWrapper.MemberRequest();
		mRequest.UserId = UserInfo.getUserId();
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject('TEST_PROJECT_NAME'));
		Test.startTest();
		try{
			List<Id> ids = BET_AccessService.RequestAccess(new List<BET_BETWrapper.MemberRequest>{mRequest},null,project.projectId);
			System.assert(ids.isEmpty(),'List should be empty');
		}catch(BET_CustomBETException exc){
			System.assertEquals(exc.getMessage(),'Unable to create access request',EXCEPTION_MSG);
		}
		Test.stopTest();
	}

	@isTest static void RequestExternalUserAccessTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id requestId = BET_AccessService.RequestExternalUserAccess(EMAIL_TEST,bet.id);
		System.assert(requestId != null,'Access request identifier should not equal to null');
		Test.stopTest();
	}

	@isTest static void RequestExternalUserAccessExceptionTest(){
		Test.startTest();
		try{
			BET_AccessService.RequestExternalUserAccess(EMAIL_TEST,null);
			System.assertEquals(0,1,EXCEPTION_MSG);
		}catch(Exception e){
			System.assertEquals(1,1,EXCEPTION_MSG);
		}
		Test.stopTest();
	}

	@isTest static void GetBetUsersTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.assertEquals(BET_AccessService.GetBetUsers(bet.id).size(),1,'Number of bet members should be 1');
		Test.stopTest();
	}

	@isTest static void GetBetUsersBetNotExistsTest(){
		Test.startTest();
		try{
			BET_AccessService.GetBetUsers(null);
			throw new BET_CustomBETException('Unit test');
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),'BET record not found for given id null','Bet record should not be found');
		}
		Test.stopTest();
	}

	@isTest static void checkEmailUnileverTest(){
		Test.startTest();
		System.assert(BET_AccessService.checkEmail('mbluj@unilever.com') != null,'There should be error message');
		Test.stopTest();
	}

	@isTest static void validateAndGetUserIdNullTest(){
		Test.startTest();
		try{
			BET_AccessService.validateAndGetUserId(null,null);
			System.assertEquals(0,1,EXCEPTION_MSG);
		}catch(Exception e){
			System.assertEquals(1,1,EXCEPTION_MSG);
		}

		try{
			BET_AccessService.validateAndGetUserId(EMAIL_TEST,null);
			System.assertEquals(0,1,EXCEPTION_MSG);
		}catch(Exception e){
			System.assertEquals(1,1,EXCEPTION_MSG);
		}

		Test.stopTest();
	}
	
}