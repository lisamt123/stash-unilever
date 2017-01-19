@isTest
public class BFM_UserCreationPostProcessing_Test {
	private static testMethod void BFM_UserCreationPostProcessing_TestMethod(){
        Id userId = UserInfo.getUserId();
        BFM_UserCreationRequest__c bfmuser = new BFM_UserCreationRequest__c();
        bfmuser.userName__c = 'TestUsername';
        bfmuser.email__c = 'Testuseremail@test.com';
        bfmuser.firstName__c = 'first';
        bfmuser.Operational_User__c = false;
        bfmuser.lastName__c = 'last';
        bfmuser.Tax_User__c=True;
        bfmuser.Finance_User__c = false;
        bfmuser.Created_User__c = Userinfo.getUserId();
        insert bfmuser;
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        Set<Id> accountsIds  = new Set<Id>();
        accountsIds.add(acc.Id);
        Test.startTest();
        BFM_UserCreationPostProcessing request = new BFM_UserCreationPostProcessing(userId, bfmuser.Id,accountsIds);
        QueueableContext SC;
        request.execute(SC);
        BFM_UserCreationRequestHandler userhandler=new BFM_UserCreationRequestHandler();
        userhandler.beforeInsert(bfmuser);
        userhandler.beforeUpdate(bfmuser, bfmuser);
        userhandler.beforeDelete(bfmuser);
        userhandler.bulkAfter();
        userhandler.bulkBefore();
        userhandler.afterInsert(bfmuser);
        userhandler.afterUpdate(bfmuser, bfmuser);
        userhandler.afterDelete(bfmuser);
        delete bfmuser;
        Test.stopTest();
    }
}