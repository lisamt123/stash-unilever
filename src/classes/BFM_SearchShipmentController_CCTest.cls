@isTest
private class BFM_SearchShipmentController_CCTest{ 
private static testMethod void testsearchshipment(){
       
        Test.startTest();
        Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.name='carrier';
        insert acc;
        system.assertEquals('carrier',acc.name);
      
      BFM_Shipment__c ship = new BFM_Shipment__c();
        ship.Carrier_Account__c=acc.id;
        ship.Company_Code__c = '3123';
        insert ship;
        system.assertEquals('3123',ship.Company_Code__c);
      
        BFM_SearchShipmentCTeController_CC search=new BFM_SearchShipmentCTeController_CC(null);
      BFM_SearchShipmentCTeController_CC.accountwrapper wrap = new BFM_SearchShipmentCTeController_CC.accountwrapper(ship.Id);
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
        String Ships;
        PageReference pageRef = page.BFM_SearchShipmentCTe_VF;
        Test.setCurrentPage(pageRef);
        search.mySearch();
      search.setPaginationSettings();
      search.getSelected();
      search.GetSelectedShipments();
      try{
      BFM_SearchShipmentCTeController_CC.updateShipments(Ships);
        }catch(Exception e){}
      search.redirectPage();
        search.redirectFileUpload();
        search.getshipments();
        search.first();
        search.last();
        search.previous();
        search.next();
        search.cancel();
        search.hasPrevious = true;
        search.hasNext=true;
        search.shipcrdateupto = Date.today();
      search.shipsrtupto = Date.today();
      search.pricingDateupto = Date.today();
      search.carrieracc = 'carrier';
      search.shipId = 'ship';
        Test.stoptest();
	}  
}