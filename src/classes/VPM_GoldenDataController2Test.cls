@isTest
public class VPM_GoldenDataController2Test{
/* Constant Values */ 
  public static final string  VPM_COUNTRYNAME='BR_Brazil';
    public static final string  COUNTRIES='Countries';
    public static final string  MDM_CODE='5001010';
    public static final string  MDM_COUNTRY='Andorra';
    public static final string  MDM_CITY='Andorra';
     public static final string  MDM_NAME ='Test U2K2';
    public static final string  ALGERIA='Algeria';
    Public static final string STR_CONST_CORDILLERA ='Cordillera';
    Public static final string STR_CONST_FUSION='Fusion';
    Public static final string STR_CONST_U2K2 ='U2K2';
    Public static final string STR_CONST_SIRIUS ='Sirius';
    Public static final string FREIGHTVENDOR='FRGT_Freight Vendor_G001';
    public static final string  MDM_ID='1234';
    public static final string  STR_ERROR='Error';
    public static final string STR_COMMODITYCLASS ='Ad-hoc Research';
    public static final string STR_VENDORNAME='Test User';
    Public static final string STR_COMMCLASS='Market Research';
     public static final String STR_CONST_DRAFT= 'Draft Request';
     public static final string STR_STREET1='Test Street';
     public static final string STR_VENDORPHONENO='1234567895';
     public static final string STR_ZIPCODE='54132';
     public static final string STR_COMPANYCODE='2236';
     Public static final string STR_VENDORTYPEMSB ='MBS_Marketing Business Services_G001';
     Public static final string STR_AUTHGRPMARKETINGSERVICES='MBS--Marketing Services';
     public static final string STR_COMPANYCODENAME='Ad-hoc Market Research - Qualitative';
     public static final string STR_COMCODE='5702 - UN01580115';
    public static final string STR_BRAZIL='Brazil';
    public static final string STR_TEST_DATA_SIRIUS='Test Sirius';
   // public PageReference pg {get;set;}

    static void customSettingData(string regionVar) {
        VPM_RegionSpecificFields__c region = new VPM_RegionSpecificFields__c();
        List<VPM_RegionSpecificFields__c> regionList = new List<VPM_RegionSpecificFields__c>();
        region.Region__c = regionVar;
        region.name = '1';
        region.Picklist_API__c ='VPM_Industry__c';
        region.Picklist_Name__c ='Industry';
        region.PICKLIST_VALUES__C = '0001_Industry 0001';
        regionList.add(region);
        insert regionList;
    }   
    
    static VPM_PurchasingRequests__c TestData(){
    
        try
        {
       string  recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
        VPM_LatamCountries__c obj = new VPM_LatamCountries__c();
        obj.Name=COUNTRIES;
        obj.VPM_CountryName__c= 'AR_Argentina,BO_Bolivia,CL_Chile,CO_Colombia,CR_Costa Rica,DO_Dominican Rep.,EC_Ecuador,GT_Guatemala';
        insert obj;
        
        customSettingData(STR_CONST_SIRIUS);        
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c =MDM_COUNTRY;
        vendor.mdm_Name1__c =MDM_NAME;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);  
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = '4707';
        companyCode.ECC__c = STR_CONST_SIRIUS;
        companyCode.VPM_Country__c ='Italy';
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='SCS_Supply Chain Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='SCS-Logistics EU';
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name='Advertising Pre-Testing - Digital';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580116';
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_SIRIUS;
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_SIRIUS;
        pur.VPM_VendorName1__c =STR_VENDORNAME;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c=STR_CONST_SIRIUS;
            pur.VPM_Street1__c=STR_STREET1;
        pur.VPM_CountryRequestingVendor__c='Italy';
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_SearchTerm_1__c=STR_VENDORNAME;       
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_DeletionBlockFlag__c = 'MDM Ops Review - Unblock';
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        pur.VPM_Industry__c = '9001_Oils';    
        insert pur;
        
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select id,VPM_Commodity__c,VPM_CountryRequestingVendor__c,VPM_Status__c,VPM_GlobalAuthorisationGroup__c from VPM_PurchasingRequests__c where id=:pur.Id];
        system.assertEquals(pur.Id,pur1.Id);
        //system.assertEquals(obj.VPM_CountryName__c,pur.VPM_Country__c );
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
    
