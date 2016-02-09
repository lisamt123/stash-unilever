/*
    @Description: Queueable Implementation which runs background processes for assign owner id and add project
    project members to queue
    @Author: Cognizant Technology
    @Date: Sep 2014
*/
/*
    This class has been marked as Without Sharing as it needs to execute operations on system objects(As non-admin users doesn't have
    permissions to Create or Edit Queues )
*/
public without sharing class IPM_ProjectOwnerChangeQueue implements Queueable  
{
    
    public static String CLASS_NAME = IPM_ProjectOwnerChangeQueue.class.getName();
    
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
            IPM_ProjectOwnerChangeQueue.PROJECT_QUEUE_CONTEXT_STARTED = true;
            IPM_ProjectOwnerChangeQueue.processProjectSharing(projectsIdsToBeProcessed);
        }
        catch(Exception ex)
        {
            Database.Rollback(phaseChangeSavePoint);
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'execute',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);             
        } 
    }
    
    public static void processProjectSharing(Set<Id> projectsIdsToBeProcessed)
    {
        if(projectsIdsToBeProcessed!=null && !projectsIdsToBeProcessed.isEmpty())
        { 
            set<id>projectIdsSet=new set<id>();
            // Get Project Specific information for Phase change and Project Rollout  Creation 
            Map<Id,IPM_Project__c>projectMap=new Map<Id,IPM_Project__c>([SELECT id,IPM_Parent_Project__c,IPM_Parent_Project__r.IPM_Parent_Project__c  FROM IPM_Project__c WHERE id IN:projectsIdsToBeProcessed or IPM_Parent_Project__c IN:projectsIdsToBeProcessed or IPM_Parent_Project__r.IPM_Parent_Project__c IN:projectsIdsToBeProcessed LIMIT 1000]);
            for(IPM_Project__c projeectIds:projectMap.values()){
                projectIdsSet.add(projeectIds.id);
                if(projeectIds.IPM_Parent_Project__c!=null){
                    projectIdsSet.add(projeectIds.IPM_Parent_Project__c);
                    
                }
                if(projeectIds.IPM_Parent_Project__r.IPM_Parent_Project__c!=null){
                     projectIdsSet.add(projeectIds.IPM_Parent_Project__r.IPM_Parent_Project__c);   
                }
            }    
            Map<Id,IPM_Project__c> projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectIdsSet);
            
            // At this point we need to start working on Projects.
            if(projectDetailMap!=null && !projectDetailMap.isEmpty())
            {
                
                //@@ Data Sharing Change - Update the queue Name & update the Owner id of the project to Queue in batch process 
                Set<id> projideset = new Set<id>();
                String projectidstr;
                Set<id> projidesets = new Set<id>();
                
                for(IPM_Project__c project:projectDetailMap.values()){
                    projectidstr = project.Id;
                    if(projectidstr.Substring(0,15) == project.IPM_Global_Project_Id__c){
                        projideset.add(project.Id);
                    }
                    projidesets.add(project.id);
                    
                    
                }
                //update queue name
                if(projideset != null && projideset.size()>0){
                    IPM_GroupManagement.groupNameUpdate(projideset);
                
                }
                if ([SELECT count() FROM AsyncApexJob WHERE JobType=:IPM_ConstantUtils.IPM_BATCHAPEX AND (Status =:IPM_ConstantUtils.IPM_PROCESSING OR Status =:IPM_ConstantUtils.IPM_PREPARE OR Status = :IPM_ConstantUtils.IPM_QUEUED)] < IPM_ConstantUtils.IPM_BATCHLIMIT)
                {      
                    Database.executeBatch(new IPM_ProjectOwnerUpdate_Batch(projectDetailMap.keyset(),projectsIdsToBeProcessed));
                } 
                else 
                {                     
                    IPM_ProjectOwnerUpdatescheduler s = new IPM_ProjectOwnerUpdatescheduler(projectDetailMap.keyset(),projectsIdsToBeProcessed);  
                    System.schedule(IPM_ConstantUtils.IPM_JOBSTATED_AT + String.valueOf(Datetime.now()), IPM_ConstantUtils.IPM_NEXT_FIRE_TIME, s); 
                }
            IPM_ProjectTriggerHandler PThandler = new IPM_ProjectTriggerHandler();      
            //@@Design Review - Data Sharing Change update the queue Members
            PThandler.onBeforeUpdate(projectDetailMap.Values());    
           }
        }
    }
    
    
}