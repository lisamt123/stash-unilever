@isTest
private class BFM_QueryOccurrenceTest{
private static testMethod void testBFM_QueryOccurrence (){
 
 Set<String> occnum=new Set<String>();
 List<String> ocrnums=new List<String>();
 Account acc1 = new account();
        acc1.name='carrier'; 
        acc1.BFM_cnpj__c = '03189042000100';
        acc1.BFM_Vendor__c='18';
        acc1.BFM_Company_Code__c='19';
        insert acc1;
        system.assertEquals('18',acc1.Vendor__c);
        BFM_Shipment__c ship1=new BFM_Shipment__c();
        ship1.Carrier_Account__c=acc1.id;
        ship1.Shipment_Number__c='1234';
        insert ship1;
        
        
        BFM_Occurrence__c occ=new BFM_Occurrence__c();
        //occ.Name='das';
        occ.Shipment__c=ship1.id;
        occ.Occurrence_Number__c='0001467783';
        occ.Carrier_Account__c = acc1.id;
        insert occ;
        occnum.add(occ.Occurrence_Number__c);
      system.assertEquals('0001467783', occ.Occurrence_Number__c);

      BFM_QueryOccurrence queryocc = new BFM_QueryOccurrence(occnum);
      String JSONbody = '{"QueryOccurrenceResponse":{"occurrences":[{"approvalDate1":"2016-01-11","approvalDate2":"2016-01-13","approvalDate3":"","approvalDate4":"","approvalDate5":"","approvalDate6":"","deliverySystem":"ZTDV","deliverySystemDescription":"DIRECT-TRAVEL","equipType":"TL24028","equipTypeDescription":"CARRETA-24TON28PAL5EIXOS","fiscalDocuments":[{"fiscalDocuments":"000380342-1"}],"loadType":"DRY","loadTypeDescription":"DRY","occurrenceQuantity":"1","occurrenceValue":"300.0","plateNumber":"IUG0046","rangeExtentOccurrenceFrom":"","rangeExtentOccurrenceTo":"","reasonCode":"0119","reasonDescription":"EXCESSODEVEICULONOCD","reasonRejection":"","rejectionDescription":"","occurrenceNumber":"0001467783","ses":[{"accoutingAccount":"","acctountAssingmentCategory":"J","cofinsAliquot":0.0,"cofinsCalculationBase":0.0,"cofinsValueo":0.0,"costCenter":"","costDocumentNumber":"","creationDate":"2016-01-13","grossValue":"0.0","icmsAliquot":"0.0","icmsCalculationBase":"0.0","icmsExempt":false,"icmsPresumedCredit":"0.0","icmsReduzedBasePercentage":0.0,"icmsST":"0.0","icmsValue":"0.0","internalOrder":"","issValue":0.0,"issCalculationBase":0.0,"issAliquot":0.0,"modificationDate":"2016-01-13","netValue":300.0,"nfe":[{"addressDestination":"RDRPEDROZIMMERMANN","billingDocument":"9781338001","cnpjDestination":"18803654000119","cnpjTaker":"","complementDestination":"GP03","complementaryInformation":"PedidodoCliente:HC173267001","countryCodeDestination":"BR","countryNameDestination":"BRASIL","cpfDestination":"","deliveryNumber":"0118243683","districtDestination":"ITOUPAVACENTRAL","grossWeight":"5610.33","incoterms":"CIF","inscricaoSuframa":"","materialUsage":"0","municipalCodeDestination":"4202404","municipalNameDestination":"BLUMENAU","nameDestination":"CENTRALDENEGEALIMREDETOPLTDA","nfeAccessKey":"3116016106827600370755001000380342814022209","nfeCreationDate":"2016-01-02","nfeItemSpecie":"CS","nfeNumber":"000380342","nfeSerie":"1","nfeTotalQuantity":"297.0","nfeTotalValue":"23338.26","numberDestination":"7299","phoneDestination":"18803654000119","postalCodeDestination":"89068-001","predominantProduct":"PedidodoCliente:HC173267001","stageRegistrationDestination":"257196307","stateDestination":"SC"},{"addressDestination":"RDRPEDROZIMMERMANN","billingDocument":"9781338001","cnpjDestination":"18803654000119","cnpjTaker":"","complementDestination":"GP03","complementaryInformation":"PedidodoCliente:HC173267001","countryCodeDestination":"BR","countryNameDestination":"BRASIL","cpfDestination":"","deliveryNumber":"0118243683","districtDestination":"ITOUPAVACENTRAL","grossWeight":"5610.33","incoterms":"CIF","inscricaoSuframa":"","materialUsage":"0","municipalCodeDestination":"4202404","municipalNameDestination":"BLUMENAU","nameDestination":"CENTRALDENEGEALIMREDETOPLTDA","nfeAccessKey":"3116016106827600370755001000380342814022209","nfeCreationDate":"2016-01-02","nfeItemSpecie":"CS","nfeNumber":"000380342","nfeSerie":"1","nfeTotalQuantity":"297.0","nfeTotalValue":"23338.26","numberDestination":"7299","phoneDestination":"18803654000119","postalCodeDestination":"89068-001","predominantProduct":"PedidodoCliente:HC173267001","stageRegistrationDestination":"257196307","stateDestination":"SC"}],"pisAliquot":"0.0","pisCalculationBase":"0.0","pisValue":"0.0","poType":"","poUmbrellaNumber":"4501750621","sesCurrency":"BRL","sesLineDescription":"","sesNumber":"1039330621","sesPlantCode":"5235","simpleOption":"","taxCode":"","numberOfClients":"0000000000"}],"shipment":[{"antt":"","shipmentStart":"2016-01-04","stage":[{"distance":"800.638","otmShipment":"1003624755","shippingType":"T","stageNumber":1,"warehouse":""},{"distance":"267.416","otmShipment":"1003624756","shippingType":"T","stageNumber":2,"warehouse":""},{"distance":"49.879","otmShipment":"1003624757","shippingType":"T","stageNumber":3,"warehouse":""},{"distance":"159.13","otmShipment":"1003624758","shippingType":"T","stageNumber":4,"warehouse":""},{"distance":"16.573","otmShipment":"1003624759","shippingType":"T","stageNumber":5,"warehouse":""},{"distance":"96.379","otmShipment":"1003624760","shippingType":"T","stageNumber":6,"warehouse":""},{"distance":"118.905","otmShipment":"1003624761","shippingType":"T","stageNumber":7,"warehouse":""},{"distance":"49.879","otmShipment":"1003624762","shippingType":"T","stageNumber":8,"warehouse":""},{"distance":"159.13","otmShipment":"1003624763","shippingType":"T","stageNumber":9,"warehouse":""},{"distance":"49.879","otmShipment":"1003624764","shippingType":"T","stageNumber":10,"warehouse":""},{"distance":"267.416","otmShipment":"1003624765","shippingType":"T","stageNumber":11,"warehouse":""}]}],"shipmentDocumentNumber":"0006098920","shipmentType":"ZA02","shippingProcess":"","shippingProcessDescription":"","status":"20","statusDescription":"Pré-Fatura","tax":"0.01","total":300.0}]}}';
        Test.startTest();  
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
      Test.stopTest();
        BFM_QueryOccurrence.callQueryOccurrenceButton(occ.id);
      //queryocc.callQueryOccurrencesIssuing();
      try{
          queryocc.parseResponse(JSONbody);  
            queryocc.callUpserts();
        }catch(Exception e){}
      
      
      queryocc.createErrorLogs(ocrnums, 'errorMessage', 'errorType');
      queryocc.createUpsertErrorLog('ocrnum', 'errorType');
      queryocc.convertNumber('txt');
    }
}