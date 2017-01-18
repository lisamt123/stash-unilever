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
		                    break;
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
    
    
                     
    
    		
    
    
                     
    
            
    
    
                     
    
    
    
    /* @description  Used for Updating volume Information from Fiancial to Financial Records.
                     
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
	        upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
	    }
    }
    
    /*****************************************************************************************************************************
    * @description  Used for Rendering Countries checkbox on Top Down Tab.
    */
    
    
    public static boolean showCountryCheckboxes(String Project_GKM,String IPM_Phase){
    	
    	if(Project_GKM == 'GKM3')
    	{
    		return True;
    	}
    	else if(IPM_Phase == 'Ideas')
    	{
    		return True;
    	}
    	else return False; 
    }
    
    /*****************************************************************************************************************************
    * @description  Used for enable or disable Countries checkbox on Top Down Tab.
    */
    
    public static boolean isCheckboxToBeDisabled(String Project_GKM,String IPM_Phase, String finType){
    	
    	if(Project_GKM == 'GKM3')
    	{

    		if(IPM_Phase == 'Feasibility' || IPM_Phase == 'Capability')	{
    			if(finType.equalsIgnoreCase(IPM_ConstantUtils.Nonkey)){
    				return false;
    			}
    			else {
    				return true;
    				}
    		}
    		// @description: Used to enable countries checkboxes editable for GKM3 Idea phase.
    		else if(IPM_Phase == 'Ideas'){
    			return false;
    		}
    		return true;
    	}
    	else if(IPM_Phase != 'Ideas')
    	{
    		return true;
    	}
    	else return false; 
    }
    
    
    /**************************************************************************************************************
    * This method return of the type of the currently opened fianncial (CONSOLIDATED,KEY,NONKEY)
    * Parameter : IPM_Financial__c currentFinancial i.e. the currently opened financial
    **************************************************************************************************************/
    public static string getCurrentFinancialType(String finExtId){
        
        string currentFinancialType = 'KEY';
        
        if(!string.isBlank(finExtId)){
             If(finExtId.endsWith(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)){
                currentFinancialType = IPM_ConstantUtils.CONSOLIDATED;
            }
            else if(finExtId.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY)){
                currentFinancialType = 'NONKEY';
            }
            
        }
        
        return currentFinancialType;
    }
    
    
    /*************************************************************************************************************
    * This method fetches the type of Financials to be evaluated for soft validations (KEY, NONkey or Consolidated)
    * These informations are stored in IPM_Project_GKM_To_Phase_Matrix__mdt metdata type
    * based on the project values the corresponding financial types are determined for soft validationa and then used for determining the eligibilty of financialSoft validations
    * Parameter : IPM_Project__c the current project
    * Return : IPM_Project_GKM_To_Phase_Matrix__mdt 
    *************************************************************************************************************/
    public static Map<String,String> getProjGKMToPhaseMatrixElement(){
        
        String queryString = IPM_Utils.prepareSOQLQuery('IPM_Project_GKM_To_Phase_Matrix__mdt',false, null, false);
        queryString = queryString + ' Limit 100';
        
        Map<String,String> projKeyToFinToEvaluateMap = new Map<String,String>();
        
        for(IPM_Project_GKM_To_Phase_Matrix__mdt GKMPhaseMapEle : (List<IPM_Project_GKM_To_Phase_Matrix__mdt>) Database.query(queryString)){
        	projKeyToFinToEvaluateMap.put(GKMPhaseMapEle.DeveloperName.trim().toLowerCase(),GKMPhaseMapEle.Financial_Type_To_Validate__c.trim().toLowerCase());
        }
        
        return projKeyToFinToEvaluateMap;
    }
    
    /*************************************************************************************************************
    * This method is used for consolidating Financial data at Regional Level. It works based on Regional rollout Project Name to perform Grouping and 
    * updates the Consolidated Financials.
    * Parameter : regionalProjectNames Target Regional Rollout/Project Names
    *************************************************************************************************************/
    public static Map<String,IPM_financial__c>  processRegionalConsolidationFinancial(Set<String> regionalProjectNames)
    {
        Map<String,IPM_financial__c> upsertRegionalConsolidationMap = new Map<String,IPM_financial__c>();
        Map<String,String> FieldAPIToAlaisMap = new Map<String,String>();    
        String AggregateSELECTString = 'SELECT IPM_Project_Rollout__r.IPM_Rollout_Project__c rolloutName ,Regional_Project__r.IPM_Project_Name__c regionalProjectName,';
        for(String changedField : IPM_FinancialHelper.FIELDS_TO_CONSOLIDATE) 
        {
            FieldAPIToAlaisMap.put(changedField,changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)); 
            AggregateSELECTString += 'SUM('+changedField+') '+changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + ',';
        }
        AggregateSELECTString = AggregateSELECTString.removeEnd(IPM_ConstantUtils.COMMA);
        AggregateSELECTString += ' FROM IPM_Financial__c ';
        
        String AggregateWHEREString = ' WHERE isActive__c = true AND RecordType.Name = \'Default\' AND ( IPM_Project_Rollout__r.IPM_Rollout_Project__c in :regionalProjectNames OR Regional_Project__r.IPM_Project_Name__c in :regionalProjectNames) '; 
        
        String AggregateGROUPString = ' GROUP BY  IPM_Project_Rollout__r.IPM_Rollout_Project__c,Regional_Project__r.IPM_Project_Name__c';
        String AggregateLIMITString = ' LIMIT 50000';
        String finalAggregateQuery = AggregateSELECTString + AggregateWHEREString + AggregateGROUPString + AggregateLIMITString;
        System.debug('finalAggregateQuery-->>'+finalAggregateQuery);
        for(AggregateResult financialAggr :database.Query(finalAggregateQuery))
        {
            //Get consolidated Financials for Regional Projects/Rollouts
            String rolloutName = IPM_ConstantUtils.BLANK;  
            if(financialAggr.get('rolloutName') !=null &&  String.isNotBlank((String)financialAggr.get('rolloutName'))) 
            {
                rolloutName = (String)financialAggr.get('rolloutName');
            }
            else if(financialAggr.get('regionalProjectName') !=null &&  String.isNotBlank((String)financialAggr.get('regionalProjectName')))
            {
                rolloutName = (String)financialAggr.get('regionalProjectName');
            }
            // Prepare the Consolidated Financial External ID 
            String financialExternalID =  rolloutName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
            IPM_Financial__c consolidatedFinancialObj = new IPM_Financial__c(Financial_External_ID__c = financialExternalID); 
            if(upsertRegionalConsolidationMap.containsKey(financialExternalID))
            {
            	consolidatedFinancialObj = upsertRegionalConsolidationMap.get(financialExternalID);
            } 
            for(String FieldAPIName : FieldAPIToAlaisMap.keySet())
            {
                String alais = FieldAPIToAlaisMap.get(FieldAPIName);
                Decimal consolidatedValue = 0;
                if(consolidatedFinancialObj.get(FieldAPIName) != null)
                {
                	consolidatedValue = (decimal)consolidatedFinancialObj.get(FieldAPIName) + (Decimal)financialAggr.get(alais);
                }
                else
                {
                	consolidatedValue = (Decimal)financialAggr.get(alais);
                } 
                consolidatedFinancialObj.put(FieldAPIName,consolidatedValue);
            }
            upsertRegionalConsolidationMap.put(financialExternalID,consolidatedFinancialObj);
        }
        if(!upsertRegionalConsolidationMap.isEmpty())
        {
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
            IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
            upsert upsertRegionalConsolidationMap.values() Financial_External_ID__c;
            IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
        }
        return upsertRegionalConsolidationMap;
    }
    /*************************************************************************************************************
    * This method is used for consolidating Financial data at Global Level. It works based on Global Project Name to perform Grouping and 
    * updates the Consolidated Financials.
    * Parameter : globalProjectNames Target Global Project Names
    *************************************************************************************************************/
    public static Map<String,IPM_financial__c>  processGlobalConsolidationFinancial(Set<String> globalProjectNamesProject)
    {
        Map<String,IPM_financial__c> upsertGlobalConsolidationMap = new Map<String,IPM_financial__c>();
        Map<String,String> FieldAPIToAlaisMap = new Map<String,String>();   
        String AggregateSELECTString = 'SELECT IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Name__c globalProjectName1 ,Regional_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c globalProjectName2,';
        for(String changedField : IPM_FinancialHelper.FIELDS_TO_CONSOLIDATE) 
        {
            FieldAPIToAlaisMap.put(changedField,changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)); 
            AggregateSELECTString += 'SUM('+changedField+') '+changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + ',';
        }
        AggregateSELECTString = AggregateSELECTString.removeEnd(IPM_ConstantUtils.COMMA);
        AggregateSELECTString += ' FROM IPM_Financial__c ';
        
        String AggregateWHEREString = ' WHERE isActive__c = true AND RecordType.Name = \'Default\' AND (IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Name__c in :globalProjectNamesProject OR Regional_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c in :globalProjectNamesProject) ';
        
        String AggregateGROUPString = ' GROUP BY  IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Name__c,Regional_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c';
        String AggregateLIMITString = ' LIMIT 50000';
        String finalAggregateQuery = AggregateSELECTString + AggregateWHEREString + AggregateGROUPString + AggregateLIMITString;
        System.debug('finalAggregateQuery-->>'+finalAggregateQuery);
        for(AggregateResult financialAggr :database.Query(finalAggregateQuery))
        {
            //Get consolidated Financials for Regional Projects/Rollouts
            String globalProjectName = IPM_ConstantUtils.BLANK;  
            if(financialAggr.get('globalProjectName1') !=null &&  String.isNotBlank((String)financialAggr.get('globalProjectName1')))
            {
                globalProjectName = (String)financialAggr.get('globalProjectName1');
            }
            else if(financialAggr.get('globalProjectName2') !=null &&  String.isNotBlank((String)financialAggr.get('globalProjectName2')))
            {
            	globalProjectName = (String)financialAggr.get('globalProjectName2');
            }
            // Prepare the Consolidated Financial External ID 
            String financialExternalID =  globalProjectName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
            IPM_Financial__c consolidatedFinancialObj = new IPM_Financial__c(Financial_External_ID__c = financialExternalID); 
            if(upsertGlobalConsolidationMap.containsKey(financialExternalID))
            {
            	consolidatedFinancialObj = upsertGlobalConsolidationMap.get(financialExternalID);
            } 
            for(String FieldAPIName : FieldAPIToAlaisMap.keySet())
            {
                String alais = FieldAPIToAlaisMap.get(FieldAPIName);
                Decimal consolidatedValue = 0;
                if(consolidatedFinancialObj.get(FieldAPIName) !=null)
                {
                	consolidatedValue = (decimal)consolidatedFinancialObj.get(FieldAPIName) + (Decimal)financialAggr.get(alais);	
                }
                else
                {
                	consolidatedValue = (Decimal)financialAggr.get(alais);
                }
                consolidatedFinancialObj.put(FieldAPIName,consolidatedValue);
            }
            upsertGlobalConsolidationMap.put(financialExternalID,consolidatedFinancialObj);
        }
        if(!upsertGlobalConsolidationMap.isEmpty())
        {
            
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
            IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
            upsert upsertGlobalConsolidationMap.values() Financial_External_ID__c;
            IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false; 
        }
        return upsertGlobalConsolidationMap;
    }
    /*************************************************************************************************************
    * This method is used for consolidating Financial Year data at Regional Level. It works based on Regional Rollouts/Project Name to perform Grouping and 
    * updates the Consolidated Financials Years. It identifies the External Id based on Combination of Global Project + Consolidated Literal + Name +Year Type+ Year PL  
    * Parameter : regionalProjectNames Target Regional Rollout/Project Names
    *************************************************************************************************************/
    
    public static Map<String,IPM_financial_Year__c> processRegionalConsolidationFY(Set<String> regionalProjectNames) 
    {
      Map<String,IPM_financial_Year__c> upsertRegionalConsolidationFYMap = new Map<String,IPM_financial_Year__c>();
      Map<String,String> FieldAPIToAlaisMap = new Map<String,String>();   
       String AggregateSELECTString = 'SELECT Name,Year_Type__c,PL_Type__c,IPM_Financial__r.IPM_Project_Rollout__r.IPM_Rollout_Project__c rolloutName ,IPM_Financial__r.Regional_Project__r.IPM_Project_Name__c regionalProjectName,';
       for(String changedField : IPM_FinancialYearHelper.FIELDS_TO_CONSOLIDATE) 
       {
         FieldAPIToAlaisMap.put(changedField,changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)); 
         AggregateSELECTString += 'SUM('+changedField+') '+changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + ',';
       }
       AggregateSELECTString = AggregateSELECTString.removeEnd(IPM_ConstantUtils.COMMA);
       AggregateSELECTString += ' FROM IPM_Financial_Year__c ';
       
       String AggregateWHEREString = ' WHERE IPM_Financial__r.isActive__c = true AND IPM_Financial__r.RecordType.Name = \'Default\' AND (IPM_Financial__r.IPM_Project_Rollout__r.IPM_Rollout_Project__c in :regionalProjectNames OR IPM_Financial__r.Regional_Project__r.IPM_Project_Name__c in :regionalProjectNames) ';
    
       String AggregateGROUPString = ' GROUP BY  IPM_Financial__r.IPM_Project_Rollout__r.IPM_Rollout_Project__c,IPM_Financial__r.Regional_Project__r.IPM_Project_Name__c,Name,Year_Type__c,PL_Type__c';
       
       String AggregateLIMITString = ' LIMIT 50000';
       
       String finalAggregateQuery = AggregateSELECTString + AggregateWHEREString + AggregateGROUPString + AggregateLIMITString;
       
       System.debug('finalAggregateQuery-->>'+finalAggregateQuery);
       
       for(AggregateResult financialAggr :database.Query(finalAggregateQuery))
       {
         //Get consolidated Financials for Regional Projects/Rollouts
      String financialYearName = (String)financialAggr.get('Name');
      String financialYearType = (String)financialAggr.get('Year_Type__c');
      String financialYearPLType = (String)financialAggr.get('PL_Type__c');
      String rolloutName = IPM_ConstantUtils.BLANK;  
      if(financialAggr.get('rolloutName') !=null &&  String.isNotBlank((String)financialAggr.get('rolloutName')))
      {
        rolloutName = (String)financialAggr.get('rolloutName');
      }
      else if(financialAggr.get('regionalProjectName') !=null &&  String.isNotBlank((String)financialAggr.get('regionalProjectName')))
      {
        rolloutName = (String)financialAggr.get('regionalProjectName');
      }
      // Prepare the Consolidated Financial External ID 
      String FYConsolidatedExternalID = rolloutName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE + '_' + financialYearName + '_' + financialYearType + '_' +financialYearPLType;
      String financialExternalID =  rolloutName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
      IPM_Financial__c financialObj = new IPM_Financial__c(Financial_External_ID__c = financialExternalID); 
      IPM_financial_Year__c consolidatedFinancialYearObj = new  IPM_financial_Year__c(External_Id__c = FYConsolidatedExternalID);
      if(upsertRegionalConsolidationFYMap.containsKey(FYConsolidatedExternalID))
      {
        consolidatedFinancialYearObj = upsertRegionalConsolidationFYMap.get(FYConsolidatedExternalID);
      }
      consolidatedFinancialYearObj.IPM_Financial__r = financialObj;
         for(String FieldAPIName : FieldAPIToAlaisMap.keySet())
         {
           String alais = FieldAPIToAlaisMap.get(FieldAPIName);
           Decimal consolidatedValue = 0;
           if(consolidatedFinancialYearObj.get(FieldAPIName) !=null)
           {
             consolidatedValue = (decimal)consolidatedFinancialYearObj.get(FieldAPIName) + (Decimal)financialAggr.get(alais);    
           }
           else
           {
             consolidatedValue = (Decimal)financialAggr.get(alais);
           }
           consolidatedFinancialYearObj.put(FieldAPIName,consolidatedValue);
         }
         upsertRegionalConsolidationFYMap.put(FYConsolidatedExternalID,consolidatedFinancialYearObj);
       }
       if(!upsertRegionalConsolidationFYMap.isEmpty())
       {
         IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
         IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
         upsert upsertRegionalConsolidationFYMap.values() External_Id__c;
         IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
         IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
       }
       return upsertRegionalConsolidationFYMap;
    }
    
    /*************************************************************************************************************
    * This method is used for consolidating Financial Year data at Global Level. It works based on Global Project Name to perform Grouping and 
    * updates the Consolidated Financials Years. It identifies the External Id based on Combination of Global Project + Consolidated Literal  
    * Parameter : globalProjectNames Target Global Project Names
    *************************************************************************************************************/
    public static Map<String,IPM_financial_Year__c>  processGlobalConsolidationFY(Set<String> globalProjectNamesProject)
    {
      Map<String,IPM_financial_Year__c> upsertGlobalConsolidationFYMap = new Map<String,IPM_financial_Year__c>();
      Map<String,String> FieldAPIToAlaisMap = new Map<String,String>();   
       String AggregateSELECTString = 'SELECT Name,Year_Type__c,PL_Type__c,IPM_Financial__r.IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Name__c globalProjectName1,IPM_Financial__r.Regional_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c globalProjectName2,';
       for(String changedField : IPM_FinancialYearHelper.FIELDS_TO_CONSOLIDATE) 
       {
         FieldAPIToAlaisMap.put(changedField,changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)); 
         AggregateSELECTString += 'SUM('+changedField+') '+changedField.removeEnd(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + ',';
       }
       AggregateSELECTString = AggregateSELECTString.removeEnd(IPM_ConstantUtils.COMMA);
       AggregateSELECTString += ' FROM IPM_Financial_Year__c '; 
       
       String AggregateWHEREString = ' WHERE IPM_Financial__r.isActive__c = true AND IPM_Financial__r.RecordType.Name = \'Default\' AND (IPM_Financial__r.IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Name__c in :globalProjectNamesProject OR IPM_Financial__r.Regional_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c in :globalProjectNamesProject) ';   
     
       String AggregateGROUPString = ' GROUP BY  IPM_Financial__r.IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Name__c,IPM_Financial__r.Regional_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c,Name,Year_Type__c,PL_Type__c';
       
       String AggregateLIMITString = ' LIMIT 50000';
       
       String finalAggregateQuery = AggregateSELECTString + AggregateWHEREString + AggregateGROUPString + AggregateLIMITString;
       
       System.debug('finalAggregateQuery-->>'+finalAggregateQuery);
       
       for(AggregateResult financialAggr :database.Query(finalAggregateQuery))
       {
         //Get consolidated Financials for Regional Projects/Rollouts
      String financialYearName = (String)financialAggr.get('Name');
      String financialYearType = (String)financialAggr.get('Year_Type__c');
      String financialYearPLType = (String)financialAggr.get('PL_Type__c');
      String globalProjectName = IPM_ConstantUtils.BLANK;  
      if(financialAggr.get('globalProjectName1') !=null &&  String.isNotBlank((String)financialAggr.get('globalProjectName1')))
      {
        globalProjectName = (String)financialAggr.get('globalProjectName1');
      }
      else if(financialAggr.get('globalProjectName2') !=null &&  String.isNotBlank((String)financialAggr.get('globalProjectName2')))
      {
        globalProjectName = (String)financialAggr.get('globalProjectName2');
      }
      // Prepare the Consolidated Financial External ID 
      String FYConsolidatedExternalID = globalProjectName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE + '_' + financialYearName + '_' + financialYearType + '_' +financialYearPLType;
      String financialExternalID =  globalProjectName + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
      IPM_Financial__c financialObj = new IPM_Financial__c(Financial_External_ID__c = financialExternalID); 
      IPM_financial_Year__c consolidatedFinancialYearObj = new  IPM_financial_Year__c(External_Id__c = FYConsolidatedExternalID);
      if(upsertGlobalConsolidationFYMap.containsKey(FYConsolidatedExternalID))
      {
        consolidatedFinancialYearObj = upsertGlobalConsolidationFYMap.get(FYConsolidatedExternalID);
      }
      consolidatedFinancialYearObj.IPM_Financial__r = financialObj;
         for(String FieldAPIName : FieldAPIToAlaisMap.keySet())
         {
           String alais = FieldAPIToAlaisMap.get(FieldAPIName);
           Decimal consolidatedValue = 0;
           if(consolidatedFinancialYearObj.get(FieldAPIName) !=null)
           {
             consolidatedValue = (decimal)consolidatedFinancialYearObj.get(FieldAPIName) + (Decimal)financialAggr.get(alais);
           }
           else
           {
             consolidatedValue = (Decimal)financialAggr.get(alais);
           }
           consolidatedFinancialYearObj.put(FieldAPIName,consolidatedValue);
         }
         upsertGlobalConsolidationFYMap.put(FYConsolidatedExternalID,consolidatedFinancialYearObj);
       }
       if(!upsertGlobalConsolidationFYMap.isEmpty())
       {

     		IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
     		IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
     		upsert upsertGlobalConsolidationFYMap.values() External_Id__c;
     		IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
     		IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
     	}
     	return upsertGlobalConsolidationFYMap;
    }
}