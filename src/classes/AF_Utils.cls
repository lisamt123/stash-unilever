public class AF_Utils
{
    //help methods
    public static Id getRecordId(string pRecordType)
    {
        return Schema.SObjectType.AF_Brand_Estimate__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();   
    }
    
    //help methods
    public static Id getEntityRecordId(string pRecordType)
    {
        return Schema.SObjectType.AF_Entity__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();   
    }
    
    public static Id getBonusResRecordId(string pRecordType)
    {
        return Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();   
    }
    
    public static Boolean isAgencyUser(String userId) {
        
        Boolean valueToReturn = false;
        Integer usercnt = [SELECT COUNT() FROM User WHERE Id = :userId AND AF_Agency_Fees_User_Type__c='Agency'];
        valueToReturn = usercnt == 1 ? true : false;
        
        return valueToReturn;
    }
    
    // Pass the resource name
    public static String getResourceURL(String resourceName){

        string paramToReturn;
        // Fetching the resource
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];

        // Checking if the result is returned or not
        if(resourceList.size() == 1){
            paramToReturn = String.valueOf(resourceList[0].SystemModStamp.getTime()); 
        }
        
        return paramToReturn;            
    }
    
    public static Boolean isValidID(string pId)
    {
        if(pId.length() == 15)
        {
            return true;
        }
        else
        {
            return false;
        }

    }
    
    public static List<sObject> ConvertMapValuesToList(Map<Id,sObject> sObjectMap)
    {
        List<sObject> sObjectList = new List<sObject>(); 
        for(sObject sobjectItem : sObjectMap.values())
        {
            sObjectList.add(sobjectItem);
        }
        return sObjectList;
    }
    
    public static string EntityNameValue(string entityId)
    {
        string result = null;
        AF_Entity__c entity = [select id, Name from AF_Entity__c where Id = : entityId];
        if(entity != null)
        {
            result = entity.Name;
        }
        return result;              
    }    
}