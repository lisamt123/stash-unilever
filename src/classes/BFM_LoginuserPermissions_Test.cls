@isTest
public class BFM_LoginuserPermissions_Test{
    public static testMethod void testassignPermissionset(){
 
        Profile p = [select id from profile where name='System Administrator']; 
          User objUser = new User(alias = 'stan', email='standarduser@test.com', 
          emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
          localesidkey='en_US', profileid = p.Id, 
          timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
          insert objUser;
          system.assertEquals('standarduser@test.com', objUser.email);

        BFM_UserCreationRequest__c userRequest = new BFM_UserCreationRequest__c();
        User userid = new User();
        userRequest.Created_User__c=userid.id;
        //userRequest.userRequestId=userRequest.id;
        userRequest.userName__c='Megha.Gavade@unile.com.carrier';
        userRequest.email__c='megha.gavade@unilever.com';
        userRequest.firstName__c='arun';
        userRequest.cnpj__c='12345678';
        userRequest.Operational_User__c=true;
        userRequest.lastName__c='kumar';
        userRequest.communityNickname__c='arunk';
        insert userRequest;
        test.startTest();
        BFM_LoginuserPermissions.assignPermissionset(objUser.id,userRequest.id);
        test.stopTest();    
    }
}