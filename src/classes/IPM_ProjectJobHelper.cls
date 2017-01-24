/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectJobHelper
@CreateDate 20/08/2015
@Description Queueable Helper for getting necessary project and related Information.
@Version 1.0
@reference Project Job Queue
*/
/* This class would initially run in System mode to make sure that it can view all project associations.However internal 
    invocations for Helpers are 'With sharing'.
*/

public without sharing class IPM_ProjectJobHelper 
{
    public static String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); 
    public static String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(); 
    
    public static Map<Id,IPM_Project_Rollout__c> processingRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
    public static Map<Id,IPM_Project__c> processingProjectMap = new Map<Id,IPM_Project__c>();
    
    public static String CLASS_NAME = IPM_ProjectJobHelper.class.getName();
    public static  Map<Id,IPM_Project__c> projectToParentMapping = new Map<Id,IPM_Project__c>();        
    public static Map<Id,IPM_Project__c> projectToGrandParentMapping = new Map<Id,IPM_Project__c>();
    public static Map<Id,Map<Id,IPM_Project__c>> projectToChildMapping = new Map<Id,Map<Id,IPM_Project__c>>();
    public static Map<Id,Map<Id,IPM_Project__c>> projectToGrandChildMapping = new Map<Id,Map<Id,IPM_Project__c>>();
    public static Map<String,IPM_Project__c> rolloutProjectsMap = new Map<String,IPM_Project__c>();
    public static Map<Id,Map<Id,IPM_Project_Rollout__c>> projectSpecificRegionalRolloutMap = new Map<Id,Map<Id,IPM_Project_Rollout__c>>();
    public static Map<Id,Map<Id,IPM_Project_Rollout__c>> projectSpecificLocalRolloutMap = new Map<Id,Map<Id,IPM_Project_Rollout__c>>();
    public static Set<String> projectExternalIdSet = new Set<String>(); 
     /**************************************************************
    * @description: Process Project information. Used for Setting Phases of various Projects, which internally invoke Related DMLs.
                    This class handles the core logic for :
                    1) This Method forms the core logic for Transaction Management and is used for Driving process from Custom Settings. 
                    2) Identifying next Phase based on various combinations of data from Project Type Custom Settings.
                    3) Iterates throught the hierarchy and creates a data set of Hierarchical data for Projects.
                    4) Derives the logic for how process should flow based on Data in Custom Setting and GatekeepingModels.
                    5) Reads various configuration attributes like 'copy Phase to Local', 'Copy Phase To Regional',
                        which identifies which project drives what projects.
                    6) Sets the value for Projects when in Transaction Management. Values like 'Job Type' and Job Status is set from this method.    
                    7) Reads Project Type Custom Setting to identify when to create regional and Local Projects. 
    * @param1 incomingProjectMap : Map of incoming Projects
    * @param2 qContext : Queueable Context.
    */
    
    public static void processProjects(Map<Id,IPM_Project__c> incomingProjectMap,QueueableContext qContext)
    {           
        Set<Id> incomingProjectIds = new Set<Id>(); 
        processingProjectMap.clear();
        
        Map<Id,IPM_Project__c> masterProjectDetailMap = new Map<Id,IPM_Project__c>();
        
                
        
        if(!incomingProjectMap.isEmpty())
        {
            incomingProjectIds = incomingProjectMap.keySet();
            masterProjectDetailMap.putAll(incomingProjectMap); 
            masterProjectDetailMap.putAll(IPM_Utils.populateParentProjectDetails(incomingProjectIds));
            masterProjectDetailMap.putAll(IPM_Utils.populateChildProjectDetails(incomingProjectIds,false));
        
            projectToParentMapping = IPM_Utils.prepareProjectToParentMapping(incomingProjectMap,masterProjectDetailMap);
            projectToGrandParentMapping = IPM_Utils.prepareProjectToGrandParentMapping(projectToParentMapping,masterProjectDetailMap);
            projectToChildMapping = IPM_Utils.prepareProjectToChildMapping(incomingProjectMap,masterProjectDetailMap);
            projectToGrandChildMapping = IPM_Utils.prepareProjectToGrandChildMapping(projectToChildMapping,masterProjectDetailMap);
        }
        
        if(!incomingProjectMap.isEmpty())
        {
            for(Id projectId : incomingProjectMap.KeySet())
            {
                IPM_Project__c incomingProjectDetail =  incomingProjectMap.get(projectId);
                
                if(incomingProjectDetail.IPM_Phase__c != incomingProjectDetail.IPM_Temporary_Phase__c)
                {
                    //if Phase is blank and Temporary Phase is populated, it is a phase Change.
                    if(!String.isBlank(incomingProjectDetail.IPM_Temporary_Phase__c) && String.isBlank(incomingProjectDetail.IPM_Phase__c))
                    {
                        incomingProjectDetail.IPM_Phase__c = incomingProjectDetail.IPM_Temporary_Phase__c;
                        incomingProjectDetail.IPM_Complexity__c = incomingProjectDetail.IPM_Child_Complexity__c;
                        incomingProjectDetail.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION;    
                        incomingProjectDetail.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                        if(qContext!=null)
                        {
                            incomingProjectDetail.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                        }
                        processingProjectMap.put(incomingProjectDetail.Id,incomingProjectDetail);
                    }
                    else if(IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Temporary_Phase__c))
                    {
                        incomingProjectDetail.IPM_Phase__c = incomingProjectDetail.IPM_Temporary_Phase__c;
                        incomingProjectDetail.IPM_Complexity__c = incomingProjectDetail.IPM_Child_Complexity__c;
                        incomingProjectDetail.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
                        incomingProjectDetail.IPM_Current_Document_Status__c = IPM_ConstantUtils.STATUS_APPROVED;
                        incomingProjectDetail.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                        
                        if(qContext!=null)
                        {
                            incomingProjectDetail.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                        }
                        
                        processingProjectMap.put(incomingProjectDetail.Id,incomingProjectDetail); 
                    }

                }
                
                IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(incomingProjectDetail);
                
                            
                List<IPM_Project_Type__c> nextPhaseList = IPM_Utils.getNextPhases(currentProjectType,false);
                
                 
                Set<String> nextPhaseSet = new Set<String>();
                for(IPM_Project_Type__c nextPhase : nextPhaseList)
                {
                    nextPhaseSet.add(nextPhase.IPM_Phase__c);
                }   
                
                if(currentProjectType!=null) 
                { 
                     
                          
                         
                        
                            
                            
                            
                    processLocalProjects(projectId,currentProjectType,incomingProjectDetail,qContext);
                        
                            
                            
                            
					
					

                          

                    processRegionalProjects(projectId,currentProjectType,incomingProjectDetail,nextPhaseSet,qContext);
                                   
                            
                        
                            
                            
                            
                            
                        
                        
                        
                            
                                
                                        
                                
                            
                            
                                   
                        
                        
                                
                                
                    processGlobalProjects(projectId,currentProjectType,incomingProjectDetail,nextPhaseSet,qContext);   
                        
                               
                                     
                                    
                                
                }
            }
        }
        
        if(!processingProjectMap.isEmpty())
        {
        	List<IPM_Project__c> projectUpdateList = new List<IPM_Project__c>();
        	for(IPM_Project__c incomingProjectDetail : processingProjectMap.values())
        	{
				
        		projectUpdateList.add(incomingProjectDetail);
        	}
        	if(!projectUpdateList.isEmpty())
        	{	
            	update projectUpdateList;
        	}
        }
    } 
    
    /**************************************************************
    * @description: Used for Conversion of Rollouts - > Projects. 
    * @param1 incomingProjectMap : Map of incoming Projects
    * @param2 qContext : Queueable Context.
    */
    
    public static void processRollouts(Map<Id,IPM_Project__c> incomingProjectMap,Set<Id> rolloutIdSet,QueueableContext qContext)
    {
        Set<Id> incomingProjectIds = incomingProjectMap.keySet();
        processingRolloutMap.clear();
        
        
        
        /*Get Rollouts Starts. Need to verify whether Project has 'Change  Project On Status Change','create REgional/Local Projects' enabled. */
        String rolloutQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Rollout__c',false,null,true);
        String eligibleRolloutValue = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
        String rolloutWhereClause = ' WHERE (IPM_Project__c IN: incomingProjectIds OR Regional_Project__c IN: incomingProjectIds ) AND IPM_Project_Job_Status__c =:eligibleRolloutValue'; 
        if(rolloutIdSet!=null && !rolloutIdSet.isEmpty())
        {
            rolloutWhereClause = rolloutWhereClause + ' AND Id in:rolloutIdSet AND isActive__c= true '; 
        }
         
        rolloutWhereClause = rolloutQuery + rolloutWhereClause + ' limit 50000';
      
        Map<Id,IPM_Project_Rollout__c> rolloutMap = new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>) database.query(rolloutWhereClause) );
        if(!rolloutMap.isEmpty())
        {
            for(IPM_Project_Rollout__c rollout : rolloutMap.values())
            {
                checkRolloutMap(rollout);
            }
        }             
        
                          
        for(Id projectId : incomingProjectIds)
        {
            prepareRolloutMap(incomingProjectMap, projectId,qContext);
           
        }
        
        if(!processingRolloutMap.isEmpty())
        {
        	IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
            update processingRolloutMap.values();
            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
        }
        
        if(!rolloutProjectsMap.isEmpty())
        {
        	for(IPM_Project__c project : [SELECT Id,IPM_Project_Name__c from IPM_Project__c where IPM_Project_Name__c in : projectExternalIdSet])
        	{
        		if(rolloutProjectsMap.containsKey(project.IPM_Project_Name__c))
        		{
        			rolloutProjectsMap.remove(project.IPM_Project_Name__c);
        		}
        	}
            upsert rolloutProjectsMap.values() IPM_Project_Name__c;
        }
    } 
    
    /*************************************************************
    * This function was created to remove the npath complexities. 
    * This function is called from processRollouts()
    * @ description:: prepare regional and local rollout map
    * @param: project Rollout
    */
    
    private static void prepareRolloutMap(Map<Id,IPM_Project__c> incomingProjectMap, Id projectId,QueueableContext qContext){
        
        if(incomingProjectMap.containsKey(projectId) && incomingProjectMap.get(projectId) !=null)
        {
            IPM_Project__c incomingProjectDetail =  incomingProjectMap.get(projectId);
            
            // Set the Latest Phase
            if(incomingProjectDetail.IPM_Phase__c != incomingProjectDetail.IPM_Temporary_Phase__c && IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Temporary_Phase__c) )
            {
                incomingProjectDetail.IPM_Phase__c = incomingProjectDetail.IPM_Temporary_Phase__c;
            }
            
            IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(incomingProjectDetail);
       
            if(currentProjectType!=null && currentProjectType.IPM_CreateRegionalProjects__c && (projectSpecificRegionalRolloutMap.containsKey(projectId) &&  projectSpecificRegionalRolloutMap.get(projectId) !=null))
            {
                   
                Map<Id,IPM_Project_Rollout__c> associatedRegionalRolloutsMap = projectSpecificRegionalRolloutMap.get(projectId);
                List<IPM_Project__c> preparedProjectList = IPM_CreateRolloutProjects.processRollouts(incomingProjectDetail, associatedRegionalRolloutsMap.values() );
                for(IPM_Project__c project : preparedProjectList)
                {
                    rolloutProjectsMap.put(project.IPM_Project_Name__c,project);  
                    projectExternalIdSet.add(project.IPM_Project_Name__c);  
                } 
                
                for(IPM_Project_Rollout__c projectRollout : associatedRegionalRolloutsMap.values())
                {
                    projectRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                    if(qContext!=null)
                    {    
                        projectRollout.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                    }
                    processingRolloutMap.put(projectRollout.Id,projectRollout);
                }
            }else if(currentProjectType!=null && currentProjectType.IPM_CreateLocalProjects__c &&(projectSpecificLocalRolloutMap.containsKey(projectId) &&  projectSpecificLocalRolloutMap.get(projectId) !=null))
            {
                Map<Id,IPM_Project_Rollout__c> associatedLocalRolloutsMap = projectSpecificLocalRolloutMap.get(projectId);
                if(!associatedLocalRolloutsMap.isEmpty())
                {
                     List<IPM_Project__c> preparedProjectList = IPM_CreateRolloutProjects.processRollouts(incomingProjectDetail, associatedLocalRolloutsMap.values() );
                    
                     for(IPM_Project__c project : preparedProjectList)
                    {
                        rolloutProjectsMap.put(project.IPM_Project_Name__c,project);   
                        projectExternalIdSet.add(project.IPM_Project_Name__c); 
                    } 

                    for(IPM_Project_Rollout__c projectRollout : associatedLocalRolloutsMap.values())
                    {
                        projectRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                        if(qContext!=null)
                        {  
                            projectRollout.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                        }
                        processingRolloutMap.put(projectRollout.Id,projectRollout);
                    }
                }
            }
        }
    }
    
    /*************************************************************
    * This function was created to remove the npath complexities. 
    * This function is called from processRollouts()
    * @ description:: Checks regional and local rollout map
    * @param: project Rollout
    */
    
    private static void checkRolloutMap(IPM_Project_Rollout__c rollout){
                // Check for Regional Rollouts and Prepare projectToRolloutMap 
                if(rollout.recordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
                {
                    Map<Id,IPM_Project_Rollout__c> associatedRegionalRolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
                    if(projectSpecificRegionalRolloutMap.containsKey(rollout.IPM_Project__c) && projectSpecificRegionalRolloutMap.get(rollout.IPM_Project__c) !=null)
                    {
                        associatedRegionalRolloutsMap = projectSpecificRegionalRolloutMap.get(rollout.IPM_Project__c);
                    }
                    associatedRegionalRolloutsMap.put(rollout.Id,rollout);
                    projectSpecificRegionalRolloutMap.put(rollout.IPM_Project__c,associatedRegionalRolloutsMap);
                }
                
                if(rollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE && rollout.IPM_Project_GKM__c != IPM_ConstantUtils.GKM_3)
                {
                    // Check for Local Rollouts and Prepare projectToRolloutMap
                    Map<Id,IPM_Project_Rollout__c> associatedlocalRolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
                    if(projectSpecificLocalRolloutMap.containsKey(rollout.Regional_Project__c) && projectSpecificLocalRolloutMap.get(rollout.Regional_Project__c) !=null)
                    {
                        associatedlocalRolloutsMap = projectSpecificLocalRolloutMap.get(rollout.Regional_Project__c);
                    }
                    associatedlocalRolloutsMap.put(rollout.Id,rollout);
                    projectSpecificLocalRolloutMap.put(rollout.Regional_Project__c,associatedlocalRolloutsMap);
                }
                //Lakhan's Changes
                else if(rollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE && rollout.IPM_Project_GKM__c== IPM_ConstantUtils.GKM_3)  
                {
                	// Check for Local Rollouts and Prepare projectToRolloutMap
                    Map<Id,IPM_Project_Rollout__c> associatedlocalRolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
                    if(projectSpecificLocalRolloutMap.containsKey(rollout.IPM_Project__c) && projectSpecificLocalRolloutMap.get(rollout.IPM_Project__c) !=null)
                    {
                        associatedlocalRolloutsMap = projectSpecificLocalRolloutMap.get(rollout.IPM_Project__c);
                    }
                    associatedlocalRolloutsMap.put(rollout.Id,rollout);
                    projectSpecificLocalRolloutMap.put(rollout.IPM_Project__c,associatedlocalRolloutsMap);
        
        }
    } 
    
    /**************************************************************
    * @description: Creating Custom Task Name for Assigning to Task 
    * @param1 incomingProjectIds : List of incoming Project Ids.
    */
    public static Map<Id,IPM_Project__c> populateProjectDetails(Set<Id> incomingProjectIds)
    {
        String ProjectDetailSelectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
        String ProjectDetailWhereClause = 'Id in :incomingProjectIds';
        
        projectDetailSelectQuery = ProjectDetailSelectQuery  + ' WHERE ' + ProjectDetailWhereClause  + IPM_Utils.LIMIT_STRING;
        return new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(ProjectDetailSelectQuery) );
   
    }
    
    /******************************************************************
    *   @description: Method for setting project Status as Failed.
        @param1 : Queueable Context
    */
    public static void markProjectsAsComplete(QueueableContext qContext)
    {
        Map<Id,IPM_Project__c> successProjectMap = new Map<Id,IPM_Project__c>();
        Map<Id,IPM_Project_Rollout__c> successRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        
        Map<Id, Decimal> mapProjectIdWithFilledInPerc = new Map<Id, Decimal>();
        mapProjectIdWithFilledInPerc = prepareProjectWithFilledInPercentMap(processingProjectMap);
        for(IPM_Project__c project : processingProjectMap.values())
        {
            IPM_Project__c tempProject = new IPM_Project__c(Id=project.Id);
            tempProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            //After phase change, as next phase's document is in 'Not Started' status, following logic will populate Filled In Percentage field on IPM project depending on filled-in copied over sections'
            tempProject.IPM_FilledIn_Percentage__c = mapProjectIdWithFilledInPerc.get(project.Id);
            if(qContext!=null)
            {  
                tempProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
            }
            successProjectMap.put(tempProject.Id,tempProject);
        }
        
        for(IPM_Project_Rollout__c rollout : processingRolloutMap.values())
        {
        	IPM_Project_Rollout__c tempRollout = new IPM_Project_Rollout__c(Id=rollout.Id);
            tempRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            if(qContext!=null)
            {
                tempRollout.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
            }
            successRolloutMap.put(tempRollout.Id,tempRollout);
        }
        
        // Udpate Rollout Values with Status as completed.
        if(!successRolloutMap.isEmpty())
        {
        	IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
            update successRolloutMap.values();
            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
        }
        
        // Udpate Project Values with Status as completed.
        if(!successProjectMap.isEmpty())
        {
        	IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            update successProjectMap.values();
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
        } 
    }
     
    public static void markProjectAsFailed(Set<Id> projectsIdsToBeProcessed) 
    {
        try
        {
            Map<Id,IPM_Project__c> failedProjectMap = new Map<Id,IPM_Project__c>();
            Map<Id,IPM_Project_Rollout__c> failedRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        
            Map<Id,IPM_Project__c> projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectsIdsToBeProcessed);
                
            if(!projectDetailMap.isEmpty())
            {
                for(IPM_Project__c project : projectDetailMap.values())
                {
                    if(project.IPM_Phase__c != project.IPM_Temporary_Phase__c)
                    {
                        project.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_FAILED;
                        failedProjectMap.put(project.Id,project);   
                    }                    
                }
            }
            
            String rolloutQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Rollout__c',false,null,true);
            String eligibleRolloutValue = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
            String rolloutWhereClause = ' WHERE (IPM_Project__c IN: projectsIdsToBeProcessed OR Regional_Project__c IN: projectsIdsToBeProcessed ) AND IPM_Project_Job_Status__c =:eligibleRolloutValue limit 10000';
            rolloutWhereClause = rolloutQuery + rolloutWhereClause;
            
            for(IPM_Project_Rollout__c projectRollout : database.query(rolloutWhereClause))
            {
                projectRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_FAILED;
                failedRolloutMap.put(projectRollout.Id,projectRollout);
            }
            
            if(!failedProjectMap.isEmpty())
            {    
                // Udpate Project Values with Status as failed.
                IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
                update failedProjectMap.values();
                IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
            }
                
            // Udpate Rollout Values with Status as failed.
            if(failedRolloutMap!=null && !failedRolloutMap.isEmpty())
            {
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                update failedRolloutMap.values();
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
            } 
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'markProjectAsFailed',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /******************************************************************
    *   @description: Method for preparing map of project id with filled-in percentages of associated document's sections
        @param1 : Projects for which filled-in percentages need to calculated
    */
    public static Map<Id, Decimal> prepareProjectWithFilledInPercentMap(Map<Id,IPM_Project__c> projectMap){
    	
        Map<Id, Decimal> mapProjectIdWithFilledInPerc = new Map<Id, Decimal>();
        Map<Id, IPM_Project_Document__c> mapProjectDoc = new Map<Id, IPM_Project_Document__c>([
          																						     Select Id, IPM_Document_Status__c,IPM_Project__c,
          																						     (Select Id, IPM_Section_Status__c FROM IPM_Project_Sections__r 
          																						     WHERE IPM_Default_Section__c=true 
          																						     AND IPM_Section__r.IPM_Section_Type__c IN :IPM_ConstantUtils.SECTION_LIST_WO_HEADER_SUBHEADER) 
          																						     FROM IPM_Project_Document__c 
          																						     WHERE IPM_Project__c IN : projectMap.keySet() 
          																						     AND  ( IPM_Document_Status__c =:IPM_ConstantUtils.STATUS_NOT_STARTED OR (IPM_Project__r.IPM_Phase__c = :IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT AND IPM_Project__r.IPMProject_Span__c= :IPM_ConstantUtils.PROJECT_SPAN_LOCAL))
          																						  ]);      
        for(IPM_Project_Document__c projectDoc : mapProjectDoc.values())
        {
        	Integer removeoptional = 0;
            Decimal filledinPer = 0;
            Integer NonNegotiable = projectDoc.IPM_Project_Sections__r.size();
        	for(IPM_Project_Document_Section__c projectDocSection : projectDoc.IPM_Project_Sections__r)
        	{
    				if(projectDocSection.IPM_Section_Status__c == IPM_ConstantUtils.SECTION_STATUS_FILLED)
    				{
    					removeoptional++;
    				}
        	}
        	if(NonNegotiable!=0)
        	{
            	filledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiable))*100);
            }
            mapProjectIdWithFilledInPerc.put(projectDoc.IPM_Project__c, filledinPer);
        } 
        
        return mapProjectIdWithFilledInPerc;
    }

    private static void processLocalProjects(Id projectId,IPM_Project_Type__c  currentProjectType,IPM_Project__c incomingProjectDetail,QueueableContext qContext)
    {
        IPM_Project__c globalProject,regionalProject = null;
        /* Local Project Calculation Begins.Used for Updating Phase of related Projects based on gatekeeping Model */
        if(incomingProjectDetail.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
        {
            globalProject = projectToGrandParentMapping.get(projectId);
            regionalProject = projectToParentMapping.get(projectId);
            if(globalProject !=null && processingProjectMap.containsKey(globalProject.Id))
            {
               globalProject = processingProjectMap.get(globalProject.Id);
            }
            if(regionalProject !=null && processingProjectMap.containsKey(regionalProject.Id))
            {
               regionalProject = processingProjectMap.get(regionalProject.Id); 
            } 
            if(regionalProject!=null)  
            {    
                IPM_PhaseChangeHelper.checkRegionalImpactfromLocal(currentProjectType,incomingProjectDetail,regionalProject,qContext);
            }
            if(globalProject!=null)
            {
                IPM_PhaseChangeHelper.checkGlobalImpactFromLocal(currentProjectType,incomingProjectDetail,globalProject,qContext);
            }
        }
        /* Local Project Calculation ends */
    }
    private static void processRegionalProjects(Id projectId,IPM_Project_Type__c  currentProjectType,IPM_Project__c incomingProjectDetail,Set<String> nextPhaseSet ,QueueableContext qContext)
    {
        IPM_Project__c globalProject = null;
        /* Regional Project Calculation Begins */         
        if(incomingProjectDetail.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL )
        {
            globalProject = projectToParentMapping.get(projectId);
            if(globalProject !=null && processingProjectMap.containsKey(globalProject.Id))
            {
               globalProject = processingProjectMap.get(globalProject.Id);
            }
            if(currentProjectType.IPM_Fast_Forward_Phase_Change__c)
            {
               IPM_PhaseChangeHelper.checkRegionalFastForward(projectId,currentProjectType,incomingProjectDetail,nextPhaseSet,qContext);
            }
            if(globalProject!=null)
            {
                IPM_PhaseChangeHelper.checkGlobalImpactFromRegional(currentProjectType,incomingProjectDetail,globalProject,qContext); 
            }
            if( (currentProjectType.IPM_CreateLocalProjects__c || currentProjectType.IPM_CopyPhase2Local__c) && projectToChildMapping.containsKey(projectId))
            {
                Map<Id,IPM_Project__c> localProjectMap =  projectToChildMapping.get(projectId);
                
                IPM_PhaseChangeHelper.checkLocalImpactFromRegional(currentProjectType,incomingProjectDetail,localProjectMap,qContext);
                
            }
        }
        /* Regional Project Calculation ends */
    }
    private static void processGlobalProjects(Id projectId,IPM_Project_Type__c  currentProjectType,IPM_Project__c incomingProjectDetail,Set<String> nextPhaseSet ,QueueableContext qContext)
    {
        /* Global Project Calculation begins */    
        if(incomingProjectDetail.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL )
        {    
            if(currentProjectType.IPM_Fast_Forward_Phase_Change__c && projectToGrandChildMapping.containsKey(projectId))
            {
                IPM_PhaseChangeHelper.checkGlobalFastForward(projectId,currentProjectType,incomingProjectDetail,nextPhaseSet,qContext);
            }
            if( (currentProjectType.IPM_CreateRegionalProjects__c || currentProjectType.IPM_CopyPhase2Regional__c) && projectToChildMapping.containsKey(projectId))
            {
                Map<Id,IPM_Project__c> regionalProjectMap =  projectToChildMapping.get(projectId);
                IPM_PhaseChangeHelper.checkRegionalImpactFromGlobal(currentProjectType,incomingProjectDetail,regionalProjectMap,qContext);
            }
            if((currentProjectType.IPM_CreateLocalProjects__c || currentProjectType.IPM_CopyPhase2Local__c) && (projectToGrandChildMapping.containsKey(projectId) || (projectToChildMapping.containsKey(projectId) && IPM_Utils.GATE_KEEPING_MODEL_3.equals(incomingProjectDetail.IPM_ProjectGKM__c))))
            {
                Map<Id,IPM_Project__c> localProjectMap;
                if(IPM_Utils.GATE_KEEPING_MODEL_3.equals(incomingProjectDetail.IPM_ProjectGKM__c)) 
                {
                    localProjectMap =  projectToChildMapping.get(projectId);
                }
                else
                {
                    localProjectMap =  projectToGrandChildMapping.get(projectId);
                }
                
                IPM_PhaseChangeHelper.checkLocalImpactFromGlobal(currentProjectType,incomingProjectDetail,localProjectMap,qContext);
                //System.assert(false);
            }
        }
        /* Global Project Calculation ends */
    }

}