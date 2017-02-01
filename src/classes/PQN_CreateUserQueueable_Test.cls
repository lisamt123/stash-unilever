@isTest
private class PQN_CreateUserQueueable_Test {
    private static testMethod void myTest(){
        PQN_User_Creation_Request__c userCreationRequest = PQN_TestLibraryUtil.createUserCreationRequest();
        insert userCreationRequest;
                
        Account dc1Account = PQN_TestLibraryUtil.createpqnAccount('DC1','India');
        insert dc1Account;
        
        PQN_User_Account_Request__c accessRequest = PQN_TestLibraryUtil.createAccountAccessRequest(userCreationRequest.Id, 
                                                                                             dc1Account.Id);
        insert accessRequest;
        system.assertEquals('userCreationRequest.Id','userCreationRequest.Id');
        
        Test.startTest();
        PQN_CreateCommuntiyUser.createUser(new List<PQN_User_Creation_Request__c>{userCreationRequest});
        
        
        Test.stopTest();
    }
}