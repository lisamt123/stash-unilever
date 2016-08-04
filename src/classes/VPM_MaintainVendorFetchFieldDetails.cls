public  class VPM_MaintainVendorFetchFieldDetails {
    public string VPM_ConvertMaintainVendorFieldDetailsToJSON(string VendorRequestId) {
        String maintainVendorObjectJSON;
        Integer reqNum = VPM_HttpUtil.generateRandomNumber();
        Map<String,String> mapUserDetails = VPM_HttpUtil.fetchUserDetails();
        System.debug('-------Random Number------' + reqNum);
        List<VPM_PurchasingRequests__c> vendorList =[SELECT VPM_MDMBPMRequestorName__c, VPM_MDMBPMRequestorPhone__c, VPM_MDMBPMRequestorEmail__c, VPM_CountryRequestingVendor__c,
                                                     VPM_MDMBPMRequestorDepartment__c, VPM_MDMBPMRequestDate__c, VPM_VendorCode__c, VPM_Comments__c, VPM_ECCSystem__c, VPM_VendorName1__c, 
                                                     VPM_VendorName2__c,VPM_Name3__c,VPM_Name4__c, VPM_SearchTerm_1__c,VPM_SearchTerm2__c, VPM_Street1__c,VPM_Street2__c,VPM_Street3__c,
                                                     VPM_Street4__c,VPM_HouseNumber__c,VPM_HouseNumSupplement__c,VPM_ZIPPostCode__c, VPM_Regions__r.VPM_Code__c,VPM_Country__c,VPM_City__c,VPM_District__c, 
                                                     VPM_IsVendorSME__c, VPM_IsVendorException__c, VPM_ExceptionType__c, VPM_POBox__c, VPM_POBoxPostCode__c, VPM_TaxNumber1__c, VPM_TaxNumber2__c, 
                                                     VPM_TaxNumber3__c, VPM_TaxNumber4__c, VPM_VATRegistrationNumber__c, VPM_TaxNumberType__c, VPM_TaxJurisdictionCode__c, 
                                                     VPM_TaxNumAtResponsibleTaxAuthority__c, VPM_CreditInfoNumber__c, VPM_CorporateGrp__c, VPM_IntLocationNumber1__c, VPM_IntLocationNumber2__c, 
                                                     VPM_ExtManufacturer__c, VPM_CheckDigit__c from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
        System.debug('@@VendorRequestId@@'+VendorRequestId);
        System.debug('@@vendorList@@'+vendorList.size());
        if(vendorList != null && vendorList.size() > 0) {
            VPM_MaintainVendorFieldDetailsWrapper maintainVendorObject= new VPM_MaintainVendorFieldDetailsWrapper();
            //maintainVendorObject.requestNumber = vendorList.get(0).VPM_SAPBPMRequestID__c == null?'':vendorList.get(0).VPM_SAPBPMRequestID__c;
            maintainVendorObject.RequestNumber = reqNum;
            maintainVendorObject.RequestorName = vendorList.get(0).VPM_MDMBPMRequestorName__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorName__c;
            if(mapUserDetails != null && mapUserDetails.containsKey('userPhone')) {
                if(String.isNotBlank(mapUserDetails.get('userPhone'))) {
                    maintainVendorObject.RequestorPhone = mapUserDetails.get('userPhone');
                } else {
                    maintainVendorObject.RequestorPhone = '01';
                }
            } else {
                maintainVendorObject.RequestorPhone = vendorList.get(0).VPM_MDMBPMRequestorPhone__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorPhone__c;
            }
            //maintainVendorObject.RequestorPhone = vendorList.get(0).VPM_MDMBPMRequestorPhone__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorPhone__c;
            if(mapUserDetails != null && mapUserDetails.containsKey('userEmail')) {
                if(String.isNotBlank(mapUserDetails.get('userEmail'))) {
                    maintainVendorObject.RequestorEmail = mapUserDetails.get('userEmail');
                } else {
                    maintainVendorObject.RequestorEmail = 'a@a.com';
                }
            } else {
                maintainVendorObject.RequestorEmail = vendorList.get(0).VPM_MDMBPMRequestorEmail__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorEmail__c;
            }
            //maintainVendorObject.RequestorEmail = vendorList.get(0).VPM_MDMBPMRequestorEmail__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorEmail__c;
            if(mapUserDetails != null && mapUserDetails.containsKey('userDepartment')) {
                if(String.isNotBlank(mapUserDetails.get('userDepartment'))) {
                    maintainVendorObject.mdmBPMRequestorDepartment = mapUserDetails.get('userDepartment');
                } else {
                    maintainVendorObject.mdmBPMRequestorDepartment = 'Default Role';
                }
            } else {
                maintainVendorObject.mdmBPMRequestorDepartment = vendorList.get(0).VPM_MDMBPMRequestorDepartment__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorDepartment__c;
            }
            //maintainVendorObject.mdmBPMRequestorDepartment = vendorList.get(0).VPM_MDMBPMRequestorDepartment__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorDepartment__c;
            maintainVendorObject.requestorCountry = vendorList.get(0).VPM_Country__c==null?'':vendorList.get(0).VPM_Country__c;
            Date requestDt = vendorList.get(0).VPM_MDMBPMRequestDate__c;
            maintainVendorObject.RequestDate = requestDt==null?'':requestDt.format();
            //maintainVendorObject.originatorEmail = vendorList.get(0).VPM_MDMBPMOriginatoEmail__c==null?'':vendorList.get(0).VPM_MDMBPMOriginatoEmail__c;
            maintainVendorObject.vendorCode = vendorList.get(0).VPM_VendorCode__c==null?'':vendorList.get(0).VPM_VendorCode__c;
            maintainVendorObject.VendorNumber = vendorList.get(0).VPM_VendorCode__c==null?'':vendorList.get(0).VPM_VendorCode__c;
            maintainVendorObject.vendorName1c = vendorList.get(0).VPM_VendorName1__c==null?'':vendorList.get(0).VPM_VendorName1__c;
            maintainVendorObject.mdmBpmComments=vendorList.get(0).VPM_Comments__c==null?'':vendorList.get(0).VPM_Comments__c;
            //need to transform value
            //maintainVendorObject.extendRegion = vendorList.get(0).VPM_ECCSystem__c==null?'':vendorList.get(0).VPM_ECCSystem__c;
            maintainVendorObject.vendorName1 = vendorList.get(0).VPM_VendorName1__c==null?'':vendorList.get(0).VPM_VendorName1__c;
            maintainVendorObject.vendorName12 = vendorList.get(0).VPM_VendorName2__c==null?'':vendorList.get(0).VPM_VendorName2__c;
            maintainVendorObject.vendorName3 = vendorList.get(0).VPM_Name3__c==null?'':vendorList.get(0).VPM_Name3__c;
            maintainVendorObject.vendorName4 = vendorList.get(0).VPM_Name4__c==null?'':vendorList.get(0).VPM_Name4__c;
            maintainVendorObject.searchTerm1 = vendorList.get(0).VPM_SearchTerm_1__c==null?'':vendorList.get(0).VPM_SearchTerm_1__c;
            maintainVendorObject.searchTerm2 = vendorList.get(0).VPM_SearchTerm2__c==null?'':vendorList.get(0).VPM_SearchTerm2__c;
            maintainVendorObject.Street1 = vendorList.get(0).VPM_Street1__c==null?'':vendorList.get(0).VPM_Street1__c;
            maintainVendorObject.Street2  = vendorList.get(0).VPM_Street2__c==null?'':vendorList.get(0).VPM_Street2__c;
            maintainVendorObject.Street3   = vendorList.get(0).VPM_Street3__c==null?'':vendorList.get(0).VPM_Street3__c;
            maintainVendorObject.Street4 = vendorList.get(0).VPM_Street4__c==null?'':vendorList.get(0).VPM_Street4__c;
            maintainVendorObject.houseNumber = vendorList.get(0).VPM_HouseNumber__c==null?'':vendorList.get(0).VPM_HouseNumber__c;
            maintainVendorObject.houseNumberSupplement = vendorList.get(0).VPM_HouseNumSupplement__c==null?'No':vendorList.get(0).VPM_HouseNumSupplement__c;
            //maintainVendorObject.countryRequestingVendor  = vendorList.get(0).VPM_ZIPPostCode__c==null?'No':vendorList.get(0).VPM_ZIPPostCode__c;
            maintainVendorObject.zipPostCode  = vendorList.get(0).VPM_ZIPPostCode__c==null?'No':vendorList.get(0).VPM_ZIPPostCode__c;
            maintainVendorObject.region  = vendorList.get(0).VPM_Regions__r.VPM_Code__c==null?'':vendorList.get(0).VPM_Regions__r.VPM_Code__c;
            maintainVendorObject.country  = vendorList.get(0).VPM_Country__c==null?'No':vendorList.get(0).VPM_Country__c;
            maintainVendorObject.city  = vendorList.get(0).VPM_City__c==null?'':vendorList.get(0).VPM_City__c;
            maintainVendorObject.district  = vendorList.get(0).VPM_District__c==null?'No':vendorList.get(0).VPM_District__c;
            maintainVendorObject.isVendorSME  = vendorList.get(0).VPM_IsVendorSME__c==null?'':vendorList.get(0).VPM_IsVendorSME__c;
            maintainVendorObject.isVendorException  = vendorList.get(0).VPM_IsVendorException__c==null?'':vendorList.get(0).VPM_IsVendorException__c;
            maintainVendorObject.exceptionType  = vendorList.get(0).VPM_ExceptionType__c==null?'': vendorList.get(0).VPM_ExceptionType__c;
            maintainVendorObject.poBox  = vendorList.get(0).VPM_POBox__c==null?'':vendorList.get(0).VPM_POBox__c;
            maintainVendorObject.poBoxPostCode  = vendorList.get(0).VPM_POBoxPostCode__c==null?'':vendorList.get(0).VPM_POBoxPostCode__c;
            maintainVendorObject.taxNumber1  = vendorList.get(0).VPM_TaxNumber1__c==null?'':vendorList.get(0).VPM_TaxNumber1__c;
            maintainVendorObject.taxNumber2  = vendorList.get(0).VPM_TaxNumber2__c==null?'':vendorList.get(0).VPM_TaxNumber2__c;
            maintainVendorObject.taxNumber3  = vendorList.get(0).VPM_TaxNumber3__c==null?'':vendorList.get(0).VPM_TaxNumber3__c;
            maintainVendorObject.taxNumber4  = vendorList.get(0).VPM_TaxNumber4__c==null?'':vendorList.get(0).VPM_TaxNumber4__c;
            maintainVendorObject.vatRegistrationNumber  = vendorList.get(0).VPM_VATRegistrationNumber__c==null?'':vendorList.get(0).VPM_VATRegistrationNumber__c;
            //need to transform value
            //IsNaturalPerson field was removed from object.
            maintainVendorObject.isNaturalPerson ='No';
            maintainVendorObject.taxNumberType    = vendorList.get(0).VPM_TaxNumberType__c==null?'':vendorList.get(0).VPM_TaxNumberType__c;
            maintainVendorObject.taxJurisdictionCode  = vendorList.get(0).VPM_TaxJurisdictionCode__c==null?'':vendorList.get(0).VPM_TaxJurisdictionCode__c;
            maintainVendorObject.taxNumAtResponsibleTaxAuthority  = vendorList.get(0).VPM_TaxNumAtResponsibleTaxAuthority__c==null?'No': String.valueOf(vendorList.get(0).VPM_TaxNumAtResponsibleTaxAuthority__c);
            maintainVendorObject.creditInfoNumber  = vendorList.get(0).VPM_CreditInfoNumber__c==null?'':vendorList.get(0).VPM_CreditInfoNumber__c;
            maintainVendorObject.corporateGrp  = vendorList.get(0).VPM_CorporateGrp__c==null?'':vendorList.get(0).VPM_CorporateGrp__c;
            maintainVendorObject.intLocationNumber1  = vendorList.get(0).VPM_IntLocationNumber1__c==null?'':vendorList.get(0).VPM_IntLocationNumber1__c;
            maintainVendorObject.intLocationNumber2  = vendorList.get(0).VPM_IntLocationNumber2__c==null?'':vendorList.get(0).VPM_IntLocationNumber2__c;
            maintainVendorObject.extManufacturer  = vendorList.get(0).VPM_ExtManufacturer__c==null?'':vendorList.get(0).VPM_ExtManufacturer__c;
            maintainVendorObject.checkDigit  = vendorList.get(0).VPM_CheckDigit__c==null?'':vendorList.get(0).VPM_CheckDigit__c;            
            maintainVendorObjectJSON = JSON.serialize(maintainVendorObject);
            System.debug('-----JSON object-----' + maintainVendorObjectJSON);
        }
        return maintainVendorObjectJSON;
    }
}