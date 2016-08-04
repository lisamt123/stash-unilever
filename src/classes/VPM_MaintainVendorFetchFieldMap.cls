public  class VPM_MaintainVendorFetchFieldMap {
    public string VPM_ConvertMaintainVendorFieldDetailsToJSON(string VendorRequestId) {
          String maintainVendorObjectJSON;
          Integer reqNum = VPM_HttpUtil.generateRandomNumber();
           List<VPM_PurchasingRequests__c> vendorList =[SELECT VPM_MDMBPMRequestorName__c,VPM_ISRNumber__c,VPM_Customer__c,VPM_AccountGroup__c,VPM_InstructionKeyDataExchange__c,VPM_VendorSubRange__c,VPM_Industry__c,VPM_Authorization__c,VPM_TrainStation__c,VPM_ECC__c, VPM_MDMBPMRequestorPhone__c, VPM_MDMBPMRequestorEmail__c, VPM_CountryRequestingVendor__c,VPM_EqualisationTax__c,
        VPM_MDMBPMRequestorDepartment__c, VPM_MDMBPMRequestDate__c, VPM_VendorCode__c,VPM_DMEIndicator__c, VPM_Comments__c, VPM_ECCSystem__c, VPM_VendorName1__c,VPM_ActualQMSystem__c, VPM_TaxNumber5__c,VPM_ReconciliationAccount__c,VPM_CashManagementGroup__c,VPM_ToleranceGroup__c,VPM_AccountClerkTelephoneNumber__c,VPM_BankCountryKey__c,VPM_BankKey__c,VPM_IndicatorVendorSubRangeRelevant__c,
        VPM_VendorName2__c,VPM_Name3__c,VPM_Name4__c, VPM_SearchTerm_1__c,VPM_SearchTerm2__c, VPM_Street1__c,VPM_Street2__c,VPM_Street3__c,VPM_FiscalAddress__c,VPM_CarFreightGroup__c,VPM_SortKey__c,VPM_InterestCalculationIndicator__c,VPM_ChkCashing__c,VPM_PreviousAccountNumber__c,VPM_BankControlKey__c,VPM_PartnerBankType__c,VPM_PurchasingOrganisation__c,VPM_SalesPurchTax__c,
        VPM_Street4__c,VPM_HouseNumber__c,VPM_HouseNumSupplement__c,VPM_ZIPPostCode__c,VPM_PlaceOfBirth__c, VPM_Regions__r.VPM_Code__c,VPM_Country__c,VPM_City__c,VPM_District__c,VPM_CompanyCode__c,VPM_PaymentMethod__c,VPM_ExemptionNumber__c,VPM_GroupingKey__c,VPM_PaymentMethodSupplement__c,VPM_IBAN__c,VPM_OrderCurrency__c,VPM_SchemaGroupVendor__c,VPM_ConfirmationControl__c,
        VPM_IsVendorSME__c, VPM_IsVendorException__c, VPM_ExceptionType__c, VPM_POBox__c, VPM_POBoxPostCode__c, VPM_TaxNumber1__c, VPM_TaxNumber2__c,VPM_SCAC__c,VPM_TaxBase__c,VPM_PaymentBlock__c,VPM_AccntWithVendor__c,VPM_AlternativePayee__c,VPM_WithholdingTaxCountryKey__c,VPM_AccountHolderName__c,VPM_Telephone__c,VPM_ModeTransportForeignTrade__c,VPM_OrderOptimRest__c,
        VPM_TaxNumber3__c, VPM_TaxNumber4__c, VPM_VATRegistrationNumber__c, VPM_TaxNumberType__c, VPM_TaxJurisdictionCode__c,VPM_Sex__c,VPM_Plant__c,VPM_ServiceAgent__c,VPM_PODRelevant__c,VPM_ClerkAtVendor__c,VPM_AccountingClerk__c,VPM_ClerksFax__c,VPM_ClerksInternet__c,VPM_ABCIndicator__c,VPM_SalesPerson__c,VPM_OfficeOfEntry__c,VPM_PurchasingGroup__c,VPM_PROATControlProof__c,
        VPM_TaxNumAtResponsibleTaxAuthority__c, VPM_CreditInfoNumber__c, VPM_CorporateGrp__c, VPM_IntLocationNumber1__c, VPM_IntLocationNumber2__c,VPM_Profession_c__c,VPM_AccountMemo__c,VPM_InterestFrequency__c,VPM_HouseBank__c,VPM_AccountStatement__c,VPM_PaymentTerms__c,VPM_Incoterms1__c,VPM_Incoterms2__c,VPM_PricingDateControl__c,VPM_SortCriterion__c,
        VPM_ExtManufacturer__c, VPM_CheckDigit__c from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
         if(vendorList != null && vendorList.size() > 0) {
        VPM_MaintainVendorServiceHelper  maintainVendorObject= new VPM_MaintainVendorServiceHelper();
        maintainVendorObject.CompanyData= new VPM_MaintainVendorServiceHelper.CompanyDataObj();
         //maintainVendorObject.BankDetails = new VPM_MaintainVendorServiceHelper.BankDetailsObj();
         maintainVendorObject.PurchasingData= new VPM_MaintainVendorServiceHelper.PurchasingDataObj ();
         VPM_MaintainVendorServiceHelper.DunningObj Dunning= new VPM_MaintainVendorServiceHelper.DunningObj();
         VPM_MaintainVendorServiceHelper.WtaxTypeObj WtaxType= new VPM_MaintainVendorServiceHelper.WtaxTypeObj ();
         VPM_MaintainVendorServiceHelper.FunctionObj Function= new VPM_MaintainVendorServiceHelper.FunctionObj();

        maintainVendorObject.ECC=vendorList.get(0).VPM_ECC__c== null?'':vendorList.get(0).VPM_ECC__c;
        maintainVendorObject.VendorCode=vendorList.get(0).VPM_VendorCode__c== null?'':vendorList.get(0).VPM_VendorCode__c;
        maintainVendorObject.TrainStation=vendorList.get(0).VPM_TrainStation__c== null?'':vendorList.get(0).VPM_TrainStation__c;
        maintainVendorObject.IntLocationNumber1=vendorList.get(0).VPM_IntLocationNumber1__c== null?'':vendorList.get(0).VPM_IntLocationNumber1__c;
        maintainVendorObject.IntLocationNumber2=vendorList.get(0).VPM_IntLocationNumber2__c== null?'':vendorList.get(0).VPM_IntLocationNumber2__c;
        maintainVendorObject.Authorization=vendorList.get(0).VPM_Authorization__c== null?'':vendorList.get(0).VPM_Authorization__c;
        maintainVendorObject.Industry=vendorList.get(0).VPM_Industry__c== null?'':vendorList.get(0).VPM_Industry__c;
        maintainVendorObject.CheckDigit=vendorList.get(0).VPM_CheckDigit__c== null?'':vendorList.get(0).VPM_CheckDigit__c;
        //maintainVendorObject.VendorSubRange=vendorList.get(0).VPM_VendorSubRange__c== null?'':vendorList.get(0).VPM_VendorSubRange__c;
        maintainVendorObject.DMEIndicator=vendorList.get(0).VPM_DMEIndicator__c== null?'':vendorList.get(0).VPM_DMEIndicator__c;
        maintainVendorObject.InstructionKeyDataExchange=vendorList.get(0).VPM_InstructionKeyDataExchange__c== null?'':vendorList.get(0).VPM_InstructionKeyDataExchange__c;
        maintainVendorObject.ISRNumber=vendorList.get(0).VPM_ISRNumber__c== null?'':vendorList.get(0).VPM_ISRNumber__c;
        maintainVendorObject.AccountGroup=vendorList.get(0).VPM_AccountGroup__c== null?'':vendorList.get(0).VPM_AccountGroup__c;
        maintainVendorObject.Customer=vendorList.get(0).VPM_Customer__c== null?'':vendorList.get(0).VPM_Customer__c;
        //maintainVendorObject.AlternativePayeeAccountNumber=vendorList.get(0).VPM_AlternativePayeeAccountNumber__c== null?'':vendorList.get(0).VPM_AlternativePayeeAccountNumber__c;
        maintainVendorObject.TaxNumber1=vendorList.get(0).VPM_TaxNumber1__c== null?'':vendorList.get(0).VPM_TaxNumber1__c;
        maintainVendorObject.TaxNumber2=vendorList.get(0).VPM_TaxNumber2__c== null?'':vendorList.get(0).VPM_TaxNumber2__c;
        maintainVendorObject.EqualisationTax= vendorList.get(0).VPM_EqualisationTax__c;
        maintainVendorObject.SalesPurchTax= vendorList.get(0).VPM_SalesPurchTax__c;
        maintainVendorObject.FiscalAddress=vendorList.get(0).VPM_FiscalAddress__c== null?'':vendorList.get(0).VPM_FiscalAddress__c;
        maintainVendorObject.VATRegistrationNumber=vendorList.get(0).VPM_VATRegistrationNumber__c== null?'':vendorList.get(0).VPM_VATRegistrationNumber__c;
        maintainVendorObject.PlaceOfBirth=vendorList.get(0).VPM_PlaceOfBirth__c== null?'':vendorList.get(0).VPM_PlaceOfBirth__c;
        //maintainVendorObject.DateOfBirth=vendorList.get(0).VPM_DateOfBirth__c== null?'':vendorList.get(0).VPM_DateOfBirth__c;
        maintainVendorObject.Sex=vendorList.get(0).VPM_Sex__c== null?'':vendorList.get(0).VPM_Sex__c;
        //maintainVendorObject.LastExtReview=vendorList.get(0).VPM_LastExtReview__c== null?'':vendorList.get(0).VPM_LastExtReview__c;
        maintainVendorObject.ActualQMSystem=vendorList.get(0).VPM_ActualQMSystem__c== null?'':vendorList.get(0).VPM_ActualQMSystem__c;
        maintainVendorObject.Plant=vendorList.get(0).VPM_Plant__c== null?'':vendorList.get(0).VPM_Plant__c;
        maintainVendorObject.IndicatorVendorSubRange= vendorList.get(0).VPM_IndicatorVendorSubRangeRelevant__c;
        //maintainVendorObject.IndicatorPlantLevel=vendorList.get(0).VPM_IndicatorPlantLevel__c== null?'':vendorList.get(0).VPM_IndicatorPlantLevel__c;
        maintainVendorObject.SCAC=vendorList.get(0).VPM_SCAC__c== null?'':vendorList.get(0).VPM_SCAC__c;
        maintainVendorObject.CarFreightGroup=vendorList.get(0).VPM_CarFreightGroup__c== null?'':vendorList.get(0).VPM_CarFreightGroup__c;
        maintainVendorObject.ServiceAgent=vendorList.get(0).VPM_ServiceAgent__c== null?'':vendorList.get(0).VPM_ServiceAgent__c;
        maintainVendorObject.TaxNumber3=vendorList.get(0).VPM_TaxNumber3__c== null?'':vendorList.get(0).VPM_TaxNumber3__c;
        maintainVendorObject.TaxNumber4=vendorList.get(0).VPM_TaxNumber4__c== null?'':vendorList.get(0).VPM_TaxNumber4__c;
        //maintainVendorObject.TaxSplit=vendorList.get(0).VPM_TaxSplit__c== null?'':vendorList.get(0).VPM_TaxSplit__c;
        maintainVendorObject.TaxBase=vendorList.get(0).VPM_TaxBase__c== null?'':vendorList.get(0).VPM_TaxBase__c;
        maintainVendorObject.Profession_c=vendorList.get(0).VPM_Profession_c__c== null?'':vendorList.get(0).VPM_Profession_c__c;
        //maintainVendorObject.NODEL=vendorList.get(0).VPM_NODEL__c== null?'':vendorList.get(0).VPM_NODEL__c;
        //maintainVendorObject.QMSystemTo=vendorList.get(0).VPM_QMSystemTo__c== null?'':vendorList.get(0).VPM_QMSystemTo__c;
        maintainVendorObject.PODRelevant=vendorList.get(0).VPM_PODRelevant__c== null?'':vendorList.get(0).VPM_PODRelevant__c;
        maintainVendorObject.TaxNumber5=vendorList.get(0).VPM_TaxNumber5__c== null?'':vendorList.get(0).VPM_TaxNumber5__c;
        maintainVendorObject.RegionStreetGroup='';
        //maintainVendorObject.CorporateGroup=vendorList.get(0).VPM_CorporateGroup__c== null?'':vendorList.get(0).VPM_CorporateGroup__c;
        //maintainVendorObject.AltPayeeAllowedFlag=vendorList.get(0).VPM_AltPayeeAllowedFlag__c== null?'':vendorList.get(0).VPM_AltPayeeAllowedFlag__c;
        //maintainVendorObject.ExternalManufacturer=vendorList.get(0).VPM_ExternalManufacturer__c== null?'':vendorList.get(0).VPM_ExternalManufacturer__c;
        
        
        
        maintainVendorObject.CompanyData.CompanyCode = vendorList.get(0).VPM_CompanyCode__c == null?'' :vendorList.get(0).VPM_CompanyCode__c;
        maintainVendorObject.CompanyData.SortKey = vendorList.get(0).VPM_SortKey__c == null?'' :vendorList.get(0).VPM_SortKey__c;
        maintainVendorObject.CompanyData.ReconciliationAccount = vendorList.get(0).VPM_ReconciliationAccount__c == null?'' :vendorList.get(0).VPM_ReconciliationAccount__c;
        //maintainVendorObject.CompanyData.AuthorizationCC = vendorList.get(0).VPM_AuthorizationCC__c == null?'' :vendorList.get(0).VPM_AuthorizationCC__c;
        maintainVendorObject.CompanyData.InterestCalculationIndicator = vendorList.get(0).VPM_InterestCalculationIndicator__c == null?'' :vendorList.get(0).VPM_InterestCalculationIndicator__c;
        maintainVendorObject.CompanyData.PaymentMethod = vendorList.get(0).VPM_PaymentMethod__c == null?'' :vendorList.get(0).VPM_PaymentMethod__c;
        //maintainVendorObject.CompanyData.IndicatorClearingBetwCustomerNVendor = vendorList.get(0).VPM_IndicatorClearingBetwCustomerNVendor__c == null?'' :vendorList.get(0).VPM_IndicatorClearingBetwCustomerNVendor__c;
        maintainVendorObject.CompanyData.PaymentBlock = vendorList.get(0).VPM_PaymentBlock__c == null?'' :vendorList.get(0).VPM_PaymentBlock__c;
        //maintainVendorObject.CompanyData.PaymentTerm = vendorList.get(0).VPM_PaymentTerm__c == null?'' :vendorList.get(0).VPM_PaymentTerm__c;
        maintainVendorObject.CompanyData.AccntWithVendor = vendorList.get(0).VPM_AccntWithVendor__c == null?'' :vendorList.get(0).VPM_AccntWithVendor__c;
        maintainVendorObject.CompanyData.ClerkAtVendor = vendorList.get(0).VPM_ClerkAtVendor__c == null?'' :vendorList.get(0).VPM_ClerkAtVendor__c;
        maintainVendorObject.CompanyData.AccountMemo = vendorList.get(0).VPM_AccountMemo__c == null?'' :vendorList.get(0).VPM_AccountMemo__c;
        maintainVendorObject.CompanyData.AccountingClerk = vendorList.get(0).VPM_AccountingClerk__c == null?'' :vendorList.get(0).VPM_AccountingClerk__c;
        maintainVendorObject.CompanyData.CashManagementGroup = vendorList.get(0).VPM_CashManagementGroup__c == null?'' :vendorList.get(0).VPM_CashManagementGroup__c;
        maintainVendorObject.CompanyData.AlternativePayee = vendorList.get(0).VPM_AlternativePayee__c == null?'' :vendorList.get(0).VPM_AlternativePayee__c;
        //maintainVendorObject.CompanyData.LastKeyDate = vendorList.get(0).VPM_LastKeyDate__c == null?'' :vendorList.get(0).VPM_LastKeyDate__c;
        maintainVendorObject.CompanyData.InterestFrequency = vendorList.get(0).VPM_InterestFrequency__c == null?'' :vendorList.get(0).VPM_InterestFrequency__c;
        //maintainVendorObject.CompanyData.LastInterestRun = vendorList.get(0).VPM_LastInterestRun__c == null?'' :vendorList.get(0).VPM_LastInterestRun__c;
        //maintainVendorObject.CompanyData.BExchangeLimit = vendorList.get(0).VPM_BExchangeLimit__c == null?'' :vendorList.get(0).VPM_BExchangeLimit__c;
        maintainVendorObject.CompanyData.ChkCashing = vendorList.get(0).VPM_ChkCashing__c == null?'' :vendorList.get(0).VPM_ChkCashing__c;
        //maintainVendorObject.CompanyData.CheckDoubleInvoices = vendorList.get(0).VPM_CheckDoubleInvoices__c == null?'' :vendorList.get(0).VPM_CheckDoubleInvoices__c;
        maintainVendorObject.CompanyData.ToleranceGroup = vendorList.get(0).VPM_ToleranceGroup__c == null?'' :vendorList.get(0).VPM_ToleranceGroup__c;
        maintainVendorObject.CompanyData.HouseBank = vendorList.get(0).VPM_HouseBank__c == null?'' :vendorList.get(0).VPM_HouseBank__c;
        //maintainVendorObject.CompanyData.IndicatorPayItemsSeparately = vendorList.get(0).VPM_IndicatorPayItemsSeparately__c == null?'' :vendorList.get(0).VPM_IndicatorPayItemsSeparately__c;
        maintainVendorObject.CompanyData.ExemptionNumber = vendorList.get(0).VPM_ExemptionNumber__c == null?'' :vendorList.get(0).VPM_ExemptionNumber__c;
        //maintainVendorObject.CompanyData.ValidUntil = vendorList.get(0).VPM_ValidUntil__c == null?'' :vendorList.get(0).VPM_ValidUntil__c;
        maintainVendorObject.CompanyData.PreviousAccountNumber = vendorList.get(0).VPM_PreviousAccountNumber__c == null?'' :vendorList.get(0).VPM_PreviousAccountNumber__c;
        maintainVendorObject.CompanyData.GroupingKey = vendorList.get(0).VPM_GroupingKey__c == null?'' :vendorList.get(0).VPM_GroupingKey__c;
        maintainVendorObject.CompanyData.PaymentMethodSupplement = vendorList.get(0).VPM_PaymentMethodSupplement__c == null?'' :vendorList.get(0).VPM_PaymentMethodSupplement__c;
        maintainVendorObject.CompanyData.WithholdingTaxCountryKey = vendorList.get(0).VPM_WithholdingTaxCountryKey__c == null?'' :vendorList.get(0).VPM_WithholdingTaxCountryKey__c;
        //maintainVendorObject.CompanyData.PmtAdviceByEDI = vendorList.get(0).VPM_PmtAdviceByEDI__c == null?'' :vendorList.get(0).VPM_PmtAdviceByEDI__c;
        maintainVendorObject.CompanyData.ClerksFax = vendorList.get(0).VPM_ClerksFax__c == null?'' :vendorList.get(0).VPM_ClerksFax__c;
        maintainVendorObject.CompanyData.ClerksInternet = vendorList.get(0).VPM_ClerksInternet__c == null?'' :vendorList.get(0).VPM_ClerksInternet__c;
        maintainVendorObject.CompanyData.AccountStatement = vendorList.get(0).VPM_AccountStatement__c == null?'' :vendorList.get(0).VPM_AccountStatement__c;
        //maintainVendorObject.CompanyData.NODELCC = vendorList.get(0).VPM_NODELCC__c == null?'' :vendorList.get(0).VPM_NODELCC__c;
        maintainVendorObject.CompanyData.AccountClerkTelephoneNumber = vendorList.get(0).VPM_AccountClerkTelephoneNumber__c == null?'' :vendorList.get(0).VPM_AccountClerkTelephoneNumber__c;
        //maintainVendorObject.CompanyData.AdoptScanDate = vendorList.get(0).VPM_AdoptScanDate__c == null?'' :vendorList.get(0).VPM_AdoptScanDate__c;
        //maintainVendorObject.CompanyData.MinorityIndicator = vendorList.get(0).VPM_MinorityIndicator__c == null?'' :vendorList.get(0).VPM_MinorityIndicator__c;
        //maintainVendorObject.CompanyData.HeadOfficeAccNo = vendorList.get(0).VPM_HeadOfficeAccNo__c == null?'' :vendorList.get(0).VPM_HeadOfficeAccNo__c;
        //maintainVendorObject.CompanyData.MGroupingKey = vendorList.get(0).VPM_MGroupingKey__c == null?'' :vendorList.get(0).VPM_MGroupingKey__c;
        //maintainVendorObject.CompanyData.PaymentTermsCreditMemoKey = vendorList.get(0).VPM_PaymentTermsCreditMemoKey__c == null?'' :vendorList.get(0).VPM_PaymentTermsCreditMemoKey__c;
        //maintainVendorObject.CompanyData.CertificationDate = vendorList.get(0).VPM_CertificationDate__c == null?'' :vendorList.get(0).VPM_CertificationDate__c;
        
        
        
        
        
        
        Dunning.DunnProcedure='0001';
        Dunning.DunningBlock='D';
        Dunning.LastDunned='2016-06-01';
        Dunning.DunningLevel='0';
        Dunning.DunRecipient='0050019408';
        Dunning.LegalDunnProc='2016-06-06';
        Dunning.DunningClerk='A8';
        
        
        WtaxType.IndicatorForWithholdingTaxType='MC';
        WtaxType.Liable = '';
        WtaxType.WithholdingTaxCode='C1';
        WtaxType.ExemptionRate ='';
        WtaxType.ExemptionFrom ='';
        WtaxType.ExemptionTo='';
        WtaxType.ExemptionCertNumber='';
        
        Function.PartnerFunction='BA';
        Function.DefaultPartner=true;
        Function.PurchasingOrgFunctionPartner='0050000129';
        
        maintainVendorObject.CompanyData.Dunning = Dunning;
        maintainVendorObject.CompanyData.WtaxType= WtaxType;
        maintainVendorObject.PurchasingData.Function = Function ;
        
        


        maintainVendorObject.PurchasingData.PurchasingOrganisation = vendorList.get(0).VPM_PurchasingOrganisation__c== null?'' :vendorList.get(0).VPM_PurchasingOrganisation__c;
        //maintainVendorObject.PurchasingData.ABCIndicator = vendorList.get(0).VPM_ABCIndicator__c;
        maintainVendorObject.PurchasingData.OrderCurrency = vendorList.get(0).VPM_OrderCurrency__c== null?'' :vendorList.get(0).VPM_OrderCurrency__c;
        maintainVendorObject.PurchasingData.SalesPerson = vendorList.get(0).VPM_SalesPerson__c== null?'' :vendorList.get(0).VPM_SalesPerson__c;
        maintainVendorObject.PurchasingData.Telephone = vendorList.get(0).VPM_Telephone__c== null?'' :vendorList.get(0).VPM_Telephone__c;
        //maintainVendorObject.PurchasingData.MinimumOrderValue = vendorList.get(0).VPM_MinimumOrderValue__c== null?'' :vendorList.get(0).VPM_MinimumOrderValue__c;
        maintainVendorObject.PurchasingData.PaymentTerms = vendorList.get(0).VPM_PaymentTerms__c== null?'' :vendorList.get(0).VPM_PaymentTerms__c;
        maintainVendorObject.PurchasingData.Incoterms1 = vendorList.get(0).VPM_Incoterms1__c== null?'' :vendorList.get(0).VPM_Incoterms1__c;
        maintainVendorObject.PurchasingData.Incoterms2 = vendorList.get(0).VPM_Incoterms2__c== null?'' :vendorList.get(0).VPM_Incoterms2__c;
        //maintainVendorObject.PurchasingData.GRbasedIV = vendorList.get(0).VPM_GRbasedIV__c== null?'' :vendorList.get(0).VPM_GRbasedIV__c;
        //maintainVendorObject.PurchasingData.OrderAcknowledgmentRequirement = vendorList.get(0).VPM_OrderAcknowledgmentRequirement__c== null?'' :vendorList.get(0).VPM_OrderAcknowledgmentRequirement__c;
        maintainVendorObject.PurchasingData.SchemaGroupVendor = vendorList.get(0).VPM_SchemaGroupVendor__c== null?'' :vendorList.get(0).VPM_SchemaGroupVendor__c;
        //maintainVendorObject.PurchasingData.AutoGenerationPOAllowed = vendorList.get(0).VPM_AutoGenerationPOAllowed__c== null?'' :vendorList.get(0).VPM_AutoGenerationPOAllowed__c;
        maintainVendorObject.PurchasingData.ModeTransportForeignTrade = vendorList.get(0).VPM_ModeTransportForeignTrade__c== null?'' :vendorList.get(0).VPM_ModeTransportForeignTrade__c;
        maintainVendorObject.PurchasingData.OfficeOfEntry = vendorList.get(0).VPM_OfficeOfEntry__c== null?'' :vendorList.get(0).VPM_OfficeOfEntry__c;
        maintainVendorObject.PurchasingData.PricingDateControl = vendorList.get(0).VPM_PricingDateControl__c== null?'' :vendorList.get(0).VPM_PricingDateControl__c;
        maintainVendorObject.PurchasingData.PurchasingGroup = vendorList.get(0).VPM_PurchasingGroup__c== null?'' :vendorList.get(0).VPM_PurchasingGroup__c;
        //maintainVendorObject.PurchasingData.AutoEvalGRSetmtDel = vendorList.get(0).VPM_AutoEvalGRSetmtDel__c== null?'' :vendorList.get(0).VPM_AutoEvalGRSetmtDel__c;
        //maintainVendorObject.PurchasingData.PlannedDeliveryTime = vendorList.get(0).VPM_PlannedDeliveryTime__c== null?'' :vendorList.get(0).VPM_PlannedDeliveryTime__c;
        //maintainVendorObject.PurchasingData.RackJobbingServiceAgreed = vendorList.get(0).VPM_RackJobbingServiceAgreed__c== null?'' :vendorList.get(0).VPM_RackJobbingServiceAgreed__c;
        //maintainVendorObject.PurchasingData.RelevantForPriceDet = vendorList.get(0).VPM_RelevantForPriceDet__c== null?'' :vendorList.get(0).VPM_RelevantForPriceDet__c;
        //maintainVendorObject.PurchasingData.GrantDiscInKind = vendorList.get(0).VPM_GrantDiscInKind__c== null?'' :vendorList.get(0).VPM_GrantDiscInKind__c;
        //maintainVendorObject.PurchasingData.DocIndexActive = vendorList.get(0).VPM_DocIndexActive__c== null?'' :vendorList.get(0).VPM_DocIndexActive__c;
        maintainVendorObject.PurchasingData.SortCriterion = vendorList.get(0).VPM_SortCriterion__c== null?'' :vendorList.get(0).VPM_SortCriterion__c;
        maintainVendorObject.PurchasingData.ConfirmationControl = vendorList.get(0).VPM_ConfirmationControl__c== null?'' :vendorList.get(0).VPM_ConfirmationControl__c;
        maintainVendorObject.PurchasingData.OrderOptimRest = vendorList.get(0).VPM_OrderOptimRest__c== null?'' :vendorList.get(0).VPM_OrderOptimRest__c;
        //maintainVendorObject.PurchasingData.AutoEvalGRSetmtRet = vendorList.get(0).VPM_AutoEvalGRSetmtRet__c== null?'' :vendorList.get(0).VPM_AutoEvalGRSetmtRet__c;
        //maintainVendorObject.PurchasingData.AccntWithVendorPO = vendorList.get(0).VPM_AccntWithVendorPO__c== null?'' :vendorList.get(0).VPM_AccntWithVendorPO__c;
        maintainVendorObject.PurchasingData.PROATControlProof = vendorList.get(0).VPM_PROATControlProof__c== null?'' :vendorList.get(0).VPM_PROATControlProof__c;
        
        
            maintainVendorObjectJSON = JSON.serialize(maintainVendorObject);
         }
         return maintainVendorObjectJSON ;
    }
}