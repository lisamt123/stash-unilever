/**********************************************************************
Name:  VPM_GoldenDataController2()
Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  Used as the cusotm controller for all Golden Data Pages (which include Global & Regoinal Golden Data ) 
1. GoldenData2
2. VPM_CordilleraGoldenData
3. VPM_SiriusGoldenData
4. VPM_FusionGoldenData
5. VPM_U2K2GoldenData
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Vaishali      --              INITIAL DEVELOPMENT       N/A
2.0 -    Samrin      29 June 2016      VPM - Used to set the flag based on the fields  which will help to triggr the approval process.
3.0 -    Epsita                        IAPR- 638 - Spend should not be mandatory for Non-Ariba Commodities
4.0-     Vaishali    5 Oct 2016        IAPR-1475 - Logic for Global and Regional golden data Page
5.0      Samrin      2 Nov 2016        IAVMD-1857 - Changes on maintain scenario are not visible to approver
6.0      Samrin      4 Nov 2016        IAVMD-2325 : L2 Approvals for Sirius and Cordillera not working ( if there's no Custom Setting for the Country, the L2 approval doesn't get triggered)
7.0      Samrin      7 Nov 2016        IAVMD-2299 : Block-Delete Vendor - Warning message on new page
8.0      Samrin      21 Dec 2016       Chnages in Approval Logic to Check and implement global & Regional Extend Request 
9.0      Samirn      09 Jan 2017       IAVMD-2767  : Implement change to Approval criteria for Adopt Scan Date 
****************************************************************************/


