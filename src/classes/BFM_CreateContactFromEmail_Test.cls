@isTest
public class BFM_CreateContactFromEmail_Test {
	private static testMethod void BFM_CreateContactFromEmail_TestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        Insert acc;
        List<BFM_Email_Information__c> emailsInserted = new List<BFM_Email_Information__c>();
        BFM_Email_Information__c emailinfo = new BFM_Email_Information__c();
       	emailinfo.email__c = 'test@test.com';
        emailinfo.Carrier_Account__c = acc.Id;
        emailinfo.Remark__c = 'SF_APPROVAL';
        emailsInserted.add(emailinfo);
        BFM_CreateContactFromEmailInformation.createContactsFromEmails(emailsInserted);
    }
}