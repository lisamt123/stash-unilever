@isTest
public class BFM_AccountMoreDetailsController_Test {
	private static testMethod void BFM_AccountMoreDetailsControllertest(){
        String cpf;
        String firstName;
        String lastName;
        String email;
        Boolean hasInformation;
		List<BFM_UserCreationRequest__c> bfmUserCreationList = new List<BFM_UserCreationRequest__c>();
		
		BFM_UserCreationRequest__c uc = new BFM_UserCreationRequest__c(); 
		uc.Email__c = UserInfo.getUserEmail();
		uc.Created_User__c = UserInfo.getUserId();
        uc.CPF__c = '123456789';
        uc.FirstName__c='test';
        uc.LastName__c = 'test';
        insert uc;

        Account acc = new Account(Name = 'TestAccountName');
		insert acc;
		ApexPages.StandardController sc = new ApexPages.standardController(acc);
		BFM_AccountMoreDetailsController acc1 = new BFM_AccountMoreDetailsController(sc);
    }
}