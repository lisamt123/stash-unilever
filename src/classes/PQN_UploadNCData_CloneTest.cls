@isTest 
private class PQN_UploadNCData_CloneTest {
    static testMethod void PQN_M1() {    
          Account acc=new account();
          acc.name='Error DC';
          insert acc;
            PQN_DC_Volumes__c dcv=PQN_TestLibraryUtil.createDCvolumes();
     insert dcv;
     PQN_Supplier__c  sup=PQN_TestLibraryUtil.createSupplier();
     insert sup;
          
           PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,dcv.id);
     insert pqn;
     
        test.starttest();
            List<PQN_Pallet_Quality_Non_Conformance__c> xPQN = new List<PQN_Pallet_Quality_Non_Conformance__c>();
            PQN_UploadNCData_Clone pU = new PQN_UploadNCData_Clone();
            PQN_UploadNCData_Clone.getSheetData(xPQN,'Unilever');
            PQN_UploadNCData_Clone.getSheetStatus('902102912');
            
        test.stoptest();
    
    }

}