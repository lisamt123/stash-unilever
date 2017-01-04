@isTest
private class PQN_updateTAR_Test{
private static  testmethod void mytest(){
     PQN_DC_Volumes__c dcv=PQN_TestLibraryUtil.createDCvolumes();
     insert dcv;
     PQN_Supplier__c  sup=PQN_TestLibraryUtil.createSupplier();
     insert sup;

     account acc=PQN_TestLibraryUtil.createpqnAccount('DC1','India');
     insert acc;
     PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,dcv.id);
     pqn.Targets__c =null;
     insert pqn;
     PQN_Targets__c tar=PQN_TestLibraryUtil.createtargets();
     insert tar;
     
    /*test.starttest();
    system.debug('PQN--->>>'+ [select id,Date_Pallet_Received__c,Year__c,Month__c,Reporting_DC__c,Region__c,DC_Country__c,Targets__c from PQN_Pallet_Quality_Non_Conformance__c where id=:pqn.id]);
    system.debug('aaa'+pqn.Year__c+pqn.DC_Country__c+pqn.Region__c);
    system.debug('bbb'+tar.Year__c+tar.Geography__c+tar.Region__c);
    test.stoptest();*/
}
}