@isTest
class DMS_ContactTriggerHelper_Test {
    private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();     
    private static final String SALES_CHANNEL = '001';
    
    
    public static testMethod void testUserCreation(){
        system.runAs(ownerUser){
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount('Distributor','DistributorCode', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount('Store1','Store1Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, SALES_CHANNEL, true);                        
            Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true);            
            User createdUser = DMS_SObjectInstance_Test.createUserPartner(contact1.Id,'testCountStore@test.com',true); 
            contact1.Email = 'contactHelper@test.com';
            Database.update(contact1);
            
            system.assert(contact1 != null);
            
        }			                                      
    }    
}