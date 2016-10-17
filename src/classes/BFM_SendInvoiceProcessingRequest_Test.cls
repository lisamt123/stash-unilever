@isTest
public class BFM_SendInvoiceProcessingRequest_Test{
    private static testMethod void testBFM_SendInvoiceProcessingRequest(){
    test.startTest();
    BFM_SendInvoiceProcessingRequest invoice=new BFM_SendInvoiceProcessingRequest();
    invoice.sendRequest();
    test.stopTest();
    }
    }