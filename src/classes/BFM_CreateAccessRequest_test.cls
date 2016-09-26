/**
 * Test class for the BFM_CreateAccessRequest class
 * 
 * @author Zanquini, Vinicius
 * @date 2016/08/02
 * */

@isTest
private class BFM_CreateAccessRequest_test {
    private static testMethod void testCreateAccessRequest(){
        BFM_UserCreationRequest__c userCreationRequest = BFM_TestUtils.createUserCreationRequest();
        insert userCreationRequest;
        
        Account accountOne = BFM_TestUtils.createCarrierAccount();
        accountOne.name = 'Carrier 1';
        Account accountTwo = BFM_TestUtils.createCarrierAccount();
        accountTwo.Name = 'Carrier 2';
        List<Account> accountsList = new List<Account>{accountOne, accountTwo};
        insert accountsList;
        Test.startTest();
        new BFM_CreateAccessRequest(userCreationRequest,accountsList).createAccessRequests();
        Test.stopTest();
    }
}