@isTest 
private class PQN_UploadNCData_CloneTest {
    static testMethod void PQN_M1() {    
  
        test.starttest();
            List<PQN_Pallet_Quality_Non_Conformance__c> xPQN = new List<PQN_Pallet_Quality_Non_Conformance__c>();
            PQN_UploadNCData_Clone pU = new PQN_UploadNCData_Clone();
            PQN_UploadNCData_Clone.getSheetData(xPQN);
            PQN_UploadNCData_Clone.getSheetStatus('902102912');
            
        test.stoptest();
    
    }

}