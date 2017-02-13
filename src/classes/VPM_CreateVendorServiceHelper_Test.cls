@isTest private class VPM_CreateVendorServiceHelper_Test {
    public static final String failStatusMDM = 'Failed to Submit to BPM';// MDM status
    public static final String successStatusMDM = 'Submitted to BPM';// MDM status
     public static final String mdm_Code_CONST = '5001010';
  public static final String mdm_City_CONST = 'Andorra';
 public static final String mdm_Country_CONST ='DZ_Algeria';
 public static final String mdm_Name1_CONST ='Test Sirius';
 public static final String mdm_ID_CONST = '1234';
 public static final String ECC_CONST = 'U2K2';
 public static final String VPM_Country_CONST ='Algeria';
 public static final String VPM_CompanyCode_CONST = 'PH01';
  public static final String VPM_Error_CONST ='Error';
  public static final String VPM_GlobalAuthorisationGroup_CONST='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
public static final String VPM_VendorType_CONST  = 'RCT_Russian Customs Tax Vendor_G001';
public static final String VPM_AdvancedFormSubmitted_CONST ='Yes';
public static final String VPM_ZIPPostcode_CONST ='54132';
public static final String VPM_VendorPhone_CONST='1234567895';
public static final String VPM_Street1_CONST='Test Street';
public static final String VPM_VendorName1_CONST ='Test User2';
public static final String VPM_Status_CONST = 'Draft Request';
public static final String VPM_AccountGroup_CONST ='ZGS1';


 public static final String VPM_VendorType1_CONST ='MBS_Marketing Business Services_G001';
 public static final String VPM_AuthorisationGroup_CONST ='MBS--Marketing Services';
 public static final String VPM_CommodityClass_CONST = 'Ad-hoc Research'; 
 public static final String Name_CONST='Ad-hoc Market Research - Qualitative';
 public static final String VPM_CommodityCode_CONST='5702 - UN01580115';
 public static final String VPM_CommodityClass1_CONST='Market Research';

   
    static testMethod void testCallout() {
    //VPM_CreateVendorServiceHelper createVen = new VPM_CreateVendorServiceHelper();
    VPM_CreateVendorServiceHelper.CreateVendorFailureResponse venRes = new VPM_CreateVendorServiceHelper.CreateVendorFailureResponse();
    venRes.details = 'details';
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
        List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,successStatusMDM);
    }
    
    static testMethod void testCallout_New() {
    //VPM_CreateVendorServiceHelper createVen = new VPM_CreateVendorServiceHelper();
    VPM_CreateVendorServiceHelper.CreateVendorFailureResponse venRes = new VPM_CreateVendorServiceHelper.CreateVendorFailureResponse();
    venRes.details = 'details';
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(400));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
       // List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur[0].id , vendorId);
    }
    
        static testMethod void testRetryCallout() {
    //VPM_CreateVendorServiceHelper createVen = new VPM_CreateVendorServiceHelper();
    VPM_CreateVendorServiceHelper.CreateVendorFailureResponse venRes = new VPM_CreateVendorServiceHelper.CreateVendorFailureResponse();
    venRes.details = 'details';
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        //string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_HttpUtil.retryCreateVendorGlobal('',pur[0].id);
        test.stopTest();
        List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,successStatusMDM);
    }
    
    
    static testMethod void testCallout500() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        //VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(500));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
        List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,failStatusMDM);
    }
    static testMethod void testCallout504() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        //VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(504));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
        List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,failStatusMDM);
    }
      
    static testMethod void testCallout00() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        //VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(0));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
        List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,failStatusMDM);
    }
    static testMethod void testCallout503() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        //VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(503));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
         List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,failStatusMDM);
    }
    static testMethod void testCallout700() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        //VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(0));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
        List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,failStatusMDM);
    }
        static testMethod void testCalloutnull() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        string vendorId = pur.get(0).id;
        //VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(123));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
        List<VPM_PurchasingRequests__c> pur1 = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test123' LIMIT 1];
        system.assertEquals(pur1[0].VPM_MDMInsertUpdateStatus__c,failStatusMDM);
    }
    static VPM_PurchasingRequests__c TestDataFreightApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass1_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
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
        pur.VPM_AdvancedFormSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
        pur.VPM_Rework__c='No';
        
        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
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
         purId.VPM_VendorType__c  = VPM_VendorType_CONST;
        purid.VPM_BusinessRequestorSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
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
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass1_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c =VPM_AdvancedFormSubmitted_CONST;
         pur.VPM_VendorType__c  = VPM_VendorType_CONST;
         pur.VPM_GlobalAuthorisationGroup__c=VPM_GlobalAuthorisationGroup_CONST;
         pur.VPM_RussianTaxApprovalRequired__c=false;
        
         pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
         pur.VPM_RussiaSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
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
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass1_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c =VPM_AdvancedFormSubmitted_CONST;
         pur.VPM_VendorType__c  = VPM_VendorType_CONST;
         pur.VPM_GlobalAuthorisationGroup__c=VPM_GlobalAuthorisationGroup_CONST;
         pur.VPM_BankDataValidationRequired__c=false;
      pur.VPM_FinanceApprovalRequired__c=true;
            pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
         pur.VPM_BankDataValidationSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
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
         purId.VPM_VendorType__c  = VPM_VendorType_CONST;
         purid.VPM_GlobalAuthorisationGroup__c=VPM_GlobalAuthorisationGroup_CONST;
        purId.VPM_BankDataValidationRequired__c=true;
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
    static VPM_PurchasingRequests__c TestDataPositive1(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass1_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
        pur.VPM_AdvancedFormSubmitted__c =VPM_AdvancedFormSubmitted_CONST;
        pur.VPM_VendorType__c  = VPM_VendorType_CONST;
        pur.VPM_GlobalAuthorisationGroup__c=VPM_GlobalAuthorisationGroup_CONST;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
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
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass1_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
        pur.VPM_AdvancedFormSubmitted__c =VPM_AdvancedFormSubmitted_CONST;
        pur.VPM_VendorType__c  = VPM_VendorType_CONST;
        pur.VPM_GlobalAuthorisationGroup__c=VPM_GlobalAuthorisationGroup_CONST;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
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
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass1_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
        pur.VPM_AdvancedFormSubmitted__c =VPM_AdvancedFormSubmitted_CONST;
        pur.VPM_VendorType__c  = VPM_VendorType_CONST;
        pur.VPM_GlobalAuthorisationGroup__c=VPM_GlobalAuthorisationGroup_CONST;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
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
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass1_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
        pur.VPM_AdvancedFormSubmitted__c =VPM_AdvancedFormSubmitted_CONST;
        pur.VPM_VendorType__c  = VPM_VendorType_CONST;
        pur.VPM_GlobalAuthorisationGroup__c=VPM_GlobalAuthorisationGroup_CONST;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c=VPM_AdvancedFormSubmitted_CONST;
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
        vendor.mdm_Code__c = mdm_Code_CONST;
        vendor.mdm_City__c = mdm_City_CONST;
        vendor.mdm_Country__c =mdm_Country_CONST;
        vendor.mdm_Name1__c =mdm_Name1_CONST;
        vendor.mdm_ID__c = mdm_ID_CONST;
        insert vendor;
        system.assert(vendor.Id!=null,VPM_Error_CONST);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = VPM_CompanyCode_CONST;
        companyCode.ECC__c = ECC_CONST;
        companyCode.VPM_Country__c =VPM_Country_CONST;
        insert companyCode;
        system.assert(companyCode.Id!=null,VPM_Error_CONST);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =VPM_VendorType1_CONST;
        commodityCode.VPM_AuthorisationGroup__c =VPM_AuthorisationGroup_CONST;
        commodityCode.VPM_CommodityClass__c = VPM_CommodityClass_CONST; 
        commodityCode.Name=Name_CONST;
        commodityCode.VPM_CommodityCode__c=VPM_CommodityCode_CONST;
        commodityCode.VPM_CommodityClass__c=VPM_CommodityClass1_CONST;
        commodityCode.VPM_Region__c=ECC_CONST;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,VPM_Error_CONST);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = ECC_CONST;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =VPM_VendorName1_CONST;
        pur.VPM_Status__c = VPM_Status_CONST;
        pur.VPM_AccountGroup__c =VPM_AccountGroup_CONST;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=VPM_Street1_CONST;
        pur.VPM_Street1__c=VPM_Street1_CONST;
        pur.VPM_CountryRequestingVendor__c=VPM_Country_CONST;
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        pur.VPM_ZIPPostcode__c =VPM_ZIPPostcode_CONST;
        pur.VPM_BusinessRequestorSubmitted__c = ''; 
        
        insert pur;
        
        system.assert(pur.Id!=null,VPM_Error_CONST);
        
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
        pur.VPM_BusinessRequestorSubmitted__c = VPM_AdvancedFormSubmitted_CONST; 
        pur.VPM_Rework__c= 'No';
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(pur);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    @testSetup static void setup() {
        VPM_CompanyCode__c compCode = new VPM_CompanyCode__c(Name = 'Company Code 1', Company_Name__c = 'Unilever', VPM_CompanyCode__c = 'UN',VPM_Country__c ='Belgium');
        insert compCode;
        VPM_PurchasingRequests__c pur =new VPM_PurchasingRequests__c();
        pur.VPM_CountryRequestingVendor__c ='Belgium';
        pur.VPM_WhatAreYouBuying__c='test';
        pur.VPM_VendorName1__c='test123';
        pur.VPM_Country__c='BE_Belgium';
        pur.VPM_VendorPhone__c=VPM_VendorPhone_CONST;
        pur.VPM_Comments__c='test';
        pur.VPM_CompanyCode__c = compCode.Id;
        insert pur;
    }
}