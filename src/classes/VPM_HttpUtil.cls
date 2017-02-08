/*********************************************************************************************************
Name:  VPM_HttpUtil 
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  Conatins logic for all service callouts.
          Conatins logic for SAP data formating.   
1. VPM_HttpUtil 

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Girish      --              INITIAL DEVELOPMENT       Build search Vendor,web service callout
2.0 -    Ajay      29 June 2016      Callouts                  Regional and Global maintatin service callout.
3.0 -    Deepak    3rd Oct 2016      Callouts                  Regional and Global Extend Service callout.
************************************************************************************************************/
public with sharing class VPM_HttpUtil {
    
    class CreateVendorResponse {
        public String Status {get; set;}
        public String RequestID {get; set;}
        public CreateVendorResponse() {
        }
    }
    class CreateVendorFailureResponse {
        public String statusCode {get; set;}
        public String message {get; set;}
        public String details {get; set;}
        public CreateVendorFailureResponse() {
        }
    }
    
    public static final String successStatus = 'BPM Record Submitted'; // VPM_Status__c
    public static final String failStatus = 'MDM Ops Review - SAP BPM submit Failed';// VPM_Status__c
     public static final String successStatusReqCompleted = 'Request Completed'; // VPM_Status__c
    public static final String successStatusMDM = 'Submitted to BPM';// MDM status
    public static final String failStatusMDM = 'Failed to Submit to BPM';// MDM status
    //private static final String certName = System.Label.VPM_CertificateName;
    private static final String certName = 'vendorbpm_client_test';
    public static final string successStatusECC = 'ECC Insert / Update Succeeded';
    public static final string failStatusECC = 'Failed to Submit to ECC';
    public static final String ECCfailStatus = 'MDM Ops Review - SAP ECC submit Failed';// VPM_Status__c
    
  
  
    /******************************************************************** 
    Created By   : Girish
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : Create end point from salesforce custom metadata.
    Return Type  : String final endpoint after appending client and scerate ID.
    ********************************************************************/
    public static String createEndPoint(String service) {
        String endpoint='',resource ='',clientId ='',clientSecret ='',finalUrl ='';
        List<VPM_ExternalService__mdt> serviceDetails = [SELECT DeveloperName, MasterLabel, VPM_ServiceEndpoint__c, VPM_ServiceResource__c FROM VPM_ExternalService__mdt WHERE DeveloperName = :service];
        if(!serviceDetails.isEmpty()) {
            endpoint = serviceDetails.get(0).VPM_ServiceEndpoint__c;
            resource = serviceDetails.get(0).VPM_ServiceResource__c;
        }
        clientId = System.Label.VPM_ClientId;
        clientSecret = System.Label.VPM_ClientSecret;
        finalUrl = endpoint + resource + '?client_id=' + clientId + '&client_secret=' + clientSecret;
        System.debug('---HttpUtil-createEndPoint--final endpoint url-------'+ finalUrl);
        return finalUrl;
    }
    
    /******************************************************************** 
    Created By   : Girish
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : Send final response to SAP. HTTP GET response
    Return Type  : HttpResponse.
    ********************************************************************/
    public static HttpResponse sendRequest(String requestType, String requestBodyJson, String serviceName , String VenId) {
        HttpResponse res = null;
        try {
            String url ='';
            if(requestType != null && !requestType.equalsIgnoreCase('GET')) {
                url = VPM_HttpUtil.createEndPoint(serviceName);
            }
            VPM_PurchasingRequests__c purReq = [Select id ,VPM_SAPBPMRequestID__c from VPM_PurchasingRequests__c where id =:VenId limit 1];
            Http h = new Http();
            HttpRequest req = new HttpRequest();        
            req.setEndpoint(url);
            req.setMethod(requestType);
            if(requestType != null && !requestType.equalsIgnoreCase('GET') && String.isNotBlank(requestBodyJson)) {
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('salesforceid',purReq.VPM_SAPBPMRequestID__c);
                req.setBody(requestBodyJson);
            }
            req.setTimeout(120000);
           if(test.isRunningTest())
            {
                req.setClientCertificateName(certName);
            }
            else{ 
                req.setClientCertificateName(certName);
            }  
            
            system.debug('before callout time='+system.now());
            res = h.send(req);
            system.debug('after callout time='+system.now());
        } catch (Exception ex) {
            res = new HttpResponse();
        }
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
        req.setTimeout(120000);
         if(test.isRunningTest())
            {
                req.setClientCertificateName(certName);
            }
            else{
                req.setClientCertificateName(certName);
            }
        //req.setCompressed(true);
        system.debug('before callout time='+system.now());
        res = h.send(req);
        system.debug('After callout time='+system.now());
        return res;
    }
    public String convertRequestParams(Map<String,String> queryParameters) {
        String stringParams='';
        if(!queryParameters.isEmpty()) {
            for(String mapEntry : queryParameters.keySet()) {
                stringParams = stringParams + '&' + EncodingUtil.urlEncode(mapEntry, 'UTF-8') + '=' + 
                    EncodingUtil.urlEncode(queryParameters.get(mapEntry), 'UTF-8');
            }
        }
        return stringParams;
    }

    
    /******************************************************************** 
    Created By   : Deepak
    Created Date : 24 Sep 2016
    Last Modify  : 06 Oct 2016
    Description  : Update vendor request status and MDM service call message
    Return Type  : Void.
    ********************************************************************/
     public static void updateVendorMDMStatus(String venReqId, String reqStatus, String message, String messageMDM) {
        // Update vendor request record status after send to SAP.
        // Update MDM Ops user fields on vendor request record.
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c,VPM_MDMOpsEmail__c,VPM_MDMInsertUpdateStatus__c,VPM_MDMInsertUpdateStatusMessage__c FROM VPM_PurchasingRequests__c WHERE Id = :venReqId LIMIT 1];
       // List<User> userList = [Select Name, Phone, Email, Department From User Where id = :UserInfo.getUserId()];
        if(!vendorList.isEmpty()) {
            VPM_PurchasingRequests__c vendor = vendorList.get(0);
            if(reqStatus != null)
            {
            vendor.VPM_Status__c = reqStatus;
            }
            vendor.VPM_MDMInsertUpdateStatusMessage__c = message;
            vendor.VPM_MDMInsertUpdateStatus__c = messageMDM;
            vendor.VPM_MDMOpsEmail__c = UserInfo.getUserEmail();
            update vendor;
           
            }
        }
        
        
    /******************************************************************** 
    Created By   : Deepak
    Created Date : 24 Sep 2016
    Last Modify  : 06 Oct 2016
    Description  : Update vendor request status and ECC service call message
    Return Type  : Void.
    ********************************************************************/
     public static void updateVendorECCStatus(String venReqId, String reqStatus, String message, String messageECC) {
        // Update vendor request record status after send to SAP.
        // Update MDM Ops user fields on vendor request record.
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c,VPM_MDMOpsEmail__c,VPM_ECC_InsertUpdateStatus__c,VPM_isVendorCached__c,VPM_ECC_InsertUpdateStatusMessage__c FROM VPM_PurchasingRequests__c WHERE Id = :venReqId LIMIT 1];
        //List<User> userList = [Select Name, Phone, Email, Department From User Where id = :UserInfo.getUserId()];
        if(!vendorList.isEmpty()) {
            VPM_PurchasingRequests__c vendor = vendorList.get(0);
            if(string.isNotBlank(reqStatus))
            {
            vendor.VPM_Status__c = reqStatus;
            }
            vendor.VPM_isVendorCached__c=True;
            vendor.VPM_ECC_InsertUpdateStatusMessage__c = message;
            vendor.VPM_ECC_InsertUpdateStatus__c = messageECC;
            vendor.VPM_MDMOpsEmail__c = UserInfo.getUserEmail();
            system.debug('inside failkkk'+vendor.VPM_isVendorCached__c);
            update vendor;
             
            }
         }   

    /******************************************************************** 
    Created By   : Ajay
    Created Date : 24 June 2016
    Last Modify  : 06 July 2016
    Description  : Extract value before updescore value from picklist.
    Return Type  : Void.
    ********************************************************************/
    public static String valueBeforeUnderscore(String inputString) {
    if(string.isNotBlank(inputString)){
        List<String> inputArray = inputString.split('_');
        if(!inputArray.isEmpty()) {
            return inputArray.get(0);
        } else {
            return '';
        }
        }
        return '';
    }
    public static Map<String,String> fetchUserDetails() {
        Map<String, String> userDetails = new Map<String, String>();
        List<User> userList = [Select Name, Phone, Email, Department From User Where id = :UserInfo.getUserId()];
        if(!userList.isEmpty()) {
            userDetails.put('userName',userList.get(0).Name);
            if(String.isNotBlank(userList.get(0).Phone)) {
                if(userList.get(0).Phone.length() > 20){
                    userDetails.put('userPhone',userList.get(0).Phone.Substring(0,19));
                } else {
                    userDetails.put('userPhone',userList.get(0).Phone);
                }
            } else {
                userDetails.put('userPhone','');
            }
            userDetails.put('name',userList.get(0).Name);
            userDetails.put('userEmail',userList.get(0).Email);
            userDetails.put('userDepartment',userList.get(0).Department);
        }
        return userDetails;
    }
    public static void updateFieldOnRecord(String idOfRecord, String fieldName, String fieldValue) {
        Id recordId = idOfRecord;
        System.debug('-------'+recordId.getSObjectType());
        SObject o1 = recordId.getSObjectType().newSObject(recordId);
        o1.put(fieldName,fieldValue);
        System.debug('------' + o1.get(fieldName));
        update o1;
    }
    
    /******************************************************************** 
    Created By   : Deepak
    Created Date : 2 Oct 2016
    Last Modify  : 6 Oct 2016
    Description  : Update vendor cache after Global Create Successfull.
    Return Type  : Void.
    ********************************************************************/
     public static void updateRecordType(String venReqId) {
            
        VPM_PurchasingRequests__c vendorList = [SELECT Id,VPM_isVendorCached__c, RecordTypeId,VPM_FieldType__c  FROM VPM_PurchasingRequests__c WHERE Id = :venReqId LIMIT 1];
        //recordType rec = [select Name, id from recordType where Name like '%Maintain%' limit 1];
       //vendorList.RecordTypeId = rec.id;
       vendorList.VPM_isVendorCached__c= true;
       //vendorList.VPM_FieldType__c = 'Regional';
        update vendorList;
        }
    public static boolean convertYesNoToBoolean(String inputString) {
        boolean booleanValue = false;
        if(String.isNotBlank(inputString) && 'Yes'.equalsIgnoreCase(inputString)) {
            booleanValue = true;
        } else {
            booleanValue = false;
        }
        return booleanValue;
    }
    
    /******************************************************************** 
    Created By   : Deepak
    Created Date : 2 Oct 2016
    Last Modify  : 6 Oct 2016
    Description  : Retry call after first scervice call failed
    Return Type  : String.
    ********************************************************************/
    public static String retryCreateVendorGlobal(String inputRetry, String vendorId) {
        System.debug('-----input json request body for create vendor is-----' + inputRetry);
        String msg = '', responseString;
        CreateVendorResponse createVenResp;
        CreateVendorFailureResponse createVenFailResp;
        HttpResponse res = sendRequest('POST',inputRetry,'VPM_CreateVendorBPM',vendorId);
        System.debug('------whole response string----'+ res.toString());
        System.debug('------HTTP response status and status code and response body are ------'+res.getStatus() + '  ' + res.getStatusCode() + '  '+res.getBody());
        // String statusCodeStr = String.valueOf(res.getStatusCode());
        if(String.isNotBlank(res.getBody())) {
            if(res.getStatusCode() == 200) {
                createVenResp = (CreateVendorResponse) System.JSON.deserialize(res.getBody(), CreateVendorResponse.class);
                System.debug('---RequestID --and response status----' + createVenResp.RequestID + '  ' + createVenResp.status);
                if(createVenResp != null && String.isNotBlank(createVenResp.status)) {
                    msg = createVenResp.status + '  ' + res.getStatusCode();
                }
            } else {
                createVenFailResp = (CreateVendorFailureResponse) System.JSON.deserialize(res.getBody(), CreateVendorFailureResponse.class);
                System.debug('---statusCode --and message are ----' + createVenFailResp.statusCode + '  ' + createVenFailResp.message);
                if(createVenFailResp != null && String.isNotBlank(createVenFailResp.message)) {
                    msg = createVenFailResp.message + '  ' + res.getStatusCode();
                }
            }
        }
        if(res.getStatusCode() == 200) {
            updateVendorMDMStatus(vendorId,VPM_HttpUtil.successStatus,msg,VPM_HttpUtil.successStatusMDM);
            //responseString = 'Vendor Request submitted to SAP.'+msg ;
            responseString = msg;
        } 

        else if(res.getStatusCode() == 0) {
            
            responseString = 'Some error occured while submitting request to SAP. Please try after some time.' ;
            updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,responseString,VPM_HttpUtil.failStatusMDM);
            //responseString = msg;
            
        } else {
            //responseString = 'Some error occured while submitting request to SAP. Please try after some time.' + '  ' + res.getStatusCode();
            
            updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            return msg;
        }
        return responseString;
    }
    public static void updateFieldType(String vendorId)
    {
        VPM_PurchasingRequests__c vendor = [Select Id , VPM_FieldType__c from VPM_PurchasingRequests__c where id=: vendorId limit 1];
        //vendor.VPM_FieldType__c = 'Regional';
        update vendor;
    }
    
    /******************************************************************** 
    Created By   : Deepak
    Created Date : 2 Oct 2016
    Last Modify  : 6 Oct 2016
    Description  : Send Email and payload after service call
    Return Type  : String.
    ********************************************************************/
  /*  public static void sendEmail(String toEmail, String subjectEmail, String bodyEmail) {
        List<String> toAddressList = new List<String>();
        toAddressList.add(toEmail);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = toAddressList;
        message.subject = subjectEmail;
        message.plainTextBody = bodyEmail;
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }*/
}