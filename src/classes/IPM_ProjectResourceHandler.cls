public with sharing class IPM_ProjectResourceHandler {
    
    private boolean m_isExecuting = false;

    public IPM_ProjectResourceHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    public void OnAfterUpdate(IPM_Project_Resource__c[] newProjectResources, Map<Id, IPM_Project_Resource__c> newProjectResourcesMap, 
                                Map<Id, IPM_Project_Resource__c> oldProjectResources) {
        
        if(IPM_CheckRecursive.runOnce()) {
            IPM_TaskHelper.reAssignTasks(newProjectResources, newProjectResourcesMap, oldProjectResources);
        }
    }
}