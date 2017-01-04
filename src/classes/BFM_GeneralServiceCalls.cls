/**
 * This class will be used to route all the calls made to Mulesoft or Amazon S3. It is responsible for mounting a JSON,
 * establishing a connection, getting the response from the external system and return a JSON for Salesforce to process.
 * Its methods are also responsible for logging eventual connection errors that happen
 * 
 * @author Zanquini, Vinicius
 * @date 2016-08-16
 * */

public class BFM_GeneralServiceCalls {

    
    public static HttpResponse requestQueryFreights(Set<String> shipmentNumber, String queryType){
        HttpRequest request = new HttpRequest();
        
        //String customSettingEndpoint = System.Url.getSalesforceBaseURL().toExternalForm() +'/services/apexrest/MulesoftMock/v1/queryFreight';
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt WHERE QualifiedAPIName = 'Query_Freights' LIMIT 1];
        String customSettingEndpoint = endpointMetadata.endpoint_URL__c;
        
        // Endpoint will be stored in a custom setting
        request.setEndpoint(customSettingEndpoint);
        request.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('client_id', 'dummyId');
        request.setHeader('client_secret', 'dummySecret');
        request.setMethod('POST');
        BFM_QueryFreightsRequest requestBody = new BFM_QueryFreightsRequest(shipmentNumber, queryType);
        request.setBody(JSON.serialize(requestBody));
        Http httpConnection = new Http();
        request.setTimeout(120000);
        System.debug('body of the request ' + request.getBody());
        HttpResponse response = httpConnection.send(request);
        System.debug('Status of the response: ' + response.getStatusCode() +' - '+ response.getStatus()+' body of the response ' +response.getBody());
        return response;
        
    }
    
    public static HttpResponse requestQueryOccurrence(List<String> occurrenceNumbers, String queryType){
        HttpRequest request = new HttpRequest();
        
        String customSettingEndpoint; //= System.Url.getSalesforceBaseURL().toExternalForm() +'/services/apexrest/MulesoftMock/v1/queryFreight';
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt WHERE QualifiedAPIName = 'Query_Occurrence' LIMIT 1];
        customSettingEndpoint = endpointMetadata.endpoint_URL__c;
        // Endpoint will be stored in a custom setting
        request.setEndpoint(customSettingEndpoint);
        request.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('client_id', 'dummyId');
        request.setHeader('client_secret', 'dummySecret');
        request.setMethod('POST');
        BFM_QueryOccurrencesRequest requestBody = new BFM_QueryOccurrencesRequest(occurrenceNumbers, queryType);
        request.setBody(JSON.serialize(requestBody));
        Http httpConnection = new Http();
        request.setTimeout(120000);
        System.debug('Endpoint of the request ' +request.getEndpoint());
        System.debug('body of the request ' + request.getBody());
        HttpResponse response = httpConnection.send(request);
        System.debug('status of the resposne ' + response.getStatusCode() + ' ' + response.getStatus());
        System.debug('body of the response ' + response.getBody() );
        return response;
        
        
    }
    
    //Method used for Sefaz Check
    public static String requestsefazCheck(Id objectId, String fileUrl, string objectName, string sessionid){
        HttpRequest request = new HttpRequest();
        system.debug('fffffff');
        String customSettingEndpoint = System.Url.getSalesforceBaseURL().toExternalForm() 
            +'/services/apexrest/MulesoftMock/v2/sefazchecking';
        // Endpoint will be stored in a custom setting
        request.setEndpoint(customSettingEndpoint);
        request.setHeader('Authorization', 'OAuth '+sessionid);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setBody(getsefazcheckJSONBody(objectId, fileUrl, objectName));
        system.debug('sssssss'+getsefazcheckJSONBody(objectId, fileUrl, objectName));
        Http httpConnection = new Http();
        HttpResponse response = httpConnection.send(request);
        System.debug('Status of the response: ' + response.getStatusCode() +' - '+ response.getStatus()+'body of the response ' +response.getBody());
        return response.getBody();  
        
    }
    
    @ TestVisible
    private static string getsefazcheckJSONBody(Id objectId, String fileUrl,string objectName){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('SefazCheck');
        gen.writeStartObject();
        gen.writeObjectField('objectId', objectId);
        gen.writeStringField('fileUrl', fileUrl);
        gen.writeStringField('objectName', objectName);
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
    public static HttpResponse publishXML(Blob xmlBody, String fileName, String contentLenght){
        HttpRequest request = new HttpRequest();
        //String customSettingEndpoint = System.Url.getSalesforceBaseURL().toExternalForm() 
        //    +'/services/apexrest/MulesoftMock/v1/XMLPublish/v1/publishXML';
        
        String customSettingEndpoint = [SELECT Endpoint_URL__c 
                                                                FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'XML_File_Upload' LIMIT 1].Endpoint_URL__c;
        // Endpoint will be stored in a custom setting
        request.setEndpoint(customSettingEndpoint);
        request.setMethod('POST');
        request.setHeader('client_id', 'client_id');
        request.setHeader('client_secret', 'client_secret');
        request.setHeader('fileName', fileName);
        request.setHeader('Content-Type', 'application/xml');
        request.setHeader('Content-Length',contentLenght);
        request.setTimeout(120000);
        request.setBodyAsBlob(xmlBody);
       
        
        Http httpConnection = new Http();
        System.debug('the request ' + request + ' fileName ' + filename + ' Content-length ' +contentLenght );
        System.debug('body of the request ' + request.getBody());
        HttpResponse response = httpConnection.send(request);
        System.debug('status of the response ' + response.getStatus() +  ' ' + response.getStatusCode());
        System.debug('body of the response ' +response.getBody());
        return response;  
    }
    
    public static HttpResponse nfsUpload(String cnjp,String filename, Datetime timeStamp, String contentType, String size, Blob file){
       system.debug(' CNJP is '+cnjp);
        HttpRequest request = new HttpRequest();
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c 
                                                                FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'Publish_NFS' LIMIT 1];
        String endpoint = endpointMetadata.endpoint_URL__c;
        
        request.setEndpoint(endpoint);
        request.setHeader('client_id', 'value');
        request.setHeader('client_secret', 'value');
        request.setHeader('taxIdentifier', cnjp);
        request.setHeader('fileName', fileName);
        request.setHeader('timeStamp', String.valueOf(timeStamp));
        request.setHeader('Content-Type', contentType);
        request.setHeader('Content-Lenght', size);
        request.setMethod('POST');
        request.setBodyAsBlob(file);
        request.setTimeout(120000);
        Http httpConnection = new Http();
        System.debug('Request ' + request);
        HttpResponse response = httpConnection.send(request);
        return response;
    }
    
    public static HttpResponse podUpload(String cnjp,String filename, Datetime timestamp, String contentType, String size, blob file){
        HttpRequest request = new HttpRequest();
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c 
                                                                FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'Publish_POD' LIMIT 1];
        String endpoint = endpointMetadata.endpoint_URL__c;
        system.debug(' cnjp is '+cnjp);
        request.setEndpoint(endpoint);
        request.setHeader('client_id', 'value');
        request.setHeader('client_secret', 'value');
        request.setHeader('taxIdentifier', cnjp);
        request.setHeader('fileName', fileName);
        request.setHeader('timeStamp', String.valueOf(timeStamp));
        request.setHeader('Content-Type', contentType);
        request.setHeader('Content-Lenght', size);
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setBodyAsBlob(file);
        Http httpConnection = new Http();
        system.debug('endpoint of the request ' + request.getEndpoint());
        HttpResponse response = httpConnection.send(request);
        System.debug('code of the response ' + response.getStatusCode() + ' ' + response.getStatus());
        return response;
    }
    
    public static HttpResponse performInvoiceProcessing(BFM_InvoiceProcessingRequest requestObj){
        HttpRequest request = new HttpRequest();
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'Request_Invoice_Processing' LIMIT 1];
        
        // Endpoint will be stored in a custom setting
        System.debug('endpoint URL ' +customSettingEndpoint.endpoint_URL__c);
        request.setEndpoint(customSettingEndpoint.endpoint_URL__c);
        request.setHeader('client_id', 'client_id');
        request.setHeader('client_secret', 'client_secret');
        
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        
        //String sampleReq='{ "RequestInvoiceProcessing": { "accessKey": "33160852548435019783570010004167061034137488", "objectName": "SAPMIROPOST4", "vendorID": "10124336", "nfType": "CE", "invoiceDate": "2016-12-05", "postingDate": "2016-12-05", "invoiceNumber": "416706-1", "companyCode": "5454", "referenceDocumentCategory": "", "transactionCode": "", "totalAmount": 15.39, "headerText": "TEST MIRO POST4", "headerTextSummary": "MIRO POST4", "valueNet": 11.27, "protocolNumber": "333160014345221", "checkDigit": "4", "nfeIssType": "1", "randomNumber": "03413748", "baselineDate": "2016-12-25", "cancellationFlag": "", "annulationFlag": "", "annulationReason": "", "inOutState": "", "complementSESFlag": false, "freeFreightFlag": false, "items": [ { "sesNumber": "1041292793", "sesNetValue": 11.27, "taxCode": "XA", "taxes": [ { "cfopInbound": "1353/AA", "fiscalRightICMS": "", "fiscalRightIPI": "", "taxType": "ICOF", "taxValue": 1.21, "rate": 7.60, "baseAmount": 15.93, "otherBase": 0, "excludedBase": 0, "icmsLaw": "IC0", "ipiLaw": "Z11", "cofinsLaw": "117", "pisLaw": "117", "issLaw": "" }, { "cfopInbound": "1353/AA", "fiscalRightICMS": "", "fiscalRightIPI": "", "taxType": "ZIC1", "taxValue": 3.19, "rate": 20, "baseAmount": 15.93, "otherBase": 0, "excludedBase": 0, "icmsLaw": "IC0", "ipiLaw": "Z11", "cofinsLaw": "117", "pisLaw": "117", "issLaw": "" }, { "cfopInbound": "1353/AA", "fiscalRightICMS": "", "fiscalRightIPI": "", "taxType": "IPI0", "taxValue": 0, "rate": 0, "baseAmount": 0, "otherBase": 15.93, "excludedBase": 0, "icmsLaw": "IC0", "ipiLaw": "Z11", "cofinsLaw": "117", "pisLaw": "117", "issLaw": "" }, { "cfopInbound": "1353/AA", "fiscalRightICMS": "", "fiscalRightIPI": "", "taxType": "IPIS", "taxValue": 0.26, "rate": 1.65, "baseAmount": 15.93, "otherBase": 0, "excludedBase": 0, "icmsLaw": "IC0", "ipiLaw": "Z11", "cofinsLaw": "117", "pisLaw": "117", "issLaw": "" } ] } ], "withholdItems": [ { "withholdingTaxType": "CF", "withholdingTaxCode": "C2", "withholdingTaxBaseAmount": 15.93, "withholdingTaxApplyFlag": false }, { "withholdingTaxType": "IN", "withholdingTaxCode": "N2", "withholdingTaxBaseAmount": 15.93, "withholdingTaxApplyFlag": true },{ "withholdingTaxType": "IR", "withholdingTaxCode": "R3", "withholdingTaxBaseAmount": 15.93, "withholdingTaxApplyFlag": false }, { "withholdingTaxType": "IS", "withholdingTaxCode": "S1", "withholdingTaxBaseAmount": 15.93, "withholdingTaxApplyFlag": true } ] } } ';
       // String sampleReq='{"RequestInvoiceProcessing":{"withholdItems":[{"withholdingTaxType":"CF","withholdingTaxCode":"2","withholdingTaxBaseAmount":29814.49,"withholdingTaxApplyFlag":false}],"vendorCode":"50439037","valueNet":"500.00","transactionCode":"1","totalAmount":4356.00,"referenceDocumentCategory":"4","randomNumber":"","protocolNumber":"135160790253918","postingDate":"2016-03-08","pisLaw":"116","objectName":"BFM_CT_e__c","nfType":"CE","nfeIssType":"1","items":[{"taxes":[{"taxValue":"12","taxType":"GH","rate":"12","otherBase":0.00,"fiscalRightIPI":"90","fiscalRightICMS":"100","excludedBase":0.00,"cfopInbound":"1353","baseAmount":29814.48},{"taxValue":"100","taxType":"XS","rate":"2019","otherBase":29814.48,"fiscalRightIPI":"","fiscalRightICMS":"","excludedBase":0.00,"cfopInbound":"1353","baseAmount":0.00},{"taxValue":"100","taxType":"200","rate":"12","otherBase":0.00,"fiscalRightIPI":"","fiscalRightICMS":"","excludedBase":0.00,"cfopInbound":"1353","baseAmount":29814.48},{"taxValue":"1200","taxType":"GH","rate":"12","otherBase":0.00,"fiscalRightIPI":"","fiscalRightICMS":"","excludedBase":0.00,"cfopInbound":"1353","baseAmount":29814.48}],"taxCode":"XA","sesNumber":"1041401510","sesNetValue":"23478.91"}],"ipiLaw":"100","invoiceNumber":"910091-8","invoiceDate":"2016-12-05","inOutState":"","icmsLaw":"100","headerTextSummary":"20161214_SFCTE0000000145","headerText":"","freeFreightFlag":false,"complementSESFlag":false,"companyCode":"2236","cofinsLaw":"117","checkDigit":"1","cancellationFlag":"","baselineDate":"2016-12-19","annulationReason":"","annulationFlag":"","accessKey":"31161282809088001204570080009100911034523211"}}';
       // String refinedString = JSON.serialize(sampleReq, false).replace('null','\"\"');
       //request.setBody(JSON.serialize(requestObj, true).replace('null','\"\"'));
       request.setBody(JSON.serialize(requestObj, true));
       //request.setBody(sampleReq);
        
        Http h = new Http();
        System.debug('Body of the request ' + request.getBody());
        HttpResponse response = h.send(request);
        System.debug('Body of the Response ' + response.getBody());
        System.debug('Status of the resposne ' + response.getStatusCode());
        return response;
    }
    
    public static HttpResponse queryTax(String requestBody){
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'Query_Tax_Calculation' LIMIT 1];
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(customSettingEndpoint.Endpoint_URL__c);
        request.setHeader('client_id','client_id');
        request.setHeader('client_secret','client_secret');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);
        request.setMethod('POST');
        request.setTimeout(120000);
        Http h = new Http();
        System.debug('body of the request ' + request.getBody());
        HttpResponse response = h.send(request);
        System.debug('status code of the response ' + response.getStatusCode());
        system.debug('body of the response ' + response.getBody());
        return response;
    }
    
    public static httpResponse queryPayments(List<String> miroAccessKeys){
        HttpRequest request = new HttpRequest();
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'Query_Payment' LIMIT 1];
        String endpoint = customSettingEndpoint.endpoint_URL__c;
        request.setHeader('client_id', 'client_id');
        request.setHeader('client_secret', 'client_secret');
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        BFM_QueryPaymentsRequest requestObject = BFM_QueryPaymentsRequest.getInstance(miroAccessKeys);
        request.setBody(JSON.serialize(requestObject));
        System.debug('Body of the request ' + request.getBody());        
        Http h = new Http();
        
        HttpResponse response = h.send(request);
        System.debug('Body of the response ' + response.getBody());
        return response;
    }
    
    public static httpResponse sendShipmentUpdate(BFM_UpdateFreightDataRequest request){
        HttpRequest hRequest = new HttpRequest();
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'Update_Freight_Data' LIMIT 1];
        String endpoint = customSettingEndpoint.endpoint_URL__c + request.UpdateFreightData.shipment.shipmentID;
        hRequest.setHeader('client_id', 'client_id');
        hRequest.setHeader('client_secret', 'client_secret');
        hRequest.setHeader('Content-Type', 'application/json');
        hRequest.setMethod('PUT');
        hRequest.setEndpoint(endpoint);
        boolean suppressApexNulls = true;
        hRequest.setBody(JSON.serialize(request, suppressApexNulls));
        System.debug('Body of the Request ' + hRequest.getBody());
        Http h = new Http();
        HttpResponse response = h.send(hRequest);
        System.debug('Body of the Response ' + response.getBody());
        return response;
    }
    
    public static httpResponse sendShipmentOccurrenceUpdate(string plateNumber, string shipmentNumber, string occurrenceNumber){
        HttpRequest request = new HttpRequest();
        String shipOrOccNumber;
        BFM_UpdateFreightDataRequest requestObject;
        if(shipmentNumber != null){
            shipOrOccNumber = shipmentNumber;
            requestObject = BFM_UpdateFreightDataRequest.getInstance(plateNumber, shipOrOccNumber, null);
        } else if(occurrenceNumber != null){
            shipOrOccNumber = occurrenceNumber;
            requestObject = BFM_UpdateFreightDataRequest.getInstance(plateNumber, null, shipOrOccNumber);
        }
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'Update_Freight_Data' LIMIT 1];
        String endpoint = customSettingEndpoint.endpoint_URL__c + shipOrOccNumber;
        request.setHeader('client_id', 'client_id');
        request.setHeader('client_secret', 'client_secret');
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('PUT');
        request.setEndpoint(endpoint);
        boolean suppressApexNulls = true;
        request.setBody(JSON.serialize(requestObject, suppressApexNulls));
        System.debug('Body of the Request ' + request.getBody());
        Http h = new Http();
        HttpResponse response = h.send(request);
        System.debug('Body of the Response ' + response.getBody());
        return response;
    }
    
    public static httpResponse requestSavePOD(String deliveryNumber, String shipmentNumber, Date podDate, String podStatus){
        
        /*Id podId){
        BFM_Pod__c pod = [SELECT POD_Date__c, POD_Status__c,
                          NF_e__r.Delivery__r.Delivery_Number__c,
                          NF_e__r.Delivery__r.Stage__r.Shipment__r.Shipment_Number__c FROM BFM_Pod__c WHERE Id =: podId];
        
           
        BFM_SavePODRequest savePoDRequest = new BFM_SavePODRequest(pod.NF_e__r.Delivery__r.Delivery_Number__c, 
                                                                   pod.NF_e__r.Delivery__r.Stage__r.Shipment__r.Shipment_Number__c , 
                                                                   pod.POD_Date__c,
                                                                   pod.POD_Status__c);
        */
        BFM_SavePODRequest savePodRequest = new BFM_SavePODRequest(deliveryNumber, shipmentNumber, podDate, podStatus);
        HttpRequest hRequest = new HttpRequest();
        hRequest.setMethod('POST');
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt WHERE QualifiedAPIName = 'Save_POD' LIMIT 1];
        
        hRequest.setEndpoint(endpointMetadata.Endpoint_URL__c);
        hRequest.setHeader('client_id', 'client_id');
        hRequest.setHeader('client_secret', 'client_secret');
        //Start-->added by Abhinav
        hrequest.setHeader('Content-Type', 'application/json');
        //End-->added by Abhinav
        hRequest.setBody(JSON.serialize(savePODRequest));
        System.debug('Request body '+hRequest.getBody());
        Http h = new Http();
        HttpResponse response = h.send(hRequest);
        System.debug('status code ' + response.getStatusCode());
        System.debug('Response body '+response.getBody());
        
        return response;
    }
    
    public static HttpResponse validateFiscalDocuments(List<String> accessKeys){
        
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                       WHERE QualifiedAPIName = 'Validate_Fiscal_Document' LIMIT 1];
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointMetadata.Endpoint_URL__c);
        
        
        request.setMethod('POST');
        request.setHeader('client_id', '2345sv252a');
        request.setHeader('client_secret', '2452sdv5246a');
        request.setHeader('Content-Type', 'application/json');
        
        BFM_ValidateFiscalDocumentsRequest requestFiscalValidation = new BFM_ValidateFiscalDocumentsRequest(accessKeys);
        request.setBody(JSON.serialize(requestFiscalValidation));
        System.debug('url sent ' + request.getEndpoint());
        System.debug('body of the request ' + request.getBody());
        Http h = new Http();
        HttpResponse response = h.send(request);
        System.debug('body of the response ' + response.getBody());
        return response;
    }
    
    public static HttpResponse publishXMLforValidation(String xmlBody, String accessKey){
        HttpRequest req = new HttpRequest();
        
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                       WHERE QualifiedAPIName = 'Publish_XML_CTE_CCE_NFE' LIMIT 1];
        String endpoint = endpointMetadata.Endpoint_URL__c+ accessKey;
        req.setEndpoint(endpoint);
        req.setHeader('client_id', 'client_id');
        req.setHeader('client_secret', 'client_secret');
        req.setHeader('Content-Type', 'application/xml');
        req.setBody(xmlBody);
        req.setMethod('PUT');
        System.debug('request body ' +req.getBody());
        Http h = new Http();
        HttpResponse response = h.send(req);
        system.debug('response body '+response.getBody());        
        System.debug('RESPONSE STRING: ' + response.toString());
        System.debug('RESPONSE STATUS: ' + response.getStatus());
        System.debug('STATUS_CODE: ' + response.getStatusCode());
        return response;
    }
}