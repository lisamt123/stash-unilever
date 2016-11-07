@isTest
public class VPM_MaintainGlobalVendorService_Test {
  public static final String failStatusMDM = 'Failed to Submit to BPM';// MDM status
    public static final String successStatusMDM = 'Submitted to BPM';// MDM status
    public static final String FieldTypeChanged = 'Both';// MDM status
    public static final String VendorCode = '5001010';// MDM status
     @isTest static void testCallout()
      {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, successStatusMDM);
    }
         @isTest static void GlobalExceptionTest()
      {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assert(true);
    }
         @isTest static void GlobalAndManintainTest() {
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
             @isTest static void GlobalAndManintainTest400() {
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
    @isTest static void testCallout500() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(500));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
    }
    @isTest static void testCallout504() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(504));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
        pur = [SELECT Id,VPM_MDMInsertUpdateStatus__c,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
       system.assertEquals(pur[0].VPM_MDMInsertUpdateStatus__c, failStatusMDM);
    }
    
        @isTest static void MaintainRegionTest200() {
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
            @isTest static void MaintainRegionTest400() {
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
    @testSetup static void setup() {
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
        pur.VPM_WhatAreYouBuying__c='test';
        pur.VPM_VendorName1__c='test1234';
        pur.VPM_Country__c='BE_Belgium';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_Comments__c='test';
        pur.VPM_fieldUpdated__c='VPM_Country__c';
        pur.VPM_CompanyCode__c = compCode.Id;
        pur.VPM_VendorCodeLookup__c = vendor.id;
        insert pur;
    }
}