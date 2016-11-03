/********************************************************************
  Created By   : Piyush Mathur
  Created Date : 06th June 2016
  Last Modify  : 
  Description  : This class will retrieve recordtype name, id without query
  MetaData     : Sobject
********************************************************************/
public class VPM_RecordTypeHelper {
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
    
    public static string getRecordTypes(string obj, id vendorReqRecordTypeID) {
        string recordtypeName;
        obj = 'VPM_PurchasingRequests__c';  
        Map<Id, string> recTypeNameWithIdMap = new Map<Id, string>();
        if(obj!= null) {
            for(Schema.RecordTypeInfo recInfo : Schema.getGlobalDescribe().get(obj).getDescribe().getRecordTypeInfosByName().values()){
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
        string launchScreenVariable;
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
        Id vendorRecordtypeId;
        string recordtypeName;
        string  VendorReqRecordType;
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
        
        return vendorRecordtypeId;
    }
    
}