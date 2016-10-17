/**
 * BFM_AccountSharer_Test
 * Class for Apex testing and code coverage of the BFM_Account_Sharer class
 * Creation Date: 2016/07/28
 * Author: Zanquini, Vinicius
 */
@isTest
private class BFM_AccountSharer_Test {
    private static User createUser(){
        Profile p=[Select Id from Profile where Name='Carrier Operational']; 
        User usr = new User(Alias = 'testo', 
                 	Email='standarduserbec@unilever.com', 
      				EmailEncodingKey='UTF-8', 
                 	LastName='Test Userbec', 
                 	LanguageLocaleKey='en_US', 
      				LocaleSidKey='en_US', 
                 	ProfileId = p.Id, 
      				TimeZoneSidKey='Europe/London',
                 	isActive=true, 
      				UserName='testuserbec@test123321.com');
        return usr;
    }
    
    private static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'Account test';
        return acc;
    }
    
    /**
     * Tests if an Account is visible for a Carrier user after Apex sharing through the BFM_AccountSharer class
	 * Creation Date: 2016/07/28 
	 * Author: Zanquini, Vinicius
	 * 
     **/
    private static testMethod void testAccountSharing(){
        User usr = createUser();
		insert usr;
        Account acc = createAccount();
        insert acc;
        List<Account> accVisibleBeforeSharing = null;
        List<Account> accVisibleAfterSharing = null;
        System.runAs(usr){
            accVisibleBeforeSharing = [SELECT Id, Owner.Name FROM Account];
        }	
        new BFM_AccountSharer().shareAccountsReadOnly(usr.Id, new Set<Id>{acc.Id});
        System.runAs(usr){
        	accVisibleAfterSharing = [SELECT Id FROM Account];
        }
        System.assertEquals(0, accVisibleBeforeSharing.size());
        system.assertEquals(1, accVisibleAfterSharing.size());
    }
}