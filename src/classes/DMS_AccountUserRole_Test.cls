@isTest
public class DMS_AccountUserRole_Test {
    private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();
    
    public static testMethod void testCreatePartner(){
        system.runAs(ownerUser){
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount('name','DMS_Distributor', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount('name','DMS_Account', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, '001', true);
            
            List<id> idAccount = new List<id>();
            idAccount.add(accountStore.Id);
            idAccount.add(accountDistributor.id);            
            Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'TestMcTesty', null,true);  
            DMS_SObjectInstance_Test.createUserPartner(contact1.id, 'testUser@Roletest.com',true);
            List<UserRole> userAccount =[SELECT Id, PortalAccountId FROM UserRole WHERE PortalAccountId =: idAccount];  
            
            System.assert(userAccount.size()>0);            
            DMS_AccountUserRole.createPartner(idAccount);                                  
        }
    }
}