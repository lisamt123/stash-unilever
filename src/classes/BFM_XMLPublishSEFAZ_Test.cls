@isTest
private class BFM_XMLPublishSEFAZ_Test {
    static testmethod void XMLPublishtest(){
    Account acc= new Account();
    acc.name = 'testname';
    insert acc;
    system.assertEquals('testname', acc.name);
        
    BFM_Shipment__c shipmentRec = new BFM_Shipment__c();
    shipmentRec.Shipment_Number__c='65624565';
    shipmentRec.Carrier_Account__c = acc.id;      
    insert shipmentRec;
        
    BFM_XMLPublishSEFAZ xmlsefaz = new BFM_XMLPublishSEFAZ(shipmentRec.id,'accessKey','xmlBody');
    BFM_SefazCheck_Utility_CC sefazutility = new BFM_SefazCheck_Utility_CC();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
    BFM_XMLPublishSEFAZ.sendForValidation('accesskey',shipmentRec.id,'sessionid');
    //BFM_SefazCheck_Utility_CC.sefazcheck(shipmentRec.id, 'fileUrl', 'objectName', 'sessionid');
    xmlsefaz.isSuccess();
    xmlsefaz.getErrors();
    Test.stopTest();
    }
}