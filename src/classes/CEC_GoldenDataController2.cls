public class CEC_GoldenDataController2 {

    public VPM_PurchasingRequests__c entity{get;set;}
    public VPM_CommodityCode__c commodityCodeVar{get;set;}
    public VPM_PurchasingRequests__c purchReqVar{get;set;}
    public VPM_PurchasingRequests__c pr{get;set;}
    public boolean isU2k2{get;set;}
    public boolean isFusion{get;set;}
    Public Boolean isInputField{get;set;}
    Public Boolean isOutputField{get;set;}
    Public Boolean isReqSpend {get;set;}
    //public Boolean isU2K2{get;set;}
    public Boolean isRequired{get;set;}
    public Boolean isRequiredFieldCountry{get;set;}
    public Boolean isRequiredtax1{get;set;} //modified for IAPR-605
    public boolean isrequiredtaxJurCode{get;set;} //modified for IAPR-605
    public Boolean isRequiredIncoterms2{get;set;}
    public Boolean isRequiredSpend{get;set;}
    public Boolean isCreate{get;set;}   
    public boolean isMaintainRecord{get;set;} 
    public static final string VENDOR_COUNTRY = 'BR_Brazil';
    public  List<SelectOption> purchasingOrg{get;set;}
    public string vendorPurchasingOrg{get;set;}
    public  List<SelectOption> CashManagementGrp{get;set;}
    public  List<SelectOption> tradePartnerTypeList{get;set;}
    public  string tradepartnerType{get;set;}
    public string vendorCashManagementGrp{get;set;}
    public string accountGroup{get;set;}  
    public string isRequiredField{get;set;}
    public Id purid{get;set;}
    public string userlang{get;set;}  
    public boolean vendorType{get;set;}
    public boolean authorisationGrp{get;set;}
    public boolean isReqOrderingEmail {get;set;} //changes for IAVMD-1271
    public boolean showOrderingEmail{get;set;}  //changes for IAVMD-1271
    public string vendorCode{get;set;}
    public string vendorName{get;set;}
    public string searchTerm1{get;set;}
    public string recordTypeId{get;set;}
    public string GlobalAuthorisationGroup {get;set;}
    public boolean Errormsgblock {get;set;}
    Public boolean GoldenDatablock{get;set;}
    
    public  list<VPM_CommodityApprover__c> lstCommodityApprover {get;set;}
    public VPM_ECCVendorSearchServiceOutput op;
    public string s;
    
   
   // public List<ApprovalFlagWrapper> lst {get;set;}
    //public List<ApprovalFlagWrapper> display_list {get; set;} 
   
    public static final string PURCHASING_ORG = 'Purchasing Organisation';
    public static final string CASH_MGMT = 'Cash mgmnt group';
    public static final string PAYMENT_TERMS = 'Payment Terms';
    public static final string TRADE_PARTNER_TYPE='TradePartnerType';
    public static final string TAX_JURIDICATION_CODE = 'Tax Jurisdiction Code';
    public static final string INDUSTRY = 'Industry';
    
    public  List<SelectOption> paymentTerms{get;set;}
    public string vendorPaymentTerms{get;set;}
    
    public  List<SelectOption> taxJuriCodeOptions{get;set;}
    public string taxJuriCodeDefValue{get;set;} 
    
    public  List<SelectOption> industryOptions{get;set;}
    public string industryOptionsDefValue{get;set;} 
    
    public  List<SelectOption> PaymentMethod{get;set;}
    public string vendorPaymentMethod{get;set;}
    public List<string> paymentMethodDefaultValue{get;set;}
    
    VendorRequest__c obj = VendorRequest__c.getInstance('Countries');
    public string latam;
    
    string NewCashManagementGroup {get; set;} 
    string OldCashManagementGroup {get; set;} 
    string NewSortKey {get; set;} 
    string OldSortKey {get; set;} 
    string NewPaymentTerms {get; set;} 
    string OldPaymentTerms {get; set;} 
    string OldPaymentMethod{get;set;}
    string NewPaymentMethod{get;set;}               
    
    ApexPages.StandardController newController;

    public CEC_GoldenDataController2(ApexPages.StandardController controller) 
    {
     userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
        system.debug('@@userlang=' +userlang);
        entity = (VPM_PurchasingRequests__c)controller.getRecord();
        
        newController = controller;
    try
    {
        purchReqVar = [SELECT Id,VPM_TaxJurisdictionCode__c,VPM_Industry__c,VPM_IsLock__c,VPM_Status__c, VPM_VendorType__c,VPM_TradePartnerType__c,VPM_Commodity__c ,VPM_Commodity_Family__c,recordTypeId,
                       VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,VPM_Street1__c,VPM_CheckDoubleInvoices__c,VPM_VendorContactDetail__c,
                       VPM_ProcurementApprovalRequired__c,VPM_Location__c,VPM_City__C,VPM_TaxNumber1__c ,VPM_ExtensionType__c,
                       VPM_OrderingEmailAddress__c,VPM_PaymentTerms__c,VPM_BankCountryKey__c,VPM_Country__c,VPM_Fieldtype__c,VPM_ClerksInternet__c,
                       VPM_BankKey__c,VPM_BankAccountNumber__c,VPM_AccountHolderName__c,VPM_PurchasingOrg__c,VPM_PurchasingOrg__r.Name,
                       VPM_Commodity__r.VPM_VendorType__c,VPM_Commodity__r.VPM_AuthorisationGroup__c, VPM_CompanyCode__r.VPM_CountryCode__c, VPM_CompanyCode__r.VPM_Country__c,
                       VPM_ReferenceSpecificationsBankDetail__c,VPM_WebformSentToVendor__c,VPM_ShowWarning__c,VPM_VendorWebformSubmitted__c,VPM_BankControlKey__c,
                       VPM_IBAN__c,VPM_CollectionAuthorization__c,VPM_Commodity__r.VPM_CommodityCode__c,
                       VPM_PartnerBankType__c,VPM_BankName__c,VPM_SwiftKey__c,VPM_Commodity__r.Name,
                       VPM_ReconciliationAccount__c,VPM_PaymentMethod__c,VPM_VendorName1__c,VPM_SearchTerm_1__c,
                       VPM_GRbasedIV__c,VPM_AutomaticPurchaseOrderGeneration__c,VPM_AlreadyAvailableSupplierUse__c,
                       VPM_PaymentBlock__c,VPM_DeletionBlockFlag__c,VPM_AccountGroup__c,// 20 Oct VPM_TaxJurisdictionCode__c,
                       VPM_GlobalAuthorisationGroup__c,RecordType.DeveloperName,VPM_CountryRequestingVendor__c,
                       VPM_Commodity__r.VPM_CommodityFamily__c,VPM_Is_changed_VAT__c,VPM_Company_Code_Value__c,
                       VPM_CashManagementGroup__c, VPM_PurchasingOrganisation__c,VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,
                       VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c,VPM_PaymentMethodWeb__c,
                       VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,VPM_Spend__c,VPM_Commodity__r.VPM_CommodityClass__c,
                       VPM_Incoterms1__c,VPM_CompanyCode__r.ecc__c,VPM_SortKey__c,VPM_VendorBlockUnblockDelete__c
                       FROM VPM_PurchasingRequests__c WHERE Id =: entity.id];                       
        System.debug('@@purchReqVar ' + purchReqVar );     
        
        
        vendorPaymentMethod = '';            
        //PaymentMethod = getPicklistValues(paymentMethodDefaultValue); 
        PaymentMethod = paymentMathodMetaData(null); 
        taxJuriCodeDefValue = purchReqVar.VPM_TaxJurisdictionCode__c;
        industryOptionsDefValue = purchReqVar.VPM_Industry__c;
        VendorName = purchReqVar.VPM_VendorName1__c;
        searchTerm1 = purchReqVar.VPM_SearchTerm_1__c;
        if(string.isBlank(searchTerm1))
        searchTerm1 = string.isNotBlank(VendorName) ? VendorName.left(10) : '';
        isFusion = false;
        isU2k2 = false;
        
       //IAVMD-1340 - logic start
       if((purchReqVar.VPM_IsLock__c ) || (purchReqVar.VPM_Status__c.contains('MDM') || purchReqVar.VPM_Status__c.contains('Review')) ) {
                isInputField = false;
                isOutputField = true;
             } else{ 
                isInputField = true;
                isOutputField = false; 
        }
        // IAVMD - 1340 - End 
        
        //Added by Epsita 
          if(purchReqVar.VPM_WebformSentToVendor__c == true && purchReqVar.VPM_VendorWebformSubmitted__c == false){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,System.label.VPM_Record_Submit_Warning));
           }
        
         if(purchReqVar.VPM_CashManagementGroup__c<>null)
        vendorCashManagementGrp = purchReqVar.VPM_CashManagementGroup__c;
        system.debug('@@ vendorCashManagementGrp' + vendorCashManagementGrp);
        //purchasingOrg = getPurchasingOrgItems();
        vendorPurchasingOrg = purchReqVar.VPM_PurchasingOrganisation__c;
        tradepartnerType=purchReqVar.VPM_TradePartnerType__c;
        vendorPaymentTerms = purchReqVar.VPM_PaymentTerms__c;
         
        Errormsgblock= false ;
        GoldenDatablock=true;// Make golden data section Avaliable by default
        //Make spend field required only when commodity code starts with 0
        //isRequiredSpend =true; // by default shld always be required
        //Changed by Epsita - IAPR- 638 || Spend should not be mandatory for Non-Ariba Commodities
        isRequiredSpend = false;
        if(string.isNotBlank(purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c) && purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c.startsWith('0'))                  
            isRequiredSpend = false;
        else                
            isRequiredSpend =true;            
        
        //changes for IAVMD-1271
        
        recordTypeId = VPM_RecordTypeHelper.getLaunchScreenVariable('',purchReqVar.RecordTypeId);
        if(recordTypeId =='Create' || recordTypeId=='Extend'){
              if(string.isNotBlank(purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c) && !(purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c.startsWith('0')) && !(purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('MBS--Other')))                  
              {
                  isReqOrderingEmail = true;
                  showOrderingEmail = true;
              }else
              {
                  isReqOrderingEmail =false;
                  showOrderingEmail = false;
              }
            
        } 
        
        // added by Piyush 10/20/2016
        if(purchReqVar.VPM_CompanyCode__r.ECC__c == 'Fusion') 
        	isFusion=true;
       else
        	isFusion=false;
        
        if(purchReqVar.VPM_CompanyCode__r.ECC__c == 'U2K2') 
        	isU2k2 = true;
       else
        	isU2k2 = false;
        
       //make spend visible for create and global extend
            
        if(recordTypeId=='Create' || (recordTypeId=='Extend' && purchReqVar.VPM_ExtensionType__c=='Global'))
        {
           isReqSpend=true;
            
        } else
            isReqSpend=false;
        
            
        if(purchReqVar.VPM_CompanyCode__r.ecc__c <> '' && purchReqVar.VPM_CompanyCode__r.ecc__c <> null)
            entity.VPM_ECC__c = purchReqVar.VPM_CompanyCode__r.ecc__c;
        
        system.debug('@@ ECC' + entity.VPM_ECC__c);
        
        
        if(string.isNotBlank(purchReqVar.VPM_VendorContactDetail__c)){        
            if(string.isBlank(purchReqVar.VPM_OrderingEmailAddress__c))
                entity.VPM_OrderingEmailAddress__c = purchReqVar.VPM_VendorContactDetail__c;
            
            if(string.isBlank(purchReqVar.VPM_ClerksInternet__c))
                entity.VPM_ClerksInternet__c = purchReqVar.VPM_VendorContactDetail__c;
        }
        
        system.debug('recordTypeId '+recordTypeId );
         system.debug('isCreate '+isCreate );
         if(recordTypeId =='Create')
           isCreate = true;
         else
           isCreate = false;
        
        purid = entity.id;
        
        
        purchasingOrg = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, PURCHASING_ORG,vendorPurchasingOrg);
        CashManagementGrp = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, CASH_MGMT,vendorCashManagementGrp);
        paymentTerms = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, PAYMENT_TERMS,vendorPaymentTerms);
        tradePartnerTypeList = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,TRADE_PARTNER_TYPE,tradepartnerType);
        taxJuriCodeOptions = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,TAX_JURIDICATION_CODE,taxJuriCodeDefValue);
        industryOptions = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,INDUSTRY,industryOptionsDefValue);
        
        if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera'){        
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c;
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion'){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeFusion__c;
            
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeSirius__c;
            
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2'){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c;
            
        }
        system.debug('@@ vendorCode'+vendorCode);
        
        if(purchReqVar.VPM_Incoterms1__c <> '' && purchReqVar.VPM_Incoterms1__c <> null)
            entity.VPM_Incoterms1__c =purchReqVar.VPM_Incoterms1__c;
        
        system.debug('@@ entity.VPM_Incoterms1__c' + entity.VPM_Incoterms1__c);
        
        
        accountGroup= entity.VPM_AccountGroup__c == null?'': entity.VPM_AccountGroup__c;
        system.debug('####accountGroup '+accountGroup);
        
        
        IF(accountGroup.containsIgnoreCase('ZGS1'))
            isRequired=true;
        else
            isRequired=false;
        
        if(entity.VPM_Incoterms1__c!='' && entity.VPM_Incoterms1__c!=null){
            isRequiredIncoterms2=true;
        }else{
            isRequiredIncoterms2 = false;
        }
            
        //modified for IAPR-605
         system.debug('@@ LATAm Countries:' + obj);
         latam = obj.VPM_CountryName__c;
        
        system.debug('@@ LATAm Countries:' + latam);
        IF(purchReqVar.VPM_Country__c == VENDOR_COUNTRY)
        {
            isRequiredFieldCountry = true;
            
        }
        else {
            isRequiredFieldCountry = false;  
            
        }           
        if(purchReqVar.VPM_Country__c == VENDOR_COUNTRY || latam.contains(purchReqVar.VPM_Country__c))
        {
            
                isRequiredtax1 = true;
        }else
                isRequiredtax1 = false;

       
        //modified for IAPR-605
        
        if(purchReqVar.VPM_CompanyCode__r.ECC__c =='Cordillera' && purchReqVar.VPM_Country__c == VENDOR_COUNTRY){
            
               isrequiredtaxJurCode = true;
            
        }else
              isrequiredtaxJurCode = false;
        
        vendorCashManagementGrp = purchReqVar.VPM_CashManagementGroup__c;
        vendorPurchasingOrg = purchReqVar.VPM_PurchasingOrganisation__c;
        //vendorPaymentTerms = purchReqVar.VPM_PaymentTerms__c;
        // Service call for Apporval Method  for Maintain record Type 
        if(purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain')   
        {
            system.debug('@@web service is called');
            op = FetchVendorDeatilSAPService(vendorCode,purchReqVar.VPM_CompanyCode__r.ecc__c,purchReqVar.VPM_Company_Code_Value__c, purchReqVar.VPM_PurchasingOrg__r.Name);
            System.debug('@@@@@@@ op ---------'+ op); 
        }
   
       
    }
    catch(exception ex){}
    
       
    }
    
    public List<SelectOption>  getRegionSpecificCustomSettingvalues(string ecc, string pickListName,string defaultValue){
            Map<String, VPM_RegionSpecificFields__c> settingMap = new Map<String, VPM_RegionSpecificFields__c>();
            Map<String, VPM_RegionSpecificFields__c> VPM_RegionSpecificMap = VPM_RegionSpecificFields__c.getAll();
            List<String> settingList = new List<String>();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
              if(string.isNotBlank(defaultValue)) {
                options.add(new SelectOption(defaultValue,defaultValue));
            }
            for(VPM_RegionSpecificFields__c region : VPM_RegionSpecificMap.values()) {
                if(region.Region__c == ecc && region.Picklist_Name__c == pickListName && region.Picklist_Values__c!=defaultValue){
                    settingMap.put(region.Picklist_Values__c,region);
                }
            }
            // sorting based on values 
            settingList.addAll(settingMap.keySet());
            settingList.sort();
            system.debug('@@ settingList' + settingList);
            if(settingList <> null && settingList.size() > 0) {         
                for (String stateName : settingList) {
                    VPM_RegionSpecificFields__c state = settingMap.get(stateName);
                    system.debug('@@ state' + state.Picklist_Values__c);
                    options.add(new SelectOption(state.Picklist_Values__c, state.Picklist_Values__c));
                }
                
               /* if(pickListName =='Payment Terms')
                {
                    if(purchReqVar.VPM_PaymentTerms__c != null && purchReqVar.VPM_PaymentTerms__c.length()==4)
                    options.add(new SelectOption( purchReqVar.VPM_PaymentTerms__c,  purchReqVar.VPM_PaymentTerms__c));
                }else if(pickListName =='TradePartnerType'){
                     if(purchReqVar.VPM_TradePartnerType__c != null && purchReqVar.VPM_TradePartnerType__c.length()==4)
                    options.add(new SelectOption( purchReqVar.VPM_TradePartnerType__c, purchReqVar.VPM_TradePartnerType__c));
                }*/
                system.debug('@@ Options' + options);
            }
            return options;
        }
        
         /*public List<SelectOption> getPicklistValues(List<string> websericePickValue) {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = VPM_PurchasingRequests__c.VPM_PaymentMethod__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        list<string> newList = new List<string>();
        string defaultValue = '';
        for(Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            for(string s : websericePickValue) {
                s = s+'_';
                if(s.contains(string.valueOf(f))) {
                    defaultValue = string.valueOf(f.getValue());
                }
            }
            //options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        vendorPaymentMethod = string.isNotBlank(defaultValue) ? defaultValue : vendorPaymentMethod; 
        return options;
    } */
    
    // Method to query from Custom Metadatype
    public List<SelectOption> paymentMathodMetaData(List<string> websericePickValue) {
        List<SelectOption> options = new List<SelectOption>();
        List<VPM_PaymentMethods__mdt> metaValues = [select id, VPM_Country__c, VPM_CountryISO2__c, VPM_PaymentMethod__c from VPM_PaymentMethods__mdt where VPM_CountryISO2__c =: purchReqVar.VPM_CompanyCode__r.VPM_CountryCode__c and VPM_Country__c =: purchReqVar.VPM_CompanyCode__r.VPM_Country__c];
        //map<string,string> metaValuesMap = new map<string,string>();
        //set<string> defaultWebValue = new set<string>();  
        
        for(VPM_PaymentMethods__mdt mdtValue : metaValues) {            
            options.add(new SelectOption(mdtValue.VPM_PaymentMethod__c, mdtValue.VPM_PaymentMethod__c));    
            //metaValuesMap.put(mdtValue.VPM_PaymentMethod__c.substringBefore('_'), mdtValue.VPM_PaymentMethod__c);
        }
        system.debug('@@Options' + Options);             
        
        return Options;
    } 
    
    public pageReference newMethod() {
    
       
        system.debug('@@inputCountry' + purchReqVar.VPM_Country__c) ;
        IF(purchReqVar.VPM_Country__c == VENDOR_COUNTRY)
        {
            isRequiredFieldCountry = true;
            
            system.debug('@@isRequiredField ' + isRequiredField);
        }else {
            isRequiredFieldCountry = false;
            
        }    
        
         //modified by Vaishali nagar for IAPR-605
           
            if(purchReqVar.VPM_Country__c <> null)
            {
                 
                if(latam.contains(purchReqVar.VPM_Country__c) || purchReqVar.VPM_Country__c == VENDOR_COUNTRY){
                    isRequiredtax1 = true;
                } 
                else
                    isRequiredtax1=false;
                    system.debug('@@ latam' + latam);
                    system.debug('@@ purchReqVar.VPM_Country__c' + purchReqVar.VPM_Country__c);
                    system.debug('@@ tax number 1' + purchReqVar.VPM_TaxNumber1__c);
                
                if(purchReqVar.VPM_CompanyCode__r.ECC__c =='Cordillera' && purchReqVar.VPM_Country__c == VENDOR_COUNTRY){
            
                    isrequiredtaxJurCode = true;
            
                }else
                    isrequiredtaxJurCode = false;
                    
            }
        return null;    
    }
    
    public pageReference  newMethod1() {
        
        system.debug('@@Acc Group' + entity.VPM_AccountGroup__c + accountGroup) ;
        if(entity.VPM_AccountGroup__c.containsIgnoreCase('ZGS1'))
        {
            isRequired= true;
            system.debug('@@isRequiredField ' + isRequired);
        }else {
            isRequired= false;
        }
        
        if(entity.VPM_Incoterms1__c!='' && entity.VPM_Incoterms1__c!=null){
            isRequiredIncoterms2=true;
        }else{
            isRequiredIncoterms2 = false;
        }        
          return null;
    }
    
    public pageReference vendorNameChange(){
    
        
        searchTerm1 = string.isNotblank(vendorName) ? vendorName.left(10) : '';
        
        system.debug('@@ searchTerm1' + searchTerm1);
        return null;
    
    }
        
       
         public ApexPages.Message checkValidations(){
    
       
        s=Apexpages.currentPage().getUrl();
        system.debug('S'+ s);
        system.debug('@@ Check Validations Called');
        system.debug('@@ entity' + entity);
        recordTypeId = VPM_RecordTypeHelper.getLaunchScreenVariable('',purchReqVar.RecordTypeId);
        system.debug('@@ recordTypeId ' + recordTypeId);
        ApexPages.Message myMsg = null;
        PageReference pg= ApexPages.currentPage();
        
        
         if(recordTypeId=='Create'){
            
            if(s.contains('VPM_GoldenData1')){
                
                if(string.isBlank(vendorName)){                
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);
                }
            }
           else{
               
               if(string.isBlank(tradepartnertype)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_TradePartnerTypepageMessage);
            }            
            if(string.isBlank(vendorPaymentTerms)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentTermsPageMessage);
            }
            if(string.isBlank(purchReqVar.VPM_PaymentMethod__c) && (string.isBlank(vendorPaymentMethod) || vendorPaymentMethod == '[]')){            
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentMethodPageMessage);            
            }
            else if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') {
                vendorPaymentMethod = vendorPaymentMethod.removeStart('[');
                vendorPaymentMethod = vendorPaymentMethod.removeEnd(']');
                List<string> vendorPaymentMethodList  = vendorPaymentMethod.split(',');
                if(vendorPaymentMethodList <> null && vendorPaymentMethodList.size() > 0 && vendorPaymentMethodList.size() > 5)
                    myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_PaymentmethodErrorMesg);                
            } 
            
            if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion' || purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'){            
                /* if(!entity.VPM_SRVBasedVendorID__c)
                {                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_SRVBasedVendorPageMessage);
                }*/
            }
            if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'|| purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2'){
                
                if(vendorCashManagementGrp =='None' || string.isBlank(vendorCashManagementGrp)){
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_CashManagementGroupPageMessage);
                }
                //if(string.isBlank(entity.VPM_BankCountryKey__c)){
                    //myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_BankCountryKeyPageMessage);                
               // }                
            }            
            
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'|| purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera'  || purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2' ){
           
                if(entity.VPM_SortKey__c =='None' ||string.isBlank(entity.VPM_SortKey__c)){
        
             
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_SortKeyPageMessage);
             
            } 
           }
           
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera' || purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2'){
           
               if(string.isBlank(entity.VPM_OrderCurrency__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPMOrderCurrencyPageMessage);
                }           
           }         
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera'){
             /* 20 Oct if(string.isBlank(entity.VPM_TaxJurisdictionCode__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_TaxJurisdictionCodePageMessage);
                } */
           }          
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion'){           
               if(string.isBlank(entity.VPM_GlobalAuthorisationGroup__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_GlobalAuthorisationGrpPageMessage);
                }           
           }
           
        }
        
       }
        
        if(recordTypeId=='Maintain' || recordTypeId=='Extend'){
            /*if(!entity.VPM_CheckDoubleInvoices__c)
            {
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CheckDoubleInvoicesPageMessage);
            }*/         
              isMaintainRecord=true;    
            if(s.contains('VPM_GoldenData1')){
                   if(string.isBlank(vendorName)){                
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);
            }  
            }else{
            
            
            if(string.isBlank(tradepartnertype)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_TradePartnerTypepageMessage);
            }            
            if(string.isBlank(vendorPaymentTerms)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentTermsPageMessage);
            }
            if(string.isBlank(purchReqVar.VPM_PaymentMethod__c) && (string.isBlank(vendorPaymentMethod) || vendorPaymentMethod == '[]')){             
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentMethodPageMessage);            
            }else if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') {
                vendorPaymentMethod = vendorPaymentMethod.removeStart('['); 
                vendorPaymentMethod = vendorPaymentMethod.removeEnd(']');
                List<string> vendorPaymentMethodList  = vendorPaymentMethod.split(',');
                if(vendorPaymentMethodList <> null && vendorPaymentMethodList.size() > 0 && vendorPaymentMethodList.size() > 5)
                    myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_PaymentmethodErrorMesg);                
            }
            
            if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion' || purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'){            
                /* if(!entity.VPM_SRVBasedVendorID__c)
                {                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_SRVBasedVendorPageMessage);
                }*/
            }
            if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'|| purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2'){
                
                if(vendorCashManagementGrp =='None' || string.isBlank(vendorCashManagementGrp)){
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_CashManagementGroupPageMessage);
                }
                //if(string.isBlank(entity.VPM_BankCountryKey__c)){
                    //myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_BankCountryKeyPageMessage);                
               // }                
            }            
            
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'|| purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera'  || purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2' ){
           
                if(entity.VPM_SortKey__c =='None' ||string.isBlank(entity.VPM_SortKey__c)){
        
             
             myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_SortKeyPageMessage);
             
            } 
           }
           
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera' || purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2'){
           
               if(string.isBlank(entity.VPM_OrderCurrency__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPMOrderCurrencyPageMessage);
                }           
           }         
         /*  if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera'){
               if(string.isBlank(entity.VPM_TaxJurisdictionCode__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_TaxJurisdictionCodePageMessage);
                }
           }     */      
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion'){           
               if(string.isBlank(entity.VPM_GlobalAuthorisationGroup__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_GlobalAuthorisationGrpPageMessage);
                }           
           }
            // Check for Block & delete 
             if(purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain') 
             {                
                string VendorBlockUnblockDelete= purchReqVar.VPM_VendorBlockUnblockDelete__c== null?'': pr.VPM_VendorBlockUnblockDelete__c;
                if((VendorBlockUnblockDelete.contains('Blocked')) || (VendorBlockUnblockDelete.contains('Deleted')))
                {
                    if(purchReqVar.VPM_VendorBlockUnblockDelete__c !=null)
                    {
                        if(string.isBlank(purchReqVar.VPM_DeletionBlockFlag__c)){          
                            myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_BlockDeleteVendorErrorMeesage);
                        }
                    }
                 }
             }
             }
        }
        system.debug('@@ myMsg' + myMsg);       
       
        return myMsg;
    }
    
    public void commonSaveMethod() {
        purchReqVar.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
        purchReqVar.VPM_CashManagementGroup__c = vendorCashManagementGrp;
        if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') {
            purchReqVar.VPM_PaymentMethod__c = vendorPaymentMethod;
        }
        purchReqVar.VPM_VendorName1__c = VendorName;
        purchReqVar.VPM_SearchTerm_1__c = searchTerm1; 
        purchReqVar.VPM_PaymentTerms__c = vendorPaymentTerms;
        purchReqVar.VPM_TradePartnerType__c  = tradePartnerType;  
        purchReqVar.VPM_TaxJurisdictionCode__c = taxJuriCodeDefValue;
        purchReqVar.VPM_Industry__c = industryOptionsDefValue;
        
        update purchReqVar;
        newController.save();
        System.debug('@@@@@@@  purchReqVar ------' +purchReqVar);
    }
    
    public PageReference saveRecord() 
    {     
        try 
        {
            
            Pagereference pg= null;
            ApexPages.Message msg;
            
            system.debug('@@ msg' + msg);
          
          msg = checkValidations();
            if(msg <> null){
            
                ApexPages.addMessage(msg);
            
            }
            else{
                commonSaveMethod();
               /*purchReqVar.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
               purchReqVar.VPM_CashManagementGroup__c = vendorCashManagementGrp;
               if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') {
                    purchReqVar.VPM_PaymentMethod__c = vendorPaymentMethod;
               }
               purchReqVar.VPM_VendorName1__c = VendorName;
               purchReqVar.VPM_SearchTerm_1__c = searchTerm1; 
               purchReqVar.VPM_PaymentTerms__c = vendorPaymentTerms;
               purchReqVar.VPM_TradePartnerType__c  = tradePartnerType;  
               
               update purchReqVar;
               newController.save();
               System.debug('@@@@@@@  purchReqVar ------' +purchReqVar); */
              
               //approvalCallMethod();   
               //pr.VPM_AdvancedFormSubmitter__c = GetAdvancedFormSubmitter();
                //msg=ProcurementApproval();
               /* if(msg <> null)
                {
                    ApexPages.addMessage(msg); 
                   //   GoToErrorMessagePage();
                    return  null;
                }*/
                //else
                //{
                    
                    System.debug('@@purchReqVar ' + purchReqVar );
                    if(recordTypeId =='Create'){
                       
                       if(purchReqVar.VPM_CompanyCode__r.ecc__c=='Cordillera'){
                        pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + entity.id);
                        
                    }
                    if(purchReqVar.VPM_CompanyCode__r.ecc__c=='Sirius'){
                        pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + entity.id);
                        
                    }
                    if(purchReqVar.VPM_CompanyCode__r.ecc__c=='Fusion'){
                        pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + entity.id);
                        
                    }
                        if(purchReqVar.VPM_CompanyCode__r.ecc__c=='U2K2'){
                        pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + entity.id);
                        //pg =  new Pagereference('/'+entity.id);
                    }
                     
                                
               }else if(recordTypeId=='Maintain' || recordTypeId=='Extend'){
               
                   if(purchReqVar.VPM_Fieldtype__c=='Global' || purchReqVar.VPM_Fieldtype__c==null){
                       
                       approvalCallMethod();   
                       pr.VPM_AdvancedFormSubmitter__c = GetAdvancedFormSubmitter();
                       msg=ProcurementApproval();
                        if(msg <> null)
                        {
                            ApexPages.addMessage(msg); 
                           //   GoToErrorMessagePage();
                            return  null;
                        }
                        else{
                            update pr;
                            pg =  new Pagereference('/'+entity.id);
                        }
                       
                   }else{
                   
                    if(purchReqVar.VPM_CompanyCode__r.ecc__c=='Cordillera'){
                        pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + entity.id);
                        
                        //pg =  new Pagereference('/'+entity.id);
                    }
                    if(purchReqVar.VPM_CompanyCode__r.ecc__c=='Sirius'){
                        pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + entity.id);
                        //pg =  new Pagereference('/'+entity.id);
                    }
                    if(purchReqVar.VPM_CompanyCode__r.ecc__c=='Fusion'){
                        pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + entity.id);
                        s='Fusion';
                        //pg =  new Pagereference('/'+entity.id);
                    }
                        if(purchReqVar.VPM_CompanyCode__r.ecc__c=='U2K2'){
                        pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + entity.id);
                        //pg =  new Pagereference('/'+entity.id);
                    }
                   }
               }
                pg.setRedirect(true);
                //}
            }
            
            return pg;
        }
        catch(exception ex){
            System.debug('Exception in saveRecord Function' + Ex.getStacktraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }        
    }
    
    //IAVMD-1475
    
      public PageReference saveRecordRegional() 
    {     
        try 
        {
            
            Pagereference pg= null;
            ApexPages.Message msg;
           
            system.debug('@@ msg' + msg);
            /* Added by Epsita */
            if(purchReqVar.VPM_WebformSentToVendor__c == true && purchReqVar.VPM_VendorWebformSubmitted__c == false && purchReqVar.VPM_ShowWarning__c== false){
                msg = new ApexPages.Message(ApexPages.Severity.WARNING,System.label.VPM_Record_Submit_Warning);   
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,System.label.VPM_Record_Submit_Warning);   
                purchReqVar.VPM_ShowWarning__c= true;
               update purchReqVar;
           }
           /*else
               msg = null; commented by Piyush  */
               
           /* Added by Epsita */
           
            msg = checkValidations();
            if(msg <> null){
            
                ApexPages.addMessage(msg);
            
            }
            else{
            
                commonSaveMethod();
               /*purchReqVar.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
               purchReqVar.VPM_CashManagementGroup__c = vendorCashManagementGrp;
               purchReqVar.VPM_VendorName1__c = VendorName;
               purchReqVar.VPM_SearchTerm_1__c = searchTerm1; 
               purchReqVar.VPM_PaymentTerms__c = vendorPaymentTerms;
               purchReqVar.VPM_TradePartnerType__c  = tradePartnerType; 
               if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') {
                    purchReqVar.VPM_PaymentMethod__c = vendorPaymentMethod; 
               }
               update purchReqVar;
               newController.save();
                System.debug('@@@@@@@  purchReqVar ------' +purchReqVar); */
                
                
                
               approvalCallMethod();   
               pr.VPM_AdvancedFormSubmitter__c = GetAdvancedFormSubmitter();
                msg=ProcurementApproval();
                if(msg <> null)
                {
                    ApexPages.addMessage(msg); 
                   //   GoToErrorMessagePage();
                    return  null;
                }
                else
                {
                    update pr;
                    System.debug('@@purchReqVar ' + purchReqVar );
                    if(recordTypeId =='Create' || recordTypeId =='Maintain'||recordTypeId =='Extend'){
                       
                    
                     pg =  new Pagereference('/'+entity.id);
                                pg.setRedirect(true);
               }
                
                }
            }
            
            return pg;
        }
        catch(exception ex){
            System.debug('Exception in saveRecord Function' + Ex.getStacktraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }        
    }
            