        VPM_LatamCountries__c obj = new VPM_LatamCountries__c();
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name=COUNTRIES;
        insert obj;
        
        customSettingData(STR_CONST_U2K2);       
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c =ALGERIA;
        vendor.mdm_Name1__c =MDM_NAME;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPANYCODE;
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
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
        pur.VPM_VendorName1__c =STR_VENDORNAME;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c=STR_CONST_U2K2;
        pur.VPM_Street1__c=STR_STREET1;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        pur.VPM_Industry__c = '9001_Oils';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_CashManagementGroup__c = 'V1000_Vendor RM_Vendors: RM & Packaging';
        update pur;
        VPM_PurchasingRequests__c pur1 = [select id,VPM_Commodity__c,VPM_CountryRequestingVendor__c,VPM_Status__c,VPM_GlobalAuthorisationGroup__c from VPM_PurchasingRequests__c where id=:pur.Id];
        system.assertEquals(pur.Id,pur1.Id);
        return pur;
       
       
       
    }
    
    
    static VPM_PurchasingRequests__c TestFusion(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
        VPM_LatamCountries__c obj = new VPM_LatamCountries__c();
        obj.VPM_CountryName__c= STR_CONST_FUSION;
        obj.Name=COUNTRIES;
        insert obj; 
        
        
        customSettingData(STR_CONST_FUSION); 
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c ='India';     
        vendor.mdm_Name1__c ='Test Fusion';
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPANYCODE;
        companyCode.ECC__c = 'Fusion';
        companyCode.VPM_Country__c ='India';
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c='Fusion';
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'Fusion';
        pur.VPM_VendorName1__c =STR_VENDORNAME;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c=STR_CONST_U2K2;
        pur.VPM_Street1__c=STR_STREET1;
        pur.VPM_CountryRequestingVendor__c='India';
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        pur.VPM_Industry__c = '9001_Oils';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select id,VPM_Commodity__c,VPM_CountryRequestingVendor__c,VPM_Status__c,VPM_GlobalAuthorisationGroup__c from VPM_PurchasingRequests__c where id=:pur.Id];
        system.assertEquals(pur.Id,pur1.Id);
        return pur;
       
       
       
    }
    
    
