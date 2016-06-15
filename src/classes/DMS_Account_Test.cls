@isTest
public class DMS_Account_Test {
    
    private static testMethod void testTrigger()
    {
        Account account = DMS_SObjectInstance_Test.createAccount('ALTAMIRA',DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE, null, null, '01219000000CiAT', UserInfo.getUserId(),null, true);
        account.Name = 'Teste';
        
        database.update(account);
    }
    
    private static testMethod void testTriggerUpdateTarget()
    {
        Account accountDistributor = DMS_SObjectInstance_Test.createAccount('Distributor','DistributorCode', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), UserInfo.getUserId(),NULL, true);
        Account accountStore = DMS_SObjectInstance_Test.createAccount('Store1','Store1Code', accountDistributor.id, 'DESAC', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), UserInfo.getUserId(), '001', true);
        
        Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null);
        User createdUser = DMS_SObjectInstance_Test.createUserParthner(contact1.Id);
        
        AccountTeamMember aTeam = new AccountTeamMember();
        aTeam.AccountId = accountStore.Id;
        aTeam.UserId = createdUser.id;
        Database.insert(aTeam); 
        accountStore.StoreStatus__c = 'APROV';
		Database.update(accountStore);        
    }
}