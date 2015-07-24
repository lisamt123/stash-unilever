@isTest
private class BET_AccessServiceTest {
	
	@isTest static void HasUserAccessTest() {
		BET_AccessService.HasUserAccess(null,null);
	}
	
	@isTest static void RequestAccessTest() {
		BET_AccessService.RequestAccess(null,null);
	}

	@isTest static void RequestExternalUserAccessTest(){
		BET_AccessService.RequestExternalUserAccess(null,null);
	}
	
}