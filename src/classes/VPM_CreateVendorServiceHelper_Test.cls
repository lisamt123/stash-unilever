@isTest private class VPM_CreateVendorServiceHelper_Test {
    public static final String failStatusMDM = 'Failed to Submit to BPM';// MDM status
    public static final String successStatusMDM = 'Submitted to BPM';// MDM status
    @isTest static void testCallout() {
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
    
        @isTest static void testRetryCallout() {
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
    
    
    @isTest static void testCallout500() {
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
    @isTest static void testCallout504() {
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
      
    @isTest static void testCallout00() {
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
    @isTest static void testCallout503() {
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
    @isTest static void testCallout700() {
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
    @testSetup static void setup() {
        VPM_CompanyCode__c compCode = new VPM_CompanyCode__c(Name = 'Company Code 1', Company_Name__c = 'Unilever', VPM_CompanyCode__c = 'UN',VPM_Country__c ='Belgium');
        insert compCode;
        VPM_PurchasingRequests__c pur =new VPM_PurchasingRequests__c();
        pur.VPM_CountryRequestingVendor__c ='Belgium';
        pur.VPM_WhatAreYouBuying__c='test';
        pur.VPM_VendorName1__c='test123';
        pur.VPM_Country__c='BE_Belgium';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_Comments__c='test';
        pur.VPM_CompanyCode__c = compCode.Id;
        insert pur;
    }
}