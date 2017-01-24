@isTest
private class PQN_updateSUP_Test{
private static  testmethod void mytest(){
     PQN_DC_Volumes__c dcv=PQN_TestLibraryUtil.createDCvolumes();
     insert dcv;
     PQN_Supplier__c  sup=PQN_TestLibraryUtil.createSupplier();
     insert sup;

     account acc=PQN_TestLibraryUtil.createpqnAccount('DC1','India');
     insert acc;
     PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,dcv.id);
     insert pqn;
     
     
     
   
}
}