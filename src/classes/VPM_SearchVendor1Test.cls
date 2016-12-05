@isTest
public class VPM_SearchVendor1Test{
    public static final string vpmCountry = 'IN_India';  
    public static final string vpmCompanyCountry = 'India';   
    public static final string vendorCode = '5001010';  
    public static final string eccU2k2 = 'U2K2';
    public static final string eccFusion = 'Fusion';
    public static final string eccCORDILLERA = 'Cordillera'; 
    
    static void customSettingData(string regionVar) {
        VPM_RegionSpecificFields__c region = new VPM_RegionSpecificFields__c();
        List<VPM_RegionSpecificFields__c> regionList = new List<VPM_RegionSpecificFields__c>();
        region.Region__c = regionVar;
        region.name = '1';
        region.Picklist_API__c ='VPM_Industry__c';
        region.Picklist_Name__c ='Industry';
        region.PICKLIST_VALUES__C = '0001_Industry 0001';
        regionList.add(region);
        insert regionList;
        
        VPM_LatamCountries__c latamContries = new VPM_LatamCountries__c();
        latamContries.name = 'Countries';
        latamContries.VPM_CountryName__c = 'AR_Argentina,BO_Bolivia,CL_Chile,CO_Colombia,CR_Costa Rica,DO_Dominican Rep.,EC_Ecuador,GT_Guatemala';
        insert latamContries;
    }    

    static  VPM_PurchasingRequests__c TestDataU2K2(){    
        customSettingData(eccU2k2);    
        VPM_Region__c reg = new VPM_Region__c();
        reg.VPM_Code__c = '05';
        reg.Name = vpmCountry;
        reg.VPM_Country__c = vpmCountry;
        insert reg;
        
        List<mdm_Vendors__c> vendorList = new List<mdm_Vendors__c>();
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = vendorCode;
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_Street__c = 'Test Street';
        vendor.mdm_Postcode__c = '54132';
        vendor.mdm_Country__c = vpmCompanyCountry;
        vendor.mdm_ID__c = '1234';
        vendor.mdm_vCodeFusion__c= vendorCode;
        vendor.mdm_vCodeCordillera__c=vendorCode;
        vendor.mdm_vCodeSirius__c=vendorCode;
        vendor.mdm_vCodeU2K2__c=vendorCode;
        vendorList.add(vendor);
        insert vendorList;
        system.debug('@@vendorList' + vendorList);
        system.assert(vendor.Id!=null,'Error');
       
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = eccU2k2;
        companyCode.VPM_Country__c ='Philippines';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.Name = 'Advertising Pre-Testing - Digital';
        commodityCode.VPM_CommodityFamily__c = 'Market Research';
        commodityCode.VPM_VendorType__c = 'PI_Production Item Vendor_G001';
        commodityCode.VPM_AuthorisationGroup__c = 'Chemicals--Inorganics_VMBA Inorganics';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research';
        commodityCode.VPM_CommodityCode__c = '5702 - UN01580116';
        commodityCode.VPM_Region__c  = eccU2k2;
            
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = eccU2k2;
        pur.VPM_VendorName1__c ='Test Sirius';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c = vendorList[0].id;
        //pur.recordTypeId=recordTypeId;
        
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Philippines';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';    
        pur.VPM_GlobalAuthorisationGroup__c = 'Chemicals--Inorganics_VMBA Inorganics';
        pur.VPM_PaymentTerms__c = '';
        pur.VPM_OrderingEmailAddress__c = '';
        pur.VPM_VendorType__c = 'PI_Production Item Vendor_G001';  
        pur.VPM_ClerksInternet__c = '';
        pur.VPM_Country__c = vpmCountry;
        pur.VPM_ExtensionType__c = VPM_RecordTypeHelper.REGIONAL_REQUEST;
        pur.VPM_Industry__c = '9001_Oils';
        pur.VPM_SupplierAchillesRegistration__c = '';
        insert pur;
        insert commodityCode;
        pur.VPM_Commodity__c = commodityCode.id;
        update pur; 
        return pur;    
    }
    
