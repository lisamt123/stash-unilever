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
    public PageReference pg {get;set;}
	 
    
    static VPM_PurchasingRequests__c TestData(){
    
        try
        {
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
    
        VendorRequest__c obj = new VendorRequest__c();
        obj.Name=COUNTRIES;
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        insert obj;
    
    
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
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name='Countries';
        insert obj;
    
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
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name='Countries';
        insert obj;
 
    
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
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name='Countries';
        insert obj;
    
 
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c ='Brazil';
        vendor.mdm_Name1__c ='Test Cordillera';
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = STR_COMPANYCODE;
        companyCode.ECC__c = STR_CONST_CORDILLERA;
        companyCode.VPM_Country__c ='Brazil';
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
        pur.VPM_CountryRequestingVendor__c='Brazil';
        pur.VPM_VendorPhone__c=STR_VENDORPHONENO;
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c =STR_ZIPCODE;
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
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name='Countries';
        insert obj;
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c ='Brazil';
        vendor.mdm_Name1__c ='Test Sirius';
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
        companyCode.VPM_Country__c ='Brazil';
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
        pur.VPM_CountryRequestingVendor__c='Brazil';
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
        obj.VPM_CountryName__c=VPM_COUNTRYNAME;
        obj.Name='Countries';
        insert obj;
    
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c =ALGERIA;
        vendor.mdm_Name1__c ='Test Sirius';
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
        
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        pur.VPM_VendorType__c =FREIGHTVENDOR;
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
        // Test.startTest();
         Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(404));
         goldenData.approvalCallMethod();
        // Test.stopTest();
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id;
         purId.recordTypeId =recordTypeId;
         update purId;
        Test.startTest();
         goldenData.approvalCallMethod();
        VPM_PurchasingRequests__c resultVendor = [SELECT Id, VPM_RussianTaxApprovalRequired__c FROM VPM_PurchasingRequests__c WHERE Id =: purId.id];
         System.debug('VPM_ApprovalMethodRussian Case  ~~~~~~~~'+ resultVendor);
            System.assertEquals(false, resultVendor.VPM_RussianTaxApprovalRequired__c);
           Test.stopTest();
    
    }
   
  static testMethod void VPM_ApprovalMethodFreight(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = FREIGHTVENDOR;
         
        
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
         
         purId.VPM_VendorType__c  = STR_VENDORTYPEMSB;
          
        
          
         update purId;
         goldenData.approvalCallMethod();
         
    
    } 
    
    static testMethod void SaveRecord(){
    
        PageReference pg =null;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.saveRecord();
    
    
    }
    
    static testMethod void backToFlow(){
    
        PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.backToFlow();
    
    
    }

    static testMethod void backToGoldenData1(){
    
        PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestData();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.backToGoldenData1();
    
    
    }
    
    
      static testMethod void Search(){
    
        PageReference pg =null;
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
        crit.ecc = STR_CONST_CORDILLERA;
        crit.compnayCode = 'ULAG';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_FetchVendorsDetails.getVendorDetails(inputCriteria);
      Test.stopTest();
  } */
    
      static testMethod void approvalMaintain1UnBlock(){
    
        PageReference pg =null;
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
    
        PageReference pg =null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.newMethod();
    
    
    }
    
    
    
    
     static testMethod void newMethod1(){
    
        PageReference pg=null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         
           
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.newMethod1();
            Test.setCurrentPageReference(new PageReference('apex/VPM_GoldenData1'));
         ApexPages.Message msg =null;
          
          msg = goldenData.checkValidations(); 
    
    
    }
    
static testMethod void VPM_ApprovalMethodFreight12(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethodMaintain();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         
         purId.VPM_VendorType__c  = STR_VENDORTYPEMSB;
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
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = MDM_ID;
        insert vendor;
        system.assert(vendor.Id!=null,STR_ERROR);
        
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
        pur.VPM_DeletionBlockFlag__c ='delete';
        pur.VPM_Incoterms1__c='UN _Not Free';
        pur.VPM_PurchasingOrg__c=org.id;
        pur.VPM_VendorType__c =FREIGHTVENDOR;
        pur.VPM_Country__c =VPM_COUNTRYNAME;
        //pur.VPM_Commodity_Family__c = 'Out of Scope';
        pur.VPM_SRVBasedVendorID__c=FALSE;
        pur.VPM_CashManagementGroup__c='None';
        insert pur;
        system.assert(pur.Id!=null,STR_ERROR);
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
        vendor.mdm_Code__c = MDM_CODE;
        vendor.mdm_City__c = MDM_CITY;
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
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
    
      PageReference pg =null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
        pg=goldenData.saveRecord();
        
        
        
}

   static testMethod void errorMessage(){
       PageReference pg =null;
        VPM_PurchasingRequests__c purId = TestDataApprovalMethodcreate();
        ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
       // pg=goldenData.ErrorMessage();

   
   
   } 
   
  
}