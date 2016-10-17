@isTest
private class BFM_QueryFreightsTest{
private static testMethod void testBFM_QueryFreights(){
 Test.startTest();
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
        
        BFM_QueryFreights.callQueryFreightsButton(ship1.id);
        BFM_QueryFreights query=new BFM_QueryFreights(shipnum);
        query.isSuccess();
        query.getErrorMessage();
        query.callQueryFreightsCTeIssuing();
        
 Test.stopTest();
}
}