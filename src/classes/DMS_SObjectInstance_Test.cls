@isTest
public class DMS_SObjectInstance_Test {

     public static Account createAccount(String name, Id parentId, String status, Id recordTypeId, Id ownerId,String salesChannel, Boolean isCreate){        
        Account acc = new Account();
        acc.Name = name;
        acc.ParentId = parentId;
        acc.StoreStatus__c = status;
        acc.RecordTypeId = recordTypeId;
        acc.SalesChannel__c = salesChannel;
        acc.OwnerId = ownerId;
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
    
}