/******************************************************************** 
    
    Created By   : Samrin Shaikh
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used to set the flag based on the fields  which will help to triggr the approval process
    Return Type  : null
    ********************************************************************/
   
   public void approvalCallMethod()
    {  
        // Query the DB Fresh record
        
            pr = [SELECT Id, VPM_VendorType__c,VPM_GlobalAuthorisationGroup__c,
                                VPM_Commodity_Family__c,
                                VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,VPM_ProcurementApprovalRequired__c,
                                VPM_FreightApprovalRequired__c,VPM_RussianTaxApprovalRequired__c,
                                VPM_ProvidedPaymentTerms__c,VPM_ProvidedBankDetails__c,
                                VPM_ProvidedFinancialSensitive__c,VPM_ProvidedBlockDelete__c,VPM_ProvidedUnblockUndelete__c,
                                VPM_PaymentTerms__c,VPM_DeletionBlockFlag__c,
                                VPM_ReconciliationAccount__c,VPM_CheckDoubleInvoices__c,VPM_CashManagementGroup__c,VPM_SortKey__c,
                                VPM_PaymentMethod__c,VPM_PaymentBlock__c,
                                VPM_BankCountryKey__c,VPM_Status__c,VPM_RequestLastWithGroup__c ,
                                VPM_BankKey__c,VPM_BankAccountNumber__c,VPM_AccountHolderName__c,
                                VPM_ReferenceSpecificationsBankDetail__c,VPM_BankControlKey__c,
                                VPM_IBAN__c,VPM_CollectionAuthorization__c,VPM_Commodity__r.VPM_CommodityCode__c,
                                VPM_BankName__c,VPM_SwiftKey__c,VPM_PartnerBankType__c,
                                RecordType.DeveloperName,VPM_CountryRequestingVendor__c,
                                VPM_Company_Code_Value__c,VPM_VendorBlockUnblockDelete__c,VPM_BankDataValidationRequired__c,
                                VPM_Commodity__r.VPM_CommodityClass__c,VPM_VATRegistrationNumber__c ,VPM_Is_changed_VAT__c
                                FROM VPM_PurchasingRequests__c WHERE Id =: entity.id];                       
        System.debug('@@pr ' + pr ); 
        System.debug('@@op ' + op ); 
        // Start : Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016 
        string finalStringValue =pr.VPM_PaymentMethod__c== null?'': pr.VPM_PaymentMethod__c;
                System.debug('finalStringValue @@@@'+ finalStringValue);
        string payMeth = finalStringValue.remove('['); 
        string payMeth1 = payMeth.remove(']'); 
                System.debug('payMeth1 @@@@'+ payMeth1);
        List<string> finalStringValueList = payMeth1.split(',');
        finalStringValueList.sort(); 
          System.debug('finalStringValueList @@@@'+ finalStringValueList);       
        string paymentMeth=''; 
        for(String str:finalStringValueList) 
         { 
            System.debug('str @@@@'+ str);
                                             paymentMeth += VPM_HttpUtil.valueBeforeUnderscore(str);
           //  paymentMeth += VPM_HttpUtil.valueBeforeUnderscore(str) + '^'; 
         }
        NewPaymentMethod = paymentMeth.remove(' '); 
        // End : Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016 

        pr.VPM_AdvancedFormSubmitted__c='YES'; 
        // Added by Ajay
        if(pr.VPM_Status__c.containsIgnoreCase('DRAFT'))
        {
            pr.VPM_RequestLastWithGroup__c ='Business Requestor';
        }
        else
            pr.VPM_RequestLastWithGroup__c ='FLS';
            //End here
        if(pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain')
        {
           System.debug('@@@@@@@ pr----------'+ pr);
           System.debug('@@@@@@@ op----------'+ op); 
            if(op!=null){
                    
                    NewPaymentTerms= pr.VPM_PaymentTerms__c== null?'': pr.VPM_PaymentTerms__c;
                    system.debug(' op.CompanyData' +  op.CompanyData);
                    OldPaymentTerms = op.CompanyData[0].PaymentTerms == null?'': op.CompanyData[0].PaymentTerms;
                    System.debug('@@@@@@@ NewPaymentTerms'+ NewPaymentTerms);
                    System.debug('@@@@@@@OldPaymentTerms'+ OldPaymentTerms);
                
                
                 // Start : Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016 
        string oldstring=op.CompanyData[0].PaymentMethod == null?'': op.CompanyData[0].PaymentMethod;
                System.debug('oldstring @@@@'+ oldstring);
        List<string> finalOldStringValueList = oldstring.split('-');
        finalOldStringValueList.sort();
                System.debug('finalOldStringValueList @@@@'+ finalOldStringValueList);
        string OldpaymentMeth=''; 
         for(String str:finalOldStringValueList) 
         { 
             System.debug('str @@@@'+ str);
             OldpaymentMeth += str; 
         }
         OldPaymentMethod = OldpaymentMeth.remove(' '); 
        System.debug('@@@@@@ NewPaymentMethod'+ NewPaymentMethod);
        System.debug('@@@@@@ OldPaymentMethod'+ OldPaymentMethod);
                              
                              //Set<String> intersection = new Set<String>(NewPaymentMethod.split('^'));
               //            Boolean FinalPayment =intersection.retainAll(OldPaymentMethod.split('^'));
                              //System.debug('FinalPayment -------'+ FinalPayment);
                              
        // End Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016        
                    if(!(NewPaymentTerms.contains(OldPaymentTerms)))
                    {
                         System.debug('@@@@@ Inside Payment Block');
                         pr.VPM_ProvidedPaymentTerms__c= true;
                    }
                // VAT Related Change 
                
                    if((pr.VPM_VATRegistrationNumber__c != op.VATRegistrationNumber))
                    {
                         System.debug('@@@@@ Inside  VAT Block');
                         pr.VPM_Is_changed_VAT__c= true;
                    }
                     // FinanciallySensitive Flag Set
                     
                     NewCashManagementGroup= pr.VPM_CashManagementGroup__c== null?'': pr.VPM_CashManagementGroup__c;
                     OldCashManagementGroup = op.CompanyData[0].CashMgmtGroup == null?'': op.CompanyData[0].CashMgmtGroup;
                     NewSortKey= pr.VPM_SortKey__c== null?'': pr.VPM_SortKey__c;
                     OldSortKey = op.CompanyData[0].SortKey == null?'': op.CompanyData[0].SortKey;
                
                     if((
                            ( pr.VPM_ReconciliationAccount__c!=null && pr.VPM_ReconciliationAccount__c != op.CompanyData[0].ReconciliationAccount))
                                ||
                            // ((pr.VPM_PaymentMethod__c  !=null && pr.VPM_PaymentMethod__c != op.CompanyData[0].PaymentMethod))
                            // Above line Commneted : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016
                            ((NewPaymentMethod  !=null && NewPaymentMethod != OldPaymentMethod))
                                ||
                           // ((pr.VPM_CashManagementGroup__c !=null && pr.VPM_CashManagementGroup__c != op.CompanyData[0].CashManagementGroup))
                           (!(NewCashManagementGroup.contains(OldCashManagementGroup)))
                                ||
                           // ((pr.VPM_SortKey__c !=null && pr.VPM_SortKey__c != op.CompanyData[0].SortKey))
                           (!(NewSortKey.contains(OldSortKey)))
                                ||
                            (pr.VPM_PaymentBlock__c !=null &&(pr.VPM_PaymentBlock__c != op.CompanyData[0].PaymentBlock))
                                ||
                            ((pr.VPM_CheckDoubleInvoices__c !=null && pr.VPM_CheckDoubleInvoices__c!=op.CompanyData[0].CheckDoubleInvoices))     
                        )
                        {
                             System.debug('@@@@@ Inside FinanciallySensitive Block    ' +op.CompanyData[0].CheckDoubleInvoices);
                             System.debug('@@@@@ Inside FinanciallySensitive Block    '+pr.VPM_CheckDoubleInvoices__c);
                             pr.VPM_ProvidedFinancialSensitive__c=true;
                        }
                    }
                }
            else{
        //Payment terms Flag  set
            IF(pr.VPM_PaymentTerms__c !=null)
                pr.VPM_ProvidedPaymentTerms__c= true;
        
        // FinanciallySensitive Flag Set
         System.debug('@@@@@ (NewPaymentMethod !=null)  ------ ' + (NewPaymentMethod !=null));
            if((pr.VPM_ReconciliationAccount__c!=null)||(pr.VPM_PaymentMethod__c !=null)||
                  //  (pr.VPM_PaymentBlock__c !=null)||
                  //  Above line Commneted : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016
                    (NewPaymentMethod !=null)||
                    (pr.VPM_CashManagementGroup__c!= null)||
                    (pr.VPM_SortKey__c !=null)||
                    (pr.VPM_CheckDoubleInvoices__c==true))
                {
                        pr.VPM_ProvidedFinancialSensitive__c= true;    
                }    

            }
                    
        // Bank Details Flag Set 
        if((pr.VPM_BankCountryKey__c!=null)|| (pr.VPM_BankKey__c !=null)||(pr.VPM_BankAccountNumber__c !=null)||(pr.VPM_AccountHolderName__c !=null)||(pr.VPM_ReferenceSpecificationsBankDetail__c !=null)||(pr.VPM_BankControlKey__c!=null)||(pr.VPM_IBAN__c!=null)||(pr.VPM_PartnerBankType__c!=null)||(pr.VPM_BankName__c !=null)||(pr.VPM_SwiftKey__c!=null)||(pr.VPM_CollectionAuthorization__c == true)) 
            pr.VPM_ProvidedBankDetails__c= true;
     
        // Unblock/UnDelete Flag set 
        if((pr.VPM_DeletionBlockFlag__c!=null))
        {
            if((pr.VPM_DeletionBlockFlag__c.contains('Undelete')) || (pr.VPM_DeletionBlockFlag__c.contains('Unblock')))
            { 
                pr.VPM_ProvidedUnblockUndelete__c= true;
                pr.VPM_ProvidedBlockDelete__c= false;  
            }
            // Delete/Block flag Set
            if((pr.VPM_DeletionBlockFlag__c.contains('Block')) || (pr.VPM_DeletionBlockFlag__c.contains('Delete')))
            {
                pr.VPM_ProvidedBlockDelete__c= true;
                pr.VPM_ProvidedUnblockUndelete__c= false;
                 pr.VPM_ProvidedFinancialSensitive__c=false;
                 pr.VPM_ProvidedPaymentTerms__c= false;
                 pr.VPM_ProvidedPaymentTerms__c= false;
                pr.VPM_ProvidedBankDetails__c= false;
            }                
        }
        if(pr.VPM_VendorType__c!=null)
        {
            System.debug(' Alsana 1 --------------------' +pr.VPM_VendorType__c );
            if(pr.VPM_VendorType__c.contains('Russian'))
            {
                System.debug(' Alsana 2--------------------' +pr.VPM_VendorType__c );
                pr.VPM_RussianTaxApprovalRequired__c =true;
                pr.VPM_FreightApprovalRequired__c  =false;   
            }
            
            else if(pr.VPM_VendorType__c.contains('Freight'))
            {
                pr.VPM_FreightApprovalRequired__c  =true;
                pr.VPM_RussianTaxApprovalRequired__c =false; 
                // Changes for Bug 346
                if(pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain')
                {
                     if ((pr.VPM_ProvidedBlockDelete__c== false) && (pr.VPM_ProvidedUnblockUndelete__c==false)  && (pr.VPM_ProvidedPaymentTerms__c==false))
                         pr.VPM_FreightApprovalRequired__c  =false;
                }
                //End  Changes for Bug 346
            }
            
            System.debug(' End @@@@@@ pr.RecordType.DeveloperName --------------------' +pr.RecordType.DeveloperName );
            System.debug(' End @@@@@@ pr.VPM_VendorType__c --------------------' +pr.VPM_VendorType__c);
            System.debug(' End @@@@@@ pr.VPM_Commodity_Family__c --------------------' +pr.VPM_Commodity_Family__c );
            System.debug(' End @@@@@@ pr.VPM_GlobalAuthorisationGroup__c --------------------' +pr.VPM_GlobalAuthorisationGroup__c);
        }
        
         GlobalAuthorisationGroup= pr.VPM_GlobalAuthorisationGroup__c== null?'': pr.VPM_GlobalAuthorisationGroup__c;
        // VPM_ProcurementApprovalRequired__c flag set 
        if((pr.VPM_VendorType__c!=null) && (pr.VPM_FinanceApprovalRequired__c!= true) && (pr.VPM_RussianTaxApprovalRequired__c !=true) && (pr.VPM_GlobalAuthorisationGroup__c!=null))
        {
           // if((pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain') && (pr.VPM_ProvidedBlockDelete__c ) && (pr.VPM_FreightApprovalRequired__c == false || pr.VPM_RussianTaxApprovalRequired__c==false ))
            //{
            
                        if( 
                            /*MBS/SCS Capex-MRO Vendors Create or Extend*/                 
                            (pr.RecordType.DeveloperName != 'VPM_VendorReqMaintain' &&    
                             pr.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                                && 
                            (
                                (pr.VPM_VendorType__c.contains('MBS')   && (!GlobalAuthorisationGroup.contains('Lakme')))||
                                GlobalAuthorisationGroup.contains('SCS-CAPEX')
                            )                     
                            )
                           
                            ||
                            /*MBS/SCS Capex-MRO Vendors Maintain*/
                            
                          
                        (pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                            &&
                            (   (pr.VPM_VendorType__c.contains('MBS') &&(!GlobalAuthorisationGroup.contains('Lakme')))||
                                GlobalAuthorisationGroup.contains('SCS-CAPEX')
                            )
                            &&
                                pr.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                            &&
                            (
                                pr.VPM_ProvidedUnblockUndelete__c == TRUE || 
                                pr.VPM_ProvidedBlockDelete__c == TRUE || 
                                pr.VPM_ProvidedPaymentTerms__c == TRUE 
                            )
                         )
                        ||
                        /*SCS Logistics*/ 
                        (pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                         &&
                         GlobalAuthorisationGroup.contains('SCS-Logistics') 
                         &&
                         pr.VPM_ProvidedPaymentTerms__c == TRUE)
                        ||
                        /*USCC/UASCC related MBS/SCS Capex 2611, 5449, 5496, 5487 Create or Extend*/ 
                        (pr.RecordType.DeveloperName != 'VPM_VendorReqMaintain'
                         &&
                         (
                           (pr.VPM_VendorType__c.contains('MBS') &&(!GlobalAuthorisationGroup.contains('Lakme')))||
                             GlobalAuthorisationGroup.contains('SCS-CAPEX') 
                         )
                         &&
                            pr.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                         &&
                         (
                             pr.VPM_Company_Code_Value__c == '2611' || 
                             pr.VPM_Company_Code_Value__c == '5449' ||    
                             pr.VPM_Company_Code_Value__c == '5496' || 
                             pr.VPM_Company_Code_Value__c == '5487'
                         ))
                        ||
                        
                        /*USCC/UASCC related MBS/SCS Capex 2611, 5449, 5496, 5487 Maintain*/ 
                        (pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                         &&
                         (
                             (pr.VPM_VendorType__c.contains('MBS') &&(!GlobalAuthorisationGroup.contains('Lakme')))||
                             GlobalAuthorisationGroup.contains('SCS-CAPEX') 
                         )
                         &&
                            pr.VPM_Commodity_Family__c != 'Out of Scope Procurement'
                         &&
                         (
                             pr.VPM_ProvidedUnblockUndelete__c == TRUE || 
                             pr.VPM_ProvidedBlockDelete__c == TRUE || 
                             pr.VPM_ProvidedPaymentTerms__c == TRUE 
                         )
                         &&
                         (
                             pr.VPM_Company_Code_Value__c == '2611' || 
                             pr.VPM_Company_Code_Value__c == '5449' || 
                             pr.VPM_Company_Code_Value__c == '5496' || 
                             pr.VPM_Company_Code_Value__c == '5487'
                         ))
                )
                    {
                        System.debug(' Alsana 4--------------------' +pr.VPM_VendorType__c );
                        pr.VPM_ProcurementApprovalRequired__c = true;
                        pr.VPM_RussianTaxApprovalRequired__c =false;
                    }
           //}
        }
        System.debug('End   Alsana 4--------------------' +pr.VPM_VendorType__c );
        
        // VPM_FinanceApprovalRequired__c flag set 
        
        if(pr.VPM_VendorType__c!=null && (pr.VPM_RussianTaxApprovalRequired__c !=true) &&  GlobalAuthorisationGroup !=null)
        {
          //if((pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain') && (pr.VPM_ProvidedBlockDelete__c ) && (pr.VPM_FreightApprovalRequired__c == false || pr.VPM_RussianTaxApprovalRequired__c==false || pr.VPM_ProcurementApprovalRequired__c == false ))
          //{
            if(
                (
                    /*MBS(Indirect) Others (Out Scope Proc)*/ 
                    (pr.VPM_VendorType__c.contains('MBS'))
                    && 
                   pr.VPM_Commodity_Family__c == 'Out of Scope Procurement'
                    &&
                    (pr.RecordType.DeveloperName == 'VPM_VendorReqCreate' || pr.RecordType.DeveloperName == 'VPM_VendorReqExtend'
                   ||
                    (
                     pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                     &&
                     (
                        pr.VPM_ProvidedUnblockUndelete__c == TRUE ||
                        pr.VPM_ProvidedBlockDelete__c == TRUE || 
                        pr.VPM_ProvidedPaymentTerms__c == TRUE ||    
                        pr.VPM_ProvidedBankDetails__c == TRUE ||  
                        pr.VPM_ProvidedFinancialSensitive__c == TRUE
                     )
                    )) 
                 )
                 ||
                 (
                 /* Freight,SCS Log*/ 
                     (pr.VPM_VendorType__c.contains('FRGT') || GlobalAuthorisationGroup.contains('SCS-L'))
                    &&
                     pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                    &&
                    (
                        pr.VPM_ProvidedBankDetails__c == TRUE ||  
                        pr.VPM_ProvidedFinancialSensitive__c == TRUE
                    )
                 )
                 ||
                (
                 /* SCS Log*/ 
                     (GlobalAuthorisationGroup.contains('SCS-L'))
                    &&
                     (pr.RecordType.DeveloperName != 'VPM_VendorReqMaintain')
                 )
                 ||
                 (
                    /*PI,3PM*/ 
                    (pr.VPM_VendorType__c.contains('PI') 
                    || 
                    (pr.VPM_VendorType__c.contains('SCS') && GlobalAuthorisationGroup.contains('3PM'))
                    )
                    &&
                    ( pr.RecordType.DeveloperName != 'VPM_VendorReqMaintain'
                    ||
                        ( pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain' &&
                            (
                                pr.VPM_ProvidedUnblockUndelete__c == TRUE ||
                                pr.VPM_ProvidedBlockDelete__c == TRUE || 
                                pr.VPM_ProvidedPaymentTerms__c == TRUE ||    
                                pr.VPM_ProvidedBankDetails__c == TRUE ||  
                                pr.VPM_ProvidedFinancialSensitive__c == TRUE ||
                                pr.VPM_Is_changed_VAT__c == TRUE
                            )
                        )
                    )
                )
                ||
                (
                 /*USCC/UASCC,MBS/SCSCap,2611,5449,5496,5487*/ 
                 (pr.VPM_VendorType__c.contains('MBS') || GlobalAuthorisationGroup.contains('CAP'))
                 && 
                    pr.VPM_Commodity_Family__c != 'Out of Scope Procurement'
                 &&
                   (pr.VPM_Company_Code_Value__c == '2611' || pr.VPM_Company_Code_Value__c == '5449' 
                        || pr.VPM_Company_Code_Value__c == '5496' || pr.VPM_Company_Code_Value__c == '5487')
                 &&
                  /*  pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                 &&
                    (   
                                pr.VPM_ProvidedBankDetails__c == TRUE ||  
                                pr.VPM_Is_changed_VAT__c == TRUE ||
                                pr.VPM_ProvidedFinancialSensitive__c == TRUE
                    ) */ 
                    ( pr.RecordType.DeveloperName == 'VPM_VendorReqCreate' || pr.RecordType.DeveloperName == 'VPM_VendorReqExtend'
                    ||
                        ( pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain' &&
                            ( 
                                pr.VPM_ProvidedBankDetails__c == TRUE ||  
                                pr.VPM_ProvidedFinancialSensitive__c == TRUE ||
                                pr.VPM_Is_changed_VAT__c == TRUE
                            )
                        )
                    )
                )
                ||
                (
                    /* USCC/UASCC,MBS(Indir)2611,5449,5496,5487*/
                    (pr.VPM_VendorType__c.contains('MBS'))
                    &&
                    pr.VPM_Commodity_Family__c == 'Out of Scope Procurement'
                    &&
                    (pr.VPM_Company_Code_Value__c == '2611' || pr.VPM_Company_Code_Value__c == '5449' 
                        || pr.VPM_Company_Code_Value__c == '5496' || pr.VPM_Company_Code_Value__c == '5487')
                    &&
                    ( pr.RecordType.DeveloperName == 'VPM_VendorReqCreate' || pr.RecordType.DeveloperName == 'VPM_VendorReqExtend'
                    ||
                        ( pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain' &&
                            (
                                pr.VPM_ProvidedUnblockUndelete__c == TRUE ||
                                pr.VPM_ProvidedBlockDelete__c == TRUE || 
                                pr.VPM_ProvidedPaymentTerms__c == TRUE ||    
                                pr.VPM_ProvidedBankDetails__c == TRUE ||  
                                pr.VPM_ProvidedFinancialSensitive__c == TRUE ||
                                pr.VPM_Is_changed_VAT__c == TRUE
                            )
                        )
                    )
                )
                ||
                (
                    /*MBS Lakme,SCS Unica*/ 
                    (
                     (pr.VPM_VendorType__c.contains('MBS') && GlobalAuthorisationGroup.contains('Lakme') && pr.VPM_Commodity_Family__c != 'Out of Scope Procurement')
                     ||
                     (pr.VPM_VendorType__c.contains('SCS') && GlobalAuthorisationGroup.contains('UNICA'))
                    )
                    &&
                    ( pr.RecordType.DeveloperName != 'VPM_VendorReqMaintain'
                    ||
                        ( pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain' &&
                            (
                                pr.VPM_ProvidedUnblockUndelete__c == TRUE ||
                                pr.VPM_ProvidedBlockDelete__c == TRUE || 
                                pr.VPM_ProvidedPaymentTerms__c == TRUE ||    
                                pr.VPM_ProvidedBankDetails__c == TRUE ||  
                                pr.VPM_ProvidedFinancialSensitive__c == TRUE 
                            )
                        )
                    )                
                )
                ||
                (
                    /*MBS/SCS Cap-MRO*/
                     (pr.VPM_VendorType__c.contains('MBS') || GlobalAuthorisationGroup.contains('CAP'))
                     &&
                     pr.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                     &&
                   
                    ((pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain' && (pr.VPM_ProvidedBankDetails__c == TRUE ||  pr.VPM_ProvidedFinancialSensitive__c == TRUE)) || (pr.RecordType.DeveloperName != 'VPM_VendorReqMaintain') )
                     
                )
              )
                
            {
                System.debug(' Alsana 5--------------------' +pr.VPM_VendorType__c );
                pr.VPM_FinanceApprovalRequired__c=true;
                pr.VPM_RussianTaxApprovalRequired__c =false;
            }
        // }
            
        }
               System.debug(' End Alsana 5--------------------' +pr.VPM_VendorType__c );
        
        // Setting VPM_NumberofApprovalsRequired__c flag 
        
        System.debug(' End @@@@@@ VPM_FinanceApprovalRequired__c--------------------' +pr.VPM_FinanceApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_ProcurementApprovalRequired__c--------------------' +pr.VPM_ProcurementApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_FreightApprovalRequired__c--------------------' +pr.VPM_FreightApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_RussianTaxApprovalRequired__c--------------------' +pr.VPM_RussianTaxApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_ProvidedPaymentTerms__c--------------------' +pr.VPM_ProvidedPaymentTerms__c);
        System.debug(' End @@@@@@ VPM_ProvidedBankDetails__c--------------------' +pr.VPM_ProvidedBankDetails__c);
        System.debug(' End @@@@@@ VPM_ProvidedFinancialSensitive__c--------------------' +pr.VPM_ProvidedFinancialSensitive__c);
        System.debug(' End @@@@@@ VPM_ProvidedBlockDelete__c--------------------' +pr.VPM_ProvidedBlockDelete__c);
        System.debug(' End @@@@@@ VPM_ProvidedUnblockUndelete__c--------------------' +pr.VPM_ProvidedUnblockUndelete__c);
        
        if((pr.VPM_FinanceApprovalRequired__c)|| (pr.VPM_ProcurementApprovalRequired__c)|| (pr.VPM_FreightApprovalRequired__c)|| (pr.VPM_RussianTaxApprovalRequired__c))
        {
            if ((pr.VPM_FinanceApprovalRequired__c ) && (pr.VPM_FreightApprovalRequired__c)) 
                {
                 pr.VPM_NumberofApprovalsRequired__c=2;
                // pr.VPMCheckFinanceApprovalFlag__c=true;
                }
            else if((pr.VPM_FinanceApprovalRequired__c ) && (pr.VPM_ProcurementApprovalRequired__c))
                {
                 pr.VPM_NumberofApprovalsRequired__c=2;
                 //pr.VPMCheckFinanceApprovalFlag__c = true;
                 }
            else if((pr.VPM_FreightApprovalRequired__c ) && (pr.VPM_ProcurementApprovalRequired__c))
                { pr.VPM_NumberofApprovalsRequired__c=2;  
                  //pr.VPMCheckFinanceApprovalFlag__c = true;
                }              
            else
               { pr.VPM_NumberofApprovalsRequired__c=1;
                // pr.VPMCheckFinanceApprovalFlag__c = false;
                }
        } 
        else
            pr.VPM_NumberofApprovalsRequired__c=0;
        
        // 3 Level  of approval
        System.debug('@@@@@ Bank Validation @@@@@-----');
        if(pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain') 
        {
             if((pr.VPM_FinanceApprovalRequired__c)|| (pr.VPM_ProcurementApprovalRequired__c)|| (pr.VPM_FreightApprovalRequired__c))
             {
                 //  Samrin Shaikh : Change for Bug No : 1285 : on 16 sept 2016 
                if((pr.VPM_ProvidedBankDetails__c) &&  (!pr.VPM_ProvidedBlockDelete__c) && (!pr.VPM_ProvidedUnblockUndelete__c))
                {    
                    pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c +1; 
                    pr.VPM_BankDataValidationRequired__c=true;
                    //pr.VPMCheckFinanceApprovalFlag__c = true;
                }
             } 
            //  Samrin Shaikh : Change for Bug No : 1409 : on 29 sept 2016 
             else if(pr.VPM_RussianTaxApprovalRequired__c)
             {
                if((pr.VPM_ProvidedBankDetails__c) &&  (!pr.VPM_ProvidedBlockDelete__c) && (!pr.VPM_ProvidedUnblockUndelete__c))
                {
                    pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c +1; 
                    pr.VPM_BankDataValidationRequired__c=true;
                }
                  //  Samrin Shaikh : Change for Bug No : 1388  : on 29 sept 2016 
                 else if((!pr.VPM_ProvidedPaymentTerms__c) && (!pr.VPM_ProvidedBankDetails__c) && 
                         (!pr.VPM_ProvidedFinancialSensitive__c) &&  (!pr.VPM_ProvidedBlockDelete__c) &&
                         (!pr.VPM_ProvidedUnblockUndelete__c))
                 {
                     pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                 }
                 //  Samrin Shaikh :  End Change for Bug No : 1388  : on 29 sept 2016
            
             }
            //  Samrin Shaikh :   Change for Bug No : 1389  : on 29 sept 2016
             else if(pr.VPM_FreightApprovalRequired__c)
             {
                if((!pr.VPM_ProvidedPaymentTerms__c) && (!pr.VPM_ProvidedBankDetails__c) && 
                         (!pr.VPM_ProvidedFinancialSensitive__c) &&  (!pr.VPM_ProvidedBlockDelete__c) &&
                         (!pr.VPM_ProvidedUnblockUndelete__c))
                 {
                     pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                 } 
             } //  Samrin Shaikh :  End Change for Bug No : 1389  : on 29 sept 2016
            
             //  Samrin Shaikh : End of  Change for Bug No : 1409 : on 29 sept 2016 
                 
        }
        else  if (pr.RecordType.DeveloperName != 'VPM_VendorReqMaintain')
        {
            VPM_L2InculdeApproval__c  approvalRequired = VPM_L2InculdeApproval__c.getInstance(pr.VPM_CountryRequestingVendor__c);
            System.debug('approvalRequired -------'+ approvalRequired);
            if(approvalRequired != null )
            {
                if(approvalRequired.VPM_L2CreateExtendApproval__c && pr.VPM_NumberofApprovalsRequired__c == 2  && pr.VPM_FinanceApprovalRequired__c ) // True mean Excluded
                {
                    pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                    pr.VPM_FinanceApprovalRequired__c= false;
                }
                    
            }
        }
            
        System.debug('@@@@@@@ No  of Approval Req--------'+pr.VPM_NumberofApprovalsRequired__c );
        System.debug('@@@@@@@ VPM_BankDataValidationRequired__c--------'+pr.VPM_BankDataValidationRequired__c );
    }  
    /*  End of Function approvalCallMethod  : VPM - Used to set the flag based on the fields  which will help to triggr the approval process */
     

     
     /******************************************************************** 
      
    Created By   : Samrin Shaikh
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used to set the AdvancedFormSubmitter  base on permission set 
    Return Type  : null
    ********************************************************************/
   
       public string  GetAdvancedFormSubmitter() {
        string AdvancedFormSubmitter =null;
        
        List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                              FROM PermissionSetAssignment
                                                              WHERE AssigneeId = :Userinfo.getUserId() order by PermissionSet.Label DESC];
                                                              
        System.debug('@@@@@@ lstcurrentUserPerSet  ----------'+ lstcurrentUserPerSet );
                                                                      
        if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('FLS')) {
            AdvancedFormSubmitter = 'FLS';
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('MDM')) {
            AdvancedFormSubmitter = 'MDM Ops';
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Finance')) {
            AdvancedFormSubmitter = 'Finance';
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Freight')) {
            AdvancedFormSubmitter = 'Freight';
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Russian')) {
            AdvancedFormSubmitter = 'Russian';
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Procurement')) {
            AdvancedFormSubmitter = 'Procurement';
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Business Requestor')) {
            AdvancedFormSubmitter = 'Business Requestor';
        }
        
        return AdvancedFormSubmitter;
    }
       
    /*  End of Function  GetAdvancedFormSubmitter  : VPM - Used to set the AdvancedFormSubmitter  base on permission set */
    
      /******************************************************************** 
    
    Created By   : Samrin Shaikh
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used to set display the error message when the Commoditiy Approval is not defined for selected country 
    Return Type  : null
    ********************************************************************/
   
    Public ApexPages.Message ProcurementApproval()
    {
            
        ApexPages.Message myMsg2 = null;
         if(pr.VPM_ProcurementApprovalRequired__c)
        {
          //  Try for Error Message if Commodity Approver not defined for selected Country & commodity Class 
          
            lstCommodityApprover =[SELECT id ,VPM_Approver1__c , VPM_Approver2__c 
                                   FROM VPM_CommodityApprover__c  
                                   WHERE VPM_Country__c = :pr.VPM_CountryRequestingVendor__c 
                                   AND VPM_CommodityClass__c =: pr.VPM_Commodity__r.VPM_CommodityClass__c
                                   AND  VPM_ConfiguredApprovers__c > 0 //  Samrin Shaikh : 1798 : when 0 Approval is present in Commdotiy Approver Record
                                  ];
            if(lstCommodityApprover.size() <=0 )
            {
                pr.VPM_AdvancedFormSubmitted__c='';
               // myMsg2 = System.Label.VPM_CommodityApproverNotDefinePageMessage;
                myMsg2= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CommodityApproverNotDefinePageMessage);
            } 
        }
        return myMsg2;
       
    }
      /* End of Function ProcurementApproval  : VPM - Used to set display the error message when the Commoditiy Approval is not defined for selected country  */
    
     /******************************************************************** 
    
    Created By   : Samrin Shaikh
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - it is call  when the request is Block/Unblock/Delete/Undelete it is called in consturctor 
    Return Type  : null
    ********************************************************************/
   
 Public pagereference  ApprovalMaintain1()
    {
        try{
            ApexPages.Message msg = null;
            System.debug('ApprovalMaintain1');
            if(purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain')    
             {
                if(string.isNotBlank(purchReqVar.VPM_DeletionBlockFlag__c))
                {
                    approvalCallMethod();
                    pr.VPM_AdvancedFormSubmitter__c=GetAdvancedFormSubmitter();
                    System.debug('Alsana ------'+ pr.VPM_AdvancedFormSubmitter__c);
                 
                    msg=ProcurementApproval();
                    System.debug('@@@@ ErrorMessage'+msg);
                    if(msg <> null)
                    {
                        Errormsgblock= True ;
                        GoldenDatablock=false;
                        ApexPages.addMessage(msg);                   
                        return  null;
                    }
                    else
                    {
                    
                        update pr;
                        System.debug('@@pr ' + pr ); 
                        Pagereference pg =  new Pagereference('/'+entity.id); 
                        pg.setRedirect(true);
                        return pg;
                    }
                }
                else
                {
                    string VendorBlockUnblockDelete= purchReqVar.VPM_VendorBlockUnblockDelete__c== null?'': purchReqVar.VPM_VendorBlockUnblockDelete__c;
                    System.debug('@@@@@ purchReqVar.VPM_VendorBlockUnblockDelete__c -----' + purchReqVar.VPM_VendorBlockUnblockDelete__c);
                    System.debug('@@@@@ purchReqVar.VPM_DeletionBlockFlag__c -----' + purchReqVar.VPM_DeletionBlockFlag__c);
                    if((VendorBlockUnblockDelete.contains('Blocked')) || (VendorBlockUnblockDelete.contains('Deleted')))
                    {
                        if(string.isBlank(purchReqVar.VPM_DeletionBlockFlag__c)){
                            msg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_BlockDeleteVendorErrorMeesage);
                            Errormsgblock= True ;
                            GoldenDatablock=false;
                            ApexPages.addMessage(msg);                   
                            return  null;    
                        }
                    }
                }
            }
            return  null; 
        }
        catch(exception ex){
            System.debug('Exception in ApprovalMaintain1 Function');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
            /*Pagereference pg =  new Pagereference('/'+entity.id); 
            pg.setRedirect(true);
            return pg; */
        }
    }
    /* End of Function ApprovalMaintain1  : VPM - it is call  when the request is Block/Unblock/Delete/Undelete it is called in consturctor   */
     
     public VPM_ECCVendorSearchServiceOutput FetchVendorDeatilSAPService(string mdmCode, string ECC, string VPMCompanyCode, string PurchasingOrg)
    {   
        
        string purchOrgName = PurchasingOrg; // added recently for passing org 
        purchOrgName = string.isNotBlank(purchOrgName) ? purchOrgName.left(4) : null; // added recently for passing org 
        VPM_FetchVendorsDetails.InputVariables ip = new VPM_FetchVendorsDetails.InputVariables();
        List<VPM_FetchVendorsDetails.InputVariables> ipList = new List<VPM_FetchVendorsDetails.InputVariables>();
        List<VPM_ECCVendorSearchServiceOutput> opList = new List<VPM_ECCVendorSearchServiceOutput>();
        ip.vendorCodeInput = mdmCode;
        ip.ecc = ECC;
        ip.compnayCode = VPMCompanyCode;
        ip.PurchasingOrg = purchOrgName;
        ipList.add(ip);
        opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
        system.debug('@@ipList' + ipList);
        system.debug('@@opList' + opList);
        return opList[0];
    }
    
   /* public PageReference GoToErrorMessagePage()
    {
        ApexPages.PageReference pr = new ApexPages.PageReference('/apex/VPM_ErrorMessage?id=' +purid);
        pr.SetRedirect(true);
        pr.GetParameters().Put('message', Errormsg);
        return pr;
    } */
    
    Public pagereference  ErrorMessage()
    {
        String message = '' + ApexPages.CurrentPage().GetParameters().Get('message');
        pagereference p = apexpages.Currentpage();
        if(message != null)
        {
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,message);
            apexpages.addmessage(msg);
        }
        return p;
    } 
    
    public pagereference saveAndBackToLaunchScreen() {
        commonSaveMethod();
        Pagereference pg = backToFlow();
        return pg;
    }
    
    public pagereference backToFlow()
    {
        string queryString = '&back=' + 'true';
       // Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); 
         Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + entity.id + queryString); 
        pg.setRedirect(true);
        return pg;
    }
    
    //Edited for IAVMD-1475
    
    public pagereference backToGlobalScreen()
    {
        string queryString = '&back=' + 'true';
        Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); 
        if(recordTypeId=='Create'){
             pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + entity.id + queryString); 
        }else if(recordTypeId=='Maintain'){
        
            if(purchReqVar.VPM_FieldType__c =='Regional' || purchReqVar.VPM_FieldType__c ==null)
                 pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString);
            else
                pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + entity.id + queryString);
        }else if(recordTypeId=='Extend'){
            if(purchReqVar.VPM_ExtensionType__c=='Regional' && (purchReqVar.VPM_FieldType__c==null || purchReqVar.VPM_FieldType__c =='Regional'))
                pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString);
            else if(purchReqVar.VPM_ExtensionType__c=='Global' && (purchReqVar.VPM_FieldType__c=='Regional'))
                pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString);
            else 
                pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + purid + queryString);
        }
        
        pg.setRedirect(true);
        return pg;
    }
    public pagereference backToGoldenData1()
    {
        string queryString = '&back=' + 'true';
        Pagereference pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + entity.id + queryString); 
        system.debug('@@ pg' + pg);
        pg.setRedirect(true);
        return pg;
    }
    

    
   
}