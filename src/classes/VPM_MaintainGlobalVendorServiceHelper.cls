global class VPM_MaintainGlobalVendorServiceHelper {
    global class MaintainGlobalVendorResponse {
        public String status {get; set;}
        public String bpmID {get; set;}
        public MaintainGlobalVendorResponse() {
        }
    }
    global static void maintainGlobalVendor(String vendorId) {
        System.debug('----------input parameters passed are----------' + vendorId);
        String reqBodyJson, requestStatus;
        MaintainGlobalVendorResponse maintainVenResp;
        VPM_MaintainVendorFetchFieldDetails clas = new VPM_MaintainVendorFetchFieldDetails();
        reqBodyJson = clas.VPM_ConvertMaintainVendorFieldDetailsToJSON(vendorId);
        System.debug('------json body of request is-----'+reqBodyJson);
        VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = utilClass.sendRequest('PUT',reqBodyJson,'VPM_MaintainExtendGlobalVendorBPM');
        System.debug('-----whloe response string-----'+ res.toString());
        System.debug('------HTTP response status and status code are ------'+res.getStatus() + '  ' + res.getStatusCode());
        maintainVenResp = (MaintainGlobalVendorResponse) System.JSON.deserialize(res.getBody(), MaintainGlobalVendorResponse.class);
        System.debug('---bpm id -- and response status---' + maintainVenResp.bpmID + '  ' + maintainVenResp.status);
        if(res.getStatusCode() == 200) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.successStatus);
        } else {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus);
        }
    }
}