with Sharing public class VPM_GoldenDataController2 {
    
    /* Constant Values */ 
    public static final string  STR_CONST_MBS='MBS';
    public static final string  STR_CONST_RECORDTYPEMAINTAIN='VPM_VendorReqMaintain';
    public static final string  STR_CONST_RECORDTYPECREATE='VPM_VendorReqCreate';
    public static final string  STR_CONST_RECORDTYPEEXTEND='VPM_VendorReqExtend';
    public static final string  STR_CONST_OUTOFSCOPE='Out of Scope Procurement';
    public static final string  STR_CONST_SCSCAPEX='SCS-CAPEX';
    public static final string  STR_CONST_LAKME='Lakme';
    public static final string  STR_CONST_SCSLOG='SCS-Logistics';
    public static final String STR_CONST_FREIGHT='Freight';
    public static final string  STR_CONST_RUSSIAN='Russian';
    public static final string  STR_CONST_BLOCK='Block';
    public static final String STR_CONST_UNBLOCK='Unblock';
    public static final string  STR_CONST_UNDELETE='Undelete';
    public static final String STR_CONST_DELETE='Delete';
    public static final String STR_CONST_PI='PI';
    public static final string  STR_CONST_3PM='3PM';
    public static final String STR_CONST_SCS='SCS';
    public static final string  STR_CONST_UNICA='UNICA';
    public static final String STR_CONST_CAP='CAP';
    public static final String STR_CONST_DRAFT= 'DRAFT';
    Public static final string STR_CONST_CORDILLERA ='Cordillera';
    Public static final string STR_CONST_FUSION='Fusion';
    Public static final string STR_CONST_U2K2 ='U2K2';
    Public static final string STR_CONST_SIRIUS ='Sirius';
    Public static final string STR_CONST_MAINTAIN ='Maintain';
    Public static final string STR_CONST_MAINTAIN2 ='Maintain2';
    Public static final string STR_CONST_CREATE ='Create';
    Public static final string STR_CONST_EXTEND ='Extend';
    Public static final string STR_CONST_MBSOTHER ='MBS--Other';
    Public static final string STR_CONST_GLOBAL='Global';
    Public static final string STR_CONST_ZGS1='ZGS1';
    Public static final string STR_CONST_GOLDENDATA1='VPM_GoldenData1';
    Public static final string STR_CONST_STATUS_MDM='MDM';
    Public static final string STR_CONST_STATUS_REVIEW='Review';
    Public static final string STR_CONST_SCC_L='SCS-L';
    Public static final string STR_CONST_FLS='FLS';
    Public static final string STR_CONST_FINANCE='Finance';
    Public static final string STR_CONST_PROCUREMENT='Procurement';
    Public static final string STR_CONST_BR='Business Requestor';
    Public static final string STR_CONST_REGIONAL='Regional';
    Public static final string STR_CONST_NONE='None';
     public static final string PURCHASING_ORG = 'Purchasing Organisation';
     public static final string CASH_MGMT = 'Cash mgmnt group';
     public static final string PAYMENT_TERMS = 'Payment Terms';
     public static final string TRADE_PARTNER_TYPE='TradePartnerType';
     public static final string TAX_JURIDICATION_CODE = 'Tax Jurisdiction Code';
     public static final string INDUSTRY = 'Industry';
     public static final string ACCOUNT_STAT = 'Account Statement';

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
    public string shippingConditionsDefValue{get;set;}
    public string accountGroup{get;set;}  
    public string isRequiredField{get;set;}
    public Id purid{get;set;}
    public string userlang{get;set;}  
    public boolean vendorType{get;set;}
    public boolean showSaveExit{get;set;}
        
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
    string RecordTypeApprovalChanges{get;set;} 
    public PageReference pg {get;set;}
    
    public  list<VPM_CommodityApprover__c> lstCommodityApprover {get;set;}
    public VPM_ECCVendorSearchServiceOutput op;
    public string s;
   

    public List<SelectOption> shippingConditionsOptions{get;set;} 
    public  List<SelectOption> paymentTerms{get;set;}
    public string vendorPaymentTerms{get;set;}

    public string taxJuriCodeDefValue{get;set;} 
    
    public  List<SelectOption> industryOptions{get;set;}
    public string industryOptionsDefValue{get;set;} 
    
    public  List<SelectOption> PaymentMethod{get;set;}
    public string vendorPaymentMethod{get;set;}
    
    public  List<SelectOption> AccountStatement{get;set;}
    public string vendorAccountStatement{get;set;} 
    
    public List<string> paymentMethodDefaultValue{get;set;}
    
    VPM_LatamCountries__c  obj = VPM_LatamCountries__c.getInstance('Countries'); 
    public string latam;
    
   public string NewCashManagementGroup {get; set;} 
   public string OldCashManagementGroup {get; set;} 
   public string NewSortKey {get; set;} 
   public string OldSortKey {get; set;} 
   public string NewPaymentTerms {get; set;} 
   public string OldPaymentTerms {get; set;} 
   public string OldPaymentMethod{get;set;}
   public string NewPaymentMethod{get;set;}  
    public string ExtendType{get;set;}
        public string PaymentBlock{get;set;}
    public string ReconciliationAccount{get;set;}
    
    ApexPages.StandardController newController;

    public VPM_GoldenDataController2() {}
    
    public VPM_GoldenDataController2(ApexPages.StandardController controller) 
    {
     userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
        system.debug('@@userlang=' +userlang);
        entity = (VPM_PurchasingRequests__c)controller.getRecord();
        
        newController = controller;
    try
    {
        purchReqVar = [SELECT Id,VPM_TaxJurisdictionCode__c,VPM_RequestLastWithGroup__c,VPM_RequestGroupTime__c,VPM_Industry__c,VPM_IsLock__c,VPM_Status__c, VPM_VendorType__c,VPM_TradePartnerType__c,VPM_Commodity__c ,VPM_Commodity_Family__c,recordTypeId,
                       VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,VPM_Street1__c,VPM_CheckDoubleInvoices__c,VPM_VendorContactDetail__c,
                       VPM_ProcurementApprovalRequired__c,VPM_Location__c,VPM_City__C,VPM_TaxNumber1__c ,VPM_ExtensionType__c,VPM_GlobalFieldChanged__c,VPM_RegionalFieldChanged__c,
                       VPM_OrderingEmailAddress__c,VPM_PaymentTerms__c,VPM_BankCountryKey__c,VPM_Country__c,VPM_Fieldtype__c,VPM_ClerksInternet__c,
                       VPM_BankKey__c,VPM_BankAccountNumber__c,VPM_AccountHolderName__c,VPM_PurchasingOrg__c,VPM_PurchasingOrg__r.Name,
                       VPM_Commodity__r.VPM_VendorType__c,VPM_Commodity__r.VPM_AuthorisationGroup__c, VPM_CompanyCode__r.VPM_CountryCode__c, VPM_CompanyCode__r.VPM_Country__c,
                       VPM_ReferenceSpecificationsBankDetail__c,VPM_WebformSentToVendor__c,VPM_ShowWarning__c,VPM_VendorWebformSubmitted__c,VPM_BankControlKey__c,
                       VPM_IBAN__c,VPM_CollectionAuthorization__c,VPM_Commodity__r.VPM_CommodityCode__c,VPM_VendorCode__c,
                       VPM_PartnerBankType__c,VPM_BankName__c,VPM_SwiftKey__c,VPM_Commodity__r.Name,VPM_AccountStatement__c,
                       VPM_ReconciliationAccount__c,VPM_PaymentMethod__c,VPM_VendorName1__c,VPM_SearchTerm_1__c,
                       VPM_GRbasedIV__c,VPM_AutomaticPurchaseOrderGeneration__c,VPM_AlreadyAvailableSupplierUse__c,VPM_ShippingConditions__c,
                       VPM_PaymentBlock__c,VPM_DeletionBlockFlag__c,VPM_AccountGroup__c,// 20 Oct VPM_TaxJurisdictionCode__c,
                       VPM_GlobalAuthorisationGroup__c,RecordType.DeveloperName,VPM_CountryRequestingVendor__c,
                       VPM_Commodity__r.VPM_CommodityFamily__c,VPM_IsChangedVAT__c,VPM_Company_Code_Value__c,
                       VPM_CashManagementGroup__c,VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,
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
        shippingConditionsDefValue = purchReqVar.VPM_ShippingConditions__c; 
        VendorName = purchReqVar.VPM_VendorName1__c;
        searchTerm1 = purchReqVar.VPM_SearchTerm_1__c;
        if(string.isBlank(searchTerm1))
        {
            searchTerm1 = string.isNotBlank(VendorName) ? VendorName.left(10) : '';
        }
        isFusion = false;
        isU2k2 = false;
        
       //IAVMD-1340 - logic start
       if((purchReqVar.VPM_IsLock__c ) || (purchReqVar.VPM_Status__c.contains(STR_CONST_STATUS_MDM) || purchReqVar.VPM_Status__c.contains(STR_CONST_STATUS_REVIEW)) ) {
                isInputField = false;
                isOutputField = true;
             } else{ 
                isInputField = true;
                isOutputField = false; 
        }
        // IAVMD - 1340 - End 
        
        //Added by Epsita 
          if(purchReqVar.VPM_WebformSentToVendor__c  && (!purchReqVar.VPM_VendorWebformSubmitted__c))
          {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,System.label.VPM_Record_Submit_Warning));
          }
           
        
         if(purchReqVar.VPM_CashManagementGroup__c<>null)
         {  
             vendorCashManagementGrp = purchReqVar.VPM_CashManagementGroup__c;}
        system.debug('@@ vendorCashManagementGrp' + vendorCashManagementGrp);
        //purchasingOrg = getPurchasingOrgItems();
        //vendorPurchasingOrg = purchReqVar.VPM_PurchasingOrganisation__c;
        tradepartnerType=purchReqVar.VPM_TradePartnerType__c;
        vendorPaymentTerms = purchReqVar.VPM_PaymentTerms__c;
         vendorAccountStatement=purchReqVar.VPM_AccountStatement__c;
         
        Errormsgblock= false ;
        GoldenDatablock=true;// Make golden data section Avaliable by default
        //Make spend field required only when commodity code starts with 0
        //isRequiredSpend =true; // by default shld always be required
        //Changed by Epsita - IAPR- 638 || Spend should not be mandatory for Non-Ariba Commodities
        isRequiredSpend = false;
        if(string.isNotBlank(purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c) && purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c.startsWith('0'))                  
        {
            isRequiredSpend = false;}
        else                
        {isRequiredSpend =true; }           
        
        //changes for IAVMD-1271
        
        recordTypeId = VPM_RecordTypeHelper.getLaunchScreenVariable('',purchReqVar.RecordTypeId);
        if(recordTypeId == STR_CONST_CREATE|| recordTypeId==STR_CONST_EXTEND){
              if(string.isNotBlank(purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c) && !(purchReqVar.VPM_Commodity__r.VPM_CommodityCode__c.startsWith('0')) && !(purchReqVar.VPM_GlobalAuthorisationGroup__c.contains(STR_CONST_MBSOTHER)))                  
              {
                  isReqOrderingEmail = true;
                  showOrderingEmail = true;
              }else
              {
                  isReqOrderingEmail =false;
                  showOrderingEmail = false;
              }
            
        }
        showSaveExit = false;
        if((recordTypeId==STR_CONST_MAINTAIN || (recordTypeId==STR_CONST_EXTEND && purchReqVar.VPM_ExtensionType__c=='Regional')) && purchReqVar.VPM_FieldType__c=='Global')
           {showSaveExit=true;}  
           else{showSaveExit=false;}       
 
                    
         if(recordTypeId ==STR_CONST_MAINTAIN || recordTypeId ==STR_CONST_MAINTAIN2)
         { isMaintainRecord = true;}
             
        // added by Piyush 10/20/2016
        if(purchReqVar.VPM_CompanyCode__r.ECC__c == STR_CONST_FUSION) 
        {  isFusion=true; }
       else
       { isFusion=false; }
        
       if(purchReqVar.VPM_CompanyCode__r.ECC__c == STR_CONST_U2K2) 
        {isU2k2 = true;}
       else
       {  isU2k2 = false;}
        
       //make spend visible for create and global extend
            
        if(recordTypeId==STR_CONST_CREATE || (recordTypeId==STR_CONST_EXTEND && purchReqVar.VPM_ExtensionType__c==STR_CONST_GLOBAL))
        {isReqSpend=true;}
        else
        {isReqSpend=false;}
        
            
        if(purchReqVar.VPM_CompanyCode__r.ecc__c <> '' && purchReqVar.VPM_CompanyCode__r.ecc__c <> null)
        { entity.VPM_ECC__c = purchReqVar.VPM_CompanyCode__r.ecc__c; }
        
        system.debug('@@ ECC' + entity.VPM_ECC__c);
        
        if(recordTypeId==STR_CONST_CREATE || (recordTypeId==STR_CONST_EXTEND && purchReqVar.VPM_ExtensionType__c==STR_CONST_GLOBAL)){
            if(string.isNotBlank(purchReqVar.VPM_VendorContactDetail__c)){        
                if(string.isBlank(purchReqVar.VPM_OrderingEmailAddress__c))
                {  entity.VPM_OrderingEmailAddress__c = purchReqVar.VPM_VendorContactDetail__c; }
                
                if(string.isBlank(purchReqVar.VPM_ClerksInternet__c))
                { entity.VPM_ClerksInternet__c = purchReqVar.VPM_VendorContactDetail__c; }
            }
        }
        
        system.debug('recordTypeId '+recordTypeId );
         system.debug('isCreate '+isCreate );
         if(recordTypeId ==STR_CONST_CREATE)
         { isCreate = true; }
         else
         { isCreate = false; }
        
        purid = entity.id;
        
        
        purchasingOrg = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, PURCHASING_ORG,vendorPurchasingOrg);
        CashManagementGrp = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, CASH_MGMT,vendorCashManagementGrp);
        paymentTerms = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, PAYMENT_TERMS,vendorPaymentTerms);
        tradePartnerTypeList = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,TRADE_PARTNER_TYPE,tradepartnerType);
        //taxJuriCodeOptions = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,TAX_JURIDICATION_CODE,taxJuriCodeDefValue);
        AccountStatement = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, ACCOUNT_STAT, vendorAccountStatement);
        industryOptions = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,INDUSTRY,industryOptionsDefValue);
        shippingConditionsOptions =VPM_PicklistHelper.getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c,VPM_PicklistHelper.SHIPPING_CONDITION,shippingConditionsDefValue);
        
        /*if(purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_CORDILLERA){        
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c;
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_FUSION){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeFusion__c;
            
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_SIRIUS){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeSirius__c;
            
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_U2K2){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c;
            
        }*/
        vendorCode = purchReqVar.VPM_VendorCode__c;
        system.debug('@@ vendorCode'+vendorCode);
        
        if(purchReqVar.VPM_Incoterms1__c <> '' && purchReqVar.VPM_Incoterms1__c <> null)
        {  entity.VPM_Incoterms1__c =purchReqVar.VPM_Incoterms1__c; }
        
        system.debug('@@ entity.VPM_Incoterms1__c' + entity.VPM_Incoterms1__c);
        
        
        accountGroup= entity.VPM_AccountGroup__c == null?'': entity.VPM_AccountGroup__c;
        system.debug('####accountGroup '+accountGroup);
        
        
        IF(accountGroup.containsIgnoreCase(STR_CONST_ZGS1))
        { isRequired=true; }
        else
        {  isRequired=false; }
        
        if(entity.VPM_Incoterms1__c!='' && entity.VPM_Incoterms1__c!=null){
            {  isRequiredIncoterms2=true; }
        }else{
            isRequiredIncoterms2 = false;
        }
            
        //modified for IAPR-605
      system.debug('@@ LATAm Countries:' + obj);
        latam = obj.VPM_CountryName__c;
        
        system.debug('@@ LATAm Countries:' + latam);
        IF(purchReqVar.VPM_Country__c == VENDOR_COUNTRY)
        {   isRequiredFieldCountry = true; }
        else 
        { isRequiredFieldCountry = false;  }
                   
        if(purchReqVar.VPM_Country__c == VENDOR_COUNTRY || latam.contains(purchReqVar.VPM_Country__c))      
        { isRequiredtax1 = true; }
        else
        { isRequiredtax1 = false; }

       
        /*//modified for IAPR-605
        
        if(purchReqVar.VPM_CompanyCode__r.ECC__c ==STR_CONST_CORDILLERA && purchReqVar.VPM_Country__c == VENDOR_COUNTRY)
        { isrequiredtaxJurCode = true; }
        else
        { isrequiredtaxJurCode = false; }
        */
        vendorCashManagementGrp = purchReqVar.VPM_CashManagementGroup__c;
        //vendorPurchasingOrg = purchReqVar.VPM_PurchasingOrganisation__c;
        //vendorPaymentTerms = purchReqVar.VPM_PaymentTerms__c;
        // Service call for Apporval Method  for Maintain record Type 
        if(purchReqVar.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN)   
        {
            system.debug('@@web service is called');
            op = FetchVendorDeatilSAPService(vendorCode,purchReqVar.VPM_CompanyCode__r.ecc__c,purchReqVar.VPM_Company_Code_Value__c, purchReqVar.VPM_PurchasingOrg__r.Name);
            System.debug('@@@@@@@ op ---------'+ op); 
        }
    }
    catch(exception ex){
            System.debug('Exception in VPM_GoldenDataController2 Constructor' + Ex.getStacktraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
}
  
    }
      /******************************************************************** 
    FunctionName : getRegionSpecificCustomSettingvalues  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used to Populate Region specific Picklist 
    Return Type  : List<SelectOption>
    ********************************************************************/ 
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
           // if(settingList <> null && settingList.size() > 0) {  
           if(!settingList.isEmpty()) {        
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
    
                      /******************************************************************** 
    FunctionName : paymentMathodMetaData  
    Created By   : Piyush 
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used to populate paymentMathodMetaData Data (Method to query from Custom Metadatype)
    Return Type  : List<SelectOption>
    ********************************************************************/
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
                   /******************************************************************** 
    FunctionName : newMethod  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used for Make VPM_Country__c & taxJurCode as Required 
    Return Type  : null
    ********************************************************************/ 
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
                {
                    isRequiredtax1=false; }
                    system.debug('@@ latam' + latam);
                    system.debug('@@ purchReqVar.VPM_Country__c' + purchReqVar.VPM_Country__c);
                    system.debug('@@ tax number 1' + purchReqVar.VPM_TaxNumber1__c);
                
                if(purchReqVar.VPM_CompanyCode__r.ECC__c ==STR_CONST_CORDILLERA && purchReqVar.VPM_Country__c == VENDOR_COUNTRY){
                    isrequiredtaxJurCode = true;
            
                }else
                { isrequiredtaxJurCode = false; }
                    
            }
        return null;    
    }
    
                /******************************************************************** 
    FunctionName : newMethod1  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used for Make VPM_AccountGroup__c as Required 
    Return Type  : null
    ********************************************************************/   
    public pageReference  newMethod1() {
        
        system.debug('@@Acc Group' + entity.VPM_AccountGroup__c + accountGroup) ;
        if(entity.VPM_AccountGroup__c.containsIgnoreCase(STR_CONST_ZGS1))
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
            /******************************************************************** 
    FunctionName : checkValidations  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used for custom Validation Error based on region
    Return Type  : null
    ********************************************************************/     
  public ApexPages.Message checkValidations(){
    
       
        s=Apexpages.currentPage().getUrl();
        system.debug('@@S'+ s);
        system.debug('@@ Check Validations Called');
        system.debug('@@ entity' + entity);
        recordTypeId = VPM_RecordTypeHelper.getLaunchScreenVariable('',purchReqVar.RecordTypeId);
        system.debug('@@ recordTypeId ' + recordTypeId);
        ApexPages.Message myMsg = null;
         pg= ApexPages.currentPage();
        
        
        /***************************************************/
        
              if(recordTypeId==STR_CONST_MAINTAIN ) 
              { isMaintainRecord=true;  }  
              
            if(s.contains(STR_CONST_GOLDENDATA1)){
                if(string.isBlank(vendorName)){                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_VendorNamePageMessage);
                }
                /***********Added by Epsita -IAVMD-2320   **********/
                system.debug('@@purchReqVar.VPM_Country__c' + purchReqVar.VPM_Country__c);
                if(purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_CORDILLERA &&  purchReqVar.VPM_Country__c == VENDOR_COUNTRY && string.isBlank(taxJuriCodeDefValue)) {
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_TaxJuriCodeErrorMessage);               
                }
                if(string.isNotBlank(taxJuriCodeDefValue) && taxJuriCodeDefValue.length() > 15) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.label.VPM_TaxJuriLengthMessage);  
                }                
            }else{
                
                
                if(string.isBlank(tradepartnertype)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_TradePartnerTypepageMessage);
                }            
                if(string.isBlank(vendorPaymentTerms)){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentTermsPageMessage);
                }
                if((string.isBlank(purchReqVar.VPM_PaymentMethod__c) || purchReqVar.VPM_PaymentMethod__c == '[]') && (string.isBlank(vendorPaymentMethod) || vendorPaymentMethod == '[]')){  
                    system.debug('@@purchReqVar.VPM_PaymentMethod__c' + purchReqVar.VPM_PaymentMethod__c);
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_PaymentMethodPageMessage);            
                }
                if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') {
                    vendorPaymentMethod = vendorPaymentMethod.removeStart('['); 
                    vendorPaymentMethod = vendorPaymentMethod.removeEnd(']');
                    List<string> vendorPaymentMethodList  = vendorPaymentMethod.split(',');
                   // if(vendorPaymentMethodList <> null && vendorPaymentMethodList.size() > 0 && vendorPaymentMethodList.size() > 5)
                   if(!vendorPaymentMethodList.isEmpty() && vendorPaymentMethodList.size() > 5)
                    {   myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_PaymentmethodErrorMesg);  }              
                }
                
                if((purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_U2K2) && (string.isBlank(industryOptionsDefValue) || industryOptionsDefValue==STR_CONST_NONE)){                           
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_Industry);
                }
                
                if((purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_U2K2) && (string.isBlank(vendorAccountStatement) || vendorAccountStatement==STR_CONST_NONE)){            
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_AccountStatement);
                }
                if((purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_SIRIUS|| purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_U2K2) && (vendorCashManagementGrp ==STR_CONST_NONE || string.isBlank(vendorCashManagementGrp))) {
                    
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_CashManagementGroupPageMessage);
                }      
                if(purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_CORDILLERA && entity.VPM_AccountGroup__c.containsIgnoreCase(STR_CONST_ZGS1) && string.isBlank(shippingConditionsDefValue)){
                    myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ShippingConditionMessage);
                }
                
                if((purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_SIRIUS ) && (entity.VPM_SortKey__c ==STR_CONST_NONE ||string.isBlank(entity.VPM_SortKey__c))){
                    
                    myMsg=new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_SortKeyPageMessage);
                }
                
                if((purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_CORDILLERA || purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_U2K2) && (string.isBlank(entity.VPM_OrderCurrency__c)) ){
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPMOrderCurrencyPageMessage);          
                }         
                 
                if((purchReqVar.VPM_CompanyCode__r.ecc__c ==STR_CONST_FUSION) && (string.isBlank(entity.VPM_GlobalAuthorisationGroup__c)) ){           
              
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_GlobalAuthorisationGrpPageMessage);         
                }
                // Check for Block & delete 
                if(purchReqVar.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN) 
                {                
                    string VendorBlockUnblockDelete= purchReqVar.VPM_VendorBlockUnblockDelete__c== null?'': pr.VPM_VendorBlockUnblockDelete__c;
                    if(((VendorBlockUnblockDelete.contains(STR_CONST_BLOCK)) || (VendorBlockUnblockDelete.contains(STR_CONST_DELETE))) && (purchReqVar.VPM_VendorBlockUnblockDelete__c !=null) && (string.isBlank(purchReqVar.VPM_DeletionBlockFlag__c) ))
                    {     
                        myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_BlockDeleteVendorErrorMeesage);
                    }
                }
             }
        
        system.debug('@@ myMsg' + myMsg);       
       
        return myMsg;
    }
   
  /******************************************************************** 
    FunctionName : commonSaveMethod  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used to save commonSaveMethod which will save the global golden data  pages d
    Return Type  : PageReference
    ********************************************************************/   
  public void commonSaveMethod() {
        //purchReqVar.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
        purchReqVar.VPM_CashManagementGroup__c = vendorCashManagementGrp;
        if(string.isNotBlank(vendorPaymentMethod) && vendorPaymentMethod <> '[]') 
        { purchReqVar.VPM_PaymentMethod__c = vendorPaymentMethod; }
      
        purchReqVar.VPM_VendorName1__c = VendorName;
        purchReqVar.VPM_SearchTerm_1__c = searchTerm1; 
        purchReqVar.VPM_PaymentTerms__c = vendorPaymentTerms;
        purchReqVar.VPM_TradePartnerType__c  = tradePartnerType;  
        purchReqVar.VPM_TaxJurisdictionCode__c = taxJuriCodeDefValue;
        purchReqVar.VPM_Industry__c = industryOptionsDefValue;
        purchReqVar.VPM_AccountStatement__c = vendorAccountStatement;
        
        update purchReqVar;
        VPM_CheckRecursive.run = true;
        newController.save();
        System.debug('@@@@@@@  purchReqVar ------' +purchReqVar);
    }
    
             /******************************************************************** 
    FunctionName : saveRecord  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used to save saveRecord which will call common save & Apprval related function inside 
    Return Type  : PageReference
    ********************************************************************/
    public PageReference saveRecord() 
    {     
        try 
        {
            Pagereference pg= null;
            ApexPages.Message msg;
          
            msg = checkValidations();
            if(msg <> null)
            {
                system.debug('msg '+msg);
                ApexPages.addMessage(msg);}
            else{
                system.debug('@@ Coming here');
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
                    if(recordTypeId ==STR_CONST_CREATE || (recordTypeId ==STR_CONST_EXTEND && purchReqVar.VPM_ExtensionType__c ==STR_CONST_GLOBAL))
                    {
                       
                        if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_CORDILLERA)
                        {
                            pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + entity.id);}

                        if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_SIRIUS)
                        { pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + entity.id);}

                        if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_FUSION)
                        { pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + entity.id); }
 
                        if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_U2K2)
                        { pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + entity.id); }
                        //pg =  new Pagereference('/'+entity.id);
                   
                        
                                
                    }else if(recordTypeId==STR_CONST_MAINTAIN || recordTypeId==STR_CONST_EXTEND)
                    {
               
                        if(purchReqVar.VPM_Fieldtype__c==STR_CONST_GLOBAL || purchReqVar.VPM_Fieldtype__c==null)
                        {
                       
                             approvalCallMethod();   
                             pr.VPM_AdvancedFormSubmitter__c = GetAdvancedFormSubmitter();
                             msg=ProcurementApproval();
                            if(msg <> null)
                            {
                                system.debug('msg '+msg);
                                ApexPages.addMessage(msg); 
                            //   GoToErrorMessagePage();
                                return  null;
                            }
                            else{
                                    update pr;
                                    pg =  new Pagereference('/'+entity.id);
                                }
                       
                        }else{
                                if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_CORDILLERA)
                                { pg =  new Pagereference('/apex/VPM_CordilleraGoldenData?id=' + entity.id); }

                                if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_SIRIUS)
                                { pg =  new Pagereference('/apex/VPM_SiriusGoldenData?id=' + entity.id); }
                   
                                if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_FUSION){
                                    pg =  new Pagereference('/apex/VPM_FusionGoldenData?id=' + entity.id);
                                    s='Fusion';
                                    //pg =  new Pagereference('/'+entity.id);
                                 }
                                if(purchReqVar.VPM_CompanyCode__r.ecc__c==STR_CONST_U2K2)
                                { pg =  new Pagereference('/apex/VPM_U2K2GoldenData?id=' + entity.id); }
                                  
                                  
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
         /******************************************************************** 
    FunctionName : saveRecordRegional  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used to save saveRecordRegional Based on the Regional Page 
    Return Type  : null
    ********************************************************************/
      public PageReference saveRecordRegional() 
    {     
        try 
        {

            /* Added by Epsita */
            if(purchReqVar.VPM_WebformSentToVendor__c  && (!purchReqVar.VPM_VendorWebformSubmitted__c) && (!purchReqVar.VPM_ShowWarning__c)){
                new ApexPages.Message(ApexPages.Severity.WARNING,System.label.VPM_Record_Submit_Warning);   
                purchReqVar.VPM_ShowWarning__c= true;
               update purchReqVar;
           }
           /* Added by Epsita */
           
           ApexPages.Message msg = checkValidations();
            
            if(msg <> null){
            
                ApexPages.addMessage(msg);
                return null;
            }
            else{
            
               commonSaveMethod();
               approvalCallMethod();   
               pr.VPM_AdvancedFormSubmitter__c = GetAdvancedFormSubmitter();
               msg=ProcurementApproval();
                if(msg <> null)
                {
                    ApexPages.addMessage(msg); 
                    return  null;
                }
                else
                {
                    
                    System.debug('@@purchReqVar ' + purchReqVar );
                    if(recordTypeId ==STR_CONST_CREATE || recordTypeId == STR_CONST_MAINTAIN ||recordTypeId ==STR_CONST_EXTEND){
                     pr.VPM_RegionalFieldChanged__c=true;
                     pg =  new Pagereference('/'+entity.id);
                     update pr;
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
// End of Function saveRecordRegional : VPM - Used to save saveRecordRegional Based on the Regional Page 
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
        
            pr = [SELECT Id,CreatedById,VPM_VendorType__c,VPM_GlobalAuthorisationGroup__c,VPM_HoursSpentWithProcurement__c,VPM_HoursSpentWithFreight__c,
                                VPM_HoursSpentWithFLS__c,VPM_HoursSpentWithFinance__c,VPM_HoursSpentWithBankValidator__c,VPM_HoursSpentWithRussianCustomTax__c,VPM_Commodity_Family__c,VPM_AdvancedFormSubmittedTime__c,
                                VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,VPM_ProcurementApprovalRequired__c,
                                VPM_FreightApprovalRequired__c,VPM_RussianTaxApprovalRequired__c,
                                VPM_ProvidedPaymentTerms__c,VPM_ProvidedBankDetails__c,
                                VPM_ProvidedFinancialSensitive__c,VPM_ProvidedBlockDelete__c,VPM_ProvidedUnblockUndelete__c,
                                VPM_PaymentTerms__c,VPM_DeletionBlockFlag__c,VPM_TargetCompletion__c,
                                VPM_ReconciliationAccount__c,VPM_CheckDoubleInvoices__c,VPM_CashManagementGroup__c,VPM_SortKey__c,
                                VPM_PaymentMethod__c,VPM_PaymentBlock__c,VPM_RegionalFieldChanged__c,VPM_GlobalFieldChanged__c,
                                VPM_BankCountryKey__c,VPM_Status__c,VPM_RequestLastWithGroup__c ,
                                VPM_BankKey__c,VPM_BankAccountNumber__c,VPM_AccountHolderName__c,
                                VPM_ReferenceSpecificationsBankDetail__c,VPM_BankControlKey__c,
                                VPM_IBAN__c,VPM_CollectionAuthorization__c,VPM_Commodity__r.VPM_CommodityCode__c,
                                VPM_BankName__c,VPM_SwiftKey__c,VPM_RequestFromFLSOrBR__c,VPM_PartnerBankType__c,VPM_RequestType__c,
                                RecordType.DeveloperName,VPM_CountryRequestingVendor__c,VPM_RequestGroupTime__c ,
                                VPM_Company_Code_Value__c,VPM_VendorBlockUnblockDelete__c,VPM_BankDataValidationRequired__c,
                                VPM_Commodity__r.VPM_CommodityClass__c,VPM_VATRegistrationNumber__c ,VPM_IsChangedVAT__c, VPM_VendorCodeLookup__r.mdm_ecc__c,
                                VPM_CompanyCode__r.ECC__c, VPM_AdoptScanDate__c FROM VPM_PurchasingRequests__c WHERE Id =: entity.id];                       
        System.debug('@@pr ' + pr ); 
        System.debug('@@op ' + op ); 
        // Start : Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016 
        
        
        //Query to get the permission set for FLS user
        List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :pr.CreatedById AND (NOT PermissionSet.Label like '%Business Requestor%') order by PermissionSet.Label DESC];

        system.debug('@@ permissionsetAssignment' + lstcurrentUserPerSet );
        if(pr.VPM_Status__c.containsIgnoreCase(STR_CONST_DRAFT) || pr.VPM_Status__c.containsIgnoreCase('FLS Approved'))
         {  //pr.VPM_RequestGroupTime__c = system.now();
            pr.VPM_AdvancedFormSubmittedTime__c= system.now();
            pr.VPM_TargetCompletion__c = system.now() + 5;
            
         }
         if(pr.VPM_RequestFromFLSOrBR__c != null)
         {
        if(pr.VPM_RequestFromFLSOrBR__c.containsIgnoreCase('FLS') ) 
        {
        pr.VPM_Status__c='FLS Approved';
        pr.VPM_RequestLastWithGroup__c = STR_CONST_FLS;
       
        }
        else if( pr.VPM_RequestFromFLSOrBR__c != null)
        {
            pr.VPM_Status__c='';
            pr.VPM_RequestLastWithGroup__c = STR_CONST_BR;
            pr.VPM_RequestGroupTime__c = system.now();
        }
        }
        
        system.debug('@@ request last group' + pr.VPM_RequestLastWithGroup__c );
        string finalStringValue = pr.VPM_PaymentMethod__c== null?'': pr.VPM_PaymentMethod__c;
        if(finalStringValue.contains('[') || finalStringValue.contains(',') || finalStringValue.contains('_')) {
            string sText = finalStringValue.replaceAll( '\\s+', '');                
            string payMeth = sText.remove('['); 
            string payMeth1 = payMeth.remove(']');
            List<string> finalStringValueList = payMeth1.split(',');
            finalStringValueList.sort();              
            string paymentMeth=''; 
            for(String str:finalStringValueList) {
                paymentMeth += VPM_HttpUtil.valueBeforeUnderscore(str);
            }
            NewPaymentMethod = paymentMeth.remove(' '); 
        }else {
            List<string> sText2 = finalStringValue.split('-');
            sText2.sort(); 
            string paymentMeth='';  
            for(String str:sText2) 
            {
                paymentMeth += str; 
            }
            NewPaymentMethod = paymentMeth.remove(' '); 
        }
        system.debug('@@NewPaymentMethod' + NewPaymentMethod);
        
        // End : Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016       
        pr.VPM_AdvancedFormSubmitted__c='YES'; 
         if(pr.VPM_Status__c.containsIgnoreCase('DRAFT'))
        {
             pr.VPM_RequestFromFLSOrBR__c=STR_CONST_BR;
             pr.VPM_RequestLastWithGroup__c = STR_CONST_BR;
             pr.VPM_RequestGroupTime__c = system.now();
        }
        else  if(pr.VPM_Status__c.containsIgnoreCase(STR_CONST_FLS))
        {
             pr.VPM_RequestFromFLSOrBR__c=STR_CONST_FLS;
             pr.VPM_RequestLastWithGroup__c = STR_CONST_FLS;
             //pr.VPM_RequestGroupTime__c = system.now();
        }
        if(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN)
        {
           System.debug('@@@@@@@ pr----------'+ pr);
           System.debug('@@@@@@@ op----------'+ op); 
           if(op!=null)
            {
                 NewPaymentTerms= pr.VPM_PaymentTerms__c== null?'': pr.VPM_PaymentTerms__c;
                string oldstring='';
                if(op.CompanyData!=null)
               
                { OldPaymentTerms = op.CompanyData[0].PaymentTerms == null?'': op.CompanyData[0].PaymentTerms;

                 // Start : Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016 
                  oldstring =op.CompanyData[0].PaymentMethod == null?'': op.CompanyData[0].PaymentMethod;  
                }
            
                    List<string> finalOldStringValueList = oldstring.split('-');
                    finalOldStringValueList.sort();
                    string OldpaymentMeth=''; 
                    for(String str:finalOldStringValueList) 
                    {
                        OldpaymentMeth += str; 
                    }                    
                    OldPaymentMethod = OldpaymentMeth.remove(' ');                     
                    system.debug('@@OldPaymentMethod' + OldPaymentMethod);       
                // End Changes with Payment Method : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016    
                
                    
            /*    if(String.isNotBlank(OldPaymentTerms))
                {
                    //if(!(NewPaymentTerms.contains(OldPaymentTerms)))
                    { pr.VPM_ProvidedPaymentTerms__c= true; }
                    else 
                    { pr.VPM_ProvidedPaymentTerms__c= False; }
                } */
                
                if((!(NewPaymentTerms.contains(OldPaymentTerms)))
                  ||
                   (op.CompanyData[0].AdoptScanDate != pr.VPM_AdoptScanDate__c)
                  )
                  { pr.VPM_ProvidedPaymentTerms__c= true; }
                  else 
                  { pr.VPM_ProvidedPaymentTerms__c= False; }

                // VAT Related Change 
                    if((String.isBlank(pr.VPM_VATRegistrationNumber__c) != String.isBlank(op.VATRegistrationNumber)))
                    {  pr.VPM_IsChangedVAT__c= true; }
                    else 
                    { pr.VPM_IsChangedVAT__c= false; }
                
                // FinanciallySensitive Flag Set
                    
            if(op.CompanyData!=null)
                { 
                     NewCashManagementGroup= pr.VPM_CashManagementGroup__c== null?'': pr.VPM_CashManagementGroup__c;
                     OldCashManagementGroup = op.CompanyData[0].CashManagementGroup == null?'': op.CompanyData[0].CashManagementGroup;
                     ReconciliationAccount = op.CompanyData[0].ReconciliationAccount == null?'': op.CompanyData[0].ReconciliationAccount;
                    PaymentBlock = op.CompanyData[0].PaymentBlock == null?'':op.CompanyData[0].PaymentBlock;
                     NewSortKey= pr.VPM_SortKey__c== null?'': pr.VPM_SortKey__c;
                     OldSortKey = op.CompanyData[0].SortKey == null?'': op.CompanyData[0].SortKey;
                    System.debug('op.CompanyData[0].ReconciliationAccount ----'+     pr.VPM_ReconciliationAccount__c!=null);
                    System.debug('pr.VPM_ReconciliationAccount__c ----'+ (pr.VPM_ReconciliationAccount__c != op.CompanyData[0].ReconciliationAccount));
                     if((
                            ( pr.VPM_ReconciliationAccount__c!=null && (pr.VPM_ReconciliationAccount__c != ReconciliationAccount)))
                                ||
                            // ((pr.VPM_PaymentMethod__c  !=null && (String.isBlank(pr.VPM_PaymentMethod__c) != String.isBlank(op.CompanyData[0].PaymentMethod))))
                            // Above line Commneted : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016
                            ((NewPaymentMethod  !=null && NewPaymentMethod != OldPaymentMethod))
                                ||
                           // ((pr.VPM_CashManagementGroup__c !=null && (String.isBlank(pr.VPM_CashManagementGroup__c) != String.isBlank(op.CompanyData[0].CashManagementGroup))))
                           (!(NewCashManagementGroup.contains(OldCashManagementGroup)))
                                ||
                           // ((pr.VPM_SortKey__c !=null && (String.isBlank(pr.VPM_SortKey__c) != String.isBlank(op.CompanyData[0].SortKey))))
                           (!(NewSortKey.contains(OldSortKey)))
                                ||
                            (pr.VPM_PaymentBlock__c !=null && (pr.VPM_PaymentBlock__c!= PaymentBlock))
                                ||
                            ((pr.VPM_CheckDoubleInvoices__c !=null && (pr.VPM_CheckDoubleInvoices__c!=op.CompanyData[0].CheckDoubleInvoices)))     
                        )
                     {  pr.VPM_ProvidedFinancialSensitive__c=true; }
                     else 
                     {     pr.VPM_ProvidedFinancialSensitive__c=false; }
                    }
                    }
                }
            else{
                 //Payment terms Flag  set
                    IF((pr.VPM_PaymentTerms__c !=null)|| 
                       (pr.VPM_AdoptScanDate__c)     
                      )
                    {  pr.VPM_ProvidedPaymentTerms__c= true; }
                    else 
                    { pr.VPM_ProvidedPaymentTerms__c= false; }
                    
                    // is VAT changes in Extend/Create 
                    IF(pr.VPM_VATRegistrationNumber__c!=null)
                    {pr.VPM_IsChangedVAT__c= true;}
                    else 
                    {pr.VPM_IsChangedVAT__c= false;}
                // FinanciallySensitive Flag Set
         
                    if((pr.VPM_ReconciliationAccount__c!=null)||(pr.VPM_PaymentMethod__c !=null)||
                  //  (pr.VPM_PaymentBlock__c !=null)||
                  //  Above line Commneted : IAVMD-1793 : Approval Process Adaptation On 17 Oct 2016
                        (NewPaymentMethod !=null)||(pr.VPM_CashManagementGroup__c!= null)||(pr.VPM_SortKey__c !=null)||(pr.VPM_CheckDoubleInvoices__c))
                    {  pr.VPM_ProvidedFinancialSensitive__c= true;   } 
                    else 
                    { pr.VPM_ProvidedFinancialSensitive__c= false; }
                }
                    
                // Bank Details Flag Set 
                    if((pr.VPM_BankCountryKey__c!=null)|| (pr.VPM_BankKey__c !=null)||(pr.VPM_BankAccountNumber__c !=null)||(pr.VPM_AccountHolderName__c !=null)||(pr.VPM_ReferenceSpecificationsBankDetail__c !=null)||(pr.VPM_BankControlKey__c!=null)||(pr.VPM_IBAN__c!=null)||(pr.VPM_PartnerBankType__c!=null)||(pr.VPM_BankName__c !=null)||(pr.VPM_SwiftKey__c!=null)||(pr.VPM_CollectionAuthorization__c )) 
                    {   pr.VPM_ProvidedBankDetails__c= true; }
                    else 
                    {   pr.VPM_ProvidedBankDetails__c= false; }
     
                // Unblock/UnDelete Flag set 
                    if((pr.VPM_DeletionBlockFlag__c!=null))
                    {
                        // UnDelete/UnBlock flag Set 
                        if((pr.VPM_DeletionBlockFlag__c.contains(STR_CONST_UNDELETE)) || (pr.VPM_DeletionBlockFlag__c.contains(STR_CONST_UNBLOCK)))
                            { 
                                pr.VPM_ProvidedUnblockUndelete__c= true;
                                pr.VPM_ProvidedBlockDelete__c= false;  
                            }
                         // Delete/Block flag Set
                         if((pr.VPM_DeletionBlockFlag__c.contains(STR_CONST_BLOCK)) || (pr.VPM_DeletionBlockFlag__c.contains(STR_CONST_DELETE)))
                            {
                                pr.VPM_ProvidedBlockDelete__c= true;
                                pr.VPM_ProvidedUnblockUndelete__c= false;
                                pr.VPM_ProvidedFinancialSensitive__c=false;
                                pr.VPM_ProvidedPaymentTerms__c= false;
                                pr.VPM_ProvidedPaymentTerms__c= false;
                                pr.VPM_ProvidedBankDetails__c= false;
                            }                
                 }
                 
                 if (pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND)
                 {
                  if(pr.VPM_VendorCodeLookup__r.mdm_ecc__c.containsIgnoreCase(pr.VPM_CompanyCode__r.ECC__c))
                   { ExtendType   ='Regional';}
                  else{ ExtendType='Global';}
                 }
             
        if(pr.VPM_VendorType__c!=null)
        {
            if(pr.VPM_VendorType__c.contains(STR_CONST_RUSSIAN))
            {
                pr.VPM_RussianTaxApprovalRequired__c =true;
                pr.VPM_FreightApprovalRequired__c  =false;   
            }
            
            else if(pr.VPM_VendorType__c.contains(STR_CONST_FREIGHT))
            {
                pr.VPM_FreightApprovalRequired__c  =true;
                pr.VPM_RussianTaxApprovalRequired__c =false; 
                // Changes for Bug 346
                if((pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN) && ((!pr.VPM_ProvidedBlockDelete__c) && (!pr.VPM_ProvidedUnblockUndelete__c)  && (!pr.VPM_ProvidedPaymentTerms__c)))
               // {
                     //if ((!pr.VPM_ProvidedBlockDelete__c) && (!pr.VPM_ProvidedUnblockUndelete__c)  && (!pr.VPM_ProvidedPaymentTerms__c))
                     { pr.VPM_FreightApprovalRequired__c  =false; }
               // }
                //End  Changes for Bug 346
            }
        }
        
         GlobalAuthorisationGroup= pr.VPM_GlobalAuthorisationGroup__c== null?'': pr.VPM_GlobalAuthorisationGroup__c;
        // Call to the function setProcurementApprovalRequired() which set the flag Procurement approval is required 
        setProcurementApprovalRequired(ExtendType);
        
        // Call to the function setFinanceApprovalRequired() which set the flag Finance approval is required 
        setFinanceApprovalRequired(ExtendType);

        System.debug(' End @@@@@@ VPM_FinanceApprovalRequired__c--------------------' +pr.VPM_FinanceApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_ProcurementApprovalRequired__c--------------------' +pr.VPM_ProcurementApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_FreightApprovalRequired__c--------------------' +pr.VPM_FreightApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_RussianTaxApprovalRequired__c--------------------' +pr.VPM_RussianTaxApprovalRequired__c);
        System.debug(' End @@@@@@ VPM_ProvidedPaymentTerms__c--------------------' +pr.VPM_ProvidedPaymentTerms__c);
        System.debug(' End @@@@@@ VPM_ProvidedBankDetails__c--------------------' +pr.VPM_ProvidedBankDetails__c);
        System.debug(' End @@@@@@ VPM_ProvidedFinancialSensitive__c--------------------' +pr.VPM_ProvidedFinancialSensitive__c);
        System.debug(' End @@@@@@ VPM_ProvidedBlockDelete__c--------------------' +pr.VPM_ProvidedBlockDelete__c);
        System.debug(' End @@@@@@ VPM_ProvidedUnblockUndelete__c--------------------' +pr.VPM_ProvidedUnblockUndelete__c);

        // Setting VPM_NumberofApprovalsRequired__c flag 
        if((pr.VPM_FinanceApprovalRequired__c)|| (pr.VPM_ProcurementApprovalRequired__c)|| (pr.VPM_FreightApprovalRequired__c)|| (pr.VPM_RussianTaxApprovalRequired__c))
        {
            if ((pr.VPM_FinanceApprovalRequired__c ) && (pr.VPM_FreightApprovalRequired__c)) 
            { pr.VPM_NumberofApprovalsRequired__c=2; }

            else if((pr.VPM_FinanceApprovalRequired__c ) && (pr.VPM_ProcurementApprovalRequired__c))
            {  pr.VPM_NumberofApprovalsRequired__c=2; }

            else if((pr.VPM_FreightApprovalRequired__c ) && (pr.VPM_ProcurementApprovalRequired__c))
            { pr.VPM_NumberofApprovalsRequired__c=2; }              
            else
            { pr.VPM_NumberofApprovalsRequired__c=1;}
        } 
        else
        { pr.VPM_NumberofApprovalsRequired__c=0; }
        
        // Call to the function setLevelApproval : which decide 3 Level  of approval for Maintain  & L2  need  Excluded/included for Creaate/Extend 
        setLevelApproval(ExtendType);
        /* Start Changes By Samrin : on 2 Nov 2016 : IAVMD-1857 - Changes on maintain scenario are not visible to approver */
        if(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN) 
        {
            RecordTypeApprovalChanges='';
            if(pr.VPM_ProvidedPaymentTerms__c)
            {  RecordTypeApprovalChanges=RecordTypeApprovalChanges+System.Label.VPM_ChangePaymentTermsDetails + ' ,' ; }
            
            if(pr.VPM_ProvidedBankDetails__c)
            { RecordTypeApprovalChanges=RecordTypeApprovalChanges+System.Label.VPM_ChangeBankDetails + ' ,' ; }
            
            if(pr.VPM_ProvidedFinancialSensitive__c)
            {  RecordTypeApprovalChanges=RecordTypeApprovalChanges+System.Label.VPM_ChangeFinancialSensitive + ' ,'; }
            
            if (pr.VPM_ProvidedBlockDelete__c)
            {  RecordTypeApprovalChanges=RecordTypeApprovalChanges+System.Label.VPM_ChangeBlockDelete+ ' ,'; }
            
            if(pr.VPM_ProvidedUnblockUndelete__c)
            { RecordTypeApprovalChanges=RecordTypeApprovalChanges+System.Label.VPM_ChangeUnBlockUnDelete + ' ,'; }
                
            if(pr.VPM_IsChangedVAT__c)
            {  RecordTypeApprovalChanges=RecordTypeApprovalChanges+System.Label.VPM_ChangeGeneralVendorDetails + ' ,'; }
            
            RecordTypeApprovalChanges = RecordTypeApprovalChanges.removeEnd(',');
            pr.VPM_RequestType__c=RecordTypeApprovalChanges;
            
        
        }
        /* End Changes By Samrin   : on 2 Nov 2016 : IAVMD-1857 - Changes on maintain scenario are not visible to approver */

    }  
    /*  End of Function approvalCallMethod  : VPM - Used to set the flag based on the fields  which will help to triggr the approval process */
     /******************************************************************** 
    FunctionName : setProcurementApprovalRequired  
    Created By   : Samrin Shaikh
    Created Date : 10th Oct 2016
    Last Modify  : N/A
    Description  : VPM - Used to set setProcurementApprovalRequired Based on the fields
    Return Type  : null
    ********************************************************************/
public void setProcurementApprovalRequired(string ExdType)
{
if(((pr.VPM_VendorType__c!=null) && (!pr.VPM_FinanceApprovalRequired__c) && (!pr.VPM_RussianTaxApprovalRequired__c) && (pr.VPM_GlobalAuthorisationGroup__c!=null))
   && 
   ( 
                            /*MBS/SCS Capex-MRO Vendors Create or Extend*/                 
                            (pr.RecordType.DeveloperName != STR_CONST_RECORDTYPEMAINTAIN && pr.VPM_Commodity_Family__c != STR_CONST_OUTOFSCOPE 
                             && 
                            ( (pr.VPM_VendorType__c.contains(STR_CONST_MBS) && (!GlobalAuthorisationGroup.contains(STR_CONST_LAKME)))|| GlobalAuthorisationGroup.contains(STR_CONST_SCSCAPEX))                     
                            )
                            ||

                            /*MBS/SCS Capex-MRO Vendors Maintain*/
                        (pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN &&
                            ((pr.VPM_VendorType__c.contains(STR_CONST_MBS) &&(!GlobalAuthorisationGroup.contains(STR_CONST_LAKME)))|| GlobalAuthorisationGroup.contains(STR_CONST_SCSCAPEX)
                            )
                            && pr.VPM_Commodity_Family__c != STR_CONST_OUTOFSCOPE
                            && ( pr.VPM_ProvidedUnblockUndelete__c ||  pr.VPM_ProvidedBlockDelete__c || pr.VPM_ProvidedPaymentTerms__c  )
                         )
                        ||

                        /*SCS Logistics*/ 
                        ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN  && GlobalAuthorisationGroup.contains(STR_CONST_SCSLOG) &&  pr.VPM_ProvidedPaymentTerms__c
                        )
                        ||

                        /*USCC/UASCC related MBS/SCS Capex 2611, 5449, 5496, 5487 Create or Extend*/ 
                        (pr.RecordType.DeveloperName != STR_CONST_RECORDTYPEMAINTAIN  &&
                         ((pr.VPM_VendorType__c.contains(STR_CONST_MBS) &&(!GlobalAuthorisationGroup.contains(STR_CONST_LAKME)))|| GlobalAuthorisationGroup.contains(STR_CONST_SCSCAPEX) 
                         )
                         && pr.VPM_Commodity_Family__c != STR_CONST_OUTOFSCOPE 
                         &&
                         (pr.VPM_Company_Code_Value__c == '2611' ||   pr.VPM_Company_Code_Value__c == '5449' ||  pr.VPM_Company_Code_Value__c == '5496' ||  pr.VPM_Company_Code_Value__c == '5487'
                         ))
                        ||
                        
                        /*USCC/UASCC related MBS/SCS Capex 2611, 5449, 5496, 5487 Maintain*/ 
                        (pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN  &&
                         ( (pr.VPM_VendorType__c.contains(STR_CONST_MBS) &&(!GlobalAuthorisationGroup.contains(STR_CONST_LAKME)))|| GlobalAuthorisationGroup.contains(STR_CONST_SCSCAPEX) 
                         ) && pr.VPM_Commodity_Family__c != STR_CONST_OUTOFSCOPE &&
                         ( pr.VPM_ProvidedUnblockUndelete__c  ||  pr.VPM_ProvidedBlockDelete__c  ||  pr.VPM_ProvidedPaymentTerms__c)
                         &&
                         ( pr.VPM_Company_Code_Value__c == '2611' ||   pr.VPM_Company_Code_Value__c == '5449' ||   pr.VPM_Company_Code_Value__c == '5496' ||  pr.VPM_Company_Code_Value__c == '5487'
                         ))
                )
  )
        {
                      
                    {
                        pr.VPM_ProcurementApprovalRequired__c = true;
                        pr.VPM_RussianTaxApprovalRequired__c =false;
                    }
           
        }
}     
/*  End of Function setProcurementApprovalRequired  : Used to set setProcurementApprovalRequired field which will trigger the Procurement  approval process  Based on the fields update & Vendor Type */

     /******************************************************************** 
    FunctionName : setFinanceApprovalRequired  
    Created By   : Samrin Shaikh
    Created Date : 10th Oct 2016
    Last Modify  : N/A
    Description  : VPM - Used to set setFinanceApprovalRequired field which will trigger the Fiance approval process  Based on the fields update & Vendor Type 
    Return Type  : null
    ********************************************************************/
public void setFinanceApprovalRequired(String ExdType)
{
    System.debug('@@@@@@  ExdType'+ ExdType);
    System.debug('pr.VPM_IsChangedVAT__c@@@@@@ '+ pr.VPM_IsChangedVAT__c );
    
    
    if((pr.VPM_VendorType__c!=null && (!pr.VPM_RussianTaxApprovalRequired__c) &&  GlobalAuthorisationGroup !=null)
      && 
       (
                (
                    /*MBS(Indirect) Others (Out Scope Proc)*/ 
                    (pr.VPM_VendorType__c.contains(STR_CONST_MBS))  &&  pr.VPM_Commodity_Family__c == STR_CONST_OUTOFSCOPE
                    && (pr.RecordType.DeveloperName == STR_CONST_RECORDTYPECREATE || pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND
                        ||
                    ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN &&
                     (pr.VPM_ProvidedUnblockUndelete__c  || pr.VPM_ProvidedBlockDelete__c  ||  pr.VPM_ProvidedPaymentTerms__c  || pr.VPM_ProvidedBankDetails__c  ||  pr.VPM_ProvidedFinancialSensitive__c )
                    )) 
                 )
                 ||
                 (
                 /* Freight,SCS Log*/ 
                     (pr.VPM_VendorType__c.contains(STR_CONST_FREIGHT) || GlobalAuthorisationGroup.contains(STR_CONST_SCC_L))
                    && pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN && ( pr.VPM_ProvidedBankDetails__c  ||  pr.VPM_ProvidedFinancialSensitive__c )
                 )
                 ||
                (
                 /* SCS Log*/ 
                     (GlobalAuthorisationGroup.contains(STR_CONST_SCC_L)) && (pr.RecordType.DeveloperName != STR_CONST_RECORDTYPEMAINTAIN)
                 )
                 ||
                 (
                    /*PI,3PM*/ 
                    (pr.VPM_VendorType__c.contains(STR_CONST_PI)  || 
                    (pr.VPM_VendorType__c.contains(STR_CONST_SCS) && GlobalAuthorisationGroup.contains(STR_CONST_3PM))
                    )  &&
                    ( pr.RecordType.DeveloperName != STR_CONST_RECORDTYPEMAINTAIN  ||
                        ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN &&
                            ( pr.VPM_ProvidedUnblockUndelete__c  || pr.VPM_ProvidedBlockDelete__c  ||  pr.VPM_ProvidedPaymentTerms__c  ||  pr.VPM_ProvidedBankDetails__c ||  pr.VPM_ProvidedFinancialSensitive__c  || pr.VPM_IsChangedVAT__c 
                            )
                        )
                    )
                )
                ||
                (
                 /*USCC/UASCC,MBS/SCSCap,2611,5449,5496,5487*/ 
                 (pr.VPM_VendorType__c.contains(STR_CONST_MBS) || GlobalAuthorisationGroup.contains(STR_CONST_CAP))
                 &&   pr.VPM_Commodity_Family__c != STR_CONST_OUTOFSCOPE
                 && (pr.VPM_Company_Code_Value__c == '2611' || pr.VPM_Company_Code_Value__c == '5449'   || pr.VPM_Company_Code_Value__c == '5496' || pr.VPM_Company_Code_Value__c == '5487')
                 &&
                  /*  pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN
                 &&
                    (   
                                pr.VPM_ProvidedBankDetails__c  || pr.VPM_IsChangedVAT__c  || pr.VPM_ProvidedFinancialSensitive__c 
                    ) */ 
                    ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPECREATE ||
                      (pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND  && ExdType=='Global' && pr.VPM_IsChangedVAT__c  )
                     
                    || ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN && (  pr.VPM_ProvidedBankDetails__c  ||   pr.VPM_ProvidedFinancialSensitive__c  || pr.VPM_IsChangedVAT__c ) )
                    )
                )
                ||
                (
                    /* USCC/UASCC,MBS(Indir)2611,5449,5496,5487*/
                    (pr.VPM_VendorType__c.contains(STR_CONST_MBS))  && pr.VPM_Commodity_Family__c == STR_CONST_OUTOFSCOPE
                    &&
                    (pr.VPM_Company_Code_Value__c == '2611' || pr.VPM_Company_Code_Value__c == '5449' 
                    || pr.VPM_Company_Code_Value__c == '5496' || pr.VPM_Company_Code_Value__c == '5487')
                    &&
                    ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPECREATE || pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND
                    ||
                        ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN &&
                            ( pr.VPM_ProvidedUnblockUndelete__c  || pr.VPM_ProvidedBlockDelete__c  ||  pr.VPM_ProvidedPaymentTerms__c  ||  pr.VPM_ProvidedBankDetails__c  ||   pr.VPM_ProvidedFinancialSensitive__c  || pr.VPM_IsChangedVAT__c  )
                        )
                    )
                )
                ||
                (
                    /*MBS Lakme,SCS Unica*/ 
                    (
                     (pr.VPM_VendorType__c.contains(STR_CONST_MBS) && GlobalAuthorisationGroup.contains(STR_CONST_LAKME) && pr.VPM_Commodity_Family__c != STR_CONST_OUTOFSCOPE)
                     || (pr.VPM_VendorType__c.contains(STR_CONST_SCS) && GlobalAuthorisationGroup.contains(STR_CONST_UNICA))
                    )
                    &&
                    ( pr.RecordType.DeveloperName != STR_CONST_RECORDTYPEMAINTAIN ||
                        ( pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN &&
                            ( pr.VPM_ProvidedUnblockUndelete__c  ||pr.VPM_ProvidedBlockDelete__c  ||  pr.VPM_ProvidedPaymentTerms__c  ||    pr.VPM_ProvidedBankDetails__c  ||   pr.VPM_ProvidedFinancialSensitive__c   )
                        )
                    )                
                )
                ||
                (
                    /*MBS/SCS Cap-MRO*/
                     (pr.VPM_VendorType__c.contains(STR_CONST_MBS) || GlobalAuthorisationGroup.contains(STR_CONST_CAP))
                     &&
                     pr.VPM_Commodity_Family__c != STR_CONST_OUTOFSCOPE 
                     &&
                    ((pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN && (pr.VPM_ProvidedBankDetails__c  ||  pr.VPM_ProvidedFinancialSensitive__c )) || (pr.RecordType.DeveloperName != STR_CONST_RECORDTYPEMAINTAIN) )
                )
              ) 
      
      )
        {
          
            {
                pr.VPM_FinanceApprovalRequired__c=true;
                pr.VPM_RussianTaxApprovalRequired__c =false;
            }
        }
}
  /*  End of Function setProcurementApprovalRequired  : VPM - Used to set setFinanceApprovalRequired field which will trigger the Fiance approval process  Based on the fields update & Vendor Type */

   /******************************************************************** 
    FunctionName : setLevelApproval  
    Created By   : Samrin Shaikh
    Created Date : 10th Oct 2016
    Last Modify  : N/A
    Description  : VPM - Used to set L3 Approval process for Maintain Request & L2 should need to inculde/Exculde  for Create/Extend Request 
    Return Type  : null
    ********************************************************************/
