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

    public string CountryName{get;set;}
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
    public Id recId{get;set;}  
    public string DeletionBlockFlag  {get;set;}
    public String options {get;set;}    
    //public User UserVar{get;set;}
    //public string userDetailsUrl{get;set;}
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
    
    public list <SelectOption> VendorTypeList{get;set;}
    
    public  List<SelectOption> Cashmgmntgroup{get;set;}
    public string vendorCashmgmntgroup{get;set;} 
    
    public  List<SelectOption> VenLanguage{get;set;}
    public string vendorLanguage{get;set;} 
    
    public  List<SelectOption> AccountStatement{get;set;}
    public string vendorAccountStatement{get;set;} 
    
    
    public  List<SelectOption> PaymentBlock{get;set;}
    public string vendorPaymentBlock{get;set;} 
    
    public  List<SelectOption> GroupingKey{get;set;} 
    public string vendorGroupingKey{get;set;} 
    
    public  List<SelectOption> SchemaGroupVendor{get;set;}
    public string vendorSchemaGroupVendor{get;set;} 
    
    public  List<SelectOption> Incoterms1{get;set;}
    public string vendorIncoterms1{get;set;} 
    
    
    public  List<SelectOption> VPMAuthorizationList{get;set;}
    public string VPMAuthorization{get;set;}
    
    
    
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
        
        vendorQuery1 = [select Id,VPM_DeletionBlockFlag__c,VPM_VendordoesntExistFlag__c, VPM_TradePartnerType__c, VPM_CheckDoubleInvoices__c,VPM_VendorContactDetail__c,VPM_ReconciliationAccount__c,VPM_BankCountryKey__c, VPM_Comments__c, VPM_VendorName1__c, VPM_VendorPhone__c,
                        VPM_ECC__c, VPM_ExtensionType__c, VPM_Status__c,VPM_VendorCodeLookup__c, VPM_VendorCodeLookup__r.mdm_ecc__c, VPM_VendorCodeLookup__r.mdm_Code__c,VPM_Commodity__r.Name,
                        VPM_CompanyCode__r.ECC__c,VPM_Commodity__c,VPM_Commodity__r.VPM_Vendor_Type__c,VPM_VendorType__c, VPM_Commodity__r.VPM_Authorisation_Group__c,VPM_GlobalAuthorisationGroup__c, VPM_Street1__c, VPM_Country__c, VPM_ZIPPostcode__c, VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,
                        VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c, VPM_PurchasingOrg__c,VPM_PurchasingOrg__r.Name,
                        recordTypeId,VPM_CompanyCode__r.VPM_CompanyCode__c,VPM_CashManagementGroup__c,VPM_Language__c,VPM_AccountStatement__c,VPM_PaymentBlock__c,VPM_GroupingKey__c,VPM_SchemaGroupVendor__c,VPM_Incoterms1__c,
                        VPM_Regions__c,VPM_SearchTerm_1__c,createdbyid,VPM_PurchasingOrganisation__c,VPM_Authorization__c,VPM_AuthorisationGroupFormula__c, VPM_VendorBlockUnblockDelete__c
                        from VPM_PurchasingRequests__c where id = : recId];
        
        vendorPurchasingOrg = vendorQuery1.VPM_PurchasingOrganisation__c;
        vendorCashmgmntgroup = vendorQuery1.VPM_CashManagementGroup__c;
        system.debug('@@ vendorQuery1.VPM_Language__c' + vendorQuery1.VPM_Language__c);
        vendorLanguage=vendorQuery1.VPM_Language__c;
        vendorAccountStatement=vendorQuery1.VPM_AccountStatement__c;
        vendorPaymentBlock=vendorQuery1.VPM_PaymentBlock__c;
        vendorGroupingKey=vendorQuery1.VPM_GroupingKey__c;
        vendorIncoterms1=vendorQuery1.VPM_Incoterms1__c;
        vendorSchemaGroupVendor=vendorQuery1.VPM_SchemaGroupVendor__c;
        
       
        if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera' || vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion')
            isInternationalVersionRendered = false;
        else
            isInternationalVersionRendered = true;
        
        isRequiredSpend =true;
        if(string.isNotBlank(vendorQuery1.VPM_Commodity__r.Name) && vendorQuery1.VPM_Commodity__r.Name.startsWith('0'))
                isRequiredSpend = false;
            else                
                isRequiredSpend =true;              

        
        
        if(vendorQuery1.VPM_CompanyCode__r.ecc__c <> '' || vendorQuery1.VPM_CompanyCode__r.ecc__c <> null)
            vendorDetails.VPM_ECC__c = vendorQuery1.VPM_CompanyCode__r.ecc__c;
        
        // assigning the picklist values based on company code ECC associated to vendor request.
        purchasingOrg = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PURCHASING_ORG);
        Cashmgmntgroup = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, CASH_MGMT);
        VenLanguage = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, LANGUAGE);
        AccountStatement = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, ACCOUNT_STAT);
        PaymentBlock = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, PAYMEMT_BLOCK);
        GroupingKey  = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, GROUPING_KEY);
        Incoterms1 = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, INCOTERMS_1);
        SchemaGroupVendor = getRegionSpecificCustomSettingvalues(vendorDetails.VPM_ECC__c, SCHEMA_GRP);
        
        system.debug('@@Cashmgmntgroup' +Cashmgmntgroup);
        
        vendorDetails.VPM_TradePartnerType__c = vendorQuery1.VPM_TradePartnerType__c;
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
        searchTerm1 = string.isNotblank(VendorName) ? vendorName.left(10) : '';
        ZIPPostcode = vendorQuery1.VPM_ZIPPostcode__c;
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
        {   
            system.debug('@@ Coming Here');
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
            }            
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
        try{
            system.debug('@@getVendorDetailList is called');    
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
             string searchQuery ='SELECT id,VPM_FullDetails__c,mdm_vCodeSirius__c,mdm_vCodeCordillera__c,mdm_vCodeU2K2__c,mdm_vCodeFusion__c,mdm_Name1__c,mdm_Street__c ,mdm_City__c,mdm_Country__c,mdm_ecc__c,mdm_Code__c FROM mdm_Vendors__c  WHERE ( mdm_Name1__c LIKE '+'\'%' + String.escapeSingleQuotes(VendorName) + '%\'' ;
            
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
            /*if(string.isNotBlank(CountryName)) {                
                List<string> s2 = CountryName.split('_',-1);
                string countryNameSplitted = s2[1];
                if(string.isNotBlank(countryNameSplitted)) {
                    searchQuery+=' AND mdm_Country__c LIKE '+ '\'%' + String.escapeSingleQuotes(countryNameSplitted)+ '%\'';
                }
            }*/
            
            system.debug('@@MDM_Vendor' +searchQuery);
            MDM_Vendor = Database.query(searchQuery);
            system.debug('@@MDM_vendor' + MDM_Vendor);
            
            mdmDetailList =setmdmDetailOption(MDM_Vendor);
            if(mdmDetailList == null || mdmDetailList.size() < 0 ) {
                hideSearchVendor = false;
                heapMessageScreen = true;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Please modify the search creteria Too many Vendors retrieved'));
                system.debug('@@ Please filter the search creteria');
            }
            system.debug('@@mdmDetailList' + mdmDetailList);
        }
        catch(exception ex){
            
            system.debug('@@Exception' + ex.getStackTraceString());
        }
    }


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
            list<string> MDMVendorInfo =MDMVendor.split('#',-2);   
            system.debug('@@MDMVendorInfo' +MDMVendorInfo[1]);      
            system.debug('@@MDMVendorInfo' +MDMVendorInfo[2]);      
           // VPM_ECCVendorSearchServiceOutput op = new VPM_ECCVendorSearchServiceOutput();      
            op = FetchVendorDeatilSAPService(MDMVendorInfo[1]);
            showSearchVendor  = false;
            hideSearchVendor=false;
            system.debug('@@op' + op);      
            system.debug('@@op.vendorFoundResult' + op.vendorFoundResult);  
            system.debug('@@op.companyCodeMatching' + op.companyCodeMatching);  
            system.debug('@@op.Blocked' + op.Blocked);  
            system.debug('@@op.Deleted' + op.Deleted);        
            if(op.statusCode == '200') {
                 if(op.vendorFoundResult && op.Blocked <> null && op.Deleted <> null) 
                  {     
                    
                    if(op.companyCodeMatching )
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
          //return pg;
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
         
 system.debug('@@@@@@@@Vendor Type '+vendorQuery1.VPM_Commodity__r.VPM_Vendor_Type__c);
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
          webServiceData(op);
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
       vendorQuery1.RecordTypeId = VPM_RecordTypeHelper.getRecordTypeNameById(requestType);
       vendorQuery1.VPM_ECC__c = vendorQuery1.VPM_CompanyCode__r.ECC__c;
       vendorQuery1.VPM_ExtensionType__c = extensionType;
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
      ipList.add(ip);
      system.debug('@@ipList' + ipList);
      opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
        
      webServiceData(opList[0]);  
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
                option.UniqueId = MDMDetail.id+'#'+ vendorCodeAssignmentSearchVen(MDMDetail.mdm_vCodeSirius__c,MDMDetail.mdm_vCodeCordillera__c,MDMDetail.mdm_vCodeU2K2__c,MDMDetail.mdm_vCodeFusion__c)+'#'+MDMDetail.mdm_ecc__c;
                options.add(option); 
            }
            OptionWrapper option = new OptionWrapper();
            option.DetailOption =System.label.VPM_MyVendorisnotlisted ;
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
      
        OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_VendorMatch + '","UniqueId":"VendorMatch","showLabel":false,"labelText":""},';
      
      
       }
      
       //Maintain 1
       else if(requestType =='Maintain2')
       {
           OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_VendorMatch + '","UniqueId":"VendorMatch","showLabel":true,"labelText":"'+System.label.VPM_Add_Additional_Information+'"},';
           OptionWrapperJSON +='{"DetailOption":"'+System.label.VPM_RequestVendortoUnblock_Undelete + '","UniqueId":"RequestVendorUnBlock/Delete","showLabel":false,"labelText":""},';
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
        system.debug('@@vendorDetails.VPM_VendorName1__c' + vendorDetails.VPM_VendorName1__c);  
         vendorDetails.VPM_VendorName1__c = op.VendorName1;   
         vendorDetails.VPM_SearchTerm_1__c = op.SearchTerm1;
         /*VendorName = string.isNotblank(op.VendorName1) ? op.VendorName1 : vendorDetails.VPM_VendorName1__c;    
         searchTerm1 = op.SearchTerm1;
        vendorDetails.VPM_Street2__c = string.isNotblank(op.Street2) ? op.Street2 : vendorDetails.VPM_Street2__c; */
        system.debug('@@VendorName' +VendorName);
         if(op.CompanyCodeFields <> null && op.CompanyCodeFields.size() > 0) {
             booleanToStringMethod(op.CompanyCodeFields[0].Blocked, op.CompanyCodeFields[0].Deleted);         
             //Company code fields
            vendorDetails.VPM_AccntWithVendor__c = op.CompanyCodeFields[0].AccntWithVendor;
            vendorDetails.VPM_AccountingClerk__c = op.CompanyCodeFields[0].AccountingClerk;
            vendorDetails.VPM_AccountMemo__c = op.CompanyCodeFields[0].AccountMemo;
            vendorDetails.VPM_AccountStatement__c = op.CompanyCodeFields[0].AccountStatement;
            //vendorDetails.VPM_AlternativePayee__c = op.CompanyCodeFields[0].AlternativePayee;
            //vendorDetails.VPM_BExchangeLimit__c = op.CompanyCodeFields[0].BExchangeLimit;
            vendorDetails.VPM_CashManagementGroup__c = op.CompanyCodeFields[0].CashManagementGroup;
            vendorDetails.VPM_CheckDoubleInvoices__c = op.CompanyCodeFields[0].CheckDoubleInvoices <>null?op.CompanyCodeFields[0].CheckDoubleInvoices:false;
            vendorDetails.VPM_ChkCashing__c = op.CompanyCodeFields[0].ChkCashing;
            vendorDetails.VPM_ClerkAtVendor__c = op.CompanyCodeFields[0].ClerkAtVendor;
            vendorDetails.VPM_ClerksFax__c = op.CompanyCodeFields[0].ClerksFax;
            vendorDetails.VPM_ClerksInternet__c = op.CompanyCodeFields[0].ClerksInternet;
            //vendorDetails.VPM_CompanyCode__c = op.CompanyCodeFields[0].CompanyCode;
            vendorDetails.VPM_ExemptionNumber__c = op.CompanyCodeFields[0].ExemptionNumber;
            vendorDetails.VPM_GroupingKey__c = op.CompanyCodeFields[0].GroupingKey;
            vendorDetails.VPM_HouseBank__c = op.CompanyCodeFields[0].HouseBank;
            vendorDetails.VPM_ToleranceGroup__c = op.CompanyCodeFields[0].ToleranceGroup;
            //vendorDetails.VPM_ValidUntil__c = op.CompanyCodeFields[0].ValidUntil;
            vendorDetails.VPM_ReconciliationAccount__c = op.CompanyCodeFields[0].ReconciliationAccount;
            vendorDetails.VPM_WithholdingTaxCountryKey__c = op.CompanyCodeFields[0].WithholdingTaxCountryKey;
            vendorDetails.VPM_PaymentTerms__c = op.CompanyCodeFields[0].PaymentTerms;   
            vendorDetails.VPM_SortKey__c = op.CompanyCodeFields[0].SortKey;
            vendorDetails.VPM_IndicatorClearingBetwCustomerNVendor__c = op.CompanyCodeFields[0].IndicatorClearingBetweenCustomerAndVendor <>null?op.CompanyCodeFields[0].IndicatorClearingBetweenCustomerAndVendor:false;
            vendorDetails.VPM_IndicatorPayItemsSeparately__c = op.CompanyCodeFields[0].IndicatorPayItemsSeparatley <>null?op.CompanyCodeFields[0].IndicatorPayItemsSeparatley:false;
            vendorDetails.VPM_InterestCalculationIndicator__c = op.CompanyCodeFields[0].InterestCalculationIndicator;
            vendorDetails.VPM_InterestFrequency__c = op.CompanyCodeFields[0].InterestFrequency;
            //vendorDetails.VPM_LastInterestRun__c = op.CompanyCodeFields[0].LastInterestRun;
            vendorDetails.VPM_PaymentMethod__c = op.CompanyCodeFields[0].PaymentMethod;
            vendorDetails.VPM_PaymentMethodSupplement__c = op.CompanyCodeFields[0].PaymentMethodSupplement;
            vendorDetails.VPM_PaymentTerms__c = op.CompanyCodeFields[0].PaymentTerms;
            //vendorDetails.VPM_PmtAdviceByEDI__c = op.CompanyCodeFields[0].PmtAdviceByEDI;
            vendorDetails.VPM_PreviousAccountNumber__c = op.CompanyCodeFields[0].PreviousAccountNumber;
            vendorDetails.VPM_AdoptScanDate__c = op.CompanyCodeFields[0].AdoptScanDate <> null?op.CompanyCodeFields[0].AdoptScanDate :false;
            
             //Dunning Block
             if(op.CompanyCodeFields[0].Dunning <> null && op.CompanyCodeFields[0].Dunning.size() > 0) {
                vendorDetails.VPM_DunningBlock__c = op.CompanyCodeFields[0].Dunning[0].DunningBlock;
                
                vendorDetails.VPM_DunningClerk__c = op.CompanyCodeFields[0].Dunning[0].DunningClerk;
                vendorDetails.VPM_DunningLevel__c = op.CompanyCodeFields[0].Dunning[0].DunningLevel;
                vendorDetails.VPM_DunnRecipient__c = op.CompanyCodeFields[0].Dunning[0].DunnRecipient;
                vendorDetails.VPM_LastDunned__c = date.valueOf(op.CompanyCodeFields[0].Dunning[0].LastDunned);      
            }
            //WtaxType
            if(op.CompanyCodeFields[0].WtaxType <> null && op.CompanyCodeFields[0].WtaxType.size() > 0) {
                vendorDetails.VPM_ExemptionRate__c = decimal.valueOf(op.CompanyCodeFields[0].WtaxType[0].ExemptionRate);
                //vendorDetails.VPM_ExemptionFrom__c = date.valueof(op.CompanyCodeFields[0].WtaxType[0].ExemptionFrom);
                //vendorDetails.VPM_ExemptionTo__c = date.valueof(op.CompanyCodeFields[0].WtaxType[0].ExemptionTo);
                vendorDetails.VPM_WithholdingTaxCode__c = op.CompanyCodeFields[0].WtaxType[0].WithholdingTaxCode;
                vendorDetails.VPM_IndicatorForWithholdingTaxType__c = op.CompanyCodeFields[0].WtaxType[0].IndicatorForWithholdingTaxType; 
                //vendorDetails.VPM_Liable__c = op.CompanyCodeFields[0].WtaxType[0].Liable;             
            }
        }
        
        //purchasing org fields
        if(op.PurchasingOrgFields <> null && op.PurchasingOrgFields.size() > 0) {
            // issue in data type Text in SFDC and Boolean in webservice- vendorDetails.VPM_ABCIndicator__c = op.PurchasingOrgFields[0].ABCIndicator;
            vendorDetails.VPM_AutoEvalGRSetmtDel__c = op.PurchasingOrgFields[0].AutoEvalGRSetmtDel <> null?op.PurchasingOrgFields[0].AutoEvalGRSetmtDel:false;
            vendorDetails.VPM_AutoEvalGRSetmtRet__c = op.PurchasingOrgFields[0].AutoEvalGRSetmtRet <> null?op.PurchasingOrgFields[0].AutoEvalGRSetmtRet:false;
            //VPM_AutoGenerationPOAllowed__c not present in SFDC
            //vendorDetails.VPM_AutoGenerationPOAllowed__c = op.PurchasingOrgFields[0].AutoGenerationPOAllowed <> null?op.PurchasingOrgFields[0].AutoGenerationPOAllowed:false;
            vendorDetails.VPM_DocIndexActive__c = op.PurchasingOrgFields[0].DocIndexActive<>null?op.PurchasingOrgFields[0].DocIndexActive:false;
            vendorDetails.VPM_GrantDiscInKind__c = op.PurchasingOrgFields[0].GrantDiscInKind <>null?op.PurchasingOrgFields[0].GrantDiscInKind:false;
            vendorDetails.VPM_GRbasedIV__c = op.PurchasingOrgFields[0].GRbasedIV <> null?op.PurchasingOrgFields[0].GRbasedIV:false;
            vendorDetails.VPM_SchemaGroupVendor__c = op.PurchasingOrgFields[0].SchemaGroupVendor;
            vendorDetails.VPM_SortCriterion__c = op.PurchasingOrgFields[0].SortCriterion;
            vendorDetails.VPM_Incoterms1__c = op.PurchasingOrgFields[0].Incoterms1;
            vendorDetails.VPM_Incoterms2__c = op.PurchasingOrgFields[0].Incoterms2;
            vendorDetails.VPM_PurchasingGroup__c = op.PurchasingOrgFields[0].PurchasingGroup;
            vendorDetails.VPM_PurchasingGroup__c = op.PurchasingOrgFields[0].PurchasingOrganisation;
            vendorDetails.VPM_RackJobbingServiceAgreed__c = op.PurchasingOrgFields[0].RackJobbingServiceAgreed <>null?op.PurchasingOrgFields[0].RackJobbingServiceAgreed:false;
            vendorDetails.VPM_SalesPerson__c = op.PurchasingOrgFields[0].SalesPerson;
            vendorDetails.VPM_SRVBasedVendorID__c = op.PurchasingOrgFields[0].SRVBasedVendorID <>null ?op.PurchasingOrgFields[0].SRVBasedVendorID:false;
            vendorDetails.VPM_MinimumOrderValue__c = decimal.valueOf(op.PurchasingOrgFields[0].MinimumOrderValue);
            vendorDetails.VPM_ModeTransportForeignTrade__c = op.PurchasingOrgFields[0].ModeTransportForeignTrade;
            vendorDetails.VPM_OfficeOfEntry__c = op.PurchasingOrgFields[0].OfficeOfEntry;
            
            vendorDetails.VPM_OrderCurrency__c = op.PurchasingOrgFields[0].OrderCurrency;
            vendorDetails.VPM_OrderOptimRest__c = op.PurchasingOrgFields[0].OrderOptimRest;
            vendorDetails.VPM_PlannedDeliveryTime__c = decimal.valueOF(op.PurchasingOrgFields[0].PlannedDeliveryTime);
            vendorDetails.VPM_PROATControlProof__c = op.PurchasingOrgFields[0].PROATControlProof;
            //issue in data type Text in SFDC and Boolean in webservice-
            //vendorDetails.VPM_DefaultPartner__c = op.PurchasingOrgFields[0].Functions[0].DefaultPartner;
            //vendorDetails.VPM_PartnerFunction__c = op.PurchasingOrgFields[0].Functions[0].PartnerFunction;
             
         }
         
        vendorDetails.VPM_AccountClerkTelephoneNumber__c = op.AccountClerkTelephoneNumber;
        vendorDetails.VPM_AccountGroup__c = op.AccountGroup; 
        //vendorDetails.VPM_AccountHolderName__c = op.AccountHolderName;
        vendorDetails.VPM_AccountingNote__c = op.AccountingNote;
        vendorDetails.VPM_AccountingText__c = op.AccountingText;
        vendorDetails.VPM_ActualQMSystem__c = op.ActualQMSystem;
        vendorDetails.VPM_AddressForm__c = op.AddressForm;
        vendorDetails.VPM_AddressTimeZone__c = op.AddressTimeZone;        
        // this field is check box in sfdc vendorDetails.VPM_AlternativePayeeAccountNumber__c = op.AlternativePayeeAccountNumber;
        // field not created in SFDC vendorDetails.VPM_AltPayeeAccountNum__c = op.AltPayeeAccountNum;
        vendorDetails.VPM_ArabiaOldNumber__c = op.ArabiaOldNumber;
        vendorDetails.VPM_ArabicVersion__c = op.ArabicVersion;
        vendorDetails.VPM_Authorization__c = op.Authorization;        
        vendorDetails.VPM_BeneficiaryAddress1__c = op.BeneficiaryAddress1;
        vendorDetails.VPM_BeneficiaryAddress2__c = op.BeneficiaryAddress2;
        vendorDetails.VPM_BeneficiaryAddress3__c = op.BeneficiaryAddress3;
        vendorDetails.VPM_BeneficiaryCountry__c = op.BeneficiaryCountry;
        vendorDetails.VPM_BeneficiaryName__c = op.BeneficiaryName;
        //vendorDetails.VPM_Blocked__c = op.Blocked;
        vendorDetails.VPM_BlockFunction__c = op.BlockFunction;        
        
        // boolean in sgfdc vendorDetails.VPM_CentralDeletionFlag__c = op.CentralDeletionFlag;
        // boolean in sgfdcvendorDetails.VPM_CentralPostingBlock__c = op.CentralPostingBlock;
        // boolean in sgfdc vendorDetails.VPM_CentralPurchasingBlock__c = op.CentralPurchasingBlock;
        vendorDetails.VPM_CENVAT__c = op.CENVAT;
        vendorDetails.VPM_CertificateWithholdingTaxExemption__c = op.CertificateWithholdingTaxExemption;
        if(string.isNotBlank(op.CertificationDate)) {
            vendorDetails.VPM_CertificationDate__c = date.valueOF(op.CertificationDate);
        }
        vendorDetails.VPM_ChangedBy__c = op.ChangedBy;
        vendorDetails.VPM_Changedon__c = op.Changedon;
        vendorDetails.VPM_CheckDigit__c = op.CheckDigit; // data value too large
        vendorDetails.VPM_City__c = op.City;
        vendorDetails.VPM_Commissionerate__c = op.Commissionerate;
        vendorDetails.VPM_CompanyPostCode__c = op.CompanyPostCode;
        vendorDetails.VPM_Department__c = op.Department;
        vendorDetails.VPM_DepartmentDescription__c = op.DepartmentDescription;
        vendorDetails.VPM_DepartmentNumber__c = op.DepartmentNumber;
        vendorDetails.VPM_Description__c = op.Description;
        vendorDetails.VPM_District__c = op.District;
        //VPM_DMEIndicator__c text in SFDC and boolean in webservice
        //vendorDetails.VPM_DMEIndicator__c = op.DMEIndicator<>null?op.DMEIndicator:false;
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
        vendorDetails.VPM_ExternalMFG__c = op.ExternalMFG;
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
        vendorDetails.VPM_TaxType__c = op.TaxType;
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
        vendorDetails.VPM_SearchTerm2__c = op.SearchTerm2;
        vendorDetails.VPM_SerRegNo__c = op.SerRegNo;
        vendorDetails.VPM_ServiceAgent__c = op.ServiceAgent;
        vendorDetails.VPM_Sex__c = op.Sex;
        vendorDetails.VPM_ShippingConditions__c = op.ShippingConditions;
        //vendorDetails.VPM_SMSIndicator__c = op.SMSIndicator;
        vendorDetails.VPM_SocialInsurance__c = op.SocialInsurance;
        vendorDetails.VPM_SocialInsuranceCodeSoc__c = op.SocialInsuranceCode;
        vendorDetails.VPM_TaxJurisdictionCode__c = op.TaxJurisdictionCode;
        vendorDetails.VPM_TaxNumber1__c = op.TaxNumber1;
        vendorDetails.VPM_TaxNumber2__c = op.TaxNumber2;
        vendorDetails.VPM_TaxNumber3__c = op.TaxNumber3;
        vendorDetails.VPM_TaxNumber4__c = op.TaxNumber4;
        vendorDetails.VPM_TaxNumber5__c = op.TaxNumber5;
        vendorDetails.VPM_TaxNumberType__c = op.TaxNumberType;
        vendorDetails.VPM_TaxOfficeIdentification__c = op.TaxOfficeIdentification;
        vendorDetails.VPM_TAXOfficeIdentLangKey__c = op.TAXOfficeIdentLangKey;
        vendorDetails.VPM_SSIStatus__c = op.SSIStatus;
        vendorDetails.VPM_StandardCommMethod__c = op.StandardCommMethod;
        vendorDetails.VPM_Street1__c = op.Street1;
        vendorDetails.VPM_Street2__c = op.Street2;
        vendorDetails.VPM_Street3__c = op.Street3;
        vendorDetails.VPM_Street4__c = op.Street4;
        vendorDetails.VPM_Street5__c = op.Street5;
        vendorDetails.VPM_SubsequentSettlement__c = op.SubsequentSettlement;
        vendorDetails.VPM_SubsequentSettlementIndex__c = op.SubsequentSettlementIndex;
        vendorDetails.VPM_TaxBase__c = op.TaxBase;
        vendorDetails.VPM_TradePartnerType__c = op.TradePartnerType;
        vendorDetails.VPM_TrainStation__c = op.TrainStation;
        vendorDetails.VPM_TransportZone__c = op.TransportZone;
        vendorDetails.VPM_TurkeyOldNumber__c = op.TurkeyOldNumber;
        vendorDetails.VPM_VendorType__c = op.TypeVendor;
        vendorDetails.VPM_UkrainianVersion__c = op.UkrainianVersion;
        vendorDetails.VPM_UnitOfMeasureGrp__c = op.UnitOfMeasureGrp;
        vendorDetails.VPM_VATRegistrationNumber__c = op.VATRegistrationNumber;
        vendorDetails.VPM_VATRegistrationNumber2__c = op.VATRegistrationNumber2;
        vendorDetails.VPM_VATRegistrationNumber3__c = op.VATRegistrationNumber3;
        vendorDetails.VPM_VendorCode__c = op.VendorCode;
        vendorDetails.VPM_VendorName1__c = op.VendorName1;
        vendorDetails.VPM_VendorName2__c = op.VendorName2;
        vendorDetails.VPM_Name3__c = op.VendorName3;
        vendorDetails.VPM_Name4__c = op.VendorName4;
        if(op.VendorSubRange <> null && op.VendorSubRange.size() > 0) {
            vendorDetails.VPM_VendorSubRange__c = op.VendorSubRange[0];
        }
        vendorDetails.VPM_HouseNumber__c = op.HouseNumber;
        vendorDetails.VPM_HouseNumSupplement__c = op.HouseNumSupplement;
        // Field not there in SFDC vendorDetails.VPM_icate__c = op.icate;
        vendorDetails.VPM_OtherCommunication__c = op.OtherCommunication;
        vendorDetails.VPM_ReasonForExemption__c = op.ReasonForExemption;
        vendorDetails.VPM_RecipientType__c = op.RecipientType;
        vendorDetails.VPM_IndicatorPlantLevelRelevant__c = op.IndicatorPlantLevel <>null?op.IndicatorPlantLevel:false;
        vendorDetails.VPM_IndicatorSubjectToWithholdingTax__c = op.IndicatorSubjectToWithholdingTax;
        //vendorDetails.VPM_IndicatorVendorSubRangeRelevant__c = op.IndicatorVendorSubRangeRelevant;
        //vendorDetails.VPM_IndividualPayment__c = op.IndividualPayment;
        vendorDetails.VPM_IndividualSpec__c = op.IndividualSpec;
        vendorDetails.VPM_IndonesiaOldVendorNumber__c = op.IndonesiaOldVendorNumber;
        vendorDetails.VPM_Industry__c = op.Industry;
        vendorDetails.VPM_IndustryType__c = op.IndustryType;
        vendorDetails.VPM_InstructionKeyDataExchange__c = op.InstructionKeyDataExchange;
        vendorDetails.VPM_InternationalVersion__c = op.InternationalVersion;
        vendorDetails.VPM_IntLocationNumber1__c = op.IntLocationNumber1;
        vendorDetails.VPM_IntLocationNumber2__c = op.IntLocationNumber2;
        vendorDetails.VPM_IsraelOldNumber__c = op.IsraelOldNumber;
        vendorDetails.VPM_ISRNumber__c = op.ISRNumber;
        vendorDetails.VPM_Language__c = op.Language;
        vendorDetails.VPM_Local2Version__c= op.Local2Version;
        if(string.isNotBlank(op.LastKeyDate)){
            vendorDetails.VPM_LastKeyDate__c = date.valueOF(op.LastKeyDate);
        }
        vendorDetails.VPM_LanguageKeyCOCode__c = op.LanguageKeyCOCode;
        vendorDetails.VPM_SalesPurchTax__c = op.SalesPurchTax <>null?op.SalesPurchTax:false;
        vendorDetails.VPM_SAPECCComments__c = op.SAPComments;
        vendorDetails.VPM_SCAC__c = op.SCAC;
        vendorDetails.VPM_ZIPPostcode__c = op.ZIPPostCode;
        vendorDetails.VPM_Region__c = op.Region;
        vendorDetails.VPM_RegStGrp__c = op.RegStGrp;
        //vendorDetails.VPM_RelevantForvendorDetailsiceDet__c = op.RelevantForvendorDetailsiceDet;
        // boolean in SFDC vendorDetails.VPM_ReturnsVendor__c = op.ReturnsVendor;
        vendorDetails.VPM_RoundingProfile__c = op.RoundingProfile;
        vendorDetails.VPM_RussianVersion__c = op.RussianVersion;
        vendorDetails.VPM_WithholdingTaxIdentificationNumber__c = op.WithholdingTaxIdentificationNumber;
        if(string.isNotBlank(op.QMSystemTo) && !op.QMSystemTo.contains('0000')) {
            //vendorDetails.VPM_QMSystemTo__c = date.valueOF(op.QMSystemTo);
        }
        //vendorDetails.VPM_ABCIndicator__c = op.vendorDetailsOATControlvendorDetailsoof;
       // vendorDetails.VPM_ABCIndicator__c = op.ABCIndicator <> null ? op.ABCIndicator:false;  string in SFDC,boolean in service output
        vendorDetails.VPM_POBox__c = op.POBox;
        vendorDetails.VPM_POBoxCity__c = op.POBoxCity;
        vendorDetails.VPM_PODRelevant__c = op.PODRelevant;
        vendorDetails.VPM_PostalCode2__c = op.PostalCode2;
        vendorDetails.VPM_MinorityIndicators__c = op.MinorityIndicators;
        vendorDetails.VPM_MobilePhone__c = op.MobilePhone;
        vendorDetails.VPM_MobilePhone2__c = op.MobilePhone2;
        vendorDetails.VPM_MobilePhone3__c = op.MobilePhone3; 
        //vendorDetails.VPM_LegalDunnvendorDetailsoc__c = op.LegalDunnvendorDetailsoc;        
        vendorDetails.VPM_LLDCode__c = op.LLDCode;
        vendorDetails.VPM_LSTno__c = op.LSTno;
        // booelan in SFDC vendorDetails.VPM_IndicatorAlternativePayeeAllowed__c = op.IndicatorAlternativePayeeAllowed;
        //field not present in SFDC vendorDetails.VPM_IndicatorCollectionAuthorization__c = op.IndicatorCollectionAuthorization;
        vendorDetails.VPM_Name3__c = op.Name3;
        vendorDetails.VPM_Name4__c = op.Name4;
        //vendorDetails.VPM_NODEL__c = op.NODEL;
        //booelan in sfdc vendorDetails.VPM_NPIVendor__c = op.NPIVendor;
        if(string.isNotBlank(op.LastExtReview)) {
            //vendorDetails.VPM_LastExtReview__c = date.valueOf(op.LastExtReview);
        }
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
        vendorDetails.VPM_PaymentBlock__c = op.PaymentBlock;
        vendorDetails.VPM_OrderingEmailAddress__c = op.OrderingEmailAddress;
        vendorDetails.VPM_Plant__c = op.Plant;
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
        ApexPages.Message msg = checkValidations();
        if(msg <> null ) {
            ApexPages.addMessage(msg);
        }else {
            updateVendorReqRecord();
            
            /*if(sendWebFormScreen){
                ScreenVisited.add('requestType');
            }*/
            backBtnAction();  
        }        
    }    
    
     /*public void updateComodityRecord() {
         system.debug('@@updateComodityRecord is called' );
         if(string.isNotBlank(vendorDetails.VPM_Commodity__c)) {
            VPM_CommodityCode__c commodityRecord = new VPM_CommodityCode__c();          
             commodityRecord.VPM_Vendor_Type__c = vendorQuery1.VPM_VendorType__c;
             commodityRecord.VPM_Authorisation_Group__c = vendorQuery1.VPM_GlobalAuthorisationGroup__c;
             commodityRecord.id = vendorQuery1.VPM_Commodity__c;
            update commodityRecord;         
             system.debug('@@commodityRecord' + commodityRecord);
         }
         
     } */

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
            vendorQuery1.VPM_SchemaGroupVendor__c =vendorSchemaGroupVendor;            
            vendorQuery1.VPM_VendorBlockUnblockDelete__c = VPM_VendorBlockUnblockDelete;
            //vendorQuery1.VPM_Commodity__r.VPM_Vendor_Type__c = vendorDetails.VPM_VendorType__c;
            //vendorQuery1.VPM_Commodity__r.VPM_Authorisation_Group__c = vendorDetails.VPM_GlobalAuthorisationGroup__c;
            vendorQuery1.VPM_VendorName1__c = VendorName;
            vendorQuery1.VPM_SearchTerm_1__c = searchTerm1;
            
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
            system.debug('@@vendorQuery1.VPM_VendordoesntExistFlag__c' +vendorQuery1.VPM_VendordoesntExistFlag__c);
            update vendorQuery1;
            //Changes  to avoid mulitple mail
            vendorQuery1.VPM_VendordoesntExistFlag__c ='';
            //commodityLookupChanges();
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
        vendorQuery1.VPM_Commodity__c = vendorDetails.VPM_Commodity__c;        
        update vendorQuery1;
        system.debug('@@vendorQuery1' +vendorQuery1);
        commodityLookupChanges();
                   
    }

    public void GoldenDataSave2() {
        system.debug('Golden Data Save method is called');
            //commodityLookupChanges();
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
            vendorQuery1.VPM_TradePartnerType__c = vendorDetails.VPM_TradePartnerType__c;
            vendorQuery1.VPM_VendorType__c = vendorDetails.VPM_VendorType__c;
            vendorQuery1.VPM_GlobalAuthorisationGroup__c = vendorDetails.VPM_GlobalAuthorisationGroup__c;
            update vendorQuery1;            
            //updateComodityRecord(); 
    }
    
    
    Public Pagereference SaveAndExit()
    {   
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
        if(generalVendorDetails || (regionalSpecificScreenSirius || regionalSpecificScreenU2K2 )) {
            if(string.isNotBlank(vendorDetails.VPM_VendorName1Int__c) || string.isNotBlank(vendorDetails.VPM_VendorName2Int__c)
             ||string.isNotBlank(vendorDetails.VPM_VendorName3Int__c) || string.isNotBlank(vendorDetails.VPM_VendorName4Int__c)
             ||string.isNotBlank(vendorDetails.VPM_Street1Int__c) || string.isNotBlank(vendorDetails.VPM_Street2Int__c)
             ||string.isNotBlank(vendorDetails.VPM_Street3Int__c) || string.isNotBlank(vendorDetails.VPM_Street4Int__c)
             ||string.isNotBlank(vendorDetails.VPM_HouseNumberInt__c) || string.isNotBlank(vendorDetails.VPM_SearchTerm1Int__c) 
             ||string.isNotBlank(vendorDetails.VPM_PostCodeInt__c) || string.isNotBlank(vendorDetails.VPM_CityInt__c)
             || string.isNotBlank(vendorDetails.VPM_CountryInt__c)) {
                
                if(string.isBlank(vendorDetails.VPM_InternationalVersion__c)){
                  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, system.label.VPM_International1);
                  
                }
            }
            if(string.isBlank(vendorPurchasingOrg)) {
                //myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, system.label.VPM_PurchasingOrganization);
            }
        }
        if(paymentTermScreen) {
            if(string.isBlank(vendorPurchasingOrg)) {  
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, system.label.VPM_PurchasingOrganization  );
            }
        }
        if(regionalSpecificScreenCordillera ||regionalSpecificScreenSirius || regionalSpecificScreenFusion || regionalSpecificScreenU2K2 ) {            
            if(!vendorDetails.VPM_CheckDoubleInvoices__c) {  
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_CheckDoubleInvoicesPageMessage);
                //vendorDetails.VPM_CheckDoubleInvoices__c.addError('You must enter a value');
            }
        }
        
        if(regionalSpecificScreenSirius || regionalSpecificScreenFusion){
        
            if(!vendorDetails.VPM_SRVBasedVendorID__c)
                {
                
                    myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_SRVBasedVendorPageMessage);
                }
        
        }

        
            
           /* if(VPM_PurchasingRequests__c.VPM_VendorType__c == null) {
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Vendor Type : ' + 'You must enter a value');
            }
            if(VPM_PurchasingRequests__c.VPM_VendorName1__c == null) {
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Vendor Name ' + 'You must enter a value');
            }*/
        
        return myMsg;
    }
    
    
     public void booleanToStringMethod(boolean blocked, boolean deleted) {
         VPM_VendorBlockUnblockDelete = '';
         if(blocked && deleted) {
             VPM_VendorBlockUnblockDelete = 'Blocked' + 'Deleted';
         }else if(!blocked && deleted) {
             VPM_VendorBlockUnblockDelete = 'Deleted';
         }else if(blocked && !deleted) {
             VPM_VendorBlockUnblockDelete = 'Blocked';
         }
         
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
    
    public void commodityLookupChanges() { 
        system.debug('@@vendorDetails.VPM_Commodity__c' + vendorDetails.VPM_Commodity__c);
        VPM_CommodityCode__c comm = [select id , name, VPM_Authorisation_Group__c, VPM_Vendor_Type__c from VPM_CommodityCode__c where id = : vendorDetails.VPM_Commodity__c];
        system.debug('@@comm' + comm);
        
        if(comm.name.startsWith('0')) {
            vendorDetails.VPM_TradePartnerType__c = 'VN_Main Vendor (VN)_ZVN1'; 
        }
        vendorDetails.VPM_VendorType__c = comm.VPM_Vendor_Type__c; 
        vendorDetails.VPM_GlobalAuthorisationGroup__c = comm.VPM_Authorisation_Group__c;
               
    }
    
  }