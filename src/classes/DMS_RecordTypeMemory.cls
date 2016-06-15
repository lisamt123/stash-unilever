public with sharing class DMS_RecordTypeMemory {
    
    private static Map<String, Map<String, Id>> fRecTypes = new Map<String, Map<String, Id>>();
    private static Map<String, Map<String, Id>> fRecTypesNames = new Map<String, Map<String, Id>>();
    
    //get values for API Name(DeveloperName)
    static {
        List<RecordType> lList = [select id, SobjectType, DeveloperName from RecordType LIMIT 50000];
        
        for(RecordType lRec : lList) {
            Map<String, Id> lObjMap = fRecTypes.get(lRec.SobjectType);
            
            if(lObjMap == null) {
                lObjMap = new Map<String, Id>();
                fRecTypes.put(lRec.SobjectType, lObjMap);
            }
            
            lObjMap.put(lRec.DeveloperName, lRec.id);
        }
    }       
    
    public static id getRecType(String aObj, String aDevName) {
        Map<String, Id> lObjMap = fRecTypes.get(aObj);
        
        if(lObjMap == null) return null;
        
        return lObjMap.get(aDevName);
    }
    
    public static  Map<String, Id> getRectypeInfo(String aObj){
        Map<String, Id> lObjMap = fRecTypes.get(aObj);
        
        if(lObjMap == null) return null;                                                            
        return lObjMap;        
    }        
}