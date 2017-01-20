@isTest
private class BFM_ShipmentUpdate_CCTest {
private static testMethod void testNFSHandler(){
 Test.startTest();
 Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        insert acc;
        system.assertEquals('11',acc.Vendor__c);
        
         ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        BFM_ShipmentUpdate_CC ship= new BFM_ShipmentUpdate_CC(sc);
        
        PageReference pageRef = Page.BFM_ShipmentUpdate_VF;
        pageRef.getParameters().put('id', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);
        
        //BFM_ShipmentUpdate_CC ship=new BFM_ShipmentUpdate_CC(acc);
        ship.updateAcc();
 Test.stopTest();
}
}