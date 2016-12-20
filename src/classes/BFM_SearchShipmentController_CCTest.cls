@isTest
private class BFM_SearchShipmentController_CCTest{ 
private static testMethod void testsearchshipment(){
       
         Test.startTest();
        Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.name='carrier';
        insert acc;
        system.assertEquals('carrier',acc.name);
        BFM_SearchShipmentController_CC search=new BFM_SearchShipmentController_CC(null);
        search.shipmentStart=date.newInstance(2016, 8, 23);
        search.shipmentNumber='12345';
        search.unileverCompanyAccountName=acc.id;
        search.carrierCompanyAccountName=acc.id;
        search.unileverCompanyAccountCNPJ='12345678900000';
        search.vendorAccountCNPJ='12345678900000';
        search.plantCode='2010';
        search.recordscount='10';
        search.recordscount='25';
        search.recordscount='50';
        search.recordscount='100';
        
         PageReference pageRef = page.BFM_SearchShipment_VF;
        Test.setCurrentPage(pageRef);
        search.mySearch();
        search.resetSearch();
        search.redirectFileUpload();
        search.getshipments();
        search.first();
        search.last();
        search.previous();
        search.next();
        search.cancel();
        search.hasPrevious = true;
        search.hasNext=true;
          
        Test.stoptest();
}  
}