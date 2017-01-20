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
        request.setHeader('client_id', 'test');
        request.setHeader('client_secret', 'test1');
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
        request.setBody(JSON.serialize(requestObj, true));
        
        
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
        BFM_SavePODRequest savePodRequest = new BFM_SavePODRequest(deliveryNumber, shipmentNumber, podDate, podStatus);
        HttpRequest hRequest = new HttpRequest();
        hRequest.setMethod('POST');
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt WHERE QualifiedAPIName = 'Save_POD' LIMIT 1];
        
        hRequest.setEndpoint(endpointMetadata.Endpoint_URL__c);
        hRequest.setHeader('client_id', 'client_id');
        hRequest.setHeader('client_secret', 'client_secret');
        hrequest.setHeader('Content-Type', 'application/json');
        hRequest.setBody(JSON.serialize(savePODRequest));
        System.debug('Request body '+hRequest.getBody());
        Http h = new Http();
        HttpResponse response = h.send(hRequest);
        System.debug('status code ' + response.getStatusCode());
        System.debug('Response body '+response.getBody());
        
        return response;
    }
     
     /**
     * Method name : validateFiscalDocuments 
     * Method : POST
     * URL : https://fiscal-doc-mgmt-qa-v1.eu.cloudhub.io/api/fiscal_document
     * @param  String accessKey
     * This request can send more than one accessKey, but we Salesforce is using it manually.
     */
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
    
     /**
     * Method name : publishXMLforValidation 
     * Method : PUT
     * URL : https://fiscal-doc-mgmt-qa-v1.eu.cloudhub.io/api/acknowledgement/
     * @param  List<BFM_CT_e__c> cte records new list
     */
    public static HttpResponse publishXMLforValidation(String xmlBody, String accessKey) {
        System.debug('xmlBody : ' + xmlBody);      
        System.debug('accessKey : ' + accessKey);     
        
        HttpRequest req = new HttpRequest();
        
        BFM_Mulesoft_Endpoint__mdt endpointMetadata = [SELECT Endpoint_URL__c FROM BFM_Mulesoft_Endpoint__mdt 
                                                       WHERE QualifiedAPIName = 'Publish_XML_CTE_CCE_NFE' LIMIT 1];
        
        String endpoint = endpointMetadata.Endpoint_URL__c + accessKey;
        req.setEndpoint(endpoint);
        req.setHeader('client_id', 'client_id');
        req.setHeader('client_secret', 'client_secret');
        req.setHeader('Content-Type', 'application/xml');
        req.setBody(xmlBody);
        req.setMethod('PUT');
        
        Http h = new Http();
        HttpResponse response = h.send(req);
        system.debug('response body '+response.getBody());        
        System.debug('RESPONSE STRING: ' + response.toString());
        System.debug('RESPONSE STATUS: ' + response.getStatus());
        System.debug('STATUS_CODE: ' + response.getStatusCode());
        return response;
    }
}