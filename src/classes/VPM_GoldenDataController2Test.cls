@isTest
public class VPM_GoldenDataController2Test{

    static VPM_PurchasingRequests__c TestData(){
    
        try
        {
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
        VendorRequest__c obj = new VendorRequest__c();
        obj.Name='Countries';
        obj.VPM_CountryName__c='BR_Brazil';
        insert obj;
    
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='Algeria';
        vendor.mdm_Name1__c ='Test U2K2';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = '4707';
        companyCode.ECC__c = 'Sirius';
        companyCode.VPM_Country__c ='Italy';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='SCS_Supply Chain Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='SCS-Logistics EU';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Advertising Pre-Testing - Digital';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580116';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='Sirius';
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'Sirius';
        pur.VPM_VendorName1__c ='Test User';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c ='BR_Brazil';
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
            pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Italy';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_SearchTerm_1__c='Test User';       
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_DeletionBlockFlag__c = 'MDM Ops Review - Unblock';
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        insert pur;
        
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select id,VPM_Commodity__c,VPM_CountryRequestingVendor__c,VPM_Status__c,VPM_GlobalAuthorisationGroup__c from VPM_PurchasingRequests__c where id=:pur.Id];
        system.assertEquals(pur.Id,pur1.Id);
        system.assertEquals(obj.VPM_CountryName__c,pur.VPM_Country__c );
        return pur;
        }
        catch(exception ex){
            System.debug('Exception in saveRecord Function' + Ex.getStacktraceString());
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }   
       
       
       
    }
    
   
    static VPM_PurchasingRequests__c TestU2K2(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
    VendorRequest__c obj = new VendorRequest__c();
        obj.VPM_CountryName__c='BR_Brazil';
        obj.Name='Countries';
        insert obj;
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='Algeria';
        vendor.mdm_Name1__c ='Test U2K2';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = '2236';
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
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
        pur.VPM_VendorName1__c ='Test User';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c ='BR_Brazil';
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='U2K2';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select id,VPM_Commodity__c,VPM_CountryRequestingVendor__c,VPM_Status__c,VPM_GlobalAuthorisationGroup__c from VPM_PurchasingRequests__c where id=:pur.Id];
        system.assertEquals(pur.Id,pur1.Id);
        return pur;
       
       
       
    }
    
    
    static VPM_PurchasingRequests__c TestFusion(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
    VendorRequest__c obj = new VendorRequest__c();
        obj.VPM_CountryName__c='BR_Brazil';
        obj.Name='Countries';
        insert obj;
 
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='India';
        vendor.mdm_Name1__c ='Test Fusion';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = '2236';
        companyCode.ECC__c = 'Fusion';
        companyCode.VPM_Country__c ='India';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='Fusion';
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'Fusion';
        pur.VPM_VendorName1__c ='Test User';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c ='BR_Brazil';
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='U2K2';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='India';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select id,VPM_Commodity__c,VPM_CountryRequestingVendor__c,VPM_Status__c,VPM_GlobalAuthorisationGroup__c from VPM_PurchasingRequests__c where id=:pur.Id];
        system.assertEquals(pur.Id,pur1.Id);
        return pur;
       
       
       
    }
    
    
