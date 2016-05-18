global class VPM_CreateVendorServiceHelper {
    global class CreateVendorResponse {
        public String status {get; set;}
        public String bpmID {get; set;}
        public CreateVendorResponse(){
        }
    }
    global static void createVendor(String vendorId) {
        System.debug('----------input parameters passed are----------' + vendorId);
        String reqBodyJson;
        CreateVendorResponse createVenResp;
        String url = 'https://vendor-bpm-uat.eu.cloudhub.io/vendor-api/vendor/global?client_id=3485ee8279af458abc58065291e188d4&client_secret=ca16126215ea409498F4296ADB25EAB5';
        // Instantiate a new http object
        
        VPM_CreateVendorFetchFieldDetails clas = new VPM_CreateVendorFetchFieldDetails();
        reqBodyJson = clas.VPM_ConvertVendorFieldDetailsToJSON(vendorId);
        System.debug('------json body of request is-----'+reqBodyJson);
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(reqBodyJson);
        //req.setCompressed(true);
        
        // Send the request, and return a response
        res = h.send(req);
        System.debug('----------'+ res.toString());
        System.debug('------HTTP response status and status code are ------'+res.getStatus() + '  ' + res.getStatusCode());
        System.debug('----------'+ res.getBody());
        createVenResp = (CreateVendorResponse) System.JSON.deserialize(res.getBody(), CreateVendorResponse.class);
        System.debug('---bpm id ---' + createVenResp.bpmID);
        System.debug('---response status ---' + createVenResp.status);
        if(String.isNotBlank(createVenResp.bpmID)){
            updateVendorStatus(vendorId);
        }
        // If the request is successful, parse the JSON response.
        if (res.getStatusCode() == 200 && String.isNotBlank(res.getBody())) {
            // Deserialize the JSON string into collections of primitive data types.
            System.debug('----vendorDetails----'+res.getBody());
        }
    }
    global static void updateVendorStatus(String venReqId) {
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c FROM VPM_PurchasingRequests__c WHERE
                                                      Id = :venReqId LIMIT 1];        
        if(vendorList != null && vendorList.size() >0){
            VPM_PurchasingRequests__c vendor = vendorList.get(0);
            vendor.VPM_Status__c='BPM Record Submitted';
            update vendor;
        }
    }
}