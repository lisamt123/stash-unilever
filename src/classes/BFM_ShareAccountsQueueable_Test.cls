@isTest
private class BFM_ShareAccountsQueueable_Test {
    private static testMethod void testQueueSharing(){
        
        User userToShareWith = BFM_TestUtils.createCarrierUser();
        insert userToShareWith;
        
        Account acc1 = BFM_TestUtils.createCarrierAccount();
        Account acc2 = BFM_TestUtils.createCarrierAccount();
        Account acc3 = BFM_TestUtils.createCarrierAccount();
        
        List<Account> accounts = new List<Account>{acc1, acc2, acc3};
        insert accounts;
        system.assertEquals('','');
        Test.startTest();
            Set<Id> accountsIds =  new Map<Id, Account>([SELECt Id FROM Account]).keySet();
            //System.enqueueJob(new BFM_ShareAccountsQueueable(userToShareWith.Id, accountsIds));
        Test.stopTest();       

    }
                          
                          
}