    static  VPM_PurchasingRequests__c TestDataFusion(){    
        customSettingData(eccFusion);    
        VPM_Region__c reg = new VPM_Region__c();
        reg.VPM_Code__c = '05';
        reg.Name = vpmCompanyCountry; 
        reg.VPM_Country__c = vpmCountry;
        insert reg;
        
        List<mdm_Vendors__c> vendorList = new List<mdm_Vendors__c>();
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = vendorCode;
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_Street__c = 'Test Street';
        vendor.mdm_Postcode__c = '54132';
        vendor.mdm_Country__c = vpmCompanyCountry;
        vendor.mdm_ID__c = '1234';
        vendor.mdm_vCodeFusion__c= vendorCode;
        vendor.mdm_vCodeCordillera__c=vendorCode;
        vendor.mdm_vCodeSirius__c=vendorCode;
        vendor.mdm_vCodeU2K2__c=vendorCode;
        vendorList.add(vendor);
        insert vendorList;
        system.debug('@@vendorList' + vendorList);
        system.assert(vendor.Id!=null,'Error');
       
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'H';
        companyCode.ECC__c = eccFusion;
        companyCode.VPM_Country__c = vpmCompanyCountry;
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.Name = 'Customer allowances';
        commodityCode.VPM_CommodityFamily__c = 'Out of Scope Procurement';
        commodityCode.VPM_VendorType__c = 'MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c = 'MBS--Other_MBS--Other';
        commodityCode.VPM_CommodityClass__c = 'Payment';
        commodityCode.VPM_CommodityCode__c = '6902 - 80141629';
        commodityCode.VPM_Region__c  = eccFusion;
            
        VPM_PurchasingOrganisation__c purcOrg = new VPM_PurchasingOrganisation__c();
        purcOrg.Name = 'ULAB_ARIBA Pur.Orgn';
        purcOrg.VPM_Country__c = vpmCompanyCountry;
        purcOrg.VPM_POSystem__c = 'Ariba';    
        insert purcOrg;    
            
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = eccFusion;
        pur.VPM_VendorName1__c ='Test Sirius';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c = vendorList[0].id;
        //pur.recordTypeId=recordTypeId;
        
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_PurchasingOrg__c = purcOrg.Id; 
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c = vpmCompanyCountry;
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c = 'MBS_Marketing Business Services_G001';
        pur.VPM_PaymentTerms__c = '';
        pur.VPM_OrderingEmailAddress__c = '';
        pur.VPM_VendorType__c = 'MBS--Other_MBS--Other';
        pur.VPM_ClerksInternet__c = '';
        pur.VPM_Country__c = vpmCountry;
        pur.VPM_Industry__c = '9001_Oils';
        pur.VPM_IsVendorSME__c = 'Yes';
        insert pur;
        insert commodityCode;
        pur.VPM_Commodity__c = commodityCode.id;
        update pur; 
        return pur;    
    }
    
    static  VPM_PurchasingRequests__c TestDataCordillera(){    
        customSettingData(eccFusion);    
        VPM_Region__c reg = new VPM_Region__c();
        reg.VPM_Code__c = '13';
        reg.Name = vpmCompanyCountry; 
        reg.VPM_Country__c = vpmCountry;
        insert reg;
        
        List<mdm_Vendors__c> vendorList = new List<mdm_Vendors__c>();
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = vendorCode;
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_Street__c = 'Test Street';
        vendor.mdm_Postcode__c = '54132';
        vendor.mdm_Country__c = vpmCompanyCountry;
        vendor.mdm_ID__c = '1234';
        vendor.mdm_vCodeFusion__c= vendorCode;
        vendor.mdm_vCodeCordillera__c=vendorCode;
        vendor.mdm_vCodeSirius__c=vendorCode;
        vendor.mdm_vCodeU2K2__c=vendorCode;
        vendorList.add(vendor);
        insert vendorList;
        system.debug('@@vendorList' + vendorList);
        system.assert(vendor.Id!=null,'Error');
       
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'H';
        companyCode.ECC__c = eccCORDILLERA;
        companyCode.VPM_Country__c = vpmCompanyCountry;
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.Name = 'Customer allowances';
        commodityCode.VPM_CommodityFamily__c = 'Out of Scope Procurement';
        commodityCode.VPM_VendorType__c = 'MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c = 'MBS--Other_MBS--Other';
        commodityCode.VPM_CommodityClass__c = 'Payment';
        commodityCode.VPM_CommodityCode__c = '6902 - 80141629';
        commodityCode.VPM_Region__c  = eccCORDILLERA;
            
        VPM_PurchasingOrganisation__c purcOrg = new VPM_PurchasingOrganisation__c();
        purcOrg.Name = 'ULAB_ARIBA Pur.Orgn';
        purcOrg.VPM_Country__c = vpmCompanyCountry;
        purcOrg.VPM_POSystem__c = 'Ariba';    
        insert purcOrg;    
            
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = eccCORDILLERA;
        pur.VPM_VendorName1__c ='Test Sirius';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c = vendorList[0].id;
        //pur.recordTypeId=recordTypeId;
        
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_PurchasingOrg__c = purcOrg.Id; 
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c = vpmCompanyCountry;
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c = 'MBS_Marketing Business Services_G001';
        pur.VPM_PaymentTerms__c = '';
        pur.VPM_OrderingEmailAddress__c = '';
        pur.VPM_VendorType__c = 'MBS--Other_MBS--Other';
        pur.VPM_ClerksInternet__c = '';
        pur.VPM_Country__c = vpmCountry;
        pur.VPM_Industry__c = '9001_Oils';
        pur.VPM_IsVendorSME__c = 'Yes';
        insert pur;
        insert commodityCode;
        pur.VPM_Commodity__c = commodityCode.id;
        update pur; 
        return pur;    
    }
    
