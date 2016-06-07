global class VPM_CreateVendorServiceHelper {

    global class CreateVendorResponse {
        public String status {get; set;}
        public String bpmID {get; set;}
        public CreateVendorResponse() {
        }
    }
  
    global static String createVendor(String vendorId) {
        System.debug('----------input parameters passed are----------' + vendorId);
        String reqBodyJson, requestStatus, responseString='';
        CreateVendorResponse createVenResp;
        VPM_CreateVendorFetchFieldDetails clas = new VPM_CreateVendorFetchFieldDetails();
        reqBodyJson = clas.VPM_ConvertVendorFieldDetailsToJSON(vendorId);
        System.debug('------json body of request is-----'+reqBodyJson);
        VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = utilClass.sendRequest('POST',reqBodyJson,'VPM_CreateVendorBPM');
        System.debug('------whole response string----'+ res.toString());
        System.debug('------HTTP response status and status code are ------'+res.getStatus() + '  ' + res.getStatusCode());
        createVenResp = (CreateVendorResponse) System.JSON.deserialize(res.getBody(), CreateVendorResponse.class);
        System.debug('---bpm id --and response status----' + createVenResp.bpmID + '  ' + createVenResp.status);
        if(res.getStatusCode() == 200) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.successStatus);
            responseString = 'Vendor Request submitted successfully to SAP.';
            
        } else if(res.getStatusCode() == 500) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus);
            responseString = 'Server Error. Please try after some time.';
        } else if(res.getStatusCode() == 504) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus);
            responseString = 'Timeout Error. Please try after some time.';
        } else if(res.getStatusCode() == 400) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus);
            responseString = 'Please check request data and try again.';
        } else {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus);
            responseString = 'Some error occured while submitting request to SAP. Please try after some time.';
        }
        return responseString;
    }
}