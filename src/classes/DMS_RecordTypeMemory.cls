public class DMS_RecordTypeMemory {
    private static Map<String, Map<String, Id>> fRecTypes = new Map<String, Map<String, Id>>();
    private static Map<String, Map<String, Id>> fRecTypesNames = new Map<String, Map<String, Id>>();
    //get values for API Name(DeveloperName)
    static {
        List<RecordType> lList = [select id, SobjectType, DeveloperName from RecordType];
        
        for(RecordType lRec : lList) {
            Map<String, Id> lObjMap = fRecTypes.get(lRec.SobjectType);
            
            if(lObjMap == null) {
                lObjMap = new Map<String, Id>();
                fRecTypes.put(lRec.SobjectType, lObjMap);
            }
            
            lObjMap.put(lRec.DeveloperName, lRec.id);
        }
    }
    
    //get values for name
    static {
        List<RecordType> recList = [select id, SobjectType, name from RecordType];
        
        for(RecordType rec : recList) {
            Map<String, Id> nameIdRecMap = fRecTypesNames.get(rec.SobjectType);
            
            if(nameIdRecMap == null) {
                nameIdRecMap = new Map<String, Id>();
                fRecTypesNames.put(rec.SobjectType, nameIdRecMap);
            }
            
            nameIdRecMap.put(rec.name, rec.id);
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
    
    //Return one map of key id and value names
    public static Map<id,String> getRecTypeNames(String aObj){
        Map<String,id> lObjMap = fRecTypesNames.get(aObj);
        Map<id,String> idNameMap = new Map<id,String>();         
        if(lObjMap!=null){
            for(String name : lObjMap.keySet()){             
                idNameMap.put(lObjMap.get(name),name);             
            }
        }        
        return idNameMap;
        
    }

}