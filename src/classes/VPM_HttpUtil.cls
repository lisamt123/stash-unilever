public class VPM_HttpUtil {
    
    public static final String successStatus = 'BPM Record Submitted';
    public static final String failStatus = 'MDM Ops Review - SAP BPM submit Failed';
    public static final String successStatusMDM = 'Submitted to BPM';
    public static final String failStatusMDM = 'Failed to Submit to BPM';
    private static final String certName = System.Label.VPM_CertificateName;
    
    public VPM_HttpUtil() {
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
        HttpResponse res;
        try {
            String url;
            if(requestType != null && !requestType.equalsIgnoreCase('GET')) {
                url = createEndPoint(serviceName);
            }
            Http h = new Http();
            HttpRequest req = new HttpRequest();        
            req.setEndpoint(url);
            req.setMethod(requestType);
            if(requestType != null && !requestType.equalsIgnoreCase('GET') && String.isNotBlank(requestBodyJson)) {
                req.setHeader('Content-Type', 'application/json');
                req.setBody(requestBodyJson);
            }
            req.setClientCertificateName(certName);
            //req.setCompressed(true);
            res = h.send(req);
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
        req.setClientCertificateName(certName);
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
    public void updateVendorStatus(String venReqId, String reqStatus, String message, String messageMDM) {
        // Update vendor request record status after send to SAP.
        // Update MDM Ops user fields on vendor request record.
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c, CreatedBy.Email,VPM_MDMBPMRequestorName__c, VPM_MDMBPMRequestorPhone__c, VPM_MDMBPMRequestorEmail__c, VPM_MDMBPMRequestorDepartment__c, VPM_MDMBPMOriginatoEmail__c,VPM_MDMInsertUpdateStatus__c,VPM_MDMInsertUpdateStatusMessage__c FROM VPM_PurchasingRequests__c WHERE Id = :venReqId LIMIT 1];
        List<User> userList = [Select Name, Phone, Email, Department From User Where id = :UserInfo.getUserId()];
        if(vendorList != null && vendorList.size() >0) {
            VPM_PurchasingRequests__c vendor = vendorList.get(0);
            vendor.VPM_Status__c = reqStatus;
            vendor.VPM_MDMInsertUpdateStatusMessage__c = message;
            vendor.VPM_MDMInsertUpdateStatus__c = messageMDM;
            vendor.VPM_MDMBPMOriginatoEmail__c = vendorList.get(0).CreatedBy.Email;
            if(userList != null && userList.size() > 0) {
                vendor.VPM_MDMBPMRequestorName__c = userList.get(0).Name;
                vendor.VPM_MDMBPMRequestorPhone__c = userList.get(0).Phone;
                vendor.VPM_MDMBPMRequestorEmail__c = userList.get(0).Email;
                vendor.VPM_MDMBPMRequestorDepartment__c = userList.get(0).Department;
            }
            update vendor;
        }
    }
    public static Integer generateRandomNumber() {
        Integer len = 9;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, len);
        Integer reqNum = Integer.valueOf(randomNumber);
        system.debug('-------Random Number------' + reqNum);
        return reqNum;
    }
    public static String valueBeforeUnderscore(String inputString) {
        List<String> inputArray = inputString.split('_');
        if(inputArray != null && inputArray.size() >0) {
            return inputArray.get(0);
        } else {
            return '';
        }
    }
    public static Map<String,String> fetchUserDetails() {
        Map<String, String> userDetails = new Map<String, String>();
        List<User> userList = [Select Name, Phone, Email, Department From User Where id = :UserInfo.getUserId()];
        if(userList != null && userList.size() > 0) {
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
    public static boolean convertYesNoToBoolean(String inputString) {
        boolean booleanValue = false;
        if(String.isNotBlank(inputString) && 'Yes'.equalsIgnoreCase(inputString)) {
            booleanValue = true;
        } else {
            booleanValue = false;
        }
        return booleanValue;
    }
}