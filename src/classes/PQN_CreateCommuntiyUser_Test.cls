@isTest
private class PQN_CreateCommuntiyUser_Test {
    private static testMethod void myTest(){
        PQN_User_Creation_Request__c userCreationRequest = PQN_TestLibraryUtil.createUserCreationRequest();
        insert userCreationRequest;
        system.assertEquals(userCreationRequest.id,userCreationRequest.id);
        Test.startTest();
        PQN_CreateCommuntiyUser.createUser(new List<PQN_User_Creation_Request__c>{userCreationRequest});        
        Test.stopTest();
        }
        }