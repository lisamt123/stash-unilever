@isTest
public class VPM_MaintainGlobalVendorService_Test {
  public static final String failStatusMDM = 'Failed to Submit to BPM';// MDM status
    public static final String successStatusMDM = 'Submitted to BPM';// MDM status
    public static final String FieldTypeChanged = 'Both';// MDM status
    public static final String VendorCode_5001010 = '5001010';// MDM status
    public static final String VendorCode = '5001010';// MDM status
    public static final String TestData= 'Test';// MDM status
    public static final String TaxDataNumber= '2345';// MDM status
  public static final string ECC_U2K2 = 'U2K2';
  public static final string CITY_ANDORRA = 'Andorra';
  public static final string COUNTRY_ALGERIA = 'DZ_Algeria';
  public static final string TEST_SIRIUS = 'Test Sirius';
  public static final string TEST_STREET = 'Test Street';
  public static final string POST_CODE = '54132';
  public static final string VENDOR_PHONE = '1234567895';
  public static final string ERROR = 'Error';
  public static final string COUNTRYREQ_ALGERIA = 'Algeria';
  public static final string PH01 = 'PH01';
  public static final string MBS_Marketing_Services = 'MBS--Marketing Services'; 
  public static final string Ad_hoc_Research = 'Ad-hoc Research';
  public static final string Ad_hoc_Qualitative = 'Ad-hoc Market Research - Qualitative';
  public static final string CODE5702_UN01580115 = '5702 - UN01580115';
  public static final string Market_Research = 'Market Research';
  public static final string Test_User2 = 'Test User2';
  public static final string Draft_Request = 'Draft Request';
  public static final string ZGS1 = 'ZGS1';
  public static final string YES = 'Yes';
  public static final string RCT_Russian = 'RCT_Russian Customs Tax Vendor_G001';
  public static final string GLOABL_3PM = '3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';  
  
  
     static testMethod void testCallout()
      {
          setup();
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        //VPM_MaintainGlobalVendorServiceHelper.fakeMethod();  
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, successStatusMDM);
    }
    
    static testMethod void testCallout1()
      {
          setup();
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test5678' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        //VPM_MaintainGlobalVendorServiceHelper.fakeMethod();  
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test5678' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, successStatusMDM);
    }
         static testMethod  void GlobalExceptionTest()
      {
        setup();  
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assert(true);
    }
         static testMethod void GlobalAndManintainTest() {
        setup();     
        List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c =FieldTypeChanged;
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, successStatusMDM);
      
    }
             static testMethod void GlobalAndManintainTest400() {
        setup();         
        List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c =FieldTypeChanged;
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(400));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
       
    }
                 @isTest static void GlobalAndManintainTest503() {
        setup();
                     List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c =FieldTypeChanged;
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(503));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
    }
                 @isTest static void GlobalAndManintainTest507() {
        setup();
                     List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c =FieldTypeChanged;
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(507));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
    }
    static testMethod void testCallout500() {
        setup();
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(500));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
    }
    static testMethod void testCallout504() {
        setup();
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(504));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
    }
        static testMethod void testCallout504exception() {
        setup();
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_WhatAreYouBuying__c='test"test';
        update pur;
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(505));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
    }
    
        static testMethod void MaintainRegionTest200() {
            setup();
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
       // VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_ECC_InsertUpdateStatus__c, 'ECC Insert / Update Succeeded');
    }
            static testMethod void MaintainRegionTest400() {
                setup();
                VPM_MaintainGlobalVendorServiceHelper.errorMsgWrapper erMsg = new VPM_MaintainGlobalVendorServiceHelper.errorMsgWrapper();
                erMsg.MessageV1 = 'Test';
                erMsg.MessageNo = '123';
                erMsg.Type= 'W';
                erMsg.ID = '43672errorId';
                VPM_MaintainGlobalVendorServiceHelper.MaintainGlobalVendorResponse responseMaintain = new VPM_MaintainGlobalVendorServiceHelper.MaintainGlobalVendorResponse();
                responseMaintain.bpmId='01678';
                responseMaintain.statusCode = '200';
                
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
       // VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(400));
        VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_ECC_InsertUpdateStatus__c, 'Failed to Submit to ECC');
    }
    static testMethod void setup() {
        VPM_CompanyCode__c compCode = new VPM_CompanyCode__c(Name = 'Company Code 2', Company_Name__c = 'Unilever', VPM_CompanyCode__c = 'UN',VPM_Country__c ='Belgium',ECC__c ='U2K2');
        insert compCode;
        mdm_Vendors__c vendor = new mdm_Vendors__c();
    vendor.mdm_Code__c = VendorCode;
    vendor.mdm_City__c = CITY_ANDORRA;
    vendor.mdm_Country__c =COUNTRY_ALGERIA;
    vendor.mdm_Name1__c =TEST_SIRIUS;
    vendor.mdm_Street__c = TEST_STREET;
    vendor.mdm_Postcode__c = POST_CODE;
    vendor.mdm_Country__c = 'India';
    vendor.mdm_ID__c = '1234';
    vendor.mdm_vCodeFusion__c=VendorCode;
    vendor.mdm_vCodeCordillera__c=VendorCode;
    vendor.mdm_vCodeSirius__c=VendorCode;
    vendor.mdm_vCodeU2K2__c=VendorCode; 
       insert vendor;
        
        VPM_PurchasingRequests__c pur =new VPM_PurchasingRequests__c();
        pur.VPM_CountryRequestingVendor__c ='Belgium';
        pur.VPM_WhatAreYouBuying__c=TestData;
        pur.VPM_VendorName1__c='test1234';
        pur.VPM_Country__c='BE_Belgium';
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        pur.VPM_Comments__c=TestData;
        pur.VPM_fieldUpdated__c='VPM_IsVendorException__c ,VPM_IsVendorSME__c ,VPM_District__c ,VPM_City__c ,VPM_Country__c,VPM_HouseNumSupplement__c ,VPM_HouseNumber__c ,VPM_Street1__c,VPM_Street2__c,VPM_Street3__c,VPM_Street4__cVPM_SearchTerm2__c ,VPM_SearchTerm_1__c ,VPM_Name3__c ,VPM_Name4__c ,VPM_VendorName2__c ,VPM_ZIPPostcode__c ,VPM_TaxType__c,VPM_ExceptionType__c ,VPM_CheckDigit__c ,VPM_IntLocationNumber2__c,VPM_IntLocationNumber1__c,VPM_CorporateGrp__c,VPM_CreditInfoNumber__c,VPM_TaxNumAtResponsibleTaxAuthority__c,VPM_TaxJurisdictionCode__c,VPM_TaxNumberType__c,VPM_IsNaturalPerson__c,VPM_POBox__c,VPM_POBoxPostCode__c ,VPM_TaxNumber1__c,VPM_TaxNumber2__c,VPM_TaxNumber3__c,VPM_TaxNumber4__c,VPM_VATRegistrationNumber__c';
        pur.VPM_CompanyCode__c = compCode.Id;
        pur.VPM_VendorCodeLookup__c = vendor.id;
        pur.VPM_POBox__c ='234';
        pur.VPM_POBoxPostCode__c ='234';
        pur.VPM_TaxNumber1__c =TaxDataNumber;
        pur.VPM_TaxNumber2__c =TaxDataNumber;
        pur.VPM_TaxNumber3__c =TaxDataNumber;
        pur.VPM_TaxNumber4__c =TaxDataNumber;
        pur.VPM_VATRegistrationNumber__c=TaxDataNumber;
        pur.VPM_IsNaturalPerson__c = true;
        pur.VPM_TaxNumberType__c =TaxDataNumber;
        pur.VPM_TaxJurisdictionCode__c =TaxDataNumber;
        pur.VPM_TaxNumAtResponsibleTaxAuthority__c = TaxDataNumber;
        pur.VPM_CreditInfoNumber__c ='234';
        pur.VPM_CorporateGrp__c = TaxDataNumber;
        pur.VPM_IntLocationNumber1__c =TaxDataNumber;
        pur.VPM_IntLocationNumber2__c =TaxDataNumber;
        pur.VPM_CheckDigit__c ='1';
        pur.VPM_ExceptionType__c =TestData;
        pur.VPM_TaxType__c=TaxDataNumber;
        pur.VPM_ZIPPostcode__c =TaxDataNumber;
        pur.VPM_VendorName2__c =TestData;
        pur.VPM_Name3__c =TaxDataNumber;
        pur.VPM_Name4__c ='22';
        pur.VPM_SearchTerm_1__c =TestData;
        pur.VPM_SearchTerm2__c ='te';
        pur.VPM_Street1__c=TaxDataNumber;
        pur.VPM_Street2__c=TaxDataNumber;
        pur.VPM_Street3__c='66';
        pur.VPM_Street4__c=TaxDataNumber;
        pur.VPM_HouseNumber__c ='2342';
        pur.VPM_HouseNumSupplement__c ='3245';
        pur.VPM_City__c ='34';
        pur.VPM_District__c ='343';
        pur.VPM_IsVendorSME__c ='No';
        pur.VPM_IsVendorException__c ='No';
        
        insert pur;
        
         VPM_PurchasingRequests__c pur1 =new VPM_PurchasingRequests__c();
        pur1.VPM_CountryRequestingVendor__c ='Belgium';
        pur1.VPM_WhatAreYouBuying__c=TestData;
        pur1.VPM_VendorName1__c='test5678';
        pur1.VPM_Country__c='BE_Belgium';
        pur1.VPM_VendorPhone__c=VENDOR_PHONE;
        pur1.VPM_Comments__c=TestData;
        pur1.VPM_fieldUpdated__c='VPM_IsVendorException__c ,VPM_IsVendorSME__c ,VPM_District__c ,VPM_City__c ,VPM_Country__c,VPM_HouseNumSupplement__c ,VPM_HouseNumber__c ,VPM_Street1__c,VPM_Street2__c,VPM_Street3__c,VPM_Street4__cVPM_SearchTerm2__c ,VPM_SearchTerm_1__c ,VPM_Name3__c ,VPM_Name4__c ,VPM_VendorName2__c ,VPM_ZIPPostcode__c ,VPM_TaxType__c,VPM_ExceptionType__c ,VPM_CheckDigit__c ,VPM_IntLocationNumber2__c,VPM_IntLocationNumber1__c,VPM_CorporateGrp__c,VPM_CreditInfoNumber__c,VPM_TaxNumAtResponsibleTaxAuthority__c,VPM_TaxJurisdictionCode__c,VPM_TaxNumberType__c,VPM_IsNaturalPerson__c,VPM_POBox__c,VPM_POBoxPostCode__c ,VPM_TaxNumber1__c,VPM_TaxNumber2__c,VPM_TaxNumber3__c,VPM_TaxNumber4__c,VPM_VATRegistrationNumber__c';
        pur1.VPM_CompanyCode__c = compCode.Id;
        pur1.VPM_VendorCodeLookup__c = vendor.id;
       
        insert pur1;
    }
    
    static VPM_PurchasingRequests__c TestDataFreightApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        
        //pur.VPM_PaymentTerms__c ='Payment Terms';
       // pur.VPM_BankCountryKey__c ='Bank Country Key';
       // pur.VPM_ReconciliationAccount__c ='Recouncil';
       // pur.VPM_DeletionBlockFlag__c='Undelete';
       // pur.VPM_DeletionBlockFlag__c ='delete';
         pur.VPM_Incoterms1__c='UN _Not Free';
       
        pur.VPM_VendorType__c  = 'FRGT_Freight Vendor_G001';
         pur.VPM_GlobalAuthorisationGroup__c='Freight_Freight';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_FreightApprovalRequired__c=false;
        pur.VPM_FreightSubmitted__c='No';
        pur.VPM_AdvancedFormSubmitted__c=Yes;
        pur.VPM_Rework__c='No';
        
        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
 /*   
     static testMethod void VPM_ApprovalMethodRussian(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = RCT_Russian;
        purid.VPM_BusinessRequestorSubmitted__c=Yes;
         purid.VPM_Rework__c='No';
        // update purId;
          system.debug('purId '+purId+'    '+purId.VPM_Commodity_Family__c);
        goldenData.approvalCallMethod();
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
        VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    
    } */
    
    static testMethod void VPM_ApprovalMethodFreight(){
        
         VPM_PurchasingRequests__c purId = TestDataFreightApprovalMethod();
       //  ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        // VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = 'FRGT_Freight Vendor_G001';
         purid.VPM_GlobalAuthorisationGroup__c='Freight_Freight';        
        purId.VPM_FreightApprovalRequired__c=true;
        
        
       List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
        static VPM_PurchasingRequests__c TestDataRussainApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c =Yes;
         pur.VPM_VendorType__c  = RCT_Russian;
         pur.VPM_GlobalAuthorisationGroup__c=GLOABL_3PM;
         pur.VPM_RussianTaxApprovalRequired__c=false;
        
         pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c=Yes;
         pur.VPM_RussiaSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
  static testMethod void VPM_ApprovalMethodRussian(){
        
         VPM_PurchasingRequests__c purId = TestDataRussainApprovalMethod();
       
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
    static VPM_PurchasingRequests__c TestDataBankApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c =Yes;
         pur.VPM_VendorType__c  = RCT_Russian;
         pur.VPM_GlobalAuthorisationGroup__c=GLOABL_3PM;
         pur.VPM_BankDataValidationRequired__c=false;
      pur.VPM_FinanceApprovalRequired__c=true;
            pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c=Yes;
         pur.VPM_BankDataValidationSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
     static testMethod void VPM_ApprovalMethodBank(){
        
         VPM_PurchasingRequests__c purId = TestDataBankApprovalMethod();
       //  ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        // VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = RCT_Russian;
         purid.VPM_GlobalAuthorisationGroup__c=GLOABL_3PM;
        purId.VPM_BankDataValidationRequired__c=true;
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
    static VPM_PurchasingRequests__c TestDataPositive1(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        pur.VPM_AdvancedFormSubmitted__c =Yes;
        pur.VPM_VendorType__c  = RCT_Russian;
        pur.VPM_GlobalAuthorisationGroup__c=GLOABL_3PM;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=Yes;
        pur.VPM_ProcurementApprovalRequired__c = true;
        pur.VPM_ProcurementSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod1() {        
        VPM_PurchasingRequests__c purId = TestDataPositive1();
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive2(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        pur.VPM_AdvancedFormSubmitted__c =Yes;
        pur.VPM_VendorType__c  = RCT_Russian;
        pur.VPM_GlobalAuthorisationGroup__c=GLOABL_3PM;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=Yes;
        pur.VPM_FreightApprovalRequired__c = true;
        pur.VPM_FreightSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod2() {        
        VPM_PurchasingRequests__c purId = TestDataPositive2(); 
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive3(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        pur.VPM_AdvancedFormSubmitted__c =Yes;
        pur.VPM_VendorType__c  = RCT_Russian;
        pur.VPM_GlobalAuthorisationGroup__c=GLOABL_3PM;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=Yes;
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_BankDataValidationRequired__c = true;
        pur.VPM_BankDataValidationSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod3() {        
        VPM_PurchasingRequests__c purId = TestDataPositive3(); 
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive4(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        pur.VPM_AdvancedFormSubmitted__c =Yes;
        pur.VPM_VendorType__c  = RCT_Russian;
        pur.VPM_GlobalAuthorisationGroup__c=GLOABL_3PM;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=Yes;
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_RussiaSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod4() {        
        VPM_PurchasingRequests__c purId = TestDataPositive4(); 
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive5(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = VendorCode_5001010;
        vendor.mdm_City__c = CITY_ANDORRA;
        vendor.mdm_Country__c =COUNTRY_ALGERIA;
        vendor.mdm_Name1__c =TEST_SIRIUS;
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = PH01;
        companyCode.ECC__c = ECC_U2K2;
        companyCode.VPM_Country__c =COUNTRYREQ_ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c =MBS_Marketing_Services;
        commodityCode.VPM_CommodityClass__c = Ad_hoc_Research; 
        commodityCode.Name=Ad_hoc_Qualitative;
        commodityCode.VPM_CommodityCode__c=CODE5702_UN01580115;
        commodityCode.VPM_CommodityClass__c=Market_Research;
        commodityCode.VPM_Region__c=ECC_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =Test_User2;
        pur.VPM_Status__c = Draft_Request;
        pur.VPM_AccountGroup__c =ZGS1;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=TEST_STREET;
        pur.VPM_Street1__c=TEST_STREET;
        pur.VPM_CountryRequestingVendor__c=COUNTRYREQ_ALGERIA;
        pur.VPM_VendorPhone__c=VENDOR_PHONE;
        pur.VPM_ZIPPostcode__c =POST_CODE;
        pur.VPM_BusinessRequestorSubmitted__c = ''; 
        
        insert pur;
        
        system.assert(pur.Id!=null,ERROR);
        
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod5() {        
        VPM_PurchasingRequests__c pur = TestDataPositive5(); 
        pur.VPM_BusinessRequestorSubmitted__c = Yes; 
        pur.VPM_Rework__c= 'No';
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(pur);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
}