@isTest
private class BFM_QueryFreightsRequest_Test{
    private static testMethod void testQueryFreightsRequest(){
        
        Account acc= new Account();
        acc.name = 'testname';
        test.startTest();
        insert acc;
        system.assertEquals('testname', acc.name);
        
        BFM_Shipment__c shipmentRec = new BFM_Shipment__c();
        shipmentRec.Shipment_Number__c='65624565';
        shipmentRec.Carrier_Account__c = acc.id;
        insert shipmentRec;
        
        set<string> setShipment = new set<string>();
        BFM_Shipment__c shipmentty = new BFM_Shipment__c();
        shipmentty.Shipment_Number__c='656245656';
        shipmentty.Carrier_Account__c = acc.id;
        string shipnumber = '656245656';    
        setshipment.add(shipnumber);        
        insert shipmentty;
               
        string query = 'Test';
        
        BFM_QueryFreightsRequest queryfrieght = new BFM_QueryFreightsRequest(setShipment,query);
        test.stopTest();       
    }
}