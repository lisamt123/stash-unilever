global class VPM_CreateVendorServiceHelper {
    
    global class CreateVendorResponse {
        public String Status {get; set;}
        public String RequestID {get; set;}
        public CreateVendorResponse() {
        }
    }
    
    global static String createVendor(String vendorId) {
        System.debug('----------input parameters passed are----------' + vendorId);
        String reqBodyJson, requestStatus, responseString='',msg='';
        CreateVendorResponse createVenResp;
        VPM_CreateVendorFetchFieldDetails clas = new VPM_CreateVendorFetchFieldDetails();
        reqBodyJson = clas.VPM_ConvertVendorFieldDetailsToJSON(vendorId);
        System.debug('------json body of request is-----'+reqBodyJson);
        VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = utilClass.sendRequest('POST',reqBodyJson,'VPM_CreateVendorBPM');
        System.debug('------whole response string----'+ res.toString());
        System.debug('------HTTP response status and status code and response body are ------'+res.getStatus() + '  ' + res.getStatusCode() + '  '+res.getBody());
        if(res.getStatusCode() == 200) {
            createVenResp = (CreateVendorResponse) System.JSON.deserialize(res.getBody(), CreateVendorResponse.class);
            System.debug('---RequestID --and response status----' + createVenResp.RequestID + '  ' + createVenResp.status);
        }
        if(createVenResp.status != null) {
            msg = createVenResp.status;
        }
        if(res.getStatusCode() == 200) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.successStatus,msg,VPM_HttpUtil.successStatusMDM);
            responseString = 'Vendor Request submitted to SAP.'+msg ;
        } else if(res.getStatusCode() == 500) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Server Error. Please try after some time.';
        } else if(res.getStatusCode() == 504) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Timeout Error. Please try after some time.';
        } else if(res.getStatusCode() == 400) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Please check request data and try again. '+msg;
        } else if(res.getStatusCode() == 503) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'SAP API not implemented.';
        } else {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Some error occured while submitting request to SAP. Please try after some time.'+msg ;
        }
        return responseString;
    }
}