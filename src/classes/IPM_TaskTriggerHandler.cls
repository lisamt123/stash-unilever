public without sharing class IPM_TaskTriggerHandler {
    
    private boolean m_isExecuting = false;

    public IPM_TaskTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    public void onAfterInsert(IPM_Task__c[] newTasks) {
        
        Set<Id> sectionIds = new Set<Id>();
        for(IPM_Task__c eachTask : newTasks) {
            sectionIds.add(eachTask.IPM_Project_Document_Section__c);
        }
        IPM_TaskHelper.markSectionNotStarted(sectionIds);
    }
    
    public void onAfterUnDelete(IPM_Task__c[] newTasks) {
        
        Set<Id> sectionIds = new Set<Id>();
        for(IPM_Task__c eachTask : newTasks) {
            sectionIds.add(eachTask.IPM_Project_Document_Section__c);
        }
        IPM_TaskHelper.markSectionNotStarted(sectionIds);
    }
    
    public void onAfterUpdate(IPM_Task__c[] newTasks, Map<Id, IPM_Task__c> oldTaskMap) {
        
        Map<Id, Set<String>> projectTasksMap = new Map<Id, Set<String>>();
        
        for(IPM_Task__c eachTask : newTasks) {
            IPM_Task__c oldTask = oldTaskMap.get(eachTask.Id);
            if(eachTask.IPM_Project__c != null && eachTask.IPM_Completed__c && 
                       eachTask.IPM_Completed__c != oldTask.IPM_Completed__c) {
               if(!projectTasksMap.containsKey(eachTask.IPM_Project__c)) {
                    Set<String> tmpStr = new Set<String>();
                    tmpStr.add(eachTask.Name);
                    projectTasksMap.put(eachTask.IPM_Project__c, tmpStr);
               }else {
                   projectTasksMap.get(eachTask.IPM_Project__c).add(eachTask.Name);
               }
            }
        }
        
        for(Id eachProject : projectTasksMap.keySet()) {
            IPM_ChatterUtils.postRecordFeed(eachProject, IPM_Utils.convertSetToString(projectTasksMap.get(eachProject)) + IPM_ChatterUtils.TASK_COMPLETION_TEXT);
        }
    }
    
    public void OnAfterDelete(IPM_Task__c[] oldTasks) {
        
        Set<Id> sectionIds = new Set<Id>();
        for(IPM_Task__c eachTask : oldTasks) {
            sectionIds.add(eachTask.IPM_Project_Document_Section__c);
        }
        IPM_TaskHelper.markSectionExcluded(sectionIds);
    }
}