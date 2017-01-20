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
        ship1.Shipment_Number__c='1234';
        insert ship1;
        shipnum.add(ship1.Shipment_Number__c);
        String JSONbody;
        Test.startTest();
        system.assertEquals('1234', ship1.Shipment_Number__c);
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
      BFM_QueryFreightsResponse queryresp = new BFM_QueryFreightsResponse();
        BFM_QueryFreights queryfrieght = new BFM_QueryFreights(shipnum);
        BFM_QueryFreights.callQueryFreightsButton(ship1.id);
        queryfrieght.callQueryFreightsCTeIssuing();
      try{
        //queryfrieght.getQueryFreightsObjectsCreated(JSONbody);
        }catch(Exception e){}
      //queryfrieght.callUpserts();
      //queryfrieght.createUpsertErrorLog('shipmentNumber','errorMessage');
      //queryfrieght.createErrorLogs(shipnum,'shipmentNumber','errorMessage');
        Test.stopTest();
  }
}