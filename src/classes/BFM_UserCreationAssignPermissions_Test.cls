@isTest
public class BFM_UserCreationAssignPermissions_Test {
  private static testMethod void BFM_UpdateUserRequestQueueable_TestMethod(){
        BFM_UserCreationRequest__c bfmuser = new BFM_UserCreationRequest__c();
        bfmuser.userName__c = 'TestUsername';
        bfmuser.email__c = 'Testuseremail@test.com';
        bfmuser.firstName__c = 'first';
        bfmuser.Operational_User__c = True;
        bfmuser.lastName__c = 'last';
        bfmuser.Tax_User__c=True;
        bfmuser.Finance_User__c = True;
        bfmuser.Created_User__c = Userinfo.getUserId();
        insert bfmuser;
        Test.startTest();
        BFM_UserCreationAssignPermissions request = new BFM_UserCreationAssignPermissions(bfmuser);
        QueueableContext SC;
        request.execute(SC);
        Test.stopTest();
    }
}