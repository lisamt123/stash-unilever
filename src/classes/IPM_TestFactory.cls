/******************************************************
* @author Cognizant (Sumit)
* @date 13/04/2015
* @description Generic Implementation of Test Data Creation factory.
*/

/*  
    This class would be running in without sharing mode. 
    The sharing and profile access has to be ensured by invoking class using System.RunAs
*/
@isTest
public without sharing class IPM_TestFactory {
    
    public static final String EMPTY_STRING = ''; 
    public static Integer REC_DML_COUNT = 5;

    public static Integer staticCounter = 1;
    public static Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
    
    private static Map<String, Schema.DescribeSObjectResult > globalSObjectDescribeCache = new Map<String, Schema.DescribeSObjectResult>();
    private static Map<String, Map<String, Schema.DescribeFieldResult>> globalFieldDescribeCache = new Map<String, Map<String, Schema.DescribeFieldResult>>();
    
    public static boolean FillAllFields = false;
    
    public static Profile userProfile = [Select Id from Profile where Name = 'System Administrator'];
    
    // Key: sobject.field
    // Value: first picklist value
    private static final Map<String, String> DefaultPicklistValue = new Map<String, String>();
    
    // Please ensure that fieldnames as well as objectNames are in LowerCase
    public static map<String, set<String>> ExcludedFields = new map<String, set<String>>{
        'All' => new set<String>{'ownerid', 'lastmodifiedbyid', 'createdbyid', 'lastmodifieddate', 'createddate','isdeleted'},
        'user' => new set<String>{'delegatedapproverid','callcenterid','contactid','delegatedapproverid','managerid','userroleid','federationidentifier','isportalenabled'}
    };
    
    
      
    /********************************************************************
    * @description Converts the passed Map to lower Case Keys.
    */ 
    
    private static void  transformMap(Map<String,Object> fieldToValueMap)
    {
        for(String fieldAPIName : fieldToValueMap.keySet())
        {
            String lowerCasefieldName = null;
            if(fieldAPIName !=null && !String.isEmpty(fieldAPIName) )
            {
                lowerCasefieldName = fieldAPIName.toLowerCase();
                if(lowerCasefieldName.compareTo(fieldAPIName) != 0)
                {   
                    fieldToValueMap.put(lowerCasefieldName,fieldToValueMap.get(fieldAPIName));
                    fieldToValueMap.remove(fieldAPIName);
                }
            }
        }
    }
    
    /********************************************************************
    * @description Converts the passed Map to lower Case Keys.
    */ 
    
    private static void transformMapBulk(Map<String,List<Object>> fieldToValueMap)
    {
        for(String fieldAPIName : fieldToValueMap.keySet())
        {
            String lowerCasefieldName = null;
            if(fieldAPIName !=null && !String.isEmpty(fieldAPIName) )
            {
                lowerCasefieldName = fieldAPIName.toLowerCase();
                List<Object> incomingValueList = fieldToValueMap.get(fieldAPIName);
                if(!fieldToValueMap.containsKey(lowerCasefieldName) )
                {
                    fieldToValueMap.put(lowerCasefieldName,incomingValueList);
                    fieldToValueMap.remove(fieldAPIName);
                }
                
            }
        }
    } 
    
   /**************************************************************************************
    * @description Used for creating Single Sobject Record.
    * @param sObjectAPIName - name of the SObject
    * @param fieldToValueMap - This would be used by developer to populate specific data in created SObject. 
             Please make sure in case you want to populate lookup, you need to pass this information here. 
             In case this is blank,  Factory would create a default Record with data.
    * @param isLite - specifies whether full copy of the sObject needs to be populated or not.
    */ 
    
    public static SObject createSObject(String sObjectAPIName,Map<String,Object> fieldToValueMap,Boolean isLite)
    {
        sObjectAPIName = sObjectAPIName.toLowerCase();
        transformMap(fieldToValueMap);
        sObject newSobj = null;
        // get SObject Describe and instantiate the sObject
        Schema.DescribeSObjectResult sObjectdescibeObj = retrieveObjectDescibe(sObjectAPIName);
        
        if(sObjectdescibeObj!=null)
        {
            Schema.SObjectType sObjectTypeObj = sObjectdescibeObj.getSobjectType();
            newSobj = sObjectTypeObj.newSObject();
        
            // get Field Descibe information 
            Map<String, Schema.DescribeFieldResult> fieldDescibeResultMap = retrieveFieldDescibe(sObjectAPIName);
        
            // get SObject Field Describe
            if(fieldToValueMap == null || fieldToValueMap.isEmpty())
            {
                createDefaultRecord(sObjectAPIName,newSobj,staticCounter,isLite);
                staticCounter++;
            }
            else
            {
                for(String fieldAPIName : fieldDescibeResultMap.keySet())
                {
                    Object defaultValue = staticCounter;
                    
                    Object providedFieldValue = null;
                    Schema.DescribeFieldResult fieldDescObj = fieldDescibeResultMap.get(fieldAPIName);
                    
                    if(fieldToValueMap.containsKey(fieldAPIName) && fieldToValueMap.get(fieldAPIName) !=null)
                    {
                        providedFieldValue = fieldToValueMap.get(fieldAPIName);  
                        setFieldValue(newSobj,fieldAPIName,fieldDescibeResultMap.get(fieldAPIName),defaultValue,providedFieldValue);
                    }
                    else 
                    {
                        if( !isLite || (isLite && !( fieldDescObj.isNillable() ) ) )
                        {
                            setFieldValue(newSobj,fieldAPIName,fieldDescibeResultMap.get(fieldAPIName),defaultValue,providedFieldValue);
                        }
                    }   
                }       
                staticCounter++;
                
            }
        }
        return newSobj;
    }
    
    /**************************************************************************************
    * @description - Used for creating Bulk Sobject Records.
    * @param sObjectAPIName - name of the SObject
    * @param fieldToValueMap - This would be used by developer to populate specific data in created SObject. 
             Please make sure in case you want to populate lookup, you need to pass this information here. 
             In case this is blank,  Factory would create a default Record with data.
    * @param isLite - specifies whether full copy of the sObject needs to be populated or not.
    */ 
    
    public static List<sObject> createSObjectList(String sObjectAPIName,Map<String,List<Object>> fieldToValueMap,Boolean isLite)
    {
         
        List<sObject> newSObjectList = new List<sObject>(); 
        sObjectAPIName = sObjectAPIName.toLowerCase();
        transformMapBulk(fieldToValueMap);
        // get SObject Describe and instantiate the sObject
        Schema.DescribeSObjectResult sObjectdescibeObj = retrieveObjectDescibe(sObjectAPIName);
        Schema.SObjectType sObjectTypeObj = sObjectdescibeObj.getSobjectType();
        
        // get Field Descibe information    
        Map<String, Schema.DescribeFieldResult> fieldDescibeResultMap = retrieveFieldDescibe(sObjectAPIName);
        if(!fieldToValueMap.isEmpty())
        {
            Integer maxCount = 0;       
            for(String fieldAPI : fieldToValueMap.keySet())
            {
                List<Object> listObject = fieldToValueMap.get(fieldAPI);
                if(listObject!=null)
                {
                    if(listObject.size() > maxCount)
                    {
                        maxCount = listObject.size(); 
                    }
                }
            }
            REC_DML_COUNT = maxCount;
        }
        for(Integer counter=1;counter<=REC_DML_COUNT;counter++)
        {
            sObject newSobj = sObjectTypeObj.newSObject();
            // get SObject Field Describe
            if(fieldToValueMap == null || fieldToValueMap.isEmpty())
            {
                createDefaultRecord(sObjectAPIName,newSobj,String.valueOf(staticCounter),isLite);    
            }
            else
            {       
                for(String fieldAPIName : fieldDescibeResultMap.keySet())
                {
                    Object defaultValue = staticCounter;
                    Object providedFieldValue = null;
                    
                    if(fieldToValueMap.containsKey(fieldAPIName) && fieldToValueMap.get(fieldAPIName) !=null)
                    {
                        List<Object> providedFieldValueList = fieldToValueMap.get(fieldAPIName);
                        try
                        {
                            if( providedFieldValueList.get(counter-1) !=null)
                            {
                                providedFieldValue = providedFieldValueList.get(counter-1);  
                            }
                        }
                        catch(ListException ex)
                        {
                            // Handling Array index out of bounds Exception
                            providedFieldValue = defaultValue;
                        } 
                        setFieldValue(newSobj,fieldAPIName,fieldDescibeResultMap.get(fieldAPIName),defaultValue,providedFieldValue);
                    }
                    else
                    {
                        Schema.DescribeFieldResult fieldDescObj = fieldDescibeResultMap.get(fieldAPIName);
                     
                        if( !isLite ||  (isLite &&  !( fieldDescObj.isNillable() ) ) )
                        { 
                            setFieldValue(newSobj,fieldAPIName,fieldDescibeResultMap.get(fieldAPIName),defaultValue,providedFieldValue); 
                        }
                    }   
                }
            }
            newSObjectList.add(newSobj);
            staticCounter ++;
        }
        
        return newSObjectList;
    }
    
    
    
     /**************************************************************************************
    * @description - Used for creating default Record.
    * @param sObjectAPIName - name of the SObject
    * @param newSobj - passed Sobject Record to be populated. 
    * @param counter - default Value to consider in case specific details are not provided .  
    * @param isLite - specifies whether full copy of the sObject needs to be populated or not.
    */ 
    
    private static void createDefaultRecord(String sObjectAPIName,sObject newSobj,Object counter,Boolean isLite)
    {
        Map<String, Schema.DescribeFieldResult> fieldDescibeResultMap = retrieveFieldDescibe(sObjectAPIName);
        for(String fieldAPIName : fieldDescibeResultMap.keySet())
        {
            
            if(!isLite || (isLite && !(fieldDescibeResultMap.get(fieldAPIName).isNillable()) ) )
            {
                setFieldValue(newSobj,fieldAPIName,fieldDescibeResultMap.get(fieldAPIName),counter,null);
            } 
        }   
    }
    
    
     /**************************************************************************************
    * @description - Validate the Object Descibe Cache and verfiy whether descibe Results already exist.
    * @param sObjectAPIName - name of the SObject
    */ 
    
    public static Schema.DescribeSObjectResult retrieveObjectDescibe(String sObjectAPIName)
    {
        if(globalSObjectDescribeCache.containsKey(sObjectAPIName))
        {
            return globalSObjectDescribeCache.get(sObjectAPIName);
        }
        else
        {
            if(globalDescribe.containsKey(sObjectAPIName))
            {
                Schema.SObjectType sObjectTypeObj = globalDescribe.get(sObjectAPIName);
                Schema.DescribeSObjectResult sObjectDescibeObj = sObjectTypeObj.getDescribe();
                globalSObjectDescribeCache.put(sObjectAPIName,sObjectDescibeObj);
                return sObjectDescibeObj;
            }
            
        }
          return null;
    }
    
     /**************************************************************************************
    * @description - Validate the Object Descibe Cache and verfiy whether descibe Results already exist. --- Bulk Invocation
    * @param sObjectAPIName - name of the SObject
    */ 

    public static Map<String, Schema.DescribeSObjectResult> retrieveObjectDescibeBulk(List<String> sObjectAPINameList)
    {
        Map<String, Schema.DescribeSObjectResult> tempSobjectDescibeObjMap = new Map<String, Schema.DescribeSObjectResult>();
        
        for(String sObjectAPIName : sObjectAPINameList)
        {
            Schema.DescribeSObjectResult sObjectDescObj = retrieveObjectDescibe(sObjectAPIName);
            tempSobjectDescibeObjMap.put(sObjectAPIName,sObjectDescObj);
        }
        
        return tempSobjectDescibeObjMap;
    }
    
    /**************************************************************************************
    * @description - Validate the field Descibe Cache and verfiy whether descibe Results already exist.
    * @param sObjectAPIName - name of the SObject
    */ 
    public static Map<String, Schema.DescribeFieldResult> retrieveFieldDescibe(String sObjectAPIName)
    {
        Schema.DescribeSObjectResult sObjectDescibeObj = retrieveObjectDescibe(sObjectAPIName);
        
        if(globalFieldDescribeCache.containsKey(sObjectAPIName))
        {   
            return globalFieldDescribeCache.get(sObjectAPIName);
        }
        else
        {
            Map<String, Schema.DescribeFieldResult> sObjectFieldDescMap = new Map<String, Schema.DescribeFieldResult>();  
            Map<String, Schema.SObjectField> fieldObjectMap =  sObjectDescibeObj.fields.getMap();
            for(String fieldAPIName : fieldObjectMap.keySet())
            {
                 Schema.SObjectField fieldObject = fieldObjectMap.get(fieldAPIName);
                 Schema.DescribeFieldResult fieldDescObj = fieldObject.getDescribe();
                 sObjectFieldDescMap.put(fieldAPIName,fieldDescObj);
            }
            
            if( sObjectFieldDescMap!=null && !sObjectFieldDescMap.isEmpty() )
            {
                globalFieldDescribeCache.put(sObjectAPIName,sObjectFieldDescMap);
            }   
            return sObjectFieldDescMap;
        }
    }
    
     /**************************************************************************************
    * @description - Validate the field Descibe Cache and verfiy whether descibe Results already exist. --- Bulk Invocation
    * @param sObjectAPIName - name of the SObject
    */ 
    
    public static Map<String,Map<String, Schema.DescribeFieldResult>> retrieveFieldDescibeBulk(List<String> sObjectAPINameList)
    {
        Map<String,Map<String, Schema.DescribeFieldResult>> fieldDescibeResultMap = new Map<String,Map<String, Schema.DescribeFieldResult>>();
        
        for(String sObjectAPIName : sObjectAPINameList)
        {
            Map<String, Schema.DescribeFieldResult> tempfieldDescibeObjMap =  retrieveFieldDescibe(sObjectAPIName);
            fieldDescibeResultMap.put(sObjectAPIName,tempfieldDescibeObjMap);
        }
        return fieldDescibeResultMap;   
    }
    
    private static String getDefaultPicklistValue(SObject obj, Schema.DescribeFieldResult fieldDescribe) {
        String key = obj.getSObjectType() + '.' + fieldDescribe.getName();
        
        if (!DefaultPicklistValue.containsKey(key)) {
            List<Schema.PicklistEntry> entries = fieldDescribe.getPicklistValues();
            String value = !entries.isEmpty() ? entries[0].getValue() : null;
            DefaultPicklistValue.put(key, value);
        }
        
        return DefaultPicklistValue.get(key);
    }
    
     /**************************************************************************************
    * @description - Validate if the passed field is from the list of excluded field Set.
    * @param obj - SObject Type
    * @param fieldDescribe -field Descibe of the passed field API Name 
    */ 
    
    private static boolean isExcludedField(Schema.DescribeFieldResult fieldDescribe) {
        String fieldAPIName = fieldDescribe.getName().toLowerCase();
        return ExcludedFields.get('All').contains(fieldAPIName);
    }
    
     
     /**************************************************************************************
    * @description - Validate if the passed field is from the list of excluded field Set.
    * @param obj - SObject Type
    * @param fieldDescribe -field Descibe of the passed field API Name 
    */ 
    
    
    private static boolean isExcludedField(SObject obj, Schema.DescribeFieldResult fieldDescribe) {
        String objectAPIName = obj.getSObjectType().getDescribe().getName();
        objectAPIName = objectAPIName.toLowerCase();
        set<String> fields = ExcludedFields.get(objectAPIName);
        String fieldAPIName = fieldDescribe.getName().toLowerCase();
        return fields == null ? false : fields.contains(fieldAPIName);
    }
    
     /**************************************************************************************
    * @description - Sets the value of the field based on various conditions liken Field Type, Default value etc.
    * @param obj - name of the SObject
    * @param fieldApiName - Api Name of the field which has to be populated with data
    * @param fieldDescObj - field Descibe of the passed field API Name
    * @param defaultValue - default Value for the field
    * @param providedFieldValue - user specified Value for the field.
    */ 
    
    private static void setFieldValue(SObject obj,String fieldApiName,Schema.DescribeFieldResult fieldDescObj,Object defaultValue,Object providedFieldValue) 
    {
        String fieldLabel = fieldDescObj.getLabel().replace(' ',EMPTY_STRING);
        Object finalValue = null;
        
        if (!isExcludedField(fieldDescObj) && !isExcludedField(obj, fieldDescObj) && !fieldDescObj.isAutoNumber() && !fieldDescObj.isCalculated() && 
	            ( 
	                fieldDescObj.isCustom() || 
	                ( !fieldDescObj.isCustom() && ( fieldDescObj.isCreateable() || fieldDescObj.isUpdateable() ) )  
	            )  
            )
        {
            if(providedFieldValue != null)
            {
                finalValue = providedFieldValue;
            }
            else if(fieldDescObj.getType() != Schema.DisplayType.Reference)
            {
                if (fieldDescObj.getType() == Schema.DisplayType.String)
                {
                    Integer maxfieldChar = fieldDescObj.getLength();
                    finalValue = fieldLabel+defaultValue;
                    
                    if( String.valueOf(finalValue).length() >  (maxfieldChar-1) )
                    {
                        finalValue = String.valueOf(finalValue).substring(0,maxfieldChar-1);
                    }
                    
                }
                else if(fieldDescObj.getType() == Schema.DisplayType.Email)
                {
                    finalValue = 'test'+fieldLabel+String.valueOf(defaultValue).normalizeSpace() + '@test.com';
                }
                else if(fieldDescObj.getType() == Schema.DisplayType.Boolean)
                {
                    finalValue = false;
                }
                else
                {
                    finalValue = defaultValue;
                }   
            }
            
            if (fieldDescObj.getType() == Schema.DisplayType.base64) {
                obj.put(fieldApiName, blob.valueOf(fieldLabel + finalValue ) );
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Boolean)  {
                
                obj.put(fieldApiName, Boolean.valueOf(finalValue));
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Combobox) 
            {
                obj.put(fieldApiName, String.valueOf(finalValue) );
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Currency) {
                obj.put(fieldApiName, Integer.ValueOf(finalValue) );
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Date) {
                obj.put(fieldApiName, Date.today());
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.DateTime) {
                obj.put(fieldApiName, DateTime.now());
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Double) {
                obj.put(fieldApiName, Double.valueOf(finalValue) );
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Email) 
            {
                obj.put(fieldApiName, finalValue);              
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Integer) 
            {
                obj.put(fieldApiName, Integer.valueOf(finalValue) );
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.MultiPicklist) 
            {
                if(finalValue != null)
                {
                    obj.put(fieldApiName, String.valueOf(finalValue));      
                }
                else
                {
                    obj.put(fieldApiName, getDefaultPicklistValue(obj, fieldDescObj));
                }
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Percent) 
            {
                obj.put(fieldApiName, Double.valueOf(finalValue) );
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Phone) 
            {
                obj.put(fieldApiName, '123-456-7890');
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Picklist) 
            {
                if(finalValue != null)
                {
                    obj.put(fieldApiName, String.valueOf(finalValue));      
                }
                else
                {
                    obj.put(fieldApiName, getDefaultPicklistValue(obj, fieldDescObj)); 
                }
            } 
            else if (fieldDescObj.getName() == 'CommunityNickname' && fieldDescObj.getType() == Schema.DisplayType.String) 
            { 
                obj.put(fieldApiName, 'test'+ math.roundtolong(math.random()*1000000) ); 
            } 
            else if (fieldDescObj.getName() == 'UserName' && fieldDescObj.getType() == Schema.DisplayType.String) 
            { 
                obj.put(fieldApiName, 'test'+ Userinfo.getOrganizationId()+ math.roundtolong(math.random()*1000000)+ String.valueOf(Datetime.now()).replace('-',EMPTY_STRING).replace(':',EMPTY_STRING).replace(' ',EMPTY_STRING)+'@test.com'); // was a@a.com
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.String) 
            {
                obj.put(fieldApiName, String.valueOf(finalValue) );
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Reference) 
            {
                String referenceObjectType = fieldDescObj.getReferenceTo()[0].getDescribe().getName();

                if (fieldDescObj.getRelationshipName() == 'RecordType') 
                {                   
                    setRecordType(obj,finalValue);
                }
                else if (referenceObjectType == 'Profile') 
                { 
                    obj.put(fieldApiName,userProfile.Id);
                }
                else if (referenceObjectType == 'User') 
                { 
                    obj.put(fieldApiName,UserInfo.getUserId() );
                }
                else
                {
                    obj.put(fieldApiName,String.valueOf(finalValue));
                }  
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.TextArea) 
            {
                obj.put(fieldApiName, String.valueOf(finalValue)); 
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.Time) 
            {
                obj.put(fieldApiName, Time.newInstance(0, 0, 0, 0)); 
            } 
            else if (fieldDescObj.getType() == Schema.DisplayType.URL) 
            {
                obj.put(fieldApiName, 'http://test' + (String)finalValue + '.com'); 
            } 
        } 
    }
    
    
    private static void setRecordType(SObject obj,Object providedFieldValue) 
    {
        List<Schema.RecordTypeInfo> recordTypes = obj.getSObjectType().getDescribe().getRecordTypeInfos();
        
        if (recordTypes.size() > 1) { // all objects have default Master type

            for (Schema.RecordTypeInfo recordType : recordTypes) {
                if(providedFieldValue!=null && recordType.getRecordTypeId() == String.valueOf(providedFieldValue) )
                {
                    obj.put('RecordTypeId', recordType.getRecordTypeId());
                }
            }
        }
        
    }
}