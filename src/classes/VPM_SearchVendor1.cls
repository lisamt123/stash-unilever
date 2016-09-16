/********************************************************************
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Modified By  : Piyush Mathur
    Last Modify  : 06th June 2016
    Description  : This controller is mainly used for search vendor page.
    MetaData     : Properties, Wrapper Calss, Methods
  ********************************************************************/
global class VPM_SearchVendor1{
    // Properties used in VF page to bind UI with Data Model
    public static boolean CheckFlag=false;
	public boolean commodityCBSFlag = false ;
    public string CountryName{get;set;}
    //public string vendorCity {get;set;}
    public string Incoterms2{get;set;}
    public boolean heapMessageScreen{get;set;}
    public list <SelectOption> CountryNameList{get;set;} 
    public string Display{get;set;}
    public boolean LaunchScreen{get;set;}
    public string labelText{get;set;}
    public list<mdm_Vendors__c> MDM_Vendor {get;set;}
    public list<OptionWrapper> mdmDetailList {get;set;}
    //public list<string> mdmDetailOption{get; set;}
    public string MDMVendor{get;set;}
    public String positions {get; set;}
    public VPM_ECCVendorSearchServiceOutput op;// = new VPM_ECCVendorSearchServiceOutput();  
    public boolean hideSearchVendor{get;set;}
    public string initialReordType{get;set;}
    public boolean isMaintain2{get;set;}
    public Boolean isRequiredField{get;set;} 
    public boolean renderBackBtn{get;set;}    
    public string requestType='Create';
    public list<OptionWrapper> RequestTypeList{get;set;}
    public String sendWebFormLabel {get; set;}
    public boolean sendWebFormScreen{get;set;}
    public boolean showSearchVendor{get;set;}
    public string VPMStatus{get;set;}
    public string screenType{get;set;}
    public list<string> ScreenVisited= new list<string>();
    public string Street1{get; set;}
    public string TaxCode{get;set;}
    //public list<string> vendorDetailList{get;set;}
    public string VendorCodeInput{get;set;}
    public string VendorName{get;set;}
    public boolean VendorNotFound{get;set;}
    ApexPages.StandardController vendorReq;
    public string ZIPPostcode{get; set;}    
    public VPM_PurchasingRequests__c vendorDetails{get;set;} 
    public string extensionType;
    public VPM_PurchasingRequests__c  vendorQuery1{get;set;}   
    public  List<SelectOption> purchasingOrg{get;set;}
    public string vendorPurchasingOrg{get;set;}   
    public string UnblockBlockUnDeleteDelete {get;set;}   
    Public Boolean isBlockDeleted {get;set;}
    Public Boolean isUnBlockUnDeleted {get;set;} 
    Public Boolean isIncoTerms2Required{get;set;}
    Public Boolean isInputField{get;set;}
    Public Boolean isOutputField{get;set;}
    Public Boolean isReadOnly{get;set;}
    public Id recId{get;set;}  
    public string DeletionBlockFlag  {get;set;}
    public String options {get;set;}    
    //public User UserVar{get;set;}
    //public string userDetailsUrl{get;set;}
    //public string vendorDefaultPaymentTerm{get;set;} 
    public string userlang{get;set;}  
    public boolean RequestBriefScreen{get;set;}
    public boolean paymentTermScreen{get;set;}
    public boolean financialScreen{get;set;}
    public boolean generalVendorDetails{get;set;} 
    public boolean blockDelScreen{get;set;} 
    public boolean unblockUnDelScreen{get;set;}  
    public boolean BankDetailsScreen{get;set;}    
    public boolean regionalSpecificScreenCordillera{get;set;}  
    public boolean regionalSpecificScreenFusion{get;set;}  
    public boolean regionalSpecificScreenSirius{get;set;}  
    public boolean regionalSpecificScreenU2K2{get;set;}
    public boolean isButtonVisible{get;set;}  
    public boolean isBackToDetalPage{get;set;}
    public boolean isButtonVisibleSaveMenu{get;set;}
    public boolean isButtonVisibleSaveExit{get;set;}
    public boolean isExitButtonVisible{get;set;}
    public boolean Goldendata2Screen{get;set;}
    public boolean Goldendata2Screen2{get;set;}
    public boolean isGoldendataButtonVisible{get;set;}
    public boolean isInternationalVersionRendered{get;set;}
    public boolean isRequiredSpend{get;set;}
    public boolean isInternationalVersionCollapsed{get;set;}
    public string pageBlockTitle{get;set;}
    public string VendorType{get;set;}
    public string searchTerm1{get;set;}
    public string VPM_VendorBlockUnblockDelete = '';
    public string webErrorMessage{get;set;}
    public static final string PURCHASING_ORG = 'Purchasing Organisation';
    public static final string CASH_MGMT = 'Cash mgmnt group';
    public static final string LANGUAGE = 'Language';
    public static final string ACCOUNT_STAT = 'Account Statement';
    public static final string PAYMEMT_BLOCK = 'Payment Block';
    public static final string GROUPING_KEY = 'Grouping Key';
    public static final string SCHEMA_GRP = 'Schema Group Vendor';
    public static final string INCOTERMS_1= 'Incoterms 1';
    //modified for IAPR_600
    public static final string PAYMENT_TERMS = 'Payment Terms';
    public static final string STANDARD_NUMBER='StandardNumber';
    public static final string INT_VERSION='InternationalVersion';
    public static final string TRADE_PARTNER_TYPE='TradePartnerType';
    
    public list <SelectOption> VendorTypeList{get;set;}
    
    public  List<SelectOption> Cashmgmntgroup{get;set;}
    public string vendorCashmgmntgroup{get;set;} 
    
    public  List<SelectOption> VenLanguage{get;set;}
    public string vendorLanguage{get;set;} 
    
    public  List<SelectOption> AccountStatement{get;set;}
    public string vendorAccountStatement{get;set;} 
     
    public  List<SelectOption> paymentTerms{get;set;}
    public string vendorPaymentTerms{get;set;}
    
    public  List<SelectOption> standardNumber{get;set;}
    public string vendorStandardNumber{get;set;}
    
    public  List<SelectOption> PaymentBlock{get;set;}
    public string vendorPaymentBlock{get;set;}
    
    public  List<SelectOption> internationalVersion{get;set;}
    public string vendorIntVersion{get;set;}
    
    public  List<SelectOption> tradePartnerType{get;set;}
    public string vendorTradePartnerType{get;set;} 
    
    public  List<SelectOption> GroupingKey{get;set;} 
    public string vendorGroupingKey{get;set;} 
    
    public  List<SelectOption> SchemaGroupVendor{get;set;}
    public string vendorSchemaGroupVendor{get;set;} 
    
    public  List<SelectOption> Incoterms1{get;set;}
    public string vendorIncoterms1{get;set;} 
    
    
    
    public  List<SelectOption> VPMAuthorizationList{get;set;}
    public string VPMAuthorization{get;set;}
    public boolean isTrue{get;set;}
     //modified by vaishali Nagar for IAPR-605
    VendorRequest__c obj = VendorRequest__c.getInstance('Countries');   
    public string latam;
    
    
    // Wrapper Class used to add Name and Value to Radio button on user selection   
    public class OptionWrapper{
        public String DetailOption{get;set;}
        public String UniqueId{get;set;}
        public boolean showLabel{get;set;}
        public String labelText{get;set;}        
    }
    
    public VPM_SearchVendor1() {}
    
    
    /******************************************************************** 
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : Apex Constructor for extension class. Load Vendor Details record in "vendorDetail" property.
    Return Type  : Contructor no return type.
    ********************************************************************/
    public VPM_SearchVendor1(ApexPages.StandardController controller)
    {
        system.debug('@@Constructor is called');
        vendorReq = controller;
        Goldendata2Screen  = false;
        Goldendata2Screen2 = false;
        pageBlockTitle = ''; 
        screenType = ''; 
        positions='Yes';
        isExitButtonVisible = false;
        isRequiredField = true;
        heapMessageScreen = false;
        webErrorMessage = '';
        isButtonVisibleSaveMenu = false;
        isIncoTerms2Required = false;
        isButtonVisibleSaveExit = false;
        isGoldendataButtonVisible = false;
        isButtonVisible = false;
        BankDetailsScreen = false;
        paymentTermScreen = false;
        sendWebFormScreen =false;
        RequestBriefScreen = false;
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
        
        sendWebFormLabel = system.label.VPM_Send_Button;
        recId = controller.getRecord().Id; 
        vendorDetails = (VPM_PurchasingRequests__c)controller.getRecord();
        system.debug('@@vendorReq' + vendorReq);
        system.debug('@@vendorDetails' + vendorDetails); 
        isInternationalVersionCollapsed = true;
        vendorQuery1 = [select Id,VPM_checkForFieldUpdate__c, VPM_City__c,isMaintain2__c,VPM_DeletionBlockFlag__c,VPM_Incoterms2__c,VPM_VendordoesntExistFlag__c, VPM_TradePartnerType__c, VPM_CheckDoubleInvoices__c,VPM_VendorContactDetail__c,VPM_ReconciliationAccount__c,VPM_BankCountryKey__c, VPM_Comments__c, VPM_VendorName1__c, VPM_VendorPhone__c,
                        VPM_VendorName2__c,VPM_Name3__c,VPM_Name4__c,VPM_TaxNumber1__c,VPM_TaxNumber2__c,VPM_TaxNumber3__c,VPM_TaxNumber4__c,VPM_VATRegistrationNumber__c,
                        VPM_ECC__c, VPM_ExtensionType__c,VPM_PaymentTerms__c,VPM_Status__c,VPM_VendorCodeLookup__c, VPM_VendorCodeLookup__r.mdm_ecc__c, VPM_VendorCodeLookup__r.mdm_Code__c,VPM_Commodity__r.Name,VPM_Commodity__r.VPM_CommodityCode__c,
                        VPM_CompanyCode__r.ECC__c,VPM_Commodity__c,VPM_Commodity__r.VPM_VendorType__c,VPM_VendorType__c, VPM_Commodity__r.VPM_AuthorisationGroup__c,VPM_GlobalAuthorisationGroup__c, VPM_Street1__c, VPM_Country__c, VPM_ZIPPostcode__c, VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,
                        VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c, VPM_PurchasingOrg__c,VPM_PurchasingOrg__r.Name, VPM_IsVendorSME__c,
                        recordTypeId,VPM_CompanyCode__r.VPM_CompanyCode__c,VPM_CashManagementGroup__c,VPM_Language__c,VPM_AccountStatement__c,VPM_PaymentBlock__c,VPM_GroupingKey__c,VPM_SchemaGroupVendor__c,VPM_Incoterms1__c,VPM_PaymentMethod__c,
                        VPM_Regions__c,VPM_SearchTerm_1__c,VPM_OrderCurrency__c,VPM_Authorization__c,VPM_TaxJurisdictionCode__c,VPM_InternationalVersion__c,VPM_StandardNumber__c,VPM_VATCountry__c,VPM_VATRegistrationNumber2__c,VPM_SortKey__c,VPM_SRVBasedVendorID__c,VPM_IsLock__c,createdbyid,VPM_PurchasingOrganisation__c,VPM_AuthorisationGroupFormula__c, VPM_VendorBlockUnblockDelete__c
                        from VPM_PurchasingRequests__c where id = : recId];
        
        vendorPurchasingOrg = vendorQuery1.VPM_PurchasingOrganisation__c;
        vendorCashmgmntgroup = vendorQuery1.VPM_CashManagementGroup__c;
        system.debug('@@ vendorQuery1.VPM_Language__c' + vendorQuery1.VPM_Language__c);
        vendorLanguage=vendorQuery1.VPM_Language__c;
        vendorAccountStatement=vendorQuery1.VPM_AccountStatement__c;
        vendorPaymentBlock=vendorQuery1.VPM_PaymentBlock__c;
        vendorGroupingKey=vendorQuery1.VPM_GroupingKey__c;
        vendorIncoterms1 = vendorQuery1.VPM_Incoterms1__c;
        vendorSchemaGroupVendor=vendorQuery1.VPM_SchemaGroupVendor__c;
        Incoterms2 = vendorQuery1.VPM_Incoterms2__c;
        //modified for IAPR-600
        vendorPaymentTerms = vendorQuery1.VPM_PaymentTerms__c;
        vendorStandardNumber = vendorQuery1.VPM_StandardNumber__c;
        vendorIntVersion = vendorQuery1.VPM_InternationalVersion__c;
        vendorTradePartnerType = vendorQuery1.VPM_TradePartnerType__c;
        searchTerm1= vendorQuery1.VPM_SearchTerm_1__c ; 
        
        
        
         
        system.debug('@@ vendorQuery1.VPM_SRVBasedVendorID__c' +vendorQuery1.VPM_SRVBasedVendorID__c);
        isTrue=true;
        
       system.debug('@@ SRV' + vendorQuery1.VPM_SRVBasedVendorID__c);
       
       vendorQuery1.VPM_SRVBasedVendorID__c = true;
       vendorQuery1.VPM_CheckDoubleInvoices__c = true; 
        
        if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera' || vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion')
            isInternationalVersionRendered = false;
        else
            isInternationalVersionRendered = true;
            
        system.debug('1@@vendorQuery1.VPM_PaymentTerms__c'+vendorQuery1.VPM_PaymentTerms__c);
        if(string.isBlank(vendorQuery1.VPM_PaymentTerms__c)){  
             system.debug('2@@vendorQuery1.VPM_PaymentTerms__c'+vendorQuery1.VPM_PaymentTerms__c);                                 
             if((vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius' || vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera')){  
              vendorQuery1.VPM_PaymentTerms__c = 'P090_Within 90 days Due net (90NET)';
             }else if(vendorQuery1.VPM_IsVendorSME__c=='Yes' && (vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion')){
              vendorQuery1.VPM_PaymentTerms__c = '30DK_Within 30 days Due net (30NET)';
             }else if((vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius' || vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2' || vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera')){
              vendorQuery1.VPM_PaymentTerms__c = 'P030_Within 30 days Due net (30NET)';
             }else if((vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2')){
              vendorQuery1.VPM_PaymentTerms__c = 'S090_Within 90 days Due net (90NET)';
             }else if((vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion')){
              vendorQuery1.VPM_PaymentTerms__c = '90DK_Within 90 days Due net (90NET)';
            }
       }
    
        //Make spend field required only when commodity code starts with 0
        //isRequiredSpend =true; // by default shld always be required
        //Changed by Epsita - IAPR- 638 || Spend should not be mandatory for Non-Ariba Commodities
        isRequiredSpend = false;
        System.debug('Commodity Code '+vendorQuery1.VPM_Commodity__r.VPM_CommodityCode__c);
        System.debug('isRequiredSpend '+isRequiredSpend );
        
        if(string.isNotBlank(vendorQuery1.VPM_Commodity__r.VPM_CommodityCode__c) && vendorQuery1.VPM_Commodity__r.VPM_CommodityCode__c.startsWith('0'))                  
            isRequiredSpend = false;
        else                
            isRequiredSpend =true;              

         String Status =vendorQuery1.VPM_Status__c== null?'': vendorQuery1.VPM_Status__c;
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
        
            
        if(vendorQuery1.VPM_CompanyCode__r.ecc__c <> '' || vendorQuery1.VPM_CompanyCode__r.ecc__c <> null)
            vendorDetails.VPM_ECC__c = vendorQuery1.VPM_CompanyCode__r.ecc__c;
        
        boolean isIncoTerms2Required = false;        
        
        
        // assigning the picklist values based on company code ECC associated to vendor request.
         purchasingOrg = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PURCHASING_ORG, vendorPurchasingOrg);
        Cashmgmntgroup = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, CASH_MGMT,vendorCashmgmntgroup);
        VenLanguage = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,LANGUAGE, vendorLanguage);
        AccountStatement = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, ACCOUNT_STAT, vendorAccountStatement);
        PaymentBlock = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PAYMEMT_BLOCK, vendorPaymentBlock);
        GroupingKey  = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, GROUPING_KEY, vendorGroupingKey);
        Incoterms1 = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, INCOTERMS_1, vendorIncoterms1);
        SchemaGroupVendor = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, SCHEMA_GRP,vendorSchemaGroupVendor);
        //modified by vaishali nagar for IAPR-600
        paymentTerms = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PAYMENT_TERMS,vendorPaymentTerms);
        standardNumber= getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,STANDARD_NUMBER,vendorStandardNumber);
        internationalVersion =getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,INT_VERSION,vendorIntVersion);
        tradePartnerType = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,TRADE_PARTNER_TYPE,vendorTradePartnerType);
        
        if(string.isBlank(vendorIncoterms1) && vendorDetails.VPM_ECC__c <> 'U2K2') {
            isIncoTerms2Required = true;
        }
        
        system.debug('@@Cashmgmntgroup' +Cashmgmntgroup);
        
        //vendorDetails.VPM_TradePartnerType__c = vendorQuery1.VPM_TradePartnerType__c;
       // vendorDetails.VPM_TradePartnerType__c =string.isNotBlank(op.TradePartnerType) ? op.TradePartnerType :vendorTradePartnerType;
        options = vendorQuery1.VPM_DeletionBlockFlag__c;
        system.debug('@@vendorQuery1.VPM_DeletionBlockFlag__c' + vendorQuery1.VPM_DeletionBlockFlag__c);
        /* assigning the picklist values based on company code ECC associated to vendor request.
        purchasingOrg = getPurchasingOrgItems();
        Cashmgmntgroup =getCashmgmntgroupItems();
        VenLanguage = getVenLanguageItems();
        AccountStatement = getAccountStatement();
        PaymentBlock = getPaymentBlock();
        GroupingKey = getGroupingKey();
        Incoterms1 = getIncoterms1();
        SchemaGroupVendor = getSchemaGroupVendor();
        //BankCountryKey = getBankCountryKey(); */
        
        Street1 = vendorQuery1.VPM_Street1__c;
        VendorName = vendorQuery1.VPM_VendorName1__c;
        if(string.isBlank(searchTerm1))
        searchTerm1 = string.isNotblank(VendorName) ? vendorName.left(10) : '';
        
        ZIPPostcode = vendorQuery1.VPM_ZIPPostcode__c;
        //vendorCity = vendorQuery1.VPM_City__c;
        CountryName = vendorQuery1.VPM_Country__c;
        CountryNameList = getCountries();
        LaunchScreen = false;
       
        
        
        system.debug('@@VendorName' +VendorName);
        
        system.debug('&&&&&vendorQuery1.RecordTypeId '+vendorQuery1.RecordTypeId);
        
        requestType = VPM_RecordTypeHelper.getLaunchScreenVariable('',vendorQuery1.RecordTypeId);
        initialReordType = requestType;
        VPMStatus = vendorQuery1.VPM_Status__c;
        screenType = 'Create';
        system.debug('&&&&&requestType '+requestType);
        
        if(requestType == 'Create')
        {
            showSearchVendor = false;
            isBackToDetalPage = true; 
            LaunchScreen =true;
            pageBlockTitle = ''; 
            
            //ScreenVisited.add('Create');
            screenType = 'Create';
        }
        else if(requestType == 'Extend')
        {
            showSearchVendor = false;
            isBackToDetalPage = true; 
            LaunchScreen =true;
            pageBlockTitle = ''; 
            screenType = 'Extend';
            // ScreenVisited.add('Extend');
        }
        else if(requestType == 'Maintain' || requestType == 'Maintain2')
        {   ////// Added for 591 Start ////////////
            system.debug('not calling web service');
            showSearchVendor = false;
            LaunchScreen =true;
            pageBlockTitle = ''; 
            screenType = 'Maintain';
            isBackToDetalPage = true; 
            system.debug('###### op '+op);
            if(vendorQuery1.isMaintain2__c) {
                requestType = 'Maintain2'; // Limited no of options
                isMaintain2 =true;   
            }else {
                requestType='Maintain';
            }
            ScreenVisited.add('vendorList');
            //renderBackBtn = true;
            LaunchScreen = true;
            screenType = 'Maintain';
            system.debug('@@%%OP.Deleted' + screenType); 
             ////// Added for 591  Finish ////////////
             
            /*system.debug('@@ Coming Here');
            op = FetchVendorDeatilSAPService('');
            showSearchVendor = false;
            LaunchScreen =true;
            pageBlockTitle = ''; 
            screenType = 'Maintain';
            isBackToDetalPage = true; 
            system.debug('###### op '+op);
            if(op.statusCode == '200') {
                if(op.vendorFoundResult) 
                {       
                    if(op.companyCodeMatching)
                    {
                        if(op.CompanyCodeFields <> null && op.CompanyCodeFields.size() > 0 ) {
                            boolean Blocked = op.CompanyCodeFields[0].Blocked;
                            boolean Deleted = op.CompanyCodeFields[0].Deleted;                    
                            if((Blocked && Deleted) || (Blocked && !Deleted) || (!Blocked && Deleted))
                            {
                                requestType = 'Maintain2'; // Limited no of options
                                isMaintain2 =true;                        
                            }
                            else{
                                requestType='Maintain';
                            }
                            webServiceData(op);  
                        }
                        ScreenVisited.add('vendorList');
                        //renderBackBtn = true;
                        LaunchScreen = true;
                        screenType = 'Maintain';
                        system.debug('@@%%OP.Deleted' + screenType); 
                    }else {
                        LaunchScreen=true;
                        //renderBackBtn = true;

                        requestType ='Extend';
                        screenType = 'Extend';
                        if((vendorQuery1.VPM_VendorCodeLookup__r.mdm_ecc__c).contains(vendorQuery1.VPM_CompanyCode__r.ECC__c)) {                       
                            extensionType = 'Regional';
                        }else {
                            extensionType = 'Global';
                        }
                        ScreenVisited.add('vendorList');
                        
                    }
                }
            }else {
                VendorNotFound =true;
                LaunchScreen = false;
                webErrorMessage = op.message;
                //renderBackBtn = true;  
                //isBackToDetalPage = true; 
                isExitButtonVisible = true;
                pageBlockTitle = ''; 
                ScreenVisited.add('vendorList');
            }  */          
        }
        else
        {
            showSearchVendor = true;
            isBackToDetalPage = true; 
            pageBlockTitle = System.label.VPM_Vendor_Match; 
            //isBackToDetalPage = false;  
            //ScreenVisited.add('searchVendor');
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
            LaunchScreen =false;
            ScreenVisited.add('searchVendor');
            string countryNameSplitted = '';
            if(string.isNotBlank(CountryName)) {                
                List<string> s2 = CountryName.split('_',-1);
                countryNameSplitted = s2[1]; 
            }
            //labelText='Vendor List';
            // Dynamic Query builded for search vendor
            string searchQuery ='SELECT id,mdm_Postcode__c,VPM_FullDetails__c,mdm_vCodeSirius__c,mdm_vCodeCordillera__c,mdm_vCodeU2K2__c,mdm_Name2__c,mdm_Name3__c,mdm_Name4__c,mdm_TaxNumber1__c,mdm_TaxNumber2__c,mdm_TaxNumber3__c,mdm_TaxNumber4__c,mdm_VATRegNum__c, mdm_vCodeFusion__c,mdm_Name1__c,mdm_Street__c ,mdm_City__c,mdm_Country__c,mdm_ecc__c,mdm_Code__c FROM mdm_Vendors__c  WHERE ( mdm_Name1__c LIKE '+'\'%' + String.escapeSingleQuotes(VendorName) + '%\'' ;
            if(string.isNotBlank(Street1) && string.isNotBlank(ZIPPostcode)) {
                searchQuery+=' OR mdm_Street__c LIKE '+ '\'%' + String.escapeSingleQuotes(Street1) + '%\'';    
                searchQuery+=' OR mdm_Postcode__c LIKE '+ '\'%' + String.escapeSingleQuotes(ZIPPostcode)+ '%\')';
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\'';
            }else  if(string.isNotBlank(Street1) && string.isBlank(ZIPPostcode)) {   
                searchQuery+=' OR mdm_Street__c LIKE '+ '\'%' + String.escapeSingleQuotes(Street1) + '%\')';  
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\'';
            }else  if(string.isBlank(Street1) && string.isNotBlank(ZIPPostcode)) {   
                searchQuery+=' OR mdm_Postcode__c LIKE '+ '\'%' + String.escapeSingleQuotes(ZIPPostcode)+ '%\')';
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\'';
            }else  if(string.isBlank(Street1) && string.isBlank(ZIPPostcode)) {   
                searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\')';
            }
            searchQuery+= 'LIMIT 999';
            
            system.debug('@@MDM_Vendor' +searchQuery);
            MDM_Vendor = Database.query(searchQuery);
            system.debug('@@MDM_vendor' + MDM_Vendor);
            
            mdmDetailList =setmdmDetailOption(MDM_Vendor);
            if(mdmDetailList == null || mdmDetailList.size() < 0 ) {
                hideSearchVendor = false;
                heapMessageScreen = true;                
                system.debug('@@ Please filter the search creteria');
            }
            system.debug('@@mdmDetailList' + mdmDetailList);
        }           
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
                        system.debug('@@ state' + state);
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
    Created Date : 05th June 2016
    Last Modify  : 15th June 2016
    Description  : Invoke when user select vendor from search List.
    Return Type  : Void
    ********************************************************************/
     public void VendorSelected()
     {
       system.debug('@@VendorSelected is called');     
       renderBackBtn = true;
         
       //if(MDM_Vendor.size() > 0)
      
       isBackToDetalPage = false;  
        system.debug('^^^^^^^ '+MDMVendor );
        pageReference pg = null;
     // Condition : When vendor is not listed then blank value is assinged to "MDMVendor"
      system.debug('MDMVendor showSearchVendor '+MDMVendor +' && '+showSearchVendor);
         if(MDMVendor == '' && !sendWebFormScreen)
      {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, System.Label.VPM_Select_Option));
      }
      else if(MDMVendor == 'notlisted')
      {
          system.debug('###initialReordType '+initialReordType);
        //if(initialReordType == 'Generic') {            
            LaunchScreen= false;
            hideSearchVendor =false;
            sendWebFormScreen =true;
            paymentTermScreen  = false;
            BankDetailsScreen=false;   
            showSearchVendor  = false;
            hideSearchVendor=false;
            LaunchScreen =false; 
            renderBackBtn = true;  
            pageBlockTitle = System.label.VPM_SendWebFormRequest;
            IF(this.positions == 'No') {
                isRequiredField = false;
                sendWebFormLabel = system.label.VPM_Next;
            }else {
                isRequiredField = true;   
                sendWebFormLabel = system.label.VPM_Send_Button;
            }
            ScreenVisited.add('vendorList');
            system.debug('@@ScreenVisited' +ScreenVisited);
      //}
          showSearchVendor  = false;
          hideSearchVendor=false;
          //LaunchScreen =sendWebFormScreen == true ?false:true;
          //Goldendata2Screen =sendWebFormScreen == true ?false:true;
          //labelText='T';
          requestType ='Create';
          screenType =requestType ;
          updateVendorDetail(null);
          setLaunchScreenText();
          //ScreenVisited.add('vendorList');
         system.debug('@@LaunchScreen' + LaunchScreen);  
         system.debug('@@sendWebFormScreen' + sendWebFormScreen); 
      }
          // Condition : If not blank "MDMVendor" then it contains vendor Detail record ID
         else if(MDMVendor !='')
          {
              system.debug('###@initialReordType '+initialReordType);
              pageBlockTitle = ''; 
             requestType = VPM_RecordTypeHelper.getLaunchScreenVariable('',vendorQuery1.RecordTypeId);
              try{
                  system.debug('@@MDMVendor' + MDMVendor);
            list<string> MDMVendorInfo =MDMVendor.split('\\\\#',-2);   
             system.debug('@@MDMVendor' + MDMVendorInfo );
            if(MDMVendorInfo <> null && MDMVendorInfo.size() > 0 ) {
                /*if(string.isNOtBlank(MDMVendorInfo[3]) && MDMVendorInfo[3] <> 'null' )  VendorName = MDMVendorInfo[3];  
                if(string.isNOtBlank(MDMVendorInfo[4])&& MDMVendorInfo[4] <> 'null')  Street1 = MDMVendorInfo[4]; 
                if(string.isNOtBlank(MDMVendorInfo[5])&& MDMVendorInfo[5] <> 'null')  ZIPPostcode = MDMVendorInfo[5]; 
                if(string.isNOtBlank(MDMVendorInfo[6])&& MDMVendorInfo[6] <> 'null')  vendorDetails.VPM_City__c = MDMVendorInfo[6];
                if(string.isNotBlank(MDMVendorInfo[7]) && MDMVendorInfo[7] <> 'null') vendorDetails.VPM_VendorName2__c = MDMVendorInfo[7];
                if(string.isNotBlank(MDMVendorInfo[8])&& MDMVendorInfo[8] <> 'null') vendorDetails.VPM_Name3__c = MDMVendorInfo[8];
                if(string.isNotBlank(MDMVendorInfo[9])&& MDMVendorInfo[9] <> 'null') vendorDetails.VPM_Name4__c = MDMVendorInfo[9];
                if(string.isNotBlank(MDMVendorInfo[10])&& MDMVendorInfo[10] <> 'null') vendorDetails.VPM_TaxNumber1__c = MDMVendorInfo[10];
                if(string.isNotBlank(MDMVendorInfo[11])&& MDMVendorInfo[11] <> 'null') vendorDetails.VPM_TaxNumber2__c = MDMVendorInfo[11];
                if(string.isNotBlank(MDMVendorInfo[12])&& MDMVendorInfo[12] <> 'null') vendorDetails.VPM_TaxNumber3__c = MDMVendorInfo[12];
                if(string.isNotBlank(MDMVendorInfo[13])&& MDMVendorInfo[13] <> 'null') vendorDetails.VPM_TaxNumber4__c  = MDMVendorInfo[13];
                if(string.isNotBlank(MDMVendorInfo[14])&& MDMVendorInfo[14] <> 'null') vendorDetails.VPM_VATRegistrationNumber__c = MDMVendorInfo[14];*/
                system.debug('@@vendorDetails' +vendorDetails); 
            }
            op = FetchVendorDeatilSAPService(MDMVendorInfo[1]);
            showSearchVendor  = false;
            hideSearchVendor=false;  
            
            if(op.statusCode == '200') {
                 if(op.vendorFoundResult && op.Blocked <> null && op.Deleted <> null) 
                  {     
                    
                    if(op.companyCodeMatching )
                    {              
                        if(op.CompanyCodeFields <> null && op.CompanyCodeFields.size() > 0 ) {
                            boolean Blocked = op.CompanyCodeFields[0].Blocked;
                            boolean Deleted = op.CompanyCodeFields[0].Deleted; 
                            
                            booleanToStringMethod(Blocked,Deleted);
                            if((Blocked && Deleted) || (Blocked && !Deleted) || (!Blocked && Deleted))
                            {
                                requestType = 'Maintain2'; // Limited no of options
                                isMaintain2 =true;  
                                vendorQuery1.isMaintain2__c = true;
                            }
                            else{ 
                                requestType='Maintain';
                                vendorQuery1.isMaintain2__c = false;
                            }
                            webServiceData(op);  
                        }
                        ScreenVisited.add('vendorList');
                        
                        screenType = 'Maintain';
                        system.debug('@@%%OP.Deleted' + screenType); 
                        //labelText='Vendor maintain launch screen';
                    }
                      else 
                      {
                          requestType ='Extend';
                          screenType = 'Extend';
                          
                          system.debug('@@WS-ECC'  + op.ECC ); 
                          
                          if((MDMVendorInfo[2]).contains(vendorQuery1.VPM_CompanyCode__r.ECC__c)) {                    
                              extensionType = 'Regional';
                          }else {
                              extensionType = 'Global';
                          }
                          webServiceData(op);  
                          ScreenVisited.add('vendorList');
                      }
                        system.debug('$$$$$$$$requestType '+requestType);
                        setLaunchScreenText(); 
                        //LaunchScreen=true;   
                        Goldendata2Screen = true;    
                        pageBlockTitle = 'Golden Data Screen';    
                        //QueryVendorRequest();                
                  }
              }
            else 
            {            
                VendorNotFound =true;
                isExitButtonVisible = true;
                webErrorMessage = op.message;
                renderBackBtn = true;  
                ScreenVisited.add('vendorList');
                
            }
            // Update purchasing request record after service call.
                  system.debug('$$$$Before calling update');      
             updateVendorDetail(MDMVendorInfo[0]);
              }
              catch(exception ex)
              {
                  system.debug('@@Exception' + ex.getStackTraceString());
              }
            
          }
         else
         {
             system.debug('###!!initialReordType '+initialReordType);
             showSearchVendor  = false;
             pageBlockTitle = ''; 
             hideSearchVendor=false;
             sendWebFormScreen=false;
             LaunchScreen =true;
             ScreenVisited.add('vendorList');             
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
      system.debug('@@ScreenVisited' +ScreenVisited);   
          system.debug('@@showSearchVendor' +showSearchVendor);
          system.debug('@@LaunchScreen' +LaunchScreen);
          system.debug('@@RequestBriefScreen' +RequestBriefScreen);  
       if(MDMVendor == '')
      {
         isBackToDetalPage = true; // added for IAPR- 671
         renderBackBtn = false; // added for IAPR- 671
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,System.Label.VPM_Select_Option));
      }
      else if(MDMVendor =='ReviewRequestBrief')
      {
      system.debug('ReviewRequestBrief');      
          RequestBriefScreen = true;
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          pageBlockTitle = System.label.VPM_Request_Brief_Heading;
          ScreenVisited.add('requestType');
      }
      else if(MDMVendor =='EditBankDetails' || MDMVendor =='EnterBankDetails') {         
          BankDetailsScreen=true;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;  
          pageBlockTitle = System.label.VPM_BankDetailsTitle;
          ScreenVisited.add('requestType');
      }
      else if(MDMVendor =='EditGeneralVendorDetails' || MDMVendor =='EnterGeneralVendorDet') {
          paymentTermScreen  = false;
          BankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          financialScreen = false;
          generalVendorDetails = true;
          VendorTypeList = getVendorType();
          VPMAuthorizationList = getAuthorization();
          
          pageBlockTitle = System.label.VPM_General_Vendor_Details;
          //VendorType = vendorQuery1.VPM_VendorType__c== null?vendorQuery1.VPM_Commodity__r.VPM_Vendor_Type__c :vendorQuery1.VPM_VendorType__c;
          //VPMAuthorization = vendorQuery1.VPM_GlobalAuthorisationGroup__c== null?vendorQuery1.VPM_Commodity__r.VPM_Authorisation_Group__c :vendorQuery1.VPM_GlobalAuthorisationGroup__c;
         
          system.debug('@@@@@@@@Vendor Type '+vendorQuery1.VPM_Commodity__r.VPM_VendorType__c);
          system.debug('@@@@@@@@Vendor Type '+vendorQuery1.VPM_VendorType__c);
          ScreenVisited.add('requestType'); 
          //pg =  new Pagereference('/apex/VPM_GeneralVendorDetails?id=' + vendorDetail.id); 
      }
      else if(MDMVendor =='RequestVendorBlock' || MDMVendor =='RequestVendorBlock/Delete' || MDMVendor =='RequestVendorUnBlock/Delete') {
          paymentTermScreen  = false;
          BankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          financialScreen = false;
          generalVendorDetails = false;
          if(requestType =='Maintain2') {
              unblockUnDelScreen = true;
              pageBlockTitle = System.label.VPM_UnBlockUnDeleteTitle;
          }else if (requestType=='Maintain') {
              blockDelScreen = true;
              pageBlockTitle = System.label.VPM_BlockDeleteTitle;
          }
          ScreenVisited.add('requestType');
      }
      else if(MDMVendor =='EditPaymentTerms' || MDMVendor =='EnterPaymentTerms') {
          paymentTermScreen  = true;
          BankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          pageBlockTitle = System.label.VPM_PaymetTermsTitle;
          ScreenVisited.add('requestType');
      }
      else if(MDMVendor =='VendorMatch')
      {
          showSearchVendor  = true;
          op = new VPM_ECCVendorSearchServiceOutput();
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          isBackToDetalPage = false;
          unblockUnDelScreen = false;
          blockDelScreen = false; 
          pageBlockTitle = '';
          isMaintain2 = false;   
          pageBlockTitle = System.label.VPM_Vendor_Match;
          vendorReq.reset();      
          //webServiceData(op);
          ScreenVisited.add('VendorMatch');
      }     
      else if(MDMVendor =='EditFinanciallySensitiveFlds' || MDMVendor =='EnterFinanciallySensiFlds') {
          paymentTermScreen  = false;
          BankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          financialScreen = true;
          pageBlockTitle = System.label.VPM_FinanciallySensitiveTitle;
          ScreenVisited.add('requestType');
      }
      else if(MDMVendor =='EditRegionalSpecificFlds' || MDMVendor =='EnterRegionalSpecificFlds') {
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;
          ScreenVisited.add('requestType');
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
      else if(MDMVendor =='SendResendWebform') {
          showSearchVendor = false;
          LaunchScreen= false;
          hideSearchVendor =false;
          sendWebFormScreen = true; 
          paymentTermScreen  = false;
          BankDetailsScreen=false;   
          showSearchVendor  = false;
          hideSearchVendor=false;
          LaunchScreen =false;
          renderBackBtn = true;  
          IF(positions == 'Yes')
           isRequiredField = true;
           else
            isRequiredField = false;
          pageBlockTitle = System.label.VPM_SendWebFormRequest;
          ScreenVisited.add('requestType');
        
      } 
      else if(MDMVendor =='SubmitVendorRequestApproval') {         
         string queryString = '&isMaintain2=' + isMaintain2;    
         if(requestType =='Maintain' || requestType =='Extend' || requestType =='Maintain2') {         
              if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera') {
                  pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + recId + queryString); 
              }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion') {
                  pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + recId + queryString); 
              }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Sirius') {
                  pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + recId + queryString); 
              }else if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'U2K2') {
                  pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + recId +queryString); 
              }   
          }else if(requestType =='Create') {
              pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + recId); 
          }        
          pg.setRedirect(true);   
      }
      else if(MDMVendor =='ExitForm') {
          pg =  new Pagereference('/' + recId); 
          pg.setRedirect(true);   
      }
      return pg;
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
       vendorQuery1.VPM_VendorName1__c = VendorName;
       vendorQuery1.VPM_Street1__c = Street1;
       vendorQuery1.VPM_ZIPPostcode__c = ZIPPostcode;
       vendorQuery1.VPM_Country__c = CountryName;  
       vendorQuery1.VPM_City__c = vendorDetails.VPM_City__c;
       vendorQuery1.RecordTypeId = VPM_RecordTypeHelper.getRecordTypeNameById(requestType);
       vendorQuery1.VPM_ECC__c = vendorQuery1.VPM_CompanyCode__r.ECC__c;
       vendorQuery1.VPM_ExtensionType__c = extensionType;       
    // 22 08 2016 : Changes By Samrin to Set VPM_VendorBlockUnblockDelete__c for the secodn time when user click on back button 
            // vendorQuery1.VPM_VendorBlockUnblockDelete__c= VPM_VendorBlockUnblockDelete== null?VPM_VendorBlockUnblockDelete: //vendorQuery1.VPM_VendorBlockUnblockDelete__c;
         vendorQuery1.VPM_VendorBlockUnblockDelete__c = VPM_VendorBlockUnblockDelete;
       
       system.debug('@@vendorQuery1' + vendorQuery1); 
        
       //vendorReq.save();
       update vendorQuery1;
    }

     /******************************************************************** 
   
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Get details of selected vendor from SAP.
    Return Type  : VPM_FetchVendorsDetails.OutputVariables
    ********************************************************************/
    public VPM_ECCVendorSearchServiceOutput FetchVendorDeatilSAPService(string MDMVendorCodeInput)
    {
        system.debug('@@web service  is called');
        string purchOrgName = vendorQuery1.VPM_PurchasingOrg__r.Name; // added recently for passing org 
        purchOrgName = string.isNotBlank(purchOrgName) ? purchOrgName.left(4) : null; // added recently for passing org 
        //VPM_CompanyCode__c ComapyCode =[SELECT VPM_CompanyCode__c, ECC__c FROM VPM_CompanyCode__c WHERE id =: vendorDetail.VPM_CompanyCode__c LIMIT 1];
        //mdm_Vendors__c mdmVendor =[SELECT id,mdm_Code__c FROM mdm_Vendors__c  WHERE id =: vendorDetail.VPM_VendorCodeLookup__c ];
        VPM_FetchVendorsDetails.InputVariables ip = new VPM_FetchVendorsDetails.InputVariables();
        List<VPM_FetchVendorsDetails.InputVariables> ipList = new List<VPM_FetchVendorsDetails.InputVariables>();
        List<VPM_ECCVendorSearchServiceOutput> opList = new List<VPM_ECCVendorSearchServiceOutput>();
        system.debug('@@MDMVendorCodeInput' +MDMVendorCodeInput);
        if(string.isNotBlank(MDMVendorCodeInput)){
            ip.vendorCodeInput = MDMVendorCodeInput;
        }else {
            ip.vendorCodeInput = vendorCodeAssignment();            
        }
      ip.ecc = vendorQuery1.VPM_CompanyCode__r.ECC__c;
      ip.compnayCode = vendorQuery1.VPM_CompanyCode__r.VPM_CompanyCode__c;
      ip.purchasingOrg = purchOrgName; // added recently for passing org 
      ipList.add(ip);
      system.debug('@@ipList' + ipList);
      opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
        
      //webServiceData(opList[0]);  
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

      // Common for all
       // if(requestType <> 'Maintain2') {
            
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_SubmitVendorRequestforApproval + '","UniqueId":"SubmitVendorRequestApproval","showLabel":true,"labelText":"'+System.label.VPM_Quick_Submit+'"},';
        //}
       
       if(requestType =='Create') {

       //OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_Request_Brief_Heading+'","UniqueId":"ReviewRequestBrief","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterGeneralVendorDetails + '","UniqueId":"EnterGeneralVendorDet","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterBankDetails + '","UniqueId":"EnterBankDetails","showLabel":false,"labelText":""},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterPaymentTerms + '","UniqueId":"EnterPaymentTerms","showLabel":false,"labelText":""},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterFinanciallySensitiveFields + '","UniqueId":"EnterFinanciallySensiFlds","showLabel":false,"labelText":""},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EnterRegionalSpecificFields + '","UniqueId":"EnterRegionalSpecificFlds","showLabel":false,"labelText":""},';
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_Send_ResendWebformRequest + '","UniqueId":"SendResendWebform","showLabel":true,"labelText":"'+System.label.VPM_Contact_Vendor+'"},';
       }
       
       if(requestType =='Maintain' || requestType =='Extend')
       {
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_General_Vendor_Details+'","UniqueId":"EditGeneralVendorDetails","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditBankDetails+'","UniqueId":"EditBankDetails","showLabel":false,"labelText":""},';
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditPaymentTerms + '","UniqueId":"EditPaymentTerms","showLabel":false,"labelText":""},';
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditFinanciallySensitiveFields + '","UniqueId":"EditFinanciallySensitiveFlds","showLabel":false,"labelText":""},';  
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_EditRegionalSpecificFields + '","UniqueId":"EditRegionalSpecificFlds","showLabel":false,"labelText":""},';
  
        if(requestType =='Maintain')
            OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_RequestVendortoBlock_Delete+'","UniqueId":"RequestVendorBlock/Delete","showLabel":false,"labelText":""},';
      
        //OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_VendorMatch + '","UniqueId":"VendorMatch","showLabel":false,"labelText":""},';
      
      
       }
      
       //Maintain 1
       else if(requestType =='Maintain2')
       {
           //OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_VendorMatch + '","UniqueId":"VendorMatch","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
           OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_RequestVendortoUnblock_Undelete + '","UniqueId":"RequestVendorUnBlock/Delete","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
           isMaintain2 = true;
      }
       OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_Exitthisform + '","UniqueId":"ExitForm","showLabel":true,"labelText":"'+System.label.VPM_Exit_Form+'"}]';
      RequestTypeList = (List<OptionWrapper>) System.JSON.deserialize(OptionWrapperJSON, List<OptionWrapper>.class);
      MDMVendor ='';
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
      MDMVendor = '';   // added for IAPR- 671
      isBackToDetalPage = false;   
      heapMessageScreen = false;   
      pageBlockTitle = '';
      isExitButtonVisible = false;   
      Goldendata2Screen  = false;   
      Goldendata2Screen2 = false;   
      try{
          system.debug('@@ScreenVisited' +ScreenVisited);
          string currentScreen = ScreenVisited[ScreenVisited.size() -1];
          system.debug('@@currentScreen' +currentScreen);   
          system.debug('@@showSearchVendor' +showSearchVendor);
          system.debug('@@LaunchScreen' +LaunchScreen);
          system.debug('@@RequestBriefScreen' +RequestBriefScreen);
          system.debug('@@currentScreen' +currentScreen);
          if(currentScreen == 'searchVendor')
          {      
            showSearchVendor = true;
            isBackToDetalPage = true; 
            renderBackBtn = false;  
            pageBlockTitle = System.label.VPM_Vendor_Match;     
            LaunchScreen= false;
            hideSearchVendor =false;
            sendWebFormScreen =false;
            ScreenVisited.remove(ScreenVisited.size() -1);
           }
           else if(currentScreen == 'vendorList')
          {      
              showSearchVendor = false;
              isBackToDetalPage = false;  
              LaunchScreen= false;
              pageBlockTitle = System.label.VPM_Vendor_Match;   
              hideSearchVendor =true;
              sendWebFormScreen =false;
              ScreenVisited.remove(ScreenVisited.size() -1);
              MDMVendor='';
              VendorNotFound =false;
              isMaintain2 =false;

          }
          else if(currentScreen == 'requestType')
          {
            showSearchVendor = false;
            LaunchScreen= true;
            renderBackBtn = false;
            isBackToDetalPage = true;
            hideSearchVendor =false;
            sendWebFormScreen =false;
            RequestBriefScreen=false;
            BankDetailsScreen = false;  
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
            ScreenVisited.remove(ScreenVisited.size() -1);
          }
             else if(currentScreen == 'VendorMatch')//sendWebForm
          {
            showSearchVendor = false;
            LaunchScreen= true;
            hideSearchVendor =false;
            sendWebFormScreen =false;
            //pageBlockTitle = System.label.VPM_Vendor_Match;   
            //MDMVendor='';
            //isBackToDetalPage = true;  
            ScreenVisited.remove(ScreenVisited.size() -1);
          }
           else if(currentScreen == 'sendWebForm')
          {
            showSearchVendor = false;
            LaunchScreen= true;
            hideSearchVendor =false;
            sendWebFormScreen =false;
            ScreenVisited.remove(ScreenVisited.size() -1); 
          } else if(currentScreen == 'ReviewRequestBrief') {
              showSearchVendor = false;
              LaunchScreen= true;
              hideSearchVendor =false;
              RequestBriefScreen =true;
              ScreenVisited.remove(ScreenVisited.size() -1);
          }
          
          if(ScreenVisited.size() == 0) {
             renderBackBtn = false;
             isBackToDetalPage = true; 
          }
      } catch(exception ex){
        renderBackBtn = false;
      }
      system.debug('@@LaunchScreen' +LaunchScreen);
    
           
        
     }
 
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
    
    
    
      public List<SelectOption> getAuthorization()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
     VPM_PurchasingRequests__c.VPM_GlobalAuthorisationGroup__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }

      public List<SelectOption> getVendorType()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
     VPM_PurchasingRequests__c.VPM_VendorType__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
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
      
    public void webServiceData(VPM_ECCVendorSearchServiceOutput op){ 
       system.debug('@@requestType' +requestType);
       system.debug('@@city' + op.city); 
        // mapping left only for Post Code (PO Box) - VPM_POBoxPostCode

        if(requestType == 'Maintain2' || requestType == 'Maintain' || screenType == 'Maintain') {
            if(op.CompanyCodeFields <> null && op.CompanyCodeFields.size() > 0) { 
                 booleanToStringMethod(op.CompanyCodeFields[0].Blocked, op.CompanyCodeFields[0].Deleted);         
                 //Company code fields
                vendorDetails.VPM_TaxNumAtResponsibleTaxAuthority__c = op.CompanyCodeFields[0].TaxNumberResponsibleAuthority;
                vendorDetails.VPM_AccntWithVendor__c = op.CompanyCodeFields[0].AccntWithVendor;
                vendorDetails.VPM_AccountingClerk__c = op.CompanyCodeFields[0].AccountingClerk;
                vendorDetails.VPM_AccountMemo__c = op.CompanyCodeFields[0].AccountMemo;            
                vendorAccountStatement  =  string.isNotBlank(op.CompanyCodeFields[0].AccountStatement) ? op.CompanyCodeFields[0].AccountStatement : vendorAccountStatement;
                vendorDetails.VPM_AlternativePayee__c = op.CompanyCodeFields[0].AlternativePayee;
                vendorDetails.VPM_BExchangeLimit__c = string.isNotblank(op.CompanyCodeFields[0].BExchangeLimit) ? decimal.valueOF(op.CompanyCodeFields[0].BExchangeLimit) : 0;          
                system.debug('@@vendorCashmgmntgroup' + vendorCashmgmntgroup);
                vendorCashmgmntgroup = string.isNotBlank(op.CompanyCodeFields[0].CashManagementGroup) ? op.CompanyCodeFields[0].CashManagementGroup : vendorCashmgmntgroup;
                vendorQuery1.VPM_CheckDoubleInvoices__c = op.CompanyCodeFields[0].CheckDoubleInvoices <>null?op.CompanyCodeFields[0].CheckDoubleInvoices:false;
                vendorDetails.VPM_ChkCashing__c = op.CompanyCodeFields[0].ChkCashing;
                vendorDetails.VPM_ClerkAtVendor__c = op.CompanyCodeFields[0].ClerkAtVendor;
                vendorDetails.VPM_ClerksFax__c = op.CompanyCodeFields[0].ClerksFax;
                vendorDetails.VPM_ClerksInternet__c = op.CompanyCodeFields[0].ClerksInternet;
                vendorDetails.VPM_ExemptionNumber__c = op.CompanyCodeFields[0].ExemptionNumber;
                vendorGroupingKey = string.isNotBlank(op.CompanyCodeFields[0].GroupingKey) ? op.CompanyCodeFields[0].GroupingKey : vendorGroupingKey;
                vendorDetails.VPM_HouseBank__c = op.CompanyCodeFields[0].HouseBank;
                vendorDetails.VPM_ToleranceGroup__c = op.CompanyCodeFields[0].ToleranceGroup;
                vendorDetails.VPM_ValidUntil__c = string.isNotBlank(op.CompanyCodeFields[0].ValidUntil) ? date.valueOf(op.CompanyCodeFields[0].ValidUntil) : null;
                vendorDetails.VPM_ReconciliationAccount__c = op.CompanyCodeFields[0].ReconciliationAccount;
                vendorDetails.VPM_WithholdingTaxCountryKey__c = op.CompanyCodeFields[0].WithholdingTaxCountryKey;
                //modified for IAPR-600
                vendorPaymentTerms = string.isNotBlank(op.CompanyCodeFields[0].PaymentTerms)? op.CompanyCodeFields[0].PaymentTerms : vendorPaymentTerms;   
                vendorQuery1.VPM_SortKey__c = (string.isNotBlank(op.CompanyCodeFields[0].SortKey)) ? op.CompanyCodeFields[0].SortKey : vendorQuery1.VPM_SortKey__c;
                vendorDetails.VPM_IndicatorClearingBetwCustomerNVendor__c = op.CompanyCodeFields[0].IndicatorClearingBetweenCustomerAndVendor <>null?op.CompanyCodeFields[0].IndicatorClearingBetweenCustomerAndVendor:false;
                vendorDetails.VPM_IndicatorPayItemsSeparately__c = op.CompanyCodeFields[0].IndividualPayment;
                vendorDetails.VPM_InterestCalculationIndicator__c = op.CompanyCodeFields[0].InterestCalculationIndicator;
                vendorDetails.VPM_InterestFrequency__c = op.CompanyCodeFields[0].InterestFrequency;
                vendorDetails.VPM_LastInterestRun__c = string.isNotblank(op.CompanyCodeFields[0].LastInterestRun) ? date.valueOf(op.CompanyCodeFields[0].LastInterestRun): null;
                vendorQuery1.VPM_PaymentMethod__c = string.isNotBlank(op.CompanyCodeFields[0].PaymentMethod) ?op.CompanyCodeFields[0].PaymentMethod :vendorQuery1.VPM_PaymentMethod__c;
                vendorDetails.VPM_PaymentMethodSupplement__c = op.CompanyCodeFields[0].PaymentMethodSupplement;
                //vendorDetails.VPM_PaymentTerms__c = op.CompanyCodeFields[0].PaymentTerms;
                
                vendorDetails.VPM_PmtAdviceByEDI__c = op.CompanyCodeFields[0].PmtAdviceByEDI;
                vendorDetails.VPM_PreviousAccountNumber__c = op.CompanyCodeFields[0].PreviousAccountNumber;
                vendorDetails.VPM_AdoptScanDate__c = op.CompanyCodeFields[0].AdoptScanDate <> null?op.CompanyCodeFields[0].AdoptScanDate :false;
                
                 //Dunning Block
                 if(op.CompanyCodeFields[0].Dunning <> null && op.CompanyCodeFields[0].Dunning.size() > 0) {
                    vendorDetails.VPM_DunningBlock__c = op.CompanyCodeFields[0].Dunning[0].DunningBlock;
                    
                    vendorDetails.VPM_DunningClerk__c = op.CompanyCodeFields[0].Dunning[0].DunningClerk;
                    vendorDetails.VPM_DunningLevel__c = op.CompanyCodeFields[0].Dunning[0].DunningLevel;
                    vendorDetails.VPM_DunnRecipient__c = op.CompanyCodeFields[0].Dunning[0].DunnRecipient;
                    vendorDetails.VPM_LastDunned__c = string.isNotblank(op.CompanyCodeFields[0].Dunning[0].LastDunned) ? date.valueOf(op.CompanyCodeFields[0].Dunning[0].LastDunned) :  null;      
                }
                //WtaxType 
                if(op.CompanyCodeFields[0].WtaxType <> null && op.CompanyCodeFields[0].WtaxType.size() > 0) {
                    vendorDetails.VPM_ExemptionRate__c = decimal.valueOf(op.CompanyCodeFields[0].WtaxType[0].ExemptionRate);
                    vendorDetails.VPM_ExemptionFrom__c = string.isNotBlank(op.CompanyCodeFields[0].WtaxType[0].ExemptionFrom) ? date.valueof(op.CompanyCodeFields[0].WtaxType[0].ExemptionFrom) : null;
                    vendorDetails.VPM_ExemptionTo__c = string.isNotBlank(op.CompanyCodeFields[0].WtaxType[0].ExemptionTo) ? date.valueof(op.CompanyCodeFields[0].WtaxType[0].ExemptionTo) : null;
                    vendorDetails.VPM_WithholdingTaxCode__c = op.CompanyCodeFields[0].WtaxType[0].WithholdingTaxCode;
                    vendorDetails.VPM_IndicatorForWithholdingTaxType__c = op.CompanyCodeFields[0].WtaxType[0].IndicatorForWithholdingTaxType; 
                    //vendorDetails.VPM_Liable__c = op.CompanyCodeFields[0].WtaxType[0].Liable;             
                }
            }
            
            //purchasing org fields
            if(op.PurchasingOrgFields <> null && op.PurchasingOrgFields.size() > 0) {
                vendorDetails.VPM_ABCIndicator__c = op.PurchasingOrgFields[0].ABCIndicator;
                vendorDetails.VPM_AutoEvalGRSetmtDel__c = op.PurchasingOrgFields[0].AutoEvalGRSetmtDel <> null?op.PurchasingOrgFields[0].AutoEvalGRSetmtDel:false;
                vendorDetails.VPM_AutoEvalGRSetmtRet__c = op.PurchasingOrgFields[0].AutoEvalGRSetmtRet <> null?op.PurchasingOrgFields[0].AutoEvalGRSetmtRet:false;
                vendorDetails.VPM_AutomaticPurchaseOrderGeneration__c = op.PurchasingOrgFields[0].AutoGenerationPOAllowed <> null?op.PurchasingOrgFields[0].AutoGenerationPOAllowed:false;
                vendorDetails.VPM_DocIndexActive__c = op.PurchasingOrgFields[0].DocIndexActive<>null?op.PurchasingOrgFields[0].DocIndexActive:false;
                vendorDetails.VPM_GrantDiscInKind__c = op.PurchasingOrgFields[0].GrantDiscInKind <>null?op.PurchasingOrgFields[0].GrantDiscInKind:false;
                vendorDetails.VPM_GRbasedIV__c = op.PurchasingOrgFields[0].GRbasedIV <> null?op.PurchasingOrgFields[0].GRbasedIV:false;
                vendorSchemaGroupVendor = string.isNotblank(op.PurchasingOrgFields[0].SchemaGroupVendor) ? op.PurchasingOrgFields[0].SchemaGroupVendor : vendorSchemaGroupVendor;
                vendorDetails.VPM_SortCriterion__c = op.PurchasingOrgFields[0].SortCriterion;
                vendorIncoterms1 = string.isNotBlank(op.PurchasingOrgFields[0].Incoterms1) ? op.PurchasingOrgFields[0].Incoterms1 : vendorIncoterms1;
                Incoterms2 = string.isNotBlank(op.PurchasingOrgFields[0].Incoterms2) ? op.PurchasingOrgFields[0].Incoterms2 : Incoterms2;
                
                vendorDetails.VPM_PurchasingGroup__c = op.PurchasingOrgFields[0].PurchasingGroup;
                vendorDetails.VPM_RackJobbingServiceAgreed__c = op.PurchasingOrgFields[0].RackJobbingServiceAgreed <>null?op.PurchasingOrgFields[0].RackJobbingServiceAgreed:false;
                vendorDetails.VPM_SalesPerson__c = op.PurchasingOrgFields[0].SalesPerson;
                vendorQuery1.VPM_SRVBasedVendorID__c = op.PurchasingOrgFields[0].SRVBasedVendorID <>null ?op.PurchasingOrgFields[0].SRVBasedVendorID:false;
                vendorDetails.VPM_MinimumOrderValue__c = decimal.valueOf(op.PurchasingOrgFields[0].MinimumOrderValue);
                vendorDetails.VPM_ModeTransportForeignTrade__c = op.PurchasingOrgFields[0].ModeTransportForeignTrade;
                vendorDetails.VPM_OfficeOfEntry__c = op.PurchasingOrgFields[0].OfficeOfEntry;
                vendorDetails.VPM_PricingDateControl__c = op.PurchasingOrgFields[0].PricingDateControl;
                vendorQuery1.VPM_OrderCurrency__c = string.isNotBlank(op.PurchasingOrgFields[0].OrderCurrency) ?op.PurchasingOrgFields[0].OrderCurrency : vendorQuery1.VPM_OrderCurrency__c;
                vendorDetails.VPM_OrderOptimRest__c = op.PurchasingOrgFields[0].OrderOptimRest;
                vendorDetails.VPM_PlannedDeliveryTime__c = decimal.valueOF(op.PurchasingOrgFields[0].PlannedDeliveryTime);
                vendorDetails.VPM_PROATControlProof__c = op.PurchasingOrgFields[0].PROATControlProof;
                //issue in data type Text in SFDC and Boolean in webservice-
                //vendorDetails.VPM_DefaultPartner__c = op.PurchasingOrgFields[0].Functions[0].DefaultPartner;
                vendorDetails.VPM_PartnerFunction__c = op.PurchasingOrgFields[0].Functions[0].PartnerFunction;
                 
            }
             
            vendorDetails.VPM_AccountClerkTelephoneNumber__c = op.AccountClerkTelephoneNumber;
            vendorDetails.VPM_AccountGroup__c = op.AccountGroup;
            vendorDetails.VPM_AccountingNote__c = op.AccountingNote;
            vendorDetails.VPM_AccountingText__c = op.AccountingText;
            vendorDetails.VPM_ActualQMSystem__c = op.ActualQMSystem;
            vendorDetails.VPM_AddressForm__c = op.AddressForm;
            vendorDetails.VPM_AddressTimeZone__c = op.AddressTimeZone;        
            // this field is check box in sfdc vendorDetails.VPM_AlternativePayeeAccountNumber__c = op.AlternativePayeeAccountNumber;
            
            vendorDetails.VPM_ArabiaOldNumber__c = op.ArabiaOldNumber;
            vendorDetails.VPM_ArabicVersion__c = op.ArabicVersion;
            vendorDetails.VPM_Authorization__c = op.Authorization;        
            vendorDetails.VPM_BeneficiaryAddress1__c = op.BeneficiaryAddress1;
            vendorDetails.VPM_BeneficiaryAddress2__c = op.BeneficiaryAddress2;
            vendorDetails.VPM_BeneficiaryAddress3__c = op.BeneficiaryAddress3;
            vendorDetails.VPM_BeneficiaryCountry__c = op.BeneficiaryCountry;
            vendorDetails.VPM_BeneficiaryName__c = op.BeneficiaryName;
            vendorDetails.VPM_BlockFunction__c = op.BlockFunction;        
            
            
            vendorDetails.VPM_CENVAT__c = op.CENVAT;
            vendorDetails.VPM_CertificateWithholdingTaxExemption__c = op.CertificateWithholdingTaxExemption;
            if(string.isNotBlank(op.CertificationDate)) {
                vendorDetails.VPM_CertificationDate__c = date.valueOF(op.CertificationDate);
            }
            vendorDetails.VPM_ChangedBy__c = op.ChangedBy;
            vendorDetails.VPM_Changedon__c = op.Changedon;
     
          
            vendorDetails.VPM_Commissionerate__c = op.Commissionerate;
            vendorDetails.VPM_CompanyPostCode__c = op.CompanyPostCode;
            vendorDetails.VPM_Customer__c = op.Customer;
                
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
            vendorDetails.VPM_ExtensionPhone__c = op.ExtensionPhone;
           
            vendorDetails.VPM_Fax__c = op.Fax;
            vendorDetails.VPM_FaxExtension__c = op.FaxExtension;
            vendorDetails.VPM_FaxNumber2__c = op.FaxNumber2;
            vendorDetails.VPM_FaxNumber3__c = op.FaxNumber3;
            vendorDetails.VPM_FiscalAddress__c = op.FiscalAddress;
            vendorDetails.VPM_FreeText1__c = op.FreeText1;
            vendorDetails.VPM_FreeText2__c = op.FreeText2;
            vendorDetails.VPM_Function__c = op.Function;
            vendorDetails.VPM_HeadOfficeAccountNumber__c = op.HeadOfficeAccountNumber;
            vendorDetails.VPM_TaxSplit__c = op.TaxSplit <>null ?op.TaxSplit:false;
            
            vendorDetails.VPM_TeleBox__c = op.TeleBox;
            vendorDetails.VPM_Telephone__c = op.Telephone;
            vendorDetails.VPM_Telephone2__c = op.Telephone2;
            vendorDetails.VPM_Telephone3__c = op.Telephone3;
            vendorDetails.VPM_TextToInput__c = op.TextToInput;
            vendorDetails.VPM_ThaiOldVendorNumber__c = op.ThaiOldVendorNumber;
            vendorDetails.VPM_ThirdPartyAddress1__c = op.ThirdPartyAddress1;
            vendorDetails.VPM_ThirdPartyAddress3__c = op.ThirdPartyAddress3;
            vendorDetails.VPM_ThirdPartyAddress4__c = op.ThirdPartyAddress4;
            vendorDetails.VPM_ThirdPartyName__c = op.ThirdPartyName;
            vendorDetails.VPM_Title__c = op.Title;        
       
            vendorDetails.VPM_SerRegNo__c = op.SerRegNo;
            vendorDetails.VPM_ServiceAgent__c = op.ServiceAgent;
            vendorDetails.VPM_Sex__c = op.Sex;
            vendorDetails.VPM_ShippingConditions__c = op.ShippingConditions;
            //vendorDetails.VPM_SMSIndicator__c = op.SMSIndicator;
            vendorDetails.VPM_SocialInsurance__c = op.SocialInsurance;
            vendorDetails.VPM_SocialInsuranceCodeSoc__c = op.SocialInsuranceCode;
            vendorDetails.VPM_TaxNumber5__c = op.TaxNumber5;
            vendorDetails.VPM_TaxOfficeIdentification__c = op.TaxOfficeIdentification;
            vendorDetails.VPM_TAXOfficeIdentLangKey__c = op.TAXOfficeIdentLangKey;
            vendorDetails.VPM_SSIStatus__c = op.SSIStatus;
            vendorDetails.VPM_StandardCommMethod__c = op.StandardCommMethod;
            vendorDetails.VPM_Street5__c = op.Street5;
            vendorDetails.VPM_SubsequentSettlement__c = op.SubsequentSettlement;
            vendorDetails.VPM_SubsequentSettlementIndex__c = op.SubsequentSettlementIndex;
            vendorDetails.VPM_TaxBase__c = op.TaxBase;
            vendorTradePartnerType = string.isNotBlank(op.TradePartnerType) ? op.TradePartnerType :vendorTradePartnerType;
           // vendorDetails.VPM_TradePartnerType__c =string.isNotBlank(op.TradePartnerType) ? op.TradePartnerType :vendorTradePartnerType;
            
            options = vendorQuery1.VPM_DeletionBlockFlag__c;
            //vendorTradePartnerType ='ZVN1';
            system.debug('@@ trade partner type' + vendorQuery1.VPM_TradePartnerType__c);
            vendorDetails.VPM_TrainStation__c = op.TrainStation;
            vendorDetails.VPM_TransportZone__c = op.TransportZone;
            vendorDetails.VPM_TurkeyOldNumber__c = op.TurkeyOldNumber;
            vendorQuery1.VPM_VendorType__c = string.isNotBlank(op.TypeVendor) ? op.TypeVendor : vendorQuery1.VPM_VendorType__c;        
            vendorDetails.VPM_UkrainianVersion__c = op.UkrainianVersion;
            vendorDetails.VPM_UnitOfMeasureGrp__c = op.UnitOfMeasureGrp;
           
            vendorDetails.VPM_VATRegistrationNumber2__c = op.VATRegistrationNumber2;
            vendorDetails.VPM_VATRegistrationNumber3__c = op.VATRegistrationNumber3;
           
            
            
            if(op.VendorSubRange <> null && op.VendorSubRange.size() > 0) {
                vendorDetails.VPM_VendorSubRange__c = op.VendorSubRange[0];
            }
          
            
            vendorDetails.VPM_OtherCommunication__c = op.OtherCommunication;
            vendorDetails.VPM_ReasonForExemption__c = op.ReasonForExemption;
            vendorDetails.VPM_RecipientType__c = op.RecipientType;
            vendorDetails.VPM_IndicatorPlantLevelRelevant__c = op.IndicatorPlantLevel <>null?op.IndicatorPlantLevel:false;
            vendorDetails.VPM_IndicatorSubjectToWithholdingTax__c = op.IndicatorSubjectToWithholdingTax;
            vendorDetails.VPM_IndicatorVendorSubRangeRelevant__c = op.IndicatorVendorSubRangeRelevant;
            vendorDetails.VPM_IndividualSpec__c = op.IndividualSpec;
            vendorDetails.VPM_IndonesiaOldVendorNumber__c = op.IndonesiaOldVendorNumber;
            vendorDetails.VPM_Industry__c = op.Industry;
            vendorDetails.VPM_IndustryType__c = op.IndustryType;
            vendorDetails.VPM_InstructionKeyDataExchange__c = op.InstructionKeyDataExchange;
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
            ZIPPostcode = string.isNotBlank(op.ZIPPostCode) ? op.ZIPPostCode:ZIPPostCode;
            
            vendorDetails.VPM_RegStGrp__c = op.RegStGrp;
            // boolean in SFDC vendorDetails.VPM_ReturnsVendor__c = op.ReturnsVendor;
            vendorDetails.VPM_RoundingProfile__c = op.RoundingProfile;
            vendorDetails.VPM_RussianVersion__c = op.RussianVersion;
            vendorDetails.VPM_WithholdingTaxIdentificationNumber__c = op.WithholdingTaxIdentificationNumber;
            vendorDetails.VPM_QMSystemTo__c = string.isNotBlank(op.QMSystemTo) ? date.valueOF(op.QMSystemTo) : null;        
            
           
            vendorDetails.VPM_POBoxCity__c = op.POBoxCity;
            vendorDetails.VPM_PODRelevant__c = op.PODRelevant;
            vendorDetails.VPM_PostalCode2__c = op.PostalCode2;
            vendorDetails.VPM_MinorityIndicators__c = op.MinorityIndicators;
            vendorDetails.VPM_MobilePhone__c = op.MobilePhone;
            vendorDetails.VPM_MobilePhone2__c = op.MobilePhone2;
            vendorDetails.VPM_MobilePhone3__c = op.MobilePhone3;    
            vendorDetails.VPM_LLDCode__c = op.LLDCode;
            vendorDetails.VPM_LSTno__c = op.LSTno;
            // booelan in SFDC vendorDetails.VPM_IndicatorAlternativePayeeAllowed__c = op.IndicatorAlternativePayeeAllowed;
            
            vendorDetails.VPM_NODEL__c = op.NODEL;
            //booelan in sfdc vendorDetails.VPM_NPIVendor__c = op.NPIVendor;
            vendorDetails.VPM_LastExtReview__c = string.isNotblank(op.LastExtReview) ? date.valueOf(op.LastExtReview) : null;        
            vendorDetails.VPM_PaymentTermsKeyCreditMemos__c = op.PaymentTermsKeyCreditMemos;
            vendorDetails.VPM_PermittedPayee__c = op.PermittedPayee;
            vendorDetails.VPM_PlaceOfBirth__c = op.PlaceOfBirth;
            vendorDetails.VPM_OtherCommunication__c = op.OtherCommunication;
            vendorDetails.VPM_OurAccNumWithVendor__c = op.OurAccNumWithVendor;
            vendorDetails.VPM_PANNumber__c = op.PANNumber;
            vendorDetails.VPM_PANreference__c = op.PANreference;
            vendorDetails.VPM_FunctionDescription__c = op.FunctionDescription;
            vendorDetails.VPM_PartnerFunctionName__c = op.PartnerFunctionName;
            vendorDetails.VPM_PartnerFunctions__c = op.PartnerFunctions;
            vendorDetails.VPM_PartnerName__c = op.PartnerName;
            vendorDetails.VPM_PartnerNumber__c = op.PartnerNumber;
            vendorDetails.VPM_PayableLocation__c = op.PayableLocation;
            vendorPaymentBlock = string.isNotBlank(op.PaymentBlock)? op.PaymentBlock : vendorPaymentBlock;
            vendorDetails.VPM_OrderingEmailAddress__c = op.OrderingEmailAddress;
            vendorDetails.VPM_Plant__c = op.Plant; 
            //vendorDetails.VPM_IndicatorCollectionAuthorization__c = op.IndicatorCollectionAuthorization;
            /////////////////////////////////////////////////////////////////////
            purchasingOrg = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PURCHASING_ORG, vendorPurchasingOrg);
            Cashmgmntgroup = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, CASH_MGMT, vendorCashmgmntgroup);
            VenLanguage = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, LANGUAGE, vendorLanguage);
            AccountStatement = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, ACCOUNT_STAT, vendorAccountStatement);
            PaymentBlock = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PAYMEMT_BLOCK, vendorPaymentBlock);
            GroupingKey  = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, GROUPING_KEY, vendorGroupingKey);
            Incoterms1 = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, INCOTERMS_1, vendorIncoterms1);
            SchemaGroupVendor = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, SCHEMA_GRP,vendorSchemaGroupVendor);
            //modifeid for IAPR-600
            paymentTerms = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,PAYMENT_TERMS,vendorPaymentTerms);
            standardNumber= getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,STANDARD_NUMBER,vendorStandardNumber);
            internationalVersion =getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,INT_VERSION,vendorIntVersion);
            tradePartnerType = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c,TRADE_PARTNER_TYPE,vendorTradePartnerType);   
            
            
        }
        vendorDetails.VPM_CorporateGrp__c = op.CorporateGrp;
        vendorDetails.VPM_Customer__c = op.Customer;
        //vendorDetails.VPM_VendorName1__c = op.VendorName1; 
        VendorName = string.isNotBlank(op.VendorName1) ? op.VendorName1 : VendorName;
        Street1 = string.isNotBlank(op.Street1) ? op.Street1 : Street1;
        searchterm1 = string.isNotBlank(op.SearchTerm1) ? op.SearchTerm1:searchterm1;
        vendorDetails.VPM_VendorCode__c = op.VendorCode;
        vendorDetails.VPM_VendorName1__c = op.VendorName1;
        vendorDetails.VPM_VendorName2__c = op.VendorName2;
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
        vendorQuery1.VPM_TaxJurisdictionCode__c = string.isNotBlank(op.TaxJurisdictionCode) ?op.TaxJurisdictionCode:vendorQuery1.VPM_TaxJurisdictionCode__c;
        Street1 = string.isNotBlank(op.Street1) ? op.Street1:Street1;
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
        VPM_SearchVendor1.CheckFlag =true;
                
        
        //// updating for web service data for default
        updateVendorReqRecord();             
    }


    public string region(){
    
        try{
            VPM_Region__c region =[select VPM_Code__c,Name,id from VPM_Region__c where VPM_Code__c=:op.region limit 1];
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
    
      
    public void SaveMethod() 
    {  
    System.debug('Save Method'); 
        
        system.debug('PAYMENT terms' + vendorPaymentTerms);
        update vendorquery1;
        ApexPages.Message msg = checkValidations();
        system.debug('@@ msg' + msg);
        if(msg<> null ) {
         system.debug('Save Method inside error msg'); 
           ApexPages.addMessage(msg);
        }else {
            updateVendorReqRecord();
            
            /*if(sendWebFormScreen){
                ScreenVisited.add('requestType');
            }*/
            backBtnAction();  
        }  
         system.debug('trade partner type' +vendorQuery1.VPM_TradePartnerType__c);      
    }    
    
     

    public void updateVendorReqRecord() {
        try
        {
            system.debug('@@ updateVendorReqRecord is called');
            vendorQuery1.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
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
            //VPM_SearchVendor1.CheckFlag =true; 
            // 22 08 2016 : Changes By Samrin to Set VPM_VendorBlockUnblockDelete__c for the secodn time when user click on back button 
             vendorQuery1.VPM_VendorBlockUnblockDelete__c= VPM_VendorBlockUnblockDelete== null?VPM_VendorBlockUnblockDelete: vendorQuery1.VPM_VendorBlockUnblockDelete__c;
          
          
          //vendorQuery1.VPM_VendorBlockUnblockDelete__c = VPM_VendorBlockUnblockDelete;
         
            vendorQuery1.VPM_VendorName1__c = VendorName;
            vendorQuery1.VPM_SearchTerm_1__c = searchTerm1;
            vendorQuery1.VPM_Incoterms2__c = Incoterms2;
            vendorQuery1.VPM_Country__c = countryName; //modified by vaishali nagar for IAPR-605
            vendorQuery1.VPM_PaymentTerms__c = vendorPaymentTerms;  
            vendorQuery1.VPM_TradePartnerType__c = vendorTradePartnerType;
            vendorQuery1.VPM_InternationalVersion__c = vendorIntVersion;
            vendorQuery1.VPM_StandardNumber__c = vendorStandardNumber;
             System.debug('@@@@@@  vendorQuery1 ------'+vendorQuery1);  
            update vendorQuery1;
          
            //update vendorQuery1.VPM_Commodity__r;
            
            system.debug('@@ options  --------'+ options  );
            if(options != null) {
                vendorDetails.VPM_DeletionBlockFlag__c= options;
            }           
            vendorDetails.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
            vendorDetails.RecordTypeId = VPM_RecordTypeHelper.getRecordTypeNameById(requestType);
            update vendorDetails;             
            vendorReq.save();
        }
        catch(exception ex){ 
            system.debug('@@Exception- ' + ex.getstacktracestring());
            system.debug('@@Exception- ' + ex.getMessage());
        }
        
        
    }
    
    public void SendWebformMethod() {
        if(MDMVendor =='SendResendWebform')  {
            pageBlockTitle = '';  
            LaunchScreen = true;
            isBackToDetalPage = true;
            renderBackBtn = false;
            Goldendata2Screen2 = false;
            Goldendata2Screen = false;            
        } else {
            pageBlockTitle = 'Golden Data Screen';      
            //QueryVendorRequest(); 
            LaunchScreen = false;
            Goldendata2Screen = true;
        }
            isExitButtonVisible = false;
            isRequiredField=true;
            isButtonVisibleSaveMenu = false;
            isButtonVisibleSaveExit = false;
            isGoldendataButtonVisible = false;
            isButtonVisible = false;
            BankDetailsScreen = false;
            paymentTermScreen = false;
            sendWebFormScreen =false;
            RequestBriefScreen = false;
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
    
    public void GoldenDataSave() {
        system.debug('Golden Data Save method is called');        
        pageBlockTitle = 'Golden Data Screen';   
        LaunchScreen = false;        
        Goldendata2Screen2 = true;
        Goldendata2Screen = false;          
        isExitButtonVisible = false;
        isRequiredField=true;
        isButtonVisibleSaveMenu = false;
        isButtonVisibleSaveExit = false;
        isGoldendataButtonVisible = false;
        isButtonVisible = false;
        BankDetailsScreen = false;
        paymentTermScreen = false;
        sendWebFormScreen =false;
        RequestBriefScreen = false;
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
        system.debug('@@vendorQuery1' +vendorQuery1);
        commodityLookupChanges();
         
    }

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
                LaunchScreen = true;
                Goldendata2Screen = false;
                Goldendata2Screen2 = false;
                isExitButtonVisible = false;
                isRequiredField=true;
                isButtonVisibleSaveMenu = false;
                isButtonVisibleSaveExit = false;
                isGoldendataButtonVisible = false;
                isButtonVisible = false;
                BankDetailsScreen = false;
                paymentTermScreen = false;
                sendWebFormScreen =false;
                RequestBriefScreen = false;
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
                //vendorQuery1.VPM_TradePartnerType__c = vendorDetails.VPM_TradePartnerType__c;
                //vendorQuery1.VPM_VendorType__c = vendorDetails.VPM_VendorType__c;
                //vendorQuery1.VPM_GlobalAuthorisationGroup__c = vendorDetails.VPM_GlobalAuthorisationGroup__c;
               
                update vendorQuery1;
                populateCustomMetdata();
            }
            
    }
    
    
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
     
      public boolean getButtonVisible() {
          isButtonVisible = false;
          if(BankDetailsScreen || unblockUnDelScreen || paymentTermScreen || generalVendorDetails || financialScreen  || blockDelScreen || regionalSpecificScreenSirius || regionalSpecificScreenCordillera || regionalSpecificScreenFusion || regionalSpecificScreenU2K2) {
              //if(options == null)  //this logic will remove save and return button from block/unblock Page                 
                  isButtonVisible = true;                      
          }
          return isButtonVisible;
      } 
   
      public PageReference backToDetailPage() {
          Pagereference pg =  new Pagereference('/'+recId); 
          pg.setRedirect(true);
          return pg; 
      }
      
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
    
    public boolean getExitButtonVisible() {
        isExitButtonVisible = false;
        if(VendorNotFound) {
            isExitButtonVisible = true;
        }
        
        return isExitButtonVisible;
    }
    
    public boolean getButtonVisibleSaveMenu() {
        isButtonVisibleSaveMenu = false;        
        if(BankDetailsScreen || unblockUnDelScreen || blockDelScreen ||  paymentTermScreen || generalVendorDetails || financialScreen || regionalSpecificScreenSirius || regionalSpecificScreenCordillera || regionalSpecificScreenFusion || regionalSpecificScreenU2K2) {
            
            isButtonVisibleSaveMenu = true;                      
        }
        return isButtonVisibleSaveMenu;
    }
    
    public boolean getButtonVisibleSaveExit() {
        isButtonVisibleSaveExit = false;
        if(BankDetailsScreen || paymentTermScreen || generalVendorDetails || financialScreen  || regionalSpecificScreenSirius || regionalSpecificScreenCordillera || regionalSpecificScreenFusion || regionalSpecificScreenU2K2) {
            
            isButtonVisibleSaveExit = true;                      
        }
        return isButtonVisibleSaveExit;
    }
    
    
    
    public ApexPages.Message checkValidations() {    
        system.debug('@@ Check Validations Called');
        system.debug('@@vendorPurchasingOrg' +vendorPurchasingOrg);
        ApexPages.Message myMsg = null;
        
        if(showSearchVendor) {
            if(string.isBlank(VendorName))
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);
            /*if(string.isNotBlank(VendorName) && !VendorName.isAlphaSpace()) 
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Vendor Name : Please enter valid characters'); */
            if(string.isNotBlank(VendorName) && VendorName.length() < 3) 
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.label.VPM_VendorNameLengthPageMessage);            
        }
        
        if(generalVendorDetails || (regionalSpecificScreenSirius || regionalSpecificScreenU2K2 )) {
            if(string.isNotBlank(vendorDetails.VPM_VendorName1Int__c) || string.isNotBlank(vendorDetails.VPM_VendorName2Int__c)
             ||string.isNotBlank(vendorDetails.VPM_VendorName3Int__c) || string.isNotBlank(vendorDetails.VPM_VendorName4Int__c)
             ||string.isNotBlank(vendorDetails.VPM_Street1Int__c) || string.isNotBlank(vendorDetails.VPM_Street2Int__c)
             ||string.isNotBlank(vendorDetails.VPM_Street3Int__c) || string.isNotBlank(vendorDetails.VPM_Street4Int__c)
             ||string.isNotBlank(vendorDetails.VPM_HouseNumberInt__c) || string.isNotBlank(vendorDetails.VPM_SearchTerm1Int__c) 
             ||string.isNotBlank(vendorDetails.VPM_PostCodeInt__c) || string.isNotBlank(vendorDetails.VPM_CityInt__c)
             || string.isNotBlank(vendorDetails.VPM_CountryInt__c)) {
                 if(isInternationalVersionRendered){
                    isInternationalVersionCollapsed = false;
                    if(string.isBlank(vendorDetails.VPM_InternationalVersion__c)){
                      myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, system.label.VPM_International1);
                   }                   
                  
                }
            }            
        }
        
        if(generalVendorDetails){
            
            if(string.isBlank(VendorName))
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);            
            if(string.isNotBlank(VendorName) && VendorName.length() < 3) 
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.label.VPM_VendorNameLengthPageMessage);  
            if(string.isBlank(CountryName)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CountryPagemessage);
            
            }if (string.isBlank(Street1)) {
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_Street1PageMessage);
            }
            
            if(string.isBlank(vendorQuery1.VPM_VendorType__c)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_VendorTypeMessage);
            }
            if(string.isBlank(vendorQuery1.VPM_GlobalAuthorisationGroup__c)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_GlobalAuthorisationGrpPageMessage);
            }
            
           //modified by vaishali Nagar for IAPR-605
           
           system.debug('@@ LATAm Countries:' + obj);
           latam = obj.VPM_CountryName__c;
            system.debug('Vendor country' + CountryName);
            if(CountryName <> null)
            {
                if(latam.contains(CountryName) && string.isBlank(vendorQuery1.VPM_TaxNumber1__c)){
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Tax Number 1 Cannot be left blank');
                } 
                
            }
            
            
           /* List<String> LList = latam.split(',');
            system.debug('@@ LList' + LList);
            
            for(string s:LList){
                if(vendorQuery1.VPM_Country__c == s){
                    isreqtax1 = true;
                }
                else
                    isreqtax1 = false;
            
            
            }*/
            
            //modified by vaishali Nagar for IAPR-605
            if(vendorQuery1.VPM_CompanyCode__r.ECC__c =='Cordillera' && string.isBlank(vendorQuery1.VPM_TaxJurisdictionCode__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Tax Jurisdiction Code Cannot be left blank');
            
            }
            //modified for IAPR-575
            else if(string.isNotBlank(vendorQuery1.VPM_VATRegistrationNumber2__c) && string.isBlank(vendorQuery1.VPM_VATCountry__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VATCountrypageMessage);  
            }  
            system.debug('@@ latam' + latam);
        
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
            
                if(vendorQuery1.VPM_ECC__c !='U2K2' && string.isNotBlank(vendorIncoterms1) && string.isBlank(Incoterms2)){
                    
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_Incoterms2PageMessage);                
                
                }
                
                if(string.isBlank(vendorPaymentTerms)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentTermsPageMessage);
                }
                
                if(string.isBlank(vendorQuery1.VPM_OrderCurrency__c)){
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPMOrderCurrencyPageMessage);
                }
        }
        
        if(BankDetailsScreen){
        
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
        
        
        if(Goldendata2Screen2){
        
        
        system.debug('@@ inside Goldendata2Screen2');
            if(string.isBlank(vendorQuery1.VPM_VendorType__c)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_VendorTypeMessage);
            }
            
            else if(string.isNotBlank(vendorQuery1.VPM_VendorType__c)){
            
                if(string.isBlank(vendorQuery1.VPM_GlobalAuthorisationGroup__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_GlobalAuthorisationGrpPageMessage);
                }
            }
            
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
        
        if(vendorCashmgmntgroup =='None' ||string.isBlank(vendorCashmgmntgroup)){
        
             system.debug('@@ cash management group');
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_CashManagementGroupPageMessage);
             
            }     
            
        if(vendorQuery1.VPM_CheckDoubleInvoices__c == null) {  
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CheckDoubleInvoicesPageMessage);
                //vendorDetails.VPM_CheckDoubleInvoices__c.addError('You must enter a value');
         }   
         
          if(vendorQuery1.VPM_PaymentMethod__c =='None' ||string.isBlank(vendorQuery1.VPM_PaymentMethod__c)){
        
             
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentMethodPageMessage);
             
            } 
         if(vendorQuery1.VPM_SortKey__c =='None' ||string.isBlank(vendorQuery1.VPM_SortKey__c)){
        
             
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_SortKeyPageMessage);
             
            } 
        }
        
        
        return myMsg;
    }
    
    
     public void booleanToStringMethod(boolean blocked, boolean deleted) {
         
         System.debug('@@@@@@@ inside booleanToStringMethod ');
         VPM_VendorBlockUnblockDelete = '';
         if(blocked && deleted) {
             VPM_VendorBlockUnblockDelete = 'Blocked' + 'Deleted';
         }else if(!blocked && deleted) {
             VPM_VendorBlockUnblockDelete = 'Deleted';
         }else if(blocked && !deleted) {
             VPM_VendorBlockUnblockDelete = 'Blocked';
         }
         System.debug('@@@@@@@ End  booleanToStringMethod ' + VPM_VendorBlockUnblockDelete);
     }
         
    
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
    
    public void populateCustomMetdata() {
        system.debug('@@populateCustomMetdata is called');
        /*for(VPM_VendorRequestDefaultValues__mdt vendorMDT : [select id , VPM_CSB__c,VPM_PaymentMethod__c,VPM_CompanyCode__c,VPM_CashManagementGroup__c,VPM_ReconciliationAccount__c,VPM_SortKey__c,VPM_VendorSubType__c,VPM_VendorType__c from VPM_VendorRequestDefaultValues__mdt]) {
            if(vendorMDT.VPM_CompanyCode__c == vendorQuery1.VPM_CompanyCode__r.VPM_CompanyCode__c && vendorMDT.VPM_VendorSubType__c == vendorQuery1.VPM_Vendor_SubType__c && vendorMDT.VPM_VendorType__c == vendorQuery1.VPM_VendorType__c) {
                vendorQuery1.VPM_CashManagementGroup__c = vendorMDT.VPM_CashManagementGroup__c;
				vendorQuery1.VPM_PaymentMethod__c = vendorMDT.VPM_PaymentMethod__c;
				vendorQuery1.VPM_ReconciliationAccount__c = vendorMDT.VPM_ReconciliationAccount__c;
				vendorQuery1.VPM_SortKey__c = vendorMDT.VPM_SortKey__c;
                system.debug('@@vendorMDT' +vendorMDT);
            }    
        }*/
        
        VPM_PurchasingRequests__c vendorQuery2 = [select id , VPM_CashManagementGroup__c,VPM_PaymentBlock__c, VPM_PaymentMethod__c, VPM_ReconciliationAccount__c, VPM_SortKey__c from  VPM_PurchasingRequests__c where id = : recId];
		vendorQuery1.VPM_PaymentMethod__c = vendorQuery2.VPM_PaymentMethod__c;
        vendorPaymentBlock = vendorQuery2.VPM_PaymentBlock__c;
        vendorCashmgmntgroup = vendorQuery2.VPM_CashManagementGroup__c;
        Cashmgmntgroup = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, CASH_MGMT,vendorCashmgmntgroup);
        vendorDetails.VPM_ReconciliationAccount__c = vendorQuery2.VPM_ReconciliationAccount__c;
        vendorQuery1.VPM_SortKey__c = vendorQuery2.VPM_SortKey__c;
        
    }
    
    public void commodityLookupChanges() { 
        
        VPM_CommodityCode__c comm = [select id ,VPM_CSBVendor__c, name,VPM_CommodityCode__c, VPM_AuthorisationGroup__c, VPM_VendorType__c from VPM_CommodityCode__c where id = : vendorQuery1.VPM_Commodity__c];
        system.debug('@@comm' + comm);
		commodityCBSFlag = comm.VPM_CSBVendor__c;
        vendorQuery1.VPM_VendorType__c = comm.VPM_VendorType__c; 
        vendorQuery1.VPM_GlobalAuthorisationGroup__c = comm.VPM_AuthorisationGroup__c;
        system.debug('@@vendorTradepartnerType' +vendorTradepartnerType);
           VPM_SearchVendor1.CheckFlag =true; 
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
        //update vendorQuery1;
    }
  }