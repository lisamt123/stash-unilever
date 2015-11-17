/*
    @Description: Queueable Implementation which runs background processes for Project Creation,Phase Change,
    Financials,Tasks,Milestones,Project Document,Project Document Sections,Quesitonnaire etc.
    @Author: Cognizant Technology
    @Date: Sep 2014
*/
public with sharing class  IPM_ProjectJob_Queue implements Queueable  
{
    
    public static String CLASS_NAME = IPM_ProjectJob_Queue.class.getName();
    
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
            IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED = true;
            
            System.debug('--->>>'+IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED);
            
            if(projectsIdsToBeProcessed!=null && !projectsIdsToBeProcessed.isEmpty())
            { 
                // Get Project Specific information for Phase change and Project Rollout  Creation 
                Map<Id,IPM_Project__c> projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectsIdsToBeProcessed);

                // At this point we need to start working on Projects.
                if(projectDetailMap !=null && !projectDetailMap.isEmpty())
                {
                    // Get newly Created Rollout Projects and insert them into Database.
                    IPM_ProjectJobHelper.processRollouts(projectDetailMap,qContext);
                    
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
                            List<IPM_Project__c>projectShrList=[SELECT ID,IPM_Global_Project_Id__c FROM IPM_Project__c WHERE ID IN:projectsIdsToBeProcessed LIMIT 1000];
                            // At this point we need to start working on Projects.
                            if(projectShrList !=null && !projectShrList.isEmpty())
                            {
                                
                                //@@ Data Sharing Change - Update the queue Name & update the Owner id of the project to Queue in batch process 
                                
                                Set<id> projideset = new Set<id>();
                                String projectidstr;
                                Set<id> projidesets = new Set<id>();
                                
                                for(IPM_Project__c project:projectShrList){
                                    projectidstr = project.Id;
                                    if(projectidstr.Substring(0,15) == project.IPM_Global_Project_Id__c){
                                        projideset.add(project.Id);
                                    }
                                    projidesets.add(project.IPM_Global_Project_Id__c);
                                    
                                    
                                }
                                
                                if(projideset != null && projideset.size()>0){
                                    IPM_GroupManagement.groupNameUpdate(projideset);
                                
                                }
                                
                                if ([SELECT count() FROM AsyncApexJob WHERE JobType=:IPM_ConstantUtils.IPM_BATCHAPEX AND (Status =:IPM_ConstantUtils.IPM_PROCESSING OR Status =:IPM_ConstantUtils.IPM_PREPARE OR Status = :IPM_ConstantUtils.IPM_QUEUED)] < IPM_ConstantUtils.IPM_BATCHLIMIT)
                                {  
                                    Database.executeBatch(new IPM_ProjectOwnerUpdate(projidesets));
                                } 
                                else 
                                {                    
                                    IPM_ProjectOwnerUpdatescheduler s = new IPM_ProjectOwnerUpdatescheduler(projidesets);  
                                    System.schedule(IPM_ConstantUtils.IPM_JOBSTATED_AT + String.valueOf(Datetime.now()), IPM_ConstantUtils.IPM_NEXT_FIRE_TIME, s); 
                                }
                           
                           }
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
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_ProcessPhaseChangeQueue','execute',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        } 
    }
    
    
}