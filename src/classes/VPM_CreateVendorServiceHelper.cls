/*********************************************************************************************************
Name:  VPM_CreateVendorServiceHelper 
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  This class has been used to do apex callout for 'create' web service and get the
their JSON response parsed. 

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Ajay       07-10-2016         createVendor method    Added the logic for 'POST' web service callout
2.0 -    Deepak     12-10-2016         createVendor method    Added the code to handle different error messages.                   
**********************************************************************************************************/

global class VPM_CreateVendorServiceHelper {

    /*
        Wrapper class for fetch mule response.
    */
    global class CreateVendorResponse {
        public String Status {get; set;}
        public String message {get; set;}
        public String RequestID {get; set;}
    }
    global class CreateVendorFailureResponse {
        public String statusCode {get; set;}
        public String message {get; set;}
        public String details {get; set;}
    }
    
    /*
      Author      : Ajay & Deepak
      Parameter   : VPM_PurchasingRequests__c object Id.
      Description : This method is used to make 'POST' callout to perform create request in SAP.
    
    */
    global static String createVendor(String vendorId) {
        System.debug('----------input vendor Id----------' + vendorId);
        String reqBodyJson ='', responseString='',msg='';
        Integer numTimes = 0;
        HttpResponse res;        
        CreateVendorResponse createVenResp;
        CreateVendorFailureResponse createVenFailResp;
        VPM_CreateVendorFetchFieldDetails clas = new VPM_CreateVendorFetchFieldDetails();
        reqBodyJson = clas.VPM_ConvertVendorFieldDetailsToJSON(vendorId);
        System.debug('------json body of request is-----'+reqBodyJson);
        do {
            try 
            {
                numTimes++;
                res = VPM_HttpUtil.sendRequest('POST',reqBodyJson,'VPM_CreateVendorBPM');
                System.debug('------whole response string----'+ res.toString());
                System.debug('------HTTP response status, status code and response body are ------'+res.getStatus() + '  ' + res.getStatusCode() + '  '+res.getBody());
               // statusCodeStr = String.valueOf(res.getStatusCode());
                if(String.isNotBlank(res.getBody())) {
                    if(res.getStatusCode() == 200 || res.getStatusCode() == 400) {
                        createVenResp = (CreateVendorResponse) System.JSON.deserialize(res.getBody(), CreateVendorResponse.class);
                        System.debug('---RequestID --and response status----' + createVenResp.RequestID + '  ' + createVenResp.status);
                        if(createVenResp != null && String.isNotBlank(createVenResp.status)) {
                            msg = createVenResp.status;
                        }
                        else
                        {
                           msg = createVenResp.message;  
                        }
                        responseString = msg;
                        if(res.getStatusCode() == 200 ) {
                            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.successStatus,msg,VPM_HttpUtil.successStatusMDM);
                            VPM_HttpUtil.updateRecordType(vendorId);
                           // VPM_HttpUtil.updateFieldType(vendorId);
                        } else if(res.getStatusCode() == 400 ) {
                            
                            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
                        }                        
                    } else if(res.getStatusCode() == 500 || res.getStatusCode() == 504 || res.getStatusCode() == 503) {
                        createVenFailResp = (CreateVendorFailureResponse) System.JSON.deserialize(res.getBody(), CreateVendorFailureResponse.class);
                        System.debug('---statusCode --and message are ----' + createVenFailResp.statusCode + '  ' + createVenFailResp.message);
                        if(createVenFailResp != null && String.isNotBlank(createVenFailResp.message)) {
                            msg = createVenFailResp.message;
                        }
                        responseString = msg;
                        VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
                    } else if(res.getStatusCode() == 0) {
                    //System.debug('----inside block where status code is 0----' + res.getStatusCode());
                    responseString = System.Label.VPM_SAPRequstError;
                    VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,responseString,VPM_HttpUtil.failStatusMDM);
                }
                } else {
                    System.debug('----inside block where response body should be blank----' + res.getStatusCode());
                    responseString = System.Label.VPM_SAPRequstError;
                    VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,responseString,VPM_HttpUtil.failStatusMDM);
                }
            } catch(System.CalloutException e) {
               // msg = e.getMessage();
                System.debug('-----CalloutException while calling create vendor global-----'+msg);
                responseString =  e.getMessage();
                integer i=0;
                do {
                    i++;
                    VPM_HttpUtil.retryCreateVendorGlobal(reqBodyJson, vendorId);
                } while(i < 4);
                VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            } catch (Exception ex) {
                //msg = ex.getMessage();
                System.debug('-----Exception while calling create vendor global-----'+msg);
                responseString = ex.getMessage();
                VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            }
        } while ((res.getStatusCode() == 504 || res.getStatusCode() == 0) && numTimes <=4 && !Test.isRunningTest());
        
        return responseString;
    }
}