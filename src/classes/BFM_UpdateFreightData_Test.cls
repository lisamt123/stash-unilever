@isTest
public class BFM_UpdateFreightData_Test {
    private static testMethod void bfm_updateFreightDataTestMethod(){
    Account acc = new Account();
    acc.Name = 'TestAccount';
    insert acc;
   	BFM_Shipment__c ship = new BFM_Shipment__c();
    ship.Carrier_Account__c = acc.id;
    ship.Shipment_Number__c = '4567543554';
    insert ship;
	Test.StartTest();
    BFM_UpdateFreightData updatefreight = new BFM_UpdateFreightData(ship.Id);
    BFM_UpdateFreightData.send6thFlagUpdate(ship.Id);
	Test.StopTest();
    }
}