@isTest (SeeAllData=true)
public with sharing class AR_Test_AgencyMyProfile {
	static testmethod void Test_AR_AgencyMyProfile()
	{
		Test.startTest();
		
		//Create account
		Account portalAccount1 = new Account(
			Name = 'TestAccount',
			OwnerId = UserInfo.getUserId()
		);
		Database.insert(portalAccount1);
		    	
		//Create contact
		Contact contact1 = new Contact(
		   	FirstName = 'Test',
		    	Lastname = 'McTesty',
			AccountId = portalAccount1.Id,
		    	Email = System.now().millisecond() + 'test@test.com'
		);
		Database.insert(contact1);
		    	
		//Create user
		Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
		User user1 = new User(
			Username = System.now().millisecond() + 'test12345@test.com',
			ContactId = contact1.Id,
			ProfileId = portalProfile.Id,
			Alias = 'test123',
			Email = 'test12345@test.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'McTesty',
			CommunityNickname = 'test12345',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US'
		);
		Database.insert(user1);
		
		System.assertEquals(portalAccount1.Id,[Select Id,AccountId FROM User where Id = :user1.Id].AccountId,'wrong or no AccountID');
		
		AR_AgencyMyProfile testcls = new AR_AgencyMyProfile();
		Account TestAcc = testcls.agency;
		
		System.runAs(user1)
		{
			AR_AgencyMyProfile testcls2 = new AR_AgencyMyProfile();
			Account TestAcc2 = testcls2.agency;
			testcls2.agency = TestAcc2;
			Account TestAcc3 = testcls2.agency;
			
			System.assertEquals(TestAcc3.Id,[Select Id,AccountId FROM User where Id = :user1.Id].AccountId,'wrong or no AccountID');
		}
		
		
		
		Test.stopTest();
	}
}