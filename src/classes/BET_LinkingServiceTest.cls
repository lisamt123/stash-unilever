@isTest
private class BET_LinkingServiceTest {
	
	private static final String IPM_PROJECT_NAME = 'Unit Test IPM Project';
	private static final String EXCEPTION_MSG = 'There should be exception thrown';

	@isTest static void setASLeadTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		BET_LinkingService.setASLead(ProjectId, BetId);
		bet = [select IPM_Project__c from uw_Bet__c where id=:BetId];
		System.assertEquals(bet.IPM_Project__c,ProjectId,'Project should become BET lead project');
		Test.stopTest();
	}

	@isTest static void setASLeadExceptionTest() {
		Test.startTest();
		try{
			Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
			BET_LinkingService.setASLead(ProjectId, null);
			System.assertEquals(0,1,EXCEPTION_MSG);
		}catch(BET_CustomBETException e){
			System.assertEquals(1,1,EXCEPTION_MSG);
		}
		Test.stopTest();
	}
	
	@isTest static void FollowTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       	User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);
       	insert testUser;
		BET_LinkingService.Follow(ProjectId, BetId, new List<Id>{testUser.id});
		List<BET_Member_Request__c> relatedMemberRequests = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: BetId];
		List<BET_Follow_Request__c> followRequests = [select id from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId];
		System.assertEquals(relatedMemberRequests.size(),1,'There should be one member request');
		System.assertEquals(followRequests.size(),1,'There hsould be one follow request created');	
		Test.stopTest();
	}

	@isTest static void FollowExceptionTest() {
		Test.startTest();
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       	User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);
       	insert testUser;
       	try{
			BET_LinkingService.Follow(ProjectId, null, new List<Id>{testUser.id});
			System.assertEquals(0,1,EXCEPTION_MSG);
		}catch(BET_CustomBETException e){
			System.assertEquals(1,1,EXCEPTION_MSG);
		}
		Test.stopTest();
	}

	@isTest static void FollowTestWithoutMemberRequestIfSameAsBETOwner() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		
		BET_LinkingService.Follow(ProjectId, BetId, new List<Id>{UserInfo.getUserId()});
		List<BET_Member_Request__c> relatedMemberRequests = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: BetId];
		List<BET_Follow_Request__c> followRequests = [select id from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId];
		System.assertEquals(relatedMemberRequests.size(),0,'There should be no member requests');
		System.assertEquals(followRequests.size(),1,'There should be one follow request created');
		Test.stopTest();
	}

	@isTest static void FollowBetNotExistsTest() {
		Test.startTest();
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingService.Follow(ProjectId, null, new List<Id> {UserInfo.getUserId()});
			throw new BET_CustomBETException('unit test');
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),Label.BET_FollowBetNotExistsMessage,'Exception message should be equal to ' + Label.BET_FollowBetNotExistsMessage);
		}
		Test.stopTest();
	}

	@isTest static void FollowBetArchivedTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Is_Archived__c = true;
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingService.Follow(ProjectId, BetId, new List<Id> {UserInfo.getUserId()});
			throw new BET_CustomBETException('unit test');
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),Label.BET_FollowBetArchivedMessage,'Exception message should be equal to ' + Label.BET_FollowBetArchivedMessage);
		}
		Test.stopTest();
	}
	
}