static VPM_PurchasingRequests__c TestCordillera(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
       VendorRequest__c obj = new VendorRequest__c();
        obj.VPM_CountryName__c='BR_Brazil';
        obj.Name='Countries';
        insert obj;
    
 
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='Brazil';
        vendor.mdm_Name1__c ='Test Cordillera';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = '2236';
        companyCode.ECC__c = 'Cordillera';
        companyCode.VPM_Country__c ='Brazil';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5005 - 40161600';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='Cordillera';
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'Cordillera';
        pur.VPM_VendorName1__c ='Test User';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c ='BR_Brazil';
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='U2K2';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Brazil';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
        system.assertEquals(pur.Id,pur1.Id);
        return pur;
       
       
       
    }    
    
    
     static VPM_PurchasingRequests__c TestDataApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
    VendorRequest__c obj = new VendorRequest__c();
        obj.VPM_CountryName__c='BR_Brazil';
        obj.Name='Countries';
        insert obj;
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='Brazil';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        vendor.mdm_vCodeFusion__c='5001010';
        vendor.mdm_vCodeCordillera__c='5001010';
        vendor.mdm_vCodeSirius__c='5001010';
        vendor.mdm_vCodeU2K2__c='5001010';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = '2236';
        companyCode.ECC__c = 'Cordillera';
        companyCode.VPM_Country__c ='Brazil';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='Cordillera';
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'Cordillera';
        pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
         
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Brazil';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_PaymentTerms__c ='Payment Terms';
        pur.VPM_BankCountryKey__c ='Bank Country Key';
        pur.VPM_ReconciliationAccount__c ='Recouncil';
        pur.VPM_DeletionBlockFlag__c='Undelete';
        pur.VPM_DeletionBlockFlag__c ='delete';
         pur.VPM_Incoterms1__c='UN _Not Free';
         pur.VPM_Country__c='BR_Brazil';
       
        pur.VPM_VendorType__c ='FRGT_Freight Vendor_G001';
        pur.VPM_Country__c ='BR_Brazil';
        //pur.VPM_Commodity_Family__c = 'Out of Scope';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
      VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_Incoterms1__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.Id,pur1.Id);
        return pur1;
       
       
       
    }
    
    static VPM_PurchasingRequests__c TestDataApprovalMethodMaintain(){
        try
        {
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
    
    VendorRequest__c obj = new VendorRequest__c();
        obj.VPM_CountryName__c='BR_Brazil';
        obj.Name='Countries';
        insert obj;
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = '2236';
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
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
        pur.VPM_VendorName1__c ='Test User';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_PaymentTerms__c ='Payment Terms';
        pur.VPM_BankCountryKey__c ='Bank Country Key';
        pur.VPM_ReconciliationAccount__c ='Recouncil';
        pur.VPM_DeletionBlockFlag__c='Undelete';
        pur.VPM_Incoterms1__c='UN _Not Free';
        //pur.VPM_DeletionBlockFlag__c ='delete';
     //  pur.VPM_Company_Code_Value__c = '2611';
        pur.VPM_ProvidedUnblockUndelete__c= TRUE;
        
        pur.VPM_Country__c ='BR_Brazil';
        pur.VPM_VendorType__c ='FRGT_Freight Vendor_G001';
        //pur.VPM_Commodity_Family__c =commodityCode.VPM_CommodityFamily__c;
        //pur.VPM_Commodity__c=commodityCode.id;
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_VendorType__c ,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
        system.assertEquals(pur.Id,pur1.Id);
        //system.assertequals(commodityCode.VPM_CommodityFamily__c,pur1.VPM_Commodity_Family__c );
        return pur1;
       
        }
        catch(exception ex){
            System.debug('Exception in saveRecord Function' + Ex.getStacktraceString());
            Return Null;
        }   
       
    }
 
    static testMethod void VPM_GoldenDataController2(){
        
         VPM_PurchasingRequests__c purId = TestData();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         goldenData.newMethod();
         goldenData.newMethod1();
    
    }
    
        static testMethod void VPM_GoldenDataControllerU2K2(){
        
         VPM_PurchasingRequests__c purId = TestU2K2();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         goldenData.newMethod();
         goldenData.newMethod1();
    
    }
    
    static testMethod void VPM_GoldenDataControllerFusion(){
        
         VPM_PurchasingRequests__c purId = TestFusion();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         goldenData.newMethod();
         goldenData.newMethod1();
    
    }
    
    static testMethod void VPM_GoldenDataControllerCordillera(){
        
         VPM_PurchasingRequests__c purId = TestCordillera();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         goldenData.newMethod();
         goldenData.newMethod1();
    
    }
    
     
    static testMethod void VPM_ApprovalMethodRussian(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        
                update purId;
         system.debug('purId '+purId+'    '+purId.VPM_Commodity_Family__c);
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(404));
         goldenData.approvalCallMethod();
         Test.stopTest();
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
         purId.recordTypeId =recordTypeId;
         update purId;
         goldenData.approvalCallMethod();
         
    
    }
   
  static testMethod void VPM_ApprovalMethodFreight(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = 'FRGT_Freight Vendor_G001';
         
        
                update purId;
         system.debug('purId '+purId+'    '+purId.VPM_Commodity_Family__c);
         goldenData.approvalCallMethod();
         
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
         purId.recordTypeId =recordTypeId;
         update purId;
         goldenData.approvalCallMethod();
         
    
    }    
    
   
    
     static testMethod void VPM_ApprovalMethodFreight1(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethodMaintain();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         
         purId.VPM_VendorType__c  = 'MBS_Marketing Business Services_G001';
          
        
          
         update purId;
         goldenData.approvalCallMethod();
         
    
    } 
    
    static testMethod void SaveRecord(){
    
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.saveRecord();
    
    
    }
    
    static testMethod void backToFlow(){
    
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.backToFlow();
    
    
    }

    static testMethod void backToGoldenData1(){
    
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.backToGoldenData1();
    
    
    }
    
    
      static testMethod void Search(){
    
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.vendorNameChange();
    
    
    }
    
   /* static testMethod void approvalMaintain1(){
    
        PageReference pg;
        ApexPages.currentPage().getParameters().put('isMaintain2','isMaintain2');
        
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.ApprovalMaintain1();
        
        
    } */
    
    /*static void getVendorDetailsTest() {
      List<VPM_FetchVendorsDetails.InputVariables> inputCriteria = new List<VPM_FetchVendorsDetails.InputVariables>();
        VPM_FetchVendorsDetails.InputVariables crit = new VPM_FetchVendorsDetails.InputVariables();
        crit.vendorCodeInput='9987534';
        crit.ecc = 'Cordillera';
        crit.compnayCode = 'ULAG';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_FetchVendorsDetails.getVendorDetails(inputCriteria);
      Test.stopTest();
  } */
    
      static testMethod void approvalMaintain1UnBlock(){
    
        PageReference pg;
        ApexPages.currentPage().getParameters().put('isMaintain2','isMaintain2');
        
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        purId.VPM_DeletionBlockFlag__c='MDM Ops Review - Undelete';
        update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.ApprovalMaintain1();
        
        
    }
    
  /*  static testMethod void ApprovalMaintain2(){
    
    PageReference pg;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate1();
        purId.VPM_ReconciliationAccount__c='qwqwq22';
        purId.VPM_AccountHolderName__c='Test Holder Name';
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.saveRecord();
        
    } */
    static testMethod void newMethod(){
    
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.newMethod();
    
    
    }
    
    
    
    
     static testMethod void newMethod1(){
    
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         
           
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.newMethod1();
            Test.setCurrentPageReference(new PageReference('apex/VPM_GoldenData1'));
         ApexPages.Message msg;
          
          msg = goldenData.checkValidations(); 
    
    
    }
    
