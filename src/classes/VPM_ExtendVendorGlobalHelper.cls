global class VPM_ExtendVendorGlobalHelper {
    global class ExtendVendorResponse {
        public String status {get; set;}
        public String bpmID {get; set;}
        public ExtendVendorResponse() {
        }
    }
    global static void extendVendorGlobal(String vendorId) {
        System.debug('----------input parameters passed are----------' + vendorId);
        Map<String, String> reqURLParams;
        String requestStatus;
        VPM_ExtendVendorFetchFieldDetails clas = new VPM_ExtendVendorFetchFieldDetails();
        reqURLParams = clas.VPM_ConvertExtendVendorFieldDetailsToMap(vendorId);
        System.debug('------map of request URL params is-----'+reqURLParams);
        
        ExtendVendorResponse extendVenResp;
        String url = 'https://vendor-bpm-uat.eu.cloudhub.io/vendor-api/vendor/global/extend?client_id=3485ee8279af458abc58065291e188d4&client_secret=ca16126215ea409498F4296ADB25EAB5';
        url = url + '&requestNumber='+reqURLParams.get('requestNumber')+'&vendorName='+reqURLParams.get('vendorName') +
            '&requestorName='+reqURLParams.get('requestorName')+'&requestDate='+reqURLParams.get('requestDate') +
            '&vendorCode='+reqURLParams.get('vendorCode')+'&mdmBpmComments='+reqURLParams.get('mdmBpmcomments') +
            '&extendRegion='+reqURLParams.get('extendRegion');
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();        
        req.setEndpoint(url);
        req.setMethod('PUT');
        //req.setHeader('Content-Type', 'application/json');
        //req.setBody(reqBodyJson);
        //req.setCompressed(true);
        res = h.send(req);
        System.debug('----------'+ res.toString());
        System.debug('------HTTP response status and status code are ------'+res.getStatus() + '  ' + res.getStatusCode());
        System.debug('----------'+ res.getBody() + '  ' + res.getHeaderKeys());        
        if(res.getStatusCode() == 200) {
            requestStatus = 'BPM Record Submitted';
            updateExtendGlobalVendorStatus(vendorId,requestStatus);
            extendVenResp = (ExtendVendorResponse) System.JSON.deserialize(res.getBody(), ExtendVendorResponse.class);
            System.debug('---bpm id ---' + extendVenResp.bpmID);
            System.debug('---response status ---' + extendVenResp.status);
        } else {
            requestStatus = 'MDM Ops Review - SAP BPM submit Failed';
            updateExtendGlobalVendorStatus(vendorId,requestStatus);
        }
        /*if (res.getStatusCode() == 200 && String.isNotBlank(res.getBody())) {
System.debug('----vendorDetails----'+res.getBody());
}*/
    }
    global static void updateExtendGlobalVendorStatus(String venReqId, String reqStatus) {
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c FROM VPM_PurchasingRequests__c WHERE
                                                      Id = :venReqId LIMIT 1];        
        if(vendorList != null && vendorList.size() >0) {
            VPM_PurchasingRequests__c vendor = vendorList.get(0);
            vendor.VPM_Status__c= reqStatus;
            update vendor;
        }
    }
}