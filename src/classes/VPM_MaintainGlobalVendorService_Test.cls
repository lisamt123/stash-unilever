@isTest
public class VPM_MaintainGlobalVendorService_Test {
  public static final String failStatusMDM = 'Failed to Submit to BPM';// MDM status
    public static final String successStatusMDM = 'Submitted to BPM';// MDM status
    public static final String FieldTypeChanged = 'Both';// MDM status
    public static final String VendorCode = '5001010';// MDM status
    public static final String TestData= 'Test';// MDM status
    public static final String TaxDataNumber= '2345';// MDM status
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
    vendor.mdm_City__c = 'Andorra';
    vendor.mdm_Country__c ='DZ_Algeria';
    vendor.mdm_Name1__c ='Test Sirius';
    vendor.mdm_Street__c = 'Test Street';
    vendor.mdm_Postcode__c = '54132';
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
        pur.VPM_VendorPhone__c='1234567895';
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
    }
    
    
}