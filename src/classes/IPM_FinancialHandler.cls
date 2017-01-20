/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Financial__c SObject. This class implements the ITrigger
               There are no try/Catch blocks in this class for transacation management purposes. We need the transaction to be rollbacked in case of error as 
*  	       the methods in this class are invoked from trigger.
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_FinancialHandler implements ITrigger
{   

    //removed DEFAULT_FINANCIAL_RECORDTYPE for SONAR Issue
    private static final String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    private static final String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId(); //Recordtype Id for Default on IPM_Financial__c object
    
    public static final Set<String> F_COPYOVERFIELDS = new Set<String>{'BIC_','CAPEX_','NPV_','Payback_','Volume_Unit_','IRR_'};
    public static final Set<String> F_SNAPSHOTFIELDS = new Set<String>{'BIC_','CAPEX_','GM_Y1_bps_vs_DNDS_','IPM_Business_Impact_','NPV_','PBO_Y1_bps_vs_DNDS_','Payback_','Volume_Unit_','Year_3_iTO_','IRR_'};
    public static Map<Id,IPM_Financial__c> deleteFinancialMap = new Map<Id,IPM_Financial__c>();
    public static Map<Id,IPM_Financial_Year__c> deleteFinancialYearMap = new Map<Id,IPM_Financial_Year__c>();
    
    private static Set<Id> finCopyOverAlreadyInitiatedSet = new Set<Id>();
    
    private Set<Id> finIdsforProjY3iToSync = new Set<Id> (); 
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
            
            String deletefinancialQuery = IPM_FinancialHelper.getFinancialQuery();
            deletefinancialQuery = deletefinancialQuery + ' WHERE Id in :deleteFinancialIDSet LIMIT 50000';
            
            deleteFinancialMap = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>) database.query(deletefinancialQuery));
            
            String deletefinancialYearQuery = IPM_FinancialYearHelper.getFinancialYearQuery();
            deletefinancialYearQuery = deletefinancialYearQuery + ' where IPM_Financial__c in :deleteFinancialIDSet LIMIT 50000 ';
            
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
        
        List<IPM_Financial__c> misalignedFinancials = new List<IPM_Financial__c>();
        //IDs of projects associated with misalligned financials, this would be used to send chatter notifications on the event of misallignment.
       
        if(Trigger.isInsert || Trigger.isUpdate)
        {  
            List<IPM_Financial__c> newFinancialList = (List<IPM_Financial__c>) Trigger.new;
            
            
            
            
            
            if(Trigger.isInsert)
            {
                IPM_FinancialHelper.insertFinancialYears(newFinancialList,upsertFinancialYearMap);    
                
                finIdsforProjY3iToSync.addAll(Trigger.newMap.keySet());    
                
                misAlignedFinancials.addAll(IPM_FinancialHelper.updateManualMisalignment(newFinancialList));
               
                
                if(!upsertFinancialYearMap.isEmpty())
                {
                    upsert upsertFinancialYearMap.values() External_ID__c;
                }
            }   
                
            if(Trigger.isUpdate) 
            {   
            	Map<Id,IPM_Financial__c> NewTriggerMap = (Map<Id,IPM_Financial__c>)Trigger.NewMap;
                List<IPM_Financial__c> eligibleForMisalignment = new List<IPM_Financial__c>();
                
                processFinancials(newFinancialList,upsertFinancialYearMap);
                
                for(IPM_Financial__c financial : (List<IPM_Financial__c>)Trigger.new)
                {
                    IPM_Financial__c  oldFinancial = (IPM_Financial__c )Trigger.oldMap.get(financial.Id);
                    if(isFinancialChange(financial, oldFinancial))
                    {
                        finIdsforProjY3iToSync.add(financial.Id); 
                    }
                    if(checkIfMisAligned(financial,oldFinancial))
                    {
                        eligibleForMisalignment.add(financial);
                    }
                }
                misAlignedFinancials.addAll(IPM_FinancialHelper.updateManualMisalignment(eligibleForMisalignment));
                
                
                // Update Flags on Financial Years && Copy over data from Various Scopes(aye Global to Regional/ Global To charter etc)
                
                // Updating Consolidated financials first to make sure that Actual consolidation based on Default financials takes precendence. Otherwise the old consolidated data might override the calculated values. 
                if(!upsertFinancialYearMap.isEmpty())
                {
                	List<IPM_Financial_Year__c> consolidatedFYList = new List<IPM_Financial_Year__c>();
                	List<IPM_Financial_Year__c> defaultFYList = new List<IPM_Financial_Year__c>();
                	for(IPM_Financial_Year__c financialYear : upsertFinancialYearMap.values())
                	{
                		Id relatedRecordType = financialYear.IPM_AssociatedFinancialRecordTypeId__c;
	        			if(relatedRecordType == CONSOLIDATED_FINANCIAL_RECORDTYPE)
	        			{
	        				consolidatedFYList.add(financialYear);
	        			}
	        			else
	        			{
	        				defaultFYList.add(financialYear);
	        			}
                	}
                	
                	// Consolidated Financials should always skip Triggers.
                	IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
     				IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
                	upsert consolidatedFYList External_ID__c;
                	IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
                	IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
                	
                    upsert defaultFYList External_ID__c;  
                }
                Map<String,IPM_financial__c> consolidatedFinancialMap = IPM_FinancialHelper.initializeConsolidation((List<IPM_Financial__c>)Trigger.new,(Map<Id,IPM_Financial__c>)Trigger.OldMap,null);
                Map<Id,IPM_Financial__c> financialActionStandardMap = new Map<Id,IPM_Financial__c>();
                if(!consolidatedFinancialMap.isEmpty())
                {
                    Set<Id> consolidatedFinancialIdSet = new Set<Id>();
                    for(IPM_financial__c fin : consolidatedFinancialMap.values())
                    {
                        consolidatedFinancialIdSet.add(fin.Id); 
                    } 
                    String financialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial__c',false,null,false);  
                    String financialWhereClause = ' WHERE Id in :consolidatedFinancialIdSet LIMIT 50000';
                    financialQuery = financialQuery + financialWhereClause;
                    financialActionStandardMap = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>)database.Query(financialQuery));
                }
                else
                {
                    financialActionStandardMap = (Map<Id,IPM_Financial__c>)Trigger.NewMap;
                }
                IPM_FinancialHelper.updateFinancialActionStandard(financialActionStandardMap);  
                IPM_FinancialHelper.updateGlobalFinancialActionStandards(financialActionStandardMap);  
            }

        // Manual Misalignment - Set the manualMisalignment field to true if there is any misalignment between the financials at Global/Regional and Local level
            if(!misAlignedFinancials.isEmpty())
            {
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
                update misAlignedFinancials;
               
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
            }
            
              
        }
        else
        {
            
            IPM_FinancialYearHelper.initialiseFYConsolidation(null,null,deleteFinancialYearMap); 
            
            IPM_FinancialHelper.initializeConsolidation(null,null,deleteFinancialMap);
            
            finIdsforProjY3iToSync.addAll(Trigger.OldMap.keySet());

        }
        
        
        
    }
    
    /**
    * This method is to check if manual misalignment has happened.
    */
    private boolean checkIfMisAligned(IPM_Financial__c financial,IPM_Financial__c oldFinancial)
    {
         if(financial.Volume_Unit_Difference__c != oldFinancial.Volume_Unit_Difference__c ||  
            financial.NPV_Difference__c!= oldFinancial.NPV_Difference__c ||  
            financial.IRR_Difference__c != oldFinancial.IRR_Difference__c || 
            financial.Payback_Difference__c != oldFinancial.Payback_Difference__c || 
            financial.CAPEX_Difference__c != oldFinancial.CAPEX_Difference__c || 
            financial.BIC_Difference__c != oldFinancial.BIC_Difference__c ||
            financial.Total_FY_Difference__c != oldFinancial.Total_FY_Difference__c)
            {
            return true;
        }
        return false;
    }
    
    /**
    * Check to add only Financial Years For Consolidated Financials. 
    */
    private boolean checkForConsolidatedFinancial(IPM_Financial__c financial, IPM_Financial__c oldFinancial){
        if(financial.isActive__c && financial.recordTypeId == DEFAULT_FINANCIAL_RECORDTYPE && 
           financial.Target_Launch_Date__c!=null && financial.Target_Launch_Date__c.year()  != oldFinancial.Target_Launch_Date__c.year()) {
            return true;
        }
        return false;
    } 
    
    /**
    * Check financial change for projects. 
    */
    private boolean isFinancialChange(IPM_Financial__c financial, IPM_Financial__c oldFinancial) {
        if(financial.Year_3_iTO_Global__c!=oldFinancial.Year_3_iTO_Global__c || 
            financial.Year_3_iTO_Regional__c != oldFinancial.Year_3_iTO_Regional__c || 
            financial.Year_3_iTO_Local__c!=oldFinancial.Year_3_iTO_Local__c) {
                return true;
            }
        return false;
    }
    
    /**
    * Insert new Financial Years to Consolidated Financials when TLD is changed for any default Financial. 
    */
    private void insertFinancialsOnTLDChg(Map<Id,IPM_Financial__c> targetLaunchChangedDateMap){
        if(!targetLaunchChangedDateMap.isEmpty())
        { 
            Set<Id> financialIdSet = targetLaunchChangedDateMap.keySet();
            // Stores the List of Consolidated Financial Records which are to be inserted.
            Map<String,IPM_Financial_Year__c> upsertConsolidatedFinancialYearMap = new Map<String,IPM_Financial_Year__c>(); 
            
            Map<Id,IPM_Financial_Year__c> updateFinancialYearMap = new Map<Id,IPM_Financial_Year__c>();
            
            String financialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial__c',true,new Set<String>{'IPM_Financial_Year__c'},false);
            String financialWhereClause = ' WHERE Id in :financialIdSet LIMIT 50000';
            financialQuery = financialQuery + financialWhereClause;
            Map<Id,IPM_Financial__c> financialDetailMap = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>) database.query(financialQuery));    
                
            if(!financialDetailMap.isEmpty())
            {
                IPM_FinancialHelper.manageFinancialYears(targetLaunchChangedDateMap,financialDetailMap,upsertConsolidatedFinancialYearMap); 
                upsert upsertConsolidatedFinancialYearMap.values() External_Id__c;
            }
            if(!targetLaunchChangedDateMap.isEmpty())
            { 
                IPM_FinancialHelper.updateFinancialYearTables(targetLaunchChangedDateMap,financialDetailMap,updateFinancialYearMap);
                update updateFinancialYearMap.values();
            }
        }
    }
    
    /**
    * Method for sustainability period change
    */
    private void sustainabilityPeriodChange(IPM_Financial__c financial, IPM_Financial__c oldFinancial, Map<Id,IPM_Financial__c> susChangedFinancialMap, Set<Id> changedFinancialSet){
        Integer newSustainabilityPeriod = Integer.valueOf(financial.Project_Sustainability_Period__c);
        Integer oldSustainabilityPeriod = Integer.valueOf(oldFinancial.Project_Sustainability_Period__c);
        
        if(newSustainabilityPeriod != oldSustainabilityPeriod)
        {
            susChangedFinancialMap.put(financial.Id,financial);
            changedFinancialSet.add(financial.Id);
        }
    }
    
    
    /**
    * Method for volume type change 
    */
    private void volumeTypeChange(IPM_Financial__c financial, IPM_Financial__c oldFinancial, Map<Id,IPM_Financial__c> volumeTypeChangedFinancialMap, Set<Id> changedFinancialSet){
        
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
    }
    
    /**
    * Method for approval field change 
    */
    private void approvalfieldchanged(IPM_Financial__c financial, IPM_Financial__c oldFinancial, Map<Id,IPM_Financial__c> approvalChangedFinancialMap, 
                                        Set<Id> changedFinancialSet, Map<Id,Set<String>> financialToApprovalChangeFieldMap){
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
    }
    
    /**
    * Method for copy over field change 
    */
    private void copyOverFieldChange(IPM_Financial__c financial, IPM_Financial__c oldFinancial, Map<Id,IPM_Financial__c> copyOverChangedFinancialMap,
                                     Set<Id> changedFinancialSet, Map<Id,Set<String>> financialTocopyOverChangedFieldMap){
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
    }
    
    /**
    * Method for addtional field change 
    */
    private void additionalFieldChange(IPM_Financial__c financial, IPM_Financial__c oldFinancial,  Map<Id,IPM_Financial__C> additionalFieldChangedFinancialMap, 
                                        Set<Id> changedFinancialSet, Map<Id,Set<String>> financialToaddtChangedFieldMap){
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
    }
    
    /**
    * Method for active field change 
    */
    private void activeFieldChange(IPM_Financial__c financial, IPM_Financial__c oldFinancial, Map<Id,IPM_Financial__c> activeChangedFinancialMap,
                                   Set<Id> changedFinancialSet, Map<Id,Set<String>> financialToactiveChangedFieldMap){
        Boolean oldActiveValue = (Boolean )oldFinancial.get(IPM_FinancialHelper.ACTIVE_FIELD);
        Boolean newActiveValue = (Boolean )financial.get(IPM_FinancialHelper.ACTIVE_FIELD);
        if(newActiveValue != oldActiveValue)
        {
            activeChangedFinancialMap.put(financial.Id,financial); 
            changedFinancialSet.add(financial.Id); 
             
            financialToactiveChangedFieldMap.put(financial.Id,new Set<String>{IPM_FinancialHelper.ACTIVE_FIELD});
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
          String sourceCopy,targetCopy = IPM_ConstantUtils.BLANK;   
            if(newfinancial.Regional_Project__c !=null &&  oldfinancial.Regional_Project__c != newfinancial.Regional_Project__c )
            {
                newfinancial.Copy_Global_to_Regional__c = true;    
                finCopyOverAlreadyInitiatedSet.add(newfinancial.Id);
            }
            
            if(newfinancial.Local_Project__c !=null && oldfinancial.Local_Project__c != newfinancial.Local_Project__c)
            {   
                if(newfinancial.Regional_Project__c != null)
                {
                    newfinancial.Copy_Regional_to_Local__c = true;
                }
                else
                {
                    newfinancial.Copy_Global_to_Local__c = true; 
                }
                
                finCopyOverAlreadyInitiatedSet.add(newfinancial.Id);
            }
            
            if((oldfinancial.Copy_Global_to_Regional__c != newfinancial.Copy_Global_to_Regional__c) &&  newfinancial.Copy_Global_to_Regional__c)
      {
        sourceCopy = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
              targetCopy = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;  
      }
            else if((oldfinancial.Copy_Regional_to_Local__c != newfinancial.Copy_Regional_to_Local__c) && newfinancial.Copy_Regional_to_Local__c)
      {
        sourceCopy = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
              targetCopy = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
      }
            else if((oldfinancial.Copy_Global_to_Local__c != newfinancial.Copy_Global_to_Local__c) && newfinancial.Copy_Global_to_Local__c)
      {
        sourceCopy = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
              targetCopy = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;  
      }
            else if((oldfinancial.Copy_Local_to_Global__c != newfinancial.Copy_Local_to_Global__c) && newfinancial.Copy_Local_to_Global__c)
      {
      sourceCopy = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
              targetCopy = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;  
      }
            else if((oldfinancial.Copy_Local_to_Regional__c != newfinancial.Copy_Local_to_Regional__c) && newfinancial.Copy_Local_to_Regional__c)
      {
        sourceCopy = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
              targetCopy = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;  
      }
      if(String.isNotBLank(targetCopy))
      {
              for(String FieldPrefix : F_COPYOVERFIELDS)
          {
            newFinancial.put(FieldPrefix+targetCopy+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX,newfinancial.get(FieldPrefix+sourceCopy+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX));
          } 
      }
        }
        
        // Moved This Logic Outside as consolidated Financial Values also need to copy Over snapshots.
        String targetSnapshot = IPM_ConstantUtils.BLANK;
        String sourceSnapShot = newfinancial.IPM_Financial_Postfix__c;
        
        if(!oldfinancial.Charter_Approved__c && newfinancial.Charter_Approved__c)
        {
          targetSnapshot = IPM_ConstantUtils.FIELD_SUFFIX_CHARTER;
        }
        else if(!oldfinancial.Contract_Approved__c && newfinancial.Contract_Approved__c)
        {
          targetSnapshot = IPM_ConstantUtils.FIELD_SUFFIX_CONTRACT;
        }
       else if(!oldfinancial.MR_Approved__c && newfinancial.MR_Approved__c)
        {
          targetSnapshot = IPM_ConstantUtils.FIELD_SUFFIX_MARKET_READY;
        }
       else if(!oldfinancial.MD_Approved__c && newfinancial.MD_Approved__c)
        {
          targetSnapshot = IPM_ConstantUtils.FIELD_SUFFIX_MARKET_DEPLOYMENT;
        }
        
        if(String.isNotBlank(targetSnapshot))
        {
          for(String FieldPrefix : F_SNAPSHOTFIELDS)
          {
            String sourcePrefix= FieldPrefix;
            String targetPrefix  = FieldPrefix;
            if(FieldPrefix == 'IPM_Business_Impact_')
            {
              sourcePrefix = 'Business_Impact_';
            }
            newFinancial.put(targetPrefix+targetSnapshot+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX,newFinancial.get(sourcePrefix+sourceSnapShot+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX));   
          }
      newFinancial.put(targetSnapshot+'_Locked'+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX,true);
        }
    }
    
    /**
    * @description :    This method is called for performing all the neccessary checking of fields to validate if Fields are changed and udpates consolidation.
    * @param1   :       Trigger.New
    * @param2   :       upsert Financial Year Map 
    * @param3   :       upsert Consolidated Map
    * @param4   :       changed financial List
    */
    private void processFinancials(List<IPM_Financial__c> newFinancialList, Map<String,IPM_Financial_Year__c> upsertFinancialYearMap)
    {
        
            Map<Id,IPM_Financial__c> targetLaunchChangedDateMap = new Map<Id,IPM_Financial__c>();
            Map<Id,IPM_Financial__c> oldFinancialMap = (Map<Id,IPM_Financial__c>)Trigger.OldMap;
            Set<Id> changedFinancialSet = new Set<Id>();
        IPM_FinancialHelper.deleteFinancialYears(newFinancialList,oldFinancialMap);
            for(IPM_Financial__c financial : newFinancialList)
            {
                IPM_Financial__c oldFinancial = oldFinancialMap.get(financial.Id); 
                // Only add Financial Years For Consolidated Financials.
                if(checkForConsolidatedFinancial(financial, oldFinancial))
                {
                    targetLaunchChangedDateMap.put(financial.Id,financial); 
                    changedFinancialSet.add(financial.Id);
                }
             
            }
            //Insert new Financial Years to Consolidated Financials when TLD is changed for any default Financial.
            insertFinancialsOnTLDChg(targetLaunchChangedDateMap);
            // Once the Consolidated Years have been added start the process for Calculating Everything from Strach.
            Map<Id,IPM_Financial__c> susChangedFinancialMap = new Map<Id,IPM_Financial__c>();
            Map<Id,IPM_Financial__c> volumeTypeChangedFinancialMap = new Map<Id,IPM_Financial__c>();
            Map<Id,IPM_Financial__c> approvalChangedFinancialMap = new Map<Id,IPM_Financial__c>();
            Map<Id,IPM_Financial__c> copyOverChangedFinancialMap = new Map<Id,IPM_Financial__c>();
            Map<Id,IPM_Financial__c> activeChangedFinancialMap = new Map<Id,IPM_Financial__c>();
            Map<Id,IPM_Financial__C> additionalFieldChangedFinancialMap = new Map<Id,IPM_Financial__c>();
            
            Map<Id,Set<String>> financialToApprovalChangeFieldMap = new Map<Id,Set<String>>();
            Map<Id,Set<String>> financialTocopyOverChangedFieldMap = new Map<Id,Set<String>>(); 
            Map<Id,Set<String>> financialToactiveChangedFieldMap = new Map<Id,Set<String>>();
            Map<Id,Set<String>> financialToaddtChangedFieldMap = new Map<Id,Set<String>>();
            // Check for Financial Action Standard Update For Sections 
            for(IPM_Financial__c financial : newFinancialList)
            {
                IPM_Financial__c oldFinancial = null;
                oldFinancial = oldFinancialMap.get(financial.Id); 
                // Sustainability Period Change
                sustainabilityPeriodChange(financial, oldFinancial, susChangedFinancialMap, changedFinancialSet);
                // Volume Type Change
                volumeTypeChange(financial, oldFinancial, volumeTypeChangedFinancialMap, changedFinancialSet);
                // Approval Field Changes
                approvalfieldchanged(financial, oldFinancial, approvalChangedFinancialMap, changedFinancialSet, financialToApprovalChangeFieldMap);
                // CopyOver Field Changes
                copyOverFieldChange(financial, oldFinancial, copyOverChangedFinancialMap, changedFinancialSet, financialTocopyOverChangedFieldMap);
                
                // addtional Field Changes
                additionalFieldChange(financial, oldFinancial, additionalFieldChangedFinancialMap, changedFinancialSet, financialToaddtChangedFieldMap);
                // Active Field Changes
                activeFieldChange(financial, oldFinancial, activeChangedFinancialMap, changedFinancialSet, financialToactiveChangedFieldMap);
            
        
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
                    IPM_FinancialHelper.processSustainabilityPeriod(susChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap);
                    // Update Financial Volume Type to Child Financial Years.
                    IPM_FinancialHelper.updateFinancialYearVolumeType(volumeTypeChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap);
                    // Update Approval Fields on Financial Years
                    IPM_FinancialHelper.copyOverFinancialFields(approvalChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialToApprovalChangeFieldMap);
                    IPM_FinancialHelper.copyOverFinancialFields(activeChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialToactiveChangedFieldMap);
                    // Additional Field Copy Over from Financial To Financial Years
                    IPM_FinancialHelper.copyOverFinancialFields(additionalFieldChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialToaddtChangedFieldMap);
                    // Update Copy Over values to Financial Years
                    IPM_FinancialHelper.copyOverFinancialFields(copyOverChangedFinancialMap,oldFinancialMap,financialDetailMap,upsertFinancialYearMap,financialTocopyOverChangedFieldMap);
                
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
        if(!finIdsforProjY3iToSync.isEmpty())
        {
            IPM_FinancialHelper.updateAssoProjectY3iToValue(finIdsforProjY3iToSync); 
        }
        if(Trigger.isDelete && Trigger.isAfter)
        {
        	deleteFinancialMap.clear();
        	deleteFinancialYearMap.clear();
        } 
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger  
        ExceptionLoggingHelper.insertLogRecordList();
    }
}