    static testMethod void VPM_SearchVendorCordillera(){
            
        VPM_PurchasingRequests__c purId = TestDataCordillera();
        string recordTypeId = [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id; 
        purId.recordTypeId = recordTypeId;
        update purId;
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purId.id];
        system.assertEquals(purch.VPM_ECC__c, 'Cordillera');
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1(vendorDetail);
        searchVendor.getVendorDetailList();     
        
        searchVendor.zipPostcode = '';
        searchVendor.getVendorDetailList();  
        
        searchVendor.street1 = '';
        searchVendor.getVendorDetailList();  
        
        searchVendor.zipPostcode = '';
        searchVendor.street1 = '';
        searchVendor.getVendorDetailList();  
        
        searchVendor.mdmVendorType = '';
        searchVendor.VendorSelected();    
        
        searchVendor.mdmVendorType = 'notlisted';  
        searchVendor.VendorSelected();
        searchVendor.newMethod();
        searchVendor.vendorNameChange(); 
        searchVendor.SendWebformMethod();  
        searchVendor.ScreenVisited.add(VPM_RecordTypeHelper.SEARCH_VENDOR);
        searchVendor.SaveMethod();

        searchVendor.ScreenVisited.add(VPM_RecordTypeHelper.VENDOR_LIST);
        searchVendor.SaveMethod();
        Test.startTest();
        searchVendor.ScreenVisited.add(VPM_RecordTypeHelper.REQUEST_TYPE);
        searchVendor.SaveMethod(); 
        searchVendor.GoldenDataSave();  
        searchVendor.GoldenDataSave2();          
        searchVendor.SaveAndExit();    
        searchVendor.VendorNotFound = true;    
        //searchVendor.isInternationalVersionCollapsed();
        searchVendor.getButtonVisibleSaveMenu();
        searchVendor.getButtonVisibleSaveExit();
        searchVendor.backToDetailPage();
        Test.stopTest();    
        //searchVendor.getExitButtonVisible();    
    }
    
    static testMethod void VPM_SearchVendorU2K2Create(){
            
        VPM_PurchasingRequests__c purId = TestDataU2K2();
        string recordTypeId = [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id; 
        purId.recordTypeId = recordTypeId;
        update purId;
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purId.id];
        system.assertEquals(purch.VPM_ECC__c, 'U2K2');
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1(vendorDetail);
        searchVendor.getVendorDetailList();     
        
        searchVendor.zipPostcode = '';
        searchVendor.getVendorDetailList();  
        
        searchVendor.street1 = '';
        searchVendor.getVendorDetailList();  
        
        searchVendor.zipPostcode = '';
        searchVendor.street1 = '';
        searchVendor.getVendorDetailList();  
        
        searchVendor.mdmVendorType = '';
        searchVendor.VendorSelected();    
        
        searchVendor.mdmVendorType = 'notlisted';  
        searchVendor.VendorSelected();
        searchVendor.newMethod();
        searchVendor.vendorNameChange(); 
        searchVendor.SendWebformMethod();  
        searchVendor.ScreenVisited.add(VPM_RecordTypeHelper.SEARCH_VENDOR);
        searchVendor.SaveMethod();

        searchVendor.ScreenVisited.add(VPM_RecordTypeHelper.VENDOR_LIST);
        searchVendor.SaveMethod();
        Test.startTest();
        searchVendor.ScreenVisited.add(VPM_RecordTypeHelper.REQUEST_TYPE);
        searchVendor.SaveMethod(); 
        searchVendor.GoldenDataSave();  
        searchVendor.GoldenDataSave2();          
        searchVendor.SaveAndExit();    
        searchVendor.VendorNotFound = true;    
        //searchVendor.isInternationalVersionCollapsed();
        searchVendor.getButtonVisibleSaveMenu();
        searchVendor.getButtonVisibleSaveExit();
        searchVendor.backToDetailPage();
        Test.stopTest();    
        //searchVendor.getExitButtonVisible();    
    }
    
