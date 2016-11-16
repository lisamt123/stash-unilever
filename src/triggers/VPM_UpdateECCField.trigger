trigger VPM_UpdateECCField on VPM_CompanyCode__c (after update) {
    Map<id,VPM_CompanyCode__c> VPM_CompanyCodeMap =Trigger.OldMap;
    list <VPM_PurchasingRequests__c> VendorRequestList =[SELECT VPM_ECC__c,VPM_CompanyCode__c, id from VPM_PurchasingRequests__c where VPM_CompanyCode__c =: VPM_CompanyCodeMap.keySet()];
      for(VPM_CompanyCode__c companyCodeObj : Trigger.new)
    {
        VPM_CompanyCode__c oldValue =VPM_CompanyCodeMap.get(companyCodeObj.id);
        if(oldValue.ECC__c != companyCodeObj.ECC__c)
        {
            for(VPM_PurchasingRequests__c vendorReq : VendorRequestList)    
            {
                    vendorReq.VPM_ECC__c = companyCodeObj.ECC__c;
                    //VendorRequestListToUpdate.add(vendorReq);   
            } 
        }
    }
    system.debug('@@vendorReq '+VendorRequestList); 
    if(VendorRequestList.size()>0)
    update VendorRequestList;
 
}