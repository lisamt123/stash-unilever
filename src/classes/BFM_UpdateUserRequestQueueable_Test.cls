@isTest
public class BFM_UpdateUserRequestQueueable_Test {
	private static testMethod void BFM_UpdateUserRequestQueueable_TestMethod(){
        BFM_UserCreationRequest__c bfmuser = new BFM_UserCreationRequest__c();
        bfmuser.userName__c = 'TestUsername';
        bfmuser.email__c = 'Testuseremail@test.com';
        bfmuser.firstName__c = 'first';
        bfmuser.cnpj__c = '';
        bfmuser.Operational_User__c = True;
        bfmuser.lastName__c = 'last';
        bfmuser.communityNickname__c = '';
        insert bfmuser;
        
        Id userId = UserInfo.getUserId();
        Test.startTest();
        BFM_UpdateUserRequestQueueable request = new BFM_UpdateUserRequestQueueable(bfmuser.Id,userId);
        QueueableContext SC;
        request.execute(SC);
        Test.stopTest();
    }
}