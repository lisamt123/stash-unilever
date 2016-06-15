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
        User createdUser = DMS_SObjectInstance_Test.createUserParthner(contact1.Id,'AccountTrigger@test.com');
        
        
        
        AccountTeamMember aTeam = new AccountTeamMember();
        aTeam.AccountId = accountStore.Id;
        aTeam.UserId = createdUser.id;
        Database.insert(aTeam);                
        
        Target__c target = createTarget(contact1.id,'001');            
        Database.insert(target);
        target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
        System.assert(target.ImpactedStores__c == 0);
        
        accountStore.StoreStatus__c = 'APROV';
        Database.update(accountStore);
        target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];        
        System.assert(target.ImpactedStores__c == 1);
        
    }
    
    
    private static Target__c createTarget(Id userIdParam,String saleschannel){
        Target__c target = new Target__c();
        //ownerUser.ContactId = contactTest.Id;
        target.SalesRep__c = userIdParam;
        target.SalesChannel__c = saleschannel;
        target.Frequency__c = 0;
        target.TargetDate__c = Date.today();
        target.Target_Key__c='';
        target.CurrencyIsoCode = 'EUR';
        target.Dropsize__c = 0;
        target.Sellout__c = 0;
        target.Orders__c = 0;
        target.ImpactedStores__c = 0;
        target.Status__c = 'ACT';
        
        return target;
    }
    
}