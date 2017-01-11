@isTest
private class PQN_updateDCV_Test{
private static testmethod void mytest(){
     
     PQN_Supplier__c  sup=PQN_TestLibraryUtil.createSupplier();
     insert sup;
     account acc=PQN_TestLibraryUtil.createpqnAccount('DC1','India');
     insert acc;
     PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,null);
     insert pqn;
     PQN_DC_Volumes__c dcv=PQN_TestLibraryUtil.createDCvolumes();
     insert dcv;
     list<PQN_Pallet_Quality_Non_Conformance__c > listpqn=new list<PQN_Pallet_Quality_Non_Conformance__c >();
     listpqn.add(pqn);
     list<PQN_DC_Volumes__c > listdcv=new list<PQN_DC_Volumes__c >();
     listdcv.add(dcv);

   test.starttest();
   PQN_updateDCV pqn1=new PQN_updateDCV();
   system.debug('abcd'+pqn.Month__c+pqn.Year__c+pqn.Reporting_DC__c+pqn.DC_Volumes__c);
   system.debug('efg'+dcv.Month__c+dcv.Year__c+dcv.Reporting_DC__c);
   //pqn.update_DCV(listdcv);
   test.stoptest();
   }
   }