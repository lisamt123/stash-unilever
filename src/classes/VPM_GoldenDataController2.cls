public class VPM_GoldenDataController2 {

    public VPM_PurchasingRequests__c entity{get;set;}
    public VPM_CommodityCode__c commodityCodeVar{get;set;}
    public VPM_PurchasingRequests__c purchReqVar{get;set;}
    public VPM_PurchasingRequests__c pr{get;set;}
    public Boolean isRequired{get;set;}
    public Boolean isRequiredFieldCountry{get;set;}
    public Boolean isRequiredtax1{get;set;} //modified for IAPR-605
    public boolean isrequiredtaxJurCode{get;set;} //modified for IAPR-605
    public Boolean isRequiredIncoterms2{get;set;}
    public Boolean isRequiredSpend{get;set;}
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
    public string vendorCode{get;set;}
    public string vendorName{get;set;}
    public string searchTerm1{get;set;}
    public string recordTypeId{get;set;}
    public string GlobalAuthorisationGroup {get;set;}
    public boolean Errormsgblock {get;set;}
    Public boolean GoldenDatablock{get;set;}
    public  list<VPM_CommodityApprover__c> lstCommodityApprover {get;set;}
    public VPM_ECCVendorSearchServiceOutput op;
   // public List<ApprovalFlagWrapper> lst {get;set;}
    //public List<ApprovalFlagWrapper> display_list {get; set;} 
   
    public static final string PURCHASING_ORG = 'Purchasing Organisation';
    public static final string CASH_MGMT = 'Cash mgmnt group';
     public static final string PAYMENT_TERMS = 'Payment Terms';
     public static final string TRADE_PARTNER_TYPE='TradePartnerType';
       public  List<SelectOption> paymentTerms{get;set;}
    public string vendorPaymentTerms{get;set;}
    
    VendorRequest__c obj = VendorRequest__c.getInstance('Countries');
    public string latam;
    
    string NewCashManagementGroup {get; set;} 
    string OldCashManagementGroup {get; set;} 
    string NewSortKey {get; set;} 
    string OldSortKey {get; set;} 
    string NewPaymentTerms {get; set;} 
    string OldPaymentTerms {get; set;} 
                    
    
    ApexPages.StandardController newController;

    public VPM_GoldenDataController2(ApexPages.StandardController controller) 
    {
     userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
        system.debug('@@userlang=' +userlang);
        entity = (VPM_PurchasingRequests__c)controller.getRecord();
        
        newController = controller;
    try
    {
        purchReqVar = [SELECT Id, VPM_VendorType__c,VPM_TradePartnerType__c,VPM_Commodity__c ,VPM_Commodity_Family__c,recordTypeId,
                       VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,VPM_Street1__c,VPM_CheckDoubleInvoices__c,
                       VPM_ProcurementApprovalRequired__c,VPM_Location__c,VPM_City__C,VPM_TaxNumber1__c ,
                       VPM_OrderingEmailAddress__c,VPM_PaymentTerms__c,VPM_BankCountryKey__c,VPM_Country__c,
                       VPM_BankKey__c,VPM_BankAccountNumber__c,VPM_AccountHolderName__c,
                       VPM_Commodity__r.VPM_VendorType__c,VPM_Commodity__r.VPM_AuthorisationGroup__c,
                       VPM_ReferenceSpecificationsBankDetail__c,VPM_BankControlKey__c,
                       VPM_IBAN__c,VPM_CollectionAuthorization__c,VPM_Commodity__r.VPM_CommodityCode__c,
                       VPM_PartnerBankType__c,VPM_BankName__c,VPM_SwiftKey__c,VPM_Commodity__r.Name,
                       VPM_ReconciliationAccount__c,VPM_PaymentMethod__c,VPM_VendorName1__c,VPM_SearchTerm_1__c,
                       VPM_GRbasedIV__c,VPM_AutomaticPurchaseOrderGeneration__c,VPM_AlreadyAvailableSupplierUse__c,
                       VPM_PaymentBlock__c,VPM_DeletionBlockFlag__c,VPM_AccountGroup__c,VPM_TaxJurisdictionCode__c,
                       VPM_GlobalAuthorisationGroup__c,RecordType.DeveloperName,VPM_CountryRequestingVendor__c,
                       VPM_Commodity__r.VPM_CommodityFamily__c,VPM_Is_changed_VAT__c,VPM_Company_Code_Value__c,
                       VPM_CashManagementGroup__c, VPM_PurchasingOrganisation__c,VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,
                       VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c,
                       VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,VPM_Spend__c,VPM_Commodity__r.VPM_CommodityClass__c,
                       VPM_Incoterms1__c,VPM_CompanyCode__r.ecc__c,VPM_SortKey__c,VPM_VendorBlockUnblockDelete__c
                       FROM VPM_PurchasingRequests__c WHERE Id =: entity.id];                       
        System.debug('@@purchReqVar ' + purchReqVar );     
        
        
        VendorName = purchReqVar.VPM_VendorName1__c;
        searchTerm1 = purchReqVar.VPM_SearchTerm_1__c;
        if(string.isBlank(searchTerm1))
        searchTerm1 = string.isNotBlank(VendorName) ? VendorName.left(10) : '';
         
         
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
        
        
        if(purchReqVar.VPM_CompanyCode__r.ecc__c <> '' && purchReqVar.VPM_CompanyCode__r.ecc__c <> null)
            entity.VPM_ECC__c = purchReqVar.VPM_CompanyCode__r.ecc__c;
        
        system.debug('@@ ECC' + entity.VPM_ECC__c);
        
        purid = entity.id;
        
        
        purchasingOrg = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, PURCHASING_ORG,vendorPurchasingOrg);
        CashManagementGrp = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, CASH_MGMT,vendorCashManagementGrp);
        paymentTerms = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, PAYMENT_TERMS,vendorPaymentTerms);
        tradePartnerTypeList = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,TRADE_PARTNER_TYPE,tradepartnerType);
        
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
            op = FetchVendorDeatilSAPService(vendorCode,purchReqVar.VPM_CompanyCode__r.ecc__c,purchReqVar.VPM_Company_Code_Value__c);
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
    
        system.debug('@@ Check Validations Called');
        system.debug('@@ entity' + entity);
        recordTypeId = VPM_RecordTypeHelper.getLaunchScreenVariable('',purchReqVar.RecordTypeId);
        system.debug('@@ recordTypeId ' + recordTypeId);
        ApexPages.Message myMsg = null;
        
        if(recordTypeId == 'Maintain' || recordTypeId == 'Extend'){
            if(!entity.VPM_CheckDoubleInvoices__c)
            {
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CheckDoubleInvoicesPageMessage);
            }                
            if(string.isBlank(vendorName)){                
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);
            }
            if(string.isBlank(tradepartnertype)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_TradePartnerTypepageMessage);
            }            
            /*if(string.isBlank(entity.VPM_Country__c)){
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CountryPagemessage);
            
            } */           
            if(string.isBlank(vendorPaymentTerms)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentTermsPageMessage);
            }
            if(string.isBlank(entity.VPM_PaymentMethod__c)){            
                 myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentMethodPageMessage);            
            }
            
            if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion' || purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'){            
                 if(!entity.VPM_SRVBasedVendorID__c)
                {                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_SRVBasedVendorPageMessage);
                }
            }
            if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion' || purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'|| purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2'){
                
                if(vendorCashManagementGrp =='None' || string.isBlank(vendorCashManagementGrp)){
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_CashManagementGroupPageMessage);
                }
                if(string.isBlank(entity.VPM_BankCountryKey__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_BankCountryKeyPageMessage);                
                }                
            }            
            
           if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion' || purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'|| purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera'){
           
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
               if(string.isBlank(entity.VPM_TaxJurisdictionCode__c)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_TaxJurisdictionCodePageMessage);
                }
           }           
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
        system.debug('@@ myMsg' + myMsg);       
       
        return myMsg;
    }
    
    public PageReference saveRecord() 
    {     
        try 
        {
            
            Pagereference pg= null;
            ApexPages.Message msg;
            msg = checkValidations();
            system.debug('@@ msg' + msg);
            if(msg <> null){
            
                ApexPages.addMessage(msg);
            
            }
            else{
            
               purchReqVar.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
               purchReqVar.VPM_CashManagementGroup__c = vendorCashManagementGrp;
               purchReqVar.VPM_VendorName1__c = VendorName;
               purchReqVar.VPM_SearchTerm_1__c = searchTerm1; 
               purchReqVar.VPM_PaymentTerms__c = vendorPaymentTerms;
               purchReqVar.VPM_TradePartnerType__c  = tradePartnerType;            
               update purchReqVar;
               newController.save();
                System.debug('@@@@@@@  purchReqVar ------' +purchReqVar);
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
                    pg =  new Pagereference('/'+entity.id); 
                    pg.setRedirect(true);
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
                     OldPaymentTerms = op.CompanyCodeFields[0].PaymentTerms == null?'': op.CompanyCodeFields[0].PaymentTerms;
                    
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
                     OldCashManagementGroup = op.CompanyCodeFields[0].CashManagementGroup == null?'': op.CompanyCodeFields[0].CashManagementGroup;
                     NewSortKey= pr.VPM_SortKey__c== null?'': pr.VPM_SortKey__c;
                     OldSortKey = op.CompanyCodeFields[0].SortKey == null?'': op.CompanyCodeFields[0].SortKey;
                     if((
                            ( pr.VPM_ReconciliationAccount__c!=null && pr.VPM_ReconciliationAccount__c != op.CompanyCodeFields[0].ReconciliationAccount))
                                ||
                             ((pr.VPM_PaymentMethod__c  !=null && pr.VPM_PaymentMethod__c != op.CompanyCodeFields[0].PaymentMethod))
                                ||
                           // ((pr.VPM_CashManagementGroup__c !=null && pr.VPM_CashManagementGroup__c != op.CompanyCodeFields[0].CashManagementGroup))
                           (!(NewCashManagementGroup.contains(OldCashManagementGroup)))
                                ||
                           // ((pr.VPM_SortKey__c !=null && pr.VPM_SortKey__c != op.CompanyCodeFields[0].SortKey))
                           (!(NewSortKey.contains(OldSortKey)))
                                ||
                            (pr.VPM_PaymentBlock__c !=null &&(pr.VPM_PaymentBlock__c != op.PaymentBlock))
                                ||
                            ((pr.VPM_CheckDoubleInvoices__c !=null && pr.VPM_CheckDoubleInvoices__c!=op.CompanyCodeFields[0].CheckDoubleInvoices))     
                        )
                        {
                             System.debug('@@@@@ Inside FinanciallySensitive Block');
                             pr.VPM_ProvidedFinancialSensitive__c=true;
                        }
                    }
                }
            else{
        //Payment terms Flag  set
            IF(pr.VPM_PaymentTerms__c !=null)
                pr.VPM_ProvidedPaymentTerms__c= true;
        
        // FinanciallySensitive Flag Set
            if((pr.VPM_ReconciliationAccount__c!=null)||(pr.VPM_PaymentMethod__c !=null)||
                    (pr.VPM_PaymentBlock__c !=null)||(pr.VPM_CashManagementGroup__c!= null)||
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
            if((pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain') && (pr.VPM_ProvidedBlockDelete__c ) && (pr.VPM_FreightApprovalRequired__c == false || pr.VPM_RussianTaxApprovalRequired__c==false ))
			{
			
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
							 pr.VPM_VendorType__c.contains('MBS') ||
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
							 pr.VPM_VendorType__c.contains('MBS')  ||
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
			}
        }
        System.debug('End   Alsana 4--------------------' +pr.VPM_VendorType__c );
        
        // VPM_FinanceApprovalRequired__c flag set 
        
        if(pr.VPM_VendorType__c!=null && (pr.VPM_RussianTaxApprovalRequired__c !=true) &&  GlobalAuthorisationGroup !=null)
        {
		  if((pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain') && (pr.VPM_ProvidedBlockDelete__c ) && (pr.VPM_FreightApprovalRequired__c == false || pr.VPM_RussianTaxApprovalRequired__c==false || pr.VPM_ProcurementApprovalRequired__c == false ))
		  {
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
                    /*PI,3PM*/ 
                    (pr.VPM_VendorType__c.contains('PI') 
                    || 
                    (pr.VPM_VendorType__c.contains('SCS') && GlobalAuthorisationGroup.contains('3PM'))
                    )
                    &&
                    ( pr.RecordType.DeveloperName == 'VPM_VendorReqExtend'
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
                    ( pr.RecordType.DeveloperName == 'VPM_VendorReqExtend'
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
                      pr.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                    && 
                    (pr.VPM_ProvidedBankDetails__c == TRUE ||  pr.VPM_ProvidedFinancialSensitive__c == TRUE )
                )
              )
                
            {
                System.debug(' Alsana 5--------------------' +pr.VPM_VendorType__c );
                pr.VPM_FinanceApprovalRequired__c=true;
                pr.VPM_RussianTaxApprovalRequired__c =false;
            }
		 }
            
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
                pr.VPM_NumberofApprovalsRequired__c=2;
            else if((pr.VPM_FinanceApprovalRequired__c ) && (pr.VPM_ProcurementApprovalRequired__c))
                pr.VPM_NumberofApprovalsRequired__c=2;
            else if((pr.VPM_FreightApprovalRequired__c ) && (pr.VPM_ProcurementApprovalRequired__c))
                pr.VPM_NumberofApprovalsRequired__c=2;                
            else
                pr.VPM_NumberofApprovalsRequired__c=1;
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
    
    public pagereference backToFlow()
    {
        string queryString = '&back=' + 'true';
       // Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); 
         Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + entity.id + queryString); 
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