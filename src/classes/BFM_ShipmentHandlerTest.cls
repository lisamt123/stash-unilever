@isTest
private class BFM_ShipmentHandlerTest{
private static testMethod void testShipmentHandler(){
 	Test.startTest();
 	Account acc = BFM_TestUtils.createCarrierAccount();
    acc.cnpj__c = '03189042000100';
    acc.Vendor__c='11';
    acc.Company_Code__c='12';
    insert acc;
    system.assertEquals('11',acc.Vendor__c);
 	BFM_Shipment__c shipment=new BFM_Shipment__c();
 	shipment.Shipment_Number__c='12378';
 	shipment.Carrier_Account__c=acc.id;
    shipment.Company_Code__c = '12';
    shipment.Vehicle_Plate__c = '123';
    shipment.X6th_flag__c = false;
 	insert shipment;
 	shipment.ANTT__c='11223344';
 	shipment.X6th_flag__c = true;
// new Http().send(request);
	shipment.Vehicle_Plate__c='1234';
 	update shipment;
 
 	BFM_ShipmentHandler ship=new BFM_ShipmentHandler();
 	//ship.bulkAfter();
 	ship.beforeInsert(shipment);
 	//ship.beforeUpdate(shipment, shipment);
 	//ship.beforeDelete(shipment);
 	//ship.afterInsert(shipment);
 	//ship.afterDelete(shipment);
	Test.stopTest();
}
}