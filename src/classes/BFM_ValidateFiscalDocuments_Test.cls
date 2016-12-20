@isTest
private class BFM_ValidateFiscalDocuments_Test {
    static testMethod void FiscalDocuments(){
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CT_e_key__c='123456';
    cte.CT_e_Number__c='6456';
    insert cte;
    system.assertEquals('123456', cte.CT_e_key__c);
    
    BFM_Error_Log__c errolog = new BFM_Error_Log__c();
    errolog.BFM_CT_e__c = cte.id;
    insert errolog;
    system.assertEquals(cte.id, errolog.BFM_CT_e__c);
        
    Set<Id> cteids = new Set<Id>();
    Test.startTest(); 
    BFM_ValidateFiscalDocuments fiscaldocs = new BFM_ValidateFiscalDocuments(cteids);
    BFM_ValidateFiscalDocumentsResponse fiscalres = new BFM_ValidateFiscalDocumentsResponse();
    BFM_GeneralServiceCalls servicecall = new BFM_GeneralServiceCalls();
    Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
    //BFM_ValidateFiscalDocuments.callValidateFiscalDocuments();
    fiscaldocs.generateIntegrationFailureErrorLogs(200,'status');
    Test.stopTest();
    }
}