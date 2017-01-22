/**
 * Class for instantiating objects that are valid according to business rules, in order to speed up Test class creation
 * Method names should stay in alphabetical order for easy location. As a best practice, they don't do DML in order to be able to be called in bulk
 * */

@isTest
public class BFM_TestUtils {
    private static Id carrierRecordTypeID = [SELECT Id FROM RecordType WHERE DeveloperName = 'BFM_Carrier' AND sObjectType = 'Account'].Id;
    private static Id carrierOperationalProfileId = [SELECt Id FROM Profile WHERE name = 'BFM Partner Community User' LIMIT 1].Id;
    
    public static BFM_UserCreationRequest__c createUserCreationRequest(){
        BFM_UserCreationRequest__c userCreationRequest = new BFM_UserCreationRequest__c();
        userCreationRequest.LastName__c = 'Test Last Name';
        userCreationRequest.FirstName__c = 'Test first Name';
        userCreationRequest.Email__c = 'email@testEmail.notreal.com';
        userCreationRequest.CommunityNickname__c = 'ARandomCommunityNickname';
        userCreationRequest.Username__c = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@randomOrg.com';
        return userCreationRequest;
    }
    
    public static BFM_AccountAccessRequest__c createAccountAccessRequest(Id idUserCreationRequest, Id idAccount){
        BFM_AccountAccessRequest__c accountAccessRequest = new BFM_AccountAccessRequest__c();
        accountAccessRequest.Account__c = idAccount;
        accountAccessRequest.UserCreationRequest__c = idUserCreationRequest;
        return accountAccessRequest;
    }
    
    public static Account createCarrierAccount(){
        Account acc = new Account(Name = 'Carrier1',recordTypeId = BFM_TestUtils.carrierRecordTypeId);
        return acc;
    }
    
    public static user createCarrierUser(){
        User u = new User();
        u.Username = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@randomOrg.com';
        u.Email = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@randomOrg.com';
        u.FirstName = 'First Name';
        u.LastName = 'Last Name';
        u.CommunityNickname = ('Some_nickname'+String.valueOf(datetime.now().getTime())).left(80);
        u.ProfileId = BFM_TestUtils.carrierOperationalProfileId;
        u.alias = u.username.left(4);
        u.LocaleSidKey = 'pt_BR';
        u.LanguageLocaleKey = 'pt_BR';
        u.TimeZoneSidKey = 'America/Sao_Paulo';
        u.EmailEncodingKey = 'ISO-8859-1';
        return u;
    }
    
   
}