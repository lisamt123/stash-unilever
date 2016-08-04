public class VPM_CreateVendorFetchFieldDetails {
    public string VPM_ConvertVendorFieldDetailsToJSON(string VendorRequestId) {
        String VPM_InterfaceFieldDetailsJSON, requestorPhoneNum, eccVal;
        Integer reqNum = VPM_HttpUtil.generateRandomNumber();
        Map<String,String> mapUserDetails = VPM_HttpUtil.fetchUserDetails();
        List<VPM_PurchasingRequests__c> vendorList =[SELECT VPM_VendorType__c, VPM_CountryRequestingVendor__c, VPM_GlobalAuthorisationGroup__c, VPM_ECC__c, VPM_TradePartnerType__c, VPM_AccountGroup__c, VPM_VendorName1__c, VPM_SearchTerm_1__c, VPM_Street1__c, VPM_ZIPPostCode__c, VPM_City__c,
                                                     VPM_Country__c, VPM_HouseNumber__c, VPM_Regions__r.VPM_Code__c, VPM_IsVendorSME__C, VPM_IsVendorException__c, VPM_ExceptionType__c, VPM_TaxNumber1__c, VPM_TaxNumber3__c, VPM_TaxJurisdictionCode__c, VPM_SupplierFinancialStabilityCheck__c, VPM_ReasonNoFinancialCheck__C, VPM_SupplierAchillesRegistration__c, VPM_AchillesExceptionDetails__C, 
                                                     VPM_SupplierPositiveAssuranceQuality__c, VPM_SupPosAssExcepDetailsQual__c, VPM_SupplierAssessmentQuestionnaireQual__c, VPM_DetailsofPlannedActivitiesQual__c, VPM_SupAudDetailsOfPlannedActivities__c, VPM_SupplierPositiveAssuranceSourcing__C, VPM_SupPosAssExcepDetailsSour__C, VPM_SupplierAssessmentQuestionnaireSour__C, 
                                                     VPM_DetailsofPlannedActivitiesSour__c, VPM_SupplierAuditSourcing__c, VPM_DetailsOfPlannedActivitiesSour2__c, VPM_MDMBPMRequestorName__c, VPM_MDMBPMRequestorPhone__c, VPM_MDMBPMRequestorEmail__c, VPM_MDMBPMRequestorDepartment__c, VPM_MDMBPMOriginatoEmail__c, VPM_MDMBPMRequestDate__c , 
                                                     VPM_AchillesRegistrationCode__c, VPM_DetailsTypeCheck__c, VPM_DUNSHierarchyInvestigationReq__c, VPM_GroupingKey__c, VPM_SMEComment__c, VPM_VATRegistrationNumber__c, VPM_CheckDigit__c, VPM_Comments__c, VPM_District__c, VPM_HouseNumSupplement__c, VPM_IsNaturalPerson__c, VPM_POBox__c, VPM_POBoxPostCode__c, VPM_SearchTerm2__c, VPM_Street2__c, VPM_Street3__c, VPM_Street4__c, VPM_TaxNumber2__c, VPM_TaxNumber4__c, VPM_TaxNumberType__c, VPM_VendorName2__c, VPM_Name3__c, VPM_Name4__c, VPM_PurchasingOrg__r.Name, VPM_CreditInfoNumber__c, VPM_TradingPartner__c, VPM_IntLocationNumber1__c, VPM_IntLocationNumber2__c, VPM_ExtManufacturer__c, VPM_SupplierAuditQuality__c from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
        system.debug('------------vendorList-------'+vendorList);
        if(vendorList != null && vendorList.size() > 0) {
            VPM_CreateVendorFieldDetailsWrapper VPM_InterfaceFieldDetails= new VPM_CreateVendorFieldDetailsWrapper();
            VPM_InterfaceFieldDetails.RequestorName = vendorList.get(0).VPM_MDMBPMRequestorName__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorName__c;
            VPM_InterfaceFieldDetails.RequestID = reqNum;
            //VPM_InterfaceFieldDetails.requestorPhone = vendorList.get(0).VPM_MDMBPMRequestorPhone__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorPhone__c;
            if(mapUserDetails != null && mapUserDetails.containsKey('userPhone')) {
                if(String.isNotBlank(mapUserDetails.get('userPhone'))) {
                VPM_InterfaceFieldDetails.requestorPhone = mapUserDetails.get('userPhone');
                } else {
                    VPM_InterfaceFieldDetails.requestorPhone = '01';
                }
            } else {
                VPM_InterfaceFieldDetails.requestorPhone = vendorList.get(0).VPM_MDMBPMRequestorPhone__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorPhone__c;
            }
            VPM_InterfaceFieldDetails.requestorCountry = vendorList.get(0).VPM_Country__c==null ? '' : VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_Country__c);
            if(mapUserDetails != null && mapUserDetails.containsKey('userDepartment')) {
                if(String.isNotBlank(mapUserDetails.get('userDepartment'))) {
                VPM_InterfaceFieldDetails.requestorDepartment = mapUserDetails.get('userDepartment');
                } else {
                    VPM_InterfaceFieldDetails.requestorDepartment = 'Default Role';
                }
            } else {
                VPM_InterfaceFieldDetails.requestorDepartment = vendorList.get(0).VPM_MDMBPMRequestorDepartment__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorDepartment__c;
            }
            //VPM_InterfaceFieldDetails.requestorDepartment = vendorList.get(0).VPM_MDMBPMRequestorDepartment__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorDepartment__c;
            if(mapUserDetails != null && mapUserDetails.containsKey('userEmail')) {
                if(String.isNotBlank(mapUserDetails.get('userEmail'))) {
                VPM_InterfaceFieldDetails.requestorEmail = mapUserDetails.get('userEmail');
                } else {
                    VPM_InterfaceFieldDetails.requestorEmail = 'a@a.com';
                }
            } else {
                VPM_InterfaceFieldDetails.requestorEmail = vendorList.get(0).VPM_MDMBPMRequestorEmail__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorEmail__c;
            }
            //VPM_InterfaceFieldDetails.requestorEmail = vendorList.get(0).VPM_MDMBPMRequestorEmail__c==null?'':vendorList.get(0).VPM_MDMBPMRequestorEmail__c;
            VPM_InterfaceFieldDetails.originatorEmail = vendorList.get(0).VPM_MDMBPMOriginatoEmail__c==null?'':vendorList.get(0).VPM_MDMBPMOriginatoEmail__c;
            Date requestDt = vendorList.get(0).VPM_MDMBPMRequestDate__c;
            //VPM_InterfaceFieldDetails.requestDate = requestDt==null?'':requestDt.format();
            VPM_InterfaceFieldDetails.requestDate = Datetime.now().format('yyyy-MM-dd');
            VPM_InterfaceFieldDetails.vendorType = vendorList.get(0).VPM_VendorType__c==null?'': VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_VendorType__c);
            VPM_InterfaceFieldDetails.countryRequestingVendor=vendorList.get(0).VPM_CountryRequestingVendor__c==null?'':vendorList.get(0).VPM_CountryRequestingVendor__c;
            VPM_InterfaceFieldDetails.globalAuthorisationGroup = vendorList.get(0).VPM_GlobalAuthorisationGroup__c==null ? '' : VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_GlobalAuthorisationGroup__c);
            VPM_InterfaceFieldDetails.tradePartnerType = vendorList.get(0).VPM_TradePartnerType__c==null?'': VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_TradePartnerType__c);
            VPM_InterfaceFieldDetails.accountGroup = vendorList.get(0).VPM_AccountGroup__c==null?'':vendorList.get(0).VPM_AccountGroup__c;
            VPM_InterfaceFieldDetails.Name1 = vendorList.get(0).VPM_VendorName1__c==null?'':vendorList.get(0).VPM_VendorName1__c;
            VPM_InterfaceFieldDetails.Name2 = vendorList.get(0).VPM_VendorName2__c == null ? '' : vendorList.get(0).VPM_VendorName2__c;
            VPM_InterfaceFieldDetails.searchTerm1 = vendorList.get(0).VPM_SearchTerm_1__c==null?'':vendorList.get(0).VPM_SearchTerm_1__c;
            VPM_InterfaceFieldDetails.street1 = vendorList.get(0).VPM_Street1__c==null?'':vendorList.get(0).VPM_Street1__c;
            VPM_InterfaceFieldDetails.zipPostCode = vendorList.get(0).VPM_ZIPPostCode__c==null?'':vendorList.get(0).VPM_ZIPPostCode__c;
            VPM_InterfaceFieldDetails.city  = vendorList.get(0).VPM_City__c==null?'':vendorList.get(0).VPM_City__c;
            VPM_InterfaceFieldDetails.country   = vendorList.get(0).VPM_Country__c==null ? '' : VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_Country__c);
            VPM_InterfaceFieldDetails.achillesRegistrationCode = vendorList.get(0).VPM_AchillesRegistrationCode__c==null?'':vendorList.get(0).VPM_AchillesRegistrationCode__c;
            VPM_InterfaceFieldDetails.detailsTypeCheck = vendorList.get(0).VPM_DetailsTypeCheck__c==null?'':vendorList.get(0).VPM_DetailsTypeCheck__c;
            VPM_InterfaceFieldDetails.DunsHierarchyRequired = vendorList.get(0).VPM_DUNSHierarchyInvestigationReq__c==null ? false : vendorList.get(0).VPM_DUNSHierarchyInvestigationReq__c;
            VPM_InterfaceFieldDetails.groupKey = vendorList.get(0).VPM_GroupingKey__c==null?'':vendorList.get(0).VPM_GroupingKey__c;
            VPM_InterfaceFieldDetails.smeComment = vendorList.get(0).VPM_SMEComment__c==null?'':vendorList.get(0).VPM_SMEComment__c;
            VPM_InterfaceFieldDetails.vatRegistrationNumber = vendorList.get(0).VPM_VATRegistrationNumber__c==null?'':vendorList.get(0).VPM_VATRegistrationNumber__c;
            VPM_InterfaceFieldDetails.houseNumber = vendorList.get(0).VPM_HouseNumber__c==null?'':vendorList.get(0).VPM_HouseNumber__c;
            VPM_InterfaceFieldDetails.region = vendorList.get(0).VPM_Regions__r.VPM_Code__c==null?'':vendorList.get(0).VPM_Regions__r.VPM_Code__c;
            VPM_InterfaceFieldDetails.IsVendorSME = vendorList.get(0).VPM_IsVendorSME__C==null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_IsVendorSME__C);
            VPM_InterfaceFieldDetails.IsVendorException = vendorList.get(0).VPM_IsVendorException__c==null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_IsVendorException__c);
            VPM_InterfaceFieldDetails.exceptionType = vendorList.get(0).VPM_ExceptionType__c==null?'':vendorList.get(0).VPM_ExceptionType__c;
            VPM_InterfaceFieldDetails.taxNumber1 = vendorList.get(0).VPM_TaxNumber1__c==null?'':vendorList.get(0).VPM_TaxNumber1__c;
            VPM_InterfaceFieldDetails.taxNumber3 = vendorList.get(0).VPM_TaxNumber3__c==null?'':vendorList.get(0).VPM_TaxNumber3__c;
            VPM_InterfaceFieldDetails.taxJurisdictionCode = vendorList.get(0).VPM_TaxJurisdictionCode__c==null?'':vendorList.get(0).VPM_TaxJurisdictionCode__c;
            VPM_InterfaceFieldDetails.IsSupplierFinanciallyStabilityCheck = vendorList.get(0).VPM_SupplierFinancialStabilityCheck__c==null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierFinancialStabilityCheck__c);
            VPM_InterfaceFieldDetails.reasonNoFinancialCheck = vendorList.get(0).VPM_ReasonNoFinancialCheck__C==null?'':vendorList.get(0).VPM_ReasonNoFinancialCheck__C;
            VPM_InterfaceFieldDetails.DetailsOfPlannedActivitiesQual1= vendorList.get(0).VPM_DetailsOfPlannedActivitiesQual__c==null?'':vendorList.get(0).VPM_DetailsOfPlannedActivitiesQual__c;
            VPM_InterfaceFieldDetails.IsSupplierAchillesRegistration = vendorList.get(0).VPM_SupplierAchillesRegistration__c == null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierAchillesRegistration__c);
            VPM_InterfaceFieldDetails.achillesExceptionDetails = vendorList.get(0).VPM_AchillesExceptionDetails__C==null?'':vendorList.get(0).VPM_AchillesExceptionDetails__C;
            VPM_InterfaceFieldDetails.IsSupplierPositiveAssurance = vendorList.get(0).VPM_SupplierPositiveAssuranceQuality__c==null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierPositiveAssuranceQuality__c);
            VPM_InterfaceFieldDetails.supPosAssExcepDetailsQual = vendorList.get(0).VPM_SupPosAssExcepDetailsQual__c==null?'':vendorList.get(0).VPM_SupPosAssExcepDetailsQual__c;
            VPM_InterfaceFieldDetails.SupplierAssessmentQuestionnaireQual = vendorList.get(0).VPM_SupplierAssessmentQuestionnaireQual__c==null?'':vendorList.get(0).VPM_SupplierAssessmentQuestionnaireQual__c;
            VPM_InterfaceFieldDetails.detailsOfPlannedActivitiesQual = vendorList.get(0).VPM_DetailsofPlannedActivitiesQual__c==null?'': vendorList.get(0).VPM_DetailsofPlannedActivitiesQual__c;
            VPM_InterfaceFieldDetails.supAudDetailsOfPlanneActivities = vendorList.get(0).VPM_SupAudDetailsOfPlannedActivities__c==null?'':vendorList.get(0).VPM_SupAudDetailsOfPlannedActivities__c;
            VPM_InterfaceFieldDetails.supplierPositiveAssuranceSourcing = vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__C==null?'':vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__C;
            VPM_InterfaceFieldDetails.supPosAssExcepDetailsSour = vendorList.get(0).VPM_SupPosAssExcepDetailsSour__C==null?'':vendorList.get(0).VPM_SupPosAssExcepDetailsSour__C;
            VPM_InterfaceFieldDetails.SupplierAssessmentQuestionnaireSour = vendorList.get(0).VPM_SupplierAssessmentQuestionnaireSour__C==null?'':vendorList.get(0).VPM_SupplierAssessmentQuestionnaireSour__C;
            VPM_InterfaceFieldDetails.detailsofPlannedActivitesSour = vendorList.get(0).VPM_DetailsofPlannedActivitiesSour__c==null?'':vendorList.get(0).VPM_DetailsofPlannedActivitiesSour__c;
            VPM_InterfaceFieldDetails.IsSupplierAuditSourcing = vendorList.get(0).VPM_SupplierAuditSourcing__c == null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierAuditSourcing__c);
            VPM_InterfaceFieldDetails.detailsOfPlannedActivitiesSour2 = vendorList.get(0).VPM_DetailsOfPlannedActivitiesSour2__c==null?'':vendorList.get(0).VPM_DetailsOfPlannedActivitiesSour2__c;
            VPM_InterfaceFieldDetails.IsSupplierAudit = vendorList.get(0).VPM_SupplierAuditQuality__c==null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierAuditQuality__c);
            VPM_InterfaceFieldDetails.IsSupplierPositiveAssuranceSour = vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__c==null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__c);
            
            //VPM_InterfaceFieldDetails.detailsOfPlannedActivitiesQual1 = vendorList.get(0).VPM_SupAudDetailsOfPlannedActivities__c==null?'':vendorList.get(0).VPM_SupAudDetailsOfPlannedActivities__c;
            //new fields added for story 426 - Missing fields from create request to BPM
            VPM_InterfaceFieldDetails.checkDigit = vendorList.get(0).VPM_CheckDigit__c == null ? '' : vendorList.get(0).VPM_CheckDigit__c;
            VPM_InterfaceFieldDetails.comments = vendorList.get(0).VPM_Comments__c == null ? '' : vendorList.get(0).VPM_Comments__c;
            VPM_InterfaceFieldDetails.detailsOfFinancialCheck = vendorList.get(0).VPM_DetailsTypeCheck__c == null ? '' : vendorList.get(0).VPM_DetailsTypeCheck__c;
            VPM_InterfaceFieldDetails.district = vendorList.get(0).VPM_District__c == null ? '' : vendorList.get(0).VPM_District__c;
            VPM_InterfaceFieldDetails.houseNoSupplement = vendorList.get(0).VPM_HouseNumSupplement__c == null ? '' : vendorList.get(0).VPM_HouseNumSupplement__c;
            VPM_InterfaceFieldDetails.IsNaturalPerson = vendorList.get(0).VPM_IsNaturalPerson__c == null ? true : vendorList.get(0).VPM_IsNaturalPerson__c;
            VPM_InterfaceFieldDetails.IsSupplierAssessmentQuestionnaireQual = vendorList.get(0).VPM_SupplierAssessmentQuestionnaireQual__c == null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierAssessmentQuestionnaireQual__c);
            VPM_InterfaceFieldDetails.IsSupplierAssessmentQuestionnaireSour = vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__c == null ? false : VPM_HttpUtil.convertYesNoToBoolean(vendorList.get(0).VPM_SupplierPositiveAssuranceSourcing__c);
            VPM_InterfaceFieldDetails.poBox = vendorList.get(0).VPM_POBox__c == null ? '' : vendorList.get(0).VPM_POBox__c;
            VPM_InterfaceFieldDetails.poPostalCode = vendorList.get(0).VPM_POBoxPostCode__c == null ? '' : vendorList.get(0).VPM_POBoxPostCode__c;
            VPM_InterfaceFieldDetails.taxNumber = vendorList.get(0).VPM_TaxNumber1__c == null ? '' : vendorList.get(0).VPM_TaxNumber1__c;
            
            VPM_InterfaceFieldDetails.cordillera = false;
            VPM_InterfaceFieldDetails.sirius = false;
            VPM_InterfaceFieldDetails.fusion = false;
            VPM_InterfaceFieldDetails.u2k2 = false;
            
            eccVal = vendorList.get(0).VPM_ECC__c;
            
            if(String.isNotBlank(eccVal)) {
                if(eccVal.equalsIgnoreCase('Cordillera')) {
                    VPM_InterfaceFieldDetails.cordillera = true;
                } else if(eccVal.equalsIgnoreCase('Sirius')) {
                    VPM_InterfaceFieldDetails.sirius = true;
                } else if(eccVal.equalsIgnoreCase('Fusion')) {
                    VPM_InterfaceFieldDetails.fusion = true;
                } else if(eccVal.equalsIgnoreCase('U2K2')) {
                    VPM_InterfaceFieldDetails.u2k2 = true;
                }
            }
            //commented since could not find these in latest create request mapping 28-July
            
            VPM_InterfaceFieldDetails.searchTerm2 = vendorList.get(0).VPM_SearchTerm2__c == null ? '' : vendorList.get(0).VPM_SearchTerm2__c;
            VPM_InterfaceFieldDetails.street2 = vendorList.get(0).VPM_Street2__c == null ? '' : vendorList.get(0).VPM_Street2__c;
            VPM_InterfaceFieldDetails.street3 = vendorList.get(0).VPM_Street3__c == null ? '' : vendorList.get(0).VPM_Street3__c;
            VPM_InterfaceFieldDetails.street4 = vendorList.get(0).VPM_Street4__c == null ? '' : vendorList.get(0).VPM_Street4__c;
            VPM_InterfaceFieldDetails.taxNumber2 = vendorList.get(0).VPM_TaxNumber2__c == null ? '' : vendorList.get(0).VPM_TaxNumber2__c;
            VPM_InterfaceFieldDetails.taxNumber4 = vendorList.get(0).VPM_TaxNumber4__c == null ? '' : vendorList.get(0).VPM_TaxNumber4__c;
            VPM_InterfaceFieldDetails.taxNumberType = vendorList.get(0).VPM_TaxNumberType__c == null ? '' : vendorList.get(0).VPM_TaxNumberType__c;
            VPM_InterfaceFieldDetails.Name3 = vendorList.get(0).VPM_Name3__c == null ? '' : vendorList.get(0).VPM_Name3__c;
            VPM_InterfaceFieldDetails.Name4 = vendorList.get(0).VPM_Name4__c == null ? '' : vendorList.get(0).VPM_Name4__c;
            
            VPM_InterfaceFieldDetails.CreditInformationNumber = vendorList.get(0).VPM_CreditInfoNumber__c == null ? '' : vendorList.get(0).VPM_CreditInfoNumber__c;
            VPM_InterfaceFieldDetails.TradingPartner = vendorList.get(0).VPM_TradingPartner__c == null ? '' : vendorList.get(0).VPM_TradingPartner__c;
            VPM_InterfaceFieldDetails.InternationalLocationNumber1 = vendorList.get(0).VPM_IntLocationNumber1__c == null ? '' : vendorList.get(0).VPM_IntLocationNumber1__c;
            VPM_InterfaceFieldDetails.InternationalLocationNumber2 = vendorList.get(0).VPM_IntLocationNumber2__c == null ? '' : vendorList.get(0).VPM_IntLocationNumber2__c;
            VPM_InterfaceFieldDetails.ExternalManufacturer = vendorList.get(0).VPM_ExtManufacturer__c == null ? '' : vendorList.get(0).VPM_ExtManufacturer__c;
            
            //eccSystem needs to be replaced with four boolean variables for each ecc
            //VPM_InterfaceFieldDetails.eccSystem = vendorList.get(0).VPM_ECC__c==null?'':vendorList.get(0).VPM_ECC__c;
            /* 
            VPM_InterfaceFieldDetails.deletionBlockFlag = vendorList.get(0). VPM_DeletionBlockFlag__c==null?'':vendorList.get(0). VPM_DeletionBlockFlag__c;
            VPM_InterfaceFieldDetails.bankCountryKey = vendorList.get(0).VPM_BankCountryKey__c==null?'':vendorList.get(0).VPM_BankCountryKey__c; 
            VPM_InterfaceFieldDetails.bankKey = vendorList.get(0).VPM_BankKey__c==null?'':vendorList.get(0).VPM_BankKey__c; 
            VPM_InterfaceFieldDetails.bankAccountNumber = vendorList.get(0).VPM_BankAccountNumber__c==null?'':vendorList.get(0).VPM_BankAccountNumber__c;
            VPM_InterfaceFieldDetails.accountHolderName = vendorList.get(0).VPM_AccountHolderName__c==null?'':vendorList.get(0).VPM_AccountHolderName__c; 
            VPM_InterfaceFieldDetails.bankControlKey = vendorList.get(0).VPM_BankControlKey__c==null?'':vendorList.get(0).VPM_BankControlKey__c;
            VPM_InterfaceFieldDetails.iBAN = vendorList.get(0).VPM_IBAN__c==null?'':vendorList.get(0).VPM_IBAN__c;
            VPM_InterfaceFieldDetails.partnerBankType = vendorList.get(0).VPM_PartnerBankType__c==null?'':vendorList.get(0).VPM_PartnerBankType__c;
            VPM_InterfaceFieldDetails.referenceSpecificationsBankDetail = vendorList.get(0).VPM_ReferenceSpecificationsBankDetail__c==null?'':vendorList.get(0).VPM_ReferenceSpecificationsBankDetail__c;
            VPM_InterfaceFieldDetails.collectionAuthorization = vendorList.get(0).VPM_CollectionAuthorization__c==null?'':vendorList.get(0).VPM_CollectionAuthorization__c;
            VPM_InterfaceFieldDetails.bankName = vendorList.get(0).VPM_BankName__c==null?'':vendorList.get(0).VPM_BankName__c;
            VPM_InterfaceFieldDetails.swiftKey = vendorList.get(0).VPM_SwiftKey__c==null?'':vendorList.get(0).VPM_SwiftKey__c;
            VPM_InterfaceFieldDetails.iSRNumber = vendorList.get(0).VPM_ISRNumber__c==null?'':vendorList.get(0).VPM_ISRNumber__c;
            VPM_InterfaceFieldDetails.bankNumber = vendorList.get(0).VPM_BankNumber__c==null?'':vendorList.get(0).VPM_BankNumber__c;
            VPM_InterfaceFieldDetails.reconciliationAccount = vendorList.get(0).VPM_ReconciliationAccount__c==null?'':vendorList.get(0).VPM_ReconciliationAccount__c;
            VPM_InterfaceFieldDetails.paymentMethod = vendorList.get(0).VPM_PaymentMethod__c==null?'':vendorList.get(0).VPM_PaymentMethod__c;
            VPM_InterfaceFieldDetails.gRbasedIV = vendorList.get(0).VPM_GRbasedIV__c==null?'':vendorList.get(0).VPM_GRbasedIV__c;
            VPM_InterfaceFieldDetails.paymentBlock = vendorList.get(0).VPM_PaymentBlock__c==null?'':vendorList.get(0).VPM_PaymentBlock__c;
            VPM_InterfaceFieldDetails.alternativePayee = vendorList.get(0).VPM_AlternativePayee__c==null?'':vendorList.get(0).VPM_AlternativePayee__c;
            VPM_InterfaceFieldDetails.purchasingOrganisation = vendorList.get(0).VPM_PurchasingOrganisation__c==null?'':vendorList.get(0).VPM_PurchasingOrganisation__c;
            VPM_InterfaceFieldDetails.sRVBasedVendorID = vendorList.get(0).VPM_SRVBasedVendorID__c==null?'':vendorList.get(0).VPM_SRVBasedVendorID__c;
            VPM_InterfaceFieldDetails.toleranceGroup = vendorList.get(0).VPM_ToleranceGroup__c==null?'':vendorList.get(0).VPM_ToleranceGroup__c;
            VPM_InterfaceFieldDetails.paymentTerms = vendorList.get(0).VPM_PaymentTerms__c==null?'':vendorList.get(0).VPM_PaymentTerms__c;
            VPM_InterfaceFieldDetails.automaticPurchaseOrderGeneration = vendorList.get(0).VPM_AutoGenerationPOAllowed__c==null?'':vendorList.get(0).VPM_AutoGenerationPOAllowed__c;
            */
            VPM_InterfaceFieldDetailsJSON = JSON.serialize(VPM_InterfaceFieldDetails);
        }
        return VPM_InterfaceFieldDetailsJSON;
    }
}