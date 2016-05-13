@isTest
private class NFS_AccountTrigger_Test {
    static testMethod void AccountUnitTest() {
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();   
        Test.startTest();
        Account acc= new Account();
        acc.Name = 'Test Customer';
        acc.RecordTypeid= accountRecordTypeId;
        insert acc;
        Test.stopTest();
        }
}