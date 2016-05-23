public class VPM_ExtendVendorFetchFieldDetails {
    public Map<String, String> VPM_ConvertExtendVendorFieldDetailsToMap(string VendorRequestId) {
        Map<String, String> extendGlobalRequestParams = new Map<String, String>();
        Integer len = 9;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, len);
        system.debug('-------Random Number------' + randomNumber);
        
        List<VPM_PurchasingRequests__c> vendorList =[SELECT VPM_SAPBPMRequestID__c, VPM_VendorName1__c, VPM_MDMBPMRequestorName__c, VPM_MDMBPMRequestDate__c, VPM_VendorCode__c, VPM_MDMBPMComments__c, VPM_Region__c from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
        if(vendorList != null && vendorList.size() > 0) {
            VPM_CreateVendorFieldDetailsWrapper VPM_InterfaceFieldDetails= new VPM_CreateVendorFieldDetailsWrapper();
            //VPM_InterfaceFieldDetails.requestNumber = vendorList.get(0).VPM_SAPBPMRequestID__c == null?'':vendorList.get(0).VPM_SAPBPMRequestID__c;
            
            extendGlobalRequestParams.put('requestNumber',randomNumber);
            extendGlobalRequestParams.put('vendorName',vendorList.get(0).VPM_VendorName1__c==null?'':vendorList.get(0).VPM_VendorName1__c);
            extendGlobalRequestParams.put('requestorName',vendorList.get(0).VPM_MDMBPMRequestorName__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorName__c);
            Date requestDt = vendorList.get(0).VPM_MDMBPMRequestDate__c;
            extendGlobalRequestParams.put('requestDate',requestDt==null?'':requestDt.format());
            extendGlobalRequestParams.put('vendorCode',vendorList.get(0).VPM_VendorCode__c==null?'':vendorList.get(0).VPM_VendorCode__c);
            extendGlobalRequestParams.put('mdmBpmcomments',vendorList.get(0).VPM_MDMBPMComments__c==null?'':vendorList.get(0).VPM_MDMBPMComments__c);
            extendGlobalRequestParams.put('extendRegion',vendorList.get(0).VPM_Region__c==null?'':vendorList.get(0).VPM_Region__c);

        }
        return extendGlobalRequestParams;
    }
}