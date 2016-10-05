/**
   @Author : Cognizant
   @name IPM_ExportDataController
   @CreateDate 
   @Description :Controller returns all the data to be exported
   @Version <1.0>
   @reference 
*/
  
public with sharing class IPM_ExportDataController {

public List<sObject> objectsToBeExported{get;set;}
String projectId;
String currentObject;
String fieldSetName;
String whereClause;
public String currentObjectName{get;set;}
    
    public IPM_ExportDataController()
    {
    	projectId= ApexPages.currentPage().getParameters().get('projectId');
    	currentObjectName = ApexPages.currentPage().getParameters().get('currentObjectName');
    	currentObject= ApexPages.currentPage().getParameters().get('currentObject');
    	fieldSetName= ApexPages.currentPage().getParameters().get('fieldSetName');
    	whereClause= ApexPages.currentPage().getParameters().get('whereClause');
    	objectsToBeExported = returnObjectList(currentObject,fieldSetName,whereClause);
    }
    
    /**
    *  Description : gives the fields in a object
    *  @name : returns the fields 
    */
    public List<Schema.FieldSetMember> getFields()
    {
    	
    	Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
	    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(currentObject);
	    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
	
	    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
	
	    return fieldSetObj.getFields(); 
    }
    
    /**
    *  Description : queries the sObject data 
    *  @name : returns list of sObjects
    */
    private List<sObject> returnObjectList(String SObjectName ,String fieldSetName,String whereClause)
    {
    	String queryStr = ' Select ';
    	Schema.DescribeSObjectResult sObjectDescribe = Schema.getGlobalDescribe().get(SObjectName).getDescribe();
    	Map<String, Schema.FieldSet> fieldSetMap = sObjectDescribe.fieldSets.getMap();
    	
    	Set<String> fieldSet = new Set<String>();
        if(!fieldSetMap.isEmpty() && fieldSetMap.containsKey(fieldSetName)) 
        {
        	for(Schema.FieldSetMember fieldSetMem : fieldSetMap.get(fieldSetName).getFields()) 
        	{ 
        		fieldSet.add(fieldSetMem.getFieldPath().toUpperCase());
        	}
        }
        
        for(String fieldAPIName :  fieldSet)
        {   
        	
            	queryStr += ' '+fieldAPIName+',';
            
        }
        
        queryStr += 'Id from '+SObjectName;
        queryStr += ' '+whereClause+' limit 999 ';
        return Database.query(queryStr);
    	
    }
    
}