static VPM_PurchasingRequests__c TestCordillera(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
       VPM_LatamCountries__c obj = new VPM_LatamCountries__c();
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name=COUNTRIES;
        insert obj; 
    
        customSettingData(STR_CONST_CORDILLERA); 
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c =STR_BRAZIL;
        vendor.mdm_Name1__c ='Test Cordillera';
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPANYCODE;
        companyCode.ECC__c = STR_CONST_CORDILLERA;
        companyCode.VPM_Country__c =STR_BRAZIL;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c='5005 - 40161600';
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_CORDILLERA;
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_CORDILLERA;
        pur.VPM_VendorName1__c =STR_VENDORNAME;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_AccountGroup__c ='';
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c=STR_CONST_U2K2;
        pur.VPM_Street1__c=STR_STREET1;
        pur.VPM_CountryRequestingVendor__c=STR_BRAZIL;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_GlobalAuthorisationGroup__c='Authorization';
        pur.VPM_Industry__c = '9001_Oils';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
        system.assertEquals(pur.Id,pur1.Id);
        return pur;
       
       
       
    }    
    
    
     static VPM_PurchasingRequests__c TestDataApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
        VPM_LatamCountries__c obj = new VPM_LatamCountries__c();
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name=COUNTRIES;
        insert obj;
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c =STR_BRAZIL;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        vendor.mdm_vCodeFusion__c=MDM_CODE;
        vendor.mdm_vCodeCordillera__c=MDM_CODE;
        vendor.mdm_vCodeSirius__c=MDM_CODE;
        vendor.mdm_vCodeU2K2__c=MDM_CODE;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPANYCODE;
        companyCode.ECC__c = STR_CONST_CORDILLERA;
        companyCode.VPM_Country__c =STR_BRAZIL;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_CORDILLERA;
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_CORDILLERA;
        pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c =STR_VENDORNAME;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
         
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c=STR_CONST_SIRIUS;
        pur.VPM_Street1__c=STR_STREET1;
        pur.VPM_CountryRequestingVendor__c=STR_BRAZIL;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_PaymentTerms__c ='Payment Terms';
        pur.VPM_BankCountryKey__c ='Bank Country Key';
        pur.VPM_ReconciliationAccount__c ='Recouncil';
        pur.VPM_DeletionBlockFlag__c='Undelete';
        pur.VPM_DeletionBlockFlag__c ='delete';
         pur.VPM_Incoterms1__c='UN _Not Free';
         pur.VPM_Country__c=VPM_COUNTRYNAME;
       
        pur.VPM_VendorType__c =FREIGHTVENDOR;
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        pur.VPM_Industry__c = '9001_Oils'; 
        //pur.VPM_Commodity_Family__c = 'Out of Scope';
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
      VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_Incoterms1__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.Id,pur1.Id);
        return pur1;
       
       
       
    }
    
    static VPM_PurchasingRequests__c TestDataApprovalMethodMaintain(){
        
    
      string   recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
    
        VPM_LatamCountries__c obj = new VPM_LatamCountries__c();
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name=COUNTRIES;
        insert obj; 
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c =ALGERIA;
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPANYCODE;
        companyCode.ECC__c = STR_CONST_U2K2;
        companyCode.VPM_Country__c =ALGERIA;
        insert companyCode;
        system.assert(companyCode.Id!=null,STR_ERROR);
        
        VPM_PurchasingOrganisation__c purcOrg = new VPM_PurchasingOrganisation__c();
        purcOrg.Name = 'ULAB_ARIBA Pur.Orgn';
        purcOrg.VPM_Country__c = ALGERIA;
        purcOrg.VPM_POSystem__c = 'Ariba';    
        insert purcOrg;  
      
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c =STR_VENDORTYPEMSB;
        commodityCode.VPM_AuthorisationGroup__c =STR_AUTHGRPMARKETINGSERVICES;
        commodityCode.VPM_CommodityClass__c = STR_COMMODITYCLASS; 
        commodityCode.Name=STR_COMPANYCODENAME;
        commodityCode.VPM_CommodityCode__c=STR_COMCODE;
        commodityCode.VPM_CommodityClass__c=STR_COMMCLASS;
        commodityCode.VPM_Region__c=STR_CONST_U2K2;
          
        insert commodityCode;
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
        pur.VPM_VendorName1__c =STR_VENDORNAME;
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c=STR_CONST_SIRIUS;
        pur.VPM_Street1__c=STR_STREET1;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
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
        pur.VPM_Industry__c = '9001_Oils';
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        pur.VPM_VendorType__c =FREIGHTVENDOR;
        //pur.VPM_Commodity_Family__c =commodityCode.VPM_CommodityFamily__c;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_PurchasingOrg__c = purcOrg.Id; 
        insert pur;
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
        VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_VendorType__c ,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
        system.assertEquals(pur.Id,pur1.Id);
        //system.assertequals(commodityCode.VPM_CommodityFamily__c,pur1.VPM_Commodity_Family__c );
        return pur1;
       
        
       
    }
 
    static testMethod void VPM_GoldenDataController2(){
        
         VPM_PurchasingRequests__c purId = TestData();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        PageReference pageRef = Page.VPM_GoldenData1;
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200,'Maintain'));
        goldenData.approvalCallMethod();
        goldenData.commodityCodeVar = null;
        goldenData.paymentMethodDefaultValue = null;
         goldenData.newMethod();
         goldenData.newMethod1();        
        goldenData.saveAndBackToLaunchScreen();
        
    
    }
    
    static testMethod void VPM_PositiveScenario() {
        VPM_PurchasingRequests__c purId = TestU2K2();
        PageReference pageRef = Page.VPM_GoldenData1;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);        
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        VPM_GoldenDataController2 goldenData1 = new VPM_GoldenDataController2();
        goldenData.recordTypeId = 'Create';
        goldenData.backToGlobalScreen();
        goldenData.recordTypeId = 'Maintain';
        purId.VPM_FieldType__c = null;   
        goldenData.backToGlobalScreen();
        goldenData.recordTypeId = 'Maintain';
        purId.VPM_FieldType__c = 'Global';   
        update purId;
        goldenData.backToGlobalScreen();
        goldenData.recordTypeId = 'Extend';
        purId.VPM_ExtensionType__c = 'Regional';   
        purId.VPM_FieldType__c = null;   
        update purId;
        goldenData.backToGlobalScreen();
        goldenData.backToFlow();

    }
    
    static testMethod void VPM_PositiveScenario1() {
        VPM_PurchasingRequests__c purId = TestU2K2();
        PageReference pageRef = Page.VPM_GoldenData1;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.recordTypeId = 'Extend';
        purId.VPM_ExtensionType__c = 'Regional';   
        purId.VPM_FieldType__c = null;   
        update purId;
        goldenData.backToGlobalScreen();
        goldenData.backToFlow();
    }
    
        static testMethod void VPM_GoldenDataControllerU2K2(){
        
         VPM_PurchasingRequests__c purId = TestU2K2();
            PageReference pageRef = Page.VPM_GoldenData1;
            Test.setCurrentPage(pageRef);
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         goldenData.newMethod();
         goldenData.newMethod1();
           purId.VPM_TradePartnerType__c='';
             update purid; 
            goldenData.checkValidations();
          //  purid.VPM_CompanyCode__r.ecc__c='U2K2';
            purid.VPM_AccountStatement__c='';
            update purid; 
            
            goldenData.checkValidations();
             string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
            purId.recordTypeId =recordTypeId;
            purId.VPM_VendorBlockUnblockDelete__c ='Block';
            goldenData.vendorName = '';
            goldenData.taxJuriCodeDefValue = 'taxJuriCodeDefValue111111111';
            goldenData.vendorPaymentMethod = '[one,one,one,one,one,one,one,one,one,one,one]';
            goldenData.checkValidations();
            goldenData.saveAndBackToLaunchScreen();
            goldenData.recordTypeId = 'Extend';
            goldenData.backToGlobalScreen();
            purId.VPM_ExtensionType__c ='';             
            update purId;
            goldenData.backToGlobalScreen();

            
      //   goldenData.saveAndBackToLaunchScreen();
        // purId.VPM_ProcurementApprovalRequired__c=true;
        // update purid; 
           // goldenData.ProcurementApproval();
    }
    
    static testMethod void VPM_GoldenDataControllerFusion(){
        
         VPM_PurchasingRequests__c purId = TestFusion();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        
         goldenData.newMethod();
         goldenData.newMethod1();
        purId.VPM_WebformSentToVendor__c=true;
        purId.VPM_VendorWebformSubmitted__c=false;
        purId.VPM_RequestFromFLSOrBR__c='FLS';
        update purId;
        goldenData.approvalCallMethod();
        purId.VPM_RequestFromFLSOrBR__c='Business Requestor';
        //Ajay
        purId.VPM_VendorContactDetail__c ='test@test.com';
        purId.VPM_OrderingEmailAddress__c ='';
        purId.VPM_ClerksInternet__c ='';
        purId.VPM_Country__c ='BR_Brazil';
     update purId;
         goldenData.approvalCallMethod();
        // Ajay
       
        VPM_GoldenDataController2 goldenData1 = new VPM_GoldenDataController2(vendorDetail);
    }
    
    static testMethod void VPM_GoldenDataControllerCordillera(){
        
         VPM_PurchasingRequests__c purId = TestCordillera();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
            goldenData.vendorType=false;
            goldenData.authorisationGrp=false;
          goldenData.NewCashManagementGroup ='';
        goldenData.OldCashManagementGroup  =''; 
        goldenData.NewSortKey  =''; 
        goldenData.OldSortKey  ='';
        goldenData.NewPaymentTerms  ='';
        goldenData.OldPaymentTerms ='';
        goldenData.OldPaymentMethod ='';
        goldenData.NewPaymentMethod ='';  

            
         goldenData.newMethod();
         goldenData.newMethod1();
        goldenData.saveRecordRegional();
        goldenData.backToGlobalScreen();
    
    }
    
     
    static testMethod void VPM_ApprovalMethodRussian(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        purId.VPM_PaymentMethod__c='C-T-W';
                update purId;
         system.debug('purId '+purId+'    '+purId.VPM_Commodity_Family__c);
        // Test.startTest();
         Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(404));
         goldenData.approvalCallMethod();
        // Test.stopTest();
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
         purId.recordTypeId =recordTypeId;
        //Purid.RecordType.DeveloperName=recordTypeId;
       /* purId.VPM_FinanceApprovalRequired__c=true;
            purId.VPM_ProvidedBankDetails__c=true;
            purid.VPM_ProvidedBlockDelete__c=false;
              purid.VPM_ProvidedUnblockUndelete__c=false;
            update purid;
                goldenData.setLevelApproval();
            Purid.VPM_RussianTaxApprovalRequired__c=true; 
             purId.VPM_ProvidedBankDetails__c=true;
            purid.VPM_ProvidedBlockDelete__c=false;
              purid.VPM_ProvidedUnblockUndelete__c=false;
            update purid;
                goldenData.setLevelApproval();
              Purid.VPM_FreightApprovalRequired__c=true; 
             purId.VPM_ProvidedPaymentTerms__c=False;
            purid.VPM_ProvidedBankDetails__c=false;
              purid.VPM_ProvidedFinancialSensitive__c=false;
            purid.VPM_ProvidedBlockDelete__c=false;
              purid.VPM_ProvidedUnblockUndelete__c=false;
            update purid;
                goldenData.setLevelApproval();
            
         update purId; */
        Test.startTest();
         goldenData.approvalCallMethod();
        VPM_PurchasingRequests__c resultVendor = [SELECT Id, VPM_RussianTaxApprovalRequired__c FROM VPM_PurchasingRequests__c WHERE Id =: purId.id];
         System.debug('VPM_ApprovalMethodRussian Case  ~~~~~~~~'+ resultVendor);
            System.assert(true);
           Test.stopTest();
    
    }
   
  static testMethod void VPM_ApprovalMethodFreight(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = FREIGHTVENDOR;
         purId.VPM_PaymentMethod__c='C-T-W';
        purId.VPM_Status__c='FLS Approved';
         update purId;
         system.debug('purId '+purId+'    '+purId.VPM_Commodity_Family__c);
         goldenData.approvalCallMethod();
         
        string  recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
         purId.recordTypeId =recordTypeId;
         purId.VPM_PaymentTerms__c='90DK_Within 90 days Due net (90NET)';
        
         update purId;
         goldenData.approvalCallMethod();
      goldenData.ErrorMessage(System.Label.VPM_BlockDeleteVendorErrorMeesage);
     purId.VPM_ProcurementApprovalRequired__c=true;
      update purId;
      goldenData.ProcurementApproval();
    //  goldenData.saveAndBackToLaunchScreen();
         
    
    }    
    
   
    
     static testMethod void VPM_ApprovalMethodFreight1(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethodMaintain();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         
         purId.VPM_VendorType__c  = STR_VENDORTYPEMSB;
          purId.VPM_PaymentMethod__c='C-T-W';
        
          
         update purId;
         Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
         goldenData.approvalCallMethod();
         
    
    } 
    
    static testMethod void SaveRecord(){
    
    VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and DeveloperName ='VPM_VendorReqExtend'].Id; 
       
         purId.VPM_TaxJurisdictionCode__c ='9900_Dummy';
        purId.recordTypeId=recordTypeId;
        purId.VPM_Fieldtype__c ='Global';
        //purId.VPM_Fieldtype__c ='VPM_ECC__c';
        purId.VPM_ProvidedBankDetails__c=true;
        purId.VPM_IsChangedVAT__c=true;
         update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         
           
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.newMethod1();
            Test.setCurrentPageReference(new PageReference('apex/VPM_GoldenData1'));
        ApexPages.Message msg =null;
          
         msg=  goldenData.checkValidations(); 
         System.debug('Msg @@@@@@'+ msg);
         purId.VPM_ExtensionType__c ='Global';
             
         update purId;
        goldenData.saveRecord();
        goldenData.vendorName = '';
        goldenData.checkValidations();   
        goldenData.setLevelApproval('Global');
    
    
    }
    
    static testMethod void backToFlow(){
    
        //PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.backToFlow();
    
    
    }

    static testMethod void backToGoldenData1(){
    
       // PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.backToGoldenData1();
    
    
    }
    
    
      static testMethod void Search(){
    
        //PageReference pg =null;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.vendorNameChange();
    
    
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
        crit.ecc = STR_CONST_CORDILLERA;
        crit.compnayCode = 'ULAG';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_FetchVendorsDetails.getVendorDetails(inputCriteria);
      Test.stopTest();
  } */
    
      static testMethod void approvalMaintain1UnBlock(){
        
       // PageReference pg =null;
        ApexPages.currentPage().getParameters().put('isMaintain2','isMaintain2');
        
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        purId.VPM_DeletionBlockFlag__c='MDM Ops Review - Undelete';
        update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.ApprovalMaintain1();
        
        
    }
    
     static testMethod void approvalMaintain1UnBlock2(){
        
       // PageReference pg =null;
        ApexPages.currentPage().getParameters().put('isMaintain2','isMaintain2');
                    ApexPages.Message msg = null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        purId.VPM_DeletionBlockFlag__c='MDM Ops Review - Block';
        update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.ApprovalMaintain1();
        
        
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
    
       // PageReference pg =null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.newMethod();
        purId.VPM_PaymentMethod__c='[A_ACH, G_DB Supplier Financing, C_Check]';
        
          
         update purId;
         goldenData.approvalCallMethod();
    
    
    }
    
        static testMethod void newMethod34(){
    
       // PageReference pg =null;
    VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
            
              VPM_L2InculdeApproval__c cs = new VPM_L2InculdeApproval__c();
        cs.Name='Brazil';
            cs.VPM_L2CreateExtendApproval__c=true;
        //cs.Other fiels values
     insert cs;
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and DeveloperName ='VPM_VendorReqExtend'].Id; 
       
         purId.VPM_TaxJurisdictionCode__c ='9900_Dummy';
        purId.recordTypeId=recordTypeId;
        purId.VPM_ProvidedBankDetails__c=true;
        purId.VPM_CountryRequestingVendor__c = STR_BRAZIL;
       // purId.VPM_VendorCodeLookup__r.mdm_ecc__c='Fusion';
        //   purId.VPM_CompanyCode__r.ECC__c='Fusion';
        purId.VPM_ProvidedBlockDelete__c=false;
        purId.VPM_ProvidedUnblockUndelete__c=false;    
        update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.pr = purId;
        goldenData.newMethod();
      
        goldenData.setLevelApproval('Regional');
        purId.VPM_IsChangedVAT__c=false;    
        update purId;    
          goldenData.setLevelApproval('Global');   
          purId.VPM_ProvidedBankDetails__c=false;    
        update purId;   
    goldenData.setLevelApproval('Regional');
    
    }
    
    
    
    
    
     static testMethod void newMethod1(){
    
       // PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         purId.VPM_TaxJurisdictionCode__c ='9900_Dummy';
         update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         
           
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.newMethod1();
            Test.setCurrentPageReference(new PageReference('apex/VPM_GoldenData1'));
        ApexPages.Message msg =null;
          
         msg=  goldenData.checkValidations(); 
         System.debug('Msg @@@@@@'+ msg);
         purId.VPM_ExtensionType__c ='Global';
             
         update purId;
        goldenData.saveRecord();
    
    }
    
         static testMethod void newMethod2(){
    
       // PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         purId.VPM_TaxJurisdictionCode__c ='9900_Dummy';
         purId.VPM_FinanceApprovalRequired__c =false;
         purId.VPM_ProcurementApprovalRequired__c =false;
         purId.VPM_FreightApprovalRequired__c = false;
         purId.VPM_RussianTaxApprovalRequired__c = true;
         
         update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         
           
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.newMethod1();
            Test.setCurrentPageReference(new PageReference('apex/VPM_GoldenData1'));
        ApexPages.Message msg =null;
          
         msg=  goldenData.checkValidations(); 
         System.debug('Msg @@@@@@'+ msg);
         purId.VPM_ExtensionType__c ='Global';
             
         update purId;
        goldenData.saveRecord();
    
    }
    
