@isTest
private class PQN_DC_VoulmesTest{
    private static testMethod void testPQN_DC_Voulmes_M1(){
     Test.startTest();
      PQN_DC_Volumes__c dcv=PQN_TestLibraryUtil.createDCvolumes();
    
         // dcv.Total_Pallets_Checked_By_DC__c=000000;
          //dcv.Total_Pallets_received_by_DC__c=000000;
          insert dcv;
           ApexPages.StandardController sc = new ApexPages.StandardController(dcv);
           PQN_DC_Voulmes testDCV = new PQN_DC_Voulmes(sc);
            testDCV.saveDCV();
            testDCV.cancelDCV();
        
           Apexpages.currentpage().getparameters().put('id',dcv.id);
           ApexPages.StandardController sc1 = new ApexPages.StandardController(dcv);
           PQN_DC_Voulmes testDCV1 = new PQN_DC_Voulmes(sc1);
            testDCV1.saveDCV();
            testDCV1.cancelDCV();
            //test
          
     test.stoptest();
     }
  }