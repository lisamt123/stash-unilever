@isTest
public class VPM_RegionalMaintainVendorTest{
 public static final String ECCRegion=  'U2K2,Sirius,Fusion'; 
 public static final String FieldType=  'Regional'; 
 public static final String VendorCode=  '5001010'; 
  public static final String successStatusMDM = 'ECC Insert / Update Succeeded'; 
 // public static final String successStatusMDM = null; 
  public static final String successStatusMsg = 'MDM Insert/Update Succeeded'; 
    
 static testMethod void updateAndCheckFieldUpdateTest() {
    VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
     purReq.VPM_Comments__c = 'test comment';
     purReq.VPM_TaxNumber1__c  = '53627282';
     purReq.VPM_checkForFieldUpdate__c = true;
     
     test.startTest();
     update purReq;
      
     VPM_PurchasingRequests__c purReq1 = [SELECT Id, Name,VPM_FieldType__c,VPM_fieldUpdated__c from VPM_PurchasingRequests__c where id  =: purReq.Id];
     
     system.debug('hfdfd'+purReq1.VPM_fieldUpdated__c);
     VPM_PurchasingRequests__c result = [SELECT Id, Name,VPM_FieldType__c from VPM_PurchasingRequests__c where id  =: purReq.Id];

     system.assertEquals(purReq1.VPM_FieldType__c,result.VPM_FieldType__c);

      

     test.stopTest();
 
 }
 
 static testMethod void InsertVendorTestFusion(){
        //String successStatusMDM = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_companyCodeMatch__c,VPM_purchasingOrgMatch__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        purReq.VPM_MDMInsertUpdateStatus__c =successStatusMsg ;
        purReq.VPM_VendorCode__c=VendorCode;
     purReq.VPM_companyCodeMatch__c = false;
     purReq.VPM_purchasingOrgMatch__c = false;
           recordType VendorReordType  = [select Name, id from recordType where developerName = 'VPM_VendorReqExtend'];
     purReq.RecordTypeId = VendorReordType.id;
        update purreq;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
       
         test.stopTest();
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        VPM_PurchasingRequests__c result = [SELECT Id,VPM_ECC_InsertUpdateStatus__c FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,result.VPM_ECC_InsertUpdateStatus__c ); 
        
 }
    
    
    static testMethod void InsertVendorTestSirius(){
        //String successStatusMDMSirius = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_companyCodeMatch__c,VPM_purchasingOrgMatch__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        purReq.VPM_MDMInsertUpdateStatus__c = successStatusMsg ;
        purReq.VPM_VendorCode__c=VendorCode;
     purReq.VPM_companyCodeMatch__c = false;
     purReq.VPM_purchasingOrgMatch__c = false;
     purReq.VPM_ReconciliationAccount__c ='9898';
     purReq.VPM_PaymentMethod__c = 'S030';
           recordType VendorReordType  = [select Name, id from recordType where developerName = 'VPM_VendorReqExtend'];
     purReq.RecordTypeId = VendorReordType.id;
         VPM_CompanyCode__c companyCode =[select ECC__c, id from VPM_CompanyCode__c where Name = 'Company Code 2' limit 1];
         companyCode.ECC__c ='Sirius';
         //purReq.VPM_ECC__c = 'Sirius';
        
         update companyCode;
        update purreq;
         test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
       
        test.stopTest(); 
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        VPM_PurchasingRequests__c result = [SELECT Id,VPM_ECC_InsertUpdateStatus__c FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,result.VPM_ECC_InsertUpdateStatus__c ); 
        
 }
    
