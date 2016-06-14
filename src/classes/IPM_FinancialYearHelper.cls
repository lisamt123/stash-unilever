/**********************************************************************************************************************
* @author       Cognizant 
* @date         27/04/2015
* @description  This class is used for managing the trigger methods for IPM_Financial_Year__c object this contains 
*               initialiseFYConsolidation: contains Financial Year Consolidation Logic
			    updateFinancialActionStandard: updates IPM_Project_Document_Section_Content__c
			    and getFinancialYearQuery: Query for the financial year records required for processing.
*************************************************************************************************************************/
public with sharing class IPM_FinancialYearHelper
{
    private static final String UPDATE_FINANCIAL_ACTION_STANDARD_STR = 'updateFinancialActionStandard';
    private static final String CLASS_NAME = IPM_FinancialYearHelper.Class.getName(); //Class Name for Exception Logging
    private static Boolean IS_RECURSSIVE = false;
    // Field set used for consolidation  
    private static final Set<String> FIELDS_TO_CONSOLIDATE = new Set<String>{
            'Advertising_Promotions_Global__c','Advertising_Promotions_Local__c','Advertising_Promotions_Regional__c',
            'Profit_Before_Overheads_Global__c','Profit_Before_Overheads_Local__c','Profit_Before_Overheads_Regional__c',
            'Gross_Profit_Global__c','Gross_Profit_Local__c','Gross_Profit_Regional__c',
            'Turnover_Global__c','Turnover_Local__c','Turnover_Regional__c',
            'Volume_Global__c','Volume_Regional__c','Volume_Local__c',
            'Volume_Tons_Global__c','Volume_Tons_Regional__c','Volume_Tons_Local__c'
        };
    
    static set<string> setInvalidFin = new set<string>();
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    
    /*******************************************************************************************************************
    * @description                      Method to initialise consolidation of financial year records. In this method we 
    									query existing financial record based on the project type
    *									and update consildated record for active financial records.
    * @param newFinancialYearList       Map of Trigger.new records
    * @param oldFinancialYearMap        Map of Trigger.old records
    * @param financialYearDetailMap	    Queried List of Financial Records from DB 		
    * @param upsertconsolidatedFinancialYearMap udapted financial record to be upsert.
    * @return                           NONE
    *********************************************************************************************************************/
    public static void initialiseFYConsolidation(List<IPM_Financial_Year__c> newFinancialYearList, Map<Id, IPM_Financial_Year__c> oldFinancialYearMap,Map<Id,IPM_Financial_Year__c> financialYearDetailMap,Map<String,IPM_Financial_Year__c> upsertconsolidatedFinancialYearMap )
    {
        Set<String> globalProjectIdSet = new Set<String>();
        Set<String> regionalProjectIdSet = new Set<String>();
        
        Set<String> changedFinancialFieldSet = new Set<String>();
        
       
        for(IPM_Financial_Year__c newfinancialYear : newFinancialYearList) 
        {
            IPM_Financial_Year__c oldFinancialYear = null;
            if(oldFinancialYearMap !=null && oldFinancialYearMap.containsKey(newfinancialYear.Id))
            {
                oldFinancialYear = oldFinancialYearMap.get(newfinancialYear.Id);
            }
             
            changedFinancialFieldSet.addAll(IPM_FinancialUtils.isConsolidationChanged(newFinancialYear.IPM_AssociatedFinancialRecordTypeId__c,newfinancialYear,oldFinancialYear,FIELDS_TO_CONSOLIDATE,'External_Id__c'));  
        }
        
        if(!changedFinancialFieldSet.isEmpty())
        {   
            String financialYearSelectQuery = IPM_FinancialYearHelper.getFinancialYearQuery(); 
            
            if(financialYearDetailMap == null || financialYearDetailMap.isEmpty())
            {
                String financialYearDetailQuery = financialYearSelectQuery + ' where Id in :newFinancialYearList LIMIT 50000 ';     
                financialYearDetailMap = new Map<Id,IPM_Financial_Year__c>( (List<IPM_Financial_Year__c>) database.query(financialYearDetailQuery));
            }  
            
            for(IPM_Financial_Year__c financialYear : newFinancialYearList)
            {
                IPM_Financial_Year__c newfinancialYear = financialYearDetailMap.get(financialYear.Id);
                
                if(newfinancialYear.Global_External_Id__c != null && newfinancialYear.Global_External_Id__c != '')
                {
                    globalProjectIdSet.add(newfinancialYear.Global_External_Id__c);
                }
                
                if(newfinancialYear.Regional_External_Id__c != null && newfinancialYear.Regional_External_Id__c != '')
                {
                    regionalProjectIdSet.add(newfinancialYear.Regional_External_Id__c);
                }  
            }

            // Get the complete list of Financial Years from the prepared List of Regional and Global Project.
            
            String financialYearWhereClause = '  where isActive__c = true AND (Global_External_Id__c in :globalProjectIdSet OR Regional_External_Id__c in :regionalProjectIdSet)  LIMIT 50000';
            String financialYearQuery = financialYearSelectQuery + financialYearWhereClause; 
           
            List<IPM_Financial_Year__c> completeFinancialYearList = database.query(financialYearQuery);
            
            Map<String,Map<Id,sObject>> consolidatedToRelatedFinancialYearMap = new Map<String,Map<Id,sObject>>();
            Map<String,sObject> consolidatedFinancialYearMap = new Map<String,sObject>();
            
            for(IPM_Financial_Year__c financialYear : completeFinancialYearList) 
            {                                                      
                IPM_FinancialUtils.prepareConsolidatedToRelatedFinancials('IPM_Financial_Year__c','External_Id__c',financialYear,consolidatedFinancialYearMap,consolidatedToRelatedFinancialYearMap,'Global_External_Id__c',financialYear.IPM_Financial__r.RecordTypeId);
                IPM_FinancialUtils.prepareConsolidatedToRelatedFinancials('IPM_Financial_Year__c','External_Id__c',financialYear,consolidatedFinancialYearMap,consolidatedToRelatedFinancialYearMap,'Regional_External_Id__c',financialYear.IPM_Financial__r.RecordTypeId);
            }
                        
            for(String consolidatedFinancialYearKey : consolidatedFinancialYearMap.KeySet())
            {
                sObject consolidatedFinancialYear = consolidatedFinancialYearMap.get(consolidatedFinancialYearKey);
                if(consolidatedToRelatedFinancialYearMap.containsKey(consolidatedFinancialYearKey))
                { 
                    Map<Id,sObject> relatedDefaultFinancialsYear = consolidatedToRelatedFinancialYearMap.get(consolidatedFinancialYearKey);
                        
                    if(!relatedDefaultFinancialsYear.isEmpty())
                    {
                        IPM_FinancialUtils.processConsolidation('IPM_Financial_Year__c','External_Id__c',consolidatedFinancialYearKey,consolidatedFinancialYear,relatedDefaultFinancialsYear,upsertconsolidatedFinancialYearMap,changedFinancialFieldSet);    
                    }
                    else
                    {
                        for(String consolidatefieldAPI : changedFinancialFieldSet)
	                    {
	                        consolidatedFinancialYear.put(consolidatefieldAPI,0);
	                    }
	                    upsertconsolidatedFinancialYearMap.put(consolidatedFinancialYearKey,(IPM_Financial_Year__c)consolidatedFinancialYear);    
                    }
                         
                }
                else
                {
                    for(String consolidatefieldAPI : changedFinancialFieldSet)
                    {
                        consolidatedFinancialYear.put(consolidatefieldAPI,0);
                    }
                    upsertconsolidatedFinancialYearMap.put(consolidatedFinancialYearKey,(IPM_Financial_Year__c)consolidatedFinancialYear);
                }
            }
        }
    }
    
    /**********************************************************************************************************************************
    * @description                  Method to update Financial Action Standards, updates project documentation section content with 
    *								financial year details based on project ID, content type and phase of the project.
    * @param newFinancialYear       New Financial Year record
    * @return                       NONE
    * Business Logic: At Charter section 6.1 Business Case V/S Action Standard needs to be populated with IRR,ValueShare,ITO,GTO values from First Full Year of financials.
                             The Below code updates those values from the Financial object into the Project DocumetnSection Content object when the Gate document IS Charter.
                             From Contract Document Onwards, only the Results set at contract gets populated.Similary the logic extends till Market Ready Gate
    ***********************************************************************************************************************************/
    public static void updateFinancialActionStandard(Map<Id, IPM_Financial_Year__c> mapNewFinancialYears){
        try{
            List<IPM_Financial_Year__c> newFinYearList=new  List<IPM_Financial_Year__c>();
            List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
            Set<Id> projectIds=new Set<Id>();
            for(IPM_Financial_Year__c newFinYear:mapNewFinancialYears.values())
            {
                if(newFinYear.Financial_External_Id__c.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE) && (String.isBlank(newFinYear.Regional_External_Id__c) || String.isBlank(newFinYear.Global_External_Id__c)) && (newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental || newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross) && !newFinYear.Charter_Approved__c)
                {
                    newFinYearList.add(newFinYear);
                    projectIds.add(newFinYear.Global_Project_Id__c);
                }
                else if(String.isNotBlank(newFinYear.Global_External_Id__c) && newFinYear.Financial_External_Id__c==newFinYear.Global_External_Id__c && (newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental || newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross) && !newFinYear.Charter_Approved__c)
                {
                    newFinYearList.add(newFinYear);
                    projectIds.add(newFinYear.Global_Project_Id__c);
                }
                else if(String.isNotBlank(newFinYear.Regional_External_Id__c) && newFinYear.Financial_External_Id__c==newFinYear.Regional_External_Id__c && (newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental || newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross) && !newFinYear.Charter_Approved__c)
                {
                    newFinYearList.add(newFinYear);
                    projectIds.add(newFinYear.Global_Project_Id__c);
                }
                else if(String.isBlank(newFinYear.Regional_External_Id__c) && String.isBlank(newFinYear.Global_External_Id__c)  && (newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental || newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross) && !newFinYear.Charter_Approved__c)
                {
                    newFinYearList.add(newFinYear);
                    projectIds.add(newFinYear.Global_Project_Id__c);
                }
            }
            
            if(projectIds!=null && !projectIds.isEmpty())
            {
                projDocSecConList=[SELECT Id,IPM_iTo_Action_Standard_Charter__c,IPM_Innov_Value_Share_Action_Charter__c,IPM_Inc_Value_Share_Action_Charter__c,IPM_gTO_Action_Standard_Charter__c,IPM_GM_Action_Standards_Charter__c,
                                          IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,IPM_Content_Type__c,
                                          IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPMProject_Span__c,
                                          IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Type__c
                                   FROM IPM_Project_Document_Section_Content__c
                                   WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c In:projectIds AND IPM_Content_Type__c=:IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS AND 
                                         IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c=:IPM_ConstantUtils.PHASE_IDEAS];  
            }
            
            for(IPM_Financial_Year__c finYear:newFinYearList)
            {  
                for(IPM_Project_Document_Section_Content__c secContent:projDocSecConList)
                {  
                    if(secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==finYear.Global_Project_Id__c)
                    {
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental)
                        {
                            secContent.IPM_Inc_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Global__c;
                            secContent.IPM_iTo_Action_Standard_Charter__c=finYear.Turnover_Global__c;
                        }
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross)
                        {
                            secContent.IPM_Innov_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Global__c;
                            secContent.IPM_gTO_Action_Standard_Charter__c=finYear.Turnover_Global__c;
                            secContent.IPM_GM_Action_Standards_Charter__c=finYear.GM_of_TO_Global__c;
                        }
                    }
                    else if(secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==finYear.Global_Project_Id__c)
                    {
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental)
                        {
                            secContent.IPM_Inc_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Regional__c;
                            secContent.IPM_iTo_Action_Standard_Charter__c=finYear.Turnover_Regional__c;
                        }
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross)
                        {
                            secContent.IPM_Innov_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Regional__c;
                            secContent.IPM_gTO_Action_Standard_Charter__c=finYear.Turnover_Regional__c;
                            secContent.IPM_GM_Action_Standards_Charter__c=finYear.GM_of_TO_Regional__c;
                        }
                    }
                    else if(secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==finYear.Global_Project_Id__c)
                    {
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental)
                        {
                            secContent.IPM_Inc_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Local__c;
                            secContent.IPM_iTo_Action_Standard_Charter__c=finYear.Turnover_Local__c;
                        }
                        
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross)
                        {
                            secContent.IPM_Innov_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Local__c;
                            secContent.IPM_gTO_Action_Standard_Charter__c=finYear.Turnover_Local__c;
                            secContent.IPM_GM_Action_Standards_Charter__c=finYear.GM_of_TO_Local__c;
                        }
                    }
                }
            }
            
            if(projDocSecConList!=null && !projDocSecConList.isEmpty())
            {
                update projDocSecConList;
            }
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                UPDATE_FINANCIAL_ACTION_STANDARD_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }
    
    /**********************************************************************************************************************************
    * @description                  This method queries for all the financial year record required for consolidation and updating the  
    *								the document section.
    * @param newFinancialYear       New Financial Year record
    * @return                       NONE
    ***********************************************************************************************************************************/
     
    public static String getFinancialYearQuery()
    {
        Map<String,Schema.SObjectField> financialYearFieldMap = Schema.SObjectType.IPM_Financial_Year__c.fields.getMap();
        
        String financialYearQuery = ' SELECT ';        
        for(String financialYearFieldAPI  : financialYearFieldMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = financialYearFieldMap.get(financialYearFieldAPI).getDescribe();
            
            if(fieldDescribe.isCustom()  && financialYearFieldAPI != 'Id')
            {
                financialYearQuery += ' '+financialYearFieldAPI+',';
            }
        }
        financialYearQuery += 'Id,Name,IPM_Financial__r.Financial_External_ID__c,IPM_Financial__r.RecordTypeId FROM IPM_Financial_Year__c';
        
        return financialYearQuery;
    }

    //This method is used to create market performance(6.5) and performance breakdown(6.3) data when financial years are created as part of local rollout creation.
    public static void createMarketPerformance(Map<id,IPM_Financial_Year__c>finYearmap){
        Map<String, IPM_Financial_Year__c> mapFinancialExternalIdwithFinancialYear = new Map<String, IPM_Financial_Year__c>();
       
        List<IPM_MarketPerformance__c>lstMarketPerformaceData = new List<IPM_MarketPerformance__c>();
        IPM_MarketPerformance__c marketPerformanceData;
        
        List<IPM_MarketPerformanceBreakdown__c> lstPerformanceBreakdownData = new List<IPM_MarketPerformanceBreakdown__c>();
        IPM_MarketPerformanceBreakdown__c performanceBreakdownData;
        
        Integer counter;
        final String PERIOD = 'Period ';
        final integer PERIOD_COUNT = 13;
         
        set<String> setFinancialExternalIds = new Set<String>();
        for( IPM_Financial_Year__c financialYear : [SELECT Id, Year__c, Year_Type__c, PL_Type__c, Financial_External_Id__c, IPM_Financial__r.Financial_External_ID__c, 
                                                    IPM_Financial__r.RecordType.Name, IPM_Financial__r.Regional_Project__c
                                                    FROM IPM_Financial_Year__c
                                                    WHERE Id IN : finYearmap.keySet()
                                                    AND isActive__c = true 
                                                    AND Year__c =: IPM_ConstantUtils.Y1_YEARINDEX
                                                    AND Year_Type__c =: IPM_ConstantUtils.YEAR_TYPE_INNOVATION AND PL_Type__c =: IPM_ConstantUtils.PL_TYPE_GROSS
                                                    AND IPM_Financial__r.RecordType.Name =: IPM_ConstantUtils.DEFAULT_FINANCIAL_RT])
                                                    //AND IPM_Financial__r.Regional_Project__c!=null ])
        {
                mapFinancialExternalIdwithFinancialYear.put(financialYear.Financial_External_Id__c, financialYear);
                setFinancialExternalIds.add(financialYear.IPM_Financial__r.Financial_External_ID__c);
        }
        for(IPM_Project_Rollout__c projectRollout : [Select Id, MCO_Name__c, IPM_Rollout_Project__c from IPM_Project_Rollout__c where IPM_Rollout_Project__c IN : setFinancialExternalIds  limit 1000]){
                marketPerformanceData = new IPM_MarketPerformance__c();
                marketPerformanceData.IPMFinancialYear__c = mapFinancialExternalIdwithFinancialYear.get(projectRollout.IPM_Rollout_Project__c).Id;
                marketPerformanceData.IPMProjectRollout__c = projectRollout.Id;
                marketPerformanceData.External_Id__c = mapFinancialExternalIdwithFinancialYear.get(projectRollout.IPM_Rollout_Project__c).Financial_External_Id__c;
                lstMarketPerformaceData.add(marketPerformanceData);
        }
        
	    if(!lstMarketPerformaceData.isEmpty()){    
	        insert lstMarketPerformaceData;
                
	        for(IPM_MarketPerformance__c marketPerformance : [Select Id, External_Id__c from IPM_MarketPerformance__c 
	                                                                                              where Id IN : (new Map<Id, IPM_MarketPerformance__c>( lstMarketPerformaceData)).keySet()])
	        {
	            for(counter=1;counter<=PERIOD_COUNT;counter++){
	                performanceBreakdownData = new IPM_MarketPerformanceBreakdown__c();
	                performanceBreakdownData.MarketPerformance__c = marketperformance.Id;
	                performanceBreakdownData.External_Id__c = marketperformance.External_Id__c + IPM_ConstantUtils.IPM_SPACE + PERIOD + counter;
	                performanceBreakdownData.Period__c = PERIOD+counter;
	                performanceBreakdownData.Sequence__c = counter;
	                lstPerformanceBreakdownData.add(performanceBreakdownData);
	            }
	        }
	        if(!lstPerformanceBreakdownData.isEmpty())
	            insert lstPerformanceBreakdownData;
	    }
        
        
    }
	
	 /**********************************************************************************************************************************
    * @description                  This method queries for all the financial year record required for consolidation and updating the  
    *                               the financial action standard records.
    * @param mapNewFinancialYears   New Financial Year record
    * @return                       NONE
    ***********************************************************************************************************************************/
    public static void updateGlobalFinancialActionStandards(Map<Id, IPM_Financial_Year__c> mapNewFinancialYears){
		try{
			List<IPM_Financial_Year__c> newFinYearList=new  List<IPM_Financial_Year__c>();
			List<IPM_Financial_Action_Standards__c> updateFinActionStdsList=new List<IPM_Financial_Action_Standards__c>();
			Set<Id> projectIds=new Set<Id>();
			for(IPM_Financial_Year__c newFinYear:mapNewFinancialYears.values()){
				if(newFinYear.Financial_External_Id__c.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)  && (newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental || newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross) && !newFinYear.Charter_Approved__c){
					newFinYearList.add(newFinYear);
					projectIds.add(newFinYear.Global_Project_Id__c);
				}
			}
			for(IPM_Financial_Action_Standards__c finActionStd:[SELECT Id,IPM_Project_Span__c,IPM_Financial_Year_Y1_Gross__c,IPM_Financial_Year_Y1_Incremental__c,IPM_GM_Action_Standards_Charter__c,IPM_gTO_Action_Standard_Charter__c,IPM_Inc_Value_Share_Action_Charter__c,
																	   IPM_Innov_Value_Share_Action_Charter__c,IPM_iTo_Action_Standard_Charter__c,IPM_Project__c FROM IPM_Financial_Action_Standards__c
																WHERE IPM_Project__c In:projectIds]){
				for(IPM_Financial_Year__c finYear:newFinYearList){
					if(finActionStd.IPM_Financial_Year_Y1_Gross__c==finYear.Id){
						finActionStd.IPM_Innov_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Global__c;
						finActionStd.IPM_gTO_Action_Standard_Charter__c=finYear.Turnover_Global__c;
						finActionStd.IPM_GM_Action_Standards_Charter__c=finYear.GM_of_TO_Global__c;
					}
					else if(finActionStd.IPM_Financial_Year_Y1_Incremental__c==finYear.Id){
						finActionStd.IPM_Inc_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Global__c;
						finActionStd.IPM_iTo_Action_Standard_Charter__c=finYear.Turnover_Global__c;
					}
				}
				updateFinActionStdsList.add(finActionStd);
			}
			if(updateFinActionStdsList!=null && !updateFinActionStdsList.isEmpty()){
				update updateFinActionStdsList;
			}
		}
		catch(Exception ex){
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
				UPDATE_FINANCIAL_ACTION_STANDARD_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
		}
	}	
	/**********************************************************************************************************************************
    * @description                  This method queries for all the financial year record required for hard validation check                    the financial action standard records.
    * @param setFinExtId            set of Financial records to be validated
    * @return                       NONE
    ***********************************************************************************************************************************/
    public static void validateDefaultFinancial(set<string> setFinExtId){
        try{
            string DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
            map<string, IPM_Financial_Year__c> mapExtIdFinYear = new map<string, IPM_Financial_Year__c>();
            //set<string> setInvalidFin = new set<string>();
            set<string> setGlobalProjExtIds = new set<string>();
            set<string> setRegionalOrigProjIds = new set<string>();
            map<string, IPM_Project__c> mapProj = new map<string, IPM_Project__c>();
            
            set<string> setAllFinacials = new set<string>(); //Set to store all Financial External Ids.
            
            //Get all Financial Year records for the related Financial records
            for(IPM_Financial_Year__c finYr :[select id, Name,Turnover_Global__c, Turnover_Regional__c, Turnover_Local__c, Financial_External_ID__c, External_Id__c, IPM_Financial__r.Global_External_Id__c, IPM_Financial__r.Regional_Project__c, IPM_Financial__r.Local_Project__c, IPM_Financial__r.Financial_External_ID__c from IPM_Financial_Year__c where Financial_External_ID__c in : setFinExtId AND IPM_Financial__r.RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE and Name!= :IPM_ConstantUtils.Y0_LABEL and isActive__c = TRUE and IPM_Financial__r.isActive__c = TRUE  LIMIT 50000]){
                mapExtIdFinYear.put(finYr.External_Id__c, finYr);
		setAllFinacials.add(finYr.IPM_Financial__r.Financial_External_ID__c);
				
                //Global Original Project's financial
                if(finYr.IPM_Financial__r.Global_External_Id__c!=null){
                    setGlobalProjExtIds.add(finYr.IPM_Financial__r.Global_External_Id__c);
                }
                //Regional Original Project's financial
                else if(finYr.IPM_Financial__r.Regional_Project__c!= null){
                    setRegionalOrigProjIds.add(finYr.IPM_Financial__r.Regional_Project__c);  
                }   
            }
            //Get phase & type of all original Projects
            if(!setGlobalProjExtIds.isEmpty() || !setRegionalOrigProjIds.isEmpty()){
                for(IPM_Project__c proj :[select id, Name, IPM_Phase__c, IPM_Project_Type__c from IPM_Project__c where Name in:setGlobalProjExtIds or id in :setRegionalOrigProjIds LIMIT 50000]){
                    mapProj.put(proj.id, proj);
                    mapProj.put(proj.Name, proj);                       
                }   
            }
            
            //Loop through all Financial Year records and get all invalid Parent Financials
            if(!mapExtIdFinYear.isEmpty()){
                
                getInvalidParentFinancialsGlobal(mapExtIdFinYear, mapProj);
            	getInvalidParentFinancialsRegional(mapExtIdFinYear, mapProj);
            	getInvalidParentFinancialsLocal(mapExtIdFinYear, mapProj);
            
                //Update Financials
                list<IPM_Financial__c> lstInvalidFinance = new list<IPM_Financial__c>();
                if(!setAllFinacials.isEmpty()){
                    for(string finExtId :setAllFinacials){
                        if(!setInvalidFin.isEmpty() && setInvalidFin.contains(finExtId)){
                            lstInvalidFinance.add(new IPM_Financial__c( Financial_External_ID__c = finExtId, IsFinancialInvalid__c = true));
                        }
                        else{
                            lstInvalidFinance.add(new IPM_Financial__c( Financial_External_ID__c = finExtId, IsFinancialInvalid__c = false));   
                        }
                    }   
                }
                //Upsert Financial Validation flag
                if(!lstInvalidFinance .isEmpty()){
                    upsert lstInvalidFinance Financial_External_ID__c;
                }
            }
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                'validateDefaultFinancial',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    //For Global Projects' Financials
    static void getInvalidParentFinancialsGlobal(map<string, IPM_Financial_Year__c> mapExtIdFinYear, map<string, IPM_Project__c> mapProj)
    {
    		for(string finExtId: mapExtIdFinYear.keySet())
    		{
                        
                //For Global Projects' Financials
                if(finExtId.endsWithIgnoreCase(IPM_ConstantUtils.PL_TYPE_GROSS) && mapExtIdFinYear.get(finExtId).IPM_Financial__r.Global_External_Id__c!=null){
                    //For Operational Projects
                    if(mapProj.containsKey(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Global_External_Id__c) && mapProj.get(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Global_External_Id__c).IPM_Project_Type__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
                        if(mapExtIdFinYear.get(finExtId).Turnover_Global__c <= IPM_ConstantUtils.INVALID_VALUE || ( mapExtIdFinYear.get(finExtId).Turnover_Global__c < mapExtIdFinYear.get(finExtId.replace( IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.PL_TYPE_INCREMENTAL )).Turnover_Global__c)){
                            setInvalidFin.add(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c);  
                        }
                    }
                    // For Renovation/Innovation Projects: Check if Project phase is Ideas
                    else if(mapProj.containsKey(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Global_External_Id__c) && mapProj.get(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Global_External_Id__c)!=null && mapProj.get(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Global_External_Id__c).IPM_Phase__c.equalsIgnoreCase(IPM_ConstantUtils.PHASE_IDEAS) && (mapExtIdFinYear.get(finExtId).Turnover_Global__c <= IPM_ConstantUtils.INVALID_VALUE || ( mapExtIdFinYear.get(finExtId).Turnover_Global__c < mapExtIdFinYear.get(finExtId.replace( IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.PL_TYPE_INCREMENTAL )).Turnover_Global__c))){
                        setInvalidFin.add(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c);      
                    }
                }
    		}
    }
    
    //For Regional Projects' Financials
    static void getInvalidParentFinancialsRegional(map<string, IPM_Financial_Year__c> mapExtIdFinYear, map<string, IPM_Project__c> mapProj)
    {
    		for(string finExtId: mapExtIdFinYear.keySet())
    		{
                        
               if(finExtId.endsWithIgnoreCase(IPM_ConstantUtils.PL_TYPE_GROSS) && mapExtIdFinYear.get(finExtId).IPM_Financial__r.Regional_Project__c!= null){
                            //For Operational Projects
                            if(mapProj.containsKey(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Regional_Project__c) && mapProj.get(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Regional_Project__c).IPM_Project_Type__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
                                if(mapExtIdFinYear.get(finExtId).Turnover_Regional__c <= IPM_ConstantUtils.INVALID_VALUE || ( mapExtIdFinYear.get(finExtId).Turnover_Regional__c < mapExtIdFinYear.get(finExtId.replace( IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.PL_TYPE_INCREMENTAL )).Turnover_Regional__c)){
                                    setInvalidFin.add(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c);  
                                }
                            }
                            //For Regional Original/Rollouts : Non-Key Financial year records
                            else if(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c.endsWithIgnoreCase(IPM_ConstantUtils.FINANCIAL_NONKEY ) && mapProj.containsKey(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Regional_Project__c) && mapProj.get(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Regional_Project__c)!=null && mapProj.get(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Regional_Project__c).IPM_Phase__c.equalsIgnoreCase(IPM_ConstantUtils.PHASE_IDEAS) && (mapExtIdFinYear.get(finExtId).Turnover_Regional__c <= IPM_ConstantUtils.INVALID_VALUE || ( mapExtIdFinYear.get(finExtId).Turnover_Regional__c < mapExtIdFinYear.get(finExtId.replace( IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.PL_TYPE_INCREMENTAL )).Turnover_Regional__c))){
                                setInvalidFin.add(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c);  
                            }
                            //For Regional Original/Rollouts : Key Financial year records
                            else if(!mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c.endsWithIgnoreCase(IPM_ConstantUtils.FINANCIAL_NONKEY ) && (mapExtIdFinYear.get(finExtId).Turnover_Regional__c <= IPM_ConstantUtils.INVALID_VALUE || ( mapExtIdFinYear.get(finExtId).Turnover_Regional__c < mapExtIdFinYear.get(finExtId.replace( IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.PL_TYPE_INCREMENTAL )).Turnover_Regional__c))){
                                setInvalidFin.add(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c);
                            }
               }
    		}
    }
    
    //For Local Projects' Financials
    static void getInvalidParentFinancialsLocal(map<string, IPM_Financial_Year__c> mapExtIdFinYear, map<string, IPM_Project__c> mapProj)
    {
    		for(string finExtId: mapExtIdFinYear.keySet())
    		{
               if(finExtId.endsWithIgnoreCase(IPM_ConstantUtils.PL_TYPE_GROSS) && mapExtIdFinYear.get(finExtId).IPM_Financial__r.Local_Project__c!= null && (mapExtIdFinYear.get(finExtId).Turnover_Local__c <= IPM_ConstantUtils.INVALID_VALUE || ( mapExtIdFinYear.get(finExtId).Turnover_Local__c < mapExtIdFinYear.get(finExtId.replace( IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.PL_TYPE_INCREMENTAL )).Turnover_Local__c))){
                            setInvalidFin.add(mapExtIdFinYear.get(finExtId).IPM_Financial__r.Financial_External_ID__c);
               }         
    		}
    }
    
}
