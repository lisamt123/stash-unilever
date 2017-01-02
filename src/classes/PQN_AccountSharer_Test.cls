@isTest
private class PQN_AccountSharer_Test {
    private static testMethod void myTestmethod(){
    User u =PQN_TestLibraryUtil.createPQNUser();
    insert u;
      Account acc=PQN_TestLibraryUtil.createpqnAccount('DC1','India');
      insert acc;
      set<id> accid=new set<id>();
      accid.add(acc.id);
     Test.startTest();
     PQN_AccountSharer acct=new PQN_AccountSharer ();
     acct.shareAccountsReadOnly(u.id,accid);
     Test.stopTest();
     }
     }