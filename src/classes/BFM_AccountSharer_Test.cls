/**
 * BFM_AccountSharer_Test
 * Class for Apex testing and code coverage of the BFM_Account_Sharer class
 * Creation Date: 2016/07/28
 * Author: Zanquini, Vinicius
 */
@isTest
private class BFM_AccountSharer_Test{
private static testMethod void passwordresettest(){
    Id uid = userinfo.getuserId();
        
        //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = uid
        );
        Database.insert(portalAccount1);
        system.debug('portalAccount1:'+portalAccount1);
        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,
        Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);
        
        BFM_AccountSharer accshare  = new BFM_AccountSharer();
        accshare.shareAccountsReadOnly(uid, new Set<Id>{portalAccount1.Id});
         
  }
}