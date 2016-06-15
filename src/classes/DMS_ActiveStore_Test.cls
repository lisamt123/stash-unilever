@isTest
public class DMS_ActiveStore_Test {
    private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();     
    private static final String SALES_CHANNEL = '001';
    private static final String SALES_CHANNEL_SECOND = '002';
        
    private static testMethod void testActiveStore(){
        system.runAs(ownerUser){
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount('Distributor','DistributorCode', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount('Store1','Store1Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, SALES_CHANNEL, true);
            Account accountStoreSameChannel = DMS_SObjectInstance_Test.createAccount('Store2','Store2Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, SALES_CHANNEL, true);        
            Account accountStoreDiferentChannel = DMS_SObjectInstance_Test.createAccount('Store3','Store3Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, SALES_CHANNEL_SECOND, true);
            Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true);
            Contact contact2 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'contactError', null,true);
            User createdUser = DMS_SObjectInstance_Test.createUserPartner(contact1.Id,'testCountStore@test.com',true); 
            Target__c target;
            Set<id> contactIds = new Set<id>();
            Map<String,Map<String,Set<id>>> numberStoresSeller;
            DMS_ActiveStore countAcStore = new DMS_ActiveStore();
            
            contactIds.add(contact1.Id);           
            
            DMS_SObjectInstance_Test.createAccountTeam(createdUser.id,accountStore.id,true);
            
            numberStoresSeller = countAcStore.countStoresUpdateTarget(contactIds);            
            System.assert(numberStoresSeller.get(contact1.Id).get(SALES_CHANNEL).size() == 1);
            
            DMS_SObjectInstance_Test.createAccountTeam(createdUser.id,accountStoreSameChannel.id,true);
            numberStoresSeller = countAcStore.countStoresUpdateTarget(contactIds);
            System.assert(numberStoresSeller.get(contact1.Id).get(SALES_CHANNEL).size() == 2);
            
            DMS_SObjectInstance_Test.createAccountTeam(createdUser.id,accountStoreDiferentChannel.id,true);
            numberStoresSeller = countAcStore.countStoresUpdateTarget(contactIds);
            System.assert(numberStoresSeller.get(contact1.Id).get(SALES_CHANNEL_SECOND).size() == 1);                                                
            
        }                
    }    
}