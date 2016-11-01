/*********************************************************************************************************
Name:  VPM_SearchVendor
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  To perform search Vendor from cache, make web service callout,
          show different screen based on buisness user selected on Launch 
         screen, perform validations and save functionality.    
1. VPM_AdvancedForm

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Piyush      --              INITIAL DEVELOPMENT       Build search Vendor,web service callout
2.0 -    Ajay      29 June 2016    Menu screen development   Allow user to navigate to different screen.
3.0 -    Ajay      3rd Oct 2016    Defaul Data               Default data from custom setting and metadata.     
************************************************************************************************************/



global with sharing class VPM_SearchVendor{
    // Properties used in VF page to bind UI with Data Model
    public ApexPages.StandardController vendorReq;
    public VPM_ECCVendorSearchServiceOutput op;
    public VPM_PurchasingRequests__c vendorDetails{get;set;}
    public VPM_PurchasingRequests__c vendorQuery1{get;set;}
    
    //List variable used in Advanced Form
    public List<OptionWrapper> requestTypeList{get;set;}
    public List<string> screenVisited = new list<string>();
    public List<mdm_Vendors__c> mdmVendor {get;set;}
    public List<OptionWrapper> mdmDetailList {get;set;}
    public List <SelectOption> countryNameList{get;set;} 
    public List<string> opt{get;set;}
    public List<SelectOption> socialInsuCodeOptions{get;set;}
    public List<SelectOption> industryOptions{get;set;}
    public List<SelectOption> standardCommOptions{get;set;}
    public List<SelectOption> regStGrpOptions{get;set;}
    public List<SelectOption> recipentTypeOptions{get;set;}
    public List<SelectOption> taxJuriCodeOptions{get;set;}
    public List<SelectOption> orderOPtimRestOptions{get;set;}
    public List<SelectOption> intCalcIndicatorOptions{get;set;}
    public List<SelectOption> confirmationControlOptions{get;set;}    
    //public List<SelectOption> VendorTypeList{get;set;}    
    public List<SelectOption> cashmgmntgroup{get;set;}
    public List<SelectOption> venLanguage{get;set;} 
    public List<SelectOption> paymentTerms{get;set;}
    public List<SelectOption> paymentBlock{get;set;}
    public List<SelectOption> ssIStatusOptions{get;set;}
    public List<SelectOption> internationalVersion{get;set;}
    public List<SelectOption> groupingKey{get;set;} 
    public List<SelectOption> schemaGroupVendor{get;set;}
    public List<SelectOption> incoterms1{get;set;}
    public List<SelectOption> shippingConditionsOptions{get;set;}
    public List<SelectOption> paymentMethod{get;set;}
    public List<SelectOption> accountStatement{get;set;}
    public List<SelectOption> termsofPaymentOptions{get;set;}
    public List<SelectOption> tradePartnerType{get;set;}
    public List<string> paymentMethodDefaultValue{get;set;}
    public List<SelectOption> indicatorWithHoldingOptions{get;set;}
    public List<SelectOption> instKeyDataExchangeOptions{get;set;}    
    public List<SelectOption> standardNumber{get;set;}
    
    //string variable used in advacned form
    public string initialReordType{get;set;} 
    public string mdmVendorType{get;set;}
    public String positions {get; set;}
    public String sendWebFormLabel {get; set;}    
    public string vpmStatus{get;set;}
    public string screenType{get;set;}    
    public string street1{get; set;}
    public string taxCode{get;set;}
    public string vendorCodeInput{get;set;}
    public string vendorName{get;set;}    
    public string countryName{get;set;}
    public string incoterms2{get;set;}
    public string display{get;set;}
    public string labelText{get;set;}
    public string unblockBlockUnDeleteDelete {get;set;}   
    public string zipPostcode{get; set;}  
    public string deletionBlockFlag  {get;set;}
    public string userlang{get;set;}  
    public string pageBlockTitle{get;set;}
    //public string VendorType{get;set;}
    public string searchTerm1{get;set;}
    public string vendorBlockUnblockDelete = '';
    public string webErrorMessage{get;set;}
    public string requestType = VPM_RecordTypeHelper.CREATE;
    public string commodityAuthorizationGrp = '';
    public string commodityVendorType = '';  
    public string commodityTradePartnerType = '';    
    public string purchOrgName = '';
    public string extensionType;
    public string recordTypeId;//changes for IAVMD-1271
    
    // Id used in Advanced form
    public Id recId{get;set;}      
    
    //boolean variables used in Advacned form
    public boolean hideSearchVendor{get;set;}
    public boolean heapMessageScreen{get;set;}
    public boolean mdmBPMPIErrorMessage{get;set;}
    public boolean launchScreen{get;set;}
    public boolean commodityCBSFlag = false ;
    public boolean isU2k2{get;set;}
    public boolean isMaintain2{get;set;}
    public boolean isMaintainRecord{get;set;}
    public Boolean isRequiredField{get;set;} 
    public boolean renderBackBtn{get;set;} 
    public boolean sendWebFormScreen{get;set;}
    public boolean piVendorCreation{get;set;}
    public boolean vendorNotFound{get;set;}
    public boolean showSearchVendor{get;set;}
    Public Boolean isBlockDeleted {get;set;}
    Public Boolean isUnBlockUnDeleted {get;set;} 
    Public Boolean isIncoTerms2Required{get;set;}
    Public Boolean isInputField{get;set;}
    Public Boolean isOutputField{get;set;}
    Public Boolean isReadOnly{get;set;}      
    public boolean paymentTermScreen{get;set;}
    public boolean financialScreen{get;set;}
    public boolean generalVendorDetails{get;set;} 
    public boolean blockDelScreen{get;set;} 
    public boolean unblockUnDelScreen{get;set;}  
    public boolean bankDetailsScreen{get;set;}    
    public boolean regionalSpecificScreenCordillera{get;set;}  
    public boolean regionalSpecificScreenFusion{get;set;}  
    public boolean regionalSpecificScreenSirius{get;set;}  
    public boolean regionalSpecificScreenU2K2{get;set;}
    public boolean isButtonVisible{get;set;}  
    public boolean isBackToDetalPage{get;set;}
    public boolean isButtonVisibleSaveMenu{get;set;}
    public boolean isButtonVisibleSaveExit{get;set;}
    public boolean isExitButtonVisible{get;set;}
    public boolean goldendata2Screen{get;set;}
    public boolean goldendata2Screen2{get;set;}
    public boolean isGoldendataButtonVisible{get;set;}
    public boolean isInternationalVersionRendered{get;set;}
    public boolean isRequiredSpend{get;set;}
    public boolean isReqOrderingEmail {get;set;} //changes for IAVMD-1271    
    public boolean isInternationalVersionCollapsed{get;set;}
    public boolean isFusion{get;set;}
    public boolean isPaymentMetod1{get;set;}
    public boolean isPaymentMetod2{get;set;}
    public boolean block{get;set;} 
    public boolean delete1{get;set;}
    public boolean isTrue{get;set;}
    public static boolean checkFlag = false; // for recurrsive trigger 
    public boolean suppPosiAssQualityOut{get;set;}
    public boolean suppPosiAssQualityInp{get;set;}    
    public boolean suppAssQuestQualityOut{get;set;}
    public boolean suppAssQuestQualityInp{get;set;}
    public boolean suppAuditQualityOut{get;set;}
    public boolean suppAuditQualityInp{get;set;}
    public boolean suppAssQualitySourceOut{get;set;}
    public boolean suppAssQualitySourceInp{get;set;}
    public boolean SupplierAssessmentQuestionnaireSourOut{get;set;}
    public boolean SupplierAssessmentQuestionnaireSourInp{get;set;}
    public boolean SupplierAuditSourcingOut{get;set;}
    public boolean SupplierAuditSourcingInp{get;set;}
    public boolean SupplierPosAssurSourcingOut{get;set;}
    public boolean SupplierPosAssurSourcingInp{get;set;}
    public boolean ReasonNoFinancialCheckOut{get;set;}
    public boolean ReasonNoFinancialCheckInp{get;set;}    
    public boolean AchillesExceptionDetailsOut{get;set;}
    public boolean AchillesExceptionDetailsInp{get;set;}
    public boolean DetailofTypeCheckOut{get;set;}  
    public boolean DetailofTypeCheckIn{get;set;}
    public boolean ArchillesRegistrationCodeOut{get;set;}  
    public boolean ArchillesRegistrationCodeIn{get;set;}      
    
    //Constants Used in advanced Form 
    public static final string CREATE = 'Create';
    public static final string EXTEND = 'Extend';
    public static final string MAINTAIN = 'Maintain';
    public static final string MAINTAIN_2 = 'Maintain2';
    
    public string industryOptionsDefValue{get;set;}
    public string standardCommDefValue{get;set;}
    public string regStGrpDefValue{get;set;}
    public string recipentTypeDefValue{get;set;}
    public string taxJuriCodeDefValue{get;set;}
    public string socialInsuCodeDefValue{get;set;}
    public string orderOPtimRestDefValue{get;set;}
    public string intCalcIndicatorDefValues{get;set;}
    public string shippingConditionsDefValue{get;set;}
    public string accountingClerkDefValue{get;set;}
    public string confirmationControlDefaultValue{get;set;}
    public string vendorCashmgmntgroup{get;set;}
    public string vendorLanguage{get;set;}
    public string vendorPaymentTerms{get;set;}
    public string termsOFPayment{get;set;}
    public string vendorStandardNumber{get;set;}
    public string vendorAccountStatement{get;set;}
    public string vendorPaymentBlock{get;set;}    
    public string vendorPaymentMethod{get;set;}
    public string paymentMethodWebserviceValues{get;set;}    
    public string ssIStatusDefaultValue{get;set;}    
    public string vendorIntVersion{get;set;}
    public string indicatorWithHoldingDefValue{get;set;}
    public string instKeyDataExchangeDefValue{get;set;}
    public string vendorTradePartnerType{get;set;}
    public string vendorGroupingKey{get;set;}
    public string vendorSchemaGroupVendor{get;set;}
    public string vendorIncoterms1{get;set;}
    public string globalAuthorisationGroup {get;set;}
    public string latam;
    
    
    // Wrapper Class used to add Name and Value to Radio button on user selection   
    public class OptionWrapper{
        public String DetailOption{get;set;}
        public String UniqueId{get;set;}
        public boolean showLabel{get;set;}
        public String labelText{get;set;}        
    }
    
    // default constructor
    public VPM_SearchVendor() {}
    
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : Apex Constructor for extension class. Load Vendor Details record in "vendorDetail" property.
    Return Type  : Contructor no return type.
    ********************************************************************/
    public VPM_SearchVendor(ApexPages.StandardController controller)
    {
        system.debug('@@Constructor is called');
        vendorReq = controller;
        goldendata2Screen  = false;
        goldendata2Screen2 = false;
        pageBlockTitle = ''; 
        screenType = ''; 
        positions='Yes';
        isExitButtonVisible = false;
        isRequiredField = true;
        heapMessageScreen = false;
        isU2k2 = false;
        webErrorMessage = '';
        isButtonVisibleSaveMenu = false;
        isIncoTerms2Required = false;
        isButtonVisibleSaveExit = false;
        isGoldendataButtonVisible = false;
        isButtonVisible = false;
        bankDetailsScreen = false;
        paymentTermScreen = false;
        sendWebFormScreen =false;
        
        financialScreen = false;
        generalVendorDetails = false;
        blockDelScreen = false;
        unblockUnDelScreen = false;
        isRequiredSpend = false;
        isInternationalVersionCollapsed = true;        
        isPaymentMetod1 = false;
        isPaymentMetod2 = false;
        regionalSpecificScreenCordillera = false;
        regionalSpecificScreenFusion = false;
        regionalSpecificScreenSirius = false;
        regionalSpecificScreenU2K2 = false;
        showSearchVendor = false; 
        isBackToDetalPage = false;
        piVendorCreation = false;
        renderBackBtn = false;
        suppPosiAssQualityOut = true;
        suppPosiAssQualityInp = false;
        suppAssQuestQualityOut = true;
        suppAssQuestQualityInp = false;        
        suppAuditQualityOut = true;
        suppAuditQualityInp = false;
        suppAssQualitySourceOut = true;
        suppAssQualitySourceInp = false;
        SupplierPosAssurSourcingOut = true;
        SupplierPosAssurSourcingInp = false;
        SupplierAssessmentQuestionnaireSourOut = true;
        SupplierAssessmentQuestionnaireSourInp = false;
        SupplierAuditSourcingOut = true;
        SupplierAuditSourcingInp = false;
        ReasonNoFinancialCheckOut = true;
        ReasonNoFinancialCheckInp = false;
        AchillesExceptionDetailsOut = true;
        AchillesExceptionDetailsInp = false;
        
        sendWebFormLabel = system.label.VPM_Send_Button;
        recId = controller.getRecord().Id; 
        vendorDetails = (VPM_PurchasingRequests__c)controller.getRecord();        
        
        
        vendorQuery1 = [select Id,VPM_ConfirmationControl__c,VPM_IndicatorForWithholdingTaxType__c,VPM_InstructionKeyDataExchange__c,VPM_Industry__c, VPM_StandardCommMethod__c,VPM_Vendor_SubType__c,VPM_IsMDMPISaved__c,VPM_PaymentMethodWeb__c,VPM_SSIStatus__c, VPM_TermsOfPayment__c, VPM_ReasonForExemption__c, VPM_ToleranceGroup__c,VPM_checkForFieldUpdate__c, VPM_City__c,isMaintain2__c,VPM_DeletionBlockFlag__c,VPM_Incoterms2__c,VPM_VendordoesntExistFlag__c, VPM_TradePartnerType__c, VPM_CheckDoubleInvoices__c,VPM_VendorContactDetail__c,VPM_ReconciliationAccount__c,VPM_BankCountryKey__c, VPM_Comments__c, VPM_VendorName1__c, VPM_VendorPhone__c,
                        VPM_VendorName2__c,VPM_Name3__c,VPM_Name4__c,VPM_TaxNumber1__c,VPM_TaxNumber2__c,VPM_TaxNumber3__c,VPM_TaxNumber4__c,VPM_VATRegistrationNumber__c, VPM_RecipientType__c, VPM_RegStGrp__c,
                        VPM_ECC__c, VPM_ExtensionType__c,VPM_PaymentTerms__c,VPM_Status__c,VPM_VendorCodeLookup__c, VPM_VendorCodeLookup__r.mdm_ecc__c, VPM_VendorCodeLookup__r.mdm_Code__c,VPM_Commodity__r.Name,VPM_Commodity__r.VPM_CommodityCode__c,VPM_Commodity__r.VPM_CSBVendor__c,
                        VPM_CompanyCode__r.ECC__c,VPM_Commodity__c,VPM_Commodity__r.VPM_VendorType__c,VPM_VendorType__c, VPM_Commodity__r.VPM_AuthorisationGroup__c,VPM_GlobalAuthorisationGroup__c, VPM_Street1__c, VPM_Country__c, VPM_ZIPPostcode__c, VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,
                        VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c, VPM_PurchasingOrg__c,VPM_PurchasingOrg__r.Name, VPM_IsVendorSME__c,VPM_Fieldtype__c,
                        recordTypeId,VPM_CompanyCode__r.VPM_CompanyCode__c,VPM_CashManagementGroup__c,VPM_Language__c,VPM_AccountStatement__c,VPM_PaymentBlock__c,VPM_GroupingKey__c,VPM_SchemaGroupVendor__c,VPM_Incoterms1__c,VPM_PaymentMethod__c,
                        VPM_Regions__c,VPM_SearchTerm_1__c,VPM_ClerksInternet__c,VPM_OrderingEmailAddress__c,VPM_OrderCurrency__c,VPM_Authorization__c,VPM_TaxJurisdictionCode__c,VPM_InternationalVersion__c,VPM_StandardNumber__c,VPM_VATCountry__c,VPM_VATRegistrationNumber2__c,VPM_SortKey__c,VPM_SRVBasedVendorID__c,VPM_IsLock__c,createdbyid,VPM_PurchasingOrganisation__c,VPM_AuthorisationGroupFormula__c, VPM_VendorBlockUnblockDelete__c,
                        VPM_SupplierFinancialStabilityCheck__c,VPM_DetailsTypeCheck__c,VPM_ReasonNoFinancialCheck__c,VPM_SupplierAchillesRegistration__c,VPM_AchillesRegistrationCode__c,VPM_AchillesExceptionDetails__c,VPM_SupplierPositiveAssuranceQuality__c,VPM_SupPosAssExcepDetailsQual__c,VPM_SupplierAssessmentQuestionnaireQual__c,VPM_DetailsOfPlannedActivitiesSour__c,VPM_SupplierAuditQuality__c,VPM_DetailsOfPlannedActivitiesQual__c,
                        VPM_SupplierPositiveAssuranceSourcing__c,VPM_SupPosAssExcepDetailsSour__c,VPM_SupplierAssessmentQuestionnaireSour__c,VPM_SupplierAuditSourcing__c,VPM_OrderOptimRest__c,VPM_AccountingClerk__c,
                        VPM_Interestcalculationindicator__c,VPM_SocialInsuranceCodeSoc__c,VPM_ShippingConditions__c, VPM_CompanyCode__r.VPM_Country__c,VPM_CompanyCode__r.VPM_CountryCode__c
                        from VPM_PurchasingRequests__c where id = : recId]; 
        
        
        vendorPaymentMethod = '';     
        paymentMethod = paymentMathodMetaData(null);    
        paymentMethodWebserviceValues = vendorQuery1.VPM_PaymentMethodWeb__c;
        confirmationControlDefaultValue = vendorQuery1.VPM_ConfirmationControl__c;
        ssIStatusDefaultValue = vendorQuery1.VPM_SSIStatus__c;
        orderOPtimRestDefValue = vendorQuery1.VPM_OrderOptimRest__c;
        intCalcIndicatorDefValues = vendorQuery1.VPM_Interestcalculationindicator__c;     
        socialInsuCodeDefValue = vendorQuery1.VPM_SocialInsuranceCodeSoc__c;     
        shippingConditionsDefValue = vendorQuery1.VPM_ShippingConditions__c;
        
        regStGrpDefValue = vendorQuery1.VPM_RegStGrp__c;
        recipentTypeDefValue = vendorQuery1.VPM_RecipientType__c;
        taxJuriCodeDefValue = vendorQuery1.VPM_TaxJurisdictionCode__c;
        industryOptionsDefValue = vendorQuery1.VPM_Industry__c;
        indicatorWithHoldingDefValue = vendorQuery1.VPM_IndicatorForWithholdingTaxType__c;
        instKeyDataExchangeDefValue = vendorQuery1.VPM_InstructionKeyDataExchange__c;
    
        
        
        vendorCashmgmntgroup = vendorQuery1.VPM_CashManagementGroup__c;
        system.debug('@@ vendorQuery1.VPM_Language__c' + vendorQuery1.VPM_Language__c);
        vendorLanguage=vendorQuery1.VPM_Language__c;
        vendorAccountStatement=vendorQuery1.VPM_AccountStatement__c;
        vendorPaymentBlock = vendorQuery1.VPM_PaymentBlock__c;
        vendorGroupingKey=vendorQuery1.VPM_GroupingKey__c;
        vendorIncoterms1 = vendorQuery1.VPM_Incoterms1__c;
        vendorSchemaGroupVendor=vendorQuery1.VPM_SchemaGroupVendor__c;
        incoterms2 = vendorQuery1.VPM_Incoterms2__c;
        //modified for IAPR-600
        vendorPaymentTerms = vendorQuery1.VPM_PaymentTerms__c;
        system.debug('@@vendorQuery1.VPM_TermsOfPayment__c' + vendorQuery1.VPM_TermsOfPayment__c);
        termsOFPayment = vendorQuery1.VPM_TermsOfPayment__c;
        system.debug('@@termsOFPayment' + termsOFPayment);
        vendorStandardNumber = vendorQuery1.VPM_StandardNumber__c;
        vendorIntVersion = vendorQuery1.VPM_InternationalVersion__c;
        vendorTradePartnerType = vendorQuery1.VPM_TradePartnerType__c;
        standardCommDefValue = vendorQuery1.VPM_StandardCommMethod__c;
        searchTerm1= vendorQuery1.VPM_SearchTerm_1__c ; 
        
        // Added by Piyush - IAVMD - 10/20/2016
        if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2') {
            isU2k2 = true;
        } else {
            isU2k2 = false;
        }
        
        //Added by Epsita - IAVMD-1576
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Launch Screen'));
         
        system.debug('@@ vendorQuery1.VPM_SRVBasedVendorID__c' +vendorQuery1.VPM_SRVBasedVendorID__c);
        isTrue=true;
        
       system.debug('@@ SRV' + vendorQuery1.VPM_SRVBasedVendorID__c);
       
       vendorQuery1.VPM_SRVBasedVendorID__c = true;
       vendorQuery1.VPM_CheckDoubleInvoices__c = true; 
       
        if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
            isFusion=true;
        } else {
            isFusion=false;
        }
        
        if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera' || vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
            isInternationalVersionRendered = false;
        }else {
            isInternationalVersionRendered = true;
        }
        
        
        if(string.isNotBlank(vendorQuery1.VPM_Commodity__r.VPM_CommodityCode__c) && (vendorQuery1.VPM_Commodity__r.VPM_CommodityCode__c.startsWith('0')) ) {
            isRequiredSpend = false;            
        }else {               
            isRequiredSpend =true;             
        }
        
        String Status = vendorQuery1.VPM_Status__c== null?'': vendorQuery1.VPM_Status__c;
        isReadOnly = false;
        isInputField = false;
        isOutputField = false;
        
        if((vendorQuery1.VPM_IsLock__c ) || (Status.contains('MDM') || Status.contains('Review')) ) {
            isInputField = false;
            isOutputField = true;
        } else{ 
            isInputField = true;
            isOutputField = false; 
        }
        
            
        if(vendorQuery1.VPM_CompanyCode__r.ecc__c <> '' || vendorQuery1.VPM_CompanyCode__r.ecc__c <> null) {
            vendorDetails.VPM_ECC__c = vendorQuery1.VPM_CompanyCode__r.ecc__c;
        }
        
        
        // assigning the picklist values based on company code ECC associated to vendor request.
        mapCustomSettingRegionpicklistValues();
        
        
        if(string.isBlank(vendorIncoterms1) && vendorDetails.VPM_ECC__c <> 'U2K2') {
            isIncoTerms2Required = true;
        }
        
        this.opt=new list<string>();
        if(opt.size()>0) {
            vendorQuery1.VPM_DeletionBlockFlag__c = opt[0];
        }
        
        street1 = vendorQuery1.VPM_Street1__c;
        vendorName = vendorQuery1.VPM_VendorName1__c;
        if(string.isBlank(searchTerm1))
        searchTerm1 = string.isNotblank(vendorName) ? vendorName.left(10) : '';
        
        zipPostcode = vendorQuery1.VPM_ZIPPostcode__c;
        countryName = vendorQuery1.VPM_Country__c;
        countryNameList = getCountries();
        launchScreen = false;
       
        
        requestType = VPM_RecordTypeHelper.getLaunchScreenVariable('',vendorQuery1.RecordTypeId);
        
       
        
        initialReordType = requestType;
        vpmStatus = vendorQuery1.VPM_Status__c;
        screenType = 'Create';
        system.debug('&&&&&requestType '+requestType);
        if(string.isBlank(vendorQuery1.VPM_PaymentMethod__c) || vendorQuery1.VPM_PaymentMethod__c == '[]') {
            isPaymentMetod2 = false; 
        }else {
            isPaymentMetod2 = true; 
        }
        
        if(requestType.equalsIgnoreCase(VPM_RecordTypeHelper.CREATE)) { 
            showSearchVendor = false;
            isBackToDetalPage = true; 
            launchScreen =true;
            pageBlockTitle = '';             
            
            screenType = VPM_RecordTypeHelper.CREATE;
            
            if((vendorQuery1.VPM_VendorType__c == 'PI_Production Item Vendor_G001' || (vendorQuery1.VPM_VendorType__c == 'SCS_Supply Chain Services_G001' && (vendorQuery1.VPM_GlobalAuthorisationGroup__c.containsIgnoreCase('3PM--3Pm'))))) {            
                system.debug('@@ Coming here');
                PIBooleanFlags();                        
            }
        }
        else if(requestType.equalsIgnoreCase(VPM_RecordTypeHelper.MAINTAIN))
        {
            showSearchVendor = false;
            isBackToDetalPage = true; 
            launchScreen =true;
            pageBlockTitle = ''; 
            screenType = 'Extend';
            // screenVisited.add('Extend');
        }
        else if(requestType.equalsIgnoreCase(VPM_RecordTypeHelper.MAINTAIN) || requestType.equalsIgnoreCase(VPM_RecordTypeHelper.MAINTAIN_2))
        {   ////// Added for 591 Start ////////////
            system.debug('not calling web service');
            isMaintainRecord = true;
            showSearchVendor = false;
            launchScreen =true;
            pageBlockTitle = ''; 
            screenType = VPM_RecordTypeHelper.MAINTAIN;
            isBackToDetalPage = true; 
            system.debug('###### op '+op);
            if(vendorQuery1.isMaintain2__c) {
                requestType = VPM_RecordTypeHelper.MAINTAIN_2; // Limited no of options
                isMaintain2 =true;   
            }else {
                requestType=VPM_RecordTypeHelper.MAINTAIN;
            }
            isPaymentMetod1 = true;
            screenVisited.add('vendorList');
            
            launchScreen = true;
            screenType = VPM_RecordTypeHelper.MAINTAIN;
            system.debug('@@%%OP.Deleted' + screenType);             
        }
        else
        {
            showSearchVendor = true;
            isBackToDetalPage = true; 
            pageBlockTitle = System.label.VPM_Vendor_Match; 
            
        }
        
        setLaunchScreenText();
        
    }
    
      public pageReference vendorNameChange(){
    
        
        searchTerm1 = string.isNotBlank(vendorName) ? vendorName.left(10) : '';
        system.debug('@@ searchTerm1' + searchTerm1);
        return null;
    
    }

    
    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : Contails logic for searching vendor from "mdm_Vendors__c" object.
    Return Type  : Void
    ********************************************************************/
    public void getVendorDetailList() 
    {
       system.debug('@@getVendorDetailList is called');    
    
       ApexPages.Message msg = checkValidations();
        if(msg <> null ) {
            system.debug('Save Method inside error msg'); 
           ApexPages.addMessage(msg);
        }else {
            renderBackBtn = true;
            isExitButtonVisible = false;
            showSearchVendor  = false;
            heapMessageScreen = false;
            isBackToDetalPage = false;     
            hideSearchVendor=true;
            launchScreen =false;
            screenVisited.add('searchVendor');
            string countryNameSplitted = '';
            if(string.isNotBlank(CountryName)) {                
                List<string> s2 = CountryName.split('_',-1);
                countryNameSplitted = s2[1]; 
            }
            //labelText='Vendor List';
            // Dynamic Query builded for search vendor
            string searchQuery ='SELECT id,mdm_Postcode__c,VPM_FullDetails__c,mdm_vCodeSirius__c,mdm_vCodeCordillera__c,mdm_vCodeU2K2__c,mdm_Name2__c,mdm_Name3__c,mdm_Name4__c,mdm_TaxNumber1__c,mdm_TaxNumber2__c,mdm_TaxNumber3__c,mdm_TaxNumber4__c,mdm_VATRegNum__c, mdm_vCodeFusion__c,mdm_Name1__c,mdm_Street__c ,mdm_City__c,mdm_Country__c,mdm_ecc__c,mdm_Code__c FROM mdm_Vendors__c  WHERE ( mdm_Name1__c LIKE '+'\'%' + String.escapeSingleQuotes(vendorName) + '%\'' ;
            if(string.isNotBlank(street1) && string.isNotBlank(zipPostcode)) {
                searchQuery+=' OR mdm_Street__c LIKE '+ '\'%' + String.escapeSingleQuotes(street1) + '%\'';    
                searchQuery+=' OR mdm_Postcode__c LIKE '+ '\'%' + String.escapeSingleQuotes(zipPostcode)+ '%\')';
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\'';
            }else  if(string.isNotBlank(street1) && string.isBlank(zipPostcode)) {   
                searchQuery+=' OR mdm_Street__c LIKE '+ '\'%' + String.escapeSingleQuotes(street1) + '%\')';  
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\'';
            }else  if(string.isBlank(street1) && string.isNotBlank(zipPostcode)) {   
                searchQuery+=' OR mdm_Postcode__c LIKE '+ '\'%' + String.escapeSingleQuotes(zipPostcode)+ '%\')';
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\'';
            }else  if(string.isBlank(street1) && string.isBlank(zipPostcode)) {   
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\')';
            }
            searchQuery+= 'LIMIT 999';
            
            system.debug('@@mdmVendor' +searchQuery);
            mdmVendor = Database.query(searchQuery);
            system.debug('@@mdmVendor' + mdmVendor);
            
            mdmDetailList =setmdmDetailOption(mdmVendor);
            if(mdmDetailList == null || mdmDetailList.size() < 0 ) {
                hideSearchVendor = false;
                heapMessageScreen = true;                
                system.debug('@@ Please filter the search creteria');
            }
            system.debug('@@mdmDetailList' + mdmDetailList);
        }           
    }
    
       

    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 15th June 2016
    Description  : Invoke when user select vendor from search List.
    Return Type  : Void
    ********************************************************************/
     public void VendorSelected()
     {
       system.debug('@@VendorSelected is called');     
       renderBackBtn = false;
         
       //if(mdmVendor.size() > 0)
      
       isBackToDetalPage = false;  
        system.debug('^^^^^^^ '+mdmVendorType );
        pageReference pg = null;
     // Condition : When vendor is not listed then blank value is assinged to "mdmVendorType"
      system.debug('mdmVendorType showSearchVendor '+mdmVendorType +' && '+showSearchVendor);
         if(mdmVendorType == '' && !sendWebFormScreen)
      {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, System.Label.VPM_Select_Option));
      }
      else if(mdmVendorType == 'notlisted')
      {
          system.debug('###initialReordType '+initialReordType);
           
            launchScreen= false;
            hideSearchVendor =false;
            sendWebFormScreen =true;
            paymentTermScreen  = false;
            bankDetailsScreen=false;   
            showSearchVendor  = false;
            hideSearchVendor=false;
            launchScreen =false;   
            renderBackBtn = false;  
            pageBlockTitle = System.label.VPM_SendWebFormRequest;
            IF(this.positions == 'No') {
                isRequiredField = false;
                sendWebFormLabel = system.label.VPM_Next;
            }else {
                isRequiredField = true;   
                sendWebFormLabel = system.label.VPM_Send_Button;
            }
            screenVisited.add('vendorList');
            system.debug('@@screenVisited' +screenVisited);
      
          showSearchVendor  = false;
          hideSearchVendor=false;          
          requestType ='Create';
          screenType = requestType;
          updateVendorDetail(null);
          setLaunchScreenText();
          //screenVisited.add('vendorList');
         system.debug('@@renderBackBtn-' +renderBackBtn);
         system.debug('@@launchScreen' + launchScreen);  
         system.debug('@@sendWebFormScreen' + sendWebFormScreen); 
      }
          // Condition : If not blank "mdmVendorType" then it contains vendor Detail record ID
         else if(mdmVendorType !='') {
             
             system.debug('###@initialReordType '+initialReordType);
             pageBlockTitle = ''; 
             requestType = VPM_RecordTypeHelper.getLaunchScreenVariable('',vendorQuery1.RecordTypeId);
             try{
                 system.debug('@@mdmVendorType' + mdmVendorType);
                 list<string> MDMVendorInfo =mdmVendorType.split('\\\\#',-2);
                 system.debug('@@mdmVendorType' + MDMVendorInfo );
                 if(MDMVendorInfo <> null && MDMVendorInfo.size() > 0 ) {                
                     system.debug('@@vendorDetails' +vendorDetails); 
                 }
                 system.debug('@@MDMVendorInfo[1]' + MDMVendorInfo[1]);           
                 op = FetchVendorDeatilSAPService(MDMVendorInfo[1], MDMVendorInfo[2]);
                 system.debug('@@op' + op);      
                 showSearchVendor  = false;
                 hideSearchVendor=false;  
                 
                 if(op.statusCode == '200') {
                     if(op.vendorFoundResult && op.Blocked <> null && op.Deleted <> null) 
                     {     
                         
                         if(op.companyCodeMatching )
                         {              
                             if(op.CompanyData <> null && op.CompanyData.size() > 0 ) {
                                 boolean Blocked = op.CompanyData[0].Blocked;
                                 boolean Deleted = op.CompanyData[0].Deleted; 
                                 
                                 booleanToStringMethod(Blocked,Deleted);
                                 if((Blocked && Deleted) || (Blocked && !Deleted) || (!Blocked && Deleted))
                                 {
                                     requestType = VPM_RecordTypeHelper.MAINTAIN_2; // Limited no of options
                                     isMaintain2 =true;  
                                     vendorQuery1.isMaintain2__c = true;
                                 }
                                 else{ 
                                     requestType = VPM_RecordTypeHelper.MAINTAIN;
                                     vendorQuery1.isMaintain2__c = false;
                                 }
                                 isPaymentMetod1 = true;
                                 webServiceData(op);  
                             }
                             screenVisited.add('vendorList');
                             
                             screenType = VPM_RecordTypeHelper.MAINTAIN;
                             system.debug('@@%%OP.Deleted' + screenType); 
                             //labelText='Vendor maintain launch screen';
                         }
                         else 
                         {
                             requestType = VPM_RecordTypeHelper.EXTEND; 
                             screenType = VPM_RecordTypeHelper.EXTEND; 
                             
                             system.debug('@@WS-ECC'  + op.ECC ); 
                             
                             if((MDMVendorInfo[2]).contains(vendorQuery1.VPM_CompanyCode__r.ECC__c)) {                    
                                 extensionType = VPM_RecordTypeHelper.REGIONAL_REQUEST;
                             }else {
                                 extensionType = VPM_RecordTypeHelper.GLOBAL_REQUEST;
                             }
                             webServiceData(op);  
                             screenVisited.add('vendorList');
                         }
                         system.debug('$$$$$$$$requestType '+requestType);
                         setLaunchScreenText(); 
                         //launchScreen=true;   
                         goldendata2Screen = true;    
                         pageBlockTitle = system.label.VPM_GoldenDataScreenTitle;    
                         //QueryVendorRequest();                
                     }
                 }     
                 else 
                 {            
                     vendorNotFound =true;
                     isExitButtonVisible = true;
                     webErrorMessage = op.message;
                     renderBackBtn = true;  
                     screenVisited.add('vendorList');
                     
                 }
                 // Update purchasing request record after service call.
                 system.debug('$$$$Before calling update');      
                 updateVendorDetail(MDMVendorInfo[0]);
             }
             catch(exception ex)
             {
                 system.debug('@@Exception' + ex.getCause() + ex.getLineNumber() + ex.getTypeName()+ ex.getMessage() + ex.getStackTraceString());
             }
             
         }
         else
         {
             system.debug('###!!initialReordType '+initialReordType);
             showSearchVendor  = false;
             pageBlockTitle = ''; 
             hideSearchVendor=false;
             sendWebFormScreen=false;
             launchScreen =true;
             screenVisited.add('vendorList');             
            vendorQuery1.VPM_VendorContactDetail__c=vendorDetails.VPM_VendorContactDetail__c;
            update vendorQuery1;  
            setLaunchScreenText();
         }
         
     }    
    
    
    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Invoke when user select request type.
    Return Type  : Void
    ********************************************************************/

    public pageReference processRequestType()
    {
        
      system.debug('@@processRequestType is called');  
      
      isBackToDetalPage = false;
      heapMessageScreen = false;
      
      pageReference pg;
      system.debug('@@screenVisited' +screenVisited);   
          system.debug('@@showSearchVendor' +showSearchVendor);
          system.debug('@@launchScreen' +launchScreen);
          
       if(mdmVendorType == '')
      {
         isBackToDetalPage = true; // added for IAPR- 671
         renderBackBtn = false; // added for IAPR- 671
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,System.Label.VPM_Select_Option));
      }
      else if(mdmVendorType =='EditBankDetails' || mdmVendorType =='EnterBankDetails') {         
          bankDetailsScreen=true;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;  
          pageBlockTitle = System.label.VPM_BankDetailsTitle;
          screenVisited.add('requestType');
      }
      else if(mdmVendorType =='EditGeneralVendorDetails' || mdmVendorType =='EnterGeneralVendorDet') {
          paymentTermScreen  = false;
          bankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;
          financialScreen = false;
          generalVendorDetails = true;
          
          
          pageBlockTitle = System.label.VPM_General_Vendor_Details;
          
         
          system.debug('@@@@@@@@Vendor Type '+vendorQuery1.VPM_Commodity__r.VPM_VendorType__c);
          system.debug('@@@@@@@@Vendor Type '+vendorQuery1.VPM_VendorType__c);
          screenVisited.add('requestType'); 
          
      }
      else if(mdmVendorType =='RequestVendorBlock' || mdmVendorType =='RequestVendorBlock/Delete' || mdmVendorType =='RequestVendorUnBlock/Delete') {
          paymentTermScreen  = false;
          bankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;
          financialScreen = false;
          generalVendorDetails = false;
          if(requestType.equalsIgnoreCase(VPM_RecordTypeHelper.MAINTAIN_2)) {
              unblockUnDelScreen = true;
              pageBlockTitle = System.label.VPM_UnBlockUnDeleteTitle;
          }else if (requestType.equalsIgnoreCase(VPM_RecordTypeHelper.MAINTAIN)) {
              blockDelScreen = true;
              pageBlockTitle = System.label.VPM_BlockDeleteTitle;
          }
          screenVisited.add('requestType');
      }
      else if(mdmVendorType =='EditPaymentTerms' || mdmVendorType =='EnterPaymentTerms') {
          paymentTermScreen  = true;
          bankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;
          pageBlockTitle = System.label.VPM_PaymetTermsTitle;
          screenVisited.add('requestType');
      }else if(mdmVendorType == 'PIVendorCreationPreRequisites') {
          paymentTermScreen  = false;
          bankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;
          financialScreen = false;
          generalVendorDetails = false;
          piVendorCreation = true;
          pageBlockTitle = System.label.VPM_MDMBPMVendorPreTitle;
          //PIBooleanFlags();
          screenVisited.add('requestType');
      }
      else if(mdmVendorType =='EditFinanciallySensitiveFlds' || mdmVendorType =='EnterFinanciallySensiFlds') {
          paymentTermScreen  = false;
          bankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;
          financialScreen = true;
          pageBlockTitle = System.label.VPM_FinanciallySensitiveTitle;
          screenVisited.add('requestType');
      }
      else if(mdmVendorType =='EditRegionalSpecificFlds' || mdmVendorType =='EnterRegionalSpecificFlds') {
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;
          screenVisited.add('requestType');
          if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
              regionalSpecificScreenCordillera = true;
              pageBlockTitle = System.label.VPM_Cordillera_Region_Specific;
          }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
              regionalSpecificScreenFusion = true;
              pageBlockTitle = System.label.VPM_Fusion_Region_Specific;
          }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius') {
              regionalSpecificScreenSirius = true;
              pageBlockTitle = System.label.VPM_Sirius_Regional_Specific;
          }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2') {
              regionalSpecificScreenU2K2 = true;
              pageBlockTitle = System.label.VPM_U2K2_Region_Specific;
          }
      }     
      else if(mdmVendorType =='SendResendWebform') {
          showSearchVendor = false;
          launchScreen= false;
          hideSearchVendor =false;
          sendWebFormScreen = true; 
          paymentTermScreen  = false;
          bankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          launchScreen =false;
          renderBackBtn = true;  
          IF(positions == 'Yes')
           isRequiredField = true;
           else
            isRequiredField = false;
          pageBlockTitle = System.label.VPM_SendWebFormRequest;
          screenVisited.add('requestType');
        
      } 
      else if(mdmVendorType =='SubmitVendorRequestApproval') {
          
          /*if(!vendorQuery1.VPM_IsMDMPISaved__c && requestType == 'Create' && (vendorQuery1.VPM_VendorType__c == 'PI_Production Item Vendor_G001' || (vendorQuery1.VPM_VendorType__c == 'SCS_Supply Chain Services_G001' && (vendorQuery1.VPM_GlobalAuthorisationGroup__c.containsIgnoreCase('3PM--3Pm'))))) {
              
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, System.Label.VPM_MDMBPMErrorMessage));
          }else { */
             string queryString = '&isMaintain2=' + isMaintain2;    
             VPM_PurchasingRequests__c purch = [select id,VPM_Fieldtype__c,VPM_ExtensionType__c from VPM_PurchasingRequests__c where id =:recId];
             system.debug('@@ fieldType' + purch.VPM_Fieldtype__c);
             if(requestType =='Maintain' || requestType =='Maintain2') { 
                isMaintainRecord=true;   
                 if(purch.VPM_Fieldtype__c=='Regional' || purch.VPM_Fieldtype__c==null){
             
                 if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
                      pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + recId + queryString); 
                  }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
                      pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + recId + queryString); 
                  }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius') {
                      pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + recId + queryString); 
                  }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2') {
                      pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + recId +queryString); 
                  }
           
                }else
                    pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + recId); 
                
             }else if(requestType =='Extend' && purch.VPM_ExtensionType__c =='Regional'){
             
                 if(purch.VPM_Fieldtype__c=='Regional' || purch.VPM_Fieldtype__c==null){
                      if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
                          pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + recId + queryString); 
                      }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
                          pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + recId + queryString); 
                      }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius') {
                          pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + recId + queryString); 
                      }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2') {
                          pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + recId +queryString); 
                      }
                }else
                    pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + recId);
             }else if(requestType =='Create' || (requestType =='Extend' && purch.VPM_ExtensionType__c =='Global')){
                  pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + recId); 
            }        
              pg.setRedirect(true);
        //}
     }
      else if(mdmVendorType =='ExitForm') {
          update vendorQuery1;
          pg =  new Pagereference('/' + recId); 
          pg.setRedirect(true);   
      }
      return pg;
    }

    public List<SelectOption>  getRegionSpecificCustomSettingvalues(string ecc, string pickListName, string defaultValue){
            Map<String, VPM_RegionSpecificFields__c> settingMap = new Map<String, VPM_RegionSpecificFields__c>();
            Map<String, VPM_RegionSpecificFields__c> VPM_RegionSpecificMap = VPM_RegionSpecificFields__c.getAll();
            List<String> settingList = new List<String>();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            if(string.isNotBlank(defaultValue)) {
                options.add(new SelectOption(defaultValue,defaultValue));
            }
            for(VPM_RegionSpecificFields__c region : VPM_RegionSpecificMap.values()) {
                if(region.Region__c == ecc && region.Picklist_Name__c == pickListName && region.Picklist_Values__c !=defaultValue){
                    
                    settingMap.put(region.Picklist_Values__c,region);
                }
            }
            if(settingMap <> null && settingMap.size() > 0) {
                // sorting based on values 
                settingList.addAll(settingMap.keySet());
                settingList.sort();
                system.debug('@@ settingList' + settingList);
                if(settingList <> null && settingList.size() > 0) {         
                    for (String stateName : settingList) {
                        VPM_RegionSpecificFields__c state = settingMap.get(stateName);
                        //system.debug('@@ state' + state);
                    /*if(state.Picklist_Values__c.containsIgnoreCase(vendorQuery1.VPM_PaymentTerms__c))
                    vendorPaymentTerms = state.Picklist_Values__c;*/
                        options.add(new SelectOption(state.Picklist_Values__c, state.Picklist_Values__c));
                    }
                    system.debug('@@ Options' + options);
                }
            }
            return options;
        }
    
    
    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Invoke when user select request type.
    Return Type  : Void
    ********************************************************************/
    public void updateVendorDetail(id vendorCodeLookup)
    {
      system.debug('$$$Update Called ');
       vendorQuery1.VPM_VendorCodeLookup__c = vendorCodeLookup;
       vendorQuery1.VPM_VendorName1__c = vendorName;
       vendorQuery1.VPM_Street1__c = street1;
       vendorQuery1.VPM_ZIPPostcode__c = zipPostcode;
       vendorQuery1.VPM_Country__c = CountryName;  
       vendorQuery1.VPM_City__c = vendorDetails.VPM_City__c;
       vendorQuery1.RecordTypeId = VPM_RecordTypeHelper.getRecordTypeNameById(requestType);
       vendorQuery1.VPM_ECC__c = vendorQuery1.VPM_CompanyCode__r.ECC__c;
       vendorQuery1.VPM_ExtensionType__c = extensionType;
       vendorQuery1.VPM_VendorBlockUnblockDelete__c = vendorBlockUnblockDelete;       
       system.debug('@@vendorQuery1' + vendorQuery1);
       update vendorQuery1;
    }

    /********************************************************************
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Get details of selected vendor from SAP.
    Return Type  : VPM_FetchVendorsDetails.OutputVariables
    ********************************************************************/
    public VPM_ECCVendorSearchServiceOutput FetchVendorDeatilSAPService(string MDMVendorCodeInput , string ECC)
    {
        system.debug('@@web service  is called');
        List<string> ECCList = new List<string>();
        purchOrgName = vendorQuery1.VPM_PurchasingOrg__r.Name; // added recently for passing org 
        purchOrgName = string.isNotBlank(purchOrgName) ? purchOrgName.left(4) : null; // added recently for passing org 
        system.debug('@@purchOrgName' +purchOrgName);        
        VPM_FetchVendorsDetails.InputVariables ip = new VPM_FetchVendorsDetails.InputVariables();
        List<VPM_FetchVendorsDetails.InputVariables> ipList = new List<VPM_FetchVendorsDetails.InputVariables>();
        List<VPM_ECCVendorSearchServiceOutput> opList = new List<VPM_ECCVendorSearchServiceOutput>();
        system.debug('@@MDMVendorCodeInput' +MDMVendorCodeInput);
        if(string.isNotBlank(MDMVendorCodeInput)){
        ip.vendorCodeInput = MDMVendorCodeInput;
        }else {
        ip.vendorCodeInput = vendorCodeAssignment();            
        }
        if(string.isNotblank(ECC)) {
         ECCList = ECC.split(',');            
        }
        if(!ECC.contains(vendorQuery1.VPM_CompanyCode__r.ECC__c)) {  
            ip.ecc = string.isNotBlank(ECCList[0]) ? ECCList[0] : vendorQuery1.VPM_CompanyCode__r.ECC__c;            
        }else { 
            ip.ecc = vendorQuery1.VPM_CompanyCode__r.ECC__c;
        }
        ip.compnayCode = vendorQuery1.VPM_CompanyCode__r.VPM_CompanyCode__c;
        ip.purchasingOrg = purchOrgName; // added recently for passing org 
        ipList.add(ip);
        system.debug('@@ipList' + ipList);
        opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);

        
        return opList[0];
    }

    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : This method assing value to wrapper class for displaying purpose.
    Return Type  : List of Wrapper Class
    ********************************************************************/
    public list<OptionWrapper> setmdmDetailOption(list<mdm_Vendors__c> mdmDeatilList) 
    {
      List<OptionWrapper> options = new List<OptionWrapper>(); 
      string mdmDisplayName;
      system.debug('@@mdmDeatilList size' + mdmDeatilList.size());
      system.debug('@@Heap size Limit' + Limits.getHeapSize());  
        if(mdmDeatilList.size() > 1000  || Limits.getHeapSize() > 275000) {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Please filter the search creteria Too many Vendors retrieved'));
            //system.debug('@@ Please filter the search creteria');
            options = null;
            mdmDeatilList = null;  
        }else { 
            for(mdm_Vendors__c MDMDetail : mdmDeatilList)
            {
                OptionWrapper option = new OptionWrapper();
                option.DetailOption =MDMDetail.VPM_FullDetails__c;
                option.UniqueId = MDMDetail.id+'\\#'+ vendorCodeAssignmentSearchVen(MDMDetail.mdm_vCodeSirius__c,MDMDetail.mdm_vCodeCordillera__c,MDMDetail.mdm_vCodeU2K2__c,MDMDetail.mdm_vCodeFusion__c) 
                                    +'\\#'+MDMDetail.mdm_ecc__c +'\\#'+MDMDetail.mdm_Name1__c +'\\#'+MDMDetail.mdm_Street__c + '\\#'+MDMDetail.mdm_Postcode__c + '\\#'+MDMDetail.mdm_City__c;
                /*option.UniqueId = MDMDetail.id+'\\#'+ vendorCodeAssignmentSearchVen(MDMDetail.mdm_vCodeSirius__c,MDMDetail.mdm_vCodeCordillera__c,MDMDetail.mdm_vCodeU2K2__c,MDMDetail.mdm_vCodeFusion__c) 
                                    +'\\#'+MDMDetail.mdm_ecc__c +'\\#'+MDMDetail.mdm_Name1__c +'\\#'+MDMDetail.mdm_Street__c + '\\#'+MDMDetail.mdm_Postcode__c + '\\#'+MDMDetail.mdm_City__c+
                                    '\\#'+MDMDetail.mdm_Name2__c +'\\#'+MDMDetail.mdm_Name3__c+'\\#'+MDMDetail.mdm_Name4__c+'\\#'+MDMDetail.mdm_TaxNumber1__c+'\\#'+MDMDetail.mdm_TaxNumber2__c+'\\#'+MDMDetail.mdm_TaxNumber3__c+'\\#'+MDMDetail.mdm_TaxNumber4__c+'\\#'+MDMDetail.mdm_VATRegNum__c;*/
                options.add(option); 
            }
            OptionWrapper option = new OptionWrapper();
            option.DetailOption =System.label.VPM_MyVendorisnotlisted;
            option.UniqueId = 'notlisted';
            options.add(option);                      
        }
      return options;

    }  
    
    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 15th June 2016
    Last Modify  : 16th June 2016
    Description  : This method assing value to launch screen radio btn.
    Return Type  : List of Wrapper Class
    ********************************************************************/
    public void setLaunchScreenText() 
    {
        
        system.debug('@@@ setting Launch screen options');
        String OptionWrapperJSON ='['; //
        //Added by Epsita for IAPR-1756
        if(vendorQuery1.VPM_IsLock__c ){
            system.debug('@@@ vendorQuery1.VPM_IsLock__c '+vendorQuery1.VPM_IsLock__c);
            if(vendorQuery1.VPM_Status__c.contains('Re-Work')) {
                system.debug('@@@vendorQuery1.VPM_Status__c '+vendorQuery1.VPM_Status__c);
                OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_SubmitVendorRequestforApproval + '","UniqueId":"SubmitVendorRequestApproval","showLabel":true,"labelText":"'+System.label.VPM_Quick_Submit+'"},';
            }
        }
        else{
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_SubmitVendorRequestforApproval + '","UniqueId":"SubmitVendorRequestApproval","showLabel":true,"labelText":"'+System.label.VPM_Quick_Submit+'"},';
        }
        if(requestType =='Create') {       
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterGeneralVendorDetails + '","UniqueId":"EnterGeneralVendorDet","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterBankDetails + '","UniqueId":"EnterBankDetails","showLabel":false,"labelText":""},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterPaymentTerms + '","UniqueId":"EnterPaymentTerms","showLabel":false,"labelText":""},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterFinanciallySensitiveFields + '","UniqueId":"EnterFinanciallySensiFlds","showLabel":false,"labelText":""},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterRegionalSpecificFields + '","UniqueId":"EnterRegionalSpecificFlds","showLabel":false,"labelText":""},';
            if(requestType == 'Create' && (vendorQuery1.VPM_VendorType__c == 'PI_Production Item Vendor_G001' || (vendorQuery1.VPM_VendorType__c == 'SCS_Supply Chain Services_G001' && (vendorQuery1.VPM_GlobalAuthorisationGroup__c.containsIgnoreCase('3PM--3Pm'))))) {
                OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_PIVendorCreationPreRequisites + '","UniqueId":"PIVendorCreationPreRequisites","showLabel":false,"labelText":""},';        
            }
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_Send_ResendWebformRequest + '","UniqueId":"SendResendWebform","showLabel":true,"labelText":"'+System.label.VPM_Contact_Vendor+'"},';
            
        }       
        if(requestType =='Maintain' || requestType =='Extend')
        {
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_General_Vendor_Details+'","UniqueId":"EditGeneralVendorDetails","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditBankDetails+'","UniqueId":"EditBankDetails","showLabel":false,"labelText":""},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditPaymentTerms + '","UniqueId":"EditPaymentTerms","showLabel":false,"labelText":""},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditFinanciallySensitiveFields + '","UniqueId":"EditFinanciallySensitiveFlds","showLabel":false,"labelText":""},';  
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditRegionalSpecificFields + '","UniqueId":"EditRegionalSpecificFlds","showLabel":false,"labelText":""},';
            
            if(requestType =='Maintain') {
                OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_RequestVendortoBlock_Delete+'","UniqueId":"RequestVendorBlock/Delete","showLabel":false,"labelText":""},';
            }
        }
        
        //Maintain 1
        else if(requestType =='Maintain2')
        {
            //OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_VendorMatch + '","UniqueId":"VendorMatch","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_RequestVendortoUnblock_Undelete + '","UniqueId":"RequestVendorUnBlock/Delete","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
            isMaintain2 = true;
        }
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_Exitthisform + '","UniqueId":"ExitForm","showLabel":true,"labelText":"'+System.label.VPM_Exit_Form+'"}]';
        requestTypeList = (List<OptionWrapper>) System.JSON.deserialize(OptionWrapperJSON, List<OptionWrapper>.class);
        mdmVendorType ='';
    }

    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 21th June 2016
    Last Modify  : 16th June 2016
    Description  : Back button functionality.
    Return Type  : Void.
    ********************************************************************/
     public void backBtnAction()
     {
         system.debug('@@backBtnAction is called'); 
         mdmVendorType = '';   // added for IAPR- 671
         //PIMethod();   
         isBackToDetalPage = false;   
         heapMessageScreen = false;   
         pageBlockTitle = '';
         isExitButtonVisible = false;   
         goldendata2Screen  = false;   
         goldendata2Screen2 = false;   
         try{
             system.debug('@@screenVisited' +screenVisited);
             string currentScreen = screenVisited[screenVisited.size() -1];
             system.debug('@@currentScreen' +currentScreen);   
             system.debug('@@showSearchVendor' +showSearchVendor);
             system.debug('@@launchScreen' +launchScreen);
             
             system.debug('@@currentScreen' +currentScreen);
             if(currentScreen == 'searchVendor')
             {      
                 showSearchVendor = true;
                 isBackToDetalPage = true; 
                 renderBackBtn = false;  
                 pageBlockTitle = System.label.VPM_Vendor_Match;     
                 launchScreen= false;
                 hideSearchVendor =false;
                 sendWebFormScreen =false;
                 screenVisited.remove(screenVisited.size() -1);
             }
             else if(currentScreen == 'vendorList')
             {      
                 showSearchVendor = false;
                 isBackToDetalPage = false;  
                 launchScreen= false;
                 pageBlockTitle = System.label.VPM_Vendor_Match;   
                 hideSearchVendor =true;
                 sendWebFormScreen =false;
                 screenVisited.remove(screenVisited.size() -1);
                 mdmVendorType='';
                 vendorNotFound =false;
                 isMaintain2 =false;                 
             }
             else if(currentScreen == 'requestType')
             {
                 showSearchVendor = false;
                 launchScreen= true;
                 piVendorCreation = false;  
                 renderBackBtn = false;
                 isBackToDetalPage = true;
                 hideSearchVendor =false;
                 sendWebFormScreen =false;
                 
                 bankDetailsScreen = false;  
                 paymentTermScreen = false;  
                 pageBlockTitle = '';
                 regionalSpecificScreenCordillera = false;
                 regionalSpecificScreenFusion = false;
                 regionalSpecificScreenSirius = false;
                 regionalSpecificScreenU2K2 = false;
                 financialScreen = false;
                 generalVendorDetails = false;
                 blockDelScreen = false;  
                 unblockUnDelScreen = false;  
                 screenVisited.remove(screenVisited.size() -1);
             }
             else if(currentScreen == 'sendWebForm')
             {
                 showSearchVendor = false;
                 launchScreen= true;
                 hideSearchVendor =false;
                 sendWebFormScreen =false;
                 screenVisited.remove(screenVisited.size() -1); 
             }
             if(screenVisited.size() == 0) {
                 renderBackBtn = false;
                 isBackToDetalPage = true; 
             }
         } catch(exception ex){
             renderBackBtn = false;
         }
         system.debug('@@launchScreen' +launchScreen);
     }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : This method pulls country picklist values from Schema
    Return Type  : List<Selectoption>
    ********************************************************************/
     public List<SelectOption> getCountries()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
     VPM_PurchasingRequests__c.VPM_Country__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 03rd Oct  2016
    Last Modify  : 07th Oct 2016
    Description  : This method pulls default data from custom medata types
    Return Type  : List<Selectoption>
    ********************************************************************/
    public List<SelectOption> paymentMathodMetaData(string defaultValue) {
        List<SelectOption> options = new List<SelectOption>();
        List<VPM_PaymentMethods__mdt> metaValues = [select id, VPM_Country__c, VPM_CountryISO2__c, VPM_PaymentMethod__c from VPM_PaymentMethods__mdt where VPM_CountryISO2__c =: vendorQuery1.VPM_CompanyCode__r.VPM_CountryCode__c and VPM_Country__c =: vendorQuery1.VPM_CompanyCode__r.VPM_Country__c];
        
        if(string.isNotBlank(defaultValue)) 
            options.add(new SelectOption(defaultValue, defaultValue));
        
        for(VPM_PaymentMethods__mdt mdtValue : metaValues) {
            options.add(new SelectOption(mdtValue.VPM_PaymentMethod__c, mdtValue.VPM_PaymentMethod__c));    
            
        }
        system.debug('@@Options' + Options);
        
        
        return Options;
    } 
    
    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 30th June 2016
    Last Modify  : 30th June 2016
    Description  : Check email mandatory or not send web form.
    Return Type  : Void.
    ********************************************************************/
    public void  newMethod() 
    {  
        IF(positions == 'Yes')
        {
            isRequiredField = true;
            sendWebFormLabel = system.label.VPM_Send_Button;
        }else {
            isRequiredField = false;
            sendWebFormLabel = system.label.VPM_Next;
        } 
        system.debug('@@sendWebFormLabel' + sendWebFormLabel);      
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 06th June  2016
    Last Modify  : 07th Oct 2016
    Description  : This method maps the webservice values to respective SFDC fields
    Return Type  : void
    ********************************************************************/  
    public void webServiceData(VPM_ECCVendorSearchServiceOutput op){   
        system.debug('@@requestType' +requestType);
        system.debug('@@city' + op.city); 
        
        if(requestType == 'Maintain2' || requestType == 'Maintain' || screenType == 'Maintain') {
            isMaintainRecord=true;   
            if(op.CompanyData <> null && op.CompanyData.size() > 0) { 
                booleanToStringMethod(op.CompanyData[0].Blocked, op.CompanyData[0].Deleted);         
                //Company code fields
                
                vendorDetails.VPM_AlternativePayeeAccountNumber__c = (op.CompanyData[0].IndicatorAltPayeeAccountNumber <> null) ? op.CompanyData[0].IndicatorAltPayeeAccountNumber :  false;
                vendorDetails.VPM_OurAccNumWithVendor__c = op.CompanyData[0].AccountWithVendor;
                vendorPaymentTerms = string.isNotBlank(op.CompanyData[0].PaymentTerms)? op.CompanyData[0].PaymentTerms : vendorPaymentTerms;   
                system.debug('@@vendorPaymentTerms' + vendorPaymentTerms);  
                //vendorDetails.VPM_AccountingClerk__c = op.CompanyData[0].AccountingClerk; 
                accountingClerkDefValue = op.CompanyData[0].AccountingClerk; 
                vendorDetails.VPM_AccountMemo__c = op.CompanyData[0].AccountMemo;            
                vendorAccountStatement  =  string.isNotBlank(op.CompanyData[0].accountStatement) ? op.CompanyData[0].accountStatement : vendorAccountStatement;
                vendorDetails.VPM_AlternativePayee__c = op.CompanyData[0].AlternativePayee;
                vendorDetails.VPM_BExchangeLimit__c = string.isNotblank(op.CompanyData[0].BExchangeLimit) ? decimal.valueOF(op.CompanyData[0].BExchangeLimit) : 0;          
                
                vendorCashmgmntgroup = string.isNotBlank(op.CompanyData[0].CashMgmtGroup) ? op.CompanyData[0].CashMgmtGroup : vendorCashmgmntgroup;
                system.debug('@@vendorCashmgmntgroup' + vendorCashmgmntgroup);
                vendorQuery1.VPM_CheckDoubleInvoices__c = op.CompanyData[0].CheckDoubleInvoices <>null?op.CompanyData[0].CheckDoubleInvoices:false;
                vendorDetails.VPM_ChkCashing__c = op.CompanyData[0].CheckCashing;
                vendorDetails.VPM_ClerkAtVendor__c = op.CompanyData[0].ClerkAtVendor;
                vendorDetails.VPM_ClerksFax__c = op.CompanyData[0].ClerksFax;
                vendorQuery1.VPM_ClerksInternet__c = string.isNotblank(op.CompanyData[0].RemittanceEmail) ?op.CompanyData[0].RemittanceEmail:vendorQuery1.VPM_ClerksInternet__c;
                //vendorQuery1.VPM_ClerksInternet__c = null; 
                vendorDetails.VPM_ExemptionNumber__c = op.CompanyData[0].ExemptionNumber;
                vendorGroupingKey = string.isNotBlank(op.CompanyData[0].groupingKey) ? op.CompanyData[0].groupingKey : vendorGroupingKey;
                vendorDetails.VPM_HouseBank__c = op.CompanyData[0].HouseBank;
                vendorDetails.VPM_ToleranceGroup__c = op.CompanyData[0].ToleranceGroup;
                vendorDetails.VPM_ValidUntil__c = string.isNotBlank(op.CompanyData[0].ValidUntil) ? date.valueOf(op.CompanyData[0].ValidUntil) : null;
                vendorDetails.VPM_ReconciliationAccount__c = op.CompanyData[0].ReconciliationAccount;
                system.debug('@@vendorDetails.VPM_ReconciliationAccount__c' +vendorDetails.VPM_ReconciliationAccount__c);
                vendorDetails.VPM_WithholdingTaxCountryKey__c = op.CompanyData[0].WithholdingTaxCountryKey;
                //modified for IAPR-600
                
                vendorQuery1.VPM_SortKey__c = (string.isNotBlank(op.CompanyData[0].SortKey)) ? op.CompanyData[0].SortKey : vendorQuery1.VPM_SortKey__c;
                vendorDetails.VPM_IndicatorClearingBetwCustomerNVendor__c = op.CompanyData[0].IndicatorClearingBetweenCustomerAndVendor <>null?op.CompanyData[0].IndicatorClearingBetweenCustomerAndVendor:false;
                vendorDetails.VPM_IndividualPayment__c = op.CompanyData[0].IndividualPayment;
                //vendorDetails.VPM_InterestCalculationIndicator__c = op.CompanyData[0].InterestCalculationIndicator;
                intCalcIndicatorDefValues = op.CompanyData[0].InterestCalculationIndicator; 
                vendorDetails.VPM_InterestFrequency__c = op.CompanyData[0].InterestFrequency;
                vendorDetails.VPM_LastInterestRun__c = string.isNotblank(op.CompanyData[0].LastInterestRun) ? date.valueOf(op.CompanyData[0].LastInterestRun): null;
                //vendorQuery1.VPM_PaymentMethod__c = string.isNotBlank(op.CompanyData[0].paymentMethod) ?op.CompanyData[0].paymentMethod :vendorQuery1.VPM_PaymentMethod__c;
                paymentMethodWebserviceValues = string.isNotBlank(op.CompanyData[0].paymentMethod) ?op.CompanyData[0].paymentMethod :vendorQuery1.VPM_PaymentMethod__c; 
                //paymentMethodWebserviceValues = vendorPaymentMethod;
                paymentMethod = paymentMathodMetaData(null);                
                
                vendorDetails.VPM_PaymentMethodSupplement__c = op.CompanyData[0].PaymentMethodSupplement;
                vendorDetails.VPM_Authorization__c = op.CompanyData[0].Authorization;     
                
                vendorDetails.VPM_PmtAdviceByEDI__c = op.CompanyData[0].PmtAdviceByEDI;
                vendorDetails.VPM_PreviousAccountNumber__c = op.CompanyData[0].PreviousAccountNumber;
                vendorDetails.VPM_AdoptScanDate__c = op.CompanyData[0].AdoptScanDate <> null?op.CompanyData[0].AdoptScanDate :false;
                // new mapping - 
                vendorDetails.VPM_BeneficiaryAddress1__c = op.CompanyData[0].BeneficiaryAddress1;
                vendorDetails.VPM_BeneficiaryAddress2__c = op.CompanyData[0].BeneficiaryAddress2;
                vendorDetails.VPM_BeneficiaryAddress3__c = op.CompanyData[0].BeneficiaryAddress3;
                vendorDetails.VPM_BeneficiaryCountry__c = op.CompanyData[0].BeneficiaryCountry;
                vendorDetails.VPM_BeneficiaryName__c = op.CompanyData[0].BeneficiaryName;  
                vendorDetails.VPM_ThirdPartyName__c = op.CompanyData[0].ThirdPartyName;
                vendorDetails.VPM_ThirdPartyAddress1__c = op.CompanyData[0].ThirdPartyAddress1;  
                vendorDetails.VPM_ThirdPartyAddress2__c = op.CompanyData[0].ThirdPartyAddress2;
                vendorDetails.VPM_ThirdPartyAddress3__c = op.CompanyData[0].ThirdPartyAddress3;  
                vendorDetails.VPM_PaymentTermsKeyCreditMemos__c =  op.CompanyData[0].PaymentTermsCreditMemoKey;
                vendorDetails.VPM_ThirdPartyAddress4__c = op.CompanyData[0].ThirdPartyAddress4;  
                vendorDetails.VPM_FreeText1__c = op.CompanyData[0].FreeText1;
                vendorDetails.VPM_FreeText2__c = op.CompanyData[0].FreeText2;  
                vendorDetails.VPM_PayableLocation__c = op.CompanyData[0].PayableLocation;
                vendorDetails.VPM_AccountClerkTelephoneNumber__c = op.CompanyData[0].AccountClerkTelephoneNumber; 
                vendorPaymentBlock = string.isNotBlank(op.CompanyData[0].paymentBlock)? op.CompanyData[0].paymentBlock : vendorPaymentBlock;
                vendorDetails.VPM_HeadOfficeAccountNumber__c = op.CompanyData[0].HeadOfficeAccountNumber;
                //Dunning Block
                if(op.CompanyData[0].Dunning <> null && op.CompanyData[0].Dunning.size() > 0) {
                    vendorDetails.VPM_DunningBlock__c = op.CompanyData[0].Dunning[0].DunningBlock;
                    
                    vendorDetails.VPM_DunningClerk__c = op.CompanyData[0].Dunning[0].DunningClerk;
                    vendorDetails.VPM_DunningLevel__c = op.CompanyData[0].Dunning[0].DunningLevel;
                    vendorDetails.VPM_DunnRecipient__c = op.CompanyData[0].Dunning[0].DunnRecipient;
                    vendorDetails.VPM_LastDunned__c = string.isNotblank(op.CompanyData[0].Dunning[0].LastDunned) ? date.valueOf(op.CompanyData[0].Dunning[0].LastDunned) :  null;      
                }
                    //WtaxType 
                    /* commented as per Kevin's // 09/30/2016
                if(op.CompanyData[0].WtaxType <> null && op.CompanyData[0].WtaxType.size() > 0) {
                vendorDetails.VPM_ExemptionRate__c = decimal.valueOf(op.CompanyData[0].WtaxType[0].ExemptionRate);
                vendorDetails.VPM_ExemptionFrom__c = string.isNotBlank(op.CompanyData[0].WtaxType[0].ExemptionFrom) ? date.valueof(op.CompanyData[0].WtaxType[0].ExemptionFrom) : null;
                vendorDetails.VPM_ExemptionTo__c = string.isNotBlank(op.CompanyData[0].WtaxType[0].ExemptionTo) ? date.valueof(op.CompanyData[0].WtaxType[0].ExemptionTo) : null;
                vendorDetails.VPM_WithholdingTaxCode__c = op.CompanyData[0].WtaxType[0].WithholdingTaxCode;
                vendorDetails.VPM_IndicatorForWithholdingTaxType__c = op.CompanyData[0].WtaxType[0].IndicatorForWithholdingTaxType; 
                indicatorWithHoldingDefValue = op.CompanyData[0].WtaxType[0].IndicatorForWithholdingTaxType; 
                vendorQuery1.VPM_ReasonForExemption__c = op.CompanyData[0].WtaxType[0].ExemptionReason; // added recenlty 29/09/2016
                system.debug('@@vendorDetails.VPM_ReasonForExemption__c' + vendorQuery1.VPM_ReasonForExemption__c);
                vendorDetails.VPM_Liable__c = op.CompanyData[0].WtaxType[0].Liable; // added recenlty 29/09/2016  
                vendorDetails.VPM_RecipientType__c = op.CompanyData[0].WtaxType[0].TypeOfRecipient; // added recenlty 29/09/2016
                recipentTypeDefValue = op.CompanyData[0].WtaxType[0].TypeOfRecipient;
                } */
                }
            
            //purchasing org fields
            if(op.PurchasingData <> null && op.PurchasingData.size() > 0) {
                vendorDetails.VPM_SMSIndicator__c = (op.PurchasingData[0].SMSIndicator <> null ? op.PurchasingData[0].SMSIndicator : false);
                vendorDetails.VPM_AccntWithVendor__c = op.PurchasingData[0].AccountWithVendor; 
                vendorDetails.VPM_UnitOfMeasureGrp__c = op.PurchasingData[0].UnitOfMeasure;
                vendorDetails.VPM_RoundingProfile__c = op.PurchasingData[0].RoundingProfile;
                vendorDetails.VPM_RelevantForPriceDet__c = op.PurchasingData[0].RelevantForPriceDet;
                //vendorDetails.VPM_ShippingConditions__c = op.PurchasingData[0].ShippingConditions;
                shippingConditionsDefValue = op.PurchasingData[0].ShippingConditions; 
                vendorDetails.VPM_ConfirmationControl__c = op.PurchasingData[0].ConfirmationControl;
                //confirmationControlDefaultValue = vendorQuery1.VPM_ConfirmationControl__c;
                system.debug('@@vendorPaymentTerms' + op.PurchasingData[0].PaymentTerms); 
                
                termsOFPayment = string.isNotBlank(op.PurchasingData[0].PaymentTerms)? op.PurchasingData[0].PaymentTerms : termsOFPayment;   
                system.debug('@@termsOFPayment' + termsOFPayment);
                
                vendorDetails.VPM_ABCIndicator__c = op.PurchasingData[0].ABCIndicator; 
                vendorDetails.VPM_AutoEvalGRSetmtDel__c = op.PurchasingData[0].AutoEvalGRSetmtDel <> null?op.PurchasingData[0].AutoEvalGRSetmtDel:false;
                vendorDetails.VPM_AutoEvalGRSetmtRet__c = op.PurchasingData[0].AutoEvalGRSetmtRet <> null?op.PurchasingData[0].AutoEvalGRSetmtRet:false;
                vendorDetails.VPM_AutomaticPurchaseOrderGeneration__c = op.PurchasingData[0].AutoGenerationPOAllowed <> null?op.PurchasingData[0].AutoGenerationPOAllowed:false;
                vendorDetails.VPM_DocIndexActive__c = op.PurchasingData[0].DocIndexActive<>null?op.PurchasingData[0].DocIndexActive:false;
                vendorDetails.VPM_GrantDiscInKind__c = op.PurchasingData[0].GrantDiscInKind <>null?op.PurchasingData[0].GrantDiscInKind:false;
                vendorDetails.VPM_GRbasedIV__c = op.PurchasingData[0].GRbasedIV <> null?op.PurchasingData[0].GRbasedIV:false;
                vendorSchemaGroupVendor = string.isNotblank(op.PurchasingData[0].schemaGroupVendor) ? op.PurchasingData[0].schemaGroupVendor : vendorSchemaGroupVendor;
                vendorDetails.VPM_SortCriterion__c = op.PurchasingData[0].SortCriterion;
                vendorIncoterms1 = string.isNotBlank(op.PurchasingData[0].incoterms1) ? op.PurchasingData[0].incoterms1 : vendorIncoterms1;
                incoterms2 = string.isNotBlank(op.PurchasingData[0].incoterms2) ? op.PurchasingData[0].incoterms2 : incoterms2;
                vendorDetails.VPM_OrderAcknowledgmentRequirement__c = op.PurchasingData[0].OrderAcknowledgmentRequirement;
                vendorDetails.VPM_PurchasingGroup__c = op.PurchasingData[0].PurchasingGroup;
                vendorDetails.VPM_RackJobbingServiceAgreed__c = op.PurchasingData[0].RackJobbingServiceAgreed <>null?op.PurchasingData[0].RackJobbingServiceAgreed:false;
                vendorDetails.VPM_SalesPerson__c = op.PurchasingData[0].SalesPerson;
                vendorQuery1.VPM_SRVBasedVendorID__c = op.PurchasingData[0].SRVBasedVendorID <>null ?op.PurchasingData[0].SRVBasedVendorID:false;
                vendorDetails.VPM_MinimumOrderValue__c = decimal.valueOf(op.PurchasingData[0].MinimumOrderValue);
                vendorDetails.VPM_ModeTransportForeignTrade__c = op.PurchasingData[0].ModeTransportForeignTrade;
                vendorDetails.VPM_OfficeOfEntry__c = op.PurchasingData[0].OfficeOfEntry;
                vendorDetails.VPM_PricingDateControl__c = op.PurchasingData[0].PricingDateControl;
                vendorQuery1.VPM_OrderCurrency__c = string.isNotBlank(op.PurchasingData[0].OrderCurrency) ?op.PurchasingData[0].OrderCurrency : vendorQuery1.VPM_OrderCurrency__c;
                //vendorDetails.VPM_OrderOptimRest__c = op.PurchasingData[0].OrderOptimRest;
                orderOPtimRestDefValue = op.PurchasingData[0].OrderOptimRest; 
                vendorDetails.VPM_PlannedDeliveryTime__c = decimal.valueOF(op.PurchasingData[0].PlannedDeliveryTime);
                vendorDetails.VPM_PROATControlProof__c = op.PurchasingData[0].PROATControlProof;
                
                if(op.PurchasingData[0].Functions <> null && op.PurchasingData[0].Functions.size() > 0) {
                    vendorDetails.VPM_DefaultPartner__c = (op.PurchasingData[0].Functions[0].DefaultPartner <> null) ? op.PurchasingData[0].Functions[0].DefaultPartner :  false;
                    vendorDetails.VPM_PartnerFunction__c = op.PurchasingData[0].Functions[0].PartnerFunction;
                }
                
            }
            vendorDetails.VPM_TaxNumAtResponsibleTaxAuthority__c = op.TaxNumberResponsibleAuthority;
            vendorDetails.VPM_AccNumOfAlternativePayee__c = op.AccountNumberAlternativePayee; 
            vendorDetails.VPM_AccountClerkTelephoneNumber__c = op.AccountClerkTelephoneNumber;
            vendorDetails.VPM_AccountGroup__c = op.AccountGroup;
            vendorDetails.VPM_AccountingNote__c = op.AccountingNote;
            vendorDetails.VPM_AccountingText__c = op.AccountingText;
            vendorDetails.VPM_ActualQMSystem__c = op.ActualQMSystem;
            vendorDetails.VPM_AddressForm__c = op.AddressForm;
            vendorDetails.VPM_AddressTimeZone__c = op.AddressTimeZone;        
            
            
            vendorDetails.VPM_ArabiaOldNumber__c = op.ArabiaOldNumber;
            vendorDetails.VPM_ArabicVersion__c = op.ArabicVersion;
            
            
            vendorDetails.VPM_BlockFunction__c = op.BlockFunction;        
            taxJuriCodeDefValue = op.TaxJurisdictionCode;
            
            vendorDetails.VPM_CENVAT__c = op.CENVAT;
            vendorDetails.VPM_CertificateWithholdingTaxExemption__c = op.CertificateWithholdingTaxExemption;
            if(string.isNotBlank(op.CertificationDate)) {
                vendorDetails.VPM_CertificationDate__c = date.valueOF(op.CertificationDate);
            }
            vendorDetails.VPM_ChangedBy__c = op.ChangedBy;
            vendorDetails.VPM_Changedon__c = op.Changedon;
            vendorDetails.VPM_CarFreightGroup__c = op.CarFreightGroup;
            vendorDetails.VPM_Profession_c__c = op.Profession;
            vendorDetails.VPM_Commissionerate__c = op.Commissionerate;
            vendorDetails.VPM_CompanyPostCode__c = op.CompanyPostCode;
            vendorDetails.VPM_Customer__c = op.Customer;
            if(string.isNotBlank(op.DateOfBirth)) {
                vendorDetails.VPM_DateOfBirth__c = date.valueOF(op.DateOfBirth);   
            }
            vendorDetails.VPM_Department__c = op.Department;
            vendorDetails.VPM_DepartmentDescription__c = op.DepartmentDescription;
            vendorDetails.VPM_DepartmentNumber__c = op.DepartmentNumber;
            vendorDetails.VPM_Description__c = op.Description;
            
            vendorDetails.VPM_DMEIndicator__c = op.DMEIndicator;
            vendorDetails.VPM_ECC__c = op.ECC;
            vendorDetails.VPM_ECCNo__c = op.ECCNo;
            vendorDetails.VPM_Email__c = op.Email;
            vendorDetails.VPM_Email2__c = op.Email2;
            vendorDetails.VPM_Email3__c = op.Email3;
            vendorDetails.VPM_EqualisationTax__c = op.EqualisationTax <> null?op.EqualisationTax:false;
            vendorDetails.VPM_ExcIndVendor__c = op.ExcIndVendor;
            vendorDetails.VPM_ExciseDivision__c = op.ExciseDivision;
            vendorDetails.VPM_ExciseRange__c = op.ExciseRange;
            vendorDetails.VPM_ExciseRegNo__c = op.ExciseRegNo;
            vendorDetails.VPM_Extension2__c = op.Extension2;
            vendorDetails.VPM_Extension3__c = op.Extension3;
            vendorDetails.VPM_ExtensionPhone__c = op.Extension1;
            
            vendorDetails.VPM_Fax__c = op.Fax;
            vendorDetails.VPM_FaxExtension__c = op.FaxExtension;
            vendorDetails.VPM_FaxNumber2__c = op.FaxNumber2;
            vendorDetails.VPM_FaxNumber3__c = op.FaxNumber3;
            vendorDetails.VPM_FiscalAddress__c = op.FiscalAddress;
            vendorDetails.VPM_Function__c = op.Function;
            
            vendorDetails.VPM_TaxSplit__c = op.TaxSplit <>null ?op.TaxSplit:false;
            
            vendorDetails.VPM_TeleBox__c = op.TeleBox;
            //vendorDetails.VPM_Telephone__c = op.Telephone; commented as per new line items issue.
            vendorDetails.VPM_Telephone2__c = op.Telephone2;
            vendorDetails.VPM_Telephone3__c = op.Telephone3;
            vendorDetails.VPM_TextToInput__c = op.TextToInput;
            vendorDetails.VPM_ThaiOldVendorNumber__c = op.ThaiOldNumber;
            /*vendorDetails.VPM_ThirdPartyAddress1__c = op.ThirdPartyAddress1;
            vendorDetails.VPM_ThirdPartyAddress3__c = op.ThirdPartyAddress3;
            vendorDetails.VPM_ThirdPartyAddress4__c = op.ThirdPartyAddress4;
            vendorDetails.VPM_ThirdPartyName__c = op.ThirdPartyName; */
            vendorQuery1.VPM_Title__c = op.Title;        
            vendorDetails.VPM_TradingPartner__c = op.TradingPartner;
            vendorDetails.VPM_SerRegNo__c = op.SerRegNo;
            vendorDetails.VPM_ServiceAgent__c = op.ServiceAgent;
            vendorDetails.VPM_Sex__c = op.Sex;            
            //Changed by Epsita - Change in datatype of VPM_SocialInsurance__c from text to checkbox
            vendorDetails.VPM_SocialInsurance__c = (op.SocialInsurance <> null) ? op.SocialInsurance :  false ; 
            //vendorDetails.VPM_SocialInsuranceCodeSoc__c = op.SocialInsuranceCode;
            socialInsuCodeDefValue = op.SocialInsuranceCode;
            vendorDetails.VPM_TaxNumber5__c = op.TaxNumber5;
            vendorDetails.VPM_TaxOfficeIdentification__c = op.TaxOfficeIdentification;
            vendorDetails.VPM_TAXOfficeIdentLangKey__c = op.TAXOfficeIdentLangKey;
            
            //vendorDetails.VPM_StandardCommMethod__c = op.StandardCommunicationMethod;
            standardCommDefValue = op.StandardCommunicationMethod;
            
            vendorDetails.VPM_Street5__c = op.Street5;
            //Commented by Epsita for change in data types of subsequent settlement fields
            vendorDetails.VPM_SubsequentSettlement__c = (op.SubsequentSettlement <> null) ? op.SubsequentSettlement : false;
            vendorDetails.VPM_SubsequentSettlementIndex__c = (op.SubsequentSettlementIndex <>  null) ? op.SubsequentSettlementIndex : false;
            vendorDetails.VPM_TaxBase__c = op.TaxBase;
            vendorTradePartnerType = string.isNotBlank(op.TradePartnerType) ? op.TradePartnerType :vendorTradePartnerType;
            
            
            if(opt.size() > 0) {
                opt[0] = vendorQuery1.VPM_DeletionBlockFlag__c;
            }
            
            //vendorTradePartnerType ='ZVN1';
            system.debug('@@ trade partner type' + vendorQuery1.VPM_TradePartnerType__c);
            vendorDetails.VPM_TrainStation__c = op.TrainStation;
            vendorDetails.VPM_TransportZone__c = op.TransportZone;
            vendorDetails.VPM_TurkeyOldNumber__c = op.TurkeyOldNumber;
            vendorQuery1.VPM_VendorType__c = string.isNotBlank(op.TypeVendor) ? op.TypeVendor : vendorQuery1.VPM_VendorType__c;        
            vendorDetails.VPM_UkrainianVersion__c = op.UkrainianVersion;
            vendorDetails.VPM_VATRegistrationNumber2__c = op.VATRegistrationNumber2;
            //vendorDetails.VPM_VATRegistrationNumber3__c = op.VATRegistrationNumber3;
            
            if(op.VendorSubRange <> null && op.VendorSubRange.size() > 0) {
                vendorDetails.VPM_VendorSubRange__c = op.VendorSubRange[0].SubRange;
            }
            vendorDetails.VPM_OtherCommunication__c = op.OtherCommunication;
            vendorDetails.VPM_ReasonForExemption__c = op.ReasonForExemption;
            //vendorDetails.VPM_RecipientType__c = op.RecipientType;
            recipentTypeDefValue = op.RecipientType;
            vendorDetails.VPM_IndicatorPlantLevelRelevant__c = op.IndicatorPlantLevel <>null?op.IndicatorPlantLevel:false;
            vendorDetails.VPM_IndicatorSubjectToWithholdingTax__c = op.IndicatorSubjectToWithholdingTax;
            vendorDetails.VPM_IndicatorVendorSubRangeRelevant__c = op.IndicatorVendorSubRangeRelevant;
            vendorDetails.VPM_IndividualSpec__c = op.IndividualSpec;
            vendorDetails.VPM_IndonesiaOldVendorNumber__c = op.IndonesiaOldNumber;
            //vendorDetails.VPM_Industry__c = op.Industry;
            industryOptionsDefValue = op.Industry;
            vendorDetails.VPM_IndustryType__c = op.IndustryType;
            //vendorDetails.VPM_InstructionKeyDataExchange__c = op.InstructionKey;
            instKeyDataExchangeDefValue = op.InstructionKey;
            vendorIntVersion = string.isNotBlank(op.InternationalVersion)? op.InternationalVersion: vendorIntVersion;
            
            vendorDetails.VPM_IsraelOldNumber__c = op.IsraelOldNumber;
            vendorDetails.VPM_ISRNumber__c = op.ISRNumber;
            vendorLanguage = string.isNotBlank(op.Language) ? op.Language : vendorLanguage;
            //system.debug('@@vendorLanguage' +vendorLanguage);
            vendorDetails.VPM_Local2Version__c= op.Local2Version;
            if(string.isNotBlank(op.LastKeyDate)){
                vendorDetails.VPM_LastKeyDate__c = date.valueOF(op.LastKeyDate);
            }
            vendorDetails.VPM_LanguageKeyCOCode__c = op.LanguageKeyCOCode;
            vendorDetails.VPM_SalesPurchTax__c = op.SalesPurchTax <>null?op.SalesPurchTax:false;
            vendorDetails.VPM_SAPECCComments__c = op.SAPComments;
            vendorDetails.VPM_SCAC__c = op.SCAC;
            zipPostcode = string.isNotBlank(op.PostCode) ? op.PostCode:zipPostcode; 
            vendorDetails.VPM_POBoxPostCode__c = op.PostCode2; 
            //vendorDetails.VPM_RegStGrp__c = op.RegStGrp;
            regStGrpDefValue = op.RegStGrp;
            // boolean in SFDC vendorDetails.VPM_ReturnsVendor__c = op.ReturnsVendor;
            
            vendorDetails.VPM_RussianVersion__c = op.RussianVersion;
            vendorDetails.VPM_WithholdingTaxIdentificationNumber__c = op.WithholdingTaxIdentificationNumber;
            vendorDetails.VPM_QMSystemTo__c = string.isNotBlank(op.QMSystemTo) ? date.valueOF(op.QMSystemTo) : null;        
            
            vendorDetails.VPM_IndustryType__c = op.TypeOfIndustry;
            vendorDetails.VPM_POBoxCity__c = op.POBoxCity;
            vendorDetails.VPM_PODRelevant__c = op.PODRelevant;
            vendorDetails.VPM_PostalCode2__c = op.PostalCode2;
            vendorDetails.VPM_MinorityIndicators__c = op.MinorityIndicators;
            vendorDetails.VPM_MobilePhone__c = op.MobilePhone;
            vendorDetails.VPM_MobilePhone2__c = op.MobilePhone2;
            vendorDetails.VPM_MobilePhone3__c = op.MobilePhone3;    
            vendorDetails.VPM_LLDCode__c = op.LLDCode;
            vendorDetails.VPM_LSTno__c = op.LSTno;
            
            
            vendorDetails.VPM_NODEL__c = op.Nodel;
            vendorDetails.VPM_NPIVendor__c = op.NPIVendor <> null ? op.NPIVendor : false;
            vendorDetails.VPM_LastExtReview__c = string.isNotblank(op.LastExtReview) ? date.valueOf(op.LastExtReview) : null;        
            
            vendorDetails.VPM_PermittedPayee__c = op.PermittedPayee;
            vendorDetails.VPM_PlaceOfBirth__c = op.PlaceOfBirth;
            vendorDetails.VPM_OtherCommunication__c = op.OtherCommunication;
            vendorDetails.VPM_OurAccNumWithVendor__c = op.OurAccNumWithVendor;
            if(op.CIN <> null) {
                vendorDetails.VPM_PANNumber__c = op.CIN.PANNumber;
                vendorDetails.VPM_PANreference__c = op.CIN.PANreference;
                vendorDetails.VPM_CSTno__c = op.CIN.CSTno;
                vendorDetails.VPM_LSTno__c = op.CIN.LSTno;
                vendorDetails.VPM_SerRegNo__c = op.CIN.SerRegNo;
                vendorDetails.VPM_ExcIndVendor__c = op.CIN.ExcIndVendor;
                vendorDetails.VPM_ECCNo__c = op.CIN.ECCNo;
                vendorDetails.VPM_ExciseRegNo__c = op.CIN.ExciseRegNo;
                vendorDetails.VPM_ExciseRange__c = op.CIN.ExciseRange;
                vendorDetails.VPM_ExciseDivision__c = op.CIN.ExciseDivision;
                vendorDetails.VPM_Commissionerate__c = op.CIN.Commissionerate;
                vendorQuery1.VPM_SSIStatus__c = op.CIN.SSIStatus;
                ssIStatusDefaultValue = op.CIN.SSIStatus;
                vendorDetails.VPM_TypeofVendor__c = op.CIN.TypeVendor;
                vendorDetails.VPM_CENVAT__c = op.CIN.CENVAT;
                vendorDetails.VPM_Changedon__c = op.CIN.ChangedOn;
                vendorDetails.VPM_ChangedBy__c = op.CIN.ChangedBy;
            }
            
            vendorDetails.VPM_FunctionDescription__c = op.FunctionDescription;
            vendorDetails.VPM_PartnerFunctionName__c = op.PartnerFunctionName;
            vendorDetails.VPM_PartnerFunctions__c = op.PartnerFunctions;
            vendorDetails.VPM_PartnerName__c = op.PartnerName;
            vendorDetails.VPM_PartnerNumber__c = op.PartnerNumber;            
            
            //vendorQuery1.VPM_OrderingEmailAddress__c = string.isNotBlank(op.OrderingEmail) ? op.OrderingEmail:vendorQuery1.VPM_OrderingEmailAddress__c; commented as per new line item issue.
            vendorQuery1.VPM_OrderingEmailAddress__c = null;
            system.debug('@@vendorQuery1.VPM_OrderingEmailAddress__c' + vendorQuery1.VPM_OrderingEmailAddress__c);
            vendorDetails.VPM_Plant__c = op.Plant; 
            vendorDetails.VPM_RegStGrp__c = op.RegStGrp; 
            
            // Mapping custom setting values for picklist values.
            mapCustomSettingRegionpicklistValues();
            
            
        }
        vendorDetails.VPM_AccountGroup__c = op.AccountGroup;
        vendorDetails.VPM_TaxNumAtResponsibleTaxAuthority__c = op.TaxNumberResponsibleAuthority;
        vendorDetails.VPM_CorporateGrp__c = op.CorporateGrp;
        vendorDetails.VPM_Customer__c = op.Customer;
        //vendorDetails.VPM_VendorName1__c = op.VendorName1; 
        vendorName = string.isNotBlank(op.VendorName1) ? op.VendorName1 : vendorName;
        street1 = string.isNotBlank(op.street1) ? op.street1 : street1;
        searchterm1 = string.isNotBlank(op.SearchTerm1) ? op.SearchTerm1:searchterm1;
        vendorDetails.VPM_VendorCode__c = op.VendorCode;
        vendorDetails.VPM_VendorName1__c = op.VendorName1;
        vendorDetails.VPM_VendorName2__c = op.VendorName2;
        vendorDetails.VPM_purchasingOrgMatch__c = OP.purchasingOrgMatch;
        vendorDetails.VPM_companyCodeMatch__c = OP.companyCodeMatch;
        vendorDetails.VPM_Name3__c = op.VendorName3;
        vendorDetails.VPM_Name4__c = op.VendorName4;
        //vendorDetails.VPM_Name3__c = op.Name3;
        //vendorDetails.VPM_Name4__c = op.Name4;
        vendorDetails.VPM_HouseNumber__c = op.HouseNumber;
        vendorDetails.VPM_HouseNumSupplement__c = op.HouseNumSupplement;
        vendorQuery1.VPM_TaxNumber1__c = string.isNotBlank(op.TaxNumber1) ?op.TaxNumber1:vendorQuery1.VPM_TaxNumber1__c;
        vendorDetails.VPM_TaxNumber2__c = op.TaxNumber2;
        vendorDetails.VPM_TaxNumber3__c = op.TaxNumber3;
        vendorDetails.VPM_TaxNumber4__c = op.TaxNumber4;
        system.debug('@@op.City' +op.City);
        vendorDetails.VPM_City__c = op.City;
        system.debug('vendorDetails.VPM_City__c' +vendorDetails.VPM_City__c);
        string region=region();           
        system.debug('region '+region);
        vendorDetails.VPM_Regions__c = string.isNotBlank(op.Region) ?region:vendorDetails.VPM_Region__c;
        vendorDetails.VPM_District__c = op.District;
        vendorDetails.VPM_VATRegistrationNumber__c = op.VATRegistrationNumber;
        taxJuriCodeDefValue = op.TaxJurisdictionCode;
        street1 = string.isNotBlank(op.street1) ? op.street1:street1;
        vendorDetails.VPM_Street2__c = op.Street2;
        vendorDetails.VPM_Street3__c = op.Street3;
        vendorDetails.VPM_Street4__c = op.Street4;
        vendorDetails.VPM_SearchTerm2__c = op.SearchTerm2;
        vendorDetails.VPM_IntLocationNumber1__c = op.IntLocationNumber1;
        vendorDetails.VPM_IntLocationNumber2__c = op.IntLocationNumber2;
        vendorDetails.VPM_TaxNumberType__c = op.TaxNumberType;
        vendorDetails.VPM_TaxType__c = op.TaxType;
        vendorDetails.VPM_CreditInfoNumber__c = op.CreditInfoNumber;
        vendorDetails.VPM_CheckDigit__c = op.CheckDigit; // data value too large
        vendorDetails.VPM_ExternalMFG__c = op.ExternalMFG;
        vendorDetails.VPM_POBox__c = op.POBox;
        zipPostcode = string.isNotBlank(op.PostCode) ? op.PostCode:zipPostcode; 
        vendorDetails.VPM_POBoxPostCode__c = op.PostCode2; 
        VPM_SearchVendor1.CheckFlag  = true;
        
        
        //// updating for web service data for default
        updateVendorReqRecord();             
    }

    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 01st Sept 2016
    Last Modify  : 03 Oct 2016
    Description  : This method pulls the region based on vendor country and code
    Return Type  : string
    ********************************************************************/
    public string region(){
    
        try{
            VPM_Region__c region =[select VPM_Code__c,Name,id, VPM_Country__c from VPM_Region__c where VPM_Code__c=:op.region and VPM_Country__c =:CountryName limit 1];
            if(region <> null)
            return region.id;
        else
            return null;
        }
        catch(Exception ex){return null;}
            
        
    }
    
    /********************************************************************
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Get details of selected vendor from SAP.
    Return Type  : VPM_FetchVendorsDetails.OutputVariables
    ********************************************************************/
    public VPM_ECCVendorSearchServiceOutput FetchVendorDeatilSAPService(string mdmCode, string ECC, string VPMCompanyCode)
    {   
        VPM_FetchVendorsDetails.InputVariables ip = new VPM_FetchVendorsDetails.InputVariables();
        List<VPM_FetchVendorsDetails.InputVariables> ipList = new List<VPM_FetchVendorsDetails.InputVariables>();
        List<VPM_ECCVendorSearchServiceOutput> opList = new List<VPM_ECCVendorSearchServiceOutput>();
        ip.vendorCodeInput = mdmCode;
        ip.ecc = ECC;
        ip.compnayCode = VPMCompanyCode;
        ipList.add(ip);
        opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
        return opList[0];
    } 
    
    /********************************************************************
    Created By   : Piyush Mathur
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : This method saves the advanced form data
    Return Type  : void
    ********************************************************************/  
    public void SaveMethod() {  
        System.debug('Save Method');
        system.debug('vendorPaymentMethod' + vendorPaymentMethod);
        update vendorquery1;
        ApexPages.Message msg = checkValidations();
        system.debug('@@ msg' + msg);
        if(msg<> null ) {
            system.debug('Save Method inside error msg'); 
            ApexPages.addMessage(msg);
        }else {
            if(string.isBlank(vendorQuery1.VPM_PaymentMethod__c) || vendorQuery1.VPM_PaymentMethod__c == '[]') {
                isPaymentMetod2 = false; 
            }else {
                isPaymentMetod2 = true; 
            }            
            updateVendorReqRecord();
            
            /*if(sendWebFormScreen){
            screenVisited.add('requestType');
            }*/
            backBtnAction();  
        }  
        system.debug('trade partner type' +vendorQuery1.VPM_TradePartnerType__c);      
    }    
    
     
    /***********************************************************************************
    Created By   : Piyush Mathur
    Created Date : 16th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method map the custom variable to field level and perform save
    Return Type  : void
    ***********************************************************************************/
    public void updateVendorReqRecord() {
        try
        {
            system.debug('@@ updateVendorReqRecord is called');
            //added recently - 2016-10-07
            vendorQuery1.VPM_PaymentMethodWeb__c = paymentMethodWebserviceValues;
            system.debug('@@vendorQuery1.VPM_PaymentMethodWeb__c' + vendorQuery1.VPM_PaymentMethodWeb__c);
            vendorQuery1.VPM_SSIStatus__c = ssIStatusDefaultValue;
            vendorQuery1.VPM_OrderOptimRest__c = orderOPtimRestDefValue;
            vendorQuery1.VPM_Interestcalculationindicator__c = intCalcIndicatorDefValues;     
            vendorQuery1.VPM_SocialInsuranceCodeSoc__c = socialInsuCodeDefValue;     
            vendorQuery1.VPM_ShippingConditions__c = shippingConditionsDefValue;
            
            vendorQuery1.VPM_RegStGrp__c = regStGrpDefValue;
            vendorQuery1.VPM_RecipientType__c = recipentTypeDefValue;
            vendorQuery1.VPM_TaxJurisdictionCode__c = taxJuriCodeDefValue;
            
            //vendorQuery1.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
            vendorQuery1.VPM_CashManagementGroup__c= vendorCashmgmntgroup;
            system.debug('@@ vendorQuery1.VPM_Language__c' + vendorQuery1.VPM_Language__c);
            vendorQuery1.VPM_Language__c = vendorLanguage;
            vendorQuery1.VPM_AccountStatement__c = vendorAccountStatement;
            vendorQuery1.VPM_PaymentBlock__c = vendorPaymentBlock;
            vendorQuery1.VPM_GroupingKey__c = vendorGroupingKey;
            vendorQuery1.VPM_Incoterms1__c =vendorIncoterms1;
            vendorDetails.VPM_Incoterms1__c  =vendorIncoterms1;
            vendorQuery1.VPM_SchemaGroupVendor__c =vendorSchemaGroupVendor;  
            vendorQuery1.VPM_checkForFieldUpdate__c = true; 
            vendorQuery1.VPM_Street1__c = street1;
            vendorQuery1.VPM_ZIPPostcode__c = zipPostcode;
            vendorQuery1.VPM_Country__c = countryName; 
            vendorQuery1.VPM_PaymentMethod__c = (string.isNotBlank(vendorPaymentMethod) ? vendorPaymentMethod :  vendorQuery1.VPM_PaymentMethod__c);
            //VPM_SearchVendor1.checkFlag =true; 
            // 22 08 2016 : Changes By Samrin to Set VPM_VendorBlockUnblockDelete__c for the secodn time when user click on back button 
            vendorQuery1.VPM_VendorBlockUnblockDelete__c = vendorBlockUnblockDelete == null? vendorBlockUnblockDelete: vendorQuery1.VPM_VendorBlockUnblockDelete__c;
          
          
          //vendorQuery1.VPM_VendorBlockUnblockDelete__c = vendorBlockUnblockDelete;
         
            vendorQuery1.VPM_VendorName1__c = vendorName;
            vendorQuery1.VPM_SearchTerm_1__c = searchTerm1;
            vendorQuery1.VPM_Incoterms2__c = incoterms2;
            vendorQuery1.VPM_Country__c = countryName; //modified by vaishali nagar for IAPR-605
            vendorQuery1.VPM_PaymentTerms__c = vendorPaymentTerms; 
            vendorQuery1.VPM_TermsOfPayment__c = termsOFPayment;
            system.debug('@@termsOFPayment' + termsOFPayment);
            vendorQuery1.VPM_TradePartnerType__c = vendorTradePartnerType;
            vendorQuery1.VPM_InternationalVersion__c = vendorIntVersion;
            vendorQuery1.VPM_StandardNumber__c = vendorStandardNumber;
            vendorQuery1.VPM_StandardCommMethod__c = standardCommDefValue;
            vendorQuery1.VPM_Industry__c = industryOptionsDefValue;
            vendorQuery1.VPM_IndicatorForWithholdingTaxType__c = indicatorWithHoldingDefValue;
            vendorQuery1.VPM_InstructionKeyDataExchange__c = instKeyDataExchangeDefValue;
            //vendorQuery1.VPM_ConfirmationControl__c = confirmationControlDefaultValue;
             System.debug('@@@@@@  vendorQuery1 ------'+vendorQuery1);  
            if(mdmVendorType == 'PIVendorCreationPreRequisites') {
                
                vendorQuery1.VPM_IsMDMPISaved__c = true; 
            }
            
            update vendorQuery1;
          
            //update vendorQuery1.VPM_Commodity__r;
            
            system.debug('@@ options  --------'+ opt  );
               if(opt.size() > 0){
                if(opt.size()<2)
               vendorDetails.VPM_DeletionBlockFlag__c= opt[0];
               else{
                    
                    if(opt[0].contains('Unblock') || opt[0].contains('Undelete'))
                        vendorDetails.VPM_DeletionBlockFlag__c ='MDM Ops Review - Unblock - Undelete';
                    else
                        vendorDetails.VPM_DeletionBlockFlag__c ='MDM Ops Review - Block - Delete';
               }
              
             }  
                    
                
                
               // vendorDetails.VPM_DeletionBlockFlag__c= options;
               
                      
            //vendorDetails.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
            vendorDetails.RecordTypeId = VPM_RecordTypeHelper.getRecordTypeNameById(requestType);
            system.debug('@@mdmVendorType' + mdmVendorType);
            
            update vendorDetails;             
            vendorReq.save();
            if(string.isBlank(vendorQuery1.VPM_PaymentMethod__c) || vendorQuery1.VPM_PaymentMethod__c == '[]') {
                isPaymentMetod2 = false; 
            }else {
                isPaymentMetod2 = true; 
            }
            paymentMethodWebserviceValues = vendorQuery1.VPM_PaymentMethodWeb__c;
            if(requestType == 'Create') {
                isPaymentMetod1 = false;
                if((vendorQuery1.VPM_VendorType__c == 'PI_Production Item Vendor_G001' || (vendorQuery1.VPM_VendorType__c == 'SCS_Supply Chain Services_G001' && (vendorQuery1.VPM_GlobalAuthorisationGroup__c.containsIgnoreCase('3PM--3Pm'))))) {             
                    system.debug('@@ Coming here');
                    PIBooleanFlags();                        
                }
            }
            
        }
        catch(exception ex){ 
            system.debug('@@Exception- ' + ex.getstacktracestring());
            system.debug('@@Exception- ' + ex.getMessage());
        }
        
        
    }
    
    /***********************************************************************************
    Created By   : Piyush Mathur
    Created Date : 16th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method allows the Send webform screen on advanced form and perform
                   save.
    Return Type  : void
    ***********************************************************************************/
    public void SendWebformMethod() {        
        if(mdmVendorType =='SendResendWebform')  {
            pageBlockTitle = '';  
            launchScreen = true;
            isBackToDetalPage = true;            
            goldendata2Screen2 = false;
            goldendata2Screen = false;            
        } else {
            pageBlockTitle = system.label.VPM_GoldenDataScreenTitle;      
            //QueryVendorRequest(); 
            launchScreen = false;
            goldendata2Screen = true;
        }
            renderBackBtn = false;
            isExitButtonVisible = false;
            isRequiredField=true;
            isButtonVisibleSaveMenu = false;
            isButtonVisibleSaveExit = false;
            isGoldendataButtonVisible = false;
            isButtonVisible = false;
            bankDetailsScreen = false;
            paymentTermScreen = false;
            sendWebFormScreen =false;
            
            financialScreen = false;
            generalVendorDetails = false;
            blockDelScreen = false;
            unblockUnDelScreen = false;
            regionalSpecificScreenCordillera = false;
            regionalSpecificScreenFusion = false;
            regionalSpecificScreenSirius = false;
            regionalSpecificScreenU2K2 = false;
            showSearchVendor = false;
            isBackToDetalPage = false;
            //updateVendorReqRecord();
            vendorQuery1.VPM_VendordoesntExistFlag__c = positions; 
            system.debug('@@positions' +positions);
            vendorQuery1.VPM_VendorContactDetail__c = vendorDetails.VPM_VendorContactDetail__c;
            system.debug('@@vendorQuery1.VPM_VendordoesntExistFlag__c' +vendorQuery1.VPM_VendordoesntExistFlag__c);
            update vendorQuery1;
            //Changes  to avoid mulitple mail
            vendorQuery1.VPM_VendordoesntExistFlag__c ='';
            
    }
    
    /***********************************************************************************
    Created By   : Piyush Mathur
    Created Date : 16th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method perform save for Golden data Screen based on default 
                  values populated from commodity object.
    Return Type  : void
    ***********************************************************************************/
    public void GoldenDataSave() {
        system.debug('Golden Data Save method is called');  
        renderBackBtn = false;
        pageBlockTitle = system.label.VPM_GoldenDataScreenTitle;   
        launchScreen = false;        
        goldendata2Screen2 = true;
        goldendata2Screen = false;          
        isExitButtonVisible = false;
        isRequiredField=true;
        isButtonVisibleSaveMenu = false;
        isButtonVisibleSaveExit = false;
        isGoldendataButtonVisible = false;
        isButtonVisible = false;
        bankDetailsScreen = false;
        paymentTermScreen = false;
        sendWebFormScreen =false;
        
        financialScreen = false;
        generalVendorDetails = false;
        blockDelScreen = false;
        unblockUnDelScreen = false;
        regionalSpecificScreenCordillera = false;
        regionalSpecificScreenFusion = false;
        regionalSpecificScreenSirius = false;
        regionalSpecificScreenU2K2 = false;
        showSearchVendor = false;
        
        isBackToDetalPage = false;
        //vendorQuery1.VPM_Commodity__c = vendorDetails.VPM_Commodity__c;        
        vendorQuery1.VPM_TradePartnerType__c =vendortradepartnerType;
        update vendorQuery1;
        screenVisited.add('GoldenData1Screen');
        system.debug('@@vendorQuery1' +vendorQuery1);
        commodityLookupChanges();
         
    }
    
    /***********************************************************************************
    Created By   : Piyush Mathur
    Created Date : 16th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method perform check default values from Commodity object .
    Return Type  : void
    ***********************************************************************************/
    public void GoldenDataSave2() {
        system.debug('Golden Data Save method is called');
            //commodityLookupChanges();
            
            ApexPages.Message msg1 = checkValidations();
            system.debug('@@ msg' + msg1);
            if(msg1<> null ) {
             system.debug('Save Method inside error msg'); 
           ApexPages.addMessage(msg1);
            }else{
            
                pageBlockTitle = ''; 
                launchScreen = true;
                goldendata2Screen = false;
                goldendata2Screen2 = false;
                isExitButtonVisible = false;
                isRequiredField=true;
                isButtonVisibleSaveMenu = false;
                isButtonVisibleSaveExit = false;
                isGoldendataButtonVisible = false;
                isButtonVisible = false;
                bankDetailsScreen = false;
                paymentTermScreen = false;
                sendWebFormScreen =false;
                
                financialScreen = false;
                generalVendorDetails = false;
                blockDelScreen = false;
                unblockUnDelScreen = false;
                regionalSpecificScreenCordillera = false;
                regionalSpecificScreenFusion = false;
                regionalSpecificScreenSirius = false;
                regionalSpecificScreenU2K2 = false;
                showSearchVendor = false;
                isBackToDetalPage = true;
                system.debug('### requestType '+requestType );
                if((requestType != 'Create')&&(vendorQuery1.VPM_GlobalAuthorisationGroup__c.equalsIgnoreCase(commodityAuthorizationGrp) || vendorQuery1.VPM_TradePartnerType__c.equalsIgnoreCase(commodityVendorType) || vendorQuery1.VPM_VendorType__c.equalsIgnoreCase(commodityVendorType))) {
                    VPM_SearchVendor1.CheckFlag  = true;
                }else { 
                    VPM_SearchVendor1.CheckFlag  = false;                   
                }
                    system.debug('### VPM_SearchVendor1.checkFlag '+VPM_SearchVendor1.CheckFlag  );
                update vendorQuery1;
                
                if(requestType == 'Maintain' || requestType == 'Maintain2' ) {
                    isMaintainRecord = true; 
                }

                
                if(requestType == 'Create' || requestType == 'Extend') {
                    /*if(string.isNotBlank(vendorQuery1.VPM_Commodity__r.VPM_CommodityCode__c) && (vendorQuery1.VPM_Commodity__r.VPM_CommodityCode__c.startsWith('0')) && string.isNotBlank(vendorQuery1.VPM_GlobalAuthorisationGroup__c) && (vendorQuery1.VPM_GlobalAuthorisationGroup__c.contains('MBS--Other')))  
                        isReqOrderingEmail = false;
                    else
                        isReqOrderingEmail =true;    */                   
                    if(string.isNotBlank(vendorDetails.VPM_VendorContactDetail__c)){        
                        if(string.isBlank(vendorQuery1.VPM_OrderingEmailAddress__c))
                            vendorQuery1.VPM_OrderingEmailAddress__c = vendorQuery1.VPM_VendorContactDetail__c;
                            
                        if(string.isBlank(vendorQuery1.VPM_ClerksInternet__c))
                            vendorQuery1.VPM_ClerksInternet__c = vendorQuery1.VPM_VendorContactDetail__c;
                    }                    
                    if(requestType == 'Create' && (vendorQuery1.VPM_VendorType__c == 'PI_Production Item Vendor_G001' || (vendorQuery1.VPM_VendorType__c == 'SCS_Supply Chain Services_G001' && (vendorQuery1.VPM_GlobalAuthorisationGroup__c.containsIgnoreCase('3PM--3Pm'))))) {
                        PIMethod();                        
                        //PIBooleanFlags();
                    }
                    customMedataCall();
                    customMedataCallOrderCurrency();   
                    defaultPaymentTerm();
                    updateVendorReqRecord();
                 }
            }
            
    }
    
    /***********************************************************************************
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method sets the deafult values for Vendor Pre Requisties Screen.
    Return Type  : void
    ***********************************************************************************/    
    public void PIMethod() {       
            setLaunchScreenText();
            suppPosiAssQualityOut = true;
            suppPosiAssQualityInp = false;
            suppAssQuestQualityOut = true;
            suppAssQuestQualityInp = false;        
            suppAuditQualityOut = true;
            suppAuditQualityInp = false;
            suppAssQualitySourceOut = true;
            suppAssQualitySourceInp = false;
            SupplierPosAssurSourcingOut = true;
            SupplierPosAssurSourcingInp = false;
            SupplierAssessmentQuestionnaireSourOut = true;
            SupplierAssessmentQuestionnaireSourInp = false;
            SupplierAuditSourcingOut = true;
            SupplierAuditSourcingInp = false;
            ReasonNoFinancialCheckOut = true;
            ReasonNoFinancialCheckInp = false;
            AchillesExceptionDetailsOut = true;
            AchillesExceptionDetailsInp = false;
            DetailofTypeCheckOut = false;
            DetailofTypeCheckIn = true;
            ArchillesRegistrationCodeOut = false;
            ArchillesRegistrationCodeIn = true;
            system.debug('@@PIMethod called');
            vendorQuery1.VPM_SupplierFinancialStabilityCheck__c = 'Yes';
            vendorQuery1.VPM_SupplierAchillesRegistration__c = 'Yes';
            vendorQuery1.VPM_SupplierPositiveAssuranceQuality__c = 'Yes';
            vendorQuery1.VPM_SupplierAssessmentQuestionnaireQual__c = 'Yes';
            vendorQuery1.VPM_SupplierPositiveAssuranceSourcing__c = 'Yes';
            vendorQuery1.VPM_SupplierAuditQuality__c = 'Yes';
            vendorQuery1.VPM_SupplierAssessmentQuestionnaireSour__c = 'Yes';
            vendorQuery1.VPM_SupplierAuditSourcing__c = 'Yes';        
            //vendorDetails.VPM_SupplierFinancialStabilityCheck__c = 'Yes';
            //vendorDetails.VPM_SupplierAchillesRegistration__c = 'Yes';
            
            vendorQuery1.VPM_DetailsOfPlannedActivitiesQual__c = '';
            vendorQuery1.VPM_SupAudDetailsOfPlannedActivities__c = '';
            vendorQuery1.VPM_DetailsOfPlannedActivitiesSour__c   = '';
            vendorQuery1.VPM_DetailsOfPlannedActivitiesSour2__c = '';
            vendorQuery1.VPM_SupPosAssExcepDetailsQual__c = '';
            vendorQuery1.VPM_SupPosAssExcepDetailsSour__c = '';
            vendorQuery1.VPM_ReasonNoFinancialCheck__c = '';
            vendorQuery1.VPM_AchillesExceptionDetails__c = '';
            //vendorQuery1.VPM_DetailsTypeCheck__c = '';  
            //vendorQuery1.VPM_AchillesRegistrationCode__c = '';
        
    }    
        
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method sets and render input and output field based 
                   on picklist value selected.
    Return Type  : void
    ********************************************************************/
    public void PIBooleanFlags() {        
        if(vendorQuery1.VPM_SupplierFinancialStabilityCheck__c == 'No'){
            ReasonNoFinancialCheckOut = false;
            ReasonNoFinancialCheckInp = true;
            DetailofTypeCheckOut = true;
            DetailofTypeCheckIn = false;
            vendorQuery1.VPM_DetailsTypeCheck__c = '';
        }else {
            ReasonNoFinancialCheckOut = true;
            ReasonNoFinancialCheckInp = false;
            DetailofTypeCheckOut = false;
            DetailofTypeCheckIn = true;
            vendorQuery1.VPM_ReasonNoFinancialCheck__c = '';
        }
        if(vendorQuery1.VPM_SupplierAchillesRegistration__c == 'No'){
            AchillesExceptionDetailsOut = false;
            AchillesExceptionDetailsInp = true;
            ArchillesRegistrationCodeOut = true;
            ArchillesRegistrationCodeIn = false;
            vendorQuery1.VPM_AchillesRegistrationCode__c = '';
        }else {
            AchillesExceptionDetailsOut = true;
            AchillesExceptionDetailsInp = false;
            ArchillesRegistrationCodeOut = false;
            ArchillesRegistrationCodeIn = true;
            vendorQuery1.VPM_AchillesExceptionDetails__c = '';
        }
        if(vendorQuery1.VPM_SupplierPositiveAssuranceQuality__c == 'No') {
            system.debug('@@Coimh here');
            suppPosiAssQualityOut = false;
            suppPosiAssQualityInp = true;
        }else {
            suppPosiAssQualityOut = true;
            suppPosiAssQualityInp = false;
            vendorQuery1.VPM_SupPosAssExcepDetailsQual__c = '';
        }
        if(vendorQuery1.VPM_SupplierAssessmentQuestionnaireQual__c == 'No') {
            suppAssQuestQualityOut = false;
            suppAssQuestQualityInp = true;
        }else {
            suppAssQuestQualityOut = true;
            suppAssQuestQualityInp = false;
            vendorQuery1.VPM_DetailsOfPlannedActivitiesQual__c = '';
        }
        if(vendorQuery1.VPM_SupplierAuditQuality__c == 'No') {
            suppAuditQualityOut = false;
            suppAuditQualityInp = true;
        }else {
            suppAuditQualityOut = true;
            suppAuditQualityInp = false;
            vendorQuery1.VPM_SupAudDetailsOfPlannedActivities__c = '';
        }if(vendorQuery1.VPM_SupplierPositiveAssuranceSourcing__c == 'No') {
            SupplierPosAssurSourcingOut = false;
            SupplierPosAssurSourcingInp = true;
        }else {
            SupplierPosAssurSourcingOut = true;
            SupplierPosAssurSourcingInp = false;
            vendorQuery1.VPM_SupPosAssExcepDetailsSour__c = '';
        }
        if(vendorQuery1.VPM_SupplierAssessmentQuestionnaireSour__c == 'No') {
            SupplierAssessmentQuestionnaireSourOut = false;
            SupplierAssessmentQuestionnaireSourInp = true;            
        }else {
            SupplierAssessmentQuestionnaireSourOut = true;
            SupplierAssessmentQuestionnaireSourInp = false;
            vendorQuery1.VPM_DetailsOfPlannedActivitiesSour__c = '';
        }if(vendorQuery1.VPM_SupplierAuditSourcing__c == 'No') {
            SupplierAuditSourcingOut = false;
            SupplierAuditSourcingInp = true;
        }else {
            SupplierAuditSourcingOut = true;
            SupplierAuditSourcingInp = false;
            vendorQuery1.VPM_DetailsOfPlannedActivitiesSour2__c = '';
        }
        
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method is called when save and exit button is clicked
                   from advacned form and perform save and exit to detail page.
    Return Type  : void
    ********************************************************************/
    Public Pagereference SaveAndExit()
    {   
    system.debug('Save and Exit');
     //vendorQuery1.VPM_PaymentTerms__c = vendorDefaultPaymentTerm;          
     //update vendorQuery1; 
        Pagereference pg = null;
        ApexPages.Message msg = checkValidations();
        if(msg <> null) {
            ApexPages.addMessage(msg);
        }else {
                  
            updateVendorReqRecord();    
            pg =  new Pagereference('/'+recId);  
            pg.setRedirect(true);
            system.debug('@@Pg' + pg);
        }
        
        return pg;       
    }
     
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the button based on screen selected 
                   on Launch screen.
    Return Type  : boolean
    ********************************************************************/
    public boolean getButtonVisible() {
        isButtonVisible = false;
        if(bankDetailsScreen || unblockUnDelScreen || paymentTermScreen || generalVendorDetails || financialScreen  || blockDelScreen || regionalSpecificScreenSirius || regionalSpecificScreenCordillera || regionalSpecificScreenFusion || regionalSpecificScreenU2K2) {
            //if(options == null)  //this logic will remove save and return button from block/unblock Page                 
            isButtonVisible = true;                      
        }
        return isButtonVisible;
    } 
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 5th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method redirect the user to detail page of record.
    Return Type  : boolean
    ********************************************************************/
    public PageReference backToDetailPage() {
        Pagereference pg =  new Pagereference('/'+recId); 
        pg.setRedirect(true);
        return pg; 
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 5th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method assign the vendor code based on ECC
    Return Type  : boolean
    ********************************************************************/
    public string vendorCodeAssignment() {
        string vendorCodeInput = '';
        If(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius') {
            vendorCodeInput = vendorQuery1.VPM_VendorCodeLookup__r.mdm_vCodeSirius__c;
        }else If(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
            vendorCodeInput = vendorQuery1.VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c;
        } else If(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2') {
            vendorCodeInput = vendorQuery1.VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c;
        }else If(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
            vendorCodeInput = vendorQuery1.VPM_VendorCodeLookup__r.mdm_vCodeFusion__c;
        }
        system.debug('@@vendorCodeInput ' +vendorCodeInput );
        vendorCodeInput = (string.isNotBlank(vendorCodeInput) ? vendorCodeInput : '');
        return vendorCodeInput;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 5th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method assign the vendor code selected on search vendor screen
    Return Type  : boolean
    ********************************************************************/
    public string vendorCodeAssignmentSearchVen(string mdm_vCodeSirius, string mdm_vCodeCordillera ,string mdm_vCodeU2K2,string mdm_vCodeFusion) {
        string vendorCodeInput = '';
        If(string.isNotBlank(mdm_vCodeSirius)) {
            vendorCodeInput = mdm_vCodeSirius;
        }else If(string.isNotBlank(mdm_vCodeCordillera)) {
            vendorCodeInput = mdm_vCodeCordillera;
        } else If(string.isNotBlank(mdm_vCodeU2K2)) {
            vendorCodeInput = mdm_vCodeU2K2;
        }else If(string.isNotBlank(mdm_vCodeFusion)) {
            vendorCodeInput = mdm_vCodeFusion;
        }
        vendorCodeInput = (string.isNotBlank(vendorCodeInput) ? vendorCodeInput : '');
        return vendorCodeInput;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the exit button on when vendor not
                    found from web service callout.
    Return Type  : boolean
    ********************************************************************/
    public boolean getExitButtonVisible() {
        isExitButtonVisible = false;
        if(vendorNotFound) {
            isExitButtonVisible = true;
        }
        
        return isExitButtonVisible;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables Save button on indiviual screens
    Return Type  : boolean
    ********************************************************************/
    public boolean getButtonVisibleSaveMenu() {
        isButtonVisibleSaveMenu = false;        
        if(piVendorCreation || bankDetailsScreen || unblockUnDelScreen || blockDelScreen ||  paymentTermScreen || generalVendorDetails || financialScreen || regionalSpecificScreenSirius || regionalSpecificScreenCordillera || regionalSpecificScreenFusion || regionalSpecificScreenU2K2) {
            
            isButtonVisibleSaveMenu = true;                      
        }
        return isButtonVisibleSaveMenu;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the button based on screen selected 
                   on Launch screen.
    Return Type  : boolean
    ********************************************************************/
    public boolean getButtonVisibleSaveExit() {
        isButtonVisibleSaveExit = false;
        if(piVendorCreation || bankDetailsScreen || paymentTermScreen || generalVendorDetails || financialScreen  || regionalSpecificScreenSirius || regionalSpecificScreenCordillera || regionalSpecificScreenFusion || regionalSpecificScreenU2K2) {
            
            isButtonVisibleSaveExit = true;                      
        }
        return isButtonVisibleSaveExit;
    }
    
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method is called before saving and validate data entered
                   against pre defined set rules.
    Return Type  : ApexPages.Message
    ********************************************************************/
    public ApexPages.Message checkValidations() {    
        system.debug('@@ Check Validations Called');
        
        ApexPages.Message myMsg = null;
        
        
        
        if(showSearchVendor) {
            if(string.isBlank(vendorName))
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);
            /*if(string.isNotBlank(vendorName) && !vendorName.isAlphaSpace()) 
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Vendor Name : Please enter valid characters'); */
            if(string.isNotBlank(vendorName) && vendorName.length() < 3) 
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.label.VPM_VendorNameLengthPageMessage);            
        }
        
        if(generalVendorDetails && isInternationalVersionRendered) {
            if(string.isNotBlank(vendorDetails.VPM_VendorName1Int__c) || string.isNotBlank(vendorDetails.VPM_VendorName2Int__c)
             ||string.isNotBlank(vendorDetails.VPM_VendorName3Int__c) || string.isNotBlank(vendorDetails.VPM_VendorName4Int__c)
             ||string.isNotBlank(vendorDetails.VPM_Street1Int__c) || string.isNotBlank(vendorDetails.VPM_Street2Int__c)
             ||string.isNotBlank(vendorDetails.VPM_Street3Int__c) || string.isNotBlank(vendorDetails.VPM_Street4Int__c)
             ||string.isNotBlank(vendorDetails.VPM_HouseNumberInt__c) || string.isNotBlank(vendorDetails.VPM_SearchTerm1Int__c) 
             ||string.isNotBlank(vendorDetails.VPM_PostCodeInt__c) || string.isNotBlank(vendorDetails.VPM_CityInt__c)
             || string.isNotBlank(vendorDetails.VPM_CountryInt__c)) {                 
                    isInternationalVersionCollapsed = false;
                    if(string.isBlank(vendorIntVersion)){
                      myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, system.label.VPM_International1);
                }
            }            
        }
        
        if(generalVendorDetails){
           // globalAuthorisationGroup= vendorQuery1.VPM_GlobalAuthorisationGroup__c== null?'': vendorQuery1.VPM_GlobalAuthorisationGroup__c;
            if(string.isBlank(vendorName))
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);            
            if(string.isNotBlank(vendorName) && vendorName.length() < 3) 
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.label.VPM_VendorNameLengthPageMessage);  
            if(string.isBlank(CountryName)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CountryPagemessage);
            
            }if (string.isBlank(street1)) {
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_Street1PageMessage);
            }
            
            if(string.isBlank(vendorQuery1.VPM_VendorType__c)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_VendorTypeMessage);
            }
            if(string.isBlank(vendorQuery1.VPM_GlobalAuthorisationGroup__c)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_GlobalAuthorisationGrpPageMessage);
            }
            
           //modified by vaishali Nagar for IAPR-605
           VendorRequest__c obj = VendorRequest__c.getInstance('Countries');   
           system.debug('@@ LATAm Countries:' + obj);
           latam = obj.VPM_CountryName__c;
            system.debug('Vendor country' + CountryName);
            if(CountryName <> null)
            {
                if(latam.contains(CountryName) && string.isBlank(vendorQuery1.VPM_TaxNumber1__c)){
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Tax Number 1 Cannot be left blank');
                } 
                
            }
            //modified by vaishali Nagar for IAPR-605
            if(vendorQuery1.VPM_CompanyCode__r.ECC__c =='Cordillera' && string.isBlank(vendorQuery1.VPM_TaxJurisdictionCode__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Tax Jurisdiction Code Cannot be left blank');
            
            }
            //modified for IAPR-575
            else if(string.isNotBlank(vendorQuery1.VPM_VATRegistrationNumber2__c) && string.isBlank(vendorQuery1.VPM_VATCountry__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VATCountrypageMessage);  
            }
            // chnages added recently requirement modification for IAPr-575 0/19/2016
            else if(string.isNotBlank(vendorQuery1.VPM_VATCountry__c) && string.isBlank(vendorQuery1.VPM_VATRegistrationNumber2__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VATRegistartion2PageMessage);  
            }
            // start : Changes by samrin On 17 Oct 2016 --- IAVMD-1789 : Error Message on Global Auth Group Selection
            globalAuthorisationGroup= vendorQuery1.VPM_GlobalAuthorisationGroup__c== null?'': vendorQuery1.VPM_GlobalAuthorisationGroup__c;
            System.debug('globalAuthorisationGroup------'+ globalAuthorisationGroup);
            System.debug('vendorQuery1.VPM_CompanyCode__r.ECC__c------'+ vendorQuery1.VPM_CompanyCode__r.ECC__c);
            if(vendorQuery1.VPM_CompanyCode__r.ECC__c !='U2K2' && ((globalAuthorisationGroup.contains('UNICA'))))
            {
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ErrorMessageGlobalAuthGroupSelection);  
            }
             if(vendorQuery1.VPM_CompanyCode__r.ECC__c !='Fusion' && ((globalAuthorisationGroup.contains('Lakme'))))
            {
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ErrorMessageGlobalAuthGroupSelection);  
            }
            
            // End  : Changes by samrin On 17 Oct 2016 --- IAVMD-1789 : Error Message on Global Auth Group Selection
        
        }
      system.debug('@@ vendorQuery1.VPM_SRVBasedVendorID__c' +vendorQuery1.VPM_SRVBasedVendorID__c);
         
          system.debug('@@paymentTermScreen' +paymentTermScreen);
         // isTrue=vendorDetails.VPM_SRVBasedVendorID__c;
          //system.debug('@@ @@ vendorDetails.VPM_SRVBasedVendorID__c' + vendorDetails.VPM_SRVBasedVendorID__c);
        if(paymentTermScreen) {
           
              /* if(!vendorQuery1.VPM_SRVBasedVendorID__c)
                {
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_SRVBasedVendorPageMessage);
                }
                */
            
                if(vendorQuery1.VPM_ECC__c !='U2K2' && string.isNotBlank(vendorIncoterms1) && string.isBlank(incoterms2)){
                    
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_Incoterms2PageMessage);                
                
                }
                
                if(string.isBlank(vendorPaymentTerms)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentTermsPageMessage);
                }
                
                /*if(string.isBlank(vendorQuery1.VPM_OrderCurrency__c)){
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPMOrderCurrencyPageMessage);
                }*/
        }
        
        if(bankDetailsScreen){
        
            if(string.isBlank(vendorQuery1.VPM_BankCountryKey__c)){
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_BankCountryKeyPageMessage);
                
            }
        }
        if(regionalSpecificScreenCordillera || regionalSpecificScreenFusion ) {            
           /* if(!vendorDetails.VPM_CheckDoubleInvoices__c) {  
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CheckDoubleInvoicesPageMessage);
                //vendorDetails.VPM_CheckDoubleInvoices__c.addError('You must enter a value');
            }
            if(vendorQuery1.VPM_SortKey__c =='None' ||string.isBlank(vendorQuery1.VPM_SortKey__c)){
        
             
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_SortKeyPageMessage);
             
            } */
        
        }
        
        
        if(goldendata2Screen2){

        system.debug('@@ inside goldendata2Screen2');
            if(string.isBlank(vendorQuery1.VPM_VendorType__c)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_VendorTypeMessage);
            }
            
            else if(string.isNotBlank(vendorQuery1.VPM_VendorType__c)){
            
                if(string.isBlank(vendorQuery1.VPM_GlobalAuthorisationGroup__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_GlobalAuthorisationGrpPageMessage);
                }
            }
            // start : Changes by samrin On 17 Oct 2016 --- IAVMD-1789 : Error Message on Global Auth Group Selection
            globalAuthorisationGroup= vendorQuery1.VPM_GlobalAuthorisationGroup__c== null?'': vendorQuery1.VPM_GlobalAuthorisationGroup__c;
            System.debug('globalAuthorisationGroup------'+ globalAuthorisationGroup);
            System.debug('vendorQuery1.VPM_CompanyCode__r.ECC__c------'+ vendorQuery1.VPM_CompanyCode__r.ECC__c);
            if(vendorQuery1.VPM_CompanyCode__r.ECC__c !='U2K2' && ((globalAuthorisationGroup.contains('UNICA'))))
            {
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ErrorMessageGlobalAuthGroupSelection);  
            }
            if(vendorQuery1.VPM_CompanyCode__r.ECC__c !='Fusion' && ((globalAuthorisationGroup.contains('Lakme')))) 
            {
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ErrorMessageGlobalAuthGroupSelection);  
            }
            
            // End  : Changes by samrin On 17 Oct 2016 --- IAVMD-1789 : Error Message on Global Auth Group Selection
            
            if(string.isBlank(vendorTradePartnerType)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_TradePartnerTypepageMessage);
            }
        
        
        }
        if(regionalSpecificScreenSirius || regionalSpecificScreenFusion){
        
           /* if(!vendorDetails.VPM_SRVBasedVendorID__c)
                {
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_SRVBasedVendorPageMessage);
                }
        */
        }

        if(financialScreen){
        
        if((vendorQuery1.VPM_CompanyCode__r.ECC__c != 'Fusion') && (vendorCashmgmntgroup =='None' ||string.isBlank(vendorCashmgmntgroup))){
        
             system.debug('@@ cash management group');
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_CashManagementGroupPageMessage);
             
            }     
            
        if(vendorQuery1.VPM_CheckDoubleInvoices__c == null) {  
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CheckDoubleInvoicesPageMessage);
                //vendorDetails.VPM_CheckDoubleInvoices__c.addError('You must enter a value');
         }   
         
            if(string.isBlank(vendorPaymentMethod) || vendorPaymentMethod == '[]' && !isPaymentMetod2){
        
             
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentMethodPageMessage);
             
            }else if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') {
                vendorPaymentMethod = vendorPaymentMethod.removeStart('[');
                vendorPaymentMethod = vendorPaymentMethod.removeEnd(']');
                List<string> vendorPaymentMethodList  = vendorPaymentMethod.split(',');
                if(vendorPaymentMethodList <> null && vendorPaymentMethodList.size() > 0 && vendorPaymentMethodList.size() > 5)
                    myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_PaymentmethodErrorMesg);
                
            } 
         if((vendorQuery1.VPM_CompanyCode__r.ECC__c != 'Fusion') && (vendorQuery1.VPM_SortKey__c =='None' ||string.isBlank(vendorQuery1.VPM_SortKey__c))){
        
             
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_SortKeyPageMessage);
             
            } 
        }
        
        
        return myMsg;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method convert the boolean to string
    Return Type  : void
    ********************************************************************/   
     public void booleanToStringMethod(boolean blocked, boolean deleted) { 
         
         System.debug('@@@@@@@ inside booleanToStringMethod ');
         vendorBlockUnblockDelete = '';
         if(blocked && deleted) {
             vendorBlockUnblockDelete = 'Blocked' + 'Deleted';
         }else if(!blocked && deleted) {
             vendorBlockUnblockDelete = 'Deleted';
         }else if(blocked && !deleted) {
             vendorBlockUnblockDelete = 'Blocked';
         }
         System.debug('@@@@@@@ End  booleanToStringMethod ' + vendorBlockUnblockDelete);
     }
         
        /******************************************************************** 
        Created By   : Epsita 
        Created Date : 28th Sept 2016
        Last Modify  : 5th Oct 2016
        Description  : This remote action method is called on button click
                       from detail page.
        Return Type  : void
        ********************************************************************/       
      @RemoteAction
      global static map<string,string> checkForBusinessReqUser() {
          
          boolean brUser = false;
          String userRole;
          // List<PermissionSetAssignment> lstcurrentUserPerSet= new  List<PermissionSetAssignment>();
          List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() order by PermissionSet.Label DESC];
          //System.Debug('----list of permission sets assigned to logged in user------' + lstcurrentUserPerSet);
          
          // for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
          // system.debug('---------psa.PermissionSet.Label---------' + psa.PermissionSet.Label);
          if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('FLS')) {
              brUser = false;
              userRole = 'FLS';
              //return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('MDM')) {
              brUser = false;
              userRole = 'MDM';
              // return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Finance')) {
              brUser = false;
              userRole = 'FIN';
              // return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Procurement')) {
              brUser = false;
              userRole = 'PRO';
              //return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Business Requestor')) {
              brUser = true;
              userRole = 'BUR';
              // System.debug('----is user brUser----'+brUser);
              //return brUser;
          }
          // }
          map<string,string> returnResult = new map<string,string>{'brUser'=>brUser==true?'true':'false','userRole'=>userRole};
              return returnResult;
      }   
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method query commodity object and populate 
    Return Type  : boolean
    ********************************************************************/    
    public void commodityLookupChanges() { 
        
        VPM_CommodityCode__c comm = [select id ,VPM_CSBVendor__c, name,VPM_CommodityCode__c, VPM_AuthorisationGroup__c, VPM_VendorType__c from VPM_CommodityCode__c where id = : vendorQuery1.VPM_Commodity__c];
        system.debug('@@comm' + comm);
        if(string.isNotBlank(comm.VPM_CommodityCode__c) && (comm.VPM_CommodityCode__c.startsWith('0')) )
            isRequiredSpend = false;                 
        else 
            isRequiredSpend =true;   
        
        if(requestType == 'Create' || requestType == 'Extend') {
            if(string.isNotBlank(comm.VPM_CommodityCode__c) && (comm.VPM_CommodityCode__c.startsWith('0')) && string.isNotBlank(vendorQuery1.VPM_GlobalAuthorisationGroup__c) && (vendorQuery1.VPM_GlobalAuthorisationGroup__c.contains('MBS--Other')))  
                isReqOrderingEmail = false;
            else
                isReqOrderingEmail =true;     
        }
        
        commodityCBSFlag = comm.VPM_CSBVendor__c;
        
        vendorQuery1.VPM_VendorType__c = comm.VPM_VendorType__c; 
        vendorQuery1.VPM_GlobalAuthorisationGroup__c = comm.VPM_AuthorisationGroup__c;
        
        system.debug('@@vendorTradepartnerType' +vendorTradepartnerType);
        VPM_SearchVendor1.CheckFlag  = true; 
        if(string.isBlank(vendorTradepartnerType)){
            if(comm.VPM_CommodityCode__c.startsWith('0')) {
            vendorQuery1.VPM_TradePartnerType__c = 'VN_Main Vendor (VN)_ZVN1'; 
            vendorQuery1.VPM_VendorType__c = '';   
            vendorQuery1.VPM_GlobalAuthorisationGroup__c = ''; 
            }else { 
                if(vendorQuery1.VPM_CompanyCode__r.ecc__c == 'Sirius' || vendorQuery1.VPM_CompanyCode__r.ecc__c == 'U2K2' || vendorQuery1.VPM_CompanyCode__r.ecc__c == 'Fusion' )             
                    vendorQuery1.VPM_TradePartnerType__c = 'VN_Main Vendor (VN)_ZVN1';
                else if(vendorQuery1.VPM_CompanyCode__r.ecc__c == 'Cordillera' && comm.VPM_VendorType__c <> 'FRGT_Freight Vendor_G001' )
                    vendorQuery1.VPM_TradePartnerType__c = 'VN_Main Vendor (VN)_ZVN1';
                // else in all condition trade partner type will default based on Vendor request object.
            }
                 vendorTradepartnerType =  vendorQuery1.VPM_TradePartnerType__c ;   
            system.debug('@@vendorTradepartnerType' +vendorTradepartnerType);
        }
        
        vendorQuery1.VPM_TradePartnerType__c =vendorTradepartnerType;   
        
        commodityAuthorizationGrp = vendorQuery1.VPM_GlobalAuthorisationGroup__c;
        commodityVendorType = vendorQuery1.VPM_VendorType__c;
        commodityTradePartnerType = vendorQuery1.VPM_TradePartnerType__c;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the button based on screen selected 
                   on Launch screen.
    Return Type  : boolean
    ********************************************************************/
    public void customMedataCall() {
        system.debug('@@customMedataCall is called');
        string paymentMethodValue = '';
        string paymentMethodDefaultValue = '[';
        List<VPM_VendorRequestDefaultValues__mdt> vendorRequestList = [select Id, VPM_CashManagementGroup__c,VPM_CompanyCode__c,VPM_CSB__c,VPM_PaymentMethod__c,VPM_PaymentMethod1__c,
            VPM_PaymentMethod2__c,VPM_PaymentMethod3__c,VPM_PaymentMethod4__c,VPM_PaymentMethod5__c,VPM_ReconciliationAccount__c,VPM_SortKey__c,VPM_ToleranceGroup__c,VPM_VendorSubType__c,VPM_VendorType__c 
            from VPM_VendorRequestDefaultValues__mdt  where VPM_VendorType__c =: vendorQuery1.VPM_VendorType__c and VPM_VendorSubType__c =: vendorQuery1.VPM_Vendor_SubType__c and VPM_CSB__c =: commodityCBSFlag and VPM_VendorType__c =: vendorQuery1.VPM_VendorType__c and VPM_CompanyCode__c =: vendorQuery1.VPM_CompanyCode__r.VPM_CompanyCode__c];
        if(vendorRequestList <> null && vendorRequestList.size() > 0 ) {
                vendorCashmgmntgroup = vendorRequestList[0].VPM_CashManagementGroup__c;                        
                vendorDetails.VPM_ReconciliationAccount__c = vendorRequestList[0].VPM_ReconciliationAccount__c;
                vendorQuery1.VPM_SortKey__c = vendorRequestList[0].VPM_SortKey__c;
                //VendorQuery1.VPM_OrderCurrency__c = vendorRequest.VPM_OrderCurrency__c;
                if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2k2')
                    vendorDetails.VPM_ToleranceGroup__c = vendorRequestList[0].VPM_ToleranceGroup__c;
                paymentMethodValue = vendorRequestList[0].VPM_PaymentMethod1__c + ',' + vendorRequestList[0].VPM_PaymentMethod2__c + ',' + vendorRequestList[0].VPM_PaymentMethod3__c + ',' + vendorRequestList[0].VPM_PaymentMethod4__c + ',' +vendorRequestList[0].VPM_PaymentMethod5__c;
                List<string> paymentMethodValueList = paymentMethodValue.split(',');
                if(paymentMethodValueList <> null && paymentMethodValueList.size() > 0) {
                    for(string s : paymentMethodValueList) {
                        if(s <> null && s<> 'null' && s <> '' )
                            paymentMethodDefaultValue += s + ',';
                    }
                    paymentMethodDefaultValue = paymentMethodDefaultValue.removeEnd(',') + ']';
                }
            vendorQuery1.VPM_PaymentMethod__c = paymentMethodDefaultValue;
            system.debug('@@vendorQuery1.VPM_PaymentMethod__c' + paymentMethodDefaultValue);
        }
        //cashmgmntgroup = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, CASH_MGMT,vendorCashmgmntgroup);
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the button based on screen selected 
                   on Launch screen.
    Return Type  : boolean
    ********************************************************************/
    public void customMedataCallOrderCurrency() {
        system.debug('@@customMedataCallOrderCurrency is called');
        List<VPM_OrderCurrencyDefaultValues__mdt> orderCurrencyMdtList = [select id, VPM_OrderCurrency__c, VPM_VendorCountry__c from VPM_OrderCurrencyDefaultValues__mdt where VPM_VendorCountry__c =: CountryName];
        if(orderCurrencyMdtList <> null && orderCurrencyMdtList.size() > 0) {
            if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius' && purchOrgName == '2050') 
                VendorQuery1.VPM_OrderCurrency__c = '';
            else 
                VendorQuery1.VPM_OrderCurrency__c = orderCurrencyMdtList[0].VPM_OrderCurrency__c;
        }
        system.debug('@@orderCurrencyMdtList ' + orderCurrencyMdtList);
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the button based on screen selected 
                   on Launch screen.
    Return Type  : boolean
    ********************************************************************/
    public void defaultPaymentTerm() {
        if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
            if(vendorQuery1.VPM_IsVendorSME__c == 'Yes') {
                vendorPaymentTerms = '30DK_Within 30 days Due net (30NET)';
                termsOFPayment = '30DK_Within 30 days Due net (30NET)';
            }else {
                vendorPaymentTerms = '90DK_Within 90 days Due net (90NET)';
                termsOFPayment = '90DK_Within 90 days Due net (90NET)';
            }
        }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2') {
            if(vendorQuery1.VPM_IsVendorSME__c == 'Yes') {
                vendorPaymentTerms = 'P030_Within 30 days Due net (30NET)';
                termsOFPayment = 'P030_Within 30 days Due net (30NET)';
            }else {
                vendorPaymentTerms = 'S090_Within 90 days Due net (90NET)';
                termsOFPayment = 'S090_Within 90 days Due net (90NET)';
            }
        }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
            if(vendorQuery1.VPM_IsVendorSME__c == 'Yes') {
                vendorPaymentTerms = 'P030_Within 30 days Due net (30NET)';
                termsOFPayment = 'P030_Within 30 days Due net (30NET)';
            }else {
                vendorPaymentTerms = 'P090_Within 90 days Due net (90NET)';
                termsOFPayment = 'P090_Within 90 days Due net (90NET)';
            }
        }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius') {
            if(vendorQuery1.VPM_IsVendorSME__c == 'Yes') {
                vendorPaymentTerms = 'P030_Within 30 days Due net (30NET)';
                termsOFPayment = 'P030_Within 30 days Due net (30NET)';
            }else {
                vendorPaymentTerms = 'P090_Within 90 days Due net (90NET)';
                termsOFPayment = 'P090_Within 90 days Due net (90NET)';
            }
        }
        //termsofPaymentOptions = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PAYMENT_TERMS,termsOFPayment);   
        //paymentTerms = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PAYMENT_TERMS,vendorPaymentTerms);
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the button based on screen selected 
                   on Launch screen.
    Return Type  : boolean
    ********************************************************************/
    public void mapCustomSettingRegionpicklistValues() {          
        cashmgmntgroup = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.CASH_MGMT,vendorCashmgmntgroup);
        venLanguage = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.LANGUAGE, vendorLanguage);
        accountStatement = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.ACCOUNT_STAT, vendorAccountStatement);
        paymentBlock = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.PAYMEMT_BLOCK, vendorPaymentBlock);
        groupingKey  = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.GROUPING_KEY, vendorGroupingKey);
        incoterms1 = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.INCOTERMS_1, vendorIncoterms1);
        schemaGroupVendor = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.SCHEMA_GRP,vendorSchemaGroupVendor);
        //modified by vaishali nagar for IAPR-600
        paymentTerms = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.PAYMENT_TERMS,vendorPaymentTerms);
        termsofPaymentOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.PAYMENT_TERMS,termsOFPayment);        
        standardNumber= VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.STANDARD_NUMBER,vendorStandardNumber);
        internationalVersion =VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.INT_VERSION,vendorIntVersion);        
        // modified by Piyush newly added - 10/7/2016 
        socialInsuCodeOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.SOCIAL_IN_CODE_SOC,socialInsuCodeDefValue);
        orderOPtimRestOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.ORDER_OPTIM_REST,orderOPtimRestDefValue);        
        intCalcIndicatorOptions= VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, VPM_PicklistHelper.INTER_CALC_INDI,intCalcIndicatorDefValues);
        shippingConditionsOptions =VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.SHIPPING_CONDITION,shippingConditionsDefValue);
        ssIStatusOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.SSI_Status,ssIStatusDefaultValue);
        regStGrpOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.REG_ST_GRP,regStGrpDefValue);
        recipentTypeOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.RECIPENT_TYPE,recipentTypeDefValue);
        taxJuriCodeOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.TAX_JURIDICATION_CODE,taxJuriCodeDefValue);
        standardCommOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.STAND_COMM,standardCommDefValue);
        industryOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.INDUSTRY,industryOptionsDefValue);
        indicatorWithHoldingOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.IND_WITHHOLD_TAX,indicatorWithHoldingDefValue);
        instKeyDataExchangeOptions = VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,VPM_PicklistHelper.INS_KEYDATA_EXCHANGE,instKeyDataExchangeDefValue);     
        //confirmationControlOptions = VPM_PicklistHelper.getPicklistValues(vendorDetails,'VPM_ConfirmationControl__c');
    }
    
    
  }