    static testMethod void VPM_SearchVendorU2k2Extend(){        
        VPM_PurchasingRequests__c purId = TestDataU2K2();
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Extend)'].Id; 
        purId.recordTypeId=recordTypeId;
        update purId;
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purId.id];
        system.assertEquals(purch.VPM_ECC__c, 'U2K2');
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1(vendorDetail);
        searchVendor.intCalcIndicatorDefValues = '01';
        searchVendor.getVendorDetailList();        
        searchVendor.mdmVendorType = '';
        searchVendor.VendorSelected();    
        
        searchVendor.mdmVendorType = '0122222 \\#; 0050502921 \\#; U2K2';
        //searchVendor.VendorSelected(); 
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200,'Maintain'));
        //searchVendor.requestType ='Maintain';  
        Test.startTest();
        searchVendor.VendorSelected(); 
        //VPM_ECCVendorSearchServiceOutput op = new VPM_ECCVendorSearchServiceOutput();
        //op = searchVendor.FetchVendorDeatilSAPService(string.valueOf(vendor.mdm_vCodeSirius__c));           
        Test.stopTest();    
    
        searchVendor.newMethod();
        searchVendor.vendorNameChange(); 
        searchVendor.SendWebformMethod();  
        searchVendor.backBtnAction();  
        searchVendor.GoldenDataSave();  
        searchVendor.GoldenDataSave2();          
        searchVendor.SaveAndExit();   
        searchVendor.SaveMethod();
        searchVendor.VendorNotFound = true;    
        //searchVendor.isInternationalVersionCollapsed();
        searchVendor.getButtonVisibleSaveMenu();
        searchVendor.getButtonVisibleSaveExit();
        //searchVendor.getExitButtonVisible();    
    }
    
    static testMethod void VPM_SearchVendorFusionExtend(){        
        VPM_PurchasingRequests__c purId = TestDataFusion();
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Extend)'].Id; 
        purId.recordTypeId=recordTypeId;
        update purId;
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purId.id];
        system.assertEquals(purch.VPM_ECC__c, 'Fusion');
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1(vendorDetail);
        searchVendor.intCalcIndicatorDefValues = '01';
        searchVendor.getVendorDetailList();        
        searchVendor.mdmVendorType = '';
        searchVendor.VendorSelected();    
        
        searchVendor.mdmVendorType = '0122222 \\#; 0050502921 \\#; U2K2';
        //searchVendor.VendorSelected(); 
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200,'Maintain'));
        //searchVendor.requestType ='Maintain';  
        Test.startTest();
        searchVendor.VendorSelected(); 
        //VPM_ECCVendorSearchServiceOutput op = new VPM_ECCVendorSearchServiceOutput();
        //op = searchVendor.FetchVendorDeatilSAPService(string.valueOf(vendor.mdm_vCodeSirius__c));           
        Test.stopTest();    
    
        searchVendor.newMethod();
        searchVendor.vendorNameChange(); 
        searchVendor.SendWebformMethod();  
        searchVendor.backBtnAction();  
        searchVendor.GoldenDataSave();  
        searchVendor.GoldenDataSave2();          
        searchVendor.SaveAndExit();   
        searchVendor.SaveMethod();
        searchVendor.VendorNotFound = true;    
        //searchVendor.isInternationalVersionCollapsed();
        searchVendor.getButtonVisibleSaveMenu();
        searchVendor.getButtonVisibleSaveExit();
        //searchVendor.getExitButtonVisible();    
    }
    
    static testMethod void VPM_SearchVendorFusionCreate(){        
        VPM_PurchasingRequests__c purId = TestDataFusion();
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id; 
        purId.recordTypeId=recordTypeId;
        update purId;
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purId.id];
        system.assertEquals(purch.VPM_ECC__c, 'Fusion');
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1(vendorDetail);
        searchVendor.getVendorDetailList();        
                
        searchVendor.mdmVendorType = '0122222 \\#; 0050502921 \\#; U2K2';
        //searchVendor.VendorSelected(); 
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200, 'Extend'));
        //searchVendor.requestType ='Maintain';  
        Test.startTest();
        searchVendor.VendorSelected(); 
        //VPM_ECCVendorSearchServiceOutput op = new VPM_ECCVendorSearchServiceOutput();
        //op = searchVendor.FetchVendorDeatilSAPService(string.valueOf(vendor.mdm_vCodeSirius__c));           
        Test.stopTest();    
    
        searchVendor.newMethod();
        searchVendor.vendorNameChange(); 
        searchVendor.SendWebformMethod();  
        searchVendor.backBtnAction();  
        searchVendor.GoldenDataSave();  
        searchVendor.GoldenDataSave2();  
        searchVendor.SaveMethod();        
        searchVendor.SaveAndExit();    
        searchVendor.VendorNotFound = false;    
        //searchVendor.isInternationalVersionCollapsed();
        searchVendor.getButtonVisibleSaveMenu();
        searchVendor.getButtonVisibleSaveExit();
        //searchVendor.getExitButtonVisible();    
    }
    
    
    static testMethod void VPM_SearchVendorFusionMaintain(){        
        VPM_PurchasingRequests__c purId = TestDataFusion();
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id; 
        purId.recordTypeId=recordTypeId;
        update purId;
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purId.id];
        system.assertEquals(purch.VPM_ECC__c, 'Fusion');
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1(vendorDetail);
        searchVendor.getVendorDetailList();        
                
        searchVendor.mdmVendorType = '0122222 \\#; 0050502921 \\#; U2K2';
        //searchVendor.VendorSelected(); 
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200, 'Extend'));
        //searchVendor.requestType ='Maintain';  
        Test.startTest();
        searchVendor.VendorSelected(); 
        //VPM_ECCVendorSearchServiceOutput op = new VPM_ECCVendorSearchServiceOutput();
        //op = searchVendor.FetchVendorDeatilSAPService(string.valueOf(vendor.mdm_vCodeSirius__c));           
        Test.stopTest();    
    
        searchVendor.newMethod();
        searchVendor.vendorNameChange(); 
        searchVendor.SendWebformMethod();  
        searchVendor.backBtnAction();  
        searchVendor.GoldenDataSave();  
        searchVendor.GoldenDataSave2();  
        searchVendor.SaveMethod();        
        searchVendor.SaveAndExit();    
        searchVendor.VendorNotFound = false;    
        //searchVendor.isInternationalVersionCollapsed();
        searchVendor.getButtonVisibleSaveMenu();
        searchVendor.getButtonVisibleSaveExit();
        //searchVendor.getExitButtonVisible();    
    }
    
    /*static void backBtnActionData(){     
        pageReference pg = null;
        VPM_PurchasingRequests__c purId = TestDataU2K2();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1 (vendorDetail);      
    }*/

    static testMethod void negativeScenarioMethod() {
        VPM_PurchasingRequests__c purd = TestDataU2K2();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purd);
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1 (vendorDetail);
        
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purd.id];
        system.assertEquals(purch.VPM_ECC__c, 'U2K2');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200, 'Extend'));
        searchVendor.showSearchVendor = true;
        searchVendor.vendorName = '';
        searchVendor.SaveMethod();
        searchVendor.vendorName = 'BA';
        searchVendor.SaveMethod();
        purd.VPM_SupplierAchillesRegistration__c = '';
        purd.VPM_BankCountryKey__c = '';  
        purd.VPM_VendorType__c = ''; 
        purd.VPM_PaymentMethod__c = null;
        update purd;
        searchVendor.showSearchVendor = false;
        searchVendor.piVendorCreation = true;
        searchVendor.SaveMethod();
        
        searchVendor.showSearchVendor = false;
        searchVendor.piVendorCreation = false;
        searchVendor.generalVendorDetails = true;
        searchVendor.countryName = '';      
        searchVendor.street1 = '';    
        searchVendor.SaveMethod();
        searchVendor.showSearchVendor = false;
        searchVendor.piVendorCreation = false;
        searchVendor.generalVendorDetails = false;
        searchVendor.paymentTermScreen = true; 
        searchVendor.vendorPaymentTerms = '';
        searchVendor.SaveMethod();
        searchVendor.showSearchVendor = false;
        searchVendor.piVendorCreation = false;
        searchVendor.generalVendorDetails = false;
        searchVendor.paymentTermScreen = false; 
        searchVendor.bankDetailsScreen = true;
        searchVendor.SaveMethod();
        searchVendor.showSearchVendor = false;
        searchVendor.piVendorCreation = false;
        searchVendor.generalVendorDetails = false;
        searchVendor.paymentTermScreen = false; 
        searchVendor.bankDetailsScreen = false;
        searchVendor.goldendata2Screen2 = true;
        searchVendor.vendorTradePartnerType = '';
        searchVendor.SaveMethod();
        searchVendor.showSearchVendor = false;
        searchVendor.piVendorCreation = false;
        searchVendor.generalVendorDetails = false;
        searchVendor.paymentTermScreen = false; 
        searchVendor.bankDetailsScreen = false;
        searchVendor.goldendata2Screen2 = false;  
        searchVendor.financialScreen = true; 
        searchVendor.vendorCashmgmntgroup = '';
        searchVendor.vendorPaymentMethod = '';
        searchVendor.SaveMethod();
        searchVendor.showSearchVendor = false;
        searchVendor.piVendorCreation = false;
        searchVendor.generalVendorDetails = false;
        searchVendor.paymentTermScreen = false; 
        searchVendor.bankDetailsScreen = false;
        searchVendor.goldendata2Screen2 = false;  
        searchVendor.financialScreen = false; 
        searchVendor.regionalSpecificScreenSirius = true; 
        searchVendor.termsOfPayment = '';
        searchVendor.SaveMethod();
        Test.stopTest();
    }
    
    static testMethod void processRequestType(){
        
        VPM_PurchasingRequests__c purId = TestDataU2K2();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1 (vendorDetail);
        
        VPM_PurchasingRequests__c purch = [Select Id, VPM_ECC__c From VPM_PurchasingRequests__c where id = : purId.id];
        system.assertEquals(purch.VPM_ECC__c, 'U2K2');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200, 'Extend'));
        searchVendor.mdmVendorType = '';
        searchVendor.processRequestType();
        
        searchVendor.mdmVendorType = System.label.VPM_EnterBankDetails;
        searchVendor.processRequestType();
    
        // For ReviewRequestBrief
        searchVendor.mdmVendorType = System.label.VPM_EnterGeneralVendorDetails;
        searchVendor.processRequestType();        
    
        // For ReviewRequestBrief
        searchVendor.mdmVendorType = System.label.VPM_RequestVendortoBlock_Delete;
        searchVendor.requestType= 'Maintain';
        searchVendor.processRequestType();
        
        searchVendor.mdmVendorType = System.label.VPM_RequestVendortoBlock_Delete;
        searchVendor.requestType= 'Maintain2';
        searchVendor.processRequestType();
            
           // For ReviewRequestBrief
        searchVendor.mdmVendorType = System.label.VPM_EnterPaymentTerms;
        searchVendor.processRequestType();    
        
         // For ReviewRequestBrief
        searchVendor.mdmVendorType = System.label.VPM_PIVendorCreationPreRequisites; 
        searchVendor.processRequestType();
    
        searchVendor.mdmVendorType = System.label.VPM_EditFinanciallySensitiveFields;
        searchVendor.processRequestType();
        
        searchVendor.mdmVendorType = System.label.VPM_EnterRegionalSpecificFields; 
        searchVendor.processRequestType();
         
        searchVendor.mdmVendorType = system.label.VPM_SubmitVendorRequestforApproval;
        searchVendor.requestType= 'Maintain';
        searchVendor.processRequestType();
        
        searchVendor.mdmVendorType = system.label.VPM_SubmitVendorRequestforApproval;
        searchVendor.requestType= 'Extend';
        searchVendor.processRequestType();
    
         // For ReviewRequestBrief
        searchVendor.mdmVendorType = system.label.VPM_Exitthisform;
        searchVendor.processRequestType();
    
        //for SendResendWebform
        searchVendor.mdmVendorType = system.label.VPM_Send_ResendWebformRequest;
        searchVendor.processRequestType();
        Test.stopTest();
    }
}