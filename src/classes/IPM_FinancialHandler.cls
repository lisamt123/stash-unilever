/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Financial__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_FinancialHandler implements ITrigger
{   
    private Map<Id,IPM_Financial__c> financialDetailMap = new Map<Id,IPM_Financial__c>();
    
    //removed DEFAULT_FINANCIAL_RECORDTYPE for SONAR Issue
    private static final String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    private static final String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId(); //Recordtype Id for Default on IPM_Financial__c object
    
    private static Map<Id,IPM_Financial__c> deleteFinancialMap = new Map<Id,IPM_Financial__c>();
    private static Map<Id,IPM_Financial_Year__c> deleteFinancialYearMap = new Map<Id,IPM_Financial_Year__c>();
    
    private static Set<Id> finCopyOverAlreadyInitiatedSet = new Set<Id>();
    
    //@description:Constructor
    public IPM_FinancialHandler() 
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
        Set<Id> deleteFinancialIDSet = new Set<Id>();
        //@@Design review - Data sharing - Code inserted for sharing the record with project owner queue 
        if(Trigger.isInsert)
        {
            IPM_FinancialHelper.updateFinanceCategory((List<IPM_Financial__c>) Trigger.new); 
        }  
        
        
        if(Trigger.isDelete)
        { 
            for(IPM_Financial__c deleteFinancial : (List<IPM_Financial__c>) Trigger.old)
            {
                deleteFinancialIDSet.add(deleteFinancial.Id);
            }
            
            String deletefinancialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial__c',false,null,false);
            String deletefinancialWhereClause = ' WHERE Id in :deleteFinancialIDSet LIMIT 50000';
            deletefinancialQuery = deletefinancialQuery + deletefinancialWhereClause;
            
            deleteFinancialMap = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>) database.query(deletefinancialQuery));
            
            String deletefinancialYearQuery = IPM_FinancialYearHelper.getFinancialYearQuery();
            String deletefinancialYearWhereClause = ' where IPM_Financial__c in :deleteFinancialIDSet LIMIT 50000';
            deletefinancialYearQuery = deletefinancialYearQuery + deletefinancialYearWhereClause;
            
            deleteFinancialYearMap = new Map<Id,IPM_Financial_Year__c>( (List<IPM_Financial_Year__c>) database.query(deletefinancialYearQuery));
        }  
    }
    
    /**
    * @description: This method checks for TLD Change and inserts/updates Consolidated Financial Years. 
                    Used for Copy over logic for default Financial Years.
                    Used for processing Financial Year records when Sustainability period changes.
                    Handles copy over logic when regional and local Projects are created.
                    Flags are moved from Financial To Financial Year Records.
    */
    
    public void bulkAfter()
    {
        Map<String,IPM_Financial_Year__c> upsertFinancialYearMap = new Map<String,IPM_Financial_Year__c>();
        Map<String,IPM_Financial__c> upsertConsolidatedFinancialMap = new Map<String,IPM_Financial__c>(); 
        List<IPM_Financial__c> consolidationChangedFinancialList = new List<IPM_Financial__c>();
        
        if(Trigger.isInsert || Trigger.isUpdate)
        {  
            List<IPM_Financial__c> newFinancialList = (List<IPM_Financial__c>) Trigger.new;
            
            
            if(Trigger.isInsert)
            {
                IPM_FinancialHelper.insertFinancialYears(newFinancialList,upsertFinancialYearMap);    
            }   
                
            if(Trigger.isUpdate) 
            { 
            	Map<Id,IPM_Financial__c> targetLaunchChangedDateMap = new Map<Id,IPM_Financial__c>();
            	
            	Map<Id,IPM_Financial__c> oldFinancialMap = (Map<Id,IPM_Financial__c>)Trigger.OldMap;
            	
            	Set<Id> changedFinancialSet = new Set<Id>();
				
		IPM_FinancialHelper.deleteFinancialYears(newFinancialList);
            	
            	for(IPM_Financial__c financial : newFinancialList)
	            {
	                IPM_Financial__c oldFinancial = oldFinancialMap.get(financial.Id); 
	            	
	            	// Only add Financial Years For Consolidated Financials.
					if(financial.isActive__c && financial.recordTypeId == DEFAULT_FINANCIAL_RECORDTYPE && 
						financial.Target_Launch_Date__c!=null && financial.Target_Launch_Date__c.year()  != oldFinancial.Target_Launch_Date__c.year() )
					{
					    targetLaunchChangedDateMap.put(financial.Id,financial); 
					    changedFinancialSet.add(financial.Id);
					}
	            }
					
				//Insert new Financial Years to Consolidated Financials when TLD is changed for any default Financial.
				if(!targetLaunchChangedDateMap.isEmpty())
				{ 
					// Stores the List of Consolidated Financial Records which are to be inserted.
					Map<String,IPM_Financial_Year__c> upsertConsolidatedFinancialYearMap = new Map<String,IPM_Financial_Year__c>(); 
					
					Map<Id,IPM_Financial_Year__c> updateFinancialYearMap = new Map<Id,IPM_Financial_Year__c>();
					
					String financialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial__c',true,new Set<String>{'IPM_Financial_Year__c'},false);
	                String financialWhereClause = ' WHERE Id in :changedFinancialSet LIMIT 50000';
	                financialQuery = financialQuery + financialWhereClause;
	                Map<Id,IPM_Financial__c> financialDetailMap = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>) database.query(financialQuery));    
	                    
	                if(!financialDetailMap.isEmpty())
	                {
	              		IPM_FinancialHelper.manageFinancialYears(targetLaunchChangedDateMap,financialDetailMap,upsertConsolidatedFinancialYearMap);	
	                	if(!upsertConsolidatedFinancialYearMap.isEmpty())
		                {
		                	upsert upsertConsolidatedFinancialYearMap.values() External_Id__c;
		                }
	                }
	                if(!targetLaunchChangedDateMap.isEmpty())
		            { 
		                IPM_FinancialHelper.updateFinancialYearTables(targetLaunchChangedDateMap,financialDetailMap,updateFinancialYearMap);

		            	if(!updateFinancialYearMap.isEmpty())
		            	{
		            		update updateFinancialYearMap.values();
		            	}
		            }
				}
				// Once the Consolidated Years have been added start the process for Calculating Everything from Strach.
                Map<Id,IPM_Financial__c> susChangedFinancialMap = new Map<Id,IPM_Financial__c>();
                Map<Id,IPM_Financial__c> volumeTypeChangedFinancialMap = new Map<Id,IPM_Financial__c>();
                Map<Id,IPM_Financial__c> approvalChangedFinancialMap = new Map<Id,IPM_Financial__c>();
                Map<Id,IPM_Financial__c> copyOverChangedFinancialMap = new Map<Id,IPM_Financial__c>();
                Map<Id,IPM_Financial__c> activeChangedFinancialMap = new Map<Id,IPM_Financial__c>();
                Map<Id,IPM_Financial__C> additionalFieldChangedFinancialMap = new Map<Id,IPM_Financial__c>();
                
                Set<String> changedFinancialFieldSet = new Set<String>();
                Map<Id,Set<String>> financialToApprovalChangeFieldMap = new Map<Id,Set<String>>();
                Map<Id,Set<String>> financialTocopyOverChangedFieldMap = new Map<Id,Set<String>>(); 
                Map<Id,Set<String>> financialToactiveChangedFieldMap = new Map<Id,Set<String>>();
                Map<Id,Set<String>> financialToaddtChangedFieldMap = new Map<Id,Set<String>>();

                // Check for Financial Action Standard Update For Sections 
                IPM_FinancialHelper.updateFinancialActionStandard((Map<Id,IPM_Financial__c>) Trigger.newMap);  
                IPM_FinancialHelper.updateGlobalFinancialActionStandards((Map<Id,IPM_Financial__c>) Trigger.newMap);   
                for(IPM_Financial__c financial : newFinancialList)
	            {
	                IPM_Financial__c oldFinancial = null;
	                
	                // Sustainability Period Change
	                oldFinancial = oldFinancialMap.get(financial.Id); 
	                
	                Integer newSustainabilityPeriod = Integer.valueOf(financial.Project_Sustainability_Period__c);
	                Integer oldSustainabilityPeriod = Integer.valueOf(oldFinancial.Project_Sustainability_Period__c);
	                
	                if(newSustainabilityPeriod != oldSustainabilityPeriod)
	                {
	                    susChangedFinancialMap.put(financial.Id,financial);
	                    changedFinancialSet.add(financial.Id);
	                }
	                
	                // Volume Type Change
	                for(String volumeTypeAPIName : IPM_FinancialHelper.VOLUME_FIELDS)  
	                {
	                    // Get the Field API for the Volume Type Field
	                    String newVolumeType = (String)financial.get(volumeTypeAPIName);
	                    String oldVolumeType = (String)oldFinancial.get(volumeTypeAPIName);
	                    
	                    // Check if the Volume Type has Changed from before. IF Yes we need to update Financial Years as well.
	                    if(newVolumeType != oldVolumeType)
	                    {
	                        volumeTypeChangedFinancialMap.put(financial.Id,financial);
	                        changedFinancialSet.add(financial.Id);
	                        break;
	                    }
	                }
	                
	                // Approval Field Changes
	                for(String approvalFieldAPI : IPM_FinancialHelper.APPROVAL_FIELDSET) 
	                {
	                    Boolean oldApprovalValue = (Boolean )oldFinancial.get(approvalFieldAPI);
	                    Boolean newApprovalValue = (Boolean )financial.get(approvalFieldAPI);
	                    if(newApprovalValue != oldApprovalValue)
	                    {
	                        approvalChangedFinancialMap.put(financial.Id,financial);
	                        changedFinancialSet.add(financial.Id);
	                        
	                        Set<String> changedFieldSet = new Set<String>(); 
	                        if(financialToApprovalChangeFieldMap.containsKey(financial.Id))
	                        {
	                            changedFieldSet = financialToApprovalChangeFieldMap.get(financial.Id);
	                        }
	                        changedFieldSet.add(approvalFieldAPI);
	                        financialToApprovalChangeFieldMap.put(financial.Id,changedFieldSet);
	                    }
	                }
	                
	                // CopyOver Field Changes
	                for(String copyOverFieldAPI : IPM_FinancialHelper.COPYOVER_FIELDSET)
                    {
                        Boolean oldCopyOverValue = (Boolean )oldFinancial.get(copyOverFieldAPI);
                        Boolean newCopyOverValue = (Boolean )financial.get(copyOverFieldAPI);
                        if(newCopyOverValue != oldCopyOverValue)
                        {
                            copyOverChangedFinancialMap.put(financial.Id,financial);
                            changedFinancialSet.add(financial.Id);
                             
                            Set<String> changedFieldSet = new Set<String>(); 
                            if(financialTocopyOverChangedFieldMap.containsKey(financial.Id))
                            {
                                changedFieldSet = financialTocopyOverChangedFieldMap.get(financial.Id);
                            }
                            changedFieldSet.add(copyOverFieldAPI);
                            financialTocopyOverChangedFieldMap.put(financial.Id,changedFieldSet);
                        }
                    }
                    
                    // CopyOver Field Changes
	                for(String additionalFieldAPI : IPM_FinancialHelper.ADDITIONAL_FIELDS)
                    {
                        String oldValue = (String)oldFinancial.get(additionalFieldAPI);
                        String newValue = (String )financial.get(additionalFieldAPI);
                        if(newValue != oldValue)
                        {
                            additionalFieldChangedFinancialMap.put(financial.Id,financial);
                            changedFinancialSet.add(financial.Id);
                             
                            Set<String> changedFieldSet = new Set<String>(); 
                            if(financialToaddtChangedFieldMap.containsKey(financial.Id))
                            {
                                changedFieldSet = financialToaddtChangedFieldMap.get(financial.Id);
                            }
                            changedFieldSet.add(additionalFieldAPI);
                            financialToaddtChangedFieldMap.put(financial.Id,changedFieldSet);
                        }
                    }
                        
                    // Active Field Changes
                    Boolean oldActiveValue = (Boolean )oldFinancial.get(IPM_FinancialHelper.ACTIVE_FIELD);
                    Boolean newActiveValue = (Boolean )financial.get(IPM_FinancialHelper.ACTIVE_FIELD);
                    if(newActiveValue != oldActiveValue)
                    {
                        activeChangedFinancialMap.put(financial.Id,financial); 
                        changedFinancialSet.add(financial.Id); 
                        
                        financialToactiveChangedFieldMap.put(financial.Id,new Set<String>{IPM_FinancialHelper.ACTIVE_FIELD});
                    }
                    
	                // Consolidation Field change
	                Set<String> changedFieldSet = IPM_FinancialUtils.isConsolidationChanged(financial.recordTypeId,financial,oldFinancial,IPM_FinancialHelper.FIELDS_TO_CONSOLIDATE,'Financial_External_ID__c'); 
	            
	                if(!changedFieldSet.isEmpty())
	                {
	                    changedFinancialFieldSet.addAll(changedFieldSet);
	                    consolidationChangedFinancialList.add(financial);   
	                    changedFinancialSet.add(financial.Id);
	                }
	            }
	             
	            if(!changedFinancialSet.isEmpty())
	            {     
	                // Get the list of financials which are eligible for Processing.
	                String financialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial__c',true,new Set<String>{'IPM_Financial_Year__c'},false);
	                String financialWhereClause = ' WHERE Id in :changedFinancialSet LIMIT 50000';
	                financialQuery = financialQuery + financialWhereClause;
	                Map<Id,IPM_Financial__c> financialDetailMap = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>) database.query(financialQuery));    
	                    
	                if(!financialDetailMap.isEmpty())
	                {
	                    // insert new financial Years based on Sustainability Period. 
	                    if(!susChangedFinancialMap.isEmpty())
	                    {
	                        IPM_FinancialHelper.processSustainabilityPeriod(susChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap);
	                    }
	                    
	                    // Update Financial Volume Type to Child Financial Years.
	                    if(!volumeTypeChangedFinancialMap.isEmpty())
	                    {
	                        IPM_FinancialHelper.updateFinancialYearVolumeType(volumeTypeChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap);
	                    }
	                    
	                    // Update Approval Fields on Financial Years
                        if(!approvalChangedFinancialMap.isEmpty()) 
                        {
                            IPM_FinancialHelper.copyOverFinancialFields(approvalChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialToApprovalChangeFieldMap);
                        }
                        
                        if(!activeChangedFinancialMap.isEmpty())
                        {
                        	IPM_FinancialHelper.copyOverFinancialFields(activeChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialToactiveChangedFieldMap);
                        }
                        
                        // Additional Field Copy Over from Financial To Financial Years
                        if(!additionalFieldChangedFinancialMap.isEmpty()) 
                        {
                        	IPM_FinancialHelper.copyOverFinancialFields(additionalFieldChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialToaddtChangedFieldMap);
                        }
                        
                        
                        // Update Copy Over values to Financial Years
                        if(!copyOverChangedFinancialMap.isEmpty())
                        {
                            IPM_FinancialHelper.copyOverFinancialFields(copyOverChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialTocopyOverChangedFieldMap);
                        }
	
	                    if(!consolidationChangedFinancialList.isEmpty())
			            {   
			                IPM_FinancialHelper.initializeConsolidation(consolidationChangedFinancialList,oldFinancialMap,financialDetailMap,upsertConsolidatedFinancialMap,changedFinancialFieldSet); 
			            }
	                }
	            }
            } 
            
            if(!upsertFinancialYearMap.isEmpty())  
	        {
	            //Insert new Financial Years to Consolidated Financials.
	            upsert upsertFinancialYearMap.values() External_ID__c;  
	        }
        }
        else
        {
            Map<String,IPM_Financial_Year__c> upsertconsolidatedFinancialYearMap = new Map<String,IPM_Financial_Year__c>();
            IPM_FinancialYearHelper.initialiseFYConsolidation(deleteFinancialYearMap.values(),null,deleteFinancialYearMap,upsertconsolidatedFinancialYearMap);
            
            if(!upsertconsolidatedFinancialYearMap.isEmpty())
            {
                upsert upsertconsolidatedFinancialYearMap.values() External_Id__c; 
            }
            deleteFinancialYearMap.clear(); 
            
            IPM_FinancialHelper.initializeConsolidation(deleteFinancialMap.values(),null,deleteFinancialMap,upsertConsolidatedFinancialMap,IPM_FinancialHelper.FIELDS_TO_CONSOLIDATE);
            deleteFinancialMap.clear();
        }
        
        if(!upsertConsolidatedFinancialMap.isEmpty())
        {
            // Remove references for Id for upsert.
            for(IPM_Financial__c financial : upsertConsolidatedFinancialMap.values())
            {
                financial.id = null;
                IPM_FinancialHelper.processLastSaved(financial);
            }
            upsert upsertConsolidatedFinancialMap.values() Financial_External_ID__c;
        }
        
        if(Trigger.isUpdate)
        {
            IPM_FinancialHelper.checkIfMisAligned((List<IPM_Financial__c>)Trigger.New,financialDetailMap);
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
        //This method has been included as the class implements the ITrigger interface && newFinancial.RecordtypeID != CONSOLIDATED_FINANCIAL_RECORDTYPE && !newFinancial.Financial_External_ID__c.contains(IPM_ConstantUtils.FINANCIAL_NONKEY) 
        
    }
    
    /**
    * @description :    This method is called iteratively for each record to be update during a BEFORE. 
                        Used for setting Copy Over Flags when regional and Local Projects are created.
    * trigger.
    * @param1   :       old sobject record
    * @param2   :       new sobject record
    */
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {   
        //This method has been included as the class implements the ITrigger interface 
        IPM_Financial__c newfinancial = (IPM_Financial__c)so;
        IPM_Financial__c oldfinancial = (IPM_Financial__c)oldSo;
        
        // If record Type is not Consolidated and Financial CopyOver has not been initiated for this Financial in same context
        if(newFinancial.RecordtypeID != CONSOLIDATED_FINANCIAL_RECORDTYPE && !finCopyOverAlreadyInitiatedSet.contains(newfinancial.Id))
        {
            if(newfinancial.Regional_Project__c !=null &&  oldfinancial.Regional_Project__c != newfinancial.Regional_Project__c )
            {
                newfinancial.Copy_Global_to_Regional__c = true;    
                finCopyOverAlreadyInitiatedSet.add(newfinancial.Id);
            }
            
            if(newfinancial.Local_Project__c !=null && oldfinancial.Local_Project__c != newfinancial.Local_Project__c)
	        {
	            newfinancial.Copy_Regional_to_Local__c = true;
	            finCopyOverAlreadyInitiatedSet.add(newfinancial.Id);
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