static testMethod void VPM_ApprovalMethodFreight12(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethodMaintain();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         
         purId.VPM_VendorType__c  = 'MBS_Marketing Business Services_G001';
         purId.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX';
         //purId.
       
         
          update purId;
          VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_CheckDoubleInvoices__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: purId.id limit 1];
          system.assertEquals(purId.VPM_VendorType__c ,pur1.VPM_VendorType__c );
          system.assertEquals(purId.VPM_GlobalAuthorisationGroup__c,pur1.VPM_GlobalAuthorisationGroup__c);
         goldenData.approvalCallMethod();
         
    
    }
   
    static VPM_PurchasingRequests__c TestDataApprovalMethodcreate(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
    
 
    
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
        
        VPM_PurchasingOrganisation__c org =new VPM_PurchasingOrganisation__c();
        org.VPM_CompanyCode__c=companyCode.id;
        org.Name='PurchasingOrg';
        insert org;
        system.assert(org.Id!=null,'Error');
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
        pur.VPM_ProvidedBankDetails__c = TRUE;
       
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
         
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_PaymentTerms__c ='Payment Terms';
        pur.VPM_BankCountryKey__c ='Bank Country Key';
        pur.VPM_ReconciliationAccount__c ='Recouncil';
        pur.VPM_DeletionBlockFlag__c='Undelete';
        pur.VPM_DeletionBlockFlag__c ='delete';
        pur.VPM_Incoterms1__c='UN _Not Free';
        pur.VPM_PurchasingOrg__c=org.id;
        pur.VPM_VendorType__c ='FRGT_Freight Vendor_G001';
        pur.VPM_Country__c ='BR_Brazil';
        //pur.VPM_Commodity_Family__c = 'Out of Scope';
        pur.VPM_SRVBasedVendorID__c=FALSE;
        pur.VPM_CashManagementGroup__c='None';
        insert pur;
        system.assert(pur.Id!=null,'Error');
         pur.VPM_VendorName1__c =null;
         pur.VPM_CheckDoubleInvoices__c=FALSE;
         pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_CheckDoubleInvoices__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
        system.assertEquals(pur.VPM_CheckDoubleInvoices__c,pur1.VPM_CheckDoubleInvoices__c);
        system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        system.debug(pur.VPM_VendorName1__c);
        system.debug(pur1.VPM_VendorName1__c);
        system.assertEquals(pur.VPM_VendorName1__c ,pur1.VPM_VendorName1__c );
        return pur1;
       
       
       
    }
    
    static VPM_PurchasingRequests__c TestDataApprovalMethodcreate1(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
    
 
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
         List<VPM_FetchVendorsDetails.InputVariables> inputCriteria = new List<VPM_FetchVendorsDetails.InputVariables>();
        VPM_FetchVendorsDetails.InputVariables crit = new VPM_FetchVendorsDetails.InputVariables();
        crit.vendorCodeInput='9987534';
        crit.ecc = 'Cordillera';
        crit.compnayCode = 'ULAG';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        Test.stopTest();
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
        
        VPM_PurchasingOrganisation__c org =new VPM_PurchasingOrganisation__c();
        org.VPM_CompanyCode__c=companyCode.id;
        org.Name='PurchasingOrg';
        insert org;
        system.assert(org.Id!=null,'Error');
        
       VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
        pur.VPM_ProvidedBankDetails__c = TRUE;
       
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
         
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_PaymentTerms__c ='Payment Terms';
        pur.VPM_BankCountryKey__c ='Bank Country Key';
        pur.VPM_ReconciliationAccount__c ='Recouncil';
        pur.VPM_DeletionBlockFlag__c='';
        pur.VPM_ProcurementApprovalRequired__c=true;
        pur.VPM_Incoterms1__c='UN _Not Free';
        pur.VPM_PurchasingOrg__c=org.id;
        pur.VPM_VendorType__c ='FRGT_Freight Vendor_G001';
        pur.VPM_Country__c ='BR_Brazil';
        pur.VPM_VendorBlockUnblockDelete__c='Blocked';
        pur.VPM_ProvidedUnblockUndelete__c = true;
        pur.VPM_ProvidedBlockDelete__c = TRUE; 
        pur.VPM_ProvidedPaymentTerms__c = TRUE ;
        //pur.VPM_Company_Code_Value__c= '2611';
        //pur.VPM_Commodity_Family__c = 'Out of Scope';
        pur.VPM_SRVBasedVendorID__c=FALSE;
        pur.VPM_CashManagementGroup__c='None';
        insert pur;
        system.assert(pur.Id!=null,'Error');
         pur.VPM_VendorName1__c =null;
         pur.VPM_Commodity__c=commodityCode.id;
         pur.VPM_CheckDoubleInvoices__c=FALSE;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_CheckDoubleInvoices__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
        system.assertEquals(pur.VPM_CheckDoubleInvoices__c,pur1.VPM_CheckDoubleInvoices__c);
        system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        system.assertEquals(pur.VPM_VendorName1__c ,pur1.VPM_VendorName1__c );
        return pur1;
       
       
       
    }
    
    
    static testMethod void SaveRecord1(){
    
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.saveRecord();
        
        
        
}

   static testMethod void errorMessage(){
        PageReference pg;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.ErrorMessage();

   
   
   } 
   
  
}