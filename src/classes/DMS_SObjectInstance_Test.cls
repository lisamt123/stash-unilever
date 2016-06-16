@isTest
public class DMS_SObjectInstance_Test {
    
    public static Account createAccount(String name,String externalCode, Id parentId, String status, Id recordTypeId, Id ownerId,String salesChannel, Boolean isCreate){        
        Account acc = new Account();
        acc.Name = name;
        acc.ParentId = parentId;
        acc.StoreStatus__c = status;
        acc.RecordTypeId = recordTypeId;
        acc.SalesChannel__c = salesChannel;
        acc.OwnerId = ownerId;
        acc.ExternalCode__c = externalCode;
        acc.CodRegion__c='testCode';        
        if(isCreate) Database.insert(acc);        
        return acc;
    }
    
    public static User createUserRunTest(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile portalProfile = [SELECT Id,name FROM Profile WHERE Name LIKE '%admin%' Limit 1];
        
        User user1 = new User(
            Username = System.now().millisecond() + DMS_GlobalConstants.USER_TEST_USERNAME, 
            LastName = System.now().millisecond()+DMS_GlobalConstants.USER_TEST_LAST_NAME,                             
            Email = System.now().millisecond()+DMS_GlobalConstants.USER_TEST_EMAIL, 
            
            Alias = DMS_GlobalConstants.USER_TEST_ALIAS, 
            CommunityNickname = System.now().millisecond()+ DMS_GlobalConstants.USER_TEST_COMMUNITY_NICKNAME, 
            
            TimeZoneSidKey = DMS_GlobalConstants.USER_TEST_TIME_ZONE, 
            UserRoleId=portalRole.id, 
            LocaleSidKey=DMS_GlobalConstants.USER_TEST_LOCALE_KEY,
            
            EmailEncodingKey = DMS_GlobalConstants.USER_TEST_EMAIL_KEY, 
            
            ProfileId=portalProfile.id,  
            LanguageLocaleKey=DMS_GlobalConstants.USER_TEST_LOCALE_KEY
        );
        Database.insert(user1);
        
        return user1;
    }
    
    public static User createUserRunTest2(){
        
        Profile portalProfile = [SELECT Id,name FROM Profile WHERE Name LIKE '%admin%' Limit 1];
        
        User user1 = new User(
            Username = System.now().millisecond() + DMS_GlobalConstants.USER_TEST_USERNAME, 
            LastName = System.now().millisecond()+DMS_GlobalConstants.USER_TEST_LAST_NAME,                             
            Email = System.now().millisecond()+DMS_GlobalConstants.USER_TEST_EMAIL, 
            
            Alias = DMS_GlobalConstants.USER_TEST_ALIAS, 
            CommunityNickname = System.now().millisecond()+ DMS_GlobalConstants.USER_TEST_COMMUNITY_NICKNAME, 
            
            TimeZoneSidKey = DMS_GlobalConstants.USER_TEST_TIME_ZONE, 
            
            LocaleSidKey=DMS_GlobalConstants.USER_TEST_LOCALE_KEY,
            
            EmailEncodingKey = DMS_GlobalConstants.USER_TEST_EMAIL_KEY, 
            
            ProfileId=portalProfile.id,  
            LanguageLocaleKey=DMS_GlobalConstants.USER_TEST_LOCALE_KEY
        );
        Database.insert(user1);
        
        return user1;
    }
    
    public static User createUserPartner(id contactId, String userName,Boolean isCreate){
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
        User user1 = new User(
            Username = userName,
            ContactId = contactId,
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
        if(isCreate){
        Database.insert(user1);                                                               
        }
        return user1;
        
        
    }
    
    public static Contact createContact(id accountId,String name, String email, Boolean isCreate){                 
        
        Contact cont1 = new Contact(
            FirstName = name,
            Lastname = name,
            AccountId = accountId,
            Email =email,
            CodRegion__c = 'testCode'
        );
        if(isCreate)
        {
        insert cont1;
        }
        return cont1;
    }
    
    public static Target__c createTarget(Id userIdParam,String saleschannel,Boolean isCreate){
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
        if(isCreate)
        {
            Database.insert(target);
        }
        return target;
    }
    
    public static AccountTeamMember createAccountTeam(id userIdParam, id accountIdParam,Boolean isCreate){
        AccountTeamMember aTeam = new AccountTeamMember();
        aTeam.AccountId = accountIdParam;
        aTeam.UserId = userIdParam;
        if(isCreate)
        {
        Database.insert(aTeam);
        }
        return aTeam;
    }
    
}