@isTest
public class BFM_ShipmentDocumentGeneration_Test {
    	
	private static testMethod void BFM_shipmentDocumentGenerationTestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        BFM_Shipment__c bfmship = new BFM_Shipment__c(Shipment_Number__c='12345678',Carrier_Account__c=acc.Id);
        insert bfmship;
        Id shipmentId;
        shipmentId = bfmship.Id;
        BFM_Stage__c bfmstage = new BFM_Stage__c();
        bfmstage.Stage_Number__c = '2';
        bfmstage.Shipment__c = bfmship.Id;
        insert bfmstage;
        
        BFM_SES__c bfmses = new BFM_SES__c();
  		bfmses.SES_Number__c = '1234';
        bfmses.Stage__c = bfmstage.Id;
       	insert bfmses;
        
       	ApexPages.StandardController sc = new ApexPages.StandardController(bfmship);
        BFM_ShipmentDocumentGeneration_CC ship = new BFM_ShipmentDocumentGeneration_CC(sc);
        ship.getNFes();
    }
}