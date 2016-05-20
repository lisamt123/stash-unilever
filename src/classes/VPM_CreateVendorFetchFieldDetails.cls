public class VPM_CreateVendorFetchFieldDetails {
    public string VPM_ConvertVendorFieldDetailsToJSON(string VendorRequestId) {
        String VPM_InterfaceFieldDetailsJSON;
        Integer len = 9;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, len);
        Integer reqNum = Integer.valueOf(randomNumber);
        system.debug('-------Random Number------' + reqNum);
        List<VPM_PurchasingRequests__c> vendorList =[SELECT VPM_SAPBPMRequestID__c, VPM_VendorType__c, VPM_CountryRequestingVendor__c, VPM_GlobalAuthorisationGroup__c, VPM_ECC__c, VPM_TradePartnerType__c, VPM_AccountGroup__c, VPM_VendorName1__c, VPM_SearchTerm1__c, VPM_Street1__c, VPM_ZIPPostCode__c, VPM_City__c,
                                                     VPM_Country__c, VPM_HouseNumber__c, VPM_Region__c, VPM_IsVendorSME__C, VPM_IsVendorException__c, VPM_ExceptionType__c, VPM_TaxNumber1__c, VPM_TaxNumber3__c, VPM_TaxJurisdictionCode__c, VPM_SupplierFinancialStabilityCheck__c, VPM_ReasonNoFinancialCheck__C, VPM_SupplierAchillesRegistration__c, VPM_AchillesExceptionDetails__C, 
                                                     VPM_SupplierPositiveAssuranceQuality__c, VPM_SupPosAssExcepDetailsQual__c, VPM_SupplierAssessmentQuestionnaireQual__c, VPM_DetailsofPlannedActivitiesQual__c, VPM_SupAudDetailsOfPlannedActivities__c, VPM_SupplierPositiveAssuranceSourcing__C, VPM_SupPosAssExcepDetailsSour__C, VPM_SupplierAssessmentQuestionnaireSour__C, 
                                                     VPM_DetailsofPlannedActivitiesSour__c, VPM_SupplierAuditSourcing__c, VPM_DetailsOfPlannedActivitiesSour2__c, VPM_MDMBPMRequestorName__c, VPM_MDMBPMRequestorPhone__c, VPM_MDMBPMRequestorEmail__c, VPM_MDMBPMRequestorDepartment__c, VPM_MDMBPMOriginatoEmail__c, VPM_MDMBPMRequestDate__c , 
                                                     VPM_AchillesRegistrationCode__c, VPM_DetailsTypeCheck__c, VPM_DUNSHierarchyInvestigationReq__c, VPM_GroupingKey__c, VPM_SMEComment__c, VPM_VATRegistrationNumber__c from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
        if(vendorList != null && vendorList.size() > 0) {
            VPM_CreateVendorFieldDetailsWrapper VPM_InterfaceFieldDetails= new VPM_CreateVendorFieldDetailsWrapper();
            //VPM_InterfaceFieldDetails.requestNumber = vendorList.get(0).VPM_SAPBPMRequestID__c == null?'':vendorList.get(0).VPM_SAPBPMRequestID__c;
            VPM_InterfaceFieldDetails.requestNumber = reqNum;
            VPM_InterfaceFieldDetails.requestorName = vendorList.get(0).VPM_MDMBPMRequestorName__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorName__c;
            VPM_InterfaceFieldDetails.requestorPhone = vendorList.get(0).VPM_MDMBPMRequestorPhone__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorPhone__c;
            VPM_InterfaceFieldDetails.requestorCountry = vendorList.get(0).VPM_Country__c==null?'':vendorList.get(0).VPM_Country__c;
            VPM_InterfaceFieldDetails.requestorDepartment = vendorList.get(0).VPM_MDMBPMRequestorDepartment__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorDepartment__c;
            VPM_InterfaceFieldDetails.requestorEmail = vendorList.get(0).VPM_MDMBPMRequestorEmail__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorEmail__c;
            VPM_InterfaceFieldDetails.originatorEmail = vendorList.get(0).VPM_MDMBPMOriginatoEmail__c==null?'':vendorList.get(0).VPM_MDMBPMOriginatoEmail__c;
            Date requestDt = vendorList.get(0).VPM_MDMBPMRequestDate__c;
            VPM_InterfaceFieldDetails.requestDate = requestDt==null?'':requestDt.format();
            VPM_InterfaceFieldDetails.vendorType = vendorList.get(0).VPM_VendorType__c==null?'':vendorList.get(0).VPM_VendorType__c;
            VPM_InterfaceFieldDetails.countryRequestingVendor=vendorList.get(0).VPM_CountryRequestingVendor__c==null?'':vendorList.get(0).VPM_CountryRequestingVendor__c;
            VPM_InterfaceFieldDetails.globalAuthorisationGroup = vendorList.get(0).VPM_GlobalAuthorisationGroup__c==null?'':vendorList.get(0).VPM_GlobalAuthorisationGroup__c;
            VPM_InterfaceFieldDetails.eccSystem = vendorList.get(0).VPM_ECC__c==null?'':vendorList.get(0).VPM_ECC__c;
            VPM_InterfaceFieldDetails.tradePartnerType = vendorList.get(0).VPM_TradePartnerType__c==null?'':vendorList.get(0).VPM_TradePartnerType__c;
            VPM_InterfaceFieldDetails.accountGroup = vendorList.get(0).VPM_AccountGroup__c==null?'':vendorList.get(0).VPM_AccountGroup__c;
            VPM_InterfaceFieldDetails.vendorName1 = vendorList.get(0).VPM_VendorName1__c==null?'':vendorList.get(0).VPM_VendorName1__c;
            VPM_InterfaceFieldDetails.searchTerm1 = vendorList.get(0).VPM_SearchTerm1__c==null?'':vendorList.get(0).VPM_SearchTerm1__c;
            VPM_InterfaceFieldDetails.street1 = vendorList.get(0).VPM_Street1__c==null?'':vendorList.get(0).VPM_Street1__c;
            VPM_InterfaceFieldDetails.zipPostCode = vendorList.get(0).VPM_ZIPPostCode__c==null?'':vendorList.get(0).VPM_ZIPPostCode__c;
            VPM_InterfaceFieldDetails.city  = vendorList.get(0).VPM_City__c==null?'':vendorList.get(0).VPM_City__c;
            VPM_InterfaceFieldDetails.country   = vendorList.get(0).VPM_Country__c==null?'':vendorList.get(0).VPM_Country__c;
            VPM_InterfaceFieldDetails.houseNumber = vendorList.get(0).VPM_HouseNumber__c==null?'':vendorList.get(0).VPM_HouseNumber__c;
            VPM_InterfaceFieldDetails.region = vendorList.get(0).VPM_Region__c==null?'':vendorList.get(0).VPM_Region__c;
            VPM_InterfaceFieldDetails.isVendorSME = vendorList.get(0).VPM_IsVendorSME__C==null?'No':vendorList.get(0).VPM_IsVendorSME__C;
            VPM_InterfaceFieldDetails.isVendorException = vendorList.get(0).VPM_IsVendorException__c==null?'No':vendorList.get(0).VPM_IsVendorException__c;
            VPM_InterfaceFieldDetails.exceptionType = vendorList.get(0).VPM_ExceptionType__c==null?'':vendorList.get(0).VPM_ExceptionType__c;
            VPM_InterfaceFieldDetails.taxNumber1 = vendorList.get(0).VPM_TaxNumber1__c==null?'':vendorList.get(0).VPM_TaxNumber1__c;
            VPM_InterfaceFieldDetails.taxNumber3 = vendorList.get(0).VPM_TaxNumber3__c==null?'':vendorList.get(0).VPM_TaxNumber3__c;
            VPM_InterfaceFieldDetails.taxJurisdictionCode = vendorList.get(0).VPM_TaxJurisdictionCode__c==null?'':vendorList.get(0).VPM_TaxJurisdictionCode__c;
            VPM_InterfaceFieldDetails.isSupplierFinanciallyStabilityCheck = vendorList.get(0).VPM_SupplierFinancialStabilityCheck__c==null?'No':vendorList.get(0).VPM_SupplierFinancialStabilityCheck__c;
            VPM_InterfaceFieldDetails.reasonNoFinancialCheck = vendorList.get(0).VPM_ReasonNoFinancialCheck__C==null?'':vendorList.get(0).VPM_ReasonNoFinancialCheck__C;
            VPM_InterfaceFieldDetails.isSupplierAchillesRegistration = vendorList.get(0).VPM_SupplierAchillesRegistration__c==null?'No':vendorList.get(0).VPM_SupplierAchillesRegistration__c;
            VPM_InterfaceFieldDetails.achillesExceptionDetails = vendorList.get(0).VPM_AchillesExceptionDetails__C==null?'':vendorList.get(0).VPM_AchillesExceptionDetails__C;
            VPM_InterfaceFieldDetails.isSupplierPositiveAssurance = vendorList.get(0).VPM_SupplierPositiveAssuranceQuality__c==null?'No':vendorList.get(0).VPM_SupplierPositiveAssuranceQuality__c;
            VPM_InterfaceFieldDetails.supPosAssExcepDetailsQual = vendorList.get(0).VPM_SupPosAssExcepDetailsQual__c==null?'':vendorList.get(0).VPM_SupPosAssExcepDetailsQual__c;
            VPM_InterfaceFieldDetails.supplierAssessmentQuestionnaireQual = vendorList.get(0).VPM_SupplierAssessmentQuestionnaireQual__c==null?'':vendorList.get(0).VPM_SupplierAssessmentQuestionnaireQual__c;
            VPM_InterfaceFieldDetails.detailsOfPlannedActivitiesQual = vendorList.get(0).VPM_DetailsofPlannedActivitiesQual__c==null?'': vendorList.get(0).VPM_DetailsofPlannedActivitiesQual__c;
            VPM_InterfaceFieldDetails.supAudDetailsOfPlanneActivities = vendorList.get(0).VPM_SupAudDetailsOfPlannedActivities__c==null?'':vendorList.get(0).VPM_SupAudDetailsOfPlannedActivities__c;
            VPM_InterfaceFieldDetails.supplierPositiveAssuranceSourcing = vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__C==null?'':vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__C;
            VPM_InterfaceFieldDetails.supPosAssExcepDetailsSour = vendorList.get(0).VPM_SupPosAssExcepDetailsSour__C==null?'':vendorList.get(0).VPM_SupPosAssExcepDetailsSour__C;
            VPM_InterfaceFieldDetails.supplierAssessmentQuestionnaireSour = vendorList.get(0).VPM_SupplierAssessmentQuestionnaireSour__C==null?'':vendorList.get(0).VPM_SupplierAssessmentQuestionnaireSour__C;
            VPM_InterfaceFieldDetails.detailsofPlannedActivitesSour = vendorList.get(0).VPM_DetailsofPlannedActivitiesSour__c==null?'':vendorList.get(0).VPM_DetailsofPlannedActivitiesSour__c;
            VPM_InterfaceFieldDetails.supplierAuditSourcing = vendorList.get(0).VPM_SupplierAuditSourcing__c==null?'':vendorList.get(0).VPM_SupplierAuditSourcing__c;
            VPM_InterfaceFieldDetails.detailsOfPlannedActivitiesSour2 = vendorList.get(0).VPM_DetailsOfPlannedActivitiesSour2__c==null?'':vendorList.get(0).VPM_DetailsOfPlannedActivitiesSour2__c;
            VPM_InterfaceFieldDetails.supplierAudit='';
            VPM_InterfaceFieldDetails.achillesRegistrationCode = vendorList.get(0).VPM_AchillesRegistrationCode__c==null?'':vendorList.get(0).VPM_AchillesRegistrationCode__c;
            VPM_InterfaceFieldDetails.detailsTypeCheck = vendorList.get(0).VPM_DetailsTypeCheck__c==null?'':vendorList.get(0).VPM_DetailsTypeCheck__c;
            VPM_InterfaceFieldDetails.dunsHierarchyRequired = vendorList.get(0).VPM_DUNSHierarchyInvestigationReq__c==null?'No': String.valueOf(vendorList.get(0).VPM_DUNSHierarchyInvestigationReq__c);
            VPM_InterfaceFieldDetails.groupKey = vendorList.get(0).VPM_GroupingKey__c==null?'':vendorList.get(0).VPM_GroupingKey__c;
            VPM_InterfaceFieldDetails.smeComment = vendorList.get(0).VPM_SMEComment__c==null?'':vendorList.get(0).VPM_SMEComment__c;
            VPM_InterfaceFieldDetails.vatRegistrationNumber = vendorList.get(0).VPM_VATRegistrationNumber__c==null?'':vendorList.get(0).VPM_VATRegistrationNumber__c;
            VPM_InterfaceFieldDetailsJSON = JSON.serialize(VPM_InterfaceFieldDetails);
        }
        return VPM_InterfaceFieldDetailsJSON;
    }
}