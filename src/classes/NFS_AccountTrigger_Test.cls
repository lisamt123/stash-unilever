@isTest
private class NFS_AccountTrigger_Test {
    static testMethod void AccountUnitTest() {
      
         Test.startTest();
        Account acc= new Account();
        acc.Name = 'Test Customer';
        
        insert acc;
        Test.stopTest();
        
        }
}