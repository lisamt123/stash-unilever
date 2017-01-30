/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Project_Document_Section__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_FinancialYearHandler implements ITrigger
{    
    public static Map<Id,IPM_Financial_Year__c> deleteFinancialYearMap = new Map<Id,IPM_Financial_Year__c>(); 
    
    public static final Set<String> FY_COPYFIELDS = new Set<String>{
    	'Advertising_Promotions_','Gross_Profit_','Profit_Before_Overheads_','Turnover_','Volume_Unit_','Volume_Tons_','Volume_','Value_Market_Share_'
	};
    //@description:Constructor
    public IPM_FinancialYearHandler ()
    {
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore()
    {
       Set<Id> deleteFinancialYearSet = new Set<Id>();
       
       if(Trigger.isDelete)
       {
            for(IPM_Financial_Year__c financialYear : (List<IPM_Financial_Year__c>)Trigger.Old)
            {
                deleteFinancialYearSet.add(financialYear.Id);
            } 
       }
       
       if(!deleteFinancialYearSet.isEmpty())
       {   
            String financialYearQuery = IPM_FinancialYearHelper.getFinancialYearQuery();
            String financialYearWhereClause = ' where Id in :deleteFinancialYearSet ';
            financialYearQuery = financialYearQuery + financialYearWhereClause;
            
            deleteFinancialYearMap = new Map<Id,IPM_Financial_Year__c>( (List<IPM_Financial_Year__c>) database.query(financialYearQuery)); 
        }    
    }
    /**
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter()
    {
       

        //Added for CR0010+CR0127
        if(Trigger.isInsert)
        {
            IPM_FinancialYearHelper.createMarketPerformance((Map<Id, IPM_Financial_Year__c>)Trigger.newMap);
        }
        else if(Trigger.isUpdate)
        {
        	Map<Id,IPM_Financial_Year__c> financialActionStandardMap = new Map<Id,IPM_Financial_Year__c>();
            Map<Id,IPM_Financial_Year__c> oldFinancialMap = (Map<Id,IPM_Financial_Year__c>) Trigger.oldMap;
            Map<String,IPM_financial_Year__c> consolidatedFinancialFYMap = IPM_FinancialYearHelper.initialiseFYConsolidation((List<IPM_Financial_Year__c>)Trigger.new,oldFinancialMap,null);
            if(!consolidatedFinancialFYMap.isEmpty())
            {
            	Set<Id> consolidatedFinancialFYIds = new Set<Id>();
            	for(IPM_financial_Year__c finFY : consolidatedFinancialFYMap.values())
	            {
	            	consolidatedFinancialFYIds.add(finFY.Id); 
	            }
	            String financialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial_Year__c',false,null,false);
	            String financialWhereClause = ' WHERE Id in :consolidatedFinancialFYIds LIMIT 50000';
	            financialQuery = financialQuery + financialWhereClause;	
	        	financialActionStandardMap = new Map<Id,IPM_Financial_Year__c>( (List<IPM_Financial_Year__c> )database.Query(financialQuery));
            }
            else
            {
            	financialActionStandardMap = (Map<Id,IPM_Financial_Year__c>)Trigger.NewMap;
            }
            IPM_FinancialYearHelper.updateFinancialActionStandard(financialActionStandardMap);
            IPM_FinancialYearHelper.updateGlobalFinancialActionStandards(financialActionStandardMap);
            
        }
        else if(Trigger.isDelete && !deleteFinancialYearMap.isEmpty()) 
        
        {
			IPM_FinancialYearHelper.initialiseFYConsolidation(null,null,deleteFinancialYearMap);
        }
		
        //Financials Hard Validations: Get all Financial External ID
        set<string> setFinExtId = new set<string>();
        if(Trigger.isInsert)
        {
            for(IPM_Financial_Year__c finYr: (list<IPM_Financial_Year__c>)Trigger.New){
            	setFinExtId.add(finYr.Financial_External_ID__c);	
        }
        }
        else if(Trigger.isUpdate && !IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED)
        {
            for(IPM_Financial_Year__c finYr: (list<IPM_Financial_Year__c>)Trigger.New)
            {
                if(finYr.Turnover_Global__c!=((IPM_Financial_Year__c) Trigger.Oldmap.get(finYr.id)).Turnover_Global__c || finYr.Turnover_Regional__c != ((IPM_Financial_Year__c) Trigger.Oldmap.get(finYr.id)).Turnover_Regional__c || finYr.Turnover_Local__c!=((IPM_Financial_Year__c)  Trigger.Oldmap.get(finYr.id)).Turnover_Local__c){
                    setFinExtId.add(finYr.Financial_External_ID__c);  
                }   
            }   
        }
        else if(Trigger.isDelete)
        {
        	for(IPM_Financial_Year__c finYr: (list<IPM_Financial_Year__c>)Trigger.Old)
		
		
		{
            	setFinExtId.add(finYr.Financial_External_ID__c);
            }
        }
			
        if(!setFinExtId.isEmpty())
		{
            IPM_FinancialYearHelper.validateDefaultFinancial(setFinExtId);
        }
        
    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void beforeInsert(SObject so) 
    {
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so)
    { 
        //This method has been included as the class implements the ITrigger interface
        
        IPM_Financial_Year__c newFinancialYear = (IPM_Financial_Year__c)so;
        
        String prefix = 'Regional';
        IF(newFinancialYear.Gate_Keeping_Model__c=='GKM3')
        {
        	prefix = 'Global';
        }
        	
    	if(newFinancialYear.get('Volume_'+prefix+'__c') != 0) 
    	{
    		newFinancialYear.Volume_Difference_Value__c = 0;
    		if( ((Decimal)newFinancialYear.get('Volume_'+prefix+'__c') - (Decimal)newFinancialYear.get('Volume_Local__c') / (Decimal)newFinancialYear.get('Volume_'+prefix+'__c') ).abs() > 0.1)
    		{
    			newFinancialYear.Volume_Difference_Value__c = ((Decimal)newFinancialYear.get('Volume_'+prefix+'__c') - (Decimal)newFinancialYear.get('Volume_Local__c')).abs();
    		}
    	}
        
    }
    
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so)
    {  
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so)
    {
      
        //This method has been included as the class implements the ITrigger interface
    }
    
    /** 
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally()
    {
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }
}