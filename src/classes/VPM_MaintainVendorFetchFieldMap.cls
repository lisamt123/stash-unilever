/* Created By : Ajay Rawat
   Created on : 20th July 2016
   Description: Use to create Dynamic JSON response for ECC maintain service 
*/

public  class VPM_MaintainVendorFetchFieldMap {

/* Created By : Ajay Rawat
   Created on : 20th July 2016
   Description: Main method takes vendor id as a parameter and return JSON string
*/

    public string VPM_ConvertMaintainVendorFieldDetailsToJSON(string VendorRequestId) 
    {
       String maintainVendorObjectJSON, PurchasingDataJSON, JSONPurchasingData ,JSONBankDetails,JSONCIN,JSONAddress, JSONWtaxType, JSONCompanyData, JSONVAT; // Final JSON string
         Integer reqNum = VPM_HttpUtil.generateRandomNumber();
         JSONGenerator rootMaintainVendor = JSON.createGenerator(true);
         JSONGenerator PurchasingData = JSON.createGenerator(true);
         JSONGenerator BankDetails = JSON.createGenerator(true);
         JSONGenerator WtaxType = JSON.createGenerator(true);
         JSONGenerator CompanyData = JSON.createGenerator(true);
         JSONGenerator VAT = JSON.createGenerator(true);
          JSONGenerator CIN = JSON.createGenerator(true);
           JSONGenerator Address = JSON.createGenerator(true);
         rootMaintainVendor.writeStartObject();
         PurchasingData.writeStartObject();
         BankDetails.writeStartObject();
         WtaxType.writeStartObject();
         CompanyData.writeStartObject();
         VAT.writeStartObject();
         CIN.writeStartObject();
         Address.writeStartObject();
         VPM_PurchasingRequests__c vendorReuest =[SELECT VPM_ECC__c, VPM_VendorCode__c, VPM_TrainStation__c, VPM_IntLocationNumber1__c, VPM_IntLocationNumber2__c, VPM_Authorization__c, VPM_Industry__c, VPM_CheckDigit__c, VPM_DMEIndicator__c, VPM_IndicatorAlternativePayeeAllowed__c, VPM_InstructionKeyDataExchange__c, VPM_ISRNumber__c, VPM_AccountGroup__c, VPM_IsNaturalPerson__c, VPM_Customer__c,VPM_AccNumOfAlternativePayee__c, VPM_TaxNumber1__c, VPM_TaxNumber2__c, VPM_EqualisationTax__c,
           VPM_SalesPurchTax__c, VPM_FiscalAddress__c, VPM_VATRegistrationNumber__c, VPM_PlaceOfBirth__c, VPM_DateOfBirth__c, VPM_Sex__c, VPM_LastExtReview__c, VPM_ActualQMSystem__c, VPM_Plant__c, VPM_IndicatorPlantLevelRelevant__c, VPM_SCAC__c, VPM_CarFreightGroup__c, VPM_ServiceAgent__c, VPM_TaxNumber3__c, VPM_TaxNumber4__c, VPM_TaxSplit__c, VPM_TaxBase__c, VPM_Profession_c__c,
           VPM_NODEL__c,  VPM_QMSystemTo__c, VPM_PODRelevant__c, VPM_TaxNumber5__c,VPM_fieldUpdated__c,VPM_ExternalMFG__c,
           VPM_PurchasingOrg__r.Name, VPM_ABCIndicator__c, VPM_OrderCurrency__c, VPM_SalesPerson__c, VPM_Telephone__c,  VPM_MinimumOrderValue__c,   VPM_Incoterms1__c,  VPM_Incoterms2__c, VPM_GRbasedIV__c,  VPM_OrderAcknowledgmentRequirement__c, VPM_SchemaGroupVendor__c, VPM_AutomaticPurchaseOrderGeneration__c, VPM_ModeTransportForeignTrade__c, VPM_OfficeOfEntry__c, VPM_PricingDateControl__c, VPM_PurchasingGroup__c,  VPM_AutoEvalGRSetmtDel__c,  VPM_PlannedDeliveryTime__c,  VPM_RackJobbingServiceAgreed__c,
           VPM_RelevantForPriceDet__c,  VPM_GrantDiscInKind__c, VPM_DocIndexActive__c,  VPM_SortCriterion__c, VPM_ConfirmationControl__c,  VPM_OrderOptimRest__c,   VPM_PROATControlProof__c, VPM_SRVBasedVendorID__c,
           VPM_BankCountryKey__c, VPM_BankKey__c, VPM_BankAccountNumber__c, VPM_BankControlKey__c, VPM_PartnerBankType__c, VPM_CollectionAuthorization__c, VPM_ReferenceSpecificationsBankDetail__c, VPM_AccountHolderName__c, VPM_IBAN__c,
           VPM_IndicatorForWithholdingTaxType__c, VPM_Liable__c, VPM_CertificateWithholdingTaxExemption__c, VPM_ExemptionRate__c, VPM_ExemptionFrom__c, VPM_ExemptionTo__c, VPM_ExemptionNumber__c, VPM_RecipientType__c,VPM_ReasonForExemption__c,
           VPM_CompanyCode__r.VPM_CompanyCode__c, VPM_SortKey__c, VPM_ReconciliationAccount__c,  VPM_Interestcalculationindicator__c, VPM_PaymentMethod__c, VPM_IndicatorClearingBetwCustomerNVendor__c, VPM_PaymentBlock__c, VPM_PaymentTerms__c, VPM_AccntWithVendor__c, VPM_ClerkAtVendor__c, VPM_AccountMemo__c, VPM_AccountingClerk__c, VPM_CashManagementGroup__c, VPM_AlternativePayee__c, VPM_LastKeyDate__c, VPM_InterestFrequency__c, VPM_LastInterestRun__c, VPM_BExchangeLimit__c, VPM_ChkCashing__c,
          VPM_VATCountry__c,VPM_VATRegistrationNumber2__c
         ,VPM_PANNumber__c,VPM_CSTno__c,VPM_LSTno__c,VPM_SerRegNo__c,VPM_ExcIndVendor__c,VPM_ECCNo__c,VPM_ExciseRegNo__c,VPM_ExciseRange__c,VPM_ExciseDivision__c,VPM_Commissionerate__c,VPM_SSIStatus__c,VPM_CENVAT__c,VPM_Changedon__c,VPM_ChangedBy__c,VPM_PANreference__c,VPM_ZIPPostCode__c,VPM_CompanyPostCode__c,VPM_POBox__c,VPM_POBoxCity__c,VPM_TransportZone__c,VPM_HouseNumber__c,VPM_Street1__c,VPM_Street2__c,VPM_Street3__c,VPM_Street4__c,VPM_Street5__c,VPM_District__c,VPM_Country__c,VPM_Language__c,VPM_Region__c,VPM_RegStGrp__c,VPM_SearchTerm_1__c ,VPM_SearchTerm2__c,VPM_AddressTimeZone__c,VPM_TaxJurisdictionCode__c,VPM_StandardCommMethod__c,VPM_ExtensionPhone__c,VPM_Fax__c,VPM_FaxExtension__c
          ,VPM_SubsequentSettlementIndex__c,VPM_SubsequentSettlement__c,VPM_ShippingConditions__c,VPM_UnitOfMeasureGrp__c,VPM_RoundingProfile__c,VPM_BeneficiaryName__c,VPM_BeneficiaryAddress1__c,VPM_BeneficiaryAddress2__c,VPM_BeneficiaryAddress3__c,VPM_BeneficiaryCountry__c,VPM_ThirdPartyName__c,VPM_ThirdPartyAddress1__c,VPM_ThirdPartyAddress2__c,VPM_ThirdPartyAddress3__c,VPM_ThirdPartyAddress4__c,VPM_FreeText1__c,VPM_FreeText2__c,VPM_PayableLocation__c,VPM_IndividualPayment__c
          ,VPM_CheckDoubleInvoices__c, VPM_AutoEvalGRSetmtRet__c,VPM_BlockFunction__c,VPM_CreditInfoNumber__c,VPM_IndicatorVendorSubRangeRelevant__c,VPM_TaxNumberType__c,VPM_TaxType__c,VPM_TaxNumAtResponsibleTaxAuthority__c,VPM_TaxOfficeIdentification__c,VPM_AlternativePayeeAccountNumber__c,VPM_SocialInsuranceCodeSoc__c,VPM_TradingPartner__c,VPM_VendorSubRange__c,VPM_CorrespondentBank__c,VPM_LLDCode__c
           from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
          if(vendorReuest != null) 
          {
           // if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ECC__c')) 
            rootMaintainVendor.writeStringField('ECC',vendorReuest.VPM_ECC__c);
           // if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_VendorCode__c')) 
            rootMaintainVendor.writeStringField('VendorCode',vendorReuest.VPM_VendorCode__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TrainStation__c')) rootMaintainVendor.writeStringField('TrainStation',vendorReuest.VPM_TrainStation__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IntLocationNumber1__c')) rootMaintainVendor.writeStringField('IntLocationNumber1',vendorReuest.VPM_IntLocationNumber1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IntLocationNumber2__c')) rootMaintainVendor.writeStringField('IntLocationNumber2',vendorReuest.VPM_IntLocationNumber2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Authorization__c')) rootMaintainVendor.writeStringField('Authorization',vendorReuest.VPM_Authorization__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Industry__c')) rootMaintainVendor.writeStringField('Industry',vendorReuest.VPM_Industry__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CheckDigit__c')) rootMaintainVendor.writeStringField('CheckDigit',vendorReuest.VPM_CheckDigit__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_DMEIndicator__c')) rootMaintainVendor.writeStringField('DMEIndicator',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_DMEIndicator__c));
            //if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CentralDeletionFlag__c')) rootMaintainVendor.writeStringField('//CentralDeletionFlag',vendorReuest.VPM_CentralDeletionFlag__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndicatorAlternativePayeeAllowed__c ')) rootMaintainVendor.writeBooleanField('AltPayeeAllowedFlag',vendorReuest.VPM_IndicatorAlternativePayeeAllowed__c );
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_InstructionKeyDataExchange__c')) rootMaintainVendor.writeStringField('InstructionKeyDataExchange',vendorReuest.VPM_InstructionKeyDataExchange__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ISRNumber__c')) rootMaintainVendor.writeStringField('ISRNumber',vendorReuest.VPM_ISRNumber__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AccountGroup__c')) rootMaintainVendor.writeStringField('AccountGroup',vendorReuest.VPM_AccountGroup__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IsNaturalPerson__c')) rootMaintainVendor.writeBooleanField('isNaturalPerson',vendorReuest.VPM_IsNaturalPerson__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Customer__c')) rootMaintainVendor.writeStringField('Customer',vendorReuest.VPM_Customer__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AccNumOfAlternativePayee__c')) rootMaintainVendor.writeStringField('AlternativePayeeAccountNumber',vendorReuest.VPM_AccNumOfAlternativePayee__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber1__c')) rootMaintainVendor.writeStringField('TaxNumber1',vendorReuest.VPM_TaxNumber1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber2__c')) rootMaintainVendor.writeStringField('TaxNumber2',vendorReuest.VPM_TaxNumber2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_EqualisationTax__c')) rootMaintainVendor.writeBooleanField('EqualisationTax',vendorReuest.VPM_EqualisationTax__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SalesPurchTax__c')) rootMaintainVendor.writeBooleanField('SalesPurchTax',vendorReuest.VPM_SalesPurchTax__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_FiscalAddress__c')) rootMaintainVendor.writeStringField('FiscalAddress',vendorReuest.VPM_FiscalAddress__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_VATRegistrationNumber__c')) rootMaintainVendor.writeStringField('VATRegistrationNumber',vendorReuest.VPM_VATRegistrationNumber__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PlaceOfBirth__c')) rootMaintainVendor.writeStringField('PlaceOfBirth',vendorReuest.VPM_PlaceOfBirth__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_DateOfBirth__c')) rootMaintainVendor.writeStringField('DateOfBirth',formatDate(vendorReuest.VPM_DateOfBirth__c));
            //if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_RegionStreetGroup__c')) rootMaintainVendor.writeStringField('//RegionStreetGroup',vendorReuest.VPM_RegionStreetGroup__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Sex__c')) rootMaintainVendor.writeStringField('Sex',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_Sex__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_LastExtReview__c')) rootMaintainVendor.writeStringField('LastExtReview',formatDate(vendorReuest.VPM_LastExtReview__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ActualQMSystem__c')) rootMaintainVendor.writeStringField('ActualQMSystem',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_ActualQMSystem__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Plant__c')) rootMaintainVendor.writeStringField('Plant',vendorReuest.VPM_Plant__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndicatorVendorSubRangeRelevant__c')) rootMaintainVendor.writeBooleanField('IndicatorVendorSubRange',vendorReuest.VPM_IndicatorVendorSubRangeRelevant__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndicatorPlantLevelRelevant__c')) rootMaintainVendor.writeBooleanField('IndicatorPlantLevel',vendorReuest.VPM_IndicatorPlantLevelRelevant__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SCAC__c')) rootMaintainVendor.writeStringField('SCAC',vendorReuest.VPM_SCAC__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CarFreightGroup__c')) rootMaintainVendor.writeStringField('CarFreightGroup',vendorReuest.VPM_CarFreightGroup__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ServiceAgent__c')) rootMaintainVendor.writeStringField('ServiceAgent',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_ServiceAgent__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber3__c')) rootMaintainVendor.writeStringField('TaxNumber3',vendorReuest.VPM_TaxNumber3__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber4__c')) rootMaintainVendor.writeStringField('TaxNumber4',vendorReuest.VPM_TaxNumber4__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxSplit__c')) rootMaintainVendor.writeBooleanField('TaxSplit',vendorReuest.VPM_TaxSplit__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxBase__c')) rootMaintainVendor.writeStringField('TaxBase',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_TaxBase__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Profession_c__c')) rootMaintainVendor.writeStringField('Profession',vendorReuest.VPM_Profession_c__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_NODEL__c')) rootMaintainVendor.writeBooleanField('NODEL',vendorReuest.VPM_NODEL__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_QMSystemTo__c')) rootMaintainVendor.writeStringField('QMSystemTo',formatDate(vendorReuest.VPM_QMSystemTo__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PODRelevant__c')) rootMaintainVendor.writeStringField('PODRelevant',vendorReuest.VPM_PODRelevant__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber5__c')) rootMaintainVendor.writeStringField('TaxNumber5',vendorReuest.VPM_TaxNumber5__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_LLDCode__c')) rootMaintainVendor.writeStringField('LLDCode',vendorReuest.VPM_LLDCode__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CorrespondentBank__c')) rootMaintainVendor.writeStringField('CorrespondentBank',vendorReuest.VPM_CorrespondentBank__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_VendorSubRange__c')) rootMaintainVendor.writeStringField('VendorSubRange',vendorReuest.VPM_VendorSubRange__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TradingPartner__c')) rootMaintainVendor.writeStringField('TradingPartner',vendorReuest.VPM_TradingPartner__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SocialInsuranceCodeSoc__c')) rootMaintainVendor.writeStringField('SocialInsuranceCode',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_SocialInsuranceCodeSoc__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AlternativePayeeAccountNumber__c')) rootMaintainVendor.writeBooleanField('IndicatorAlternativePayeeAccountNumber',vendorReuest.VPM_AlternativePayeeAccountNumber__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxOfficeIdentification__c')) rootMaintainVendor.writeStringField('TaxOfficeIdentification',vendorReuest.VPM_TaxOfficeIdentification__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumAtResponsibleTaxAuthority__c')) rootMaintainVendor.writeStringField('TaxNumberResponsibleAuthority',vendorReuest.VPM_TaxNumAtResponsibleTaxAuthority__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxType__c')) rootMaintainVendor.writeStringField('TaxType',vendorReuest.VPM_TaxType__c);
            //if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndicatorVendorSubRangeRelevant__c')) rootMaintainVendor.writeStringField('IndicatorVendorSubRangeRelevant',vendorReuest.VPM_IndicatorVendorSubRangeRelevant__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CreditInfoNumber__c')) rootMaintainVendor.writeStringField('CreditInfoNumber',vendorReuest.VPM_CreditInfoNumber__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BlockFunction__c')) rootMaintainVendor.writeStringField('BlockFunction',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_BlockFunction__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AutoEvalGRSetmtRet__c')) rootMaintainVendor.writeBooleanField('AutoEvalGRSetmtRet',vendorReuest.VPM_AutoEvalGRSetmtRet__c); 
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CheckDoubleInvoices__c')) rootMaintainVendor.writeBooleanField('CheckDoubleInvoices',vendorReuest.VPM_CheckDoubleInvoices__c); 
           


            // Purchsing Data Object
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ABCIndicator__c')) PurchasingData.writeStringField('ABCIndicator',vendorReuest.VPM_ABCIndicator__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_OrderCurrency__c')) PurchasingData.writeStringField('OrderCurrency',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_OrderCurrency__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SalesPerson__c')) PurchasingData.writeStringField('SalesPerson',vendorReuest.VPM_SalesPerson__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Telephone__c')) PurchasingData.writeStringField('Telephone',vendorReuest.VPM_Telephone__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_MinimumOrderValue__c')) PurchasingData.writeNumberField('MinimumOrderValue',vendorReuest.VPM_MinimumOrderValue__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PaymentTerms__c')) PurchasingData.writeStringField('PaymentTerms',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PaymentTerms__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Incoterms1__c')) PurchasingData.writeStringField('Incoterms1',vendorReuest.VPM_Incoterms1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Incoterms2__c')) PurchasingData.writeStringField('Incoterms2',vendorReuest.VPM_Incoterms2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_GRbasedIV__c')) PurchasingData.writeBooleanField('GRbasedIV',vendorReuest.VPM_GRbasedIV__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_OrderAcknowledgmentRequirement__c')) PurchasingData.writeBooleanField('OrderAcknowledgmentRequirement',vendorReuest.VPM_OrderAcknowledgmentRequirement__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SchemaGroupVendor__c')) PurchasingData.writeStringField('SchemaGroupVendor',vendorReuest.VPM_SchemaGroupVendor__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AutomaticPurchaseOrderGeneration__c')) PurchasingData.writeBooleanField('AutoGenerationPOAllowed',vendorReuest.VPM_AutomaticPurchaseOrderGeneration__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ModeTransportForeignTrade__c')) PurchasingData.writeStringField('ModeTransportForeignTrade',vendorReuest.VPM_ModeTransportForeignTrade__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_OfficeOfEntry__c')) PurchasingData.writeStringField('OfficeOfEntry',vendorReuest.VPM_OfficeOfEntry__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PricingDateControl__c')) PurchasingData.writeStringField('PricingDateControl',vendorReuest.VPM_PricingDateControl__c);
            //if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PurchasingGroup__c')) PurchasingData.writeStringField('PurchasingGroup',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PurchasingGroup__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AutoEvalGRSetmtDel__c')) PurchasingData.writeBooleanField('AutoEvalGRSetmtDel',vendorReuest.VPM_AutoEvalGRSetmtDel__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PlannedDeliveryTime__c')) PurchasingData.writeNumberField('PlannedDeliveryTime',vendorReuest.VPM_PlannedDeliveryTime__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_RackJobbingServiceAgreed__c')) PurchasingData.writeBooleanField('RackJobbingServiceAgreed',vendorReuest.VPM_RackJobbingServiceAgreed__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_RelevantForPriceDet__c')) PurchasingData.writeBooleanField('RelevantForPriceDet',vendorReuest.VPM_RelevantForPriceDet__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_GrantDiscInKind__c')) PurchasingData.writeBooleanField('GrantDiscInKind',vendorReuest.VPM_GrantDiscInKind__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_DocIndexActive__c')) PurchasingData.writeBooleanField('DocIndexActive',vendorReuest.VPM_DocIndexActive__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SortCriterion__c')) PurchasingData.writeStringField(' SortCriterion',vendorReuest.VPM_SortCriterion__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ConfirmationControl__c')) PurchasingData.writeStringField('ConfirmationControl',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_ConfirmationControl__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_OrderOptimRest__c')) PurchasingData.writeStringField('OrderOptimRest',vendorReuest.VPM_OrderOptimRest__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AccntWithVendor__c')) PurchasingData.writeStringField(' AccntWithVendorPO',vendorReuest.VPM_AccntWithVendor__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PROATControlProof__c')) PurchasingData.writeStringField('PROATControlProof',vendorReuest.VPM_PROATControlProof__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SRVBasedVendorID__c')) PurchasingData.writeBooleanField('SRVBasedVendorID',vendorReuest.VPM_SRVBasedVendorID__c);

            // BankDetails Object
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BankCountryKey__c')) BankDetails.writeStringField('BankCountryKey',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_BankCountryKey__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BankKey__c')) BankDetails.writeStringField('BankKey',vendorReuest.VPM_BankKey__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BankAccountNumber__c')) BankDetails.writeStringField('BankAccountNumber',vendorReuest.VPM_BankAccountNumber__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BankControlKey__c')) BankDetails.writeStringField('BankControlKey',vendorReuest.VPM_BankControlKey__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PartnerBankType__c')) BankDetails.writeStringField('PartnerBankType',vendorReuest.VPM_PartnerBankType__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CollectionAuthorization__c')) BankDetails.writeBooleanField('CollectionAuthorisation',vendorReuest.VPM_CollectionAuthorization__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ReferenceSpecificationsBankDetail__c')) BankDetails.writeStringField('RefSpecBankDetails',vendorReuest.VPM_ReferenceSpecificationsBankDetail__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AccountHolderName__c')) BankDetails.writeStringField('AccountHolderName',vendorReuest.VPM_AccountHolderName__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IBAN__c')) BankDetails.writeStringField('IBAN',vendorReuest.VPM_IBAN__c);

            //WtaxType object
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndicatorForWithholdingTaxType__c')) WtaxType.writeStringField('IndicatorForWithholdingTaxType',vendorReuest.VPM_IndicatorForWithholdingTaxType__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Liable__c')) WtaxType.writeBooleanField('Liable',vendorReuest.VPM_Liable__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CertificateWithholdingTaxExemption__c')) WtaxType.writeStringField('WithholdingTaxCode',vendorReuest.VPM_CertificateWithholdingTaxExemption__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExemptionRate__c')) WtaxType.writeNumberField('ExemptionRate',vendorReuest.VPM_ExemptionRate__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExemptionFrom__c')) WtaxType.writeStringField('ExemptionFrom',formatDate(vendorReuest.VPM_ExemptionFrom__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExemptionTo__c')) WtaxType.writeStringField('ExemptionTo',formatDate(vendorReuest.VPM_ExemptionTo__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExemptionNumber__c')) WtaxType.writeStringField('ExemptionCertNumber',vendorReuest.VPM_ExemptionNumber__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ReasonForExemption__c')) WtaxType.writeStringField('ExemptionReason',vendorReuest.VPM_ReasonForExemption__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_RecipientType__c')) WtaxType.writeStringField('TypeOfRecipient',vendorReuest.VPM_RecipientType__c);
           
           // For Fusion
              if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SubsequentSettlement__c')) PurchasingData.writeStringField('SubsequentSettlement',vendorReuest.VPM_SubsequentSettlement__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SubsequentSettlementIndex__c')) PurchasingData.writeStringField('SubsequentSettlementIndex',vendorReuest.VPM_SubsequentSettlementIndex__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ShippingConditions__c')) PurchasingData.writeStringField('ShippingConditions',vendorReuest.VPM_ShippingConditions__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_UnitOfMeasureGrp__c')) PurchasingData.writeStringField('UnitOfMeasureGroup',vendorReuest.VPM_UnitOfMeasureGrp__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_RoundingProfile__c')) PurchasingData.writeStringField('RoundingProfile',vendorReuest.VPM_RoundingProfile__c);
           /* if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryName__c')) PurchasingData.writeStringField('BeneficiaryName',vendorReuest.VPM_BeneficiaryName__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryAddress1__c')) PurchasingData.writeStringField('BeneficiaryAddress1',vendorReuest.VPM_BeneficiaryAddress1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryAddress2__c')) PurchasingData.writeStringField('BeneficiaryAddress2',vendorReuest.VPM_BeneficiaryAddress2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryAddress3__c')) PurchasingData.writeStringField('BeneficiaryAddress3',vendorReuest.VPM_BeneficiaryAddress3__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryCountry__c')) PurchasingData.writeStringField('BeneficiaryCountry',vendorReuest.VPM_BeneficiaryCountry__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyName__c')) PurchasingData.writeStringField('ThirdPartyName',vendorReuest.VPM_ThirdPartyName__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress1__c')) PurchasingData.writeStringField('ThirdPartyAddress1',vendorReuest.VPM_ThirdPartyAddress1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress2__c')) PurchasingData.writeStringField('ThirdPartyAddress2',vendorReuest.VPM_ThirdPartyAddress2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress3__c')) PurchasingData.writeStringField('ThirdPartyAddress3',vendorReuest.VPM_ThirdPartyAddress3__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress4__c')) PurchasingData.writeStringField('ThirdPartyAddress4',vendorReuest.VPM_ThirdPartyAddress4__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_FreeText1__c')) PurchasingData.writeStringField('FreeText1',vendorReuest.VPM_FreeText1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_FreeText2__c')) PurchasingData.writeStringField('FreeText2',vendorReuest.VPM_FreeText2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PayableLocation__c')) PurchasingData.writeStringField('PayableLocation',vendorReuest.VPM_PayableLocation__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndividualPayment__c')) PurchasingData.writeBooleanField('IndividualPayment',vendorReuest.VPM_IndividualPayment__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_NODEL__c')) PurchasingData.writeStringField('Nodel',vendorReuest.VPM_NODEL__c);
           */ 
          }
          if(vendorReuest.VPM_ECC__c == 'Sirius' || vendorReuest.VPM_ECC__c =='Fusion')
          {
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CorporateGrp__c')) rootMaintainVendor.writeStringField('CorporateGroup',vendorReuest.VPM_CorporateGrp__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExternalMFG__c')) rootMaintainVendor.writeStringField('ExternalManufacturer',vendorReuest.VPM_ExternalMFG__c);

            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SortKey__c')) CompanyData.writeStringField('SortKey',vendorReuest.VPM_SortKey__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ReconciliationAccount__c')) CompanyData.writeStringField('ReconciliationAccount',vendorReuest.VPM_ReconciliationAccount__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Authorization__c')) CompanyData.writeStringField('AuthorizationCC',vendorReuest.VPM_Authorization__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Interestcalculationindicator__c')) CompanyData.writeStringField('InterestCalculationIndicator',vendorReuest.VPM_Interestcalculationindicator__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PaymentMethod__c')) CompanyData.writeStringField('PaymentMethod',vendorReuest.VPM_PaymentMethod__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndicatorClearingBetwCustomerNVendor__c')) CompanyData.writeBooleanField('IndicatorClearingBetwCustomerNVendor',vendorReuest.VPM_IndicatorClearingBetwCustomerNVendor__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PaymentBlock__c')) CompanyData.writeStringField('PaymentBlock',vendorReuest.VPM_PaymentBlock__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PaymentTerms__c')) CompanyData.writeStringField('PaymentTerm',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PaymentTerms__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AccntWithVendor__c')) CompanyData.writeStringField('AccntWithVendor',vendorReuest.VPM_AccntWithVendor__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ClerkAtVendor__c')) CompanyData.writeStringField('ClerkAtVendor',vendorReuest.VPM_ClerkAtVendor__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AccountMemo__c')) CompanyData.writeStringField('AccountMemo',vendorReuest.VPM_AccountMemo__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AccountingClerk__c')) CompanyData.writeStringField('AccountingClerk',vendorReuest.VPM_AccountingClerk__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CashManagementGroup__c')) CompanyData.writeStringField('CashManagementGroup',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_CashManagementGroup__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AlternativePayee__c')) CompanyData.writeStringField('AlternativePayee',vendorReuest.VPM_AlternativePayee__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_LastKeyDate__c')) CompanyData.writeStringField('LastKeyDate',formatDate(vendorReuest.VPM_LastKeyDate__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_InterestFrequency__c')) CompanyData.writeStringField('InterestFrequency',vendorReuest.VPM_InterestFrequency__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_LastInterestRun__c')) CompanyData.writeStringField('LastInterestRun',formatDate(vendorReuest.VPM_LastInterestRun__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BExchangeLimit__c')) CompanyData.writeNumberField('BExchangeLimit',vendorReuest.VPM_BExchangeLimit__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ChkCashing__c')) CompanyData.writeStringField('ChkCashing',vendorReuest.VPM_ChkCashing__c);

            // VAT object
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_VATCountry__c')) CompanyData.writeStringField('VATCountry',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_VATCountry__c));
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_VATRegistrationNumber2__c')) CompanyData.writeStringField('VATRegistrationNumber',vendorReuest.VPM_VATRegistrationNumber2__c);

             
             //Fusion Only
             if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryName__c')) CompanyData.writeStringField('BeneficiaryName',vendorReuest.VPM_BeneficiaryName__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryAddress1__c')) CompanyData.writeStringField('BeneficiaryAddress1',vendorReuest.VPM_BeneficiaryAddress1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryAddress2__c')) CompanyData.writeStringField('BeneficiaryAddress2',vendorReuest.VPM_BeneficiaryAddress2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryAddress3__c')) CompanyData.writeStringField('BeneficiaryAddress3',vendorReuest.VPM_BeneficiaryAddress3__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_BeneficiaryCountry__c')) CompanyData.writeStringField('BeneficiaryCountry',vendorReuest.VPM_BeneficiaryCountry__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyName__c')) CompanyData.writeStringField('ThirdPartyName',vendorReuest.VPM_ThirdPartyName__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress1__c')) CompanyData.writeStringField('ThirdPartyAddress1',vendorReuest.VPM_ThirdPartyAddress1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress2__c')) CompanyData.writeStringField('ThirdPartyAddress2',vendorReuest.VPM_ThirdPartyAddress2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress3__c')) CompanyData.writeStringField('ThirdPartyAddress3',vendorReuest.VPM_ThirdPartyAddress3__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ThirdPartyAddress4__c')) CompanyData.writeStringField('ThirdPartyAddress4',vendorReuest.VPM_ThirdPartyAddress4__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_FreeText1__c')) CompanyData.writeStringField('FreeText1',vendorReuest.VPM_FreeText1__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_FreeText2__c')) CompanyData.writeStringField('FreeText2',vendorReuest.VPM_FreeText2__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PayableLocation__c')) CompanyData.writeStringField('PayableLocation',vendorReuest.VPM_PayableLocation__c);
            if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_IndividualPayment__c')) CompanyData.writeBooleanField('IndividualPayment',vendorReuest.VPM_IndividualPayment__c);
            //if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_NODEL__c')) CompanyData.writeStringField('Nodel',vendorReuest.VPM_NODEL__c);
              }
              // Address object
               if(vendorReuest.VPM_ECC__c == 'Fusion')
               {
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ZIPPostCode__c')) Address.writeStringField('ZIPPostCode',vendorReuest.VPM_ZIPPostCode__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CompanyPostCode__c')) Address.writeStringField('CompanyPostCode',vendorReuest.VPM_CompanyPostCode__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_POBox__c')) Address.writeStringField('POBox',vendorReuest.VPM_POBox__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_POBoxCity__c')) Address.writeStringField('POBoxCity',vendorReuest.VPM_POBoxCity__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TransportZone__c')) Address.writeStringField('TransportZone',vendorReuest.VPM_TransportZone__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_HouseNumber__c')) Address.writeStringField('HouseNumber',vendorReuest.VPM_HouseNumber__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street1__c')) Address.writeStringField('Street1',vendorReuest.VPM_Street1__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street2__c')) Address.writeStringField('Street2',vendorReuest.VPM_Street2__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street3__c')) Address.writeStringField('Street3',vendorReuest.VPM_Street3__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street4__c')) Address.writeStringField('Street4',vendorReuest.VPM_Street4__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street5__c')) Address.writeStringField('Street5',vendorReuest.VPM_Street5__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_District__c')) Address.writeStringField('District',vendorReuest.VPM_District__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Country__c')) Address.writeStringField('Country',vendorReuest.VPM_Country__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Language__c')) Address.writeStringField('Language',vendorReuest.VPM_Language__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Region__c')) Address.writeStringField('Region',vendorReuest.VPM_Region__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_RegStGrp__c')) Address.writeStringField('RegStructGroup',vendorReuest.VPM_RegStGrp__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SearchTerm_1__c')) Address.writeStringField('SearchTerm1',vendorReuest.VPM_SearchTerm_1__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SearchTerm2__c')) Address.writeStringField('SearchTerm2',vendorReuest.VPM_SearchTerm2__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_AddressTimeZone__c')) Address.writeStringField('AddressTimeZone',vendorReuest.VPM_AddressTimeZone__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxJurisdictionCode__c')) Address.writeStringField('TaxJurisdictionCode',vendorReuest.VPM_TaxJurisdictionCode__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_StandardCommMethod__c')) Address.writeStringField('StandardCommMethod',vendorReuest.VPM_StandardCommMethod__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Telephone__c')) Address.writeStringField('Telephone',vendorReuest.VPM_Telephone__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExtensionPhone__c')) Address.writeStringField('ExtensionPhone',vendorReuest.VPM_ExtensionPhone__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Fax__c')) Address.writeStringField('Fax',vendorReuest.VPM_Fax__c);
                if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_FaxExtension__c')) Address.writeStringField('FaxExtension',vendorReuest.VPM_FaxExtension__c);
                
                // CIN Object
                
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_PANNumber__c')) CIN.writeStringField('PANNumber',vendorReuest.VPM_PANNumber__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_CSTno__c')) CIN.writeStringField('CSTno',vendorReuest.VPM_CSTno__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_LSTno__c')) CIN.writeStringField('LSTno',vendorReuest.VPM_LSTno__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SerRegNo__c')) CIN.writeStringField('SerRegNo',vendorReuest.VPM_SerRegNo__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExcIndVendor__c')) CIN.writeStringField('ExcIndVendor',vendorReuest.VPM_ExcIndVendor__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ECCNo__c')) CIN.writeStringField('ECCNo',vendorReuest.VPM_ECCNo__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExciseRegNo__c')) CIN.writeStringField('ExciseRegNo',vendorReuest.VPM_ExciseRegNo__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExciseRange__c')) CIN.writeStringField('ExciseRange',vendorReuest.VPM_ExciseRange__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_ExciseDivision__c')) CIN.writeStringField('ExciseDivision',vendorReuest.VPM_ExciseDivision__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_Commissionerate__c')) CIN.writeStringField('Commissionerate',vendorReuest.VPM_Commissionerate__c);
                 if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase('VPM_SSIStatus__c')) CIN.writeStringField('SSIStatus',vendorReuest.VPM_SSIStatus__c);
                 }
                
                
                
              
          
           JSONPurchasingData= PurchasingData.getAsString();
          if(JSONPurchasingData != '{ }')
          {
           //PurchasingData.writeStringField('PurchasingOrganisation',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PurchasingOrg__r.Name));
           JSONPurchasingData = JSONPurchasingData.removeEnd('}');
           JSONPurchasingData = JSONPurchasingData+',"PurchasingOrganisation":"'+VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PurchasingOrg__r.Name)+'"}';  
            rootMaintainVendor.writeFieldName('PurchasingData');
           rootMaintainVendor.writeObject(JSONPurchasingData);
          }
          JSONCompanyData = CompanyData.getAsString();
          if(JSONCompanyData != '{ }')
          {
           //PurchasingData.writeStringField('PurchasingOrganisation',VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PurchasingOrg__r.Name));
           JSONCompanyData = JSONCompanyData.removeEnd('}');
           JSONCompanyData = JSONCompanyData+',"PurchasingOrganisation":"'+VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PurchasingOrg__r.Name)+'"}';  
           rootMaintainVendor.writeFieldName('CompanyData');
           rootMaintainVendor.writeObject(JSONCompanyData);
          }
          JSONBankDetails= BankDetails.getAsString();
          if(JSONBankDetails != '{ }')
          {
           rootMaintainVendor.writeFieldName('BankDetails');
           rootMaintainVendor.writeObject(JSONBankDetails);
          }
            JSONWtaxType= WtaxType.getAsString();
          if(JSONWtaxType != '{ }')
          {
           rootMaintainVendor.writeFieldName('WtaxType');
           rootMaintainVendor.writeObject(JSONWtaxType);
          }
          JSONVAT= VAT.getAsString();
          if(JSONVAT != '{ }')
          {
           rootMaintainVendor.writeFieldName('VAT');
           rootMaintainVendor.writeObject(JSONVAT);
          }
          JSONCIN= CIN.getAsString();
          if(JSONCIN != '{ }')
          {
           rootMaintainVendor.writeFieldName('CIN');
           rootMaintainVendor.writeObject(JSONCIN);
          }//Address
          JSONAddress= Address.getAsString();
          if(JSONAddress != '{ }')
          {
           rootMaintainVendor.writeFieldName('VAT');
           rootMaintainVendor.writeObject(JSONAddress);
          }

          
          maintainVendorObjectJSON = rootMaintainVendor.getAsString();
           maintainVendorObjectJSON =maintainVendorObjectJSON.replaceAll('\\\\n','');
          maintainVendorObjectJSON =maintainVendorObjectJSON.replaceAll('\\\\','');
          maintainVendorObjectJSON =maintainVendorObjectJSON.replaceAll('"\\{','{');
          maintainVendorObjectJSON =maintainVendorObjectJSON.replaceAll('\\}"','}');
         
         
         system.debug('PurchasingOrganisationJSOn  '+maintainVendorObjectJSON );
          return maintainVendorObjectJSON;
          //return '{  "ECC" : "Cordillera",  "VendorCode" : "0050479756",  "IntLocationNumber1" : "0000000",  "IntLocationNumber2" : "00000",  "Authorization" : "NPIV",  "Industry" : "5999",  "CheckDigit" : "0",  "AccountGroup" : "Sept",  "TaxNumber1" : "20507634479",  "TaxBase" : "0",  "PurchasingData" : {  "OrderCurrency" : "PEN",  "SalesPerson" : "A.G.",  "Telephone" : "4425555",  "MinimumOrderValue" : 0,  "PaymentTerms" : "P002",  "Incoterms1" : "DAP",  "Incoterms2" : "Delivered at Place (DAP)",  "SchemaGroupVendor" : "01",  "PurchasingGroup" : "PE1",  "PlannedDeliveryTime" : 0,  "VPM_SRVBasedVendorID__c" : false,  "PurchasingOrganisation" : "PE01"}}';
        //return '{  "ECC": "Fusion",  "VendorCode": "0050000018",  "TrainStation": "Train",  "IntLocationNumber1": "0000001",  "IntLocationNumber2": "1",  "Authorization": "SAP",  "Industry": "1",  "CheckDigit": "1",  "DMEIndicator": "1",  "InstructionKeyDataExchange": "01",  "ISRNumber": "7890",  "CorporateGroup": "GROUP",  "AccountGroup": "HL13",  "Customer": "YU125",  "AlternativePayeeAccountNumber": "2000004",  "CentralDeletionFlag": null,  "CentralPostingBlock": null,  "CentralPurchasingBlock": null,  "TaxNumber1": "TAX 1",  "TaxNumber2": "TAX 2",  "EqualisationTax": null,  "SalesPurchTax": true,  "AltPayeeAllowedFlag": null,  "FiscalAddress": null,  "VATRegistrationNumber": "19200361003",  "isNaturalPerson": true,  "BlockFunction": null,  "PlaceOfBirth": "Bangalore",  "DateOfBirth": "1985-08-01",  "Sex": "1",  "CreditInfoNumber": "INFO",  "LastExtReview": "2016-09-05",  "ActualQMSystem": "1080",  "Plant": null,  "IndicatorVendorSubRangeRelevant": null,  "IndicatorPlantLevel": null,  "SCAC": "SC12",  "CarFreightGroup": null,  "TaxType": "09",  "TaxNumberType": "01",  "TaxNumber3": "TAX 134",  "TaxNumber4": "TAX 156",  "TaxSplit": null,  "TaxBase": "1",  "TaxNumberResponsibleAuthority": null,  "Profession": "Consultant",  "ExternalManufacturer": "External",  "Nodel": null,  "QMSystemTo": "2016-09-05",  "PODRelevant": "B",  "IndicatorAlternativePayeeAccountNumber": null,  "TaxOfficeIdentification": "50478468",  "TaxNumber5": "TAX 5",  "LLDCode": null,  "CorrespondentBank": null,  "Email": "nithin.jacob@unilever.com",  "VendorSubRange": null,  "TradingPartner": "1000",  "SocialInsuranceCode": "SAP",  "ServiceAgent": "0001",  "Address": {    "RegionStreetGroup": null,    "ZIPPostCode": "517501",    "CompanyPostCode": "562101",    "POBox": "517501",    "POBoxCity": "Bangalore",    "TransportZone": "0000000001",    "HouseNumber": "1234",    "Street1": "Street1",    "Street2": "Street2",    "Street3": "Street3",    "Street4": "Street4",    "Street5": "Street5",    "District": "District",    "Country": "IN",    "Language": "E",    "Region": "10",    "RegStructGroup": "H03",    "SearchTerm1": "SEARCH",    "SearchTerm2": "80",    "AddressTimeZone": "INDIA",    "TaxJurisdictionCode": "TAX JUD",    "StandardCommMethod": "INT",    "Telephone": "80445567",    "ExtensionPhone": "1234",    "Fax": "12345",    "FaxExtension": "123"  }, "CompanyData": {    "CompanyCode": "Haa",    "SortKey": "009",    "ReconciliationAccount": "1420198",    "AuthorizationCC": "AUTH",    "InterestCalculationIndicator": null,    "PaymentMethod": "0",    "PaymentBlock": "A",    "PaymentTerm": null,    "AccntWithVendor": null,    "ClerkAtVendor": null,    "AccountMemo": null,    "CashManagementGroup": "A1",    "AccountingClerk": null,    "HeadOfficeAccNo": "50478468",    "AlternativePayee": null,    "LastKeyDate": null,    "InterestFrequency": null,    "LastInterestRun": null,    "BExchangeLimit": "0",    "ChkCashing": "0",    "ToleranceGroup": "0001",    "HouseBank": "AAC01",    "ValidUntil": null,    "ExemptionNumber": null,    "PreviousAccountNumber": "TA009",    "GroupingKey": "01",    "MGroupingKey": null,    "PaymentMethodSupplement": "1",    "WithholdingTaxCountryKey": "IN",    "ClerksFax": null,    "ClerksInternet": null,    "PaymentTermsCreditMemoKey": "00AD",    "AccountStatement": null,    "CertificationDate": null,    "AccountClerkTelephoneNumber": null,    "BeneficiaryName": "Test",    "BeneficiaryAddress1": "ADD NAME",    "BeneficiaryAddress2": "SPARK,ANDHERI KURLA ROAD,AN",    "BeneficiaryAddress3": "DHERI (E)",    "BeneficiaryCountry": "IN",    "ThirdPartyCountry": "IN",    "ThirdPartyName": "PARTY NAME",    "ThirdPartyAddress1": "ADD1",    "ThirdPartyAddress2": "ADD2",    "ThirdPartyAddress3": "ADD3",    "ThirdPartyAddress4": "ADD4",    "FreeText1": "Text 1",    "FreeText2": "Text 2",    "PayableLocation": "BANGALORE",    "IndicatorClearingBetwCustomerNVendor": null,    "CheckDoubleInvoices": true,    "IndividualPayment": true,    "MinorityIndicator": null,    "PmtAdviceByEDI": null,    "Nodel": null,    "AdoptScanDate": null,    "WtaxType":{        "IndicatorForWithholdingTaxType": "A0",        "IdentificationNumber": "ID",        "Liable": null,        "WithholdingTaxCode": null,        "ExemptionRate": "1",        "ExemptionFrom": "2016-09-05",        "ExemptionTo": "2016-09-05",        "ExemptionReason": "A",        "ExemptionCertNumber": "98700678",        "TypeOfRecipient": null      }  },  "PurchasingData": {    "PurchasingOrganisation": "ULCP",    "ABCIndicator": "A",    "OrderCurrency": "INR",    "SalesPerson": "Master",    "Telephone": "987456432",    "MinimumOrderValue": "1",    "PaymentTerms": "30DK",    "Incoterms1": "CFR",    "Incoterms2": "COST AND FREIGHT",    "SchemaGroupVendor": "DO",    "ModeTransportForeignTrade": "3",    "OfficeOfEntry": "0001",    "PricingDateControl": "1",    "PurchasingGroup": "101",    "PlannedDeliveryTime": "1",    "SortCriterion": "C",    "ConfirmationControl": "ZULC",    "OrderOptimRest": "0001",    "AccntWithVendorPO": "1234567",    "PROACTControlProof": "SAPD",    "GRbasedIV": true,    "OrderAcknowledgmentRequirement": null,    "AutoGenerationPOAllowed": null,    "AutoEvalGRSetmtDel": true,    "RackJobbingServiceAgreed": null,    "RelevantForPriceDet": true,    "GrantDiscInKind": true,    "DocIndexActive": true,    "AutoEvalGRSetmtRet": true,    "SRVBasedVendorID": null,    "AcknowledgeReq": true,    "SubsequentSettlement": true,    "SubsequentSettlementIndex": true,    "AutoPurchaseOrder": true,    "ShippingConditions": "01",    "UnitOfMeasureGroup": "Z1",    "RoundingProfile": "ZC01"  },  "CIN": {    "PANNumber": "AAJFA9129R",    "CSTno": "19413403267",    "LSTno": "19413403073",    "SerRegNo": "AAJFA9129RST001",    "ExcIndVendor": null,    "ECCNo": "TEST2",    "ExciseRegNo": "346TEST",    "ExciseRange": "567TEST",    "ExciseDivision": "TEST",    "Commissionerate": "TEST1",    "SSIStatus": "0",    "TypeVendor": "M",    "CENVAT": true,    "Changedon": null,    "ChangedBy": null,    "PANreference": "REFERENCE1"  }}';
    }
         
      public string appendZero(string value, Integer zeroCount)
    {
        string formatedValue='';

        if(zeroCount == 1)
            formatedValue ='0'+value;

        else if(zeroCount == 2)
            formatedValue ='00'+value;

        else if(zeroCount == 3)
            formatedValue ='000'+value;

        return formatedValue;
    }
     public string formatDate(DateTime dt)
    {
        string formatedDate = dt.format('yyy-MM-dd');
        return formatedDate;
    }
}