      static testMethod void InsertVendorTestU2K2(){
        //String successStatusMDMU2K2 = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_companyCodeMatch__c,VPM_purchasingOrgMatch__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        purReq.VPM_MDMInsertUpdateStatus__c = successStatusMsg ;
        purReq.VPM_VendorCode__c=VendorCode;
     purReq.VPM_companyCodeMatch__c = false;
     purReq.VPM_purchasingOrgMatch__c = false;
           recordType VendorReordType  = [select Name, id from recordType where developerName = 'VPM_VendorReqExtend'];
     purReq.RecordTypeId = VendorReordType.id;
         VPM_CompanyCode__c companyCode =[select ECC__c, id from VPM_CompanyCode__c where Name = 'Company Code 2' limit 1];
         companyCode.ECC__c ='U2K2';
              //purReq.VPM_ECC__c = 'U2K2';
        
         update companyCode;
         // VPM_CheckRecursive.run = true;
        update purreq;
       
         test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
       
        test.stopTest();
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        VPM_PurchasingRequests__c result = [SELECT Id,VPM_ECC_InsertUpdateStatus__c FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,result.VPM_ECC_InsertUpdateStatus__c );
         
 }
    
    
      static testMethod void InsertVendorTestCordillera(){
        //String successStatusMDMCordillera = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_companyCodeMatch__c,VPM_purchasingOrgMatch__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        purReq.VPM_MDMInsertUpdateStatus__c =successStatusMsg ;
        purReq.VPM_VendorCode__c=VendorCode;
     purReq.VPM_companyCodeMatch__c = false;
     purReq.VPM_purchasingOrgMatch__c = false;
           recordType VendorReordType  = [select Name, id from recordType where developerName = 'VPM_VendorReqExtend'];
     purReq.RecordTypeId = VendorReordType.id;
         VPM_CompanyCode__c companyCode =[select ECC__c, id from VPM_CompanyCode__c where Name = 'Company Code 2' limit 1];
         companyCode.ECC__c ='Cordillera';
         update companyCode;
        update purreq;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        test.stopTest(); 
        
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        VPM_PurchasingRequests__c result = [SELECT Id,VPM_ECC_InsertUpdateStatus__c FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,result.VPM_ECC_InsertUpdateStatus__c ); 
        
 }
    
    
    static testMethod void InsertVendorTest(){
        //String successStatusMDM = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_companyCodeMatch__c,VPM_purchasingOrgMatch__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        purReq.VPM_MDMInsertUpdateStatus__c =successStatusMsg ;
        purReq.VPM_VendorCode__c=VendorCode;
     purReq.VPM_companyCodeMatch__c = false;
     purReq.VPM_purchasingOrgMatch__c = false;
           recordType VendorReordType  = [select Name, id from recordType where developerName = 'VPM_VendorReqExtend'];
     purReq.RecordTypeId = VendorReordType.id;
        update purreq;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
       // VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(purReq.Id);
        test.stopTest(); 
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        VPM_PurchasingRequests__c result = [SELECT Id,VPM_ECC_InsertUpdateStatus__c FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,result.VPM_ECC_InsertUpdateStatus__c );
        
 }

static testMethod void CreateRecordTypeTestFusion(){
        //String successStatusMDM = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_companyCodeMatch__c,VPM_purchasingOrgMatch__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        
     //purReq.VPM_companyCodeMatch__c = false;
     //purReq.VPM_purchasingOrgMatch__c = false;
           recordType VendorReordType  = [select Name, id from recordType where developerName = 'VPM_VendorReqCreate'];
     purReq.RecordTypeId = VendorReordType.id;
       
        purReq.VPM_MDMInsertUpdateStatus__c =successStatusMsg ;
        purReq.VPM_VendorCode__c=VendorCode;
     purReq.VPM_ReconciliationAccount__c ='9898';
    purReq.VPM_PaymentMethod__c ='test';
        test.startTest();
        update purReq;
        //Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
       // VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(purReq.Id);
        test.stopTest(); 
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        VPM_PurchasingRequests__c result = [SELECT Id,VPM_ECC_InsertUpdateStatus__c FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,result.VPM_ECC_InsertUpdateStatus__c );
        
 }
 
