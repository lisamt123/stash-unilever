@isTest
public class DMS_WaveRestCall_Test {

     static testMethod void test() {
        Test.setMock(HttpCalloutMock.class, new DMS_WebServiceMockGenerator_Test());
        Test.startTest();
         
        DMS_WaveRestCall_CC vCall = new DMS_WaveRestCall_CC();
        DMS_WaveRestCall_CC.getRecords('','','');
         
        Test.stopTest();
         
     }

    
}