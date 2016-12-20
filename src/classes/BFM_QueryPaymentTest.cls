@isTest
private class BFM_QueryPaymentTest{
private static testMethod void testBFM_QueryPayment (){
 Test.startTest();
 Set<Id> miroid=new Set<Id>(); 
 BFM_MIRO_Header__c miro=new BFM_MIRO_Header__c();
 miro.Access_Key__c='3123';
 insert miro;
 system.assertEquals('3123',miro.Access_Key__c);
 miroid.add(miro.id);
 
 
 BFM_QueryPayment.callQueryPaymentFromButton(miro.id);
 BFM_QueryPayment payment=new BFM_QueryPayment(miroid);
 payment.queryPayments();
 
 
 Test.stopTest();
}
}