@isTest
public class BFM_CreateContactFromEmail_Test {
  private static testMethod void BFM_CreateContactFromEmail_TestMethod(){
      	Account acc = new Account();
      	acc.Name = 'TestAccount';
      	Insert acc;  
		BFM_Email_Information__c emailinfo = new BFM_Email_Information__c();
        emailinfo.email__c = 'test@test.com';
        emailinfo.Carrier_Account__c = acc.Id;
        emailinfo.Remark__c = 'SF_APPROVAL';
      	insert emailinfo;
      	List<BFM_Email_Information__c> emailsInserted = [select id,Name,email__c,Carrier_Account__c,Remark__c,SF_Approver__c from BFM_Email_Information__c where id=:emailinfo.id ];
      	BFM_CreateContactFromEmailInformation.createContactsFromEmails(emailsInserted);
	}
}