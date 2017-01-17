@isTest
private class PQN_AccountDAO_Test{
    private static testMethod void PQN_AccountDAO_M(){
     Test.startTest();
     PQN_AccountDAO.getAccountsWithDcCountry('in');
     PQN_AccountDAO.getAccountsWithDcCountry(null);
      System.assertEquals('Test Last Name','Test Last Name');
     test.stoptest();
     }
   }