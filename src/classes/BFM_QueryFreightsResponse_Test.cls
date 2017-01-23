@isTest
public class BFM_QueryFreightsResponse_Test{
    private static testMethod void testQueryFreightsRequest(){
         
         Account acc= new Account();
         acc.name = 'testname';
         test.startTest();
         system.assertEquals('testname', acc.name);
         insert acc;
         
         set<string> setShipment = new set<string>();
         BFM_Shipment__c shipmentty = new BFM_Shipment__c();
         shipmentty.Shipment_Number__c='656245656';
         shipmentty.Shipment_Number__c='12345';
         shipmentty.Shipment_Type__c='gw';
         shipmentty.ANTT__c='string';
         shipmentty.Carrier_Account__c = acc.id;
         string shipnumber = '656245656';    
         setshipment.add(shipnumber);        
         insert shipmentty;
         
         BFM_Occurrence__c occur = new BFM_Occurrence__c();
         //occur.name='testname';
         occur.Shipment__c = shipmentty.id;
         occur.Carrier_Account__c = acc.id;
         insert occur;
                          
         BFM_SES__c ses = new BFM_SES__c();
         ses.SES_Number__c='123454566';
         ses.PO_Type__c='12345678900000';
         ses.SES_Plant_Code__c='12';
         ses.Occurrence__c=occur.id;
         insert ses;         
                 
         BFM_Stage__c newST = new BFM_Stage__c();
         newST.Shipment__c=shipmentty.id;
         newST.Stage_Number__c='563546';
         newST.Origin_city__c='ABC';
         newST.Origin_country__c='xyz';
         insert newST;             
        
         BFM_QueryFreightsResponse response = new BFM_QueryFreightsResponse();
         BFM_QueryFreightsResponse.Ses wrapse = new BFM_QueryFreightsResponse.Ses();
         wrapse.sesNumber = 'test';
         wrapse.poUmbrellaNumber = 'test';
         wrapse.poType = 'test';
         wrapse.creationDate = 'test';
         wrapse.modificationDate = 'test';
         wrapse.grossValue = 0.05;
         wrapse.taxCode = 'test';
         wrapse.icmsPresumedCredit = 0.10;
         wrapse.icmsST = 0.10;
         wrapse.icmsValue = 10.9;
         wrapse.icmsCalculationBase = 8.0;
         wrapse.icmsAliquot = 1.5;
         wrapse.pisValue = 2.5;
         wrapse.pisCalculationBase = 2.5;
         wrapse.pisAliquot = 2.5;
         wrapse.cofinsValue = 2.5;
         wrapse.cofinsCalculationBase = 2.5;
         wrapse.cofinsAliquot = 2.5;
         wrapse.simpleOption = 'option';
         wrapse.icmsReduzedBasePercentage = 2.5;
         //wrapse.icmsExempt = 2.5;
         wrapse.netValue = 0.05;
         wrapse.sesCurrency = 'currency';
         wrapse.sesLineDescription = 'sesdesc';
         wrapse.costDocumentNumber = 'costnum';
         wrapse.occurrenceNumber = 'occnum';
         wrapse.acctountAssingmentCategory = 'acccat';
         wrapse.costCenter = 'cc';
         wrapse.sesPlantCode = 'sesplant';
         wrapse.accoutingAccount = 'accc';
         wrapse.internalOrder = 'iorder';
         //wrapse.nfe = 'option';
         BFM_QueryFreightsResponse.Stage wrapse1 = new BFM_QueryFreightsResponse.Stage();
         wrapse1.stageNumber=123345;
         wrapse1.originCity='bangalore';
         wrapse1.originPostalCode='560040';
         wrapse1.originCountry='India';
         wrapse1.originPlantCode='123345';
         wrapse1.originPlantDescription='1233';
         wrapse1.destinationCity='abc';
         wrapse1.destinationPostalCode='123345';
         wrapse1.destinationCountry='123345';
         wrapse1.loadType='df';
         wrapse1.shippingProcess='ff';
         wrapse1.deliverySystem='xyz';
         wrapse1.loadFM='tt';
         wrapse1.equipType='xxx';
         wrapse1.grouping='aaa';
         wrapse1.palletCount=1.2;
         wrapse1.grossValueCostPreview=10.3;
         wrapse1.tollCostPreview=50.3;
         //wrapse1.freeFreight=21.1;
         wrapse1.shippingType='szdd';
         wrapse1.warehouse='xrew';
         wrapse1.otmShipment='pqn';
         //wrapse1.distance=123;        
    }
}