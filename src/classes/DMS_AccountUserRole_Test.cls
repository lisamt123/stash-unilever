@isTest
public class DMS_AccountUserRole_Test {
    private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();
    
    public static testMethod void testCreatePartner(){
        system.runAs(ownerUser){
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount('name','DMS_Distributor', null, null, '01219000000CiAT', ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount('name','DMS_Account', accountDistributor.id, 'APROV', '01219000000CiAY', ownerUser.id, '001', true);
            
            List<id> idAccount = new List<id>();
            idAccount.add(accountStore.Id);
            idAccount.add(accountDistributor.id);
            
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = accountDistributor.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
            
            //Create user
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
            User user1 = new User(
                Username = System.now().millisecond() + 'test@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = System.now().millisecond()+'test@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = System.now().millisecond()+'McTesty',
                CommunityNickname = System.now().millisecond()+ 'test',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                UserRole = portalRole
            );
            Database.insert(user1);
            
            DMS_AccountUserRole.createPartner(idAccount);
        }
    }
}