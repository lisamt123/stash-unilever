@isTest
private class PQN_CheckDeleteTest{
    private static testMethod void testPQN_CheckDelete(){
  
    user usr=PQN_TestLibraryUtil.createPQNUser();
    insert usr;
    
     PQN_Supplier__c  supplier=PQN_TestLibraryUtil.createSupplier();
    insert supplier;
    
    PQN_DC_Volumes__c dcvolume=PQN_TestLibraryUtil.createDCvolumes();
    insert dcvolume;
    
    Account acc=PQN_TestLibraryUtil.createpqnAccount('abc','srilanka');
    insert acc;
    
    
     PQN_Pallet_Quality_Non_Conformance__c PQN1 = PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
     insert PQN1;
    
    

    ApexPages.StandardController sc = new ApexPages.standardController(PQN1);
    PQN_CheckDelete a = new PQN_CheckDelete(sc);

    Test.startTest();
    PageReference track = a.checkDelete();
    Test.stopTest();

   
   
    }
    }