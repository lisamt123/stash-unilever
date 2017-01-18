@isTest
private class BFM_SearchShipmentController_CCTest{ 
private static testMethod void testsearchshipment(){
       
         Test.startTest();
        Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.name='carrier';
        insert acc;
        system.assertEquals('carrier',acc.name);
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        BFM_SearchShipmentcteController_CC search=new BFM_SearchShipmentcteController_CC(null);
        
          
        Test.stoptest();
    }
}