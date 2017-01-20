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
}