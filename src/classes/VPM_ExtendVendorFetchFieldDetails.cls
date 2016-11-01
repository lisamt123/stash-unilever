public class VPM_ExtendVendorFetchFieldDetails {
    public String VPM_ConvertExtendVendorFieldDetailsToMap(string VendorRequestId) {
        
        String extendVendorObjectJSON;
        Integer len = 9;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, len);
        system.debug('-------Random Number------' + randomNumber);
        Map<String,String> mapUserDetails = VPM_HttpUtil.fetchUserDetails();
        List<VPM_PurchasingRequests__c> vendorList =[SELECT VPM_VendorName1__c,VPM_MDMBPMRequestorEmail__c,VPM_MDMBPMRequestorDepartment__c,VPM_MDMBPMOriginatoEmail__c,VPM_Comments__c, VPM_SAPBPMRequestID__c,VPM_MDMBPMRequestorPhone__c,
                                        VPM_MDMBPMRequestorName__c,VPM_Country__c, VPM_MDMBPMRequestDate__c, VPM_VendorCode__c, VPM_Region__c from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
        if(vendorList != null && vendorList.size() > 0) {
        VPM_ExtendGlobalFieldDetailsWrapper extendVendor = new VPM_ExtendGlobalFieldDetailsWrapper();
           // VPM_CreateVendorFieldDetailsWrapper VPM_InterfaceFieldDetails= new VPM_CreateVendorFieldDetailsWrapper();
            if(mapUserDetails != null && mapUserDetails.containsKey('userPhone')) {
                if(String.isNotBlank(mapUserDetails.get('userPhone'))) {
                    extendVendor.RequestorPhone = mapUserDetails.get('userPhone');
                } else {
                    extendVendor.RequestorPhone = '01';
                }
            } 
            else {
                extendVendor.RequestorPhone = vendorList.get(0).VPM_MDMBPMRequestorPhone__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorPhone__c;
            }
            if(mapUserDetails != null && mapUserDetails.containsKey('userEmail')) {
                if(String.isNotBlank(mapUserDetails.get('userEmail'))) {
                    extendVendor.RequestorEmail = mapUserDetails.get('userEmail');
                } else {
                    extendVendor.RequestorEmail = 'a@a.com';
                }
            } else {
                extendVendor.RequestorEmail = vendorList.get(0).VPM_MDMBPMRequestorEmail__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorEmail__c;
            }
           
            if(mapUserDetails != null && mapUserDetails.containsKey('userDepartment')) {
                if(String.isNotBlank(mapUserDetails.get('userDepartment'))) {
                    extendVendor.RequestorDepartment = mapUserDetails.get('userDepartment');
                } else {
                    extendVendor.RequestorDepartment = 'Default Role';
                }
            } else {
                extendVendor.RequestorDepartment = vendorList.get(0).VPM_MDMBPMRequestorDepartment__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorDepartment__c;
            }
            extendVendor.RequestID = vendorList.get(0).VPM_SAPBPMRequestID__c;
            extendVendor.vendorName = vendorList.get(0).VPM_VendorName1__c==null?'':vendorList.get(0).VPM_VendorName1__c;
            extendVendor.RequestorName = vendorList.get(0).VPM_MDMBPMRequestorName__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorName__c;
            Date requestDt = vendorList.get(0).VPM_MDMBPMRequestDate__c;
            extendVendor.RequestDate = requestDt==null?'':requestDt.format();
            extendVendor.originatorEmail = vendorList.get(0).VPM_MDMBPMOriginatoEmail__c==null?'':vendorList.get(0).VPM_MDMBPMOriginatoEmail__c;
            extendVendor.RequestorCountry = vendorList.get(0).VPM_Country__c==null?'':vendorList.get(0).VPM_Country__c;
            extendVendor.vendorCode = vendorList.get(0).VPM_VendorCode__c==null?'':vendorList.get(0).VPM_VendorCode__c;
            extendVendor.BpmComments=vendorList.get(0).VPM_Comments__c==null?'':vendorList.get(0).VPM_Comments__c;
            extendVendorObjectJSON = JSON.serialize(extendVendor);
        }
        return extendVendorObjectJSON;
    }
}