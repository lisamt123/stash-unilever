/**
* @Author Cognizant
* @Name IPM_FinancialUtils
* @CreateDate 05/01/2016
* @Description This class is a Utility Class used by Financial and Financial Year Methods to perform common operations like 
    checking if consolidated fields changed
    Doing the actual consolidation.
    Creation relationship maps between Consolidated and associated Financials and Financial Years.
* @Version 1.0
*/

public with sharing class IPM_FinancialUtils 
{ 
    
    private static final String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId(); //Recordtype Id for Default on IPM_Financial__c object
    private static final String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    
    
    /*****************************************************************************************************************************
    * @description  Method to check if consolidation specific fields were changed. Used for doing selective Consolidation.
                     
    * @param incomingRecordTypeId   incoming SObject Record Type
    * @param newfinancialsObject    Changed/deleted/inserted Financial record
    * @param oldfinancialsObject    Old Financial record
    * @param fieldsToConsolidate    Fields for which consolidation happens.
    * @param finExternalId          Financial External Id field.
    */
      
    public static Set<String> isConsolidationChanged(String incomingRecordTypeId,sObject newfinancialsObject,sObject oldfinancialsObject,Set<String> fieldsToConsolidate,String finExternalId)
    {
        Set<String> changedFinancialFields = new Set<String>();
        if(Trigger.isDelete)  
        {
           return fieldsToConsolidate; 
        }
        else if(Trigger.isUpdate)
        {
	        if(incomingRecordTypeId == DEFAULT_FINANCIAL_RECORDTYPE)
	        {
	        	if(newfinancialsObject.get('isActive__c') != oldfinancialsObject.get('isActive__c'))
	        	{
	        		return fieldsToConsolidate; 
	        	}
                else if(newfinancialsObject.get(finExternalId) != oldfinancialsObject.get(finExternalId)) 
                {
                    return fieldsToConsolidate; 
                }
	        	else
	        	{
		            for(String fieldAPI : fieldsToConsolidate)
		            {
		                if(newfinancialsObject.get(fieldAPI) != oldfinancialsObject.get(fieldAPI))
		                {
		                    changedFinancialFields.add(fieldAPI);
		                }
		            }
	        	}
	        }
            else // In case consolidation is made inactive, initiate consolidation again.
            {
                if(newfinancialsObject.get('isActive__c') != oldfinancialsObject.get('isActive__c'))
                { 
                    return fieldsToConsolidate; 
                }
            }
	        return changedFinancialFields;
        }
        return changedFinancialFields;
    }
    
    /*****************************************************************************************************************************
    * @description  Used for Creating a mapping between Consolidated and related Records which gets consolidated. Works for both Financial and Financial Years.
                     
    * @param sObjectName                            Sobject Name
    * @param externalId                             Financial External Id field.
    * @param incontextfinancial                     Changed/deleted/inserted Financial record
    * @param consolidatedFinancialMap               Map containing processed list of Consolidated Records  
    * @param consolidatedToRelatedFinancialMap      Map containing relationship between consolidated and related record for financial and Financial Years.
    * @param mappingField                           Used for getting Rollout Prefix
    * @param incomingRecordType                     incoming SObject record Type.
    */
    
    public static void prepareConsolidatedToRelatedFinancials(String sObjectName,String externalId, sObject incontextfinancial,Map<String,sObject> consolidatedFinancialMap,Map<String,Map<Id,sObject>> consolidatedToRelatedFinancialMap,String mappingField,String incomingRecordType)
    {
    	if(incontextfinancial.get(mappingField) != null)  
    	{
	        if(incomingRecordType == CONSOLIDATED_FINANCIAL_RECORDTYPE)
	        {
	            consolidatedFinancialMap.put((String)incontextfinancial.get(externalId),incontextfinancial); 
	        }
	        else
	        {
	            Map<Id,sObject> relatedFinancialsMap = new Map<Id,sObject>();
	            String rolloutName = (String)incontextfinancial.get(mappingField);
    		
	            // Get ConsolidatedKey 
	            String consolidatedfinKey = getUniqueFinancialKey(sObjectName,rolloutName,incontextfinancial);        
	            if(consolidatedToRelatedFinancialMap.containsKey(consolidatedfinKey))
	            {
	                relatedFinancialsMap = consolidatedToRelatedFinancialMap.get(consolidatedfinKey); 
	            }
	            relatedFinancialsMap.put(incontextfinancial.Id,incontextfinancial);
	            consolidatedToRelatedFinancialMap.put(consolidatedfinKey,relatedFinancialsMap);
	        }
    	}
    }
    
    
    /*****************************************************************************************************************************
    * @description  Does the actual Consolidation based on relationship between consolidated and associated related records.
                     
    * @param sObjectName                    Sobject Name
    * @param externalId                     Financial External Id field.
    * @param consolidatedUniqueKey          Consolidated Financial Record Unique Key.
    * @param consolidatefinancial           Consolidated Financial Record  
    * @param relatedFinancialMap            Map containing relationship between consolidated and related record for financial and Financial Years.
    * @param upsertConsolidatedFinancial    Map for Storing target Financial Consolidation.
    * @param fieldsToConsolidate            Set of fields to consolidate
    */
    
    public static void processConsolidation(String sObjectName,String externalId, String consolidatedUniqueKey,sobject consolidatefinancial,Map<Id,sObject> relatedFinancialMap,Map<String,sObject> upsertConsolidatedFinancial,Set<String> fieldsToConsolidate)
    {
        // Get External Id for Consolidated Financial Year
        for(String consolidatefieldAPI : fieldsToConsolidate)
        {
            consolidatefinancial.put(consolidatefieldAPI,0);
        }
            
        for(sObject relatedFinancial : relatedFinancialMap.values()) 
        {		 
            for(String consolidatefieldAPI : fieldsToConsolidate)
            {
            	if(relatedFinancial.get(consolidatefieldAPI)!=null)
            	{
            		Decimal consolidatedValue = (Decimal)consolidatefinancial.get(consolidatefieldAPI) + (Decimal)relatedFinancial.get(consolidatefieldAPI);
                    consolidatefinancial.put(consolidatefieldAPI,consolidatedValue);	
            	}
            }  
		}
		upsertConsolidatedFinancial.put(consolidatedUniqueKey,consolidatefinancial);
        System.debug(LoggingLevel.ERROR,'upsertConsolidatedFinancial-->>'+upsertConsolidatedFinancial);
    }
    
    
    /*****************************************************************************************************************************
    * @description  Forms the unique Key for Consolidated Record External Id.
                     
    * @param sObjectName        Sobject Name
    * @param rolloutName        Associated Rollout Name
    * @param relatedFinancial   Financial Record 
    */
    
    private static String getUniqueFinancialKey(String sObjectName,String rolloutName ,sObject relatedFinancial)
    {
        if(sObjectName == 'IPM_Financial_Year__c')
        {
            return (rolloutName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE + '_' + relatedFinancial.get('Name') + '_' + relatedFinancial.get('Year_Type__c') + '_' + relatedFinancial.get('PL_Type__c'));
        }
        else if(sObjectName == 'IPM_Financial__c')
        {
            return rolloutName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
        }
        return null; 
    }
    
    
    /*****************************************************************************************************************************
    * @description  Used for Updating volume Information from Fiancial to Financial Records.
                     
    * @param financialDetail        Financial Record
    * @param newVolumeType          changed Volume Type
    * @param suffix                 suffix - Global,Regional,Local
    * @param upsertFinancialYearMap Target Financial Year Map to be upserted.  
    */
    
    public static void updateVolumeStatistics(IPM_Financial__c financialDetail,String newVolumeType, String suffix,Map<String,IPM_Financial_Year__c>  upsertFinancialYearMap)
    {
        String volumeTypeAPIName = IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX;
        
        for(IPM_Financial_Year__c financialYear : financialDetail.IPM_Financial_Years__r)
	    {
	        financialYear.put(volumeTypeAPIName,newVolumeType); 
	        // If the Volume Type is changed to Tons, we need to make Units as 0
	        if(newVolumeType != null && newVolumeType.equalsIgnoreCase(IPM_ConstantUtils.TOTALTONS))
	        {
	            String impactedStatAPI = IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX;
	            financialYear.put(impactedStatAPI,0);
	        }
	        else
	        {
	            String impactedStatAPI = IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX;
	            financialYear.put(impactedStatAPI,0);
	        }               
	        upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
	    }
    }
    
    
}