Public void setLevelApproval(string ExdType)
{
         if (pr.RecordType.DeveloperName != STR_CONST_RECORDTYPEMAINTAIN)
        {
            VPM_L2InculdeApproval__c  approvalRequired = VPM_L2InculdeApproval__c.getInstance(pr.VPM_CountryRequestingVendor__c);
            System.debug('approvalRequired ' + approvalRequired);
            
           System.debug('@@@@ Reg  '  + (!(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND  && ExdType=='Regional' && pr.VPM_ProvidedBankDetails__c ) 
                       ));
            System.debug('@@@@ Global  '+  (!(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND  && ExdType=='Global' && pr.VPM_IsChangedVAT__c ) ));
          if((approvalRequired != null) && (approvalRequired.VPM_L2CreateExtendApproval__c && pr.VPM_NumberofApprovalsRequired__c == 2  && pr.VPM_FinanceApprovalRequired__c )  )
{

                        if(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND)
                        {
                            if(ExdType=='Global')
                            {
                              if(!(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND  && ExdType=='Global' && pr.VPM_IsChangedVAT__c ) )
                              {
                                    System.debug('!!! Global ');
                                    pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                                    pr.VPM_FinanceApprovalRequired__c= false;
                              }
                            }
                            else if(ExdType=='Regional')
                            {
                                if(!(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND  && ExdType=='Regional' && pr.VPM_ProvidedBankDetails__c ) )
                                {
                                    System.debug('!!! Regional ');
                                    pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                                    pr.VPM_FinanceApprovalRequired__c= false;
                                    
                                }
                            }
                        }
                        else 
                        {
                            System.debug('!!! my ');
                            pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                            pr.VPM_FinanceApprovalRequired__c= false;
                        }
}
else if(approvalRequired==null && pr.VPM_FinanceApprovalRequired__c) // Changes for the bug  By Samrin on 4th Nov :  IAVMD-2325 : L2 Approvals for Sirius and Cordillera not working 
{
      if(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND)
      {
            if(ExdType=='Global')
            {
                if(!(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND  && ExdType=='Global' && pr.VPM_IsChangedVAT__c ) )
                {
                     System.debug('!!! 22222  Global ');
                     pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                     pr.VPM_FinanceApprovalRequired__c= false;
                }
            }
            else if(ExdType=='Regional')
            {
                if(!(pr.RecordType.DeveloperName == STR_CONST_RECORDTYPEEXTEND  && ExdType=='Regional' && pr.VPM_ProvidedBankDetails__c ) )
                {
                    System.debug('!!!  2222   Regional ');
                    pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
                    pr.VPM_FinanceApprovalRequired__c= false;
                                    
                }
            }
     }
     else 
     {
            System.debug('!!! my ');
            pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1; 
            pr.VPM_FinanceApprovalRequired__c= false;
     }
}
            // End Changes for the bug  By Samrin on 4th Nov :  IAVMD-2325 : L2 Approvals for Sirius and Cordillera not working 
        }
        
        if(pr.RecordType.DeveloperName != STR_CONST_RECORDTYPECREATE) 
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
            //  Samrin Shaikh : Change for Bug No : 1409 : on 29 sept 2016 
             else if(pr.VPM_RussianTaxApprovalRequired__c)
             {
                if((pr.VPM_ProvidedBankDetails__c) &&  (!pr.VPM_ProvidedBlockDelete__c) && (!pr.VPM_ProvidedUnblockUndelete__c))
                {
                    pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c +1; 
                    pr.VPM_BankDataValidationRequired__c=true;
                }
                  //  Samrin Shaikh : Change for Bug No : 1388  : on 29 sept 2016 
                 else if((!pr.VPM_ProvidedPaymentTerms__c) && (!pr.VPM_ProvidedBankDetails__c) &&  (!pr.VPM_ProvidedFinancialSensitive__c) &&  (!pr.VPM_ProvidedBlockDelete__c) &&  (!pr.VPM_ProvidedUnblockUndelete__c))
                 { pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1;  }
                 //  Samrin Shaikh :  End Change for Bug No : 1388  : on 29 sept 2016
            
             }
            //  Samrin Shaikh :   Change for Bug No : 1389  : on 29 sept 2016
             else if(pr.VPM_FreightApprovalRequired__c)
             {
                if((!pr.VPM_ProvidedPaymentTerms__c) && (!pr.VPM_ProvidedBankDetails__c) && (!pr.VPM_ProvidedFinancialSensitive__c) &&  (!pr.VPM_ProvidedBlockDelete__c) &&(!pr.VPM_ProvidedUnblockUndelete__c))
                {  pr.VPM_NumberofApprovalsRequired__c= pr.VPM_NumberofApprovalsRequired__c - 1;  }
             } //  Samrin Shaikh :  End Change for Bug No : 1389  : on 29 sept 2016
            
             //  Samrin Shaikh : End of  Change for Bug No : 1409 : on 29 sept 2016 
                 
        }
         
}
 /*  End of Function setLevelApproval  : VPM - Used to set L3 Approval process for Maintain Request & L2 should need to inculde/Exculde  for Create /Extend Request */
   
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

                                                                      
        if(lstcurrentUserPerSet[0].PermissionSet.Label.contains(STR_CONST_FLS)) {
            AdvancedFormSubmitter = STR_CONST_FLS;
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains(STR_CONST_STATUS_MDM)) {
            AdvancedFormSubmitter = 'MDM Ops';
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains(STR_CONST_FINANCE)) {
            AdvancedFormSubmitter = STR_CONST_FINANCE;
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains(STR_CONST_FREIGHT)) {
            AdvancedFormSubmitter = STR_CONST_FREIGHT;
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains(STR_CONST_RUSSIAN)) {
            AdvancedFormSubmitter = STR_CONST_RUSSIAN;
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains(STR_CONST_PROCUREMENT)) {
            AdvancedFormSubmitter = STR_CONST_PROCUREMENT;
        } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains(STR_CONST_BR)) {
            AdvancedFormSubmitter = STR_CONST_BR;
        }
        
        return AdvancedFormSubmitter;
    }
       
    /*  End of Function  GetAdvancedFormSubmitter  : VPM - Used to set the AdvancedFormSubmitter  base on permission set */
    
      /******************************************************************** 
    
    Created By   : Samrin Shaikh
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used to set display the error message when the Commoditiy Approval is not defined for selected country or when the Approver 1-10 all are null 
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
            
            if(purchReqVar.RecordType.DeveloperName == STR_CONST_RECORDTYPEMAINTAIN)    
             {
                if(string.isNotBlank(purchReqVar.VPM_DeletionBlockFlag__c))
                {
                    approvalCallMethod();
                    pr.VPM_AdvancedFormSubmitter__c=GetAdvancedFormSubmitter();
                    msg=ProcurementApproval();
                    System.debug('@@@@ ErrorMessage'+msg);
                    if(msg <> null)
                    {
                        Errormsgblock= True ;
                        GoldenDatablock=false;
                        ApexPages.addMessage(msg);
                       /* Start : 7 Nov Samrin  Changes for : IAVMD-2299 : Block-Delete Vendor - Warning message on new page  */
                            pg=ErrorMessage(msg.getSummary());
                            return  pg;   
                         /*  End  7 Nov Samrin  Changes for : IAVMD-2299 : Block-Delete Vendor - Warning message on new page  */
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
                    if(((VendorBlockUnblockDelete.contains(STR_CONST_BLOCK)) || (VendorBlockUnblockDelete.contains(STR_CONST_DELETE))) &&  (string.isBlank(purchReqVar.VPM_DeletionBlockFlag__c)) )
                    {
                       // if(string.isBlank(purchReqVar.VPM_DeletionBlockFlag__c)){
                            msg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_BlockDeleteVendorErrorMeesage);
                            Errormsgblock= True ;
                            GoldenDatablock=false;
                            ApexPages.addMessage(msg); 
                        /* Start : 7 Nov Samrin  Changes for : IAVMD-2299 : Block-Delete Vendor - Warning message on new page  */
                            pg=ErrorMessage(msg.getSummary());
                            return  pg;   
                         /*  End  7 Nov Samrin  Changes for : IAVMD-2299 : Block-Delete Vendor - Warning message on new page  */
                       // }
                    }
                }
            }
            return  null; 
        }
        catch(exception ex){
            System.debug('Exception in ApprovalMaintain1 Function');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }
    }
    /* End of Function ApprovalMaintain1  : VPM - it is call  when the request is Block/Unblock/Delete/Undelete it is called in consturctor   */
    
     /******************************************************************** 
    
    Created By   : Samrin Shaikh
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used to call webservice based on selected vendor & Used to compare the data so that correct approval get trigger 
    Return Type  : VPM_ECCVendorSearchServiceOutput
    ********************************************************************/
    
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
        system.debug('@@ipList' + ipList);
        opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
        system.debug('@@ipList' + ipList);
        system.debug('@@opList' + opList);
        return opList[0];
    }
    
      /******************************************************************** 
    
    Created By   : Samrin Shaikh
    Created Date : 7 Nov  2016
    Last Modify  : N/A
    Description  : IAVMD-2299 : Block-Delete Vendor - Warning message on new page
    Return Type  : pagereference
    ********************************************************************/
  Public pagereference  ErrorMessage(String message)
        {
            System.debug('@@@@@@message ------'+ message);
            if(message != null)
            {              
                    ApexPages.PageReference pr = new ApexPages.PageReference('/apex/VPM_ErrorMessage?id=' +purid);
                    pr.GetParameters().Put('message', message);
                    pr.SetRedirect(true);
                    return pr;          
            }
            Return Null;
    
        } 
    
       /******************************************************************** 
    Func.Name    : saveAndBackToLaunchScreen
    Created By   : Vaishali
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used  redirect to the Launch screen 
    Return Type  : pagereference
    ********************************************************************/
    
    public pagereference saveAndBackToLaunchScreen() {
        ApexPages.Message msg;
        msg = checkValidations();
            if(msg <> null){
            
                ApexPages.addMessage(msg);
                return null;
            
            }else
            {
                commonSaveMethod();
                Pagereference pg = backToFlow();
                return pg;
            }
    }
    
      /******************************************************************** 
    Func.Name    : backToFlow
    Created By   : Vaishali
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used  redirect to the Adv. Application 
    Return Type  : pagereference
    ********************************************************************/
    
    public pagereference backToFlow()
    {
        string queryString = '&back=' + 'true';
       // Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); 
         Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + entity.id + queryString); 
        pg.setRedirect(true);
        return pg;
    }
    
    //Edited for IAVMD-1475
     /******************************************************************** 
    Func.Name    : backToGlobalScreen
    Created By   : Vaishali
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used  redirect to Global Golden Data page from Regional Golden Data 
    Return Type  : pagereference
    ********************************************************************/
    
    public pagereference backToGlobalScreen()
    {
        string queryString = '&back=' + 'true';
        Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); 
        if(recordTypeId=='Create' || (recordTypeId =='Extend' && purchReqVar.VPM_ExtensionType__c=='Global')){
             pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + entity.id + queryString); 
        }else if(recordTypeId==STR_CONST_MAINTAIN){
        
            if(purchReqVar.VPM_FieldType__c ==STR_CONST_REGIONAL || purchReqVar.VPM_FieldType__c ==null)
            { pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); }
            else
            {  pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + entity.id + queryString); }
        }else if(recordTypeId=='Extend'){
            if(purchReqVar.VPM_ExtensionType__c==STR_CONST_REGIONAL && (purchReqVar.VPM_FieldType__c==null || purchReqVar.VPM_FieldType__c ==STR_CONST_REGIONAL))
            { pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); }
           else 
           {  pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + purid + queryString); }
        }
        
        pg.setRedirect(true);
        return pg;
    }
    
       /******************************************************************** 
    Func.Name    : backToGoldenData1
    Created By   : Vaishali
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used  redirect to  Golden Data page 
    Return Type  : pagereference
    ********************************************************************/
    public pagereference backToGoldenData1()
    {
        string queryString = '&back=' + 'true';
        Pagereference pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + entity.id + queryString); 
        pg.setRedirect(true);
        return pg;
    }
    

    
   
}