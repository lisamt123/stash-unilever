/********************************************************************
  Created By   : Piyush Mathur
  Created Date : 06th June 2016
  Last Modify  : 
  Description  : This class will retrieve recordtype name, id without query
  MetaData     : Sobject
********************************************************************/
public with sharing class VPM_RecordTypeHelper {
    public static final string VendorReqGenericRecordType = 'Vendor Request';
    public static final string VendorReqCreateRecordType = 'Vendor Request (Create)';
    public static final string VendorReqMaintainRecordType = 'Vendor Request (Maintain)';
    public static final string VendorReqExtendRecordType = 'Vendor Request (Extend)';
    
    public static final string  GenricRecordType = 'Vendor Request';
    public static final string  CreateRecordType = 'Vendor Request (Create)';
    public static final string  MaintainRecordType = 'Vendor Request (Maintain)';
    public static final string  ExtendRecordType = 'Vendor Request (Extend)';
    
    public static final string CREATE = 'Create';
    public static final string EXTEND = 'Extend';
    public static final string MAINTAIN = 'Maintain';
    public static final string MAINTAIN_2 = 'Maintain2';
    public static final string GENERIC = 'Generic';
    
    public static final string REGIONAL_REQUEST = 'Regional';
    public static final string GLOBAL_REQUEST = 'Global';
    
    public static final string ECC_U2K2 = 'U2K2';
    public static final string ECC_FUSION = 'Fusion';
    public static final string ECC_CORDILLERA = 'Cordillera';
    public static final string ECC_SIRIUS = 'Sirius';
    public static final string STATUS_MDM = 'MDM';
    public static final string STATUS_REVIEW = 'Review';
    
    public static final string VENDOR_TYPE_PI = 'PI_Production Item Vendor_G001';
    public static final string VENDOR_TYPE_ZVN1 = 'VN_Main Vendor (VN)_ZVN1';
    public static final string VENDOR_TYPE_FRGT = 'FRGT_Freight Vendor_G001';
    public static final string VENDOR_TYPE_SCS_SUPPLY = 'SCS_Supply Chain Services_G001';
    public static final string GLOBAL_AUTH_3PM = '3PM--3Pm';
    public static final string GLOBAL_AUTH_UNICA = 'UNICA'; 
    public static final string GLOBAL_AUTH_LAKME = 'Lakme'; 
    
    public static final string PURCH_ORG = '2050'; 
    
    public static final string PAYMENT_TERM_30DK = '30DK_Within 30 days Due net (30NET)';
    public static final string PAYMENT_TERM_90DK = '90DK_Within 90 days Due net (90NET)'; 
    public static final string PAYMENT_TERM_P030 = 'P030_Within 30 days Due net (30NET)'; 
    public static final string PAYMENT_TERM_S090 = 'S090_Within 90 days Due net (90NET)'; 
    public static final string PAYMENT_TERM_P090 = 'P090_Within 90 days Due net (90NET)';
    
    public static final string YES = 'Yes';
    public static final string NO = 'No';
    
    public static final string BLOCKED = 'Blocked';
    public static final string DELETED = 'Deleted';
    public static final string UN_BLOCK = 'Unblock';
    public static final string UN_DELETE = 'Undelete';
    public static final string STATUS_MDM_REV_UNBLOCK_UNDEL  = 'MDM Ops Review - Unblock - Undelete';
    public static final string STATUS_MDM_REV_BLOCK_DEL  = 'MDM Ops Review - Block - Delete';
    
    public static final string DETAIL_OPTION = 'DetailOption';
    public static final string UNIUQUEID = 'UniqueId'; 
    public static final string SHOW_LABEL = 'showLabel';
    public static final string LABEL_TEXT = 'labelText';
    public static final string REQUEST_TYPE = 'requestType';  
    public static final string NOT_LISTED = 'notlisted'; 
    public static final string SEARCH_VENDOR = 'searchVendor'; 
    public static final string VENDOR_LIST = 'vendorList'; 
    public static final string RE_WORK = 'Re-Work';
    public static final string REJECTED = 'Rejected';
    public static final string APPROVALPENDING= 'Approval Pending';
    public static final string ABORTED = 'Aborted';
    public static final string REQUEST_COMPLETED = 'Request Completed';
    public static final string CONST_LITERAL1 = '\\#';
    public static final string VENDOR_COUNTRY = 'BR_Brazil';
      Public static final string MDM_REVIEW='MDM Ops Review';
    public static final string MDM_RE_WROK='MDM Ops Review Requested Re-Work';
    //public static final string CONST_LITERAL2 = '\'%';
    
    public class OptionWrapper{
        public String DetailOption{get;set;}
        public String UniqueId{get;set;}
        public boolean showLabel{get;set;}
        public String labelText{get;set;}        
    }
    
    public static string getRecordTypes(string obj, id vendorReqRecordTypeID) {
        string recordtypeName = '';
        string objValue = 'VPM_PurchasingRequests__c';  
        Map<Id, string> recTypeNameWithIdMap = new Map<Id, string>();
        if(objValue!= null) {
            for(Schema.RecordTypeInfo recInfo : Schema.getGlobalDescribe().get(objValue).getDescribe().getRecordTypeInfosByName().values()){
                system.debug('@@Map -' + recInfo);
                recTypeNameWithIdMap.put(recInfo.getRecordTypeId(),recInfo.getName());
            }
            
            for(id recId : recTypeNameWithIdMap.keySet()) {
                if(vendorReqRecordTypeID.equals(recId)) 
                    recordtypeName = recTypeNameWithIdMap.get(vendorReqRecordTypeID);
            }
            system.debug('@@Map -' + recordtypeName);
        }
        return recordtypeName;
    }
    
    public static string getLaunchScreenVariable(string obj, id vendorReqRecordTypeID) {
        string launchScreenVariable = '';
        string recordTypeName = getRecordTypes(obj, vendorReqRecordTypeID);
        if(recordTypeName.contains(CREATE)){
            launchScreenVariable = CREATE;
        }else if(recordTypeName.contains(MAINTAIN)) {
            launchScreenVariable = MAINTAIN;
        }else if(recordTypeName.contains(EXTEND)){
            launchScreenVariable = EXTEND;
        }else {
            launchScreenVariable = GENERIC;
        }
        return launchScreenVariable;
    }
    public static id getRecordTypeNameById(string recortTypeValue) {
        Id vendorRecordtypeId = null;     
        string VendorReqRecordType = '';
        system.debug('@@recortTypeValue' + recortTypeValue);
        if(recortTypeValue.contains(GENERIC)) {
            VendorReqRecordType = GenricRecordType;
        }else if(recortTypeValue.contains(MAINTAIN)) {
            VendorReqRecordType = MaintainRecordType;
        }else if(recortTypeValue.contains(EXTEND)) {
            VendorReqRecordType = ExtendRecordType;
        }else if(recortTypeValue.contains(CREATE)) {
            VendorReqRecordType = CreateRecordType;
        }
        else
             VendorReqRecordType = GenricRecordType;
        
        string obj = 'VPM_PurchasingRequests__c';  
        Map<string,Id> recTypeNameWithIdMap = new Map<string,Id>();
        if(obj!= null) {
            for(Schema.RecordTypeInfo recInfo : Schema.getGlobalDescribe().get(obj).getDescribe().getRecordTypeInfosByName().values()){
                system.debug('@@Map -' + recInfo);
                recTypeNameWithIdMap.put(recInfo.getName(),recInfo.getRecordTypeId());
            }          
            for(string recName : recTypeNameWithIdMap.keySet()) {
                if(VendorReqRecordType.equals(recName)) 
                    vendorRecordtypeId = recTypeNameWithIdMap.get(recName);
            }
        }
            system.debug('@@Map -' + vendorRecordtypeId);            
        system.debug('@@vendorRecordtypeId' + vendorRecordtypeId);
        return vendorRecordtypeId;
    }
    
    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : This method assing value to wrapper class for displaying purpose.
    Return Type  : List of Wrapper Class
    ********************************************************************/
    public static list<OptionWrapper> setmdmDetailOption(list<mdm_Vendors__c> mdmDeatilList) 
    {
      List<OptionWrapper> options = new List<OptionWrapper>(); 
      list<mdm_Vendors__c> mdmDeatilListNew = mdmDeatilList;  
      //string mdmDisplayName;
      system.debug('@@mdmDeatilList size' + mdmDeatilListNew.size());
      system.debug('@@Heap size Limit' + Limits.getHeapSize());  
        if(mdmDeatilListNew.size() > 1000  || Limits.getHeapSize() > 275000) {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Please filter the search creteria Too many Vendors retrieved'));
            //system.debug('@@ Please filter the search creteria');
            options = null;
            mdmDeatilListNew = null;  
        }else { 
            for(mdm_Vendors__c MDMDetail : mdmDeatilListNew)
            {
                OptionWrapper option = new OptionWrapper();
                option.DetailOption =MDMDetail.VPM_FullDetails__c;
                option.UniqueId = MDMDetail.id+ CONST_LITERAL1 + VPM_RecordTypeHelper.vendorCodeAssignmentSearchVen(MDMDetail.mdm_vCodeSirius__c,MDMDetail.mdm_vCodeCordillera__c,MDMDetail.mdm_vCodeU2K2__c,MDMDetail.mdm_vCodeFusion__c) 
                                    +CONST_LITERAL1 +MDMDetail.mdm_ecc__c;
                
                options.add(option); 
            }
            OptionWrapper option = new OptionWrapper();
            option.DetailOption =System.label.VPM_MyVendorisnotlisted;
            option.UniqueId = VPM_RecordTypeHelper.NOT_LISTED;
            options.add(option);                      
        }
      return options;

    }  
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 5th June 2016
    Last Modify  : 5th Oct 2016
    Description  : This method assign the vendor code selected on search vendor screen
    Return Type  : boolean
    ********************************************************************/
    public static string vendorCodeAssignmentSearchVen(string mdm_vCodeSirius, string mdm_vCodeCordillera ,string mdm_vCodeU2K2,string mdm_vCodeFusion) {
        string vendorCodeInput = '';
        If(string.isNotBlank(mdm_vCodeSirius)) {
            vendorCodeInput = mdm_vCodeSirius;
        }else If(string.isNotBlank(mdm_vCodeCordillera)) {
            vendorCodeInput = mdm_vCodeCordillera;
        } else If(string.isNotBlank(mdm_vCodeU2K2)) {
            vendorCodeInput = mdm_vCodeU2K2;
        }else If(string.isNotBlank(mdm_vCodeFusion)) {
            vendorCodeInput = mdm_vCodeFusion;
        }
        vendorCodeInput = (string.isNotBlank(vendorCodeInput) ? vendorCodeInput : '');
        return vendorCodeInput;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method convert the boolean to string
    Return Type  : string
    ********************************************************************/   
     public static string booleanToStringMethod(boolean blockedWeb, boolean deletedWeb) {       
         boolean blockedAdv = blockedWeb;    
         boolean deletedAdv = deletedWeb;
         System.debug('@@@@@@@ inside booleanToStringMethod ');
         string vendorBlockUnblockDelete = '';
         if(blockedAdv && deletedAdv) {
             vendorBlockUnblockDelete = VPM_RecordTypeHelper.BLOCKED + VPM_RecordTypeHelper.DELETED;
         }else if(!blockedAdv && deletedAdv) {
             vendorBlockUnblockDelete = VPM_RecordTypeHelper.DELETED;
         }else if(blockedAdv && !deletedAdv) {
             vendorBlockUnblockDelete = VPM_RecordTypeHelper.BLOCKED;
         }
         return vendorBlockUnblockDelete;         
     }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : This method pulls country picklist values from Schema
    Return Type  : List<Selectoption>
    ********************************************************************/
     public static List<SelectOption> getCountries()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       VPM_PurchasingRequests__c.VPM_Country__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    
    /********************************************************************  
    Created By   : Ajay Rawat
    Created Date : 01st Sept 2016
    Last Modify  : 03 Oct 2016
    Description  : This method pulls the region based on vendor country and code
    Return Type  : string
    ********************************************************************/
    public static string region(string regionWeb, string countryName ){    
        try{
            VPM_Region__c region =[select VPM_Code__c,Name,id, VPM_Country__c from VPM_Region__c where VPM_Code__c=: regionWeb and VPM_Country__c =: CountryName limit 1];
            if(region <> null)
            return region.id;
        else
            return null;
        }
        catch(Exception ex){return null;}            
        
    }
    
    /********************************************************************
    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Get details of selected vendor from SAP.
    Return Type  : VPM_FetchVendorsDetails.OutputVariables
    ********************************************************************/
    public static VPM_ECCVendorSearchServiceOutput fetchVendorDeatilSAPService(string mdmVendorCodeInput , string ecc, string vendorQuery1ECC, string vendorQuery1PurchOrgName , string companyCode) {
        system.debug('@@web service  is called');
        List<string> eccList = new List<string>();
        //string purchOrgName = vendorQuery1.VPM_PurchasingOrg__r.Name; // added recently for passing org 
        string purchOrgName = vendorQuery1PurchOrgName; // added recently for passing org 
        system.debug('@@purchOrgName' +purchOrgName);        
        VPM_FetchVendorsDetails.InputVariables ip = new VPM_FetchVendorsDetails.InputVariables();
        List<VPM_FetchVendorsDetails.InputVariables> ipList = new List<VPM_FetchVendorsDetails.InputVariables>();
        List<VPM_ECCVendorSearchServiceOutput> opList = new List<VPM_ECCVendorSearchServiceOutput>();
        system.debug('@@MDMVendorCodeInput' +MDMVendorCodeInput);
        if(string.isNotBlank(MDMVendorCodeInput)){
            ip.vendorCodeInput = MDMVendorCodeInput;
        }/*else {
            ip.vendorCodeInput = vendorCodeAssignment();            
        }*/
        
        if(string.isNotblank(ecc)) {
            eccList = ecc.split(',');            
        }
        //vendorQuery1.VPM_CompanyCode__r.ECC__c)
        
        if(!ecc.contains(vendorQuery1ECC)) {  
            ip.ecc = string.isNotBlank(eccList[0]) ? eccList[0] : vendorQuery1ECC;            
        }else { 
            ip.ecc = vendorQuery1ECC;
        }
        //ip.compnayCode = vendorQuery1.VPM_CompanyCode__r.VPM_CompanyCode__c;
        ip.compnayCode = companyCode;
        ip.purchasingOrg = purchOrgName; // added recently for passing org 
        ipList.add(ip);
        system.debug('@@ipList' + ipList);
        opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
        return opList[0];
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 03rd Oct  2016
    Last Modify  : 07th Oct 2016
    Description  : This method pulls default data from custom medata types
    Return Type  : List<Selectoption>
    ********************************************************************/
    public static List<SelectOption> paymentMathodMetaData(string countryCode, string countryName) { 
        List<SelectOption> options = new List<SelectOption>();
        List<VPM_PaymentMethods__mdt> metaValues = [select id, VPM_Country__c, VPM_CountryISO2__c, VPM_PaymentMethod__c from VPM_PaymentMethods__mdt where VPM_CountryISO2__c =: countryCode and VPM_Country__c =: countryName ];
        
        for(VPM_PaymentMethods__mdt mdtValue : metaValues) {
            options.add(new SelectOption(mdtValue.VPM_PaymentMethod__c, mdtValue.VPM_PaymentMethod__c)); 
        }
        system.debug('@@Options' + Options);
        
        
        return Options;
    } 
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method enables the button based on screen selected 
                   on Launch screen.
    Return Type  : boolean 
    ********************************************************************/
    public static string customMedataCallOrderCurrency(string ecc, string purchOrgName ,string countryName) {
        string orderCurrencyValue = '';
        system.debug('@@customMedataCallOrderCurrency is called');
        List<VPM_OrderCurrencyDefaultValues__mdt> orderCurrencyMdtList = [select id, VPM_OrderCurrency__c, VPM_VendorCountry__c from VPM_OrderCurrencyDefaultValues__mdt where VPM_VendorCountry__c =: countryName];
        if(orderCurrencyMdtList <> null && orderCurrencyMdtList.size() > 0) {
            if(ecc.equals(VPM_RecordTypeHelper.ECC_SIRIUS) && purchOrgName.equals(VPM_RecordTypeHelper.PURCH_ORG)) {
                orderCurrencyValue = '';
            }else { 
                orderCurrencyValue = orderCurrencyMdtList[0].VPM_OrderCurrency__c;
            }
        }
        system.debug('@@orderCurrencyMdtList ' + orderCurrencyMdtList);
        return orderCurrencyValue;
    }
    
    /******************************************************************** 
    Created By   : Piyush Mathur
    Created Date : 28th Sept 2016
    Last Modify  : 5th Oct 2016
    Description  : This method provides default value
    Return Type  : boolean
    ********************************************************************/
    public static string defaultPaymentTerm(string ecc, string isVendorSME) {
        string paymentTermValue = '';
        if(ecc.equals(VPM_RecordTypeHelper.ECC_FUSION)) {
            if(string.isNotBlank(isVendorSME) && isVendorSME.equals(VPM_RecordTypeHelper.YES)) {
                paymentTermValue = VPM_RecordTypeHelper.PAYMENT_TERM_30DK; 
                //termsOFPayment = VPM_RecordTypeHelper.PAYMENT_TERM_30DK;
            }else {
                paymentTermValue = VPM_RecordTypeHelper.PAYMENT_TERM_90DK; 
                //termsOFPayment = VPM_RecordTypeHelper.PAYMENT_TERM_90DK;
            }
        }else if(ecc.equals(VPM_RecordTypeHelper.ECC_U2K2)) {
            if(string.isNotBlank(isVendorSME) && isVendorSME.equals(VPM_RecordTypeHelper.YES)) {
                paymentTermValue = VPM_RecordTypeHelper.PAYMENT_TERM_P030; 
                //termsOFPayment = VPM_RecordTypeHelper.PAYMENT_TERM_P030;
            }else {
                paymentTermValue = VPM_RecordTypeHelper.PAYMENT_TERM_S090; 
                //termsOFPayment = VPM_RecordTypeHelper.PAYMENT_TERM_S090;
            }
        }else if(ecc.equals(VPM_RecordTypeHelper.ECC_CORDILLERA) || ecc.equals(VPM_RecordTypeHelper.ECC_SIRIUS)) {
            if(string.isNotBlank(isVendorSME) && isVendorSME.equals(VPM_RecordTypeHelper.YES)) {
                paymentTermValue = VPM_RecordTypeHelper.PAYMENT_TERM_P030; 
                //termsOFPayment = VPM_RecordTypeHelper.PAYMENT_TERM_P030;
            }else {
                paymentTermValue = VPM_RecordTypeHelper.PAYMENT_TERM_P090; 
                //termsOFPayment = VPM_RecordTypeHelper.PAYMENT_TERM_P090;
            }
        }
        return paymentTermValue;
    }
    
}