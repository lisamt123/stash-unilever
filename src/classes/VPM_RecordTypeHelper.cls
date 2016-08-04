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
    
        static final string  GenricRecordType = 'Vendor Request';
        static final string  CreateRecordType = 'Vendor Request (Create)';
        static final string  MaintainRecordType = 'Vendor Request (Maintain)';
        static final string  ExtendRecordType = 'Vendor Request (Extend)';
    
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
        if(recordTypeName.contains('Create')){
            launchScreenVariable = 'Create';
        }else if(recordTypeName.contains('Maintain')) {
            launchScreenVariable = 'Maintain';
        }else if(recordTypeName.contains('Extend')){
            launchScreenVariable = 'Extend';
        }else {
            launchScreenVariable = 'Generic';
        }
        return launchScreenVariable;
    }
    public static id getRecordTypeNameById(string recortTypeValue) {
        Id vendorRecordtypeId;
        string recordtypeName;
        string  VendorReqRecordType;
        if(recortTypeValue.contains('Generic')) {
            VendorReqRecordType = GenricRecordType;
        }else if(recortTypeValue.contains('Maintain')) {
            VendorReqRecordType = MaintainRecordType;
        }else if(recortTypeValue.contains('Extend')) {
            VendorReqRecordType = ExtendRecordType;
        }else if(recortTypeValue.contains('Create')) {
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