public without sharing class  IPM_ProcessPhaseChangeQueue implements Queueable  
{
    public static String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); 
    public static String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(); 
    
    public static Map<Id,Map<Id,IPM_Project_Rollout__c>> projectSpecificRegionalRolloutMap = new Map<Id,Map<Id,IPM_Project_Rollout__c>>();
    public static Map<Id,Map<Id,IPM_Project_Rollout__c>> projectSpecificLocalRolloutMap = new Map<Id,Map<Id,IPM_Project_Rollout__c>>();
    
    /* Get Child Projects starts. We need to identify whether we need to update Child records on Change of Status of Parent Projects */
    public static Map<Id,Map<Id,IPM_Project__c>> incomingProjectsToChildProjects = new Map<Id,Map<Id,IPM_Project__c>>();
    
    /*Get Parent Projects Starts .Need to validate whether parent projects need to be updated on Child Phase Change. */ 
    public static Map<Id,IPM_Project__c> incomingProjectsToParentProjects = new Map<Id,IPM_Project__c>();     
            
    /*Actual Processing Records */        
    public Set<Id> projectsIdsToBeProcessed{get;set;} 
    public static Map<Id,IPM_Project__c> incomingProjectsToDetailMap = new Map<Id,IPM_Project__c>();
    public static Map<Id,Map<Id,IPM_Project_Rollout__c>> incomingProjectsToRolloutMap = new Map<Id,Map<Id,IPM_Project_Rollout__c>>();
    
    public void initializeProjectData(Set<Id> incomingProjectsIds)
    {
        this.projectsIdsToBeProcessed = incomingProjectsIds;
    }
    
    public void execute(QueueableContext qContext) 
    {
        System.savePoint phaseChangeSavePoint = Database.setSavePoint();

        try
        {
            if(projectsIdsToBeProcessed!=null && !projectsIdsToBeProcessed.isEmpty())
            { 
                List<IPM_Project__c> targetProjectList = startPhaseChangeJobProcessing(projectsIdsToBeProcessed);
            
                if(targetProjectList!=null && !targetProjectList.isEmpty())
                {
                    for(IPM_Project__c targetProject : targetProjectList)
                    {
                        // Create a new Instance of SObject and update the Job Status
                        targetProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                        targetProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                    } 
                    // these below debugs are required for Quickly analysing the issues which might come up during SIT hence not removing now
                    System.debug('targetProjectList-->>>'+targetProjectList);
                    System.debug('incomingProjectsToDetailMap-->>>'+incomingProjectsToDetailMap);
                    System.debug('incomingProjectsToRolloutMap-->>>'+incomingProjectsToRolloutMap);
                    
                    upsert targetProjectList Id;    
                    
                    if(incomingProjectsToDetailMap!=null && !incomingProjectsToDetailMap.isEmpty())
                    {
                        Map<Id,IPM_Project_Rollout__c> updateRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
                        for(IPM_Project__c project : incomingProjectsToDetailMap.values())
                        {
                            project.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
                            if(incomingProjectsToRolloutMap!=null && !incomingProjectsToRolloutMap.isEmpty() && incomingProjectsToRolloutMap.containsKey(project.Id) && 
                                incomingProjectsToRolloutMap.get(project.Id)!=null )
		                    {
		                        for(IPM_Project_Rollout__c rollOut : incomingProjectsToRolloutMap.get(project.Id).values())
		                        {
		                              rollOut.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
		                              updateRolloutMap.put(rollOut.Id,rollOut);
		                        }
		                    }
                            
                        }
                        
                        // Udpate Project Values with Status as completed.
                        update incomingProjectsToDetailMap.values();
                        
                        // Udpate Rollout Values with Status as completed.
                        if(updateRolloutMap!=null && !updateRolloutMap.isEmpty())
                        {
                            update updateRolloutMap.values();
                        }
                    }
                }
            }  
        }
        catch(Exception ex)
        {
            Database.Rollback(phaseChangeSavePoint);
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_ProcessPhaseChangeQueue','execute',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null); 
            
            if(incomingProjectsToDetailMap!=null && !incomingProjectsToDetailMap.isEmpty())
            {
                Map<Id,IPM_Project_Rollout__c> updateRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
                for(IPM_Project__c project : incomingProjectsToDetailMap.values())
                {
                    project.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
                    if(incomingProjectsToRolloutMap!=null && !incomingProjectsToRolloutMap.isEmpty() && incomingProjectsToRolloutMap.containsKey(project.Id) && 
                        incomingProjectsToRolloutMap.get(project.Id)!=null )
                    {
                        for(IPM_Project_Rollout__c rollOut : incomingProjectsToRolloutMap.get(project.Id).values())
                        {
                              rollOut.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
                              updateRolloutMap.put(rollOut.Id,rollOut);
                        }
                    }
                    
                }
                // Udpate Project Values with Status as completed.
                update incomingProjectsToDetailMap.values();
                
                // Udpate Rollout Values with Status as completed.
                if(updateRolloutMap!=null && !updateRolloutMap.isEmpty())
                {
                    update updateRolloutMap.values();
                }
            }            
        } 
    }
    
    public static List<IPM_Project__c> startPhaseChangeJobProcessing(Set<Id> eligibleProjectIds)
    {
        List<IPM_Project__c> projectsToBeProcessed = new List<IPM_Project__c>();
        String limitString = ' LIMIT 10000 ';
        
        /*Current Project Information Starts. We Need to update Project Phase for incoming Projects. Phase is temporarily stored in Temp Phase Field */
        String ProjectDetailSelectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null);
        String ProjectDetailWhereClause = 'Id in :eligibleProjectIds';
        
        ProjectDetailSelectQuery = ProjectDetailSelectQuery  + ' WHERE ' + ProjectDetailWhereClause + limitString;
        incomingProjectsToDetailMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(ProjectDetailSelectQuery) );
        
        /*Current Project Information ends */
        
        
        String childProjectSelectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null);
        String childProjectWhereClause = 'IPM_Parent_Project__c in :eligibleProjectIds ';
        
        
        childProjectSelectQuery = childProjectSelectQuery  + ' WHERE ' + childProjectWhereClause + limitString;       
        Map<Id,IPM_Project__c> incomingProjectsChildDetailMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(childProjectSelectQuery) );
        
        for(IPM_Project__c project : incomingProjectsChildDetailMap.values())
        {
            Map<Id,IPM_Project__c> childProjectMap = new Map<Id,IPM_Project__c>();
   
            if(incomingProjectsToChildProjects.containsKey(project.IPM_Parent_Project__c))
            {
                childProjectMap =  incomingProjectsToChildProjects.get(project.IPM_Parent_Project__c);        
            }
        
            childProjectMap.put(project.Id,project);
       
            incomingProjectsToChildProjects.put(project.IPM_Parent_Project__c,childProjectMap);
        }
        /* Get Child Projects ends */
        
        /*Get Parent Projects Starts .Need to validate whether parent projects need to be updated on Child Phase Change. */
        Map<Id,Id> incomingProjectToParentMap = new Map<Id,Id>();

        for(IPM_Project__c project : incomingProjectsToDetailMap.values() )
        {
            if(project.IPM_Parent_Project__c !=null)
            {
                incomingProjectToParentMap.put(project.Id,project.IPM_Parent_Project__c);   
            }
        }
        
        Set<Id> parentProjectSet = incomingProjectToParentMap.keySet(); // NO SONAR, used in dyanamic SOQL
        
        String parentProjectSelectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null);
        String parentProjectWhereClause = 'IPM_Parent_Project__c in :parentProjectSet ';
        
        parentProjectSelectQuery = parentProjectSelectQuery  + ' WHERE ' + parentProjectWhereClause + limitString;       
        Map<Id,IPM_Project__c> incomingProjectsParentDetailMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(parentProjectSelectQuery) );
        
        for(ID incomingProjectId : incomingProjectToParentMap.values())
        {
            ID parentProjectId = incomingProjectToParentMap.get(incomingProjectId);
            if(incomingProjectsParentDetailMap.containsKey(parentProjectId) && incomingProjectsParentDetailMap.get(parentProjectId) !=null)
            {
                IPM_Project__c parentProject = incomingProjectsParentDetailMap.get(parentProjectId);
                incomingProjectsToParentProjects.put(incomingProjectId,parentProject);
            }
        }
        /*Get Parent Projects ends */
         
        /*Get Rollouts Starts. Need to verify whether Project has 'Change  Project On Status Change','create REgional/Local Projects' enabled. */
        String rolloutQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Rollout__c',false,null);
        String eligibleRolloutValue = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE; // NO SONAR, used in dyanamic SOQL
        String rolloutWhereClause = ' WHERE (IPM_Project__c IN: eligibleProjectIds OR Regional_Project__c IN: eligibleProjectIds ) AND IPM_Project_Job_Status__c =:eligibleRolloutValue limit 10000';
        rolloutWhereClause = rolloutQuery + rolloutWhereClause;
        Map<Id,IPM_Project_Rollout__c> rolloutMap = new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>) database.query(rolloutWhereClause) );
        
        if(!rolloutMap.isEmpty())
        {
            for(IPM_Project_Rollout__c rollout : rolloutMap.values())
            {
                // Check for Regional Rollouts and Prepare projectToRolloutMap
                Map<Id,IPM_Project_Rollout__c> associatedRegionalRolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
                if(projectSpecificRegionalRolloutMap.containsKey(rollout.IPM_Project__c) && projectSpecificRegionalRolloutMap.get(rollout.IPM_Project__c) !=null)
                {
                    associatedRegionalRolloutsMap = projectSpecificRegionalRolloutMap.get(rollout.IPM_Project__c);
                }
                associatedRegionalRolloutsMap.put(rollout.Id,rollout);
                projectSpecificRegionalRolloutMap.put(rollout.IPM_Project__c,associatedRegionalRolloutsMap);
                
                // Check for Local Rollouts and Prepare projectToRolloutMap
                Map<Id,IPM_Project_Rollout__c> associatedlocalRolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
                if(projectSpecificLocalRolloutMap.containsKey(rollout.Regional_Project__c) && projectSpecificLocalRolloutMap.get(rollout.Regional_Project__c) !=null)
                {
                    associatedlocalRolloutsMap = projectSpecificLocalRolloutMap.get(rollout.Regional_Project__c);
                }
                associatedlocalRolloutsMap.put(rollout.Id,rollout);
                projectSpecificLocalRolloutMap.put(rollout.Regional_Project__c,associatedlocalRolloutsMap);
            }
        }             
        
        /*Get Rollouts ends */
        
        /*Starts Building the Data for updates */                          
        for(Id projectId : eligibleProjectIds)
        {
            if(incomingProjectsToDetailMap.containsKey(projectId) && incomingProjectsToDetailMap.get(projectId) !=null)
            {
                IPM_Project__c incomingProjectDetail =  incomingProjectsToDetailMap.get(projectId);
                incomingProjectDetail.IPM_Phase__c = incomingProjectDetail.IPM_Temporary_Phase__c;
                incomingProjectDetail.IPM_Current_Document_Status__c = IPM_ConstantUtils.STATUS_APPROVED;
                projectsToBeProcessed.add(incomingProjectDetail);
                
                IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(incomingProjectDetail);
                
                if(currentProjectType!=null)
                {   
                    // Check for Parent Project .
                    Id parentProjectID = incomingProjectDetail.IPM_Parent_Project__c;
                    
                    if(currentProjectType.IPM_Update_Parent_Project_Status__c && incomingProjectsToParentProjects.containsKey(projectId) !=null && 
                        incomingProjectsToParentProjects.get(projectId) !=null)
                    {
                         IPM_Project__c parentProject = incomingProjectsToParentProjects.get(projectId);
                         parentProject.IPM_Phase__c =  incomingProjectDetail.IPM_Phase__c;  
                         projectsToBeProcessed.add(parentProject);      
                    }
                
                    // Check for Child Projects.
                    if(currentProjectType.IPM_Update_Child_Project_Status__c && incomingProjectsToChildProjects.containsKey(projectId) && incomingProjectsToChildProjects.get(projectId)!=null)
                    {
                        // Update Child Statuses
                        Map<Id,IPM_Project__c> childProjectMap = incomingProjectsToChildProjects.get(projectId);
                        
                        for(IPM_Project__c childProject : childProjectMap.values())
                        {
                           childProject.IPM_Phase__c =  incomingProjectDetail.IPM_Phase__c;
                           projectsToBeProcessed.add(childProject);
                        }
                    }
                
                    // Check for Rollouts.
                    if(currentProjectType.IPM_CreateRegionalProjectOnStatusChange__c || currentProjectType.IPM_CreateRegionalProjects__c)
                    {
                        Map<Id,IPM_Project_Rollout__c> regionalRollouts = new Map<Id,IPM_Project_Rollout__c>();

                        if(projectSpecificRegionalRolloutMap.containsKey(projectId) &&  projectSpecificRegionalRolloutMap.get(projectId) !=null)
                        {
                            Map<Id,IPM_Project_Rollout__c> associatedRegionalRolloutsMap = projectSpecificRegionalRolloutMap.get(projectId);
                            
                            for(IPM_Project_Rollout__c regionalRollout : associatedRegionalRolloutsMap.values())
                            {
                                if( (currentProjectType.IPM_CreateRegionalProjectOnStatusChange__c || currentProjectType.IPM_CreateRegionalProjects__c ) && 
                                    regionalRollout.recordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
                                {
                                    regionalRollouts.put(regionalRollout.Id,regionalRollout);
                                    
                                    Map<Id,IPM_Project_Rollout__c> processingRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
                                    if(incomingProjectsToRolloutMap.containsKey(projectId) &&  incomingProjectsToRolloutMap.get(projectId) !=null )
                                    {
                                        processingRolloutMap = incomingProjectsToRolloutMap.get(projectId);
                                    }
                                    processingRolloutMap.put(regionalRollout.Id,regionalRollout);
                                    incomingProjectsToRolloutMap.put(projectId,processingRolloutMap);
                                }
                            }
                            projectsToBeProcessed.addAll(IPM_CreateRolloutProjects.processRollouts(incomingProjectDetail, regionalRollouts.values() ) );
                        }          
                    }
                    
                    if(currentProjectType.IPM_CreateLocalProjects__c)
                    {
                        Map<Id,IPM_Project_Rollout__c> localRollouts = new Map<Id,IPM_Project_Rollout__c>();
                        if(projectSpecificLocalRolloutMap.containsKey(projectId) &&  projectSpecificLocalRolloutMap.get(projectId) !=null)
                        {
                            Map<Id,IPM_Project_Rollout__c> associatedLocalRolloutsMap = projectSpecificLocalRolloutMap.get(projectId);
                            
                            for(IPM_Project_Rollout__c localRollout : associatedLocalRolloutsMap.values())
                            {
                                if( currentProjectType.IPM_CreateLocalProjects__c  && localRollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
                                {
                                    localRollouts.put(localRollout.Id,localRollout);
                                    
                                    Map<Id,IPM_Project_Rollout__c> processingRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
                                    if(incomingProjectsToRolloutMap.containsKey(projectId) &&  incomingProjectsToRolloutMap.get(projectId) !=null )
                                    {
                                        processingRolloutMap = incomingProjectsToRolloutMap.get(projectId);
                                    }
                                    processingRolloutMap.put(localRollout.Id,localRollout);
                                    incomingProjectsToRolloutMap.put(projectId,processingRolloutMap);
                                }
                                
                            }
                            projectsToBeProcessed.addAll(IPM_CreateRolloutProjects.processRollouts(incomingProjectDetail, localRollouts.values() ) );
                        }   
                    }
                }
            }
        }
        return  projectsToBeProcessed;
    } 
}