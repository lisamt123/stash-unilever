@isTest
public class VPM_regionalMaintainVendorTest{

 @isTest static void updateAndCheckFieldUpdateTest() {
    VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
     purReq.VPM_Comments__c = 'test comment';
     purReq.VPM_TaxNumber1__c  = '53627282';
     purReq.VPM_checkForFieldUpdate__c = true;
     
     test.startTest();
     update purReq;
     test.stopTest(); 
     VPM_PurchasingRequests__c purReq1 = [SELECT Id, Name,VPM_FieldType__c,VPM_fieldUpdated__c from VPM_PurchasingRequests__c where id  =: purReq.Id];
     system.debug('hfdfd'+purReq1.VPM_fieldUpdated__c);
     system.assertEquals(purReq1.VPM_FieldType__c,'Global');
 
 }
 
 @isTest static void InsertVendorTest(){
        String successStatusMDM = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        purReq.VPM_MDMInsertUpdateStatus__c = 'MDM Insert/Update Succeeded';
        purReq.VPM_VendorCode__c='5001010';
           
        update purreq;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
       // VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(purReq.Id);
        test.stopTest(); 
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,successStatusMDM); 
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
        pur.VPM_ECC__c ='Sirius';
        pur.VPM_TaxNumber1__c = '173872';
        pur.VPM_PaymentMethod__c = 'S030';
        pur.VPM_checkForFieldUpdate__c = false;
        pur.VPM_MDMInsertUpdateStatus__c = 'Failed to Submit to BPM';
        insert pur;
        
        List<VPM_listOfRegionalandGlobalField__c> globalFieldsList = new List<VPM_listOfRegionalandGlobalField__c>();
        VPM_listOfRegionalandGlobalField__c globalFields = new VPM_listOfRegionalandGlobalField__c();
        globalFields.Name = '1';
        globalFields.VPM_ApiName__c = 'VPM_TaxNumber1__c';
        globalFields.VPM_ECCRegion__c = 'U2K2,Sirius,Fusion'; 
        globalFields.VPM_fieldDatatype__C = 'Text';
        globalFields.VPM_fieldType__C = 'Global';
        globalFields.VPM_JSONFieldName__c = 'TaxNumber1';
        globalFields.VPM_parentElement__c = 'MainObject';
        
        VPM_listOfRegionalandGlobalField__c globalFields1 = new VPM_listOfRegionalandGlobalField__c();
        globalFields1.Name = '2';
        globalFields1.VPM_ApiName__c = 'VPM_PaymentMethod__c';
        globalFields1.VPM_ECCRegion__c = 'U2K2,Sirius,Fusion'; 
        globalFields1.VPM_fieldDatatype__C = 'Text';
        globalFields1.VPM_fieldType__C = 'Global';
        globalFields1.VPM_JSONFieldName__c = 'TaxNumber1';
        globalFields1.VPM_parentElement__c = 'MainObject';
        globalFieldsList .add(globalFields);
        
        insert globalFieldsList ;
        
    }

}