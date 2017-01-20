@isTest
public class BFM_GeneralServiceCalls_Test {
    public static testMethod void Generalservice(){
    Set<String> shipnum = new Set<String>();
    List<String> occrnum = new List<String>();
    
    Account acc= new Account();
    acc.name = 'testname';
    insert acc;
    system.assertEquals('testname', acc.name);
    
    BFM_Shipment__c shipmentRec = new BFM_Shipment__c();
    shipmentRec.Shipment_Number__c='65624565';
    shipmentRec.Carrier_Account__c = acc.id;      
    insert shipmentRec;
    
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
    HttpResponse res = BFM_GeneralServiceCalls.publishXMLforValidation('xmlbody','accessKey');
    BFM_GeneralServiceCalls.requestQueryFreights(shipnum,'querytype');
    
    BFM_QueryOccurrencesRequest queryoccur = new BFM_QueryOccurrencesRequest(occrnum,'querytype');
    BFM_GeneralServiceCalls.requestQueryOccurrence(occrnum,'querytype');
    
    BFM_GeneralServiceCalls.requestsefazCheck(shipmentRec.id,'fileUrl','objname','session');
    BFM_GeneralServiceCalls.getsefazcheckJSONBody(shipmentRec.id,'fileUrl','objname');
    BFM_GeneralServiceCalls.publishXML(blob.valueOf('xml'),'filename','conlength');
    BFM_GeneralServiceCalls.nfsUpload('cnjp','filename',Date.valueOf('2016-10-17T12:22:22.904Z'),'filename','conlength',blob.valueOf('xml'));
    BFM_GeneralServiceCalls.podUpload('cnjp','filename',Date.valueOf('2016-10-17T12:22:22.904Z'),'filename','conlength',blob.valueOf('xml'));
    
    BFM_InvoiceProcessingRequest invpro = new BFM_InvoiceProcessingRequest();
    BFM_GeneralServiceCalls.performInvoiceProcessing(invpro );
    
    BFM_GeneralServiceCalls.queryTax('reqbody');
    BFM_GeneralServiceCalls.queryPayments(occrnum);
    BFM_GeneralServiceCalls.sendShipmentOccurrenceUpdate('plateNumber','shipno','occno');
    BFM_GeneralServiceCalls.requestSavePOD('plateNumber','shipno',Date.Today(),'occno');
    BFM_GeneralServiceCalls.validateFiscalDocuments(occrnum);
    
    String contentType = res.getHeader('Content-Type');
    System.assert(contentType == 'application/xml');
    Test.stopTest();         
    } 
    }