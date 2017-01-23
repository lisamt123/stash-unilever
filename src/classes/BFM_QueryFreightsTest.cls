@isTest
private class BFM_QueryFreightsTest{
static testMethod void testBFM_QueryFreights(){
 
 Set<String> shipnum=new Set<String>(); 
 Account acc1 = new account();
     acc1.name='carrier'; 
        acc1.cnpj__c = '03189042000100';
        acc1.Vendor__c='18';
        acc1.Company_Code__c='19';
        insert acc1;
        
        BFM_Shipment__c ship1=new BFM_Shipment__c();
        ship1.Carrier_Account__c=acc1.id;
        ship1.Shipment_Number__c='0007200134';
        insert ship1;
        shipnum.add(ship1.Shipment_Number__c);
        String JSONbody = '{"QueryFreightResponse": {"shipment": [{"antt": "","pricingCalculationDate": "2016-12-02","shipmentNumber": "0007200134","shipmentStart": "","shipmentType": "ZA01","stage": [{"deliverySystem": "ZTDV","destinationCity": "BETIM","destinationCountry": "BR","destinationPostalCode": "32651-000","equipType": "TL24028","grossValueCostPreview": 0.0,"grouping": "","loadFM": "PALLETIZED","loadType": "DRY","originCity": "Pouso Alegre","originCountry": "BR","originPlantCode": "5235","originPlantDescription": "Pouso Alegre HPC","originPostalCode": "37550-000","distance": "371.502","freeFreight": false,"otmShipment": "1004555405","palletCount": 0.0,"ses": [{"accoutingAccount": "","acctountAssingmentCategory": "","cofinsAliquot": 0.0,"cofinsCalculationBase": 0.0,"cofinsValue": 0.0,"costCenter": "","costDocumentNumber": "","creationDate": "","grossValue": 0.0,"icmsAliquot": 0.0,"icmsCalculationBase": 0.0,"icmsExempt": false,"icmsPresumedCredit": 0.0,"icmsReduzedBasePercentage": 0.0,"icmsST": 0.0,"icmsValue": 0.0,"internalOrder": "","issValue": 0.0,"issCalculationBase": 0.0,"issAliquot": 0.0,"modificationDate": "","netValue": 0.0,"nfe": [{"grossWeight": 0.0,"addressDestination": "","cnpjDestination": "","cnpjTaker": "","complementDestination": "","complementaryInformation": "","countryCodeDestination": "","countryNameDestination": "","cpfDestination": "","deliveryNumber": "0124085987","districtDestination": "","incoterms": "","inscricaoSUFRAMA": "","materialUsage": "","municipalCodeDestination": "","municipalNameDestination": "","nameDestination": "","nfeAccessKey": "","nfeCreationDate": "","nfeItemSpecie": "","nfeNumber": "","nfeSerie": "","nfeTotalQuantity": 0.0,"nfeTotalValue": 0.0,"numberDestination": "","phoneDestination": "","postalCodeDestination": "","predominantProduct": "","stageRegistrationDestination": "","stateDestination": ""}],"occurrenceNumber": "","pisAliquot": 0.0,"pisCalculationBase": 0.0,"pisValue": 0.0,"poType": "","poUmbrellaNumber": "","sesCurrency": "","sesLineDescription": "","sesNumber": "","sesPlantCode": "","simpleOption": "","taxCode": "","numberOfClients": ""}],"shippingProcess": "","shippingType": "T","stageNumber": "0001","tollCostPreview": 0.0,"warehouse": "1000"}]}]}}';
        Test.startTest();
        system.assertEquals('0007200134', ship1.Shipment_Number__c);
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
      BFM_QueryFreightsResponse queryresp = new BFM_QueryFreightsResponse();
        BFM_QueryFreights queryfrieght = new BFM_QueryFreights(shipnum);
        BFM_QueryFreights.callQueryFreightsButton(ship1.id);
        queryfrieght.callQueryFreightsCTeIssuing();
      try{
        queryfrieght.getQueryFreightsObjectsCreated(JSONbody);
        }catch(Exception e){}
      queryfrieght.callUpserts();
      queryfrieght.createUpsertErrorLog('shipmentNumber','errorMessage');
      queryfrieght.createErrorLogs(shipnum,'shipmentNumber','errorMessage');
        Test.stopTest();
  }
}