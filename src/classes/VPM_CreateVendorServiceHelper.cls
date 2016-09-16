global class VPM_CreateVendorServiceHelper {
    global class CreateVendorResponse {
        public String Status {get; set;}
        public String RequestID {get; set;}
        public CreateVendorResponse() {
        }
    }
    global class CreateVendorFailureResponse {
        public String statusCode {get; set;}
        public String message {get; set;}
        public String details {get; set;}
        public CreateVendorFailureResponse() {
        }
    }
    global static String createVendor(String vendorId) {
        System.debug('----------input vendor Id----------' + vendorId);
        String reqBodyJson, requestStatus, responseString='',msg='',statusCodeStr;
        Integer numTimes = 0;
        HttpResponse res;        
        CreateVendorResponse createVenResp;
        CreateVendorFailureResponse createVenFailResp;
        VPM_CreateVendorFetchFieldDetails clas = new VPM_CreateVendorFetchFieldDetails();
        reqBodyJson = clas.VPM_ConvertVendorFieldDetailsToJSON(vendorId);
        System.debug('------json body of request is-----'+reqBodyJson);
        do {
            try {
                numTimes++;
                res = VPM_HttpUtil.sendRequest('POST',reqBodyJson,'VPM_CreateVendorBPM');
                System.debug('------whole response string----'+ res.toString());
                System.debug('------HTTP response status, status code and response body are ------'+res.getStatus() + '  ' + res.getStatusCode() + '  '+res.getBody());
                statusCodeStr = String.valueOf(res.getStatusCode());
                if(String.isNotBlank(res.getBody())) {
                    if(res.getStatusCode() == 200 || res.getStatusCode() == 400) {
                        createVenResp = (CreateVendorResponse) System.JSON.deserialize(res.getBody(), CreateVendorResponse.class);
                        System.debug('---RequestID --and response status----' + createVenResp.RequestID + '  ' + createVenResp.status);
                        if(createVenResp != null && String.isNotBlank(createVenResp.status)) {
                            msg = createVenResp.status;
                        }
                        responseString = msg;
                        if(res.getStatusCode() == 200 ) {
                            VPM_HttpUtil.updateVendorStatus(vendorId,VPM_HttpUtil.successStatus,msg,VPM_HttpUtil.successStatusMDM);
                        } else if(res.getStatusCode() == 400 ) {
                            VPM_HttpUtil.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
                        }                        
                    } else if(res.getStatusCode() == 500 || res.getStatusCode() == 504 || res.getStatusCode() == 503) {
                        createVenFailResp = (CreateVendorFailureResponse) System.JSON.deserialize(res.getBody(), CreateVendorFailureResponse.class);
                        System.debug('---statusCode --and message are ----' + createVenFailResp.statusCode + '  ' + createVenFailResp.message);
                        if(createVenFailResp != null && String.isNotBlank(createVenFailResp.message)) {
                            msg = createVenFailResp.message;
                        }
                        responseString = msg;
                        VPM_HttpUtil.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
                    } else if(res.getStatusCode() == 0) {
                    System.debug('----inside block where status code is 0----' + statusCodeStr);
                    responseString = 'Some error occured while submitting request to SAP. Please try after some time.';
                    VPM_HttpUtil.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,responseString,VPM_HttpUtil.failStatusMDM);
                }
                } else {
                    System.debug('----inside block where response body should be blank----' + statusCodeStr);
                    responseString = 'Some error occured while submitting request to SAP. Please try after some time.';
                    VPM_HttpUtil.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,responseString,VPM_HttpUtil.failStatusMDM);
                }
            } catch(System.CalloutException e) {
                msg = e.getMessage();
                System.debug('-----CalloutException while calling create vendor global-----'+msg);
                responseString = msg;
                integer i=0;
                do {
                    i++;
                    VPM_HttpUtil.retryCreateVendorGlobal(reqBodyJson, vendorId);
                } while(i < 4);
                VPM_HttpUtil.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            } catch (Exception ex) {
                msg = ex.getMessage();
                System.debug('-----Exception while calling create vendor global-----'+msg);
                responseString = msg;
                VPM_HttpUtil.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            }
        } while ((res.getStatusCode() == 504 || res.getStatusCode() == 0) && numTimes <=4);
        VPM_HttpUtil.sendEmail('deepak.moudekar@capgemini.com','Global Create Response from service',responseString + '\n' + '--response body--' + res.getBody() + '\n' + '--response code--'+ String.valueOf(res.getStatusCode()) + '\n' + reqBodyJson + '\n' + vendorId);
        return responseString;
    }
}