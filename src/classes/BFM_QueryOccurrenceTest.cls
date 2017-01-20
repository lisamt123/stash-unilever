@isTest
private class BFM_QueryOccurrenceTest{
private static testMethod void testBFM_QueryOccurrence (){
 
 Set<String> occnum=new Set<String>(); 
 Account acc1 = new account();
     acc1.name='carrier'; 
        acc1.cnpj__c = '03189042000100';
        acc1.Vendor__c='18';
        acc1.Company_Code__c='19';
        insert acc1;
        system.assertEquals('18',acc1.Vendor__c);
          BFM_Shipment__c ship1=new BFM_Shipment__c();
        ship1.Carrier_Account__c=acc1.id;
        ship1.Shipment_Number__c='1234';
        insert ship1;
        
        
        BFM_Occurrence__c occ=new BFM_Occurrence__c();
        //occ.Name='das';
        occ.Shipment__c=ship1.id;
        occ.Occurrence_Number__c='3123';
        insert occ;
        
        occnum.add(occ.Occurrence_Number__c);
        
        Test.startTest();
        
        system.assertEquals('3123', occ.Occurrence_Number__c);
      Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
         BFM_QueryOccurrence.callQueryOccurrenceButton(occ.id);
        BFM_QueryOccurrence query=new BFM_QueryOccurrence(occnum);
        
        //query.callQueryOccurrencesCTeIssuing();
      Test.stopTest();
}
}