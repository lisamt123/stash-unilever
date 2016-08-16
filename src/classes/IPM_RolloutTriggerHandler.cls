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
    public IPM_RolloutTriggerHandler()
    { 
        mapUpsertFinancials = new Map<String, IPM_Financial__c>();
                
        deleteRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        rolloutUpdateMap = new Map<String,IPM_Project_Rollout__c>();
        localRolloutCountrySet = new Set<String>();
        setDeleteFinancialExternalIds = new Set<String>();
        
        
    }
    
    /*****************************************************************************************************************************
    * @description  Method to handle before delete Trigger context for IPM_Project_Rollout__c. 
                    This method is responsible for removing other associated components from Rollouts like associated financials and Countries
                    which shouldnt exist with Rollouts. Also it checks if this is last local Rollout which is being deleted. 
                    If yes it deletes the regional Rollout as well along with regional Consolidated financials.
                    
    * @param lstProjectRollouts     List of Trigger.old records 
    */
    public void processDelete(List<IPM_Project_Rollout__c> lstProjectRollouts)
    {
        Set<String> setRegionalRolloutNames = new Set<String>();
        Set<String> setRegionalProjectNames = new Set<String>(); 
        
        Set<String> setCurrentRolloutIds = new Set<String>();        
        
        Set<Id> deletedLocalRolloutIds = new Set<Id>();
        Set<Id> setTopLevelProjectIds = new Set<Id>();
        
        // Validate if there are any countries which are charter approved or inactive. Only charter Approved countries can be inactive.
        for(IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
        {
            if(projectRollout.IPM_CharterApproved__c)
            {
               projectRollout.addError(Label.IPM_Cannot_Delete_CharterApproved); 
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
                deletedLocalRolloutIds.add(projectRollout.Id);
                //PROCESS ROLLOUTS FOR THE ROLLOUT STATUS
                if(projectRollout.IPM_Project__c != null)
                {
                    setTopLevelProjectIds.add(projectRollout.IPM_Project__c);
                }
                else if(projectRollout.Regional_Project__c!=null)
                {
                    setTopLevelProjectIds.add(projectRollout.Regional_Project__c);
                }
                
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
            List<IPM_Project_Rollout__c> compositeRolloutsList = [SELECT Id, IPM_Rollout_Project__c,IPM_Project__r.IPM_Phase__c,Regional_Rollout__c,isActive__c,Added_At_Stage__c,IPM_CharterApproved__c,Regional_Rollout_External_Id__c,IPM_Regional_Rollout_Status__c,IPM_Status__c,
                                                                    (SELECT Id,IPM_Rollout_Project__c,KeyMCO__c,isActive__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,Added_At_Stage__c,IPM_CharterApproved__c,Regional_Rollout__c,Regional_Rollout_External_Id__c FROM Local_Rollouts__r),
                                                                    (SELECT Id,Financial_External_Id__c,isActive__c,Charter_Approved__c,Added_At_Stage__c,IPM_Key_Financial__c FROM IPM_Financials__r)
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
                                                            (SELECT Id,IPM_Regional_Rollout_Status__c,IPM_Status__c,IPM_Rollout_Project__c,KeyMCO__c,isActive__c,IPM_CharterApproved__c,Added_At_Stage__c,Regional_Rollout_External_Id__c FROM Regional_Project_Rollout__r)
                                                            FROM IPM_Project__c
                                                            WHERE IPM_Project_Name__c IN: setRegionalProjectNames Limit 50000];
            
            for(IPM_Project__c project :compositeProjectList)
            {
                removeRolloutAssociations(setCurrentRolloutIds,null,project);
            }
        } 
        
        if(!mapUpsertFinancials.isEmpty()){
            upsert mapUpsertFinancials.values() IPM_Financial__c.Financial_External_Id__c;
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
        
        IPM_ProcessRolloutStatusAndDates.execute(setTopLevelProjectIds,deletedLocalRolloutIds);  // deletion              
    }
    
    /*****************************************************************************************************************************
    * @description  This method is responsible for creating new financials based on incoming regional and local Rollouts.
            If it is a regional Rollout creates Regional Consolidated financials.
            If it is a local Rollout, creates corresponding financials based on whether it is key or non Key Rollout.
            Also First and follower is invoked from here which based on TLD sets the first rollout and follower rollouts.
            
    * @param lstProjectRollouts     List of Trigger.new records
    */
    
    public  void processInsert(List<IPM_Project_Rollout__c> lstProjectRollouts)
    {
        Set<Id> setTopLevelProjectIds = new Set<Id>();

        // Process financials only when Rollout has a parent project attached to it. 
        // For regional Rollouts it would be Global Project and For local Rollouts it would be parent Project plus regional project 
        
        Map<String,Schema.SObjectField> projRolloutFieldTypeMap = Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap();
		Map<String,Schema.SObjectField> financialFieldTypeMap = Schema.SObjectType.IPM_Financial__c.fields.getMap();

        String rolloutQuery = ' SELECT ';        
        for(String fieldAPIName : projRolloutFieldTypeMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = projRolloutFieldTypeMap.get(fieldAPIName).getDescribe();
            
            if(fieldDescribe.isCustom()  && fieldAPIName != 'Id')
            {
                rolloutQuery += ' '+fieldAPIName+',';
            }
        }
        rolloutQuery = rolloutQuery +'Regional_Rollout__r.IPM_Project__c,Regional_Project__r.IPM_Parent_Project__c,Name,RecordTypeId,Id FROM IPM_Project_Rollout__c ';
        String rolloutWhereClause = ' WHERE Id in :lstProjectRollouts LIMIT 50000';
        rolloutQuery = rolloutQuery + rolloutWhereClause;
        
        lstProjectRollouts = database.query(rolloutQuery);
        
        Map<String,IPM_Financial__c> existingFinancialMap = new Map<String,IPM_Financial__c>();
        existingFinancialMap = getExistingFinancialMap(lstProjectRollouts);
        
        for (IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
        {       
            ///Regional Rollout. Validate consolidated financials is present or not. If no create one.
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
            {
                String financialExternalId = projectRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                
                createRolloutFinancials(financialExternalId,CONSOLIDATED_FINANCIAL_RECORDTYPE,projectRollout,existingFinancialMap);
            }             
            else 
            {
                String financialExternalId = IPM_Utils.getFinancialExternalId(projectRollout); 
            
                createRolloutFinancials(financialExternalId,DEFAULT_FINANCIAL_RECORDTYPE,projectRollout,existingFinancialMap);
                
                //PROCESS ROLLOUTS FOR THE ROLLOUT STATUS
                if(projectRollout.IPM_Project__c != null)
                {
                    setTopLevelProjectIds.add(projectRollout.IPM_Project__c);
                }
                else if (projectRollout.Regional_Project__c != null)
                {
                    setTopLevelProjectIds.add(projectRollout.Regional_Project__c);
                }
                
            }
        }
        
        if (mapUpsertFinancials != NULL && !mapUpsertFinancials.isEmpty())
        {
                upsert mapUpsertFinancials.values() IPM_Financial__c.Financial_External_Id__c ;
                
                if(!setTopLevelProjectIds.isEmpty() )
                {
                    IPM_ProcessRolloutStatusAndDates.execute(setTopLevelProjectIds,new Set<Id>());// insertion   
                }
        }
    }

    /*****************************************************************************************************************************
    * @description  This method is responsible for creating new financials based on incoming regional and local Rollouts.
            If it is a local Rollout is updated with Key or non Key or is made active or inactive , operates on  corresponding financials.
            Also in case of inactive rollouts corresponding financials and countries are made inactive.
            Also First and follower is invoked from here which based on TLD sets the first rollout and follower rollouts.
            
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
                if(projectRollout.Regional_Project__c !=null)
                {
                    setRegionalProjectNames.add(projectRollout.Regional_Rollout_External_Id__c);
                }
                else  
                {   // If it is associated with Regional Rollout, It means we are working with Global Original Rollout Project and no regional Projects have been created.
                    setRegionalRolloutNames.add(projectRollout.Regional_Rollout_External_Id__c);
                }
            }
        }
        
        List<IPM_Project_Rollout__c> lstProjRegRollouts = [SELECT Id, IPM_Rollout_Project__c,IPM_Project__c,IPM_Regional_Rollout_Status__c,IPM_Project__r.IPM_Phase__c,isActive__c,IPM_Status__c,Added_At_Stage__c,Regional_Project__c,Regional_Project__r.IPM_Phase__c,Target_Launch_Date__c,Calculated_Sustainability_Period__c,Regional_Rollout__c,IPM_Regional_Original_Project__c,Regional_Rollout_External_Id__c,IPM_Project_GKM__c,
                                                            (SELECT Id,IPM_Regional_Rollout_Status__c,IPM_Status__c,IPM_Rollout_Project__c,isActive__c,IPM_Project__c,Added_At_Stage__c,KeyMCO__c,Regional_Project__c,Target_Launch_Date__c,Regional_Rollout__c,IPM_Regional_Original_Project__c,Calculated_Sustainability_Period__c,Regional_Rollout_External_Id__c,Regional_Rollout__r.IPM_Project__c,Regional_Project__r.IPM_Parent_Project__c,IPM_Project_GKM__c FROM Local_Rollouts__r), 
                                                            (SELECT Id,isActive__c,Added_At_Stage__c,Financial_External_Id__c,IPM_Key_Financial__c FROM IPM_Financials__r) FROM IPM_Project_Rollout__c   
                                                            WHERE IPM_Rollout_Project__c IN: setRegionalRolloutNames Limit 50000];
                                                                                                  
        for(IPM_Project_Rollout__c regionalRollout : lstProjRegRollouts)
        {
            updateRolloutAssociations(mapOldProjectRollouts,regionalRollout,null);
        }

        if(!setRegionalProjectNames.isEmpty()) 
        { 
            List<IPM_Project__c> lstRegionalProjects = [SELECT Id,IPM_Project_Name__c,IPM_Target_Launch_Dates__c,Sustainability_Period__c,IPM_Phase__c,
                                                       (SELECT Id,IPM_Rollout_Project__c,isActive__c,Added_At_Stage__c,KeyMCO__c,Regional_Project__c,IPM_Project__c,IPM_Regional_Original_Project__c,IPM_Regional_Rollout_Status__c,IPM_Status__c,Target_Launch_Date__c,Calculated_Sustainability_Period__c,Regional_Rollout__c,Regional_Rollout_External_Id__c,Regional_Rollout__r.IPM_Project__c,Regional_Project__r.IPM_Parent_Project__c FROM Regional_Project_Rollout__r),
                                                       (SELECT Id,isActive__c,Added_At_Stage__c,Financial_External_Id__c,IPM_Key_Financial__c FROM IPM_Financials_Regional__r) FROM IPM_Project__c
                                                       WHERE IPM_Project_Name__c IN: setRegionalProjectNames Limit 50000];
            
        
            for(IPM_Project__c regionalProject : lstRegionalProjects)
            {
                updateRolloutAssociations(mapOldProjectRollouts,null,regionalProject);
            }
        }
        
        //For Rollout Status Updates
        Set<Id> setTopLevelProjectIds = new Set<Id>();
 
        for(IPM_Project_Rollout__c newRollout : mapNewProjectRollouts.values())
        {
            if(newRollout.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
            {
                //Id regionalRollout = newRollout.Regional_Rollout__c;
                
                IPM_Project_Rollout__c oldRollout = mapOldProjectRollouts.get(newRollout.Id);
                
                //Rollout Status
                if(newRollout.Target_Launch_Date__c != oldRollout.Target_Launch_Date__c || newRollout.isActive__c != oldRollout.isActive__c || newRollout.Regional_Project__c != oldRollout.Regional_Project__c)
                {
                    
                    //PROCESS ROLLOUTS FOR THE ROLLOUT STATUS
                    // Global Project
                    if(newRollout.IPM_Project__c != null)
                    {
                        setTopLevelProjectIds.add(newRollout.IPM_Project__c); 
                    }
                    // regional project
                    else if (newRollout.Regional_Project__c != null)
                    {
                        setTopLevelProjectIds.add(newRollout.Regional_Project__c);
                    }
                }
            }
        }
        
        
        deleteAssociatedFinancials();
        
        deleteAssociatedCountries(localRolloutCountrySet);

        if (!mapUpsertFinancials.isEmpty())
        {
            // Remove ID's from Upsert Call.
            for(IPM_Financial__c financial : mapUpsertFinancials.values())
            {
                financial.Id = null;
            }
            upsert mapUpsertFinancials.values() IPM_Financial__c.Financial_External_Id__c; 
        } 
        
        // Whether it is Global or regional Original Project    
        if( (!setTopLevelProjectIds.isEmpty() ) )
        {
            IPM_ProcessRolloutStatusAndDates.execute(setTopLevelProjectIds,new Set<Id>()); // updation
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
           
        if(!updatedRollouts.isEmpty()) 
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
        
        if(projectidset != null && !projectidset.isEmpty())
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
    
    
     /**********************************************************************************************************************************
    * @description                      Used for udpating job Id for corresponding Rollout when the background process of Rollout to Project Conversion happens. 
    * @param phaseChangeRolloutSet      Rollouts which are being sent for background processing for Queueable interface.
      @param JobId                      Associated Job Id.
    */
    
    public static void udpateAsyncJobId(Set<Id>phaseChangeRolloutSet, Id JobId)
    {
        Map<Id,IPM_Project_Rollout__c> updateAsyncJobIdRolloutMap = new Map<Id,IPM_Project_Rollout__c>(); 
        for(Id rolloutId : phaseChangeRolloutSet)
        {
            IPM_Project_Rollout__c projectRollout = new IPM_Project_Rollout__c(Id=rolloutId,IPM_PhaseChangeQueueJobId__c = JobId);
            updateAsyncJobIdRolloutMap.put(rolloutId,projectRollout);
        }
        
        if(!updateAsyncJobIdRolloutMap.isEmpty())
        {
            SKIP_TRIGGER_EXECUTION = true;
            update updateAsyncJobIdRolloutMap.values();
            SKIP_TRIGGER_EXECUTION = false;
        }
    }
    
    
    
    
    /*******************************************************************************************************
    * @description  Method to get updating Financials and countries based on active/inactive flags on rollouts.
                    Also key non Key changes related to rollouts are covered here and whether non key financials should be removed or retained.
                    
    * @param oldRolloutsMap     List of Trigger.old records
    * @param regionalRollout    Associated Regional Rollout
    * @param regionalProject    Associated Regional Project
    */
    
    public void updateRolloutAssociations(Map<Id, IPM_Project_Rollout__c> oldRolloutsMap,IPM_Project_Rollout__c regionalRollout,IPM_Project__c regionalProject)
    {
        // Financial NON-KEY external Id as it is based on Regional Rollout Level
        String financialNonKeyExternalId = null;
        String associatedPhase = null;
        Map<String,IPM_Financial__c> financialExistingMap = new Map<String,IPM_Financial__c>();
        
        List<IPM_Financial__c> associatedfinancials = new List<IPM_Financial__c>();
        List<IPM_Project_Rollout__c> associatedlocalRollouts = new List<IPM_Project_Rollout__c>();
         
        if(regionalProject!=null)
        {
            financialNonKeyExternalId = regionalProject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            associatedfinancials = regionalProject.IPM_Financials_Regional__r;
            associatedlocalRollouts = regionalProject.Regional_Project_Rollout__r;
            associatedPhase = regionalProject.IPM_Phase__c;
        }
    if(regionalProject==null)
        {
            financialNonKeyExternalId = regionalRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            associatedfinancials = regionalRollout.IPM_Financials__r;
            associatedlocalRollouts = regionalRollout.Local_Rollouts__r;
            associatedPhase = regionalRollout.IPM_Project__r.IPM_Phase__c;
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
            IPM_Project_Rollout__c oldProjectRollout;
            if(oldRolloutsMap.containsKey(localRollout.Id))
            {           
            	oldProjectRollout = oldRolloutsMap.get(localRollout.Id);
            }
            
            if(!localRollout.KeyMCO__c && localRollout.isActive__c)
            {
                nonkeyActiveRolloutExists = true; 
            }
                           

            if(oldProjectRollout != null && localRollout.isActive__c)
            {
                if(localRollout.KeyMCO__c)
                { 
                    // If Rollout is a key Rollout,We need to generate Corresponding Key Financials.
                    if(localRollout.KeyMCO__c != oldProjectRollout.KeyMCO__c || localRollout.isActive__c != oldProjectRollout.isActive__c)
                    {
                        createRolloutFinancials(financialExternalId,DEFAULT_FINANCIAL_RECORDTYPE,localRollout,financialExistingMap);
                    }
                }
                if(!localRollout.KeyMCO__c)
                {
                    processlocal(localRollout, oldProjectRollout, financialExistingMap, financialExternalId , associatedPhase);   
                }    
            }

            if(oldProjectRollout != null && !localRollout.isActive__c)
            {
                // If old rollout was active, we need to inactive Financials or delete financials.
                if(localRollout.isActive__c != oldProjectRollout.isActive__c)
                {
                    setDeleteFinancialExternalIds.add(oldProjectRollout.IPM_Rollout_Project__c); 
                    localRolloutCountrySet.add(localRollout.IPM_Rollout_Project__c);
                }
            }
        }        
            
        if(!nonkeyActiveRolloutExists)
        {
            setDeleteFinancialExternalIds.add(financialNonKeyExternalId);
        }
        if(nonkeyActiveRolloutExists && nonKeyFinancial != null){
            
            //flag Is_Nonkey_Business_Case_Changed__c is set to true which indicates that the Non Key business case has been changed.
            //Non Key Business case is changed when A Nonkey MCO is added or removed from existing Non Key Business Case
            nonKeyFinancial.Is_Nonkey_Business_Case_Changed__c = true;
            mapUpsertFinancials.put(nonKeyFinancial.Financial_External_Id__c,nonKeyFinancial);
        }
    }
    
    //Method to process each local rollout
    public void processlocal(IPM_Project_Rollout__c localRollout, IPM_Project_Rollout__c oldProjectRollout, Map<String,IPM_Financial__c> financialExistingMap, string financialExternalId, string associatedPhase){
        // If rollout was a Key Rollout before, remove Key Financials for corresponding Rollout 
        if(localRollout.KeyMCO__c != oldProjectRollout.KeyMCO__c ||  localRollout.isActive__c != oldProjectRollout.isActive__c) 
        {    
            // In case there is a corresponding financial specific business case 
            if(localRollout.KeyMCO__c != oldProjectRollout.KeyMCO__c)
            {
                setDeleteFinancialExternalIds.add(oldProjectRollout.IPM_Rollout_Project__c); 
            }
            // Create Non Key financial for the corresponding Non Key Rollout
            createRolloutFinancials(financialExternalId,DEFAULT_FINANCIAL_RECORDTYPE,localRollout,financialExistingMap);
            
            //If it is a non Key and Phase is not ideas, We need to add Financials Corresponding to rollouts.   
            if(associatedPhase != IPM_ConstantUtils.PHASE_IDEAS)
            {
                createRolloutFinancials(localRollout.IPM_Rollout_Project__c,DEFAULT_FINANCIAL_RECORDTYPE,localRollout,financialExistingMap);
            }
        }  
    }
    /*******************************************************************************************************
    * @description   Method to get Creating Financials.
    * @param financialExternalId  External Id for financials which needs to be created.
    * @param financialRecordType  Associated financial Record Type.
    * @param projectRollout       Associated Project Rollout.
    * @param financialExistingMap Existing Financial Map containing existing Financials.
    */
    
    // Generate financials for Rollouts based on Params 
    public IPM_Financial__c createRolloutFinancials(String financialExternalId,String financialRecordType, IPM_Project_Rollout__c projectRollout,Map<String,IPM_Financial__c> financialExistingMap)
    {
        IPM_Financial__c projectFinancials = null;
        
        if(mapUpsertFinancials!=null && mapUpsertFinancials.containsKey(financialExternalId))
        {
            projectFinancials =  financialExistingMap.get(financialExternalId);
        }
        
        if(financialExistingMap!=null && financialExistingMap.containsKey(financialExternalId))
        {
           projectFinancials =  financialExistingMap.get(financialExternalId);
           
           if(projectFinancials.IPM_Key_Financial__c != projectRollout.KeyMCO__c)
           {
                projectFinancials.IPM_Key_Financial__c = projectRollout.KeyMCO__c;
                mapUpsertFinancials.put(financialExternalId, projectFinancials);     
           }
           
           if(!projectFinancials.isActive__c)
           {
               projectFinancials.isActive__c = true;
               mapUpsertFinancials.put(financialExternalId, projectFinancials);
           }
           
           if(!projectRollout.KeyMCO__c){
            //flag Is_Nonkey_Business_Case_Changed__c is set to true which indicates that the Non Key business case has been changed.
            //Non Key Business case is changed when A Nonkey MCO is added or removed from existing Non Key Business Case
            projectFinancials.Is_Nonkey_Business_Case_Changed__c = true;
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
            else if(projectRollout.Regional_Rollout__c !=null) 
            {
                projectFinancials.IPM_Project_Rollout__c = projectRollout.Regional_Rollout__c;
            }
        }
        
        return projectFinancials;
    } 
    
    
    /*******************************************************************************************************
    * @description  Used to remove rollout associations, like financials and country based on deleted rollouts.
                    Various Criteria for checking and removing of Rollouts based on whether it is a Key Rollout,Non Key Rollout or Created before or after charter.
                    If it is a key Rollout, deletes asscociated Financials.
                    If it is a non Key Rollout, Checks if there is any other non Key rollout, if no, then deletes the Non Key financials.
                    Checks if there are no local rollouts under regional Rollout, deletes the associated Regional Rollout.
                    Checks if local Rollout is charter approved, then makes it as inactive.             
    * @param deleteRolloutIDset List of removed rollout 
    * @param regionalRollout    Associated Regional Rollout
    * @param regionalProject    Associated Regional Project
    */                                                       
    
    public void removeRolloutAssociations(Set<String> deleteRolloutIDset,IPM_Project_Rollout__c regionalRollout,IPM_Project__c regionalProject)
    {
        List<IPM_Project_Rollout__c> localRolloutList = new List<IPM_Project_Rollout__c>();
        
        Map<Id,IPM_Project_Rollout__c> deletedNonKeyRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        Map<Id,IPM_Project_Rollout__c> deleteKeyRolloutMap = new Map<Id,IPM_Project_Rollout__c>(); 
        Map<Id,IPM_Project_Rollout__c> completeNonKeyRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        
        Map<String,IPM_Financial__c> financialExtIdFinancialMap = new Map<String,IPM_Financial__c>();
        IPM_Financial__c survivingNonkeyFinancial = new IPM_Financial__c();
        
        for(IPM_Financial__c regionalRolloutFinancial : regionalRollout.IPM_Financials__r ){
            financialExtIdFinancialMap.put(regionalRolloutFinancial.Financial_External_ID__c,regionalRolloutFinancial);
        }      
        
        Boolean activeNonKeyRolloutPresent = false;
        Boolean activeRolloutPresent = false;
        
        String financialNonKeyExternalId = null;

        if(regionalProject !=null)
        {
            financialNonKeyExternalId = regionalProject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            localRolloutList = regionalProject.Regional_Project_Rollout__r;
        }
        else if(regionalRollout!=null)
        {
            financialNonKeyExternalId = regionalRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            localRolloutList = regionalRollout.Local_Rollouts__r; 
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
                   
                   //fetch the nonKeyFinancial which still exist after deletion of Non key rollouts
                   survivingNonkeyFinancial = financialExtIdFinancialMap.get(financialNonKeyExternalId);
                   
                   //flag Is_Nonkey_Business_Case_Changed__c is set to true which indicates that the Non Key business case has been changed.
            	   //Non Key Business case is changed when A Nonkey MCO is added or removed from existing Non Key Business Case
                   survivingNonkeyFinancial.Is_Nonkey_Business_Case_Changed__c = true;
                   mapUpsertFinancials.put(financialNonKeyExternalId, financialExtIdFinancialMap.get(financialNonKeyExternalId));
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
    
    
    /*******************************************************************************************************
    * @description  Used to delete Countries when associated rollout is removed from System. 
                    It validates whether it is charter Approved, If yes makes it as inactive else delete that specific country.  
    * @param deleteCountrySet  Set of deleted Coutries.
    */    
    
    private void deleteAssociatedCountries(Set<String> deleteCountrySet)
    {
        // Delete Country
        Map<Id,IPM_Country__c> deleteCountryMap = new Map<Id,IPM_Country__c>();
        Map<Id,IPM_Country__c> updateCountryMap = new Map<Id,IPM_Country__c>();
        
        //Delete Countries associated with rollouts.Make sure that we dont delete Countries which are inactive or Charter Approved.
        List<IPM_Project_Rollout__c> lstLocRollOuts = [SELECT Id,IPM_Status__c,IPM_Regional_Rollout_Status__c,IPM_Rollout_Project__c,IPM_CharterApproved__c,KeyMCO__c,
                                                            Added_At_Stage__c,(SELECT Id,IPM_CharterApproved__c FROM IPM_Countries_Local__r where isActive__c = true)
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
    
     /*******************************************************************************************************
    * @description  Used to delete Financials when associated rollout is removed from System. 
                    It validates whether it is charter Approved, If yes makes it as inactive else delete that specific country.  
    */  
    
    public void deleteAssociatedFinancials()
    {
        //Delete Financials
        Map<Id,IPM_Financial__c> updateFinancialMap = new Map<Id,IPM_Financial__c>();
        Map<Id,IPM_Financial__c> deleteFinancialMap = new Map<Id,IPM_Financial__c>();

        List<IPM_Financial__c> lstDeteleFinancials = [SELECT Id,Financial_External_ID__c,isActive__c,Added_At_Stage__c,Charter_Approved__c,IPM_Key_Financial__c  FROM IPM_Financial__c WHERE Financial_External_Id__c IN: setDeleteFinancialExternalIds LIMIT 50000];
        
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
    
      /*************************************************************************************************************
    * @description:Assign Company Card to rollouts
    */
    public void assignCompanyCard(List<IPM_Project_Rollout__c>lstProjectRollouts)
    {
        List<IPM_Company_Card__c>companyCardLst=new List<IPM_Company_Card__c>(); 
        companyCardLst=[select Id,IPM_MCO__c,IPM_CompanyCard_Type__c,IPM_Managed_Category__c,RecordType.Name,IPM_TxtGeographical_Scope__c from IPM_Company_Card__c 
                        where RecordType.Name=:IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL Limit 5000];
        
        
       
            for(IPM_Project_Rollout__c rollouts : lstProjectRollouts)
            {
                for(IPM_Company_Card__c companyCard : companyCardLst)
                {
                    
                        if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.Equals(rollouts.IPM_Rollout_Span__c) && 
                            companyCard.IPM_Managed_Category__c!=null && rollouts.IPM_Small_C__c!=null && 
                            companyCard.RecordType.Name!=null && rollouts.IPM_Rollout_Span__c!=null && 
                            companyCard.IPM_TxtGeographical_Scope__c!=null && rollouts.Market_Cluster_Name__c!=null && 
                            companyCard.IPM_Managed_Category__c.contains(rollouts.IPM_Small_C__c)&&
                            companyCard.IPM_TxtGeographical_Scope__c.Equals(rollouts.Market_Cluster_Name__c))
                        {
                        
                            rollouts.IPM_Company_Card__c=companyCard.Id;
                        
                        }
                    }
            }
    }
    
    /*******************************************************************************************************
    * @description  For Creating Financial Action Standards When Rollout get Created.  
    */ 
    public void createRegionalFinancialActionStandards(List<IPM_Project_Rollout__c> lstProjectRollouts)
    {   
        Set<Id> rolloutProjectIdSet=new Set<Id>();
        Set<Id> rolloutIdSet=new Set<Id>();
        for(IPM_Project_Rollout__c projRoll:lstProjectRollouts)
        {
            if(projRoll.RecordTypeId==REGIONAL_ROLLOUT_RECORDTYPE)
            {
                rolloutProjectIdSet.add(projRoll.IPM_Project__c);
                rolloutIdSet.add(projRoll.Id);
            }
        }

        Map<String,IPM_Financial_Year__c>  finYearMap = getFinancialYears(rolloutIdSet);
        
        Map<Id,IPM_Project_Document_Section__c> projDocSecMap=new Map<Id,IPM_Project_Document_Section__c>();
        for(IPM_Project_Document_Section__c projDocSec:[SELECT Id,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Project_Document__r.IPM_Document_Status__c 
                                                        FROM IPM_Project_Document_Section__c 
                                                        WHERE IPM_Project_Document__r.IPM_Project__c In :rolloutProjectIdSet AND IPM_Project_Document__r.IPM_Document_Status__c IN :IPM_ConstantUtils.STATUS_SET_WO_APPROVED
                                                              AND IPM_Master_Section_External_Id__c=:IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD])
        {
            projDocSecMap.put(projDocSec.IPM_Project_Document__r.IPM_Project__c,projDocSec);                                                            
        }
        
        List<IPM_Financial_Action_Standards__c> regionalActionStandardsList=new List<IPM_Financial_Action_Standards__c>();
        
        for(IPM_Project_Rollout__c projRollout:lstProjectRollouts)
        {
            if(projRollout.Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && projRollout.RecordTypeId==REGIONAL_ROLLOUT_RECORDTYPE)
            {
                IPM_Financial_Action_Standards__c finActionStandard = new IPM_Financial_Action_Standards__c();
                IPM_Market_Cluster_Short_Names__c mcsName=IPM_Market_Cluster_Short_Names__c.getValues(projRollout.Market_Cluster__c);
                if(projDocSecMap.get(projRollout.IPM_Project__c)!=null)
                {    
                    finActionStandard.IPM_Project_Document_Section__c=projDocSecMap.get(projRollout.IPM_Project__c).Id;
                }
                finActionStandard.IPM_Financial_Year_Y1_Incremental__c=finYearMap.get(projRollout.Id+IPM_ConstantUtils.Y1InnovationIncremental).Id;
                finActionStandard.IPM_Financial_Year_Y1_Gross__c=finYearMap.get(projRollout.Id+IPM_ConstantUtils.Y1InnovationGross).Id;
                if(mcsName!=null)
                {
                    finActionStandard.IPM_Financial_Action_Standard_Name__c = mcsName.Short_Name__c+' '+IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARDS;
                }
                finActionStandard.IPM_GM_Action_Standards_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_gTO_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_Innov_Value_Share_Action_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_Inc_Value_Share_Action_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_IRR_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_iTo_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_NPV_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_Payback_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                finActionStandard.IPM_Project_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
                finActionStandard.IPM_Project__c = projRollout.IPM_Project__c;
                regionalActionStandardsList.add(finActionStandard);
            }
        }
        
        if(regionalActionStandardsList!=null && !regionalActionStandardsList.isEmpty())
        {
            insert regionalActionStandardsList;
        }
    }
    
    public Map<String,IPM_Financial_Year__c> getFinancialYears(Set<Id> rolloutIdSet)
    {
        Map<String,IPM_Financial_Year__c> finYearMap = new Map<String,IPM_Financial_Year__c>();
        
        for(IPM_Financial_Year__c finYear:[SELECT Id,IPM_Financial__c,IPM_Financial__r.RecordTypeId,IPM_Financial__r.Parent_Project__c,NameYearPLtype__c,IPM_Financial__r.IPM_Project_Rollout__c FROM IPM_Financial_Year__c 
                                           WHERE IPM_Financial__r.IPM_Project_Rollout__c In:rolloutIdSet AND (NameYearPLtype__c=:IPM_ConstantUtils.Y1InnovationIncremental OR NameYearPLtype__c=:IPM_ConstantUtils.Y1InnovationGross)
                                                 AND IPM_Financial__r.RecordTypeId=:CONSOLIDATED_FINANCIAL_RECORDTYPE])
        {
            if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental)
            {
                finYearMap.put(finYear.IPM_Financial__r.IPM_Project_Rollout__c+IPM_ConstantUtils.Y1InnovationIncremental,finYear);
            }
            
            if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross)
            {
                finYearMap.put(finYear.IPM_Financial__r.IPM_Project_Rollout__c+IPM_ConstantUtils.Y1InnovationGross,finYear);
            }
        }
        
        return finYearMap;
    }
    
    /*******************************************************************************************************
    * @description  For Collecting the List of Financial Action Standards When Rollout get Deleted.  
    */ 
    public void deleteRegionalFinancialActionStandards(List<IPM_Project_Rollout__c> lstProjectRollouts){
        Set<Id> projIdSet=new Set<Id>();
        Set<String> rollOutNameSet=new Set<String>();
        rollOutNameSet.add(IPM_ConstantUtils.IPM_GLOBAL_FINANCIAL_ACTION_STANDARDS);
        for(IPM_Project_Rollout__c projRoll:lstProjectRollouts){
            if(projRoll.RecordTypeId==REGIONAL_ROLLOUT_RECORDTYPE){
                IPM_Market_Cluster_Short_Names__c mcsName=IPM_Market_Cluster_Short_Names__c.getValues(projRoll.Market_Cluster__c);
                rollOutNameSet.add(mcsName.Short_Name__c+' '+IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARDS);
                projIdSet.add(projRoll.IPM_Project__c);
            }    
        }
        List<IPM_Financial_Action_Standards__c> deleteFinActionList=new List<IPM_Financial_Action_Standards__c>();
        List<IPM_Financial_Action_Standards__c> updateFinActionList=new List<IPM_Financial_Action_Standards__c>();
        for(IPM_Financial_Action_Standards__c finActionStandard:[SELECT Id,IPM_Financial_Action_Standard_Name__c,IPM_gTO_Action_Standard_Charter__c,IPM_iTo_Action_Standard_Charter__c,
                                                                        IPM_Project__c,IPM_Project_Span__c FROM IPM_Financial_Action_Standards__c
                                                                 WHERE IPM_Project__c In:projIdSet AND IPM_Financial_Action_Standard_Name__c In:rollOutNameSet]){
            if(finActionStandard.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
                updateFinActionList.add(finActionStandard);    
            }                                                         
            else if(finActionStandard.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                deleteFinActionList.add(finActionStandard); 
            }                                                      
        }
        updateFinActionStandards(deleteFinActionList,updateFinActionList);
    }
    /*******************************************************************************************************
    * @description  For Updating the List of Financial Action Standards When Rollout get Deleted.  
    */ 
    public void updateFinActionStandards(List<IPM_Financial_Action_Standards__c> deleteFinActionList,List<IPM_Financial_Action_Standards__c> updateFinActionList){
        for(IPM_Financial_Action_Standards__c updateFin:updateFinActionList){
            for(IPM_Financial_Action_Standards__c delFin:deleteFinActionList){
                if(updateFin.IPM_Project__c==delFin.IPM_Project__c){
                    updateFin.IPM_gTO_Action_Standard_Charter__c=updateFin.IPM_gTO_Action_Standard_Charter__c-delFin.IPM_gTO_Action_Standard_Charter__c;
                    updateFin.IPM_iTo_Action_Standard_Charter__c=updateFin.IPM_iTo_Action_Standard_Charter__c-delFin.IPM_iTo_Action_Standard_Charter__c;
                }
            }                                                         
        }
        if(updateFinActionList!=null && !updateFinActionList.isEmpty()){
            update updateFinActionList;
        }
        if(deleteFinActionList!=null && !deleteFinActionList.isEmpty()){
            delete deleteFinActionList;
        }
    }
    
    /*******************************************************************************************************
    * @description  For fetching the Existing Financial Map  (Map of Financial ext Id and Financial)
    */
    public Map<String,IPM_Financial__c> getExistingFinancialMap(List<IPM_Project_Rollout__c> lstProjectRollouts){
        // Get the associated Financials...
        Set<Id> regionalLevelIDs = new Set<Id>();
        
        for(IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
        {   
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE && projectRollout.IPM_Project__c !=null)
            {
                regionalLevelIDs.add(projectRollout.Id);
            }
            else if(projectRollout.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
            {
                if(projectRollout.Regional_Project__c !=null)
                {
                    regionalLevelIDs.add(projectRollout.Regional_Project__c);
                }
                else  
                {   // If it is associated with Regional Rollout, It means we are working with Global Original Rollout Project and no regional Projects have been created.
                    regionalLevelIDs.add(projectRollout.Regional_Rollout__c);
                }
            }
        }
        
        Map<String,Schema.SObjectField> financialFieldTypeMap = Schema.SObjectType.IPM_Financial__c.fields.getMap();
        
        String financialQuery = ' SELECT ';        
        for(String fieldAPIName : financialFieldTypeMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = financialFieldTypeMap.get(fieldAPIName).getDescribe();
            
            if(fieldDescribe.isCustom()  && fieldAPIName != 'Id')
            {
                financialQuery += ' '+fieldAPIName+',';
            }
        }
        
        financialQuery = financialQuery.removeEnd(',');
        
        financialQuery = financialQuery +' FROM IPM_Financial__c where IPM_Project_Rollout__c in :regionalLevelIDs OR Regional_Project__c in :regionalLevelIDs';
        
        List<IPM_Financial__c> existingFinancialList = database.query(financialQuery);
        
        Map<String,IPM_Financial__c> existingFinancialMap = new Map<String,IPM_Financial__c>();
        
        for(IPM_Financial__c financial : existingFinancialList)
        {
            existingFinancialMap.put(financial.Financial_External_Id__c,financial);
        }
        
        return existingFinancialMap;
    }
    
    
    
       
}