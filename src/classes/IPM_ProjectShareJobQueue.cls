/*
    @Description: Queueable Implementation which runs background processes for assign owner id and add project
    project members to queue
    @Author: Cognizant Technology
    @Date: Sep 2014
*/
public without sharing class  IPM_ProjectShareJobQueue implements Queueable  
{
    
    public static String CLASS_NAME = IPM_ProjectShareJobQueue.class.getName();
    
    // Static Variable to identify that Background Job is in Progress.
    public static Boolean PROJECT_QUEUE_CONTEXT_STARTED = false;
    
    //Actual Processing Records invoked from Trigger to Process Background Process         
    public Set<Id> projectsIdsToBeProcessed{get;set;} 

    // Invoked from trigger and passing Project Ids for which background process needs to be invoked.             
    public void initializeProjectData(Set<Id> incomingProjectsIds)
    {
        this.projectsIdsToBeProcessed = incomingProjectsIds;
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
            IPM_ProjectShareJobQueue.PROJECT_QUEUE_CONTEXT_STARTED = true;
            
            if(projectsIdsToBeProcessed!=null && !projectsIdsToBeProcessed.isEmpty())
            { 
                // Get Project Specific information for Phase change and Project Rollout  Creation 
                Map<Id,IPM_Project__c> projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectsIdsToBeProcessed);

                // At this point we need to start working on Projects.
                if(projectDetailMap !=null && !projectDetailMap.isEmpty())
                {
                    
                    
                IPM_ProjectTriggerHandler PThandler = new IPM_ProjectTriggerHandler();      
                //@@Design Review - Data Sharing Change update the queue Members
                PThandler.onBeforeUpdate(projectDetailMap.values());                
                
                }
            }  
        }
        catch(Exception ex)
        {
            Database.Rollback(phaseChangeSavePoint); 
            
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME ,'execute',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null); 
        } 
    }
    
    
}