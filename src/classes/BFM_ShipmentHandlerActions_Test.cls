@isTest
private class BFM_ShipmentHandlerActions_Test {
        static testMethod void testShipmentHandlerActions(){
        
        Test.startTest();
        RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName = 'BFM_Unilever_Account' Limit 1];
        Account acc = New Account();
        acc.RecordTypeId = unileverAccount.id;
        acc.BFM_CNPJ__c = '03189042000100';
        acc.BFM_Vendor__c='11';
        acc.BFM_Company_Code__c='12';
        acc.Name = 'TestAccount';
        insert acc;
        system.assertEquals('11',acc.BFM_Vendor__c);
        BFM_Shipment__c shipment=new BFM_Shipment__c();
        shipment.Shipment_Number__c='12378';
        shipment.Carrier_Account__c=acc.id;
        shipment.Is_Deleted_in_SAP__c = true;
        shipment.Vehicle_Plate__c = '1234';
        shipment.Shipment_Start__c = Date.today();
        insert shipment;
   
        BFM_Occurrence__c occ = new BFM_Occurrence__c();
        occ.Carrier_Account__c =acc.id;
        occ.Shipment__c = shipment.id;
        occ.Plate_Number__c = '2235674';
        insert occ;
        BFM_Shipment__c sh =[SELECT Vehicle_Plate__c, Shipment_Number__c,Shipment_Start__c FROM BFM_Shipment__c WHERE Id =:shipment.Id LIMIT 1];
        BFM_Occurrence__c oc =[SELECT Plate_Number__c FROM BFM_Occurrence__c where Id =:occ.Id LIMIT 1]; 
        List<BFM_Shipment__c> shipmentNewLst = new List<BFM_Shipment__c>();
        shipmentNewLst.add(shipment);
        BFM_ShipmentHandlerActions shipactions = new BFM_ShipmentHandlerActions();
        BFM_ShipmentHandlerActions.send6thflag(shipment);
        BFM_ShipmentHandlerActions.defineShipmentUnileverAccount(shipmentNewLst);
        BFM_ShipmentHandlerActions.checkIfNeedsToBeDeleted(shipmentNewLst);      
        Test.stopTest();            
    }
}