  static testMethod void CreateRecordTypeTestCordillera(){
        //String successStatusMDMCordillera = 'ECC Insert / Update Succeeded';
       VPM_PurchasingRequests__c purReq = [SELECT Id, Name,VPM_Comments__c,VPM_VendorCode__c,VPM_companyCodeMatch__c,VPM_purchasingOrgMatch__c,VPM_MDMInsertUpdateStatus__c,VPM_TaxNumber1__c,VPM_PaymentMethod__c ,VPM_checkForFieldUpdate__c  FROM VPM_PurchasingRequests__c WHERE VPM_VendorName1__c = 'test1234' LIMIT 1]; 
        purReq.VPM_MDMInsertUpdateStatus__c =successStatusMsg ;
        purReq.VPM_VendorCode__c=VendorCode;
     purReq.VPM_companyCodeMatch__c = false;
     purReq.VPM_purchasingOrgMatch__c = false;
           recordType VendorReordType  = [select Name, id from recordType where developerName = 'VPM_VendorReqCreate'];
     purReq.RecordTypeId = VendorReordType.id;
         VPM_CompanyCode__c companyCode =[select ECC__c, id from VPM_CompanyCode__c where Name = 'Company Code 2' limit 1];
         companyCode.ECC__c ='Cordillera';
         update companyCode;
       
        test.startTest();
         update purreq;
       // Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        test.stopTest(); 
        
        VPM_PurchasingRequests__c pur1 = [SELECT Id,VPM_ECC_InsertUpdateStatus__c, Name FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        VPM_PurchasingRequests__c result = [SELECT Id,VPM_ECC_InsertUpdateStatus__c FROM VPM_PurchasingRequests__c WHERE Id=:purReq.Id  LIMIT 1];
        system.assertEquals(pur1.VPM_ECC_InsertUpdateStatus__c,result.VPM_ECC_InsertUpdateStatus__c ); 
        
 }


 @testSetup static void setup() {
        String vCode = '5001010'; 
        VPM_CompanyCode__c compCode = new VPM_CompanyCode__c(Name = 'Company Code 2', Company_Name__c = 'Unilever', VPM_CompanyCode__c = 'UN',VPM_Country__c ='Belgium',ECC__c ='Fusion');
        insert compCode;
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = vCode;
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_Street__c = 'Test Street';
        vendor.mdm_Postcode__c = '54132';
        vendor.mdm_Country__c = 'India';
        vendor.mdm_ID__c = '1234';
        vendor.mdm_vCodeFusion__c= vCode;
        vendor.mdm_vCodeCordillera__c= vCode;
        vendor.mdm_vCodeSirius__c= vCode;
        vendor.mdm_vCodeU2K2__c=vCode; 
       insert vendor;
        
        VPM_PurchasingRequests__c pur =new VPM_PurchasingRequests__c();
        pur.VPM_CountryRequestingVendor__c ='Belgium';
        pur.VPM_WhatAreYouBuying__c='test';
        pur.VPM_VendorName1__c='test1234';
        pur.VPM_Country__c='BE_Belgium';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_Comments__c='test';
        pur.VPM_fieldUpdated__c='VPM_LastInterestRun__c,VPM_ReconciliationAccount__c ,VPM_LastKeyDate__c,VPM_TaxNumber1__c,VPM_ActualQMSystem__c,VPM_LSTno__c,VPM_OrderAcknowledgmentRequirement__c,VPM_PaymentMethod__c,VPM_QMSystemTo__c,VPM_ReasonForExemption__c';
        pur.VPM_CompanyCode__c = compCode.Id;
        pur.VPM_VendorCodeLookup__c = vendor.id;
        pur.VPM_ECC__c ='Sirius';
        pur.VPM_TaxNumber1__c = '173872';
        pur.VPM_PaymentMethod__c = 'S030';
        pur.VPM_checkForFieldUpdate__c = false;
        pur.VPM_MDMInsertUpdateStatus__c = 'Failed to Submit to BPM';
        pur.VPM_ActualQMSystem__c ='TE_TEST';
        pur.VPM_OrderAcknowledgmentRequirement__c=true;
        pur.VPM_QMSystemTo__c= System.Today();
        pur.VPM_ReasonForExemption__c= 'TE_TEST';
        pur.VPM_LSTno__c ='test';
        pur.VPM_ReconciliationAccount__c ='0902334';
        pur.VPM_PANNumber__c ='2344';
     pur.VPM_LastKeyDate__c = null;
     pur.VPM_LastInterestRun__c = null;
        insert pur;
        
        List<VPM_listOfRegionalandGlobalField__c> globalFieldsList = new List<VPM_listOfRegionalandGlobalField__c>();
        VPM_listOfRegionalandGlobalField__c globalFields = new VPM_listOfRegionalandGlobalField__c();
        globalFields.Name = '0';
        globalFields.VPM_ApiName__c = 'VPM_TaxNumber1__c';
        globalFields.VPM_ECCRegion__c = ECCRegion; 
        globalFields.VPM_fieldDatatype__C = 'Text';
        globalFields.VPM_fieldType__C = 'Global';
        globalFields.VPM_JSONFieldName__c = 'TaxNumber1';
        globalFields.VPM_parentElement__c = 'MainObject';
        globalFields.VPM_SectionName__c = 'General Vendor Details Section Changed';
        globalFieldsList.add(globalFields);

        //List<VPM_listOfRegionalandGlobalField__c> globalFieldsList = new List<VPM_listOfRegionalandGlobalField__c>();
        VPM_listOfRegionalandGlobalField__c globalFields1 = new VPM_listOfRegionalandGlobalField__c();
        globalFields1.Name = '1';
        globalFields1.VPM_ApiName__c = 'VPM_ActualQMSystem__c';
        globalFields1.VPM_ECCRegion__c =ECCRegion; 
        globalFields1.VPM_fieldDatatype__C = 'valueWithUnderScore';
        globalFields1.VPM_fieldType__C = FieldType;
        globalFields1.VPM_JSONFieldName__c = 'ActualQMSystem';
        globalFields1.VPM_parentElement__c = 'CompanyData';
        globalFieldsList.add(globalFields1);

        //List<VPM_listOfRegionalandGlobalField__c> globalFieldsList2 = new List<VPM_listOfRegionalandGlobalField__c>();
        VPM_listOfRegionalandGlobalField__c globalFields2 = new VPM_listOfRegionalandGlobalField__c();
        globalFields2.Name = '2';
        globalFields2.VPM_ApiName__c = 'VPM_OrderAcknowledgmentRequirement__c';
        globalFields2.VPM_ECCRegion__c = ECCRegion; 
        globalFields2.VPM_fieldDatatype__C = 'Boolean';
        globalFields2.VPM_fieldType__C = FieldType;
        globalFields2.VPM_JSONFieldName__c = 'OrderAcknowledgmentRequirement';
        globalFields2.VPM_parentElement__c = 'WtaxType';
        globalFieldsList.add(globalFields2);


        VPM_listOfRegionalandGlobalField__c globalFields3 = new VPM_listOfRegionalandGlobalField__c();
        globalFields3.Name = '3';
        globalFields3.VPM_ApiName__c = 'VPM_PaymentMethod__c';
        globalFields3.VPM_ECCRegion__c = ECCRegion; 
        globalFields3.VPM_fieldDatatype__C = 'MultiPicklistValueWithUnderScore';
        globalFields3.VPM_fieldType__C = FieldType;
        globalFields3.VPM_JSONFieldName__c = 'PaymentMethod';
        globalFields3.VPM_parentElement__c = 'MainObject';
        globalFieldsList.add(globalFields3);

        VPM_listOfRegionalandGlobalField__c globalFields4 = new VPM_listOfRegionalandGlobalField__c();
        globalFields4.Name = '4';
        globalFields4.VPM_ApiName__c = 'VPM_QMSystemTo__c';
        globalFields4.VPM_ECCRegion__c = ECCRegion; 
        globalFields4.VPM_fieldDatatype__C = 'DateTime';
        globalFields4.VPM_fieldType__C = FieldType;
        globalFields4.VPM_JSONFieldName__c = 'QMSystemTo';
        globalFields4.VPM_parentElement__c = 'Address';
        globalFieldsList.add(globalFields4);
     

        VPM_listOfRegionalandGlobalField__c globalFields5 = new VPM_listOfRegionalandGlobalField__c();
        globalFields5.Name = '5';
        globalFields5.VPM_ApiName__c = 'VPM_ReasonForExemption__c';
        globalFields5.VPM_ECCRegion__c = ECCRegion; 
        globalFields5.VPM_fieldDatatype__C = 'valueWithUnderScore';
        globalFields5.VPM_fieldType__C = FieldType;
        globalFields5.VPM_JSONFieldName__c = 'ReasonForExemption';
        globalFields5.VPM_parentElement__c = 'InternationalVersions';
        globalFieldsList.add(globalFields5);
        
        VPM_listOfRegionalandGlobalField__c globalFields6 = new VPM_listOfRegionalandGlobalField__c();
        globalFields6.Name = '6';
        globalFields6.VPM_ApiName__c = 'VPM_LSTno__c';
        globalFields6.VPM_ECCRegion__c = ECCRegion; 
        globalFields6.VPM_fieldDatatype__C = 'Text';
        globalFields6.VPM_fieldType__C = FieldType;
        globalFields6.VPM_JSONFieldName__c = 'LSTno';
        globalFields6.VPM_parentElement__c = 'CIN';
        globalFieldsList.add(globalFields6);
        
        
        
        VPM_listOfRegionalandGlobalField__c globalFields7 = new VPM_listOfRegionalandGlobalField__c();
        globalFields7.Name = '7';
        globalFields7.VPM_ApiName__c = 'VPM_ReconciliationAccount__c';
        globalFields7.VPM_ECCRegion__c = ECCRegion; 
        globalFields7.VPM_fieldDatatype__C = 'Text';
        globalFields7.VPM_fieldType__C = FieldType;
        globalFields7.VPM_JSONFieldName__c = 'ReconciliationAccount';
        globalFields7.VPM_parentElement__c = 'CompanyData';
        globalFieldsList.add(globalFields7);
     
     VPM_listOfRegionalandGlobalField__c globalFields8 = new VPM_listOfRegionalandGlobalField__c();
        globalFields8.Name = '8';
        globalFields8.VPM_ApiName__c = 'VPM_LastKeyDate__c';
        globalFields8.VPM_ECCRegion__c = ECCRegion; 
        globalFields8.VPM_fieldDatatype__C = 'DateTime';
        globalFields8.VPM_fieldType__C = FieldType;
        globalFields8.VPM_JSONFieldName__c = 'QMSystemTo';
        globalFields8.VPM_parentElement__c = 'CompanyData';
        globalFieldsList.add(globalFields8);
        
        VPM_listOfRegionalandGlobalField__c globalFields9 = new VPM_listOfRegionalandGlobalField__c();
        globalFields9.Name = '9';
        globalFields9.VPM_ApiName__c = 'VPM_PANNumber__c';
        globalFields9.VPM_ECCRegion__c = ECCRegion; 
        globalFields9.VPM_fieldDatatype__C = 'Text';
        globalFields9.VPM_fieldType__C = FieldType;
        globalFields9.VPM_JSONFieldName__c = 'PANNumber';
        globalFields9.VPM_parentElement__c = 'CIN';
        globalFieldsList.add(globalFields9);
     
  
        
        insert globalFieldsList ;
        
    }

}