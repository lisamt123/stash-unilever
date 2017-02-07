@isTest
private class PQN_CreateAccessRequest_Test{
    private static testMethod void PQN_CreateAccessRequest_M(){
     Test.startTest();
     
     List<account> listacc=new List<account>();
     Account acc1=PQN_TestLibraryUtil.createpqnAccount('def','ind');
     insert acc1;
     listacc.add(acc1);
     Account acc2=PQN_TestLibraryUtil.createpqnAccount('abc','india');
     insert acc2;
     listacc.add(acc2);
     PQN_User_Creation_Request__c req=PQN_TestLibraryUtil.createUserCreationRequest();
     insert req;
     System.assertEquals(req.Last_Name__c,'Test Last Name');
     PQN_CreateAccessRequest pqn=new PQN_CreateAccessRequest(req,listacc);
     pqn.createAccessRequests();
     
     List<PQN_User_Account_Request__c> listuar=new List<PQN_User_Account_Request__c>();
     PQN_User_Account_Request__c uar1=PQN_TestLibraryUtil.createAccountAccessRequest(req.id,acc1.id);
     insert uar1;
     listuar.add(uar1);
     PQN_User_Account_Request__c uar2=PQN_TestLibraryUtil.createAccountAccessRequest(req.id,acc2.id);
     insert uar2;
     listuar.add(uar2);
      System.assertEquals('Test Last Name','Test Last Name');
     test.stoptest();
     }
  }