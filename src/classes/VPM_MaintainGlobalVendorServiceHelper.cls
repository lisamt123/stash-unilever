global class VPM_MaintainGlobalVendorServiceHelper {
    
        global class errorMsgWrapper
        {
            public String Message {get;set;}
            public String MessageV1 {get;set;}
            public String Field {get;set;}
            public String Type {get;set;}
            public String ID {get;set;}

        }
    global class MaintainGlobalVendorResponse { 
        public String status {get; set;}
        public String bpmID {get; set;}
        
    }
    global static String maintainGlobalVendor(String vendorId) {
        System.debug('----------input parameters passed are----------' + vendorId);
        String reqBodyJson, requestStatus,responseString ;
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
        string msg='';
        if(maintainVenResp.status != null) {
            msg = maintainVenResp.status;
        }
        if(res.getStatusCode() == 200) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.successStatus,msg,VPM_HttpUtil.successStatusMDM);
            responseString = 'Vendor Request submitted successfully to SAP.';
        } else if(res.getStatusCode() == 500) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Server Error. Please try after some time.';
        } else if(res.getStatusCode() == 504) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Timeout Error. Please try after some time.';
        } else if(res.getStatusCode() == 400) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Please check request data and try again.';
        } else if(res.getStatusCode() == 503) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'SAP API not implemented.';
        } else {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Some error occured while submitting request to SAP. Please try after some time.';
        }
        return responseString;
    }
    


    // Ajay : For Regional maintain
     global static String maintainECCVendor(String vendorId) 
        {
       String reqBodyJson, requestStatus,responseString ;
        MaintainGlobalVendorResponse maintainVenResp;
        list<errorMsgWrapper> errorList;
        //VPM_MaintainVendorFetchFieldDetails clas = new VPM_MaintainVendorFetchFieldDetails();
        //reqBodyJson = clas.VPM_ConvertMaintainVendorFieldDetailsToJSON(vendorId);
        VPM_MaintainVendorFetchFieldMap maintainService = new VPM_MaintainVendorFetchFieldMap();
        reqBodyJson = maintainService.VPM_ConvertMaintainVendorFieldDetailsToJSON(vendorId);
        system.debug('reqBodyJson '+reqBodyJson );
        VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = utilClass.sendRequest('PUT',reqBodyJson,'VPM_ECCVendorSearch');
        maintainVenResp = (MaintainGlobalVendorResponse) System.JSON.deserialize(res.getBody(), MaintainGlobalVendorResponse.class);
        string msg='';
         system.debug('res '+res);
        system.debug('maintainVenResp.status'+maintainVenResp.status);
        if(maintainVenResp.status != null) {
            msg = maintainVenResp.status;
        }
        VPM_PurchasingRequests__c VendorReq = [SELECT VPM_ECC_InsertUpdateStatusMessage__c FROM VPM_PurchasingRequests__c WHERE id =: vendorId];
        if(res.getStatusCode() == 200) {
            /*utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.successStatus,msg,VPM_HttpUtil.successStatusMDM);
            responseString = 'Vendor Request submitted successfully to SAP.';*/
             errorList= (List<errorMsgWrapper>) System.JSON.deserialize(res.getBody(), List<errorMsgWrapper>.class);
             for(errorMsgWrapper error : errorList)
             {
              responseString = error.Message+';';
              if(error.Type == 'E' )
              {
             
              VendorReq.VPM_ECC_InsertUpdateStatus__c = 'Failed to Submit to ECC';
             
            }
            else if(error.Type == 'S')
            {
             VendorReq.VPM_ECC_InsertUpdateStatus__c = 'ECC Insert / Update Succeeded';
            }
             
             }
             VendorReq.VPM_ECC_InsertUpdateStatusMessage__c = responseString;
             update VendorReq;
             system.debug('Error List '+errorList);
              //responseString = 'Vendor Request submitted successfully to SAP.';
            
        } else if(res.getStatusCode() == 500) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Server Error. Please try after some time.';
        } else if(res.getStatusCode() == 504) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Timeout Error. Please try after some time.';
        } else if(res.getStatusCode() == 400) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Please check request data and try again.';
        } else if(res.getStatusCode() == 503) {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'SAP API not implemented.';
        } else {
            utilClass.updateVendorStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = 'Some error occured while submitting request to SAP. Please try after some time.';
        }
        return responseString;
    }
}