<<<<<<< HEAD
trigger IPM_Project_Resource_Trigger on IPM_Project_Resource__c (after insert, after update, after delete, after undelete) {
    
    IPM_ProjectResourceTriggerHandler handler = new IPM_ProjectResourceTriggerHandler(Trigger.isExecuting);
    if(Trigger.isDelete && Trigger.isAfter){
        handler.OnAfterDelete(Trigger.old);
    }else if(Trigger.isInsert && Trigger.isAfter){
        handler.onAfterInsert(Trigger.new);
    }else if(Trigger.isUnDelete && Trigger.isAfter){
        handler.onAfterUnDelete(Trigger.new);
    }else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
    }
=======
trigger IPM_Project_Resource_Trigger on IPM_Project_Resource__c (before insert,after insert,before update,after update,before delete,after delete, after undelete) {
    TriggerFactory.createHandler(IPM_Project_Resource__c.sObjectType);    
   
>>>>>>> FETCH_HEAD
}