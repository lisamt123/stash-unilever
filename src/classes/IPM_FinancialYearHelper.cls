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

    private static String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    
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
        
        Boolean consolidationChanged = false;  
        Map<String,Schema.SObjectField> financialYearFieldMap = Schema.SObjectType.IPM_Financial_Year__c.fields.getMap();
        
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
}