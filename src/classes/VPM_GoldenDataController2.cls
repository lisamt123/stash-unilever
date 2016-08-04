public class VPM_GoldenDataController2 {

    public VPM_PurchasingRequests__c entity{get;set;}
    public VPM_CommodityCode__c commodityCodeVar{get;set;}
    public VPM_PurchasingRequests__c purchReqVar{get;set;}
    public Boolean isRequired{get;set;}
    public Boolean isRequiredFieldCountry{get;set;}
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
   // public List<ApprovalFlagWrapper> lst {get;set;}
    //public List<ApprovalFlagWrapper> display_list {get; set;} 
   
    public static final string PURCHASING_ORG = 'Purchasing Organisation';
    public static final string CASH_MGMT = 'Cash mgmnt group';
    
    
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
                       VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,VPM_Street1__c,
                       VPM_ProcurementApprovalRequired__c,VPM_Location__c,VPM_City__C,
                       VPM_OrderingEmailAddress__c,VPM_PaymentTerms__c,VPM_BankCountryKey__c,VPM_Country__c,
                       VPM_BankKey__c,VPM_BankAccountNumber__c,VPM_AccountHolderName__c,
                       VPM_Commodity__r.VPM_Vendor_Type__c,VPM_Commodity__r.VPM_Authorisation_Group__c,
                       VPM_ReferenceSpecificationsBankDetail__c,VPM_BankControlKey__c,
                       VPM_IBAN__c,VPM_CollectionAuthorization__c,VPM_Commodity__r.VPM_Commodity_Code__c,
                       VPM_PartnerBankType__c,VPM_BankName__c,VPM_SwiftKey__c,VPM_Commodity__r.Name,
                       VPM_ReconciliationAccount__c,VPM_PaymentMethod__c,VPM_VendorName1__c,VPM_SearchTerm_1__c,
                       VPM_GRbasedIV__c,VPM_AutomaticPurchaseOrderGeneration__c,VPM_AlreadyAvailableSupplierUse__c,
                       VPM_PaymentBlock__c,VPM_DeletionBlockFlag__c,VPM_AccountGroup__c,
                       VPM_GlobalAuthorisationGroup__c,RecordType.DeveloperName,
                       VPM_Commodity__r.VPM_CommodityFamily__c,VPM_Is_changed_VAT__c,VPM_Company_Code_Value__c,
                       VPM_CashManagementGroup__c, VPM_PurchasingOrganisation__c,VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,
                       VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c,
                       VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,VPM_Spend__c,
                       VPM_Incoterms1__c,VPM_CompanyCode__r.ecc__c
                       FROM VPM_PurchasingRequests__c WHERE Id =: entity.id];                       
        System.debug('@@purchReqVar ' + purchReqVar );     
        
        
        VendorName = purchReqVar.VPM_VendorName1__c;
        searchTerm1 = string.isNotBlank(VendorName) ? VendorName.left(10) : '';
         
        vendorCashManagementGrp = purchReqVar.VPM_CashManagementGroup__c;
        //purchasingOrg = getPurchasingOrgItems();
        vendorPurchasingOrg = purchReqVar.VPM_PurchasingOrganisation__c;
        tradepartnerType=purchReqVar.VPM_TradePartnerType__c;
        
        //Make spend field required only when commodity code starts with 0
        isRequiredSpend =true; // by default shld always be required
        if(string.isNotBlank(purchReqVar.VPM_Commodity__r.Name) && purchReqVar.VPM_Commodity__r.Name.startsWith('0'))           
            isRequiredSpend = false;
        else                
            isRequiredSpend =true;            
        
        
        if(purchReqVar.VPM_CompanyCode__r.ecc__c <> '' && purchReqVar.VPM_CompanyCode__r.ecc__c <> null)
            entity.VPM_ECC__c = purchReqVar.VPM_CompanyCode__r.ecc__c;
        
        system.debug('@@ ECC' + entity.VPM_ECC__c);
        
        purid = entity.id;
        
        
        purchasingOrg = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, PURCHASING_ORG);
        CashManagementGrp = getRegionSpecificCustomSettingvalues(entity.VPM_ECC__c, CASH_MGMT);
        
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
        
        IF(entity.VPM_Country__c == VENDOR_COUNTRY)
        {
            isRequiredFieldCountry = true;
        }
        else {
            isRequiredFieldCountry = false;             
        }           

        
        vendorCashManagementGrp = purchReqVar.VPM_CashManagementGroup__c;
        //purchasingOrg = getPurchasingOrgItems();
        vendorPurchasingOrg = purchReqVar.VPM_PurchasingOrganisation__c;
        //CashManagementGrp=getCashManagementGrp();
        //tradePartnerTypeList = getTradePartnerType();    
   
       
    }
    catch(exception ex){}
    
       
    }

    
        
        /* -- Samrin Shaikh : Added the Sorting for the Picklist Value */
      
  /*  public List<SelectOption>  getPurchasingOrgItems(){
        Map<String, VPM_RegionSpecificFields__c> settings = VPM_RegionSpecificFields__c.getAll();
        List<String> settingNames = new List<String>();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        settingNames.addAll(settings.keySet());
        settingNames.sort();
        System.debug('Alsana  --------'+settingNames);
        //now if you can for example create SelectOptions
        for (String s : settingNames) {
            VPM_RegionSpecificFields__c region = settings.get(s);
            if(region.Region__c == entity.VPM_ECC__c && region.Picklist_Name__c =='Purchasing Organisation'){
                options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            }
        }
        return options;
    } 

    // End -- Samrin Shaikh : Added the Sorting for the Picklist Value 

    public List<SelectOption> getCashManagementGrp(){
        
        Map<String, VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll();
        List<String> settingNames = new List<String>();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        settingNames.addAll(getPicklistValues.keySet());
        settingNames.sort();
        System.debug('Alsana  --------'+settingNames);
        for (String s : settingNames) {
            VPM_RegionSpecificFields__c region = getPicklistValues.get(s);
            if(region.Region__c == entity.VPM_ECC__c && region.Picklist_Name__c =='Cash mgmnt group'){
                options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            }
        }
        return options;
    }
    
    
    
    public List<SelectOption> getTradePartnerType()
    {
        List<VPM_TradePartnerType__c> getPicklistValues = VPM_TradePartnerType__c.getAll().values();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        for(VPM_TradePartnerType__c region:getPicklistValues){
            if(region.VPM_Region__c== entity.VPM_ECC__c){
                //system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
                options.add(new SelectOption(region.VPM_PickListValue__c,region.VPM_PickListValue__c));
                //purchasingOrg.add(region.Picklist_Values__c);
            }
            system.debug('@@region.VPM_PickListValue__c'+region.VPM_PickListValue__c);
            system.debug('@@region.Region__c'+region.VPM_Region__c);
        }
        
        return options;
    }
    */
    
    public List<SelectOption>  getRegionSpecificCustomSettingvalues(string ecc, string pickListName){
            Map<String, VPM_RegionSpecificFields__c> settingMap = new Map<String, VPM_RegionSpecificFields__c>();
            Map<String, VPM_RegionSpecificFields__c> VPM_RegionSpecificMap = VPM_RegionSpecificFields__c.getAll();
            List<String> settingList = new List<String>();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            for(VPM_RegionSpecificFields__c region : VPM_RegionSpecificMap.values()) {
                if(region.Region__c == ecc && region.Picklist_Name__c == pickListName){
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
                    system.debug('@@ state' + state);
                    options.add(new SelectOption(state.Picklist_Values__c, state.Picklist_Values__c));
                }
                system.debug('@@ Options' + options);
            }
            return options;
        }
    
    public pageReference newMethod() {
        
        system.debug('@@inputCountry' + entity.VPM_Country__c) ;
        IF(entity.VPM_Country__c == VENDOR_COUNTRY)
        {
            isRequiredFieldCountry = true;
            system.debug('@@isRequiredField ' + isRequiredField);
        }else {
            isRequiredFieldCountry = false;
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
    
 /******************************************************************** 
    
    Created By   : Samrin Shaikh
    Created Date : 29th June 2016
    Last Modify  : N/A
    Description  : VPM - Used to set the flag based on the fields  which will help to triggr the approval process
    Return Type  : null
    ********************************************************************/
   
   public void approvalCallMethod()
    {
        purchReqVar.VPM_AdvancedFormSubmitted__c='YES'; 
        //Payment terms Flag  set
        IF(purchReqVar.VPM_PaymentTerms__c !=null)
        {
            // purchReqVar.VPM_AdvancedFormSubmitted__c='YES';  
            purchReqVar.VPM_ProvidedPaymentTerms__c= true;
        }
        
        // Bank Details Flag Set 
        if((purchReqVar.VPM_BankCountryKey__c!=null)|| (purchReqVar.VPM_BankKey__c !=null)||(purchReqVar.VPM_BankAccountNumber__c !=null)||(purchReqVar.VPM_AccountHolderName__c !=null)||(purchReqVar.VPM_ReferenceSpecificationsBankDetail__c !=null)||(purchReqVar.VPM_BankControlKey__c!=null)||(purchReqVar.VPM_IBAN__c!=null)||(purchReqVar.VPM_PartnerBankType__c!=null)||(purchReqVar.VPM_BankName__c !=null)||(purchReqVar.VPM_SwiftKey__c!=null)||(purchReqVar.VPM_CollectionAuthorization__c == true)) 
        {
            //purchReqVar.VPM_AdvancedFormSubmitted__c='YES'; 
            purchReqVar.VPM_ProvidedBankDetails__c= true;
        }
        
        // FinanciallySensitive Flag Set
        if((purchReqVar.VPM_ReconciliationAccount__c!=null)||(purchReqVar.VPM_PaymentMethod__c !=null)||
           (purchReqVar.VPM_PaymentBlock__c !=null)||(purchReqVar.VPM_CashManagementGroup__c!= null)||
           (purchReqVar.VPM_SortKey__c !=null)||
           (purchReqVar.VPM_CheckDoubleInvoices__c==true))
        {
            // purchReqVar.VPM_AdvancedFormSubmitted__c='YES'; 
            purchReqVar.VPM_ProvidedFinancialSensitive__c= true;    
        }
        
        // Unblock/UnDelete Flag set 
        if((purchReqVar.VPM_DeletionBlockFlag__c!=null))
        {
            if((purchReqVar.VPM_DeletionBlockFlag__c.contains('Undelete')) || (purchReqVar.VPM_DeletionBlockFlag__c.contains('Unblock')))
            { 
                // purchReqVar.VPM_AdvancedFormSubmitted__c='YES'; 
                purchReqVar.VPM_ProvidedUnblockUndelete__c= true;
                purchReqVar.VPM_ProvidedBlockDelete__c= false;  
            }
            // Delete/Block flag Set
            if((purchReqVar.VPM_DeletionBlockFlag__c.contains('Block')) || (purchReqVar.VPM_DeletionBlockFlag__c.contains('Delete')))
            {
                
                purchReqVar.VPM_ProvidedBlockDelete__c= true;
                purchReqVar.VPM_ProvidedUnblockUndelete__c= false;
            }                
        }
        
              VPM_ApprovalProcessCall approvalFlagObj = new VPM_ApprovalProcessCall();
            //List<ApprovalFlagWrapper> lstApprovalFlagWrapper = new List<ApprovalFlagWrapper>();
       //lstApprovalFlagWrapper=approvalFlagObj.SetApprovalFlag(purchReqVar);
        // Setting the Required flag for approval process
        
        // VPM_RussianTaxApprovalRequired__c  &&  VPM_FreightApprovalRequired__c  flag setting 
        
        if(purchReqVar.VPM_VendorType__c!=null)
        {
            System.debug(' Alsana 1 --------------------' +purchReqVar.VPM_VendorType__c );
            if(purchReqVar.VPM_VendorType__c.contains('Russian'))
            {
                System.debug(' Alsana 2--------------------' +purchReqVar.VPM_VendorType__c );
                purchReqVar.VPM_RussianTaxApprovalRequired__c =true;
                purchReqVar.VPM_FreightApprovalRequired__c  =false;   
            }
            
            else if(purchReqVar.VPM_VendorType__c.contains('Freight'))
            {
                System.debug(' Alsana 3 --------------------' +purchReqVar.VPM_VendorType__c );
                purchReqVar.VPM_FreightApprovalRequired__c  =true;
                purchReqVar.VPM_RussianTaxApprovalRequired__c =false;    
            }
            System.debug(' End Alsana 1 --------------------' +purchReqVar.RecordType.DeveloperName );
            System.debug(' End Alsana 1 --------------------' +purchReqVar.VPM_VendorType__c);
            System.debug(' End Alsana 1 --------------------' +purchReqVar.VPM_Commodity_Family__c );
            System.debug(' End Alsana 1 --------------------' +purchReqVar.VPM_GlobalAuthorisationGroup__c);
            System.debug(' End Alsana 1 --------------------' +purchReqVar.VPM_ProvidedUnblockUndelete__c );
            System.debug(' End Alsana 1 --------------------' +purchReqVar.VPM_ProvidedBlockDelete__c );
            
           // if(purchReqVar.RecordType.DeveloperName != 'VPM_VendorReqCreate')
            //{
              //  purchReqVar.VPM_FreightApprovalRequired__c  =false;
            //}
            
            
        }
        
        
        
        
        // VPM_ProcurementApprovalRequired__c flag set 
        if((purchReqVar.VPM_VendorType__c!=null) && (purchReqVar.VPM_FinanceApprovalRequired__c!= true) && (purchReqVar.VPM_RussianTaxApprovalRequired__c !=true) && (purchReqVar.VPM_GlobalAuthorisationGroup__c!=null))
        {
            
            
            if( 
                /*MBS/SCS Capex-MRO Vendors Create or Extend*/                 
                (purchReqVar.RecordType.DeveloperName != 'VPM_VendorReqMaintain' &&
                 
                     purchReqVar.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                 && 
                    (purchReqVar.VPM_VendorType__c.contains('MBS') ||
                     purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('SCS-CAPEX'))
                     
                 )
                ||
                /*MBS/SCS Capex-MRO Vendors Maintain*/ 
                (purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                    &&
                    (   purchReqVar.VPM_VendorType__c.contains('MBS') ||
                        purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('SCS-CAPEX')
                    )
                    &&
                        purchReqVar.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                    
                    &&
                    (
                        purchReqVar.VPM_ProvidedUnblockUndelete__c == TRUE || 
                        purchReqVar.VPM_ProvidedBlockDelete__c == TRUE || 
                        purchReqVar.VPM_ProvidedPaymentTerms__c == TRUE 
                    )
                 )
                
                ||
                /*SCS Logistics*/ 
                (purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                 &&
                 purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('SCS-Logistics') 
                 &&
                 purchReqVar.VPM_ProvidedPaymentTerms__c == TRUE)
                ||
                /*USCC/UASCC related MBS/SCS Capex 2611, 5449, 5496, 5487 Create or Extend*/ 
                (purchReqVar.RecordType.DeveloperName != 'VPM_VendorReqMaintain'
                 &&
                 (
                     purchReqVar.VPM_VendorType__c.contains('MBS') ||
                     purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('SCS-CAPEX') 
                 )
                 &&
                    purchReqVar.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                 &&
                 (
                     
                     purchReqVar.VPM_Company_Code_Value__c == '2611' || 
                     purchReqVar.VPM_Company_Code_Value__c == '5449' || 
                     
                     purchReqVar.VPM_Company_Code_Value__c == '5496' || 
                     purchReqVar.VPM_Company_Code_Value__c == '5487'
                 ))
                ||
                
                /*USCC/UASCC related MBS/SCS Capex 2611, 5449, 5496, 5487 Maintain*/ 
                (purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                 &&
                 (
                     purchReqVar.VPM_VendorType__c.contains('MBS')  ||
                     purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('SCS-CAPEX') 
                 )
                 &&
                    purchReqVar.VPM_Commodity_Family__c != 'Out of Scope Procurement'
                 &&
                 (
                     purchReqVar.VPM_ProvidedUnblockUndelete__c == TRUE || 
                     purchReqVar.VPM_ProvidedBlockDelete__c == TRUE || 
                     purchReqVar.VPM_ProvidedPaymentTerms__c == TRUE 
                 )
                 &&
                 (
                     purchReqVar.VPM_Company_Code_Value__c == '2611' || 
                     purchReqVar.VPM_Company_Code_Value__c == '5449' || 
                     purchReqVar.VPM_Company_Code_Value__c == '5496' || 
                     purchReqVar.VPM_Company_Code_Value__c == '5487'
                 ))
            )
            {
                System.debug(' Alsana 4--------------------' +purchReqVar.VPM_VendorType__c );
                purchReqVar.VPM_ProcurementApprovalRequired__c = true;
                purchReqVar.VPM_RussianTaxApprovalRequired__c =false;
            }
            
        }
        System.debug('End   Alsana 4--------------------' +purchReqVar.VPM_VendorType__c );
        
        // VPM_FinanceApprovalRequired__c flag set 
        
        if(purchReqVar.VPM_VendorType__c!=null && (purchReqVar.VPM_RussianTaxApprovalRequired__c !=true) &&  purchReqVar.VPM_GlobalAuthorisationGroup__c !=null)
        {
            if(
                 (
                    /*MBS(Indirect) Others (Out Scope Proc)*/ 
                    (purchReqVar.VPM_VendorType__c.contains('MBS')) 
                    && 
                    purchReqVar.VPM_Commodity_Family__c == 'Out of Scope Procurement'
                    &&
                    (purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqCreate' || purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqExtend')
                    ||
                    (
                     purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                     &&
                     (
                        purchReqVar.VPM_ProvidedUnblockUndelete__c == TRUE ||
                        purchReqVar.VPM_ProvidedBlockDelete__c == TRUE || 
                        purchReqVar.VPM_ProvidedPaymentTerms__c == TRUE ||    
                        purchReqVar.VPM_ProvidedBankDetails__c == TRUE ||  
                        purchReqVar.VPM_ProvidedFinancialSensitive__c == TRUE
                     )
                    )
                 )
                 ||
                 
                 (
                 /* Freight,SCS Log*/ 
                     (purchReqVar.VPM_VendorType__c.contains('FRGT') || purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('SCS-L'))
                    &&
                     purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                    &&
                    (
                        purchReqVar.VPM_ProvidedBankDetails__c == TRUE ||  
                        purchReqVar.VPM_ProvidedFinancialSensitive__c == TRUE
                    )
                 )
                 
                 ||
                 (
                    /*PI,3PM*/ 
                    (purchReqVar.VPM_VendorType__c.contains('PI') 
                    || 
                    (purchReqVar.VPM_VendorType__c.contains('SCS') && purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('SCS-L'))
                    )
                    &&
                    ( purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqExtend'
                    ||
                        ( purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain' &&
                            (
                                purchReqVar.VPM_ProvidedUnblockUndelete__c == TRUE ||
                                purchReqVar.VPM_ProvidedBlockDelete__c == TRUE || 
                                purchReqVar.VPM_ProvidedPaymentTerms__c == TRUE ||    
                                purchReqVar.VPM_ProvidedBankDetails__c == TRUE ||  
                                purchReqVar.VPM_ProvidedFinancialSensitive__c == TRUE ||
                                purchReqVar.VPM_Is_changed_VAT__c == TRUE
                            )
                        )
                    )
                )
                ||
                (
                 /*USCC/UASCC,MBS/SCSCap,2611,5449,5496,5487*/ 
                 (purchReqVar.VPM_VendorType__c.contains('MBS') || purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('CAP'))
                 && 
                    purchReqVar.VPM_Commodity_Family__c != 'Out of Scope Procurement'
                 &&
                   (purchReqVar.VPM_Company_Code_Value__c == '2611' || purchReqVar.VPM_Company_Code_Value__c == '5449' 
                        || purchReqVar.VPM_Company_Code_Value__c == '5496' || purchReqVar.VPM_Company_Code_Value__c == '5487')
                 &&
                    purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                 &&
                    (   
                                purchReqVar.VPM_ProvidedBankDetails__c == TRUE ||  
                                purchReqVar.VPM_ProvidedFinancialSensitive__c == TRUE
                    )
                )
                ||
                (
                    /* USCC/UASCC,MBS(Indir)2611,5449,5496,5487*/
                    (purchReqVar.VPM_VendorType__c.contains('MBS'))
                    &&
                    purchReqVar.VPM_Commodity_Family__c == 'Out of Scope Procurement'
                    &&
                    (purchReqVar.VPM_Company_Code_Value__c == '2611' || purchReqVar.VPM_Company_Code_Value__c == '5449' 
                        || purchReqVar.VPM_Company_Code_Value__c == '5496' || purchReqVar.VPM_Company_Code_Value__c == '5487')
                    &&
                     
                    ( purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqCreate' || purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqExtend'
                    ||
                        ( purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain' &&
                            (
                                purchReqVar.VPM_ProvidedUnblockUndelete__c == TRUE ||
                                purchReqVar.VPM_ProvidedBlockDelete__c == TRUE || 
                                purchReqVar.VPM_ProvidedPaymentTerms__c == TRUE ||    
                                purchReqVar.VPM_ProvidedBankDetails__c == TRUE ||  
                                purchReqVar.VPM_ProvidedFinancialSensitive__c == TRUE ||
                                purchReqVar.VPM_Is_changed_VAT__c == TRUE
                            )
                        )
                    )
                )
                ||
                (
                    /*MBS Lakme,SCS Unica*/ 
                    (
                     (purchReqVar.VPM_VendorType__c.contains('MBS') || purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('Lakme'))
                     ||
                     (purchReqVar.VPM_VendorType__c.contains('SCS') || purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('UNICA'))
                    )
                    &&
                    ( purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqExtend'
                    ||
                        ( purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain' &&
                            (
                                purchReqVar.VPM_ProvidedUnblockUndelete__c == TRUE ||
                                purchReqVar.VPM_ProvidedBlockDelete__c == TRUE || 
                                purchReqVar.VPM_ProvidedPaymentTerms__c == TRUE ||    
                                purchReqVar.VPM_ProvidedBankDetails__c == TRUE ||  
                                purchReqVar.VPM_ProvidedFinancialSensitive__c == TRUE 
                            )
                        )
                    )                
                )
                ||
                (
                    /*MBS/SCS Cap-MRO*/
                     (purchReqVar.VPM_VendorType__c.contains('MBS') || purchReqVar.VPM_GlobalAuthorisationGroup__c.contains('CAP'))
                     &&
                     purchReqVar.VPM_Commodity_Family__c != 'Out of Scope Procurement' 
                     &&
                      purchReqVar.RecordType.DeveloperName == 'VPM_VendorReqMaintain'
                    && 
                    (purchReqVar.VPM_ProvidedBankDetails__c == TRUE ||  purchReqVar.VPM_ProvidedFinancialSensitive__c == TRUE )
                )
              )
                
            {
                System.debug(' Alsana 5--------------------' +purchReqVar.VPM_VendorType__c );
                purchReqVar.VPM_FinanceApprovalRequired__c=true;
                purchReqVar.VPM_RussianTaxApprovalRequired__c =false;
            }
            
        }
        System.debug(' End Alsana 5--------------------' +purchReqVar.VPM_VendorType__c );
        
        // Setting VPM_NumberofApprovalsRequired__c flag 
        
        System.debug(' End Alsana VPM_FinanceApprovalRequired__c--------------------' +purchReqVar.VPM_FinanceApprovalRequired__c);
        System.debug(' End Alsana VPM_ProcurementApprovalRequired__c--------------------' +purchReqVar.VPM_ProcurementApprovalRequired__c);
        System.debug(' End Alsana VPM_FreightApprovalRequired__c--------------------' +purchReqVar.VPM_FreightApprovalRequired__c);
        System.debug(' End Alsana VPM_RussianTaxApprovalRequired__c--------------------' +purchReqVar.VPM_RussianTaxApprovalRequired__c);
        
        
        if((purchReqVar.VPM_FinanceApprovalRequired__c)|| (purchReqVar.VPM_ProcurementApprovalRequired__c)|| (purchReqVar.VPM_FreightApprovalRequired__c)|| (purchReqVar.VPM_RussianTaxApprovalRequired__c))
        {
            if ((purchReqVar.VPM_FinanceApprovalRequired__c ) && (purchReqVar.VPM_FreightApprovalRequired__c)) 
                purchReqVar.VPM_NumberofApprovalsRequired__c=2;
            else if((purchReqVar.VPM_FinanceApprovalRequired__c ) && (purchReqVar.VPM_ProcurementApprovalRequired__c))
                purchReqVar.VPM_NumberofApprovalsRequired__c=2;
            else if((purchReqVar.VPM_FreightApprovalRequired__c ) && (purchReqVar.VPM_ProcurementApprovalRequired__c))
                purchReqVar.VPM_NumberofApprovalsRequired__c=2;                
            else
                purchReqVar.VPM_NumberofApprovalsRequired__c=1;
        } 
        else
            purchReqVar.VPM_NumberofApprovalsRequired__c=0;
    }
   

        
    /*  End of Function approvalCallMethod  : VPM - Used to set the flag based on the fields  which will help to triggr the approval process */
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
    
    public ApexPages.Message checkValidations(){
    
        system.debug('@@ Check Validations Called');
        system.debug('@@ entity' + entity);
        recordTypeId = VPM_RecordTypeHelper.getLaunchScreenVariable('',purchReqVar.RecordTypeId);
        system.debug('@@ recordTypeId ' + recordTypeId);
        ApexPages.Message myMsg = null;
        
        if(recordTypeId=='Create')
        {
              /*   if(string.isBlank(entity.VPM_Country__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Country :You must Enter a value');
            }
            
            else if(string.isBlank(entity.VPM_VendorName1__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Vendor Name :You must Enter a value');
            }
            
            else if(string.isBlank(entity.VPM_Street1__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Address Line 1 :You must Enter a value');
                system.debug('@@ entity.VPM_Street1__c' + entity.VPM_Street1__c);
            }
            
            else if(string.isBlank(entity.VPM_City__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'City :You must Enter a value');
                 system.debug('@@ entity.VPM_City__c' + entity.VPM_City__c);
            }
            
            else if(string.isBlank(entity.VPM_AlreadyAvailableSupplierUse__c)){
            
                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Why cant an Existing Supplier be used? :You must Enter a value');
                 system.debug('@@ entity.VPM_AlreadyAvailableSupplierUse__c' + entity.VPM_AlreadyAvailableSupplierUse__c);
            }
            */
        
        
        }else if(recordTypeId == 'Maintain' || recordTypeId == 'Extend'){
        
            
                if(!entity.VPM_CheckDoubleInvoices__c)
                {
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CheckDoubleInvoicesPageMessage);
                }
            
            if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion' || purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'){
            
                 if(!entity.VPM_SRVBasedVendorID__c)
                {
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_SRVBasedVendorPageMessage);
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
                purchReqVar.VPM_TradePartnerType__c = tradePartnerType;
                purchReqVar.VPM_VendorName1__c = VendorName;
                purchReqVar.VPM_SearchTerm_1__c = searchTerm1;
                
                update purchReqVar;
                
                System.debug('@@purchReqVar *****************************************************' + purchReqVar );
               
                System.debug('@@ purchReqVar.VPM_TradePartnerType__c' + purchReqVar.VPM_TradePartnerType__c);
                System.debug('@@ purchReqVar.VPM_VendorType__c' + purchReqVar.VPM_VendorType__c);
                System.debug('@@ purchReqVar.VPM_GlobalAuthorisationGroup__c' + purchReqVar.VPM_GlobalAuthorisationGroup__c);
                newController.save();             
                approvalCallMethod();
                purchReqVar.VPM_AdvancedFormSubmitter__c = GetAdvancedFormSubmitter();
                System.debug('Alsana ------'+ purchReqVar.VPM_AdvancedFormSubmitter__c);
                update purchReqVar;
                System.debug('@@purchReqVar ' + purchReqVar );   
                 pg =  new Pagereference('/'+entity.id); 
                pg.setRedirect(true);
            }
            return pg;
        }
        catch(exception ex){
            System.debug('Exception in saveRecord Function' + Ex.getStacktraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }        
    }
    
    Public pagereference  ApprovalMaintain1()
    {
        try{
            
            // Retrieved  the QueryString  which specidfied its Maintain1 or Maintain 2 Screen */ 
            System.debug('ApprovalMaintain1');
        //  Boolean isMaintain2= Boolean.ValueOf(ApexPages.currentPage().getParameters().get('isMaintain2'));
            System.debug('@@@@@@@ purchReqVar.VPM_DeletionBlockFlag__c-------------'+purchReqVar.VPM_DeletionBlockFlag__c);
            if(string.isNotBlank(purchReqVar.VPM_DeletionBlockFlag__c))
            {
                approvalCallMethod();
                purchReqVar.VPM_AdvancedFormSubmitter__c=GetAdvancedFormSubmitter();
                System.debug('Alsana ------'+ purchReqVar.VPM_AdvancedFormSubmitter__c);
                update purchReqVar;
                System.debug('@@purchReqVar ' + purchReqVar );   
                Pagereference pg =  new Pagereference('/'+entity.id); 
                pg.setRedirect(true);
                return pg;
            }
            else
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