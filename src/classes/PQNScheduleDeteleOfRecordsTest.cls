@isTest
private class PQNScheduleDeteleOfRecordsTest{
    private static testMethod void testPQNScheduleDeteleOfRecords (){
    Test.startTest();
    SchedulableContext SC3;

    
    PQN_Supplier__c  supplier=PQN_TestLibraryUtil.createSupplier();
    insert supplier;
    
    PQN_DC_Volumes__c dcvolume=PQN_TestLibraryUtil.createDCvolumes();
    insert dcvolume;
    
    Account acc=PQN_TestLibraryUtil.createpqnAccount('abc','srilanka');
    insert acc;
   
     list<PQN_Pallet_Quality_Non_Conformance__c > pqnList1 = new list<PQN_Pallet_Quality_Non_Conformance__c >();
     PQN_Pallet_Quality_Non_Conformance__c PQN1 = PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
     
     insert PQN1 ;
     
     PQNScheduleDeteleOfRecords shcedule=new PQNScheduleDeteleOfRecords();
     shcedule.execute(SC3);
     
     test.stoptest();
    }
    }