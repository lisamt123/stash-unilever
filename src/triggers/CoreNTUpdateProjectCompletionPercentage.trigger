trigger CoreNTUpdateProjectCompletionPercentage on CORE_NT_Task__c(after update) {
MAP<Id,CORE_NT_Task__c> lstOldTaskDetail= Trigger.oldMap;
MAP<Id,CORE_NT_Task__c> lstNewTaskDetail= Trigger.newMap;
CORE_NT_Task__c oldTaskDetail;
CORE_NT_Task__c newTaskDetail;
    for(Id id: lstOldTaskDetail.keySet())
    {
        oldTaskDetail = lstOldTaskDetail.get(id);
    }
    //System.debug('Old Task detail'+oldTaskDetail);
    for(Id id: lstNewTaskDetail.keySet())
    {
        newTaskDetail = lstNewTaskDetail.get(id); 
    }
    //System.debug('new Task detail'+newTaskDetail);               
    if(oldTaskDetail.Complete__c == false && newTaskDetail.Complete__c == true){
        AggregateResult taskCount=[SELECT count(Id) FROM CORE_NT_Task__c WHERE ProjectId__c = :newTaskDetail.ProjectId__c ];
        AggregateResult taskCompletedCount=[SELECT count(Id) FROM CORE_NT_Task__c WHERE ProjectId__c = :newTaskDetail.ProjectId__c and Complete__c=true ];
        List<CORE_NT_Project__c> projectPercent=[SELECT PercentComplete__c FROM CORE_NT_Project__c WHERE Id =:newTaskDetail.ProjectId__c];
        if(taskCount==taskCompletedCount)
            projectPercent[0].PercentComplete__c=100;
        else{
            Decimal singleTaskPercent=(1*100)/((Integer)taskCount.get('expr0'));
            projectPercent[0].PercentComplete__c+=singleTaskPercent;
        }
       // System.debug('projectPercent[0].PercentComplete__c'+projectPercent[0].PercentComplete__c);     
        update projectPercent;
    }
}