@isTest
private class BFM_ShipmentHandlerTest{
private static testMethod void testShipmentHandler(){
    //Test.startTest();
    RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName = 'BFM_Unilever_Account' Limit 1];
    Account acc = BFM_TestUtils.createCarrierAccount();
    acc.BFM_cnpj__c = '03189042000100';
    acc.RecordTypeId = unileverAccount.id;
    acc.BFM_Vendor__c='11';
    acc.BFM_Company_Code__c='12';
    insert acc;
    system.assertEquals('11',acc.BFM_Vendor__c);
    
    BFM_Shipment__c shipment=new BFM_Shipment__c();
    shipment.Shipment_Number__c='12378';
    shipment.Carrier_Account__c=acc.id;
    shipment.Company_Code__c = '12';
    shipment.Vehicle_Plate__c = '123';
    shipment.X6th_flag__c = false;
    insert shipment;
    BFM_NF_e__c nfe = new  BFM_NF_e__c();
    nfe.Shipment__c = shipment.id;
    nfe.NF_e_access_key__c = '12345678901234567890123456789012345678901234';
    insert nfe;
    shipment.ANTT__c='11223344';
    shipment.X6th_flag__c = true;
    shipment.X6th_flag_Updated_Date__c = system.now();
    shipment.Vehicle_Plate__c='1234';
    update shipment;
    
    BFM_ShipmentHandler shipHandler = new BFM_ShipmentHandler();
    BFM_ShipmentHandlerActions shiphandleraction = new BFM_ShipmentHandlerActions();
    shipHandler.bulkAfter();
    shipHandler.beforeDelete(shipment);
    shipHandler.afterInsert(shipment);
    shipHandler.afterUpdate(shipment,shipment);
    shipHandler.afterDelete(shipment);
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
    BFM_ShipmentHandlerActions shiphandleraction1 = new BFM_ShipmentHandlerActions();
    BFM_UpdateFreightData.send6thFlagUpdate(shipment.Id);
    BFM_UpdateFreightData.sendUpdateShipmentRequestFuture(shipment.Id);
    Test.stopTest();
    }
}