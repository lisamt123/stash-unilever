@isTest(seealldata=false)
public with sharing  class VPM_ApprovalSubmitTest {

public static final string  MDM_CODE='5001010';
    public static final string  MDM_COUNTRY='Andorra';
    public static final string  MDM_STREET='Test Street';
    public static final string  ALGERIA='Algeria';
     public static final string ACCGRP='ZGS1';
     public static final string STR_COMCODE='5702 - UN01580115';
      public static final string  MDM_NAME ='Test U2K2';
  Public static final string STR_COMPCODE='PH01';
    public static final string STR_VENDORNAME2='Test User2';
    Public static final string STR_CONST_CORDILLERA ='Cordillera';
    Public static final string STR_CONST_FUSION='Fusion';
    Public static final string STR_CONST_U2K2 ='U2K2';
    Public static final string STR_CONST_ALGERIA ='DZ_Algeria';
   public static final string STR_TEST_DATA_SIRIUS='Test Sirius';
       public static final string  STR_ERROR='Error';
    public static final string STR_COMMODITYCLASS ='Ad-hoc Research';
    public static final string STR_VENDORNAME='Test User';
    Public static final string STR_COMMCLASS='Market Research';
     public static final String STR_CONST_DRAFT= 'Draft Request';
     public static final string STR_VENDORPHONENO='1234567895';
     public static final string STR_ZIPCODE='54132';
   public static final string  MDM_ID='1234';
    Public Static final string STR_NO='No';
      Public Static final string STR_YES='Yes';
     Public static final string STR_VENDORTYPEMSB ='MBS_Marketing Business Services_G001';
     Public static final string STR_AUTHGRPMARKETINGSERVICES='MBS--Marketing Services';
     public static final string STR_COMPANYCODENAME='Ad-hoc Market Research - Qualitative';
   Public static final string STR_GBLAUTHGRP= '3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
   Public static final string STR_VENDTYPERUS='RCT_Russian Customs Tax Vendor_G001';
      Public static final string STR_VENDORTYPEFRGT='FRGT_Freight Vendor_G001';
        Public static final string  STR_GBLAUTHGRPFRGT='Freight_Freight';
    Public static final string  STR_GBLAUTHGRPSCS= 'SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
  
    /*@isTest
     public static User insertUser()
    {
        //Profile p = [SELECT Id FROM Profile WHERE Name='VPM - No Access'];
        Profile p = [SELECT Id FROM Profile WHERE Name=:System.label.VPM_Profile];
        User u = new User(LastName = 'Testing', 
                          Username = 'vpmtestuser@test00DE0000000bbLj.org', 
                          Email = 'vpmtestuser@test.com', 
                          Alias = 'utest', 
                          TimeZoneSidKey = 'Europe/London', 
                          LocaleSidKey = 'en_GB', 
                          EmailEncodingKey = 'UTF-8', 
                          ProfileId = p.Id, 
                          LanguageLocaleKey = 'en_US',
                          UserPermissionsKnowledgeUser = true);  
        
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('VPM_Business_Requestor')];
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        for(PermissionSet ps:pslist)
        {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            psalist.add(psa);
        }
        
        insert psalist;
        return u;
        
    }  */

    static VPM_PurchasingRequests__c TestDataFreightApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRPSCS;
        
        //pur.VPM_PaymentTerms__c ='Payment Terms';
       // pur.VPM_BankCountryKey__c ='Bank Country Key';
       // pur.VPM_ReconciliationAccount__c ='Recouncil';
       // pur.VPM_DeletionBlockFlag__c='Undelete';
       // pur.VPM_DeletionBlockFlag__c ='delete';
         pur.VPM_Incoterms1__c='UN _Not Free';
       
        pur.VPM_VendorType__c  = STR_VENDORTYPEFRGT;
         pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRPFRGT;
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_FreightApprovalRequired__c=false;
        pur.VPM_FreightSubmitted__c=STR_NO;
        pur.VPM_AdvancedFormSubmitted__c=STR_YES;
        pur.VPM_Rework__c=STR_NO;
        
        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,STR_ERROR);
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       // List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       //purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
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
         purId.VPM_VendorType__c  = STR_VENDTYPERUS;
        purid.VPM_BusinessRequestorSubmitted__c=STR_YES;
         purid.VPM_Rework__c=STR_NO;
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
         purId.VPM_VendorType__c  = STR_VENDORTYPEFRGT;
         purid.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRPFRGT;        
        purId.VPM_FreightApprovalRequired__c=true;
        
        
       List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
        static VPM_PurchasingRequests__c TestDataRussainApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        //pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRPSCS;
        pur.VPM_AdvancedFormSubmitted__c =STR_YES;
         pur.VPM_VendorType__c  = STR_VENDTYPERUS;
         pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRP;
         pur.VPM_RussianTaxApprovalRequired__c=false;
        
         pur.VPM_Rework__c=STR_NO;
         pur.VPM_AdvancedFormSubmitted__c=STR_YES;
         pur.VPM_RussiaSubmitted__c=STR_NO;
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,STR_ERROR);
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       // List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       //purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
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
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        //pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRPSCS;
        pur.VPM_AdvancedFormSubmitted__c =STR_YES;
         pur.VPM_VendorType__c  = STR_VENDTYPERUS;
         pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRP;
         pur.VPM_BankDataValidationRequired__c=false;
      pur.VPM_FinanceApprovalRequired__c=true;
            pur.VPM_Rework__c=STR_NO;
         pur.VPM_AdvancedFormSubmitted__c=STR_YES;
         pur.VPM_BankDataValidationSubmitted__c=STR_NO;
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,STR_ERROR);
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       // List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       //purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
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
         purId.VPM_VendorType__c  = STR_VENDTYPERUS;
         purid.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRP;
        purId.VPM_BankDataValidationRequired__c=true;
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
    static VPM_PurchasingRequests__c TestDataPositive1(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_AdvancedFormSubmitted__c =STR_YES;
        pur.VPM_VendorType__c  = STR_VENDTYPERUS;
        pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRP;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,STR_ERROR);
        pur.VPM_Rework__c=STR_NO;
        pur.VPM_AdvancedFormSubmitted__c=STR_YES;
        pur.VPM_ProcurementApprovalRequired__c = true;
        pur.VPM_ProcurementSubmitted__c = STR_NO;
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       // List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       //purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
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
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_AdvancedFormSubmitted__c =STR_YES;
        pur.VPM_VendorType__c  = STR_VENDTYPERUS;
        pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRP;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        system.assert(pur.Id!=null,STR_ERROR);
        pur.VPM_Rework__c=STR_NO;
        pur.VPM_AdvancedFormSubmitted__c=STR_YES;
        pur.VPM_FreightApprovalRequired__c = true;
        pur.VPM_FreightSubmitted__c = STR_NO;
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
      //  List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       //purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
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
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_AdvancedFormSubmitted__c =STR_YES;
        pur.VPM_VendorType__c  = STR_VENDTYPERUS;
        pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRP;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,STR_ERROR);
        pur.VPM_Rework__c=STR_NO;
        pur.VPM_AdvancedFormSubmitted__c=STR_YES;
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_BankDataValidationRequired__c = true;
        pur.VPM_BankDataValidationSubmitted__c = STR_NO;
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        //List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       //purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
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
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_AdvancedFormSubmitted__c =STR_YES;
        pur.VPM_VendorType__c  = STR_VENDTYPERUS;
        pur.VPM_GlobalAuthorisationGroup__c=STR_GBLAUTHGRP;
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        system.assert(pur.Id!=null,STR_ERROR);
        pur.VPM_Rework__c=STR_NO;
        pur.VPM_AdvancedFormSubmitted__c=STR_YES;
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_RussiaSubmitted__c = STR_NO;
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
      //  List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       //purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
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
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_COUNTRY;
        vendor.mdm_Country__c =STR_CONST_ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME2;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c =ACCGRP;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c=MDM_STREET;
        pur.VPM_Street1__c=MDM_STREET;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_BusinessRequestorSubmitted__c = ''; 
        
        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,STR_ERROR);
        
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
      //  List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
    //   purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod5() {        
        VPM_PurchasingRequests__c pur = TestDataPositive5(); 
        pur.VPM_BusinessRequestorSubmitted__c = STR_YES; 
        pur.VPM_Rework__c= STR_NO;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(pur);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
}