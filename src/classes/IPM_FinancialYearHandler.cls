/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Project_Document_Section__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_FinancialYearHandler implements ITrigger
{    
    public static Map<Id,IPM_Financial_Year__c> deleteFinancialYearMap = new Map<Id,IPM_Financial_Year__c>();
    
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
        Set<Id> incomingFinancialYearSet = new Set<Id>();
        Map<String,IPM_Financial_Year__c> upsertconsolidatedFinancialYearMap = new Map<String,IPM_Financial_Year__c>();

        //Added for CR0010+CR0127
        if(Trigger.isInsert)
        {
            IPM_FinancialYearHelper.createMarketPerformance((Map<Id, IPM_Financial_Year__c>)Trigger.newMap);
        }
        else if(Trigger.isUpdate)
        {
            Map<Id,IPM_Financial_Year__c> oldFinancialMap = (Map<Id,IPM_Financial_Year__c>) Trigger.oldMap;
            IPM_FinancialYearHelper.updateFinancialActionStandard((Map<Id,IPM_Financial_Year__c>) Trigger.newMap);
            IPM_FinancialYearHelper.updateGlobalFinancialActionStandards((Map<Id,IPM_Financial_Year__c>) Trigger.newMap);
            IPM_FinancialYearHelper.initialiseFYConsolidation((List<IPM_Financial_Year__c>)Trigger.new,oldFinancialMap,null,upsertconsolidatedFinancialYearMap);
        }
        else if(Trigger.isDelete && !deleteFinancialYearMap.isEmpty()) 
        { 			   			IPM_FinancialYearHelper.initialiseFYConsolidation(deleteFinancialYearMap.values(),null,deleteFinancialYearMap,upsertconsolidatedFinancialYearMap);
        }
        
        if(!upsertconsolidatedFinancialYearMap.isEmpty())
        {
            upsert upsertconsolidatedFinancialYearMap.values() External_Id__c;
        }
		
        //Financials Hard Validations: Get all Financial External ID
        set<string> setFinExtId = new set<string>();
        list<IPM_Financial_Year__c> lstFinYr = new list<IPM_Financial_Year__c>();
        if(Trigger.isInsert){
            lstFinYr = (list<IPM_Financial_Year__c>)Trigger.New;
        }
        else if(Trigger.isUpdate){
            for(IPM_Financial_Year__c finYr: (list<IPM_Financial_Year__c>)Trigger.New){
                if(finYr.Turnover_Global__c!=((IPM_Financial_Year__c) Trigger.Oldmap.get(finYr.id)).Turnover_Global__c || finYr.Turnover_Regional__c != ((IPM_Financial_Year__c) Trigger.Oldmap.get(finYr.id)).Turnover_Regional__c || finYr.Turnover_Local__c!=((IPM_Financial_Year__c)  Trigger.Oldmap.get(finYr.id)).Turnover_Local__c){
                    lstFinYr.add(finYr);    
                }   
            }   
        }
        else if(Trigger.isDelete){
            lstFinYr = (list<IPM_Financial_Year__c>)Trigger.Old;    
        }
		
		
        if(!lstFinYr.isEmpty())
		{
            for(IPM_Financial_Year__c finYear: lstFinYr){
                setFinExtId.add(finYear.Financial_External_ID__c);          
            }
			
			if(!setFinExtId.isEmpty()){
            IPM_FinancialYearHelper.validateDefaultFinancial(setFinExtId);
			}
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
        IPM_Financial_Year__c oldFinancialYear = (IPM_Financial_Year__c)oldSo;
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