/*********************************************************************************************************
Name:  VPM_MaintainVendorFetchFieldDetails 
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  This class has been used to generate JSON payload for 'Create' web service callout.

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                                                Description
1.0 -    Ajay       09-10-2016    VPM_ConvertMaintainVendorFieldDetailsToJSON method    Added the Code for Json generation
2.0 -    Deepak     12-10-2016    VPM_ConvertMaintainVendorFieldDetailsToJSON method    Added the code to send only if updated field values else none.                   
**********************************************************************************************************/
public with sharing class VPM_MaintainVendorFetchFieldDetails {
 public static final string STR_CONST_COMMA='////#, ';
 public static final string STR_CONST_BOOLEANCOMMA=',';
 
 /*
    Author      : Deepak & Ajay
    Parameter   : VPM_PurchasingRequests__c  object id.
    Return Type : Json String.
    Description : Creating Json string adding mandatory data all time. For rest of fields only added if they are updated by user only.
 */
    public string VPM_ConvertMaintainVendorFieldDetailsToJSON(string VendorRequestId) {
        //String maintainVendorObjectJSON;
       
        //Integer reqNum = VPM_HttpUtil.generateRandomNumber();
        Map<String,String> mapUserDetails = VPM_HttpUtil.fetchUserDetails();
       // System.debug('-------Random Number------' + reqNum);
        List<VPM_PurchasingRequests__c> vendorList =[SELECT id,VPM_MDMBPMRequestorName__c,VPM_VendorCodeLookup__r.mdm_ID__c,VPM_fieldUpdated__c,VPM_SAPBPMRequestID__c,VPM_MDMBPMOriginatoEmail__c,VPM_CompanyCode__r.ECC__c,VPM_IsNaturalPerson__c,VPM_TaxType__c, VPM_MDMBPMRequestorPhone__c, VPM_MDMBPMRequestorEmail__c, VPM_CountryRequestingVendor__c,
                                                     VPM_MDMBPMRequestorDepartment__c, VPM_MDMBPMRequestDate__c, VPM_VendorCode__c, VPM_Comments__c, VPM_ECCSystem__c, VPM_VendorName1__c, 
                                                     VPM_VendorName2__c,VPM_Name3__c,VPM_Name4__c, VPM_SearchTerm_1__c,VPM_SearchTerm2__c, VPM_Street1__c,VPM_Street2__c,VPM_Street3__c,
                                                     VPM_Street4__c,VPM_HouseNumber__c,VPM_HouseNumSupplement__c,VPM_ZIPPostCode__c, VPM_Regions__r.VPM_Code__c,VPM_Country__c,VPM_City__c,VPM_District__c, 
                                                     VPM_IsVendorSME__c, VPM_IsVendorException__c, VPM_ExceptionType__c, VPM_POBox__c, VPM_POBoxPostCode__c, VPM_TaxNumber1__c, VPM_TaxNumber2__c, 
                                                     VPM_TaxNumber3__c, VPM_TaxNumber4__c, VPM_VATRegistrationNumber__c, VPM_TaxNumberType__c, VPM_TaxJurisdictionCode__c, 
                                                     VPM_TaxNumAtResponsibleTaxAuthority__c, VPM_CreditInfoNumber__c, VPM_CorporateGrp__c, VPM_IntLocationNumber1__c, VPM_IntLocationNumber2__c, 
                                                     VPM_ExtManufacturer__c, VPM_CheckDigit__c from VPM_PurchasingRequests__c where id =: VendorRequestId LIMIT 1];
        System.debug('@@VendorRequestId@@'+VendorRequestId);
        System.debug('@@vendorList@@'+vendorList.size());
         String mainJsonObject = '{ ';
 //boolean eccVal = false;
 mainJsonObject =mainJsonObject+ '////#RequestID////# : '+vendorList.get(0).VPM_SAPBPMRequestID__c+', ';
 mainJsonObject =mainJsonObject+ '////#RequestDate////# : ////#'+ String.ValueOf(System.today())+STR_CONST_COMMA;
   if(mapUserDetails != null && mapUserDetails.containsKey('name')) {
                if(String.isNotBlank(mapUserDetails.get('name'))) {
                    mainJsonObject =mainJsonObject+ '////#RequestorName////# : ////#'+mapUserDetails.get('name')+STR_CONST_COMMA;
                } else {
                     mainJsonObject =mainJsonObject+ '////#RequestorName////# : ////#Test////#,';
                }
            }
    if(mapUserDetails != null && mapUserDetails.containsKey('userPhone')) {
                if(String.isNotBlank(mapUserDetails.get('userPhone'))) {
                    mainJsonObject =mainJsonObject+ '////#RequestorPhone////# : ////#'+mapUserDetails.get('userPhone')+STR_CONST_COMMA;
                } else {
                    mainJsonObject =mainJsonObject+ '////#RequestorPhone////# : ////#01////#,';
                }
            }
     if(mapUserDetails != null && mapUserDetails.containsKey('userEmail')) {
                if(String.isNotBlank(mapUserDetails.get('userEmail'))) {
                    mainJsonObject =mainJsonObject+ '////#RequestorEmail////# : ////#'+mapUserDetails.get('userEmail')+STR_CONST_COMMA;
                    mainJsonObject =mainJsonObject+ '////#OriginatorEmail////# : ////#'+mapUserDetails.get('userEmail')+STR_CONST_COMMA; 
                } else {
                    mainJsonObject =mainJsonObject+ '////#RequestorEmail////# : ////#a@a.com////#,';
                    mainJsonObject =mainJsonObject+ '////#OriginatorEmail////# : ////#a@a.com////#,';
                }
            }
      if(mapUserDetails != null && mapUserDetails.containsKey('userDepartment')) {
                if(String.isNotBlank(mapUserDetails.get('userDepartment'))) {
                    mainJsonObject =mainJsonObject+ '////#RequestorDepartment////# : ////#'+mapUserDetails.get('userDepartment')+STR_CONST_COMMA;
                } else {
                    mainJsonObject =mainJsonObject+ '////#RequestorDepartment////# : ////#Default Role+////#,';
                }
            }           
 if(vendorList.get(0).VPM_CountryRequestingVendor__c != null)
    {
     Map<String, VPM_MDMCountry__c> VPM_MapCountryMap = VPM_MDMCountry__c.getAll();
      for(VPM_MDMCountry__c region : VPM_MapCountryMap.values()) {
                if(region.Country_Name__c == vendorList.get(0).VPM_CountryRequestingVendor__c){                   
       mainJsonObject =mainJsonObject+ '////#RequestorCountry////# : ////#'+region.Country_Code__c+STR_CONST_COMMA;
                }
          }  
     
    } 
  if(vendorList.get(0).VPM_VendorCodeLookup__r.mdm_ID__c != null)
  {
     mainJsonObject =mainJsonObject+ '////#VendorCode////# :'+Integer.valueOf(vendorList.get(0).VPM_VendorCodeLookup__r.mdm_ID__c)+', ';
     mainJsonObject =mainJsonObject+ '////#VendorNumber////# :////#'+vendorList.get(0).VPM_VendorCodeLookup__r.mdm_ID__c+STR_CONST_COMMA;
  }
  if(vendorList.get(0).VPM_VendorName1__c != null)
  {
      mainJsonObject =mainJsonObject+ '////#VendorName////# :////#'+vendorList.get(0).VPM_VendorName1__c+STR_CONST_COMMA;
      mainJsonObject =mainJsonObject+ '////#Name1////# :////#'+vendorList.get(0).VPM_VendorName1__c+STR_CONST_COMMA;
  }
  if(vendorList.get(0).VPM_Comments__c != null){
    mainJsonObject =mainJsonObject+ '////#BpmComments////# :////#'+vendorList.get(0).VPM_Comments__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_VendorName2__c != null  && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_VendorName2__c')){
    mainJsonObject =mainJsonObject+ '////#Name2////# :////#'+vendorList.get(0).VPM_VendorName2__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_Name3__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_Name3__c')){
    mainJsonObject =mainJsonObject+ '////#Name3////# :////#'+vendorList.get(0).VPM_Name3__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_Name4__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_Name4__c')){
    mainJsonObject =mainJsonObject+ '////#Name4////# :////#'+vendorList.get(0).VPM_Name4__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_SearchTerm_1__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_SearchTerm_1__c')){
    mainJsonObject =mainJsonObject+ '////#SearchTerm1////# :////#'+vendorList.get(0).VPM_SearchTerm_1__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_SearchTerm2__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_SearchTerm2__c')){
    mainJsonObject =mainJsonObject+ '////#SearchTerm2////# :////#'+vendorList.get(0).VPM_SearchTerm2__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_Street1__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street1__c')){
    mainJsonObject =mainJsonObject+ '////#Street////# :////#'+vendorList.get(0).VPM_Street1__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_Street2__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street2__c')){
    mainJsonObject =mainJsonObject+ '////#Street2////# :////#'+vendorList.get(0).VPM_Street2__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_Street3__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street3__c')){
    mainJsonObject =mainJsonObject+ '////#Street3////# :////#'+vendorList.get(0).VPM_Street3__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_Street4__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_Street4__c')){
    mainJsonObject =mainJsonObject+ '////#Street4////# :////#'+vendorList.get(0).VPM_Street4__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_HouseNumber__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_HouseNumber__c')){
    mainJsonObject =mainJsonObject+ '////#HouseNumber ////# :////#'+vendorList.get(0).VPM_HouseNumber__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_HouseNumSupplement__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_HouseNumSupplement__c')){
    mainJsonObject =mainJsonObject+ '////#HouseNumberSupplement ////# :////#'+vendorList.get(0).VPM_HouseNumSupplement__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_Regions__r.VPM_Code__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('vpm_regions__c')){
    mainJsonObject =mainJsonObject+ '////#Region////# :////#'+vendorList.get(0).VPM_Regions__r.VPM_Code__c+STR_CONST_COMMA;
  //}if(vendorList.get(0).VPM_Country__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_Country__c')){
    mainJsonObject =mainJsonObject+ '////#Country////# :////#'+VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_Country__c)+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_City__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_City__c')){
    mainJsonObject =mainJsonObject+ '////#City////# :////#'+vendorList.get(0).VPM_City__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_District__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_District__c')){
    mainJsonObject =mainJsonObject+ '////#District////# :////#'+vendorList.get(0).VPM_District__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_IsVendorSME__c'))
    {
   if((vendorList.get(0).VPM_IsVendorSME__c==null || vendorList.get(0).VPM_IsVendorSME__c=='No'))
            {
               mainJsonObject =mainJsonObject+'////#SmeIndicator////# :'+false+STR_CONST_BOOLEANCOMMA;
            }
            else
            {
               mainJsonObject =mainJsonObject+'////#SmeIndicator////# :'+true+STR_CONST_BOOLEANCOMMA;
            }
    }
    if(vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_IsVendorException__c'))
    {
    if(vendorList.get(0).VPM_IsVendorException__c==null || vendorList.get(0).VPM_IsVendorException__c=='No')
            {
                mainJsonObject =mainJsonObject+'////#ExceptionIndicator////# :'+false+STR_CONST_BOOLEANCOMMA;
            }
            else
            {
                 mainJsonObject =mainJsonObject+'////#ExceptionIndicator////# :'+true+STR_CONST_BOOLEANCOMMA;
            }
    }
  if(vendorList.get(0).VPM_POBox__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_POBox__c')){
    mainJsonObject =mainJsonObject+ '////#PoBox////# :////#'+vendorList.get(0).VPM_POBox__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_POBoxPostCode__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_POBoxPostCode__c')){
    mainJsonObject =mainJsonObject+ '////#PoPostalCode////# :////#'+vendorList.get(0).VPM_POBoxPostCode__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_TaxNumber1__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber1__c')){
    mainJsonObject =mainJsonObject+ '////#TaxNumber1////# :////#'+vendorList.get(0).VPM_TaxNumber1__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_TaxNumber2__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber2__c')){
    mainJsonObject =mainJsonObject+ '////#TaxNumber2////# :////#'+vendorList.get(0).VPM_TaxNumber2__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_TaxNumber3__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber3__c')){
    mainJsonObject =mainJsonObject+ '////#TaxNumber3////# :////#'+vendorList.get(0).VPM_TaxNumber3__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_TaxNumber4__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumber4__c')){
    mainJsonObject =mainJsonObject+ '////#TaxNumber4////# :////#'+vendorList.get(0).VPM_TaxNumber4__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_VATRegistrationNumber__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_VATRegistrationNumber__c')){
    mainJsonObject =mainJsonObject+ '////#VatRegistrationNumber////# :////#'+vendorList.get(0).VPM_VATRegistrationNumber__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_IsNaturalPerson__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_IsNaturalPerson__c')){
    mainJsonObject =mainJsonObject+ '////#IsNaturalPerson////# :'+vendorList.get(0).VPM_IsNaturalPerson__c+', ';
  }if(vendorList.get(0).VPM_TaxNumberType__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumberType__c')){
    mainJsonObject =mainJsonObject+ '////#TaxNumberType////# :////#'+VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_TaxNumberType__c)+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_TaxJurisdictionCode__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxJurisdictionCode__c')){
    mainJsonObject =mainJsonObject+ '////#TaxJurisdictionCode////# :////#'+VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_TaxJurisdictionCode__c)+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_TaxNumAtResponsibleTaxAuthority__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxNumAtResponsibleTaxAuthority__c')){
    mainJsonObject =mainJsonObject+ '////#taxNumAtResponsibleTaxAuthority////# :////#'+vendorList.get(0).VPM_TaxNumAtResponsibleTaxAuthority__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_CreditInfoNumber__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_CreditInfoNumber__c')){
    mainJsonObject =mainJsonObject+ '////#CreditInformationNumber////# :////#'+vendorList.get(0).VPM_CreditInfoNumber__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_CorporateGrp__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_CorporateGrp__c')){
    mainJsonObject =mainJsonObject+ '////#corporateGrp////# :////#'+vendorList.get(0).VPM_CorporateGrp__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_IntLocationNumber1__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_IntLocationNumber1__c')){
    mainJsonObject =mainJsonObject+ '////#InternationalLocationNumber1////# :////#'+vendorList.get(0).VPM_IntLocationNumber1__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_IntLocationNumber2__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_IntLocationNumber2__c')){
    mainJsonObject =mainJsonObject+ '////#InternationalLocationNumber2////# :////#'+vendorList.get(0).VPM_IntLocationNumber2__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_CheckDigit__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_CheckDigit__c')){
    mainJsonObject =mainJsonObject+ '////#CheckDigit////# :////#'+vendorList.get(0).VPM_CheckDigit__c+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_ExceptionType__c != null){
     mainJsonObject =mainJsonObject+ '////#ExceptionType////# :////#'+VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_ExceptionType__c)+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_TaxType__c != null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_TaxType__c')){
    mainJsonObject =mainJsonObject+ '////#TaxType////# :////#'+VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_TaxType__c)+STR_CONST_COMMA;
  }if(vendorList.get(0).VPM_ZIPPostcode__c!= null && vendorList.get(0).VPM_fieldUpdated__c.containsIgnoreCase('VPM_ZIPPostcode__c')){  
    mainJsonObject =mainJsonObject+ '////#PostalCode////# :////#'+VPM_HttpUtil.valueBeforeUnderscore(vendorList.get(0).VPM_ZIPPostcode__c)+STR_CONST_COMMA;
   //F String urlAttach = URL.getSalesforceBaseUrl().toExternalForm()+'/'+vendorList.get(0).Id;
   // mainJsonObject =mainJsonObject+ '////#AttachmentLink////# :////#'+urlAttach+STR_CONST_COMMA;
    }
    if(vendorList.get(0).VPM_CompanyCode__r.ECC__c == 'Fusion')
            {
               
               mainJsonObject =mainJsonObject+ '////#Fusion////# :'+True+STR_CONST_BOOLEANCOMMA;
                
            }
            else 
            {
              mainJsonObject =mainJsonObject+ '////#Fusion////# :'+False+STR_CONST_BOOLEANCOMMA;
            }
            if(vendorList.get(0).VPM_CompanyCode__r.ECC__c == 'U2K2')
            {
               mainJsonObject =mainJsonObject+ '////#U2K2////# :'+True+STR_CONST_BOOLEANCOMMA; 
            }
            else 
            {
              mainJsonObject =mainJsonObject+ '////#U2K2////# :'+False+STR_CONST_BOOLEANCOMMA;
            }
            if(vendorList.get(0).VPM_CompanyCode__r.ECC__c == 'Sirius')
            {
               mainJsonObject =mainJsonObject+ '////#Sirius////# :'+True+STR_CONST_BOOLEANCOMMA; 
            } 
            else 
            {
               mainJsonObject =mainJsonObject+ '////#Sirius////# :'+False+STR_CONST_BOOLEANCOMMA;
            }
            if(vendorList.get(0).VPM_CompanyCode__r.ECC__c == 'Cordillera')
            {
               mainJsonObject =mainJsonObject+ '////#Cordillera////# :'+True+''; 
            }
            else
            {
               mainJsonObject =mainJsonObject+ '////#Cordillera////# :'+False;
            }
    mainJsonObject =mainJsonObject+ '}'; 
    string addEscapeCharacter =  mainJsonObject.replace('\\','\\\\');
     addEscapeCharacter = addEscapeCharacter.replace('"','\\"');
     addEscapeCharacter = addEscapeCharacter.replace('////#','"');
    system.debug('hello='+mainJsonObject); 
    return addEscapeCharacter;
       
    }
}