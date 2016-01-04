/**
@Author Cognizant
@Name IPM_RolloutPlansTableController
@CreateDate 27/04/2015
@Description This class is used for managing the trigger methods for IPM_Project_Rollout__c object 
@Version 1.0
@reference IPM_ProjectRolloutHandler class
*/

public with sharing class IPM_RolloutTriggerHandler 
{    
    private String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
    private String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
    private String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
    private String CONSOLIDATED_FINANCIAL_RECORDTYPE =Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    public static Boolean RECURSIVE_CONTEXT = false;
    
    private Set<String> localRolloutCountrySet;
    
    private Set<String> setDeleteFinancialExternalIds;
    private Map<String, IPM_Financial__c> mapUpsertFinancials;
    
    private Map<Id,IPM_Project_Rollout__c> deleteRolloutMap;
    private Map<String,IPM_Project_Rollout__c> rolloutUpdateMap;
    
    
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    
    /*****************************************************************************************************************************
    * @description      Constructor
    */
    public IPM_RolloutTriggerHandler(){     
        mapUpsertFinancials = new Map<String, IPM_Financial__c>();
                
        deleteRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        rolloutUpdateMap = new Map<String,IPM_Project_Rollout__c>();
        localRolloutCountrySet = new Set<String>();
        setDeleteFinancialExternalIds = new Set<String>();
        
        
    }
    
    /*****************************************************************************************************************************
    * @description                  Method to handle before delete Trigger context for 
    *                               IPM_Project_Rollout__c object
    * @param lstProjectRollouts     List of Trigger.old records 
    */
    public void processDelete(List<IPM_Project_Rollout__c> lstProjectRollouts)
    {
        Set<String> setRegionalRolloutNames = new Set<String>();
        Set<String> setRegionalProjectNames = new Set<String>(); 
        
        Set<String> setCurrentRolloutIds = new Set<String>();        
        Set<String> setInActiveFinancialExternalIds = new Set<String>();
        
        // Validate if there are any countries which are charter approved or inactive. Only charter Approved countries can be inactive.
        for(IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
        {
            if(projectRollout.IPM_CharterApproved__c)
            {
               projectRollout.addError('Cannot Delete Charter Approved Rollouts'); 
            }    
        }
         
        for(IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
        {
            setCurrentRolloutIds.add(projectRollout.Id);
            
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE) 
            {
                // Add to Regional Rollout List for Getting related data
                setRegionalRolloutNames.add(projectRollout.IPM_Rollout_Project__c);
            } 
            else
            { 
                if(projectRollout.Regional_Project__c!=null)
                {
                    setRegionalProjectNames.add(projectRollout.Regional_Rollout_External_Id__c);
                }
                else
                {
                    // Add to Regional Rollout List for Getting related data
                    setRegionalRolloutNames.add(projectRollout.Regional_Rollout_External_Id__c);
                }
                
                // Add composite list of Local Rollouts to the list for getting country specific data. 
                localRolloutCountrySet.add(projectRollout.IPM_Rollout_Project__c);
            }           
        }
         
        if(!setRegionalRolloutNames.isEmpty())
        {
            List<IPM_Project_Rollout__c> compositeRolloutsList = [SELECT Id, IPM_Rollout_Project__c,IPM_Project__r.IPM_Phase__c,Regional_Rollout__c,isActive__c,Added_At_Stage__c,IPM_CharterApproved__c,Regional_Rollout_External_Id__c,IPM_Regional_Rollout_Status__c,
                                                                    (SELECT Id,IPM_Rollout_Project__c,KeyMCO__c,isActive__c,Added_At_Stage__c,IPM_CharterApproved__c,Regional_Rollout__c,Regional_Rollout_External_Id__c FROM Local_Rollouts__r),
                                                                    (SELECT Id,Financial_External_Id__c,isActive__c,Charter_Approved__c,Added_At_Stage__c FROM IPM_Financials__r)
                                                                    FROM IPM_Project_Rollout__c
                                                                    WHERE IPM_Rollout_Project__c IN: setRegionalRolloutNames Limit 50000]; 
                                                            
            for(IPM_Project_Rollout__c regionalRollout : compositeRolloutsList)
            {
                //REGIONAL ROLLOUT BEING DELETED
                if(setCurrentRolloutIds.contains(regionalRollout.Id))
                {
                    //Add All Local Rollouts which are not being deleted
                    for (IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r)   
                    {
                        if(!setCurrentRolloutIds.contains(localRollout.Id) && localRollout.isActive__c)
                        {
                            deleteRolloutMap.put(localRollout.Id,localRollout); 
                            localRolloutCountrySet.add(localRollout.IPM_Rollout_Project__c);    
                        }    
                    }

                    //Add All Regional Financials for deletion 
                    for(IPM_Financial__c ipmFinancial : regionalRollout.IPM_Financials__r)
                    {
                        // While deleting system would check for charter Approved.
                        setDeleteFinancialExternalIds.add(ipmFinancial.Financial_External_Id__c);
                    }                
                }
                //REGIONAL ROLLOUT NOT BEING DELETED
                else 
                {
                    removeRolloutAssociations(setCurrentRolloutIds,regionalRollout,null);
                }           
            }
        }
        
        if(!setRegionalProjectNames.isEmpty())
        {
            List<IPM_Project__c> compositeProjectList = [SELECT Id,IPM_Project_Name__c,IPM_Phase__c,
                                                            (SELECT Id,IPM_Rollout_Project__c,KeyMCO__c,isActive__c,IPM_CharterApproved__c,Added_At_Stage__c,Regional_Rollout_External_Id__c FROM Regional_Project_Rollout__r)
                                                            FROM IPM_Project__c
                                                            WHERE IPM_Project_Name__c IN: setRegionalProjectNames Limit 50000];
            
            for(IPM_Project__c project :compositeProjectList)
            {
                removeRolloutAssociations(setCurrentRolloutIds,null,project);
            }
        } 
        
        
        // Delete Associated Financials.
        deleteAssociatedFinancials();
        
        // Delete Associated Countries.
        deleteAssociatedCountries(localRolloutCountrySet);
        
        
        if(!rolloutUpdateMap.isEmpty())
        {
            update rolloutUpdateMap.values();
        }    
        
        if(!deleteRolloutMap.isEmpty() && !IPM_RolloutTriggerHandler.RECURSIVE_CONTEXT)
        {                             
            RECURSIVE_CONTEXT = true;
            delete deleteRolloutMap.values();
        }
        
        IPM_ProcessRolloutStatusAndDates.execute(new Set<Id>(), new Set<Id>(), setCurrentRolloutIds);  // deletion              
    }
    
    /*****************************************************************************************************************************
    * @description                  Method to handle after insert Trigger context for 
    *                               IPM_Project_Rollout__c object
    * @param lstProjectRollouts     List of Trigger.new records
    */
    public  void processInsert(List<IPM_Project_Rollout__c> lstProjectRollouts)
    {
        Set<Id> setGlobalProjectIds = new Set<Id>();
        Set<Id> setRegionalOriginalProjectIds = new Set<Id>();
        
        // Process financials only when Rollout has a parent project attached to it. 
        // For regional Rollouts it would be Global Project and For local Rollouts it would be parent Project plus regional project 
        
        Map<String,Schema.SObjectField> fieldTypeMap = Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap();

        String rolloutQuery = ' SELECT ';        
        for(String fieldAPIName : fieldTypeMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = fieldTypeMap.get(fieldAPIName).getDescribe();
            
            if(fieldDescribe.isCustom()  && fieldAPIName != 'Id')
            {
                rolloutQuery += ' '+fieldAPIName+',';
            }
        }
        rolloutQuery = rolloutQuery +'Regional_Rollout__r.IPM_Project__c,Regional_Project__r.IPM_Parent_Project__c,Name,RecordTypeId,Id FROM IPM_Project_Rollout__c ';
        String rolloutWhereClause = ' WHERE Id in :lstProjectRollouts LIMIT 50000';
        rolloutQuery = rolloutQuery + rolloutWhereClause;
        
        lstProjectRollouts = database.query(rolloutQuery);
        
        for (IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
        {       
            ///Regional Rollout. Validate consolidated financials is present or not. If no create one.
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
            {
                IPM_Financial__c newFinancial;
                
                String financialExternalId = projectRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                               
                createRolloutFinancials(financialExternalId,CONSOLIDATED_FINANCIAL_RECORDTYPE,projectRollout,mapUpsertFinancials);
                
            }             
            else 
            {
                String financialExternalId = IPM_Utils.getFinancialExternalId(projectRollout); 
				
                createRolloutFinancials(financialExternalId,DEFAULT_FINANCIAL_RECORDTYPE,projectRollout,mapUpsertFinancials);
                
                //PROCESS ROLLOUTS FOR THE ROLLOUT STATUS
                if(projectRollout.IPM_Project__c != null)
                {
                    setGlobalProjectIds.add(projectRollout.IPM_Project__c);
                }
                else if (projectRollout.Regional_Project__r.IPM_Parent_Project__c != null)
                {
                    setGlobalProjectIds.add(projectRollout.Regional_Project__r.IPM_Parent_Project__c);
                }
                
                else if (projectRollout.Regional_Project__c != null)
                {
                    setRegionalOriginalProjectIds.add(projectRollout.Regional_Project__c);
                }
                
            }
        }
        
        if (mapUpsertFinancials != NULL && !mapUpsertFinancials.isEmpty())
        {
                upsert mapUpsertFinancials.values() IPM_Financial__c.Financial_External_Id__c ;
                
                if((setGlobalProjectIds != NULL && !setGlobalProjectIds.isEmpty()) || (setRegionalOriginalProjectIds != NULL && !setRegionalOriginalProjectIds.isEmpty()))
                {
                    IPM_ProcessRolloutStatusAndDates.execute(setGlobalProjectIds, setRegionalOriginalProjectIds);// insertion
                }
        }
    }

    /*****************************************************************************************************************************
    * @description                      Method to handle after update Trigger context for 
    *                                   IPM_Project_Rollout__c object
    * @param mapNewProjectRollouts      List of Trigger.new records
    * @param mapOldProjectRollouts      List of Trigger.old records
    */
    public void processUpdate(Map<Id, IPM_Project_Rollout__c> mapNewProjectRollouts, Map<Id, IPM_Project_Rollout__c> mapOldProjectRollouts)
    {
        mapUpsertFinancials = new Map<String, IPM_Financial__c>();
        
        Set<String> setRegionalRolloutNames = new Set<String>();
        Set<String> setRegionalProjectNames = new Set<String>();
        
      
        for(IPM_Project_Rollout__c projectRollout : mapNewProjectRollouts.values())
        {   
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE && projectRollout.IPM_Project__c !=null)
            {
                setRegionalRolloutNames.add(projectRollout.IPM_Rollout_Project__c);
                
            }
            else if(projectRollout.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
            {
                // If it is associated with Regional Rollout, It means we are working with Global Original Rollout Project.
                if(projectRollout.regional_Rollout__c !=null)
                {
                    setRegionalRolloutNames.add(projectRollout.Regional_Rollout_External_Id__c);
                }
                else // It is a regional Original Project
                {
                    setRegionalProjectNames.add(projectRollout.Regional_Rollout_External_Id__c);
                }
            }
        }
        
        List<IPM_Project_Rollout__c> lstProjRegRollouts = [SELECT Id, IPM_Rollout_Project__c,IPM_Project__c,IPM_Regional_Rollout_Status__c,IPM_Project__r.IPM_Phase__c,isActive__c,Added_At_Stage__c,Regional_Project__c,Regional_Project__r.IPM_Phase__c,Target_Launch_Date__c,Calculated_Sustainability_Period__c,Regional_Rollout__c,IPM_Regional_Original_Project__c,Regional_Rollout_External_Id__c,
                                                            (SELECT Id,IPM_Regional_Rollout_Status__c,IPM_Rollout_Project__c,isActive__c,IPM_Project__c,Added_At_Stage__c,KeyMCO__c,Regional_Project__c,Target_Launch_Date__c,Regional_Rollout__c,IPM_Regional_Original_Project__c,Calculated_Sustainability_Period__c,Regional_Rollout_External_Id__c,Regional_Rollout__r.IPM_Project__c,Regional_Project__r.IPM_Parent_Project__c FROM Local_Rollouts__r), 
                                                            (SELECT Id,isActive__c,Added_At_Stage__c,Financial_External_Id__c FROM IPM_Financials__r) FROM IPM_Project_Rollout__c 
                                                            WHERE IPM_Rollout_Project__c IN: setRegionalRolloutNames Limit 50000];
                                                                                                  
        for(IPM_Project_Rollout__c regionalRollout : lstProjRegRollouts)
        {
            updateRolloutAssociations(mapOldProjectRollouts,regionalRollout,null);
        }
        
        if(!setRegionalProjectNames.isEmpty()) 
        { 
            List<IPM_Project__c> lstRegionalProjects = [SELECT Id,IPM_Project_Name__c,IPM_Target_Launch_Dates__c,Sustainability_Period__c,IPM_Phase__c,
                                                       (SELECT Id,IPM_Rollout_Project__c,isActive__c,Added_At_Stage__c,KeyMCO__c,Regional_Project__c,IPM_Project__c,IPM_Regional_Original_Project__c,Target_Launch_Date__c,Calculated_Sustainability_Period__c,Regional_Rollout__c,Regional_Rollout_External_Id__c,Regional_Rollout__r.IPM_Project__c,Regional_Project__r.IPM_Parent_Project__c FROM Regional_Project_Rollout__r),
                                                       (SELECT Id,isActive__c,Added_At_Stage__c,Financial_External_Id__c FROM IPM_Financials_Regional__r) FROM IPM_Project__c
                                                       WHERE IPM_Project_Name__c IN: setRegionalProjectNames Limit 50000];
            
        
            for(IPM_Project__c regionalProject : lstRegionalProjects)
            {
                updateRolloutAssociations(mapOldProjectRollouts,null,regionalProject);
            }
        }

        //For Rollout Status Updates
        Set<Id> setGlobalProjectIds = new Set<Id>();
        Set<Id> setRegionalOriginalProjectIds = new Set<Id>();
        
        for(IPM_Project_Rollout__c newRollout : mapNewProjectRollouts.values())
        {
            if(newRollout.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
            {
                Id regionalRollout = newRollout.Regional_Rollout__c;
                
                IPM_Project_Rollout__c oldRollout = mapOldProjectRollouts.get(newRollout.Id);
                
                //Rollout Status
                if(newRollout.Target_Launch_Date__c != oldRollout.Target_Launch_Date__c)
                {
                    //PROCESS ROLLOUTS FOR THE ROLLOUT STATUS
                    if(newRollout.IPM_Project__c != null)
                    {
                        setGlobalProjectIds.add(newRollout.IPM_Project__c);
                        
                    }
                    else if (newRollout.Regional_Project__r.IPM_Parent_Project__c != null)
                    {
                        setGlobalProjectIds.add(newRollout.Regional_Project__r.IPM_Parent_Project__c);
                       
                    }
                    else if (newRollout.Regional_Project__c != null)
                    {
                        setRegionalOriginalProjectIds.add(newRollout.Regional_Project__c);    
                    }
                }
            }
        }

        deleteAssociatedFinancials();
        
        deleteAssociatedCountries(localRolloutCountrySet);
        
        if (!mapUpsertFinancials.isEmpty())
        {
            upsert mapUpsertFinancials.values() IPM_Financial__c.Financial_External_Id__c; 
        }
            
        if((!setGlobalProjectIds.isEmpty()) || (setRegionalOriginalProjectIds != NULL && !setRegionalOriginalProjectIds.isEmpty()))
        {
            IPM_ProcessRolloutStatusAndDates.execute(setGlobalProjectIds, setRegionalOriginalProjectIds); // updation
        }
    
            // EPIC172 implementation start 
        Map<ID,IPM_Project_Rollout__c> updatedRollouts = new Map<ID,IPM_Project_Rollout__c>();
        for(IPM_Project_Rollout__c rollout: mapNewProjectRollouts.values()) 
        {
            if ( rollout.Target_Launch_Date__c != mapOldProjectRollouts.get(rollout.Id).Target_Launch_Date__c ) 
            {
                updatedRollouts.put(rollout.Id,rollout);
            }
        }
           
        if(updatedRollouts.size()>0) 
        {
            IPM_SyncFinanceTableTLD syncFinanceTableTLD = new IPM_SyncFinanceTableTLD();
            syncFinanceTableTLD.syncProjectRolloutFinancialTLD(updatedRollouts);
        }
          //  EPIC172 implementation end 
       
    }
            
    /**********************************************************************************************************************************
    * @description                      Method to handle before update Trigger context for 
    *                                   IPM_Project_Rollout__c object to update the owner id of rollout to queue id (owner of project)
    * @param NewProjectRollouts         List of Trigger.new records
    */
    
    public void OnBeforeInsert(List<IPM_Project_Rollout__c> NewProjectRollouts)
    {
        //@@Design Review Changes
        set<id> projectidset = new set<id>();
        
        for(IPM_Project_Rollout__c projectRollout : NewProjectRollouts)
        {
            if(projectRollout.IPM_Project__c != null)
            {
                projectidset.add(projectRollout.IPM_Project__c);
            }
            else if(projectRollout.Regional_Project__c!=null)
            {
                projectidset.add(projectRollout.Regional_Project__c);
            }
            else if(projectRollout.Local_Project__c!=null)
            {
                projectidset.add(projectRollout.Local_Project__c);
            }
        }
        
        if(projectidset != null && projectidset.size()>0)
        {
            for(IPM_Project__c proj: [select id, ownerid, IPM_Category_Text__c from IPM_Project__c where id IN:projectidset])
            {
                for(IPM_Project_Rollout__c projectRollout : NewProjectRollouts)
                {
                    
                    if((projectRollout.IPM_Project__c!=null && projectRollout.IPM_Project__c == proj.id) ||
                        (projectRollout.Regional_Project__c!=null && projectRollout.Regional_Project__c== proj.id) ||
                        (projectRollout.Local_Project__c!=null && projectRollout.Local_Project__c== proj.id)
                    )
                    {
                        projectRollout.ownerid=proj.ownerid;
                        projectRollout.IPM_Small_C__c = proj.IPM_Category_Text__c;
                    }
                    
                }
                
            }
            
        }
        
    }
    
    public static void udpateAsyncJobId(Set<Id>phaseChangeRolloutSet, Id JobId)
    {
        Map<Id,IPM_Project_Rollout__c> updateAsyncJobIdRolloutMap = new Map<Id,IPM_Project_Rollout__c>(); 
        for(Id rolloutId : phaseChangeRolloutSet)
        {
            IPM_Project_Rollout__c projectRollout = new IPM_Project_Rollout__c(Id=rolloutId,IPM_PhaseChangeQueueJobId__c = JobId);
            updateAsyncJobIdRolloutMap.put(rolloutId,projectRollout);
        }
        
        if(updateAsyncJobIdRolloutMap.size() > 0)
        {
            SKIP_TRIGGER_EXECUTION = true;
            update updateAsyncJobIdRolloutMap.values();
            SKIP_TRIGGER_EXECUTION = false;
        }
    }
    
    
   
    
    /*******************************************************************************************************
    * @description              Method to get Creating Financials.
    * @param projectRollout     List of Trigger.old records
    * @param projectRollout     Rollout whose local Rollouts would result in Financial/Country updates
    * @param projectRollout     Project whose local Rollouts would result in Financial/Country updates
    */
    
    public void updateRolloutAssociations(Map<Id, IPM_Project_Rollout__c> oldRolloutsMap,IPM_Project_Rollout__c regionalRollout,IPM_Project__c regionalProject)
    {
        // Financial NON-KEY external Id as it is based on Regional Rollout Level
        String financialNonKeyExternalId = null;
        
        Map<String,IPM_Financial__c> financialExistingMap = new Map<String,IPM_Financial__c>();
        
        List<IPM_Financial__c> associatedfinancials = new List<IPM_Financial__c>();
        List<IPM_Project_Rollout__c> associatedlocalRollouts = new List<IPM_Project_Rollout__c>();
        
        if(regionalRollout!=null)
        {
            financialNonKeyExternalId = regionalRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            associatedfinancials = regionalRollout.IPM_Financials__r;
            associatedlocalRollouts = regionalRollout.Local_Rollouts__r;
        }
        else
        {
            financialNonKeyExternalId = regionalProject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            associatedfinancials = regionalProject.IPM_Financials_Regional__r;
            associatedlocalRollouts = regionalProject.Regional_Project_Rollout__r;
        }
        
        // Get the nonKey financials for this Rollout
        for(IPM_Financial__c ipmFinancial : associatedfinancials)
        {
            financialExistingMap.put(ipmFinancial.Financial_External_Id__c,ipmFinancial);
        }
            
        IPM_Financial__c nonKeyFinancial = financialExistingMap.get(financialNonKeyExternalId);
        
        // Check if non Key Should be retained/Created based on whether there are non Key MCO's present. 
        Boolean  nonkeyActiveRolloutExists = false;
        
        for(IPM_Project_Rollout__c localRollout : associatedlocalRollouts)
        {
            String financialExternalId = IPM_Utils.getFinancialExternalId(localRollout); 
            
            IPM_Project_Rollout__c oldProjectRollout = oldRolloutsMap.get(localRollout.Id);
            
            if(oldProjectRollout != null)
            {
                // If Rollout is a key financial or Non Key financial which has parent Project(After Charter non Key breaks into individual Financials)
                if(localRollout.KeyMCO__c || (!localRollout.KeyMCO__c  && localRollout.Regional_Project__c != null) )
                {
                    // Only Create Financials if Rollout is active.
                    if(localRollout.isActive__c)
                    {
	                    // If rollout was a non Key Rollout before, create Key Financials for Key Rollouts. 
	                    // OR If rollout was inactive and now made Active,update Key financials to active.
	                    if( (localRollout.KeyMCO__c && localRollout.KeyMCO__c != oldProjectRollout.KeyMCO__c) || (localRollout.isActive__c != oldProjectRollout.isActive__c ) )
	                    {
	                        createRolloutFinancials(financialExternalId,DEFAULT_FINANCIAL_RECORDTYPE,localRollout,financialExistingMap);
	                    }
                    }
                    
                    // If rollout was active before and now made inactive ,remove/inactivate Key financials.
                    if(!localRollout.isActive__c && localRollout.isActive__c != oldProjectRollout.isActive__c)
                    {
                        removeKeyFinancials(financialExternalId,localRollout,financialExistingMap);
                        localRolloutCountrySet.add(localRollout.IPM_Rollout_Project__c);   
                    }
                }
                else
                {
                    // If Rollout was a key Before,we need to remove Key Financials.
                    if(localRollout.KeyMCO__c != oldProjectRollout.KeyMCO__c)
                    {
                        String financialOldExternalId = IPM_Utils.getFinancialExternalId(oldProjectRollout);
                        removeKeyFinancials(financialOldExternalId,localRollout,financialExistingMap);        
                    }
                } 
            }  
            
            // For Checking if Non Key Exists currently and whether to retain Non Key financial or not.
            if(!localRollout.KeyMCO__c)
            {
                if(localRollout.isActive__c) 
                {
                    nonkeyActiveRolloutExists = true;
                }
            }          
        }
        
        if(nonKeyFinancial == null)
        {
            nonKeyFinancial = new IPM_Financial__c(
                                                    RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                                                    Financial_External_ID__c = financialNonKeyExternalId,
                                                    isActive__c = true
                                                  );
                                                                  
            if(regionalRollout!=null)
            {
                nonKeyFinancial.Target_Launch_Date__c = regionalRollout.Target_Launch_Date__c;
                nonKeyFinancial.IPM_Project_Rollout__c = regionalRollout.Id;
                nonKeyFinancial.Project_Sustainability_Period__c = regionalRollout.Calculated_Sustainability_Period__c;
                nonKeyFinancial.Added_At_Stage__c = regionalRollout.Added_At_Stage__c;
            }
            else
            {
                nonKeyFinancial.Target_Launch_Date__c = regionalProject.IPM_Target_Launch_Dates__c; 
                nonKeyFinancial.Project_Sustainability_Period__c = regionalProject.Sustainability_Period__c;
                nonKeyFinancial.Added_At_Stage__c = regionalProject.IPM_Phase__c;
            }
        }
            
        if(nonkeyActiveRolloutExists)
        {
            mapUpsertFinancials.put(financialNonKeyExternalId, nonKeyFinancial);
        }     
        else
        {
            setDeleteFinancialExternalIds.add(financialNonKeyExternalId);
        }
    }
    
    // Generate financials for Rollouts based on Params 
    public void createRolloutFinancials(String financialExternalId,String financialRecordType, IPM_Project_Rollout__c projectRollout,Map<String,IPM_Financial__c> financialExistingMap)
    {
        IPM_Financial__c projectFinancials = null;
        
        if(financialExistingMap!=null && financialExistingMap.containsKey(financialExternalId))
        {
           projectFinancials =  financialExistingMap.get(financialExternalId);
           if(!projectFinancials.isActive__c)
           {
               projectFinancials.isActive__c = true;
               mapUpsertFinancials.put(financialExternalId, projectFinancials);
           } 
        }
        else
        {
            projectFinancials = new IPM_Financial__c(
                                                        RecordTypeId = financialRecordType,
                                                        Financial_External_ID__c = financialExternalId,
                                                        Target_Launch_Date__c = projectRollout.Target_Launch_Date__c,
                                                        Project_Sustainability_Period__c = projectRollout.Calculated_Sustainability_Period__c,
                                                        Added_At_Stage__c = projectRollout.Added_At_Stage__c,
                                                        IPM_Key_Financial__c = projectRollout.KeyMCO__c,
                                                        isActive__c = projectRollout.isActive__c
                                                   );   
                                                                   
            mapUpsertFinancials.put(financialExternalId, projectFinancials);
        }
        
        
        //Checks for Regional Original & Regional Rollout Projects
        
        
        if(financialRecordType == CONSOLIDATED_FINANCIAL_RECORDTYPE && projectRollout.IPM_Project__c !=null)
        {
            projectFinancials.Parent_Project__c = projectRollout.IPM_Project__c;
            projectFinancials.IPM_Project_Rollout__c = projectRollout.Id;
        }
        
        if(financialRecordType != CONSOLIDATED_FINANCIAL_RECORDTYPE)
        {  
            if(projectRollout.Regional_Project__c != null)
            {
                projectFinancials.Regional_Project__c = projectRollout.Regional_Project__c;
            }
                
            if(projectRollout.Regional_Rollout__c !=null)
            {
                projectFinancials.IPM_Project_Rollout__c = projectRollout.Regional_Rollout__c;
            }
        }
    }                                                     
    
    public void removeKeyFinancials(String financialOldExternalId,IPM_Project_Rollout__c oldProjectRollout,Map<String,IPM_Financial__c> financialExistingMap)
    {
        IPM_Financial__c existingfinancial = null;
        
        if(financialExistingMap.containsKey(financialOldExternalId))
        {
            existingfinancial =  financialExistingMap.get(financialOldExternalId);
            setDeleteFinancialExternalIds.add(financialOldExternalId);
        	
        	// In case there is a corresponding financial specific business case 
        	setDeleteFinancialExternalIds.add(oldProjectRollout.IPM_Rollout_Project__c); 
        }
    }
    
    public void removeRolloutAssociations(Set<String> deleteRolloutIDset,IPM_Project_Rollout__c regionalRollout,IPM_Project__c regionalProject)
    {
        List<IPM_Project_Rollout__c> localRolloutList = new List<IPM_Project_Rollout__c>();
        
        Map<Id,IPM_Project_Rollout__c> deletedNonKeyRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        Map<Id,IPM_Project_Rollout__c> deleteKeyRolloutMap = new Map<Id,IPM_Project_Rollout__c>(); 
        Map<Id,IPM_Project_Rollout__c> completeNonKeyRolloutMap = new Map<Id,IPM_Project_Rollout__c>();        
        
        Boolean activeNonKeyRolloutPresent = false;
        Boolean activeRolloutPresent = false;
        
        String financialNonKeyExternalId = null;

        if(regionalRollout!=null)
        {
            financialNonKeyExternalId = regionalRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            localRolloutList = regionalRollout.Local_Rollouts__r; 
        }
        else if(regionalProject !=null)
        {
            financialNonKeyExternalId = regionalProject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            localRolloutList = regionalProject.Regional_Project_Rollout__r;
        }
        
        Map<Id,IPM_Project_Rollout__c> completelocalRolloutMap = new Map<Id,IPM_Project_Rollout__c>((List<IPM_Project_Rollout__c>)localRolloutList);
                    
        for (IPM_Project_Rollout__c localRollout : localRolloutList)
        {
            // Get all the non Key Rollouts associated to this regional Rollout or Project.
            if(!localRollout.KeyMCO__c)
            {
                completeNonKeyRolloutMap.put(localRollout.Id,localRollout);
            }
            
            // Get the list of Keys and non  Key Rollouts which are being deleted.
            if(deleteRolloutIDset.contains(localRollout.Id))
            {
                // After feasibility, non Key breaks in Multiple Financials. Added to cover those cases. When rollout is deleted, assocaited financials are also deleted.
                setDeleteFinancialExternalIds.add(localRollout.IPM_Rollout_Project__c);
                
                if(!localRollout.KeyMCO__c) 
                {
                    // List of deleted Non Key Rollouts.
                    deletedNonKeyRolloutMap.put(localRollout.Id,localRollout);
                }
                else
                {
                    // List of deleted Key Rollouts.
                    deleteKeyRolloutMap.put(localRollout.Id,localRollout);
                }
            }
        }
        
        
        
        Set<Id> completeNonKeyRolloutSet = completeNonKeyRolloutMap.KeySet();
        Set<Id> deletedNonKeyRolloutSet = deletedNonKeyRolloutMap.KeySet();
        
        // If Deleted Non Key Rollout contains all non Keys which resulted in Non Key financial, delete the Non Key financials as well.            
        if(deletedNonKeyRolloutSet.containsAll(completeNonKeyRolloutSet))  
        {    
            setDeleteFinancialExternalIds.add(financialNonKeyExternalId);
        }
        else
        {
            // Remove the Non Keys eligible for deletion. 
           for(IPM_Project_Rollout__c deleteRollout : deletedNonKeyRolloutMap.values())
           {
               completeNonKeyRolloutMap.remove(deleteRollout.Id);     
           } 
           
           // Validate if there are active non Keys.If no, mark the non key as inactive. If yes do nothing.
           for(IPM_Project_Rollout__c nonKeyRollout : completeNonKeyRolloutMap.values())
           {
               // Check for active Non Key Rollouts.
               if(nonKeyRollout.isActive__c)
               {
                   activeNonKeyRolloutPresent = true;
                   break;
               }
           } 
           
           // If there is no active Rollout, it means we have non Key Rollouts which are either inactive or charter Approved.
           if(!activeNonKeyRolloutPresent)
           {
                setDeleteFinancialExternalIds.add(financialNonKeyExternalId); 
           }
        }
        
        if(regionalRollout !=null)
        {
            if(!deleteRolloutIDset.contains(regionalRollout.Id))
            {
                // Check if all rollouts associated with it are deleted
                for(IPM_Project_Rollout__c deleteKeyRollout : deleteKeyRolloutMap.values())
                {
                   completelocalRolloutMap.remove(deleteKeyRollout.Id);     
                } 
               
                for(IPM_Project_Rollout__c deleteNonKeyRollout : deletedNonKeyRolloutMap.values())
                {
                   completelocalRolloutMap.remove(deleteNonKeyRollout.Id);     
                } 
            
                if(completelocalRolloutMap.isEmpty())
                {
                    deleteRolloutMap.put(regionalRollout.Id,regionalRollout);
                }
                else
                {
                    for(IPM_Project_Rollout__c localRollout :  completelocalRolloutMap.values())
                    {
                        if(localRollout.isActive__c)
                        {
                            activeRolloutPresent = true;
                            break;
                        }    
                    }
                    
                    if(!activeRolloutPresent)
                    {
                        for(IPM_Project_Rollout__c localRollout :  completelocalRolloutMap.values())
                        {
                            if(localRollout.IPM_CharterApproved__c)
                            {
                                regionalRollout.isActive__c = false;
                                rolloutUpdateMap.put(regionalRollout.Id,regionalRollout);
                                break;        
                            }
                        }
                    }
                }
            }
        }       
    }
    
    private void deleteAssociatedCountries(Set<String> deleteCountrySet)
    {
        // Delete Country
        Map<Id,IPM_Country__c> deleteCountryMap = new Map<Id,IPM_Country__c>();
        Map<Id,IPM_Country__c> updateCountryMap = new Map<Id,IPM_Country__c>();
        
        //Delete Countries associated with rollouts.Make sure that we dont delete Countries which are inactive or Charter Approved.
        List<IPM_Project_Rollout__c> lstLocRollOuts = [SELECT Id, IPM_Rollout_Project__c,IPM_CharterApproved__c,(SELECT Id,IPM_CharterApproved__c FROM IPM_Countries_Local__r where isActive__c = true)
                            FROM IPM_Project_Rollout__c
                            WHERE IPM_Rollout_Project__c IN: localRolloutCountrySet Limit 50000];
                            
        for(IPM_Project_Rollout__c localRollout : LstLocRollOuts)
        {
            for(IPM_Country__c localRolloutCountry : localRollout.IPM_Countries_Local__r)
            {
                if(localRolloutCountry.IPM_CharterApproved__c)
                {
                    localRolloutCountry.isActive__c = false;
                    updateCountryMap.put(localRolloutCountry.Id,localRolloutCountry);
                }
                else
                {
                    deleteCountryMap.put(localRolloutCountry.Id,localRolloutCountry);
                }
            }
        }
        
        if(!updateCountryMap.isEmpty())
        {                
            update updateCountryMap.values();
        }
        
        if(!deleteCountryMap.isEmpty())
        {                
            delete deleteCountryMap.values();
        }
    }
    
    
    public void deleteAssociatedFinancials()
    {
        //Delete Financials
        Map<Id,IPM_Financial__c> updateFinancialMap = new Map<Id,IPM_Financial__c>();
        Map<Id,IPM_Financial__c> deleteFinancialMap = new Map<Id,IPM_Financial__c>();
        
        List<IPM_Financial__c> lstDeteleFinancials = [SELECT Id,Financial_External_ID__c,isActive__c,Added_At_Stage__c,Charter_Approved__c  FROM IPM_Financial__c WHERE Financial_External_Id__c IN: setDeleteFinancialExternalIds LIMIT 50000];
        
        if(!lstDeteleFinancials.isEmpty())
        {
            for(IPM_Financial__c financial : lstDeteleFinancials)
            {
                if(!financial.Charter_Approved__c)
                {
                    deleteFinancialMap.put(financial.Id,financial);
                }
                else
                {
                    financial.isActive__c = false;
                    updateFinancialMap.put(financial.Id,financial);
                }
            }
			
            if(!deleteFinancialMap.isEmpty())
            {
                delete deleteFinancialMap.values();
            }
            
            if(!updateFinancialMap.isEmpty())
            {
                update updateFinancialMap.values();
            }
        }
    }
}