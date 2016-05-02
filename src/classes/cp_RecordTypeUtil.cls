public class cp_RecordTypeUtil {
	/**
	   utility class to retrive record type object
	**/
	public static ID getRecordTypeId(final String typeName, final String recordTypeName) {
		if (sObjectMap.isEmpty()) {
			sObjectMap = Schema.getGlobalDescribe();
		}
        if (!recordTypeMap.containsKey(typeName)) {
            Schema.SObjectType targetType = sObjectMap.get(typeName);
            if (targetType != null) {
                Map<String, Schema.RecordTypeInfo> typeMap = targetType.getDescribe().getRecordTypeInfosByName();
                recordTypeMap.put(typeName,typeMap);
            }
        }
        Schema.RecordTypeInfo recordTypeInfo = recordTypeMap.get(typeName).get(recordTypeName);
        return (recordTypeInfo != null) ? 
                recordTypeInfo.getRecordTypeId():
                null;
    }
    
    private static Map<String, Schema.SObjectType> sObjectMap = new Map<String, Schema.SObjectType>();
    private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypeMap = new Map<String, Map<String, Schema.RecordTypeInfo>>();

}