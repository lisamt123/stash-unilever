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
    
    private Map<String, IPM_Financial__c> mapUpsertFinancials;
    private Map<String, List<String>> mapProjectRolloutCountries;
    
    private List<IPM_Country__c> lstDeleteCountries;
    private List<IPM_Financial__c> lstDeleteFinancials;
    private List<IPM_Project_Rollout__c> lstDeleteRollouts;
    
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    
    /*****************************************************************************************************************************
    * @description      Constructor
    */
    public IPM_RolloutTriggerHandler(){
        system.debug(logginglevel.error, 'entry in constructor IPM_RolloutTriggerHandler');        
        mapUpsertFinancials = new Map<String, IPM_Financial__c>();
        lstDeleteCountries = new List<IPM_Country__c>();
        lstDeleteFinancials = new List<IPM_Financial__c>();
        lstDeleteRollouts = new List<IPM_Project_Rollout__c>();
        mapProjectRolloutCountries = new Map<String, List<String>>();
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
        Set<String> setLocalRolloutNames = new Set<String>();
        
        Set<String> setCurrentRolloutIds = new Set<String>();        
        Set<String> setFinancialExternalIds = new Set<String>();
        
        For(IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
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
                setLocalRolloutNames.add(projectRollout.IPM_Rollout_Project__c);
            }           
        }
         
        if(!setRegionalRolloutNames.isEmpty())
        {
            List<IPM_Project_Rollout__c> compositeRolloutsList = [SELECT Id, IPM_Rollout_Project__c,IPM_Project__r.IPM_Phase__c,(SELECT Id,IPM_Rollout_Project__c,KeyMCO__c FROM Local_Rollouts__r),
                                        (SELECT Id,Financial_External_Id__c FROM IPM_Financials__r)
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
                        if(!setCurrentRolloutIds.contains(localRollout.Id))
                        {
                            lstDeleteRollouts.add(localRollout); 
                            setLocalRolloutNames.add(localRollout.IPM_Rollout_Project__c); 
                        }    
                    }
    
                    //Add All Regional Financials for deletion 
                    for(IPM_Financial__c ipmFinancial : regionalRollout.IPM_Financials__r)
                    {
                        lstDeleteFinancials.add(ipmFinancial);
                    }                
                    
                }
                //REGIONAL ROLLOUT NOT BEING DELETED
                else 
                {
                    Set<String> setNonKeyRolloutIds = new Set<String>();
                    Set<String> setLocalRolloutIds = new Set<String>();
                    
                    for (IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r)
                    {
                        setLocalRolloutIds.add(localRollout.Id);
                        
                        if(regionalRollout.IPM_Project__r.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS) 
                        { // If it is a Key MCO and stage is ideas, delete the corresponding financial.
                            if(localRollout.KeyMCO__c)
                            {
                                if(setCurrentRolloutIds.contains(localRollout.Id)) 
                                {
                                    setFinancialExternalIds.add(localRollout.IPM_Rollout_Project__c);
                                }
                            } 
                            else
                            {   // If it is not a key Rollout,then add it to non key to get composite list of non keys.
                                setNonKeyRolloutIds.add(localRollout.Id);
                            }
                        }
                        else
                        {
                            if(setCurrentRolloutIds.contains(localRollout.Id)) 
                            {
                                setFinancialExternalIds.add(localRollout.IPM_Rollout_Project__c);
                            }
                        }
                    }
                    
                    //ALL Local Rollouts being deleted 
                    if(setCurrentRolloutIds.containsAll(setLocalRolloutIds)  && !setCurrentRolloutIds.contains(regionalRollout.Id))
                    {
                        lstDeleteRollouts.add(regionalRollout);                 
                    }
                    
                     //ALL Local Rollouts being deleted
                     if(setCurrentRolloutIds.containsAll(setNonKeyRolloutIds)) 
                     {
                        setFinancialExternalIds.add(regionalRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_NONKEY);
                     }
                }           
            }
        }
        
        if(!setRegionalProjectNames.isEmpty())
        {
            List<IPM_Project__c> compositeProjectList = [SELECT Id,IPM_Project_Name__c,IPM_Phase__c,(SELECT Id,IPM_Rollout_Project__c,KeyMCO__c FROM Regional_Project_Rollout__r)
                                                        FROM IPM_Project__c
                                                        WHERE IPM_Project_Name__c IN: setRegionalProjectNames Limit 50000];
            
            for(IPM_Project__c project :compositeProjectList)
            {
                Set<String> setNonKeyRolloutIds = new Set<String>();
                Set<String> setLocalRolloutIds = new Set<String>();
                
                for (IPM_Project_Rollout__c localRollout : project.Regional_Project_Rollout__r)
                {   
                    if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS) 
                    {
                        if(localRollout.KeyMCO__c)
                        {
                            if(setCurrentRolloutIds.contains(localRollout.Id) )
                            {
                                setFinancialExternalIds.add(localRollout.IPM_Rollout_Project__c);
                            }   
                        }
                        else
                        {
                            setNonKeyRolloutIds.add(localRollout.Id);         
                        }    
                    }
                    else
                    { // If the phase is after ideas dont delete non key rollouts.
                        if(setCurrentRolloutIds.contains(localRollout.Id) )
                        {
                            setFinancialExternalIds.add(localRollout.IPM_Rollout_Project__c);
                        }
                    }
                }
                 
                // Delete financials for non key if all rollouts associated with 
                if(setCurrentRolloutIds.containsAll(setNonKeyRolloutIds)) 
                {
                   setFinancialExternalIds.add(project.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY);
                }  
            }
        } 
              
        //Delete Countries
        List<IPM_Project_Rollout__c> lstLocRollOuts = [SELECT Id, IPM_Rollout_Project__c, (SELECT Id FROM IPM_Countries_Local__r)
                            FROM IPM_Project_Rollout__c
                            WHERE IPM_Rollout_Project__c IN: setLocalRolloutNames Limit 50000];
                            
        for(IPM_Project_Rollout__c localRollout : LstLocRollOuts)
        {
            lstDeleteCountries.addAll(localRollout.IPM_Countries_Local__r);
        }
        
        if(lstDeleteCountries != NULL && !lstDeleteCountries.isEmpty())
        {                
            delete lstDeleteCountries;
        }
         
        //Delete Financials
        List<IPM_Financial__c> lstFinancials = [SELECT Id FROM IPM_Financial__c WHERE Financial_External_Id__c IN: setFinancialExternalIds LIMIT 50000];
        
        if(!lstFinancials.isEmpty())
        {
            delete lstFinancials;
        }
  
        if(lstDeleteRollouts != NULL && !lstDeleteRollouts.isEmpty() && !IPM_RolloutTriggerHandler.RECURSIVE_CONTEXT)
        {                             
            RECURSIVE_CONTEXT = true;
            delete lstDeleteRollouts;
        }
        
        IPM_ProcessRolloutStatusAndDates.execute(new Set<Id>(), new Set<Id>(), setCurrentRolloutIds);                
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
        rolloutQuery = rolloutQuery +' Regional_Project__r.IPM_Parent_Project__c,Name,RecordTypeId,Id FROM IPM_Project_Rollout__c ';
        String rolloutWhereClause = ' WHERE Id in :lstProjectRollouts LIMIT 50000';
        rolloutQuery = rolloutQuery + rolloutWhereClause;
        
        System.debug(LoggingLevel.ERROR,rolloutQuery);
        
        lstProjectRollouts = database.query(rolloutQuery);
        
        for (IPM_Project_Rollout__c projectRollout : lstProjectRollouts)
        {       
            ///Regional Rollout
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
            {
                IPM_Financial__c newFinancial;
                String externalId = projectRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                if(mapUpsertFinancials.containsKey(externalId))
                {
                    newFinancial = mapUpsertFinancials.get(externalId);   
                }
                else
                {   
                    newFinancial = new IPM_Financial__c(Parent_Project__c = projectRollout.IPM_Project__c,IPM_Project_Rollout__c = projectRollout.Id,
                                                        RecordtypeId = CONSOLIDATED_FINANCIAL_RECORDTYPE,Financial_External_ID__c = externalId,Target_Launch_Date__c = projectRollout.Target_Launch_Date__c,
                                                        Project_Sustainability_Period__c = projectRollout.Calculated_Sustainability_Period__c,Added_At_Stage__c = projectRollout.Added_At_Stage__c 
                                                       );
                }
                mapUpsertFinancials.put(externalId, newFinancial);
            }             
            else 
            {
                IPM_Financial__c newFinancial;
                String externalId = getFinancialExternalId(projectRollout);
                if(mapUpsertFinancials.containsKey(externalId))
                {
                    newFinancial = mapUpsertFinancials.get(externalId);   
                }
                else
                {    
                    newFinancial = new IPM_Financial__c(
                        RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                        Financial_External_ID__c = externalId,
                        Target_Launch_Date__c = projectRollout.Target_Launch_Date__c,
                        Project_Sustainability_Period__c = projectRollout.Calculated_Sustainability_Period__c,
                        Added_At_Stage__c = projectRollout.Added_At_Stage__c
                    );  
                }
                
                //Checks for Regional Original & Regional Rollout Projects
                if(projectRollout.Regional_Project__c != null)
                {
                    newFinancial.Regional_Project__c = projectRollout.Regional_Project__c;
                }
                else
                {
                    newFinancial.IPM_Project_Rollout__c = projectRollout.Regional_Rollout__c;
                }
                
                mapUpsertFinancials.put(externalId, newFinancial);
                
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
                    IPM_ProcessRolloutStatusAndDates.execute(setGlobalProjectIds, setRegionalOriginalProjectIds);
                }
        }
        
    }
    
    /*******************************************************************************************************
    * @description              Method to get Financial External Id
    * @param projectRollout     Rollout for which external id needs o be generated
    * @return                   Financial External Id
    */
    private String getFinancialExternalId(IPM_Project_Rollout__c projectRollout)
    {
        if(projectRollout.Regional_Project__c != null && projectRollout.Regional_Rollout__c == null && !projectRollout.IPM_Regional_Original_Project__c)
        {
            return projectRollout.IPM_Rollout_Project__c;
        }
        else if (projectRollout.KeyMCO__c)
        {
            return projectRollout.IPM_Rollout_Project__c;
        }
        else
        {
            return projectRollout.Regional_Rollout_External_Id__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
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
        lstDeleteFinancials = new List<IPM_Financial__c>();
        
        Set<String> setDeleteFinancialExternalIds = new Set<String>();
        
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
        
        Set<String> nonKeyFinancialExistingSet = new Set<String>();
        
        List<IPM_Project_Rollout__c> lstProjRegRollouts = [SELECT Id, IPM_Rollout_Project__c,(SELECT Id,IPM_Rollout_Project__c,KeyMCO__c FROM Local_Rollouts__r), 
                                                            (SELECT Id,Financial_External_Id__c FROM IPM_Financials__r) FROM IPM_Project_Rollout__c 
                                                            WHERE IPM_Rollout_Project__c IN: setRegionalRolloutNames Limit 50000];
                                                                                                  
        for(IPM_Project_Rollout__c regionalRollout : lstProjRegRollouts)
        {
            for(IPM_Financial__c ipmFinancial : regionalRollout.IPM_Financials__r)
            {
                if(ipmFinancial.Financial_External_Id__c.equalsIgnoreCase(regionalRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_NONKEY))
                {
                    nonKeyFinancialExistingSet.add(ipmFinancial.Financial_External_Id__c);
                }                                          
            }
            
            Boolean nonkeyRolloutExists = false;
            IPM_Project_Rollout__c newNonKeyRollout = null; 
            for(IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r)
            {
                if(!localRollout.KeyMCO__c)
                {
                    nonkeyRolloutExists = true;
                    if(mapNewProjectRollouts.containsKey(localRollout.Id))
                    {
                        newNonKeyRollout = mapNewProjectRollouts.get(localRollout.Id);
                        break;    
                    }                                      
                    
                }
            }
            
            String financialExternalId = regionalRollout.IPM_Rollout_Project__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            if(!nonkeyRolloutExists)
            {
                setDeleteFinancialExternalIds.add(financialExternalId);
            }
            else
            {
                if(!nonKeyFinancialExistingSet.contains(financialExternalId) && newNonKeyRollout!=null)
                {
                    IPM_Financial__c newFinancial = new IPM_Financial__c(
                            IPM_Project_Rollout__c = regionalRollout.Id,
                            RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                            Financial_External_ID__c = financialExternalId,
                            Target_Launch_Date__c = newNonKeyRollout.Target_Launch_Date__c,
                            Project_Sustainability_Period__c = newNonKeyRollout.Calculated_Sustainability_Period__c,
                            Added_At_Stage__c = newNonKeyRollout.Added_At_Stage__c
                        );
                        
                    mapUpsertFinancials.put(financialExternalId, newFinancial);        
                }  
            }
        }
        
        if(!setRegionalProjectNames.isEmpty())
        {
            List<IPM_Project__c> lstRegionalProjects = [SELECT Id,IPM_Project_Name__c,(SELECT Id,IPM_Rollout_Project__c,KeyMCO__c FROM Regional_Project_Rollout__r),
                                                        (SELECT Id,Financial_External_Id__c FROM IPM_Financials_Regional__r) FROM IPM_Project__c
                                                        WHERE IPM_Project_Name__c IN: setRegionalProjectNames Limit 50000];
            
        
            for(IPM_Project__c regionalProject : lstRegionalProjects)
            {
                for(IPM_Financial__c ipmFinancial : regionalProject.IPM_Financials_Regional__r)
                {
                    if(ipmFinancial.Financial_External_Id__c.equalsIgnoreCase(regionalProject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY))
                    {
                        nonKeyFinancialExistingSet.add(ipmFinancial.Financial_External_Id__c);
                    }                                          
                }
                
                Boolean nonkeyRolloutExists = false;
                IPM_Project_Rollout__c newNonKeyRollout = null;
                System.debug(LoggingLevel.ERROR,'Local Rollouts-->>'+regionalProject.Regional_Project_Rollout__r);
                System.debug(LoggingLevel.ERROR,'mapNewProjectRollouts-->>'+mapNewProjectRollouts); 
                for(IPM_Project_Rollout__c localRollout : regionalProject.Regional_Project_Rollout__r)
                {
                    if(!localRollout.KeyMCO__c)
                    {
                        nonkeyRolloutExists = true;
                        if(mapNewProjectRollouts.containsKey(localRollout.Id))
                        {
                            newNonKeyRollout = mapNewProjectRollouts.get(localRollout.Id);
                            break;    
                        }
                        System.debug(LoggingLevel.ERROR,'newNonKeyRollout-->>'+newNonKeyRollout);                                      
                    }
                }
                
                String financialExternalId = regionalProject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
                if(!nonkeyRolloutExists)
                {
                    setDeleteFinancialExternalIds.add(financialExternalId);
                }
                else
                {
                    if(!nonKeyFinancialExistingSet.contains(financialExternalId) && newNonKeyRollout!=null)
                    {
                        IPM_Financial__c newFinancial = new IPM_Financial__c(
                                Regional_Project__c = regionalProject.Id,
                                RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                                Financial_External_ID__c = financialExternalId,
                                Target_Launch_Date__c = newNonKeyRollout.Target_Launch_Date__c,
                                Project_Sustainability_Period__c = newNonKeyRollout.Calculated_Sustainability_Period__c,
                                Added_At_Stage__c = newNonKeyRollout.Added_At_Stage__c
                            );
                            
                        mapUpsertFinancials.put(financialExternalId, newFinancial);        
                    }  
                }
            }
        }

        //For Rollout Status Updates
        Set<Id> setGlobalProjectIds = new Set<Id>();
        Set<Id> setRegionalOriginalProjectIds = new Set<Id>();
        //system.debug(loggingLevel.error, 'new map --> ' + mapNewProjectRollouts);
        
        for(IPM_Project_Rollout__c newRollout : mapNewProjectRollouts.values())
        {
            if(newRollout.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
            {
                Id regionalRollout = newRollout.Regional_Rollout__c;
                
                IPM_Project_Rollout__c oldRollout = mapOldProjectRollouts.get(newRollout.Id);
                
                if(newRollout.KeyMCO__c)
                {
                    //Insert key financial
                    IPM_Financial__c newFinancial;
                    String externalId = getFinancialExternalId(newRollout);
                    if(mapUpsertFinancials.containsKey(externalId))
                    {
                        newFinancial = mapUpsertFinancials.get(externalId);
                    }
                    else
                    {
                        newFinancial = new IPM_Financial__c(
                            RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                            Financial_External_ID__c = externalId,
                            Target_Launch_Date__c = newRollout.Target_Launch_Date__c,
                            Project_Sustainability_Period__c = newRollout.Calculated_Sustainability_Period__c,
                            Added_At_Stage__c = newRollout.Added_At_Stage__c
                        );
                        
                        if(newRollout.Regional_Rollout__c !=null)
                        {
                            newFinancial.IPM_Project_Rollout__c = newRollout.Regional_Rollout__c;
                        }
                        if(newRollout.Regional_Project__c !=null)
                        {
                            newFinancial.Regional_Project__c = newRollout.Regional_Project__c;
                        }
                        
                    }
                    mapUpsertFinancials.put(externalId, newFinancial); 
                }
                else if(oldRollout.KeyMCO__c)
                {//IF WAS KEY BEFORE DELETE Key Financial.
                    setDeleteFinancialExternalIds.add(getFinancialExternalId(oldRollout));
                }
                
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
        
        
        List<IPM_Financial__c> lstFinancials = [SELECT Id FROM IPM_Financial__c WHERE Financial_External_Id__c IN: setDeleteFinancialExternalIds];
        if(lstFinancials != null && !lstFinancials.isEmpty())
        {
            delete lstFinancials;
        }
         

            if (!mapUpsertFinancials.isEmpty())
            {
                upsert mapUpsertFinancials.values() IPM_Financial__c.Financial_External_Id__c; 
            }
            
            if((!setGlobalProjectIds.isEmpty()) || (setRegionalOriginalProjectIds != NULL && !setRegionalOriginalProjectIds.isEmpty()))
            {
                IPM_ProcessRolloutStatusAndDates.execute(setGlobalProjectIds, setRegionalOriginalProjectIds);
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
}