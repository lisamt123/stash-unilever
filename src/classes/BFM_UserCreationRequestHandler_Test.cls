@isTest
public class BFM_UserCreationRequestHandler_Test {
    private static testMethod void BFM_UserCreationRequestHandler_TestMethod(){
        Test.startTest();
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,
                          Email ='newuser123@testorg.com',
                          EmailEncodingKey = 'UTF-8',
                          LastName = 'Testing',
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          UserName='newuser1234@testorg.com',
                          ProfileId=p.Id,
                          TimeZoneSidKey='America/Los_Angeles');
        insert u2;

        BFM_UserCreationRequest__c bfmuser = new BFM_UserCreationRequest__c();
        bfmuser.userName__c = 'TestUsername';
        bfmuser.email__c = 'Testuseremail@test.com';
        bfmuser.firstName__c = 'first';
        bfmuser.Operational_User__c = false;
        bfmuser.lastName__c = 'last';
        bfmuser.Tax_User__c=True;
        bfmuser.Finance_User__c = false;
        bfmuser.Created_User__c = u2.Id;
        insert bfmuser;
        
        BFM_UserCreationRequestHandler userhandler=new BFM_UserCreationRequestHandler();
        userhandler.beforeInsert(bfmuser);
        userhandler.beforeUpdate(bfmuser, bfmuser);
        userhandler.beforeDelete(bfmuser);
        userhandler.bulkAfter();
        userhandler.bulkBefore();
        BFM_UserCreationRequestAttachmentCheck attcheck = new BFM_UserCreationRequestAttachmentCheck();
        userhandler.afterInsert(bfmuser);
        userhandler.afterUpdate(bfmuser, bfmuser);
        userhandler.afterDelete(bfmuser);
        delete bfmuser;
        Test.stopTest();
    }
    private static testMethod void BFM_UserCreationRequestHandler_TestMethod1(){
        Test.startTest();
        BFM_UserCreationRequest__c bfmuser = new BFM_UserCreationRequest__c();
        bfmuser.userName__c = 'TestUsername1';
        bfmuser.email__c = 'Testuseremail1@test.com';
        bfmuser.firstName__c = 'first';
        bfmuser.Operational_User__c = false;
        bfmuser.lastName__c = 'last';
        bfmuser.Tax_User__c=True;
        bfmuser.Finance_User__c = false;
        bfmuser.Created_User__c = Userinfo.getUserId();
        insert bfmuser;
        
        BFM_UserCreationRequestHandler userhandler=new BFM_UserCreationRequestHandler();
        userhandler.afterInsert(bfmuser);
        userhandler.afterUpdate(bfmuser, bfmuser);
        userhandler.afterDelete(bfmuser);
        delete bfmuser;
        Test.stopTest();
    }
}