public with sharing class AA_RestRequestController {

    @AuraEnabled
    public static Response service(
        String path, 
        String method, 
        String responseFormat, 
        String bodyContent, 
        String bodyContentType
    ) {
        HttpRequest request = buildRequest(path, method, responseFormat, bodyContent, bodyContentType);
        HttpResponse httpRes = sendRequest(request);
        Response restRes = buildResponse(httpRes);
        system.debug('Return Result==>'+restRes);
        return restRes;
    }
    
    private static HttpRequest buildRequest(String path, String method, String responseFormat, String bodyContent, String bodyContentType) {
        HttpRequest request = new HttpRequest();
		String csName=AA_constants.CUSTOM_SETTING_NAME;
        String baseURL = path;
        baseUrl +='&language=en';
       // baseUrl +='&client='+Label.GoogleAPIClientID;
        baseUrl +='&client='+AA_GoogleMap__c.getInstance(csName).ClientID__c;
        
        //string privateKey = 'DS-2wns6FR5hcaXPy5liVFfwKek=';
      	string privateKey = AA_GoogleMap__c.getInstance(csName).PrivateKey__c;
        privateKey = privateKey.replace('-', '+');
        privateKey = privateKey.replace('_', '/');
        
        Blob privateKeyBlob = EncodingUtil.base64Decode(privateKey);
        Blob urlBlob = Blob.valueOf(baseURL);
        Blob signatureBlob = Crypto.generateMac('HMacSHA1', urlBlob, privateKeyBlob);
        
        String signature =EncodingUtil.base64Encode(signatureBlob);
        signature = signature.replace('+', '-');
        signature = signature.replace('/', '_');
        
        baseUrl += '&signature=' + signature;

       // baseUrl = 'https://maps.googleapis.com' + baseUrl;
         baseUrl = AA_GoogleMap__c.getInstance(csName).BaseUrl__c + baseUrl;
        request.setEndpoint(baseUrl);
        
        request.setMethod(method);
        
        if (bodyContent != null) {
            request.setBody(JSON.serialize(bodyContent));
            request.setHeader('Content-Type', bodyContentType); 
        }
        
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('ACCEPT', responseFormat);

        system.debug('buildRequest==> '+request);
        return request;
    }
      
    private static HttpResponse sendRequest(HttpRequest request) {    
        return new Http().send(request);
    }
    
    private static Response buildResponse(HttpResponse httpRes) {
        Response restRes = new Response();
        
        restRes.status = httpRes.getStatus();
        restRes.statusCode = httpRes.getStatusCode();
        restRes.body = httpRes.getBody();
        
        return restRes;
    }

    public class Response {

        @AuraEnabled
        public String status { get; set; }
        
        @AuraEnabled
        public Integer statusCode { get; set; }
        
        @AuraEnabled
        public String body { get; set; }
    }
}