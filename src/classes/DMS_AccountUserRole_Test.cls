@isTest
public class DMS_AccountUserRole_Test {
    private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();
    
    public static testMethod void testCreatePartner(){
        system.runAs(ownerUser){
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount(DMS_GlobalConstants.ACCOUNT_NAME,DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE, null, null, DMS_GlobalConstants.ACCOUNT_RECTYPE_DISTRIBUTOR, ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount(DMS_GlobalConstants.ACCOUNT_NAME,DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE_STORE, accountDistributor.id, DMS_GlobalConstants.ACCOUNT_STATUS_APROV, DMS_GlobalConstants.ACCOUNT_RECTYPE_STORE, ownerUser.id, DMS_GlobalConstants.ACCOUNT_SALES_CHANNEL, true);
            
            List<id> idAccount = new List<id>();
            idAccount.add(accountStore.Id);
            idAccount.add(accountDistributor.id);
            
            Contact contact1 = new Contact(
                FirstName = DMS_GlobalConstants.CONTACT_FIRSTNAME,
                Lastname = DMS_GlobalConstants.CONTACT_LASTNAME,
                AccountId = accountDistributor.Id,
                Email = System.now().millisecond() + DMS_GlobalConstants.CONTACT_EMAIL
            );
            Database.insert(contact1);
            
            
            //Create user
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
            User user1 = new User(
                Username = System.now().millisecond() + DMS_GlobalConstants.USER_TEST_USERNAME,
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = DMS_GlobalConstants.USER_TEST_ALIAS,
                Email = System.now().millisecond()+DMS_GlobalConstants.USER_TEST_EMAIL,
                EmailEncodingKey = DMS_GlobalConstants.USER_TEST_EMAIL_KEY,
                LastName = System.now().millisecond()+DMS_GlobalConstants.USER_TEST_LAST_NAME,
                CommunityNickname = System.now().millisecond()+ DMS_GlobalConstants.USER_TEST_COMMUNITY_NICKNAME,
                TimeZoneSidKey = DMS_GlobalConstants.USER_TEST_TIME_ZONE,
                LocaleSidKey = DMS_GlobalConstants.USER_TEST_LOCALE_KEY,
                LanguageLocaleKey = DMS_GlobalConstants.USER_TEST_LOCALE_KEY,
                UserRole = portalRole
            );
            Database.insert(user1);
            
            DMS_AccountUserRole_CC.createPartner(idAccount);
        }
    }
}