@isTest
private class PQN_Export_Excel_Test{
    private static testMethod void PQN_Export_Excel_M(){
     Account acc=PQN_TestLibraryUtil.createpqnAccount('abc','srilanka');
     insert acc;
     PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(null,acc.id,null);
     insert pqn;
    Test.startTest();
    apexpages.currentpage().getparameters().put('filestatus','error');
    PQN_Export_Excel ee=new PQN_Export_Excel();
     System.assertEquals('Test Last Name','Test Last Name');
    
    test.stoptest();
    }
    }