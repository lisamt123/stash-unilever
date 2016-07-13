public with sharing class IPM_StopProjectHelper 
{
    // Set of all Projects which are going to be Stopped including explicit and implicit stops.
    public static Map<Id,Set<Id>> parentToStoppedChildProjectIds = new Map<Id,Set<Id>>(); 
    public static Map<string,map<string,boolean>> projStopMapArc = new map<string,map<string,boolean>> 
    {
        IPM_ConstantUtils.PROJECT_SPAN_GLOBAL => new map<string,boolean>{ IPM_ConstantUtils.SHOW_AT_GLOBAL => true,IPM_ConstantUtils.SHOW_AT_REGIONAL => true,IPM_ConstantUtils.SHOW_AT_LOCAL =>true },
        IPM_ConstantUtils.PROJECT_SPAN_REGIONAL => new map<string,boolean>{ IPM_ConstantUtils.SHOW_AT_GLOBAL => false,IPM_ConstantUtils.SHOW_AT_REGIONAL => true,IPM_ConstantUtils.SHOW_AT_LOCAL =>true},
        IPM_ConstantUtils.PROJECT_SPAN_LOCAL => new map<string,boolean>{ IPM_ConstantUtils.SHOW_AT_GLOBAL => false,IPM_ConstantUtils.SHOW_AT_REGIONAL => false,IPM_ConstantUtils.SHOW_AT_LOCAL =>true }
    };

    public static Map<Id,IPM_Project__c> relatedProjectsToStopMap = new Map<Id,IPM_Project__c>();
    public static Map<Id,IPM_Project_Document__c> relatedProjectDocToStopMap = new Map<Id,IPM_Project_Document__c>();
    public static Map<Id,IPM_Task__c> relatedProjectTaskToStopMap = new Map<Id,IPM_Task__c>();
    public static Map<Id,IPM_Project_Resource__c> relatedProjectResourceToStopMap = new Map<Id,IPM_Project_Resource__c>();
    public static Map<Id,IPM_Project_Rollout__c> relatedRolloutsToStopMap = new Map<Id,IPM_Project_Rollout__c>();
    public static Map<Id,IPM_financial__c> relatedFinancialsToStopMap = new Map<Id,IPM_financial__c>();
    public static Map<Id,IPM_Country__c> relatedCountryToStopMap = new Map<Id,IPM_Country__c>();

    public static Map<String,IPM_Project_Metadata__mdt> projectMetadataMap = new  Map<String,IPM_Project_Metadata__mdt>();
    
    public static void populateMetadata() 
    {
        if(projectMetadataMap.isEmpty())
        {
            String projectMetadataQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Metadata__mdt',false,null,true);
            List<IPM_Project_Metadata__mdt> projectMetadataList = (List<IPM_Project_Metadata__mdt>)database.Query(projectMetadataQuery);
            for(IPM_Project_Metadata__mdt projectMetada : projectMetadataList)
            {
                projectMetadataMap.put(projectMetada.Label,projectMetada);
            }
        }
    }

    public static void populateProjectData(IPM_Project__c incomingProject, IPM_Project__c sourceProject)
    {
        
        incomingProject.IPM_Stopped_Date_Time__c = System.now();    
        incomingProject.IPM_PreviouslyStoppedBy__c = incomingProject.IPM_Stopped_By__c; 
        incomingProject.IPM_Stopped_By__c = UserInfo.getUserId();
        incomingProject.IPM_Stopped_Phase__c = incomingProject.IPM_Phase__c;
        incomingProject.IPM_Stopped_At_Span__c = incomingProject.IPMProject_Span__c;
        incomingProject.IPM_Document_Update_Comments__c = incomingProject.IPM_Stopped_Comments__c;
        
        if(sourceProject!=null)
        {
            incomingProject.IPM_Stopped_Date_Time__c = sourceProject.IPM_Stopped_Date_Time__c;    
            incomingProject.IPM_StoppedByProjectPhase__c = sourceProject.IPM_Phase__c;
            incomingProject.IPM_Stopped_Comments__c = sourceProject.IPM_Stopped_Comments__c;
            incomingProject.IPM_Stopped_At_Span__c = sourceProject.IPMProject_Span__c;
            incomingProject.IPM_Document_Update_Comments__c = sourceProject.IPM_Stopped_Comments__c;
            incomingProject.IPM_PrepareForArchival__c = sourceProject.IPM_PrepareForArchival__c;
            incomingProject.Is_Archieved__c = sourceProject.Is_Archieved__c;
            incomingProject.IPM_Cluster__c = sourceProject.IPM_Cluster__c;
            incomingProject.IPM_StoppedByProject__c   = sourceProject.Id; 
        }
    }

    public static void clearProjectData(IPM_project__c incomingProject)
    {
        incomingProject.IPM_PrepareForArchival__c = false;    
        incomingProject.Is_Archieved__c =  false; 
        incomingProject.IPM_Stopped_Date_Time__c = null;  
        incomingProject.IPM_ProjectStoppedDatetime__c = null;
        incomingProject.IPM_PreviouslyStoppedBy__c = incomingProject.IPM_Stopped_By__c;
        incomingProject.IPM_Stopped_By__c = null;
        incomingProject.IPM_Stopped_Phase__c = null;
        incomingProject.IPM_StoppedByProjectPhase__c = null;
        incomingProject.IPM_Stopped_At_Span__c = null;
        incomingProject.IPM_Document_Update_Comments__c = null;
        incomingProject.IPM_Stopped_Comments__c = null;
        incomingProject.IPM_StoppedByProject__c = null;
        incomingProject.IPM_CancelStoppingProjectTill__c = null;
        if(incomingProject.IPM_PreviousDocumentStatus__c!=null &&  (incomingProject.IPM_Current_Document_Status__c == IPM_ConstantUtils.BLANK ||
             incomingProject.IPM_Current_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED ) ) 
        {
            incomingProject.IPM_Current_Document_Status__c = incomingProject.IPM_PreviousDocumentStatus__c;
        }
        incomingProject.IPM_PreviousDocumentStatus__c = null;
    }

    public static void prepareDataForArchiving(IPM_Project__c incomingProject,IPM_Project__c oldProject)
    {
        populateMetadata(); 
        if(incomingProject.IPM_PrepareForArchival__c !=null && !incomingProject.Is_Archieved__c &&  incomingProject.IPM_PrepareForArchival__c != oldProject.IPM_PrepareForArchival__c)
        {
            if(incomingProject.IPM_PrepareForArchival__c)
            {
                

                Integer cancelStopProjectDuration = 4320;

                if(projectMetadataMap.containsKey(incomingProject.IPM_ProjectGKM__c))
                {

                    IPM_Project_Metadata__mdt projectMetadata  = projectMetadataMap.get(incomingProject.IPM_ProjectGKM__c);
                    if(projectMetadata.IPM_CancelStopProjectDuration__c > 0 )
                    {
                        cancelStopProjectDuration = Integer.valueOf(projectMetadata.IPM_CancelStopProjectDuration__c);    
                    }
                }

                incomingProject.IPM_CancelStoppingProjectTill__c = System.now().addMinutes(cancelStopProjectDuration);
                incomingProject.IPM_ProjectStoppedDatetime__c = incomingProject.IPM_CancelStoppingProjectTill__c.format();
                populateProjectData(incomingProject,null);
            }
            else
            {
               clearProjectData(incomingProject);
            } 
        } 
    }

    public static void prepareDataForArchieve(IPM_Project__c incomingProject,IPM_Project__c oldProject)
    {
        if(incomingProject.Is_Archieved__c !=null && incomingProject.Is_Archieved__c != oldProject.Is_Archieved__c)
        {
            if(incomingProject.Is_Archieved__c) 
            { 
                // Set Prepare for Archieve as False. Set Cluster as null.
                incomingProject.IPM_PrepareForArchival__c = false;
                incomingProject.IPM_Cluster__c =null;
                incomingProject.IPM_PreviousDocumentStatus__c = incomingProject.IPM_Current_Document_Status__c;
                incomingProject.IPM_Current_Document_Status__c = IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED;   
                populateProjectData(incomingProject,null);

                
            } 
            else 
            {
                clearProjectData(incomingProject);
            }
        }
    }

    
    public static void processArchiving(Map<Id,IPM_Project__c> projectArchivingMap) 
    {
        Map<Id,IPM_Project__c> relatedArchvingProjectsMap = new Map<Id,IPM_Project__c>(); 
        Map<Id,Set<Id>> parentToChildProjectIds = new Map<Id,Set<Id>>(); 
        set<Id> projectArchivingIdSet =  new Set<Id>(projectArchivingMap.keySet()); 
        

        while (!projectArchivingIdSet.isEmpty()) 
        {
             //query project to get its parent and child project ids irrespective of archived or not archived
            parentToChildProjectIds.putAll(IPM_Utils.getImmediateChildProjects(projectArchivingIdSet));             
        }

        // Final List of Projects to be stopped including implicit and explicit stopping.
        Set<Id> resultantPrepareStoppedProjectIdSet = parentToChildProjectIds.KeySet();

        String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,false);
        String projectWhereClause = ' WHERE Id in :resultantPrepareStoppedProjectIdSet AND Is_Archieved__c = false LIMIT 10000';
        projectQuery = projectQuery + projectWhereClause;
        Map<Id,IPM_Project__c> prepareStopProjectMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(projectQuery));

    
        // Again reassign the Set of Projects Stopped by User.  
        projectArchivingIdSet = new Set<Id>(projectArchivingMap.keySet()); 

        for(Id userPrepareStoppedProjId : projectArchivingIdSet) 
        {
            IPM_Project__c userPrepareStoppedProject = prepareStopProjectMap.get(userPrepareStoppedProjId); 

            Set<Id> allChildProjectSet = new Set<Id>();
            
            // This would get you all the child Projects which are not archieved.
            IPM_Utils.getAllChildProjects(userPrepareStoppedProjId,userPrepareStoppedProjId,parentToChildProjectIds,allChildProjectSet);
            
            for(Id childProjectId : allChildProjectSet) 
            {
                // However, we only need child projects impacted by source Project.
                if(prepareStopProjectMap.containsKey(childProjectId))
                {
                    IPM_Project__c childProject = prepareStopProjectMap.get(childProjectId); 

                    childProject.IPM_CancelStoppingProjectTill__c = userPrepareStoppedProject.IPM_CancelStoppingProjectTill__c;
                    childProject.IPM_ProjectStoppedDatetime__c = userPrepareStoppedProject.IPM_CancelStoppingProjectTill__c.format();

                    populateProjectData(childProject,userPrepareStoppedProject);

                    relatedArchvingProjectsMap.put(childProjectId,childProject);
                }
                
            }
            // In Case the Original DML Project Records gets invoked.
            relatedArchvingProjectsMap.remove(userPrepareStoppedProjId);
        }

        if(!relatedArchvingProjectsMap.isEmpty())
        {
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            IPM_ProjectHandler.INSIDE_PREPARE_STOP_PROJECT = true;

            update relatedArchvingProjectsMap.values();

            IPM_ProjectHandler.INSIDE_PREPARE_STOP_PROJECT = false; 
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
        }
    }


    public static void processUnArchiving(Map<Id,IPM_Project__c> cancelStopProjectMap )
    {
        Map<Id,IPM_Project__c> relatedUnArchvingProjectsMap = new Map<Id,IPM_Project__c>(); 
        
        for(IPM_Project__c impactedProject : [SELECT Id,IPM_StoppedByProject__c  FROM IPM_Project__c WHERE IPM_StoppedByProject__c IN : cancelStopProjectMap.keySet() and IPM_PrepareForArchival__c = true limit 10000])
        {
            IPM_Project__c userCancelledStoppedProject = cancelStopProjectMap.get(impactedProject.IPM_StoppedByProject__c);
            clearProjectData(impactedProject);
            relatedUnArchvingProjectsMap.put(impactedProject.Id,impactedProject);

            // In Case the Original DML Project Records gets invoked.
            relatedUnArchvingProjectsMap.remove(userCancelledStoppedProject.Id);
        }
 
        if(!relatedUnArchvingProjectsMap.isEmpty())
        { 
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            IPM_ProjectHandler.INSIDE_PREPARE_STOP_PROJECT = true;  

            update relatedUnArchvingProjectsMap.values();
            
            IPM_ProjectHandler.INSIDE_PREPARE_STOP_PROJECT = false; 
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;  
        }
    }

    
    /***********************************************************************
    @Description : when project is stopped its child projects should be stopped and country, rollout, financials should  be made inactive
    @param: Set<Id> stoppedProjectMap
    @Release:1.2
    **********************************************************************/
    public static void processArchival(map<Id,IPM_Project__c> archivalProjectMap)
    { 
        relatedProjectsToStopMap = new Map<Id,IPM_Project__c>();
        relatedProjectDocToStopMap = new Map<Id,IPM_Project_Document__c>();
        relatedProjectTaskToStopMap = new Map<Id,IPM_Task__c>();
        relatedProjectResourceToStopMap = new Map<Id,IPM_Project_Resource__c>();
        relatedRolloutsToStopMap = new Map<Id,IPM_Project_Rollout__c>();
        relatedFinancialsToStopMap = new Map<Id,IPM_financial__c>();
        relatedCountryToStopMap = new Map<Id,IPM_Country__c>();

        IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION = true; 
        IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
        IPM_TaskHelper.SKIP_TRIGGER_EXECUTION = true;
        IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;

        // Set of Projects Stopped by User. 
        set<Id> stoppedProjectIdSet =  new Set<Id>(archivalProjectMap.keySet()); 
        
        while (!stoppedProjectIdSet.isEmpty())  
        {
             //query project to get its parent and child project ids
            parentToStoppedChildProjectIds.putAll(IPM_Utils.getImmediateChildProjects(stoppedProjectIdSet)); 
        }
        // Again reassign the Set of Projects Stopped by User. 
        stoppedProjectIdSet = new Set<Id>(archivalProjectMap.keySet()); 

        // Final List of Projects to be stopped including implicit and explicit stopping.
        Set<Id> resultantStoppedProjectIdSet = parentToStoppedChildProjectIds.KeySet();

        //query all data associated with stopped/restarted project, its parent and child projects  
        Map<Id,IPM_Project__c> stopProjectMap =  new map<Id,IPM_Project__c>([SELECT Id,Name,IPM_Cluster__c,IPM_Phase__c,IPM_Stopped_Phase__c,IPM_StoppedByProjectPhase__c,IPM_StoppedByProject__c,IPM_PreviouslyStoppedBy__c,IPM_PrepareForArchival__c,IPM_Parent_Project__c,IPM_PreviousDocumentStatus__c,IPM_Project_Rollout__c,Is_Archieved__c,IPM_Stopped_Date_Time__c,IPM_Stopped_By__c,IPM_Stopped_Comments__c,IPM_Current_Document_Status__c,IPM_Document_Update_Comments__c,IPM_Parent_Project__r.IPM_Parent_Project__c,IPMProject_Span__c,IPM_Current_Gate_Name__c,IPM_Stopped_At_Span__c,
        (SELECT id,IPM_Stopped_Date__c,IPM_Updated_User_By__c,IPM_Stopped_Comments__c,IPM_Document_Status__c,IPM_GateDocuments__c From Project_Documents__r limit 10000),
        (SELECT id from Tasks__r where IPM_Active__c = true limit 10000), 
        (SELECT id from IPM_Countries__r where isActive__c = true limit 10000),
        (SELECT id from IPM_Countries1__r where isActive__c = true limit 10000),
        (SELECT id from IPM_Countries2__r where isActive__c = true limit 10000),
        (SELECT id from IPM_Project_Resources__r  limit 10000), 
        (SELECT id from IPM_Project_Rollout__r  where isActive__c = true limit 10000),
        (SELECT id from Regional_Project_Rollout__r  where isActive__c = true limit 10000),
        (SELECT id from Local_Project_Rollout__r  where isActive__c = true limit 10000),
        (SELECT id from IPM_Financials_Consolidated__r where isActive__c = true limit 10000),
        (SELECT id from IPM_Financials_Regional__r where isActive__c = true limit 10000),
        (SELECT id from IPM_Financials_Local__r where isActive__c = true limit 10000),
        (SELECT Id,IPM_Target_Launch_Dates__c,IPM_Project_Name__c,IPM_Cluster__c,IPM_PrepareForArchival__c,Rollout_Plan_Target_Launch_Date__c,IPM_Temporary_Phase__c from IPM_Projects__r where Is_Archieved__c = false)
        FROM IPM_Project__c 
        WHERE Id in:stoppedProjectIdSet OR ( Id IN : resultantStoppedProjectIdSet AND Is_Archieved__c = false) limit 10000]);
        
        for(Id userStoppedProjectId : stoppedProjectIdSet)
        {  
            if(stopProjectMap.containsKey(userStoppedProjectId))
            {
                IPM_Project__c userStoppedProject = stopProjectMap.get(userStoppedProjectId);     
               
                /* Logic for stopped Project & Documents */
                Map<Id,IPM_Project__c> childProjectMap = new Map<Id,IPM_Project__c>();
                Map<Id,IPM_Project_Document__c> childProjectDocumentMap = new Map<Id,IPM_Project_Document__c>();
                Map<Id,IPM_Task__c>childProjectTaskMap = new Map<Id,IPM_Task__c>();
                Map<Id,IPM_Project_Resource__c> childProjectResourceMap = new Map<Id,IPM_Project_Resource__c>();
                Map<Id,IPM_Project_Rollout__c> childRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
                Map<Id,IPM_financial__c> childFinancialMap = new Map<Id,IPM_financial__c>();
                Map<Id,IPM_Country__c> childCountryMap = new Map<Id,IPM_Country__c>();

                getChildRelatedRecords(userStoppedProjectId,childProjectMap,childProjectDocumentMap,childProjectTaskMap,childProjectResourceMap,childRolloutMap,childFinancialMap,childCountryMap,stopProjectMap);
                
                // For double Checking 
                childProjectMap.remove(userStoppedProjectId); 

                for(Id childProjectId : childProjectMap.keySet())
                {
                    IPM_Project__c childProject = childProjectMap.get(childProjectId);
                    childProject.IPM_Cluster__c =null; 
                    childProject.IPM_PreviousDocumentStatus__c = userStoppedProject.IPM_PreviousDocumentStatus__c;
                    childProject.IPM_Current_Document_Status__c = userStoppedProject.IPM_Current_Document_Status__c;
                    populateProjectData(childProject,userStoppedProject);
                    relatedProjectsToStopMap.put(childProjectId,childProject);
                } 
                processProjectRelatedArchival(userStoppedProject,childProjectDocumentMap,childProjectTaskMap,childProjectResourceMap,childRolloutMap,childFinancialMap,childCountryMap);   
            }
        } 

        updateChildProjects(relatedProjectsToStopMap);
        updateprojectRelatedRecords(relatedProjectDocToStopMap,relatedProjectResourceToStopMap,relatedFinancialsToStopMap,relatedCountryToStopMap,relatedRolloutsToStopMap,relatedProjectTaskToStopMap);  
    }

    public static void processProjectRelatedArchival(IPM_Project__c userStoppedProject, Map<Id,IPM_Project_Document__c> childProjectDocumentMap, Map<Id,IPM_Task__c> childProjectTaskMap,Map<Id,IPM_Project_Resource__c> childProjectResourceMap,Map<Id,IPM_Project_Rollout__c> childRolloutMap,Map<Id,IPM_Financial__c> childFinancialMap,Map<Id,IPM_Country__c>  childCountryMap) 
    {
 
        String projectspan = userStoppedProject.IPMProject_Span__c;

        Map<String,Boolean> apiNameToValue = projStopMapArc.get(projectspan);

        for(Id taskId : childProjectTaskMap.keySet())
        { 
            IPM_Task__c projectTask = new IPM_Task__c(id = taskId,IPM_Active__c=false,IPM_StoppedByProject__c=userStoppedProject.Id);
            relatedProjectTaskToStopMap.put(projectTask.Id,projectTask);
        }
          
     
        for(Id projectDocId : childProjectDocumentMap.keySet())
        {
            IPM_Project_Document__c projectDoc = new IPM_Project_Document__c(id = projectDocId);
            projectDoc.IPM_Updated_User_By__c = UserInfo.getUserId();
            projectDoc.IPM_Stopped_Date__c = userStoppedProject.IPM_Stopped_Date_Time__c.date();
            projectDoc.IPM_Stopped_Comments__c = userStoppedProject.IPM_Stopped_Comments__c;
            projectDoc.IPM_Document_Status__c = userStoppedProject.IPM_Current_Document_Status__c;
            relatedProjectDocToStopMap.put(projectDocId,projectDoc);
        }

        for(Id resourceId : childProjectResourceMap.keySet())
        {
            IPM_Project_Resource__c projectResource = new IPM_Project_Resource__c(id = resourceId, IPM_NotifyProjectStop__c = true);
            relatedProjectResourceToStopMap.put(resourceId,projectResource);
        }

        for(Id rolloutId : childRolloutMap.keySet())
        {
            IPM_Project_Rollout__c rollout = new IPM_Project_Rollout__c(id = rolloutId,isActive__c=false,IPM_StoppedByProject__c=userStoppedProject.Id);
            for(String apiName : apiNameToValue.keySet())
            {   
                rollout.put(apiName,(Boolean)apiNameToValue.get(apiName));     
            }
            relatedRolloutsToStopMap.put(rolloutId,rollout);
        }

        for(Id financialId : childFinancialMap.keySet())
        {
            IPM_financial__c financial = new IPM_financial__c(id = financialId,isActive__c=false,IPM_StoppedByProject__c= userStoppedProject.Id);
            for(String apiName : apiNameToValue.keySet())
            {
                financial.put(apiName,(Boolean)apiNameToValue.get(apiName));
            }
            relatedFinancialsToStopMap.put(financialId,financial);
        }

        for(Id countryId : childCountryMap.keySet()) 
        {
            IPM_Country__c country = new IPM_Country__c(id = countryId,isActive__c=false,IPM_StoppedByProject__c=userStoppedProject.Id);
            for(String apiName : apiNameToValue.keySet())
            {
                country.put(apiName,(Boolean)apiNameToValue.get(apiName));
            }
            relatedCountryToStopMap.put(countryId,country);
        }
    }

    public static void processUnArchival(map<Id,IPM_Project__c> unArchieveProjectMap)
    {
        relatedProjectsToStopMap = new Map<Id,IPM_Project__c>();
        relatedProjectDocToStopMap = new Map<Id,IPM_Project_Document__c>();
        relatedProjectTaskToStopMap = new Map<Id,IPM_Task__c>();
        relatedProjectResourceToStopMap = new Map<Id,IPM_Project_Resource__c>();
        relatedRolloutsToStopMap = new Map<Id,IPM_Project_Rollout__c>();
        relatedFinancialsToStopMap = new Map<Id,IPM_financial__c>();
        relatedCountryToStopMap = new Map<Id,IPM_Country__c>();

        IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION = true;
        IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
        IPM_TaskHelper.SKIP_TRIGGER_EXECUTION = true;
        IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;

        // Set of Projects Stopped by User.
        set<Id> unArchieveProjectIdSet =  new Set<Id>(unArchieveProjectMap.keySet());

        //query all data associated with stopped/restarted project, its parent and child projects  
        Map<Id,IPM_Project__c> unArchieveRelatedProjectMap =  new map<Id,IPM_Project__c>([SELECT Id,Name,IPM_StoppedByProject__c,IPM_Parent_Project__c,
                IPM_PreviousDocumentStatus__c,IPM_Project_Rollout__c,Is_Archieved__c,IPM_Stopped_Date_Time__c,IPM_Stopped_By__c,IPM_Stopped_Comments__c,
                IPM_Current_Document_Status__c,IPM_Document_Update_Comments__c,IPM_Parent_Project__r.IPM_Parent_Project__c,IPMProject_Span__c,
                IPM_Current_Gate_Name__c,IPM_Stopped_At_Span__c,
        (SELECT id,IPM_Stopped_Date__c,IPM_Updated_User_By__c,IPM_Stopped_Comments__c,IPM_Document_Status__c,IPM_GateDocuments__c From Project_Documents__r limit 10000),
        (SELECT id from Tasks__r where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000), 
        (SELECT id from IPM_Countries__r where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000), 
        (SELECT id from IPM_Countries1__r where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT id from IPM_Countries2__r where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT id from IPM_Project_Resources__r  limit 10000), 
        (SELECT id from IPM_Project_Rollout__r  where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT id from Regional_Project_Rollout__r  where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT id from Local_Project_Rollout__r  where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT id from IPM_Financials_Consolidated__r where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT id from IPM_Financials_Regional__r where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT id from IPM_Financials_Local__r where IPM_StoppedByProject__c in :unArchieveProjectIdSet limit 10000),
        (SELECT Id,Name,IPM_StoppedByProject__c,IPM_Project_Name__c from IPM_Projects__r where Is_Archieved__c = true AND  IPM_StoppedByProject__c in :unArchieveProjectIdSet)
        FROM IPM_Project__c 
        WHERE Id in :unArchieveProjectIdSet OR ( IPM_StoppedByProject__c IN : unArchieveProjectIdSet AND Is_Archieved__c = true ) limit 10000]);
        
        for(IPM_Project__c dbProject : unArchieveRelatedProjectMap.values())
        {  
            // Get the Source Project.
            IPM_Project__c sourceProject = null; 

            if(dbProject.IPM_StoppedByProject__c != null )
            {
                sourceProject = unArchieveRelatedProjectMap.get(dbProject.IPM_StoppedByProject__c); 
            }
            
            // If Source Project Present means it is a child Project else it is a source Project.
            if(sourceProject != null)
            { 
                dbProject.IPM_Current_Document_Status__c = dbProject.IPM_PreviousDocumentStatus__c;
                clearProjectData(dbProject);
                relatedProjectsToStopMap.put(dbProject.Id,dbProject);
            }
            else
            {
               sourceProject = dbProject; 
            }

            processProjectRelatedUnArchival(dbProject,sourceProject); 
        } 

        updateChildProjects(relatedProjectsToStopMap);
        updateprojectRelatedRecords(relatedProjectDocToStopMap,relatedProjectResourceToStopMap,relatedFinancialsToStopMap,relatedCountryToStopMap,relatedRolloutsToStopMap,relatedProjectTaskToStopMap);  
    }

    public static void processProjectRelatedUnArchival(IPM_Project__c dbProject,IPM_Project__c sourceProject)
    {
        /* Logic for stopped Project & Documents */
        String projectspan = sourceProject.IPMProject_Span__c;
        Map<String,Boolean> apiNameToValue = projStopMapArc.get(projectspan);

        for(Id taskId : processProjectTaskStop(dbProject).keySet())
        {
            IPM_Task__c projectTask = new IPM_Task__c(id = taskId);
            projectTask.IPM_Active__c = true;
            projectTask.IPM_StoppedByProject__c = null;
            relatedProjectTaskToStopMap.put(projectTask.Id,projectTask);
        }
        
        for(Id projectDocId : processProjectDocumentStop(dbProject).keySet())
        {
            IPM_Project_Document__c projectDoc = new IPM_Project_Document__c(id = projectDocId);
            projectDoc.IPM_Stopped_Date__c = null;
            projectDoc.IPM_Stopped_Comments__c = null;
            projectDoc.IPM_Updated_User_By__c = UserInfo.getUserId();
            projectDoc.IPM_Document_Status__c = sourceProject.IPM_PreviousDocumentStatus__c; 
            relatedProjectDocToStopMap.put(projectDocId,projectDoc);
        }

        for(Id resourceId : processProjectResourceStop(dbProject).keySet())
        {
            IPM_Project_Resource__c projectResource = new IPM_Project_Resource__c(id = resourceId);
            projectResource.IPM_NotifyProjectStop__c = false;
            relatedProjectResourceToStopMap.put(resourceId,projectResource);
        }

        for(Id rolloutId : processRolloutStop(dbProject).keySet()) 
        {
            IPM_Project_Rollout__c rollout = new IPM_Project_Rollout__c(id = rolloutId,isActive__c= true,IPM_StoppedByProject__c= IPM_ConstantUtils.BLANK);
            for(String apiName : apiNameToValue.keySet())
            {   
                rollout.put(apiName,false);     
            }
            relatedRolloutsToStopMap.put(rolloutId,rollout);
        }

        for(Id financialId : processFinancialsStop(dbProject).keySet())
        {
            IPM_financial__c financial = new IPM_financial__c(id = financialId,isActive__c=true,IPM_StoppedByProject__c = IPM_ConstantUtils.BLANK);
            for(String apiName : apiNameToValue.keySet())
            {
                financial.put(apiName,false);
            }
            relatedFinancialsToStopMap.put(financialId,financial); 
        }

        for(Id countryId : processCountryStop(dbProject).keySet()) 
        {
            IPM_Country__c country = new IPM_Country__c(id = countryId,isActive__c= true ,IPM_StoppedByProject__c = IPM_ConstantUtils.BLANK);
            for(String apiName : apiNameToValue.keySet())
            {
                country.put(apiName,false);
            }
            relatedCountryToStopMap.put(countryId,country);
        }
    }

    

    public static void getChildRelatedRecords(Id stoppedProjectId,Map<Id,IPM_Project__c> childProjectMap,Map<Id,IPM_Project_Document__c> childProjectDocumentMap,Map<Id,IPM_Task__c> childProjectTaskMap, Map<Id,IPM_Project_Resource__c> childProjectResourcesMap,Map<Id,IPM_Project_Rollout__c> childRolloutMap, Map<Id,IPM_Financial__c> childFinancialMap, Map<Id,IPM_Country__c> childCountryMap,Map<Id,IPM_Project__c> masterProjectMap)
    {
        if(masterProjectMap.containsKey(stoppedProjectId))
        {
            IPM_Project__c stoppedProject = masterProjectMap.get(stoppedProjectId);
            Set<Id> childProjectIdSet = parentToStoppedChildProjectIds.get(stoppedProject.Id);  
            
            for(Id childProjectId : childProjectIdSet) 
            {
                getChildRelatedRecords(childProjectId,childProjectMap,childProjectDocumentMap,childProjectTaskMap,childProjectResourcesMap,childRolloutMap,childFinancialMap,childCountryMap,masterProjectMap); 
            }

            childProjectMap.put(stoppedProject.Id,stoppedProject);
            childProjectDocumentMap.putAll(processProjectDocumentStop(stoppedProject));
            childProjectTaskMap.putAll(processProjectTaskStop(stoppedProject));
            childProjectResourcesMap.putAll(processProjectResourceStop(stoppedProject));
            childRolloutMap.putAll(processRolloutStop(stoppedProject)); 
            childFinancialMap.putAll(processFinancialsStop(stoppedProject));
            childCountryMap.putAll(processCountryStop(stoppedProject));
        }
    }

    public static Map<Id,IPM_Task__c> processProjectTaskStop(IPM_Project__c stopProject)
    {
        Map<Id,IPM_Task__c> tempTaskMap = new Map<Id,IPM_Task__c>(); 
        tempTaskMap.putall(new Map<Id,IPM_Task__c>(stopProject.Tasks__r));
        return tempTaskMap;
    }

    public static Map<Id,IPM_Project_Document__c> processProjectDocumentStop(IPM_Project__c stopProject)
    {
        Map<Id,IPM_Project_Document__c> tempProjectDocumentMap = new Map<Id,IPM_Project_Document__c>();
        
        List<IPM_Project_Document__c> projectDocumentList = new List<IPM_Project_Document__c>();
        projectDocumentList.addAll(stopProject.Project_Documents__r);    
        
        for(IPM_Project_Document__c projectDoc : projectDocumentList)
        {
            if(stopProject.IPM_Current_Gate_Name__c == projectDoc.IPM_GateDocuments__c  )
            {
                tempProjectDocumentMap.put(projectDoc.Id,projectDoc);
            }
        }

        tempProjectDocumentMap.remove(null);
        
        return  tempProjectDocumentMap;
    }

    public static Map<Id,IPM_Project_Resource__c> processProjectResourceStop(IPM_Project__c stopProject)
    {
        Map<Id,IPM_Project_Resource__c> tempResourceMap = new Map<Id,IPM_Project_Resource__c>(); 
        tempResourceMap.putall(new Map<Id,IPM_Project_Resource__c>(stopProject.IPM_Project_Resources__r));
        tempResourceMap.remove(null);
        return tempResourceMap;
    }

    public static Map<Id,IPM_Project_Rollout__c> processRolloutStop(IPM_Project__c stopProject)
    {
        Map<Id,IPM_Project_Rollout__c> tempRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        tempRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>(stopProject.IPM_Project_Rollout__r));
        tempRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>(stopProject.Regional_Project_Rollout__r));
        tempRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>(stopProject.Local_Project_Rollout__r));
        tempRolloutMap.put(stopProject.IPM_Project_Rollout__c,new IPM_Project_Rollout__c(id=stopProject.IPM_Project_Rollout__c));
        tempRolloutMap.remove(null);
        return tempRolloutMap;
    }

    public static Map<Id,IPM_Financial__c> processFinancialsStop(IPM_Project__c stopProject)
    {
        Map<Id,IPM_Financial__c> tempFinancialMap = new Map<Id,IPM_Financial__c>();
        tempFinancialMap.putAll(new Map<Id,IPM_Financial__c>(stopProject.IPM_Financials_Consolidated__r));
        tempFinancialMap.putAll(new Map<Id,IPM_Financial__c>(stopProject.IPM_Financials_Regional__r));
        tempFinancialMap.putAll(new Map<Id,IPM_Financial__c>(stopProject.IPM_Financials_Local__r));
        tempFinancialMap.remove(null);
        return tempFinancialMap;
    }

    public static Map<Id,IPM_Country__c> processCountryStop(IPM_Project__c stopProject)
    {
        Map<Id,IPM_Country__c> tempCountryMap = new Map<Id,IPM_Country__c>();
        tempCountryMap.putAll(new Map<Id,IPM_Country__c>(stopProject.IPM_Countries__r));
        tempCountryMap.putAll(new Map<Id,IPM_Country__c>(stopProject.IPM_Countries1__r));
        tempCountryMap.putAll(new Map<Id,IPM_Country__c>(stopProject.IPM_Countries2__r));
        tempCountryMap.remove(null);
        return tempCountryMap;
    }


     /***********************************************************************
    @Description : when project is stopped/restared its child projects and project documents should also update
    @param: map<Id,Boolean> projectStatusMap 
    @param: map<Id,IPM_Project__c> projectMap
    @param: map<Id,String> unArchieveProjectMap
    @Release:1.2
    **********************************************************************/
    public static void updateChildProjects(map<Id,IPM_Project__c> projectMap)
    {
        if(!projectMap.isEmpty() )
        {
            IPM_ProjectHandler.INSIDE_STOP_PROJECT = true;
            update projectMap.values();
            IPM_ProjectHandler.INSIDE_STOP_PROJECT = false;
        }
    }

    public static void updateprojectRelatedRecords(Map<Id,IPM_Project_Document__c> projectsDocumentMap,Map<Id,IPM_Project_Resource__c> updatedResourceMap,Map<Id,IPM_Financial__c> updatedFinancialMap, map<Id,IPM_Country__c> updatedCountryMap, map<Id,IPM_Project_Rollout__c> updatedRolloutMap,Map<Id,IPM_Task__c> updatedTaskMap)
    {
    
        if(!updatedResourceMap.isEmpty())
        {
            update updatedResourceMap.values();    
        }

        if(!updatedFinancialMap.isEmpty() )
        {
            update updatedFinancialMap.values();
        }
        if(!updatedCountryMap.isEmpty() )
        {
            update updatedCountryMap.values();
        }
        if(!updatedRolloutMap.isEmpty())
        {
            update updatedRolloutMap.values();
        }

        if(!updatedTaskMap.isEmpty())
        {
            update updatedTaskMap.values();   
        }
    }
}