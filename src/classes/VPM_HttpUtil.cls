public class VPM_HttpUtil {
    public static final String successStatus = 'BPM Record Submitted';
    public static final String failStatus = 'MDM Ops Review - SAP BPM submit Failed';
    public VPM_HttpUtil(){
    }
    public String createEndPoint(String service) {
        String endpoint,resource,clientId,clientSecret,finalUrl;
        List<VPM_ExternalService__mdt> serviceDetails = [SELECT DeveloperName, MasterLabel, VPM_ServiceEndpoint__c, VPM_ServiceResource__c FROM VPM_ExternalService__mdt WHERE DeveloperName = :service];
        if(serviceDetails != null && serviceDetails.size() >0) {
            endpoint = serviceDetails.get(0).VPM_ServiceEndpoint__c;
            resource = serviceDetails.get(0).VPM_ServiceResource__c;
        }
        clientId = System.Label.VPM_ClientId;
        clientSecret = System.Label.VPM_ClientSecret;
        finalUrl = endpoint + resource + '?client_id=' + clientId + '&client_secret=' + clientSecret;
        System.debug('---HttpUtil-createEndPoint--final endpoint url-------'+ finalUrl);
        return finalUrl;
    }
    public HttpResponse sendRequest(String requestType, String requestBodyJson, String serviceName) {
        String url;
        if(requestType != null && !requestType.equalsIgnoreCase('GET')) {
        	url = createEndPoint(serviceName);
        }
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;        
        req.setEndpoint(url);
        req.setMethod(requestType);
        if(requestType != null && !requestType.equalsIgnoreCase('GET') && String.isNotBlank(requestBodyJson)) {
            req.setHeader('Content-Type', 'application/json');
            req.setBody(requestBodyJson);
        }
        //req.setCompressed(true);
        res = h.send(req);
        return res;
    }
    public HttpResponse sendGetRequest(String requestType, String serviceName, Map<String,String> queryParams) {
        String url = createEndPoint(serviceName);
        url = url + convertRequestParams(queryParams);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;        
        req.setEndpoint(url);
        req.setMethod(requestType);
        //req.setCompressed(true);
        res = h.send(req);
        return res;
    }
    public String convertRequestParams(Map<String,String> queryParameters) {
        String stringParams='';
        if(queryParameters != null && queryParameters.size() >0) {
            for(String mapEntry : queryParameters.keySet()) {
                stringParams = stringParams + '&' + EncodingUtil.urlEncode(mapEntry, 'UTF-8') + '=' + 
                    EncodingUtil.urlEncode(queryParameters.get(mapEntry), 'UTF-8');
    		}
        }
        return stringParams;
    }
    public void updateVendorStatus(String venReqId, String reqStatus) {
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c FROM VPM_PurchasingRequests__c WHERE
                                                      Id = :venReqId LIMIT 1];        
        if(vendorList != null && vendorList.size() >0) {
            VPM_PurchasingRequests__c vendor = vendorList.get(0);
            vendor.VPM_Status__c = reqStatus;
            update vendor;
        }
    }
}