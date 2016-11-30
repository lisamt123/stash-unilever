@isTest(seealldata=false)
public with sharing  class VPM_ApprovalSubmitTest {

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
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
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
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_Rework__c='No';
        
        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,'Error');
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
         purId.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        purid.VPM_BusinessRequestorSubmitted__c='Yes';
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
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
         pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
         pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
         pur.VPM_RussianTaxApprovalRequired__c=false;
        
         pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c='Yes';
         pur.VPM_RussiaSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,'Error');
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
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
         pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
         pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
         pur.VPM_BankDataValidationRequired__c=false;
      pur.VPM_FinanceApprovalRequired__c=true;
            pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c='Yes';
         pur.VPM_BankDataValidationSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,'Error');
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
         purId.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
         purid.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        purId.VPM_BankDataValidationRequired__c=true;
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
    static VPM_PurchasingRequests__c TestDataPositive1(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_ProcurementApprovalRequired__c = true;
        pur.VPM_ProcurementSubmitted__c = 'No';
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
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_FreightApprovalRequired__c = true;
        pur.VPM_FreightSubmitted__c = 'No';
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
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_BankDataValidationRequired__c = true;
        pur.VPM_BankDataValidationSubmitted__c = 'No';
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
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_RussiaSubmitted__c = 'No';
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
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_BusinessRequestorSubmitted__c = ''; 
        
        insert pur;
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(pur);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
        system.assert(pur.Id!=null,'Error');
        
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
        pur.VPM_BusinessRequestorSubmitted__c = 'Yes'; 
        pur.VPM_Rework__c= 'No';
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(pur);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
}