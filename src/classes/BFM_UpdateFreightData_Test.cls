@isTest
private class BFM_UpdateFreightData_Test {
    static testMethod void Updatefreight(){
  Account acc= new Account();
    acc.name = 'testname';
    insert acc;
    system.assertEquals('testname', acc.name);
    
    BFM_Shipment__c shipmentRec = new BFM_Shipment__c();
    shipmentRec.Shipment_Number__c='65624565';
    shipmentRec.Carrier_Account__c = acc.id;      
    insert shipmentRec;
    
    BFM_Occurrence__c occ = new BFM_Occurrence__c();
    occ.Carrier_Account__c = acc.id;
    occ.Shipment__c = shipmentRec.id;
    occ.Plate_Number__c = '3453';
    insert occ;
        
    BFM_UpdateFreightData freight = new BFM_UpdateFreightData(shipmentRec.Id);
    BFM_UpdateFreightData occfreight = new BFM_UpdateFreightData(occ.Id);
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
    BFM_UpdateFreightData.sendUpdateShipmentRequestFuture(shipmentRec.Id);
    BFM_UpdateFreightData.send6thFlagUpdate(shipmentRec.Id);
    freight.send6thFlagUpdateRequest();
    Test.stopTest();
    }   
}