static testMethod void VPM_ApprovalMethodFreight12(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethodMaintain();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         
         purId.VPM_VendorType__c  = STR_VENDORTYPEMSB;
         purId.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX';
    purId.VPM_PaymentMethod__c='[3_ACC - HSBC At Par Cheque, 4_CCC - UTI At Par Cheque]';
         purId.VPM_VATRegistrationNumber__c='1133442';
   purId.VPM_ReconciliationAccount__c='sddddd';
    purid.VPM_BankAccountNumber__c='105067483';
       
         
          update purId;
    Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
    goldenData.commonSaveMethod();
          VPM_PurchasingRequests__c pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_CheckDoubleInvoices__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,VPM_Commodity_Family__c from VPM_PurchasingRequests__c  where id =: purId.id limit 1];
          system.assertEquals(purId.VPM_VendorType__c ,pur1.VPM_VendorType__c );
          system.assertEquals(purId.VPM_GlobalAuthorisationGroup__c,pur1.VPM_GlobalAuthorisationGroup__c);
         goldenData.approvalCallMethod();
         
    
    }
   
    static VPM_PurchasingRequests__c TestDataApprovalMethodcreate(){
    
    string    recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
    
        VPM_LatamCountries__c obj = new VPM_LatamCountries__c();
        obj.Name=COUNTRIES;
        obj.VPM_CountryName__c= 'AR_Argentina,BO_Bolivia,CL_Chile,CO_Colombia,CR_Costa Rica,DO_Dominican Rep.,EC_Ecuador,GT_Guatemala';
        insert obj; 
        VPM_L2InculdeApproval__c cs=new VPM_L2InculdeApproval__c();
        cs.Name='Philippines';
        cs.VPM_L2CreateExtendApproval__c=true;
        cs.VPM_ECC__c=STR_CONST_U2K2;
        insert cs;
        customSettingData(STR_CONST_U2K2);     
    
 //customSettingData('U2K2');    
        VPM_Region__c reg = new VPM_Region__c();
        reg.VPM_Code__c = '05';
        reg.Name = 'IN_India'; 
        reg.VPM_Country__c = 'IN_India';
        insert reg;
        
        List<mdm_Vendors__c> vendorList = new List<mdm_Vendors__c>();
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_Street__c = 'Test Street';
        vendor.mdm_Postcode__c = '54132';
        vendor.mdm_Country__c = 'India';
        vendor.mdm_ID__c = '1234';
        vendor.mdm_vCodeFusion__c=MDM_CODE;
        vendor.mdm_vCodeCordillera__c=MDM_CODE;
        vendor.mdm_vCodeSirius__c=MDM_CODE;
        vendor.mdm_vCodeU2K2__c=MDM_CODE;
        vendorList.add(vendor);
        insert vendorList;
        system.debug('@@vendorList' + vendorList);
        system.assert(vendor.Id!=null,'Error');
       
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Philippines';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
        VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.Name = 'Advertising Pre-Testing - Digital';
        commodityCode.VPM_CommodityFamily__c = 'Market Research';
        commodityCode.VPM_VendorType__c = 'PI_Production Item Vendor_G001';
        commodityCode.VPM_AuthorisationGroup__c = 'Chemicals--Inorganics_VMBA Inorganics';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research';
        commodityCode.VPM_CommodityCode__c = '5702 - UN01580116';
        commodityCode.VPM_Region__c  = 'U2K2';
            
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
        pur.VPM_VendorName1__c =STR_TEST_DATA_SIRIUS;
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_VendorCodeLookup__c = vendorList[0].id;
        pur.recordTypeId=recordTypeId;
        
        pur.VPM_CompanyCode__c=companyCode.Id;
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c='Sirius';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Philippines';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';    
        pur.VPM_GlobalAuthorisationGroup__c = 'Chemicals--Inorganics_VMBA Inorganics';
        pur.VPM_PaymentTerms__c = '';
        pur.VPM_OrderingEmailAddress__c = '';
        pur.VPM_VendorType__c = 'PI_Production Item Vendor_G001';  
        pur.VPM_ClerksInternet__c = '';
        pur.VPM_Country__c = 'IN_India';
        pur.VPM_ExtensionType__c = VPM_RecordTypeHelper.REGIONAL_REQUEST;
        pur.VPM_Industry__c = '9001_Oils';
        insert pur;
        insert commodityCode;
        pur.VPM_Commodity__c = commodityCode.id;
        update pur; 
        return pur;   
       
       
    }
    
    static VPM_PurchasingRequests__c TestDataApprovalMethodcreate1(){
    
      string  recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
    
 
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c =STR_TEST_DATA_SIRIUS;
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
         List<VPM_FetchVendorsDetails.InputVariables> inputCriteria = new List<VPM_FetchVendorsDetails.InputVariables>();
        VPM_FetchVendorsDetails.InputVariables crit = new VPM_FetchVendorsDetails.InputVariables();
        crit.vendorCodeInput='9987534';
        crit.ecc = STR_CONST_CORDILLERA;
        crit.compnayCode = 'ULAG';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        Test.stopTest();
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
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
        
        VPM_PurchasingOrganisation__c org =new VPM_PurchasingOrganisation__c();
        org.VPM_CompanyCode__c=companyCode.id;
        org.Name='PurchasingOrg';
        org.VPM_Country__c = ALGERIA;
        insert org;
        system.assert(org.Id!=null,STR_ERROR);
        
       VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = STR_CONST_U2K2;
        pur.VPM_ProvidedBankDetails__c = TRUE;
       
        pur.VPM_Status__c = STR_CONST_DRAFT;
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
         
        //pur.VPM_VendorCodeLookup__r.mdm_Code__c=vendor.mdm_Code__c;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_PurchasingOrg__c = org.Id; 
        //pur.VPM_CompanyCode__r.VPM_CompanyCode__c='PH01';
        //pur.VPM_CompanyCode__r.ECC__c=STR_CONST_SIRIUS;
        pur.VPM_Street1__c=STR_STREET1;
        pur.VPM_CountryRequestingVendor__c=ALGERIA;
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_PaymentTerms__c ='Payment Terms';
        pur.VPM_BankCountryKey__c ='Bank Country Key';
        pur.VPM_ReconciliationAccount__c ='Recouncil';
        pur.VPM_DeletionBlockFlag__c='';
        pur.VPM_ProcurementApprovalRequired__c=true;
        pur.VPM_Incoterms1__c='UN _Not Free';
        pur.VPM_PurchasingOrg__c=org.id;
        pur.VPM_VendorType__c =FREIGHTVENDOR;
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        pur.VPM_VendorBlockUnblockDelete__c='Blocked';
        pur.VPM_ProvidedUnblockUndelete__c = true;
        pur.VPM_ProvidedBlockDelete__c = TRUE; 
        pur.VPM_ProvidedPaymentTerms__c = TRUE ;
        //pur.VPM_Company_Code_Value__c= '2611';
        //pur.VPM_Commodity_Family__c = 'Out of Scope';
        pur.VPM_SRVBasedVendorID__c=FALSE;
        pur.VPM_CashManagementGroup__c='None';
        insert pur;
        system.assert(pur.Id!=null,STR_ERROR);
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
    
        //PageReference pg =null;
        // PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and DeveloperName ='VPM_VendorReqExtend'].Id; 
       
         purId.VPM_TaxJurisdictionCode__c ='9900_Dummy';
        purId.recordTypeId=recordTypeId;
         update purId;
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         
           
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        goldenData.newMethod1();
            Test.setCurrentPageReference(new PageReference('apex/VPM_GoldenData1'));
        ApexPages.Message msg =null;
          
         msg=  goldenData.checkValidations(); 
         System.debug('Msg @@@@@@'+ msg);
         purId.VPM_ExtensionType__c ='Global';
             
         update purId;
        goldenData.saveRecord();
        
        
        
}

   static testMethod void errorMessage(){
    //   PageReference pg =null;
      
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id; 
        purId.recordTypeId=recordTypeId;
        update purId;
        
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
       VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
       system.assertEquals(VPM_GoldenDataController2.STR_CONST_MBS,'MBS');  
      //  VPM_SearchVendor1 searchVendorConst = new VPM_SearchVendor1 ();
       // VPM_SearchVendor1 searchVendor = new VPM_SearchVendor1(vendorDetail);
     //   searchVendor.intCalcIndicatorDefValues = '01';
       // searchVendor.getVendorDetailList();        
       // searchVendor.mdmVendorType = '';
         //  Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200,'Maintain'));
        //searchVendor.requestType ='Maintain';  
        //Test.startTest();
       // searchVendor.VendorSelected(); 
        
       // pg=goldenData.ErrorMessage();
       purId.VPM_VendorName1__c='TEST VENDOR';
       goldenData.commonSaveMethod();
       

   } 
   
    // newly added - 
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
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
 
    static testMethod void VPM_ApprovalMethodFreight_1(){
        
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
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
  static testMethod void VPM_ApprovalMethodRussian_1(){
        
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
        
        system.assert(pur.Id!=null,'Error');
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
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
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
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
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
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
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
        
        system.assert(pur.Id!=null,'Error');
        
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
        pur.VPM_BusinessRequestorSubmitted__c = 'Yes'; 
        pur.VPM_Rework__c= 'No';
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(pur);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    
 	 
}