/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Utils
@CreateDate : 2/6/2014
@Description : This is a common class used in the application 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_Utils
{
	//help methods
	/***********************************************************************************
*  @Description: this method is used to get the Brandestimate  record type
*  @name : getRecordId
*  @param : none.
*  @return: none.
*************************************************************************************/	 
	public static Id getRecordId(string pRecordType)
	{
		return Schema.SObjectType.AF_Brand_Estimate__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();   
	}
	//help methods
	/***********************************************************************************
*  @Description: this method is used to get the entity record type
*  @name : getEntityRecordId
*  @param : none.
*  @return: none.
*************************************************************************************/	 
	public static Id getEntityRecordId(string pRecordType)
	{
		return Schema.SObjectType.AF_Entity__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();   
	}
	/***********************************************************************************
*  @Description: this method is used to get the BonusResult record type
*  @name : getBonusResRecordId
*  @param : none.
*  @return: none.
*************************************************************************************/	 
	public static Id getBonusResRecordId(string pRecordType)
	{
		return Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();   
	}
	public static Boolean isAgencyUser(String userId) {
		Boolean valueToReturn = false;
		Integer usercnt = [SELECT COUNT() FROM User WHERE Id = :userId AND AF_Agency_Fees_User_Type__c=:AF_Constants.UT_AGENCY];
		valueToReturn = usercnt == 1 ? true : false;
		return valueToReturn;
	}
	/***********************************************************************************
*  @Description: this method is check the resource from static resource and returns the string
*  @name : getResourceURL
*  @param : none.
*  @return: string.
*************************************************************************************/	  
	// Pass the resource name
	public static String getResourceURL(String resourceName){
		string paramToReturn='';
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
	/***********************************************************************************
*  @Description: this method is to map the sobjects id to it's corresponding object 
*  @name : ConvertMapValuesToList
*  @param : none.
*  @return: list.
*************************************************************************************/	  
	public static List<sObject> ConvertMapValuesToList(Map<Id,sObject> sObjectMap)
	{
		List<sObject> sObjectList = new List<sObject>(); 
		for(sObject sobjectItem : sObjectMap.values())
		{
			sObjectList.add(sobjectItem);
		}
		return sObjectList;
	}
	/***********************************************************************************
*  @Description: this method is to check the entity id 
*  @name : EntityNameValue
*  @param : none.
*  @return: string.
*************************************************************************************/	  
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