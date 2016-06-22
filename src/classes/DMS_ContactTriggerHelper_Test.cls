@isTest
class DMS_ContactTriggerHelper_Test {
    private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();     
    private static final String SALES_CHANNEL = '001';
    private static List<Contact> contactList = new List<Contact>(); 
    
    
    public static testMethod void testUserCreation(){
        system.runAs(ownerUser){
            List<AccountTeamMember> aTeamList = new List<AccountTeamMember>();
            DMS_ContactTriggerHelper contactHelper = new DMS_ContactTriggerHelper();
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount('Distributor','DistributorCode', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount('Store1','Store1Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, SALES_CHANNEL, true);                        

            Contact contactUser = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true);
            Contact contactTest = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true); 
            User createdUser = DMS_SObjectInstance_Test.createUserPartner(contactTest.Id,'testContact@trigger.com',true); 
            aTeamList = [SELECT id FROM AccountTeamMember WHERE AccountId =: accountStore.id];

            Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true);            
            User createdUser = DMS_SObjectInstance_Test.createUserPartner(contact1.Id,'testCountStore@test.com',true); 
            contact1.Email = 'contactHelper@test.com';
            Database.update(contact1);

            
            System.assert(aTeamList.size() == 0);
            
            contactUser.Email = 'contactHelper@test.com';
            contactUser.CodRegion__c = 'testCode';
            Database.update(contactUser);
            
            contactList.add(contactUser);
            contactList.add(contactTest);
            contactHelper.createNewUser(contactList);
            aTeamList = [SELECT id FROM AccountTeamMember WHERE AccountId =: accountStore.id];
            System.assert(aTeamList.size() > 0);
            
        }			                                      
    }    
}
