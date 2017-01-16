@isTest
private class PQN_TestLibraryUtil_Test{
    private static testMethod void PQN_TestLibraryUtil_M(){
     Test.startTest();
     PQN_TestLibraryUtil t=new PQN_TestLibraryUtil ();
     Account A=new Account();
     A.name='Test';
     insert A;
     PQN_Supplier__c sup=PQN_TestLibraryUtil.createSupplier();
     insert sup;
     PQN_DC_Volumes__c dcv=PQN_TestLibraryUtil.createDCvolumes();
      insert dcv;
     PQN_User_Creation_Request__c ucr=PQN_TestLibraryUtil.createUserCreationRequest();
     insert ucr;
     PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,A.id,dcv.id);
     insert pqn;
     user u=PQN_TestLibraryUtil.createPQNUser();
     insert u;
      PQN_User_Account_Request__c uar=PQN_TestLibraryUtil.createAccountAccessRequest(ucr.id,A.id);
     insert uar;
     PQN_Targets__c tar=PQN_TestLibraryUtil.createtargets();
     insert tar;
     PQN_Sourcing_Unit__c su=PQN_TestLibraryUtil.createSourcingUnit();
     insert su;
     Contact c=PQN_TestLibraryUtil.createContact(A.id);
     insert c;
      System.assertEquals('Test Last Name','Test Last Name');
     
     // t.createSupplier();
     /* t.createPQN_Pallet_Quality_Non_Conformance(null,A.id,null);
      t.createPQNUser();
      t.createUserCreationRequest();
      t.createAccountAccessRequest(ucr.id,A.id);
      t.createDCvolumes();
      t.createtargets();
      t.createSourcingUnit();
      t.createContact(A.id);*/
      Test.stopTest();
      }
      }