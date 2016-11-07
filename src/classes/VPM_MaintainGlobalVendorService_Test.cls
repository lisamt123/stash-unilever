@isTest
public class VPM_MaintainGlobalVendorService_Test {
     @isTest static void testCallout() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
    }
         @isTest static void GlobalAndManintainTest() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c ='Both';
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
    }
             @isTest static void GlobalAndManintainTest400() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c ='Both';
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(400));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
    }
                 @isTest static void GlobalAndManintainTest503() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c ='Both';
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(503));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
    }
                 @isTest static void GlobalAndManintainTest507() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id,VPM_Fieldtype__c, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        pur[0].VPM_Fieldtype__c ='Both';
             update pur;
             string vendorId = pur.get(0).id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(507));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
    }
    @isTest static void testCallout500() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(500));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
    }
    @isTest static void testCallout504() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(504));
        VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorId);
        test.stopTest();
    }
    @isTest static void testCallout400() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(400));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
    }
    @isTest static void testCallout503() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(503));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
    }
    @isTest static void testCallout700() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
        VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(700));
        VPM_CreateVendorServiceHelper.createVendor(vendorId);
        test.stopTest();
    }
    
        @isTest static void MaintainRegionTest200() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
       // VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
        test.stopTest();
    }
            @isTest static void MaintainRegionTest400() {
        List<VPM_PurchasingRequests__c> pur = [SELECT Id, Name FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1];
        string vendorId = pur.get(0).id;
       // VPM_CreateVendorServiceHelper.CreateVendorResponse resp = new VPM_CreateVendorServiceHelper.CreateVendorResponse();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(400));
        VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
        test.stopTest();
    }
    @testSetup static void setup() {
        VPM_CompanyCode__c compCode = new VPM_CompanyCode__c(Name = 'Company Code 2', Company_Name__c = 'Unilever', VPM_CompanyCode__c = 'UN',VPM_Country__c ='Belgium',ECC__c ='U2K2');
        insert compCode;
        mdm_Vendors__c vendor = new mdm_Vendors__c();
    vendor.mdm_Code__c = '5001010';
    vendor.mdm_City__c = 'Andorra';
    vendor.mdm_Country__c ='DZ_Algeria';
    vendor.mdm_Name1__c ='Test Sirius';
    vendor.mdm_Street__c = 'Test Street';
    vendor.mdm_Postcode__c = '54132';
    vendor.mdm_Country__c = 'India';
    vendor.mdm_ID__c = '1234';
    vendor.mdm_vCodeFusion__c='5001010';
    vendor.mdm_vCodeCordillera__c='5001010';
    vendor.mdm_vCodeSirius__c='5001010';
    vendor.mdm_vCodeU2K2__c='5001010'; 
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