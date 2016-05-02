/*
    @Description: Queueable Implementation which runs background processes for Project Creation,Phase Change,
    Financials,Tasks,Milestones,Project Document,Project Document Sections,Quesitonnaire etc.
    @Author: Cognizant Technology
    @Date: Sep 2014
*/

/*  
    This class would initially run in System mode to make sure that it can view all project specific data and associations.
    However internal invocations for Helpers are 'With sharing'. 
*/

public with sharing class  IPM_ProjectJob_Queue implements Queueable  
{
    
    public static String CLASS_NAME = IPM_ProjectJob_Queue.class.getName();
    
    // Static Variable to identify that Background Job is in Progress.
    public static Boolean PROJECT_QUEUE_CONTEXT_STARTED = false;
    
    //Actual Processing Records invoked from Trigger to Process Background Process          
    public Set<Id> projectsIdsToBeProcessed{get;set;}
    
    //Actual Processing Rollout Records invoked from Trigger to Process Background Process 
    public Set<Id> rollOutIdsToBeProcessed{get;set;}
    
    // Invoked from trigger and passing Project Ids for which background process needs to be invoked.             
    public void initializeProjectData(Set<Id> incomingProjectsIds)
    {
        this.projectsIdsToBeProcessed = incomingProjectsIds;
    }
    
    // Invoked from trigger and passing Project Ids && RolloutIds for which background process needs to be invoked.             
    public void initializeRolloutProjectData(Set<Id> incomingProjectsIds,Set<Id> incomingRolloutIds)
    {
        this.projectsIdsToBeProcessed = incomingProjectsIds;
        this.rollOutIdsToBeProcessed = incomingRolloutIds;
    }
    
    /*********************************************************
    *   @description: Queueable Method Implementation for Processing of Project Data
        @param1 qContext: Queueable Context
    */
    public void execute(QueueableContext qContext) 
    {
        System.savePoint phaseChangeSavePoint = Database.setSavePoint();
        try
        {
            // Start Context for Queueable interface
            IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED = true;
            
            if(projectsIdsToBeProcessed!=null && !projectsIdsToBeProcessed.isEmpty())
            { 
                // Get Project Specific information for Phase change and Project Rollout  Creation 
                Map<Id,IPM_Project__c> projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectsIdsToBeProcessed);

                // At this point we need to start working on Projects.
                if(projectDetailMap !=null && !projectDetailMap.isEmpty())
                {
                    // Get newly Created Rollout Projects and insert them into Database.
                    IPM_ProjectJobHelper.processRollouts(projectDetailMap,rollOutIdsToBeProcessed,qContext);
                    
                    // Again query the Data to get Latest information about the projects which got converted.
                    projectDetailMap.clear();
                    projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectsIdsToBeProcessed);
                    
                    // Start Processing incoming Projects now and We would be performing Phase specific updates on projects.
                    IPM_ProjectJobHelper.processProjects(projectDetailMap,qContext);            
                    
                    // Mark the Project Job status as complete on Successful Processing.
                    IPM_ProjectJobHelper.markProjectsAsComplete(qContext);
                    
                    if(!IPM_ProjectOwnerChangeQueue.PROJECT_QUEUE_CONTEXT_STARTED)
                    {
                        Map<Id,IPM_Project__c>projectMap=new Map<Id,IPM_Project__c>([SELECT id FROM IPM_Project__c WHERE id IN:projectDetailMap.keyset() or IPM_Parent_Project__c IN:projectDetailMap.keyset() LIMIT 1000]);
                        IPM_ProjectOwnerChangeQueue changeOwnerHandler = new IPM_ProjectOwnerChangeQueue (); 
                        changeOwnerHandler.initializeProjectData(projectMap.keyset()); 
                        if(!Test.isRunningTest())
                        {
                            System.enqueueJob(changeOwnerHandler);
                        }
                        else
                        {
                            IPM_ProjectOwnerChangeQueue.processProjectSharing(projectMap.keyset()); 
                        }
                    }
                
                }
            }  
        }
        catch(Exception ex)
        {
            Database.Rollback(phaseChangeSavePoint); 
            // Mark the Project Job status as Failed on Failure.
            IPM_ProjectJobHelper.markProjectAsFailed(projectsIdsToBeProcessed);
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'execute',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        } 
    }
    
    
}