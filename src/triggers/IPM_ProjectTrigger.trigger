<<<<<<< HEAD
trigger IPM_ProjectTrigger on IPM_Project__c (after insert, after update) {
    
    IPM_ProjectTriggerHandler handler = new IPM_ProjectTriggerHandler(Trigger.isExecuting);
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isInsert){
            handler.onAfterInsert(Trigger.new);
        }
    }
=======
trigger IPM_ProjectTrigger on IPM_Project__c (before insert,after insert,before update,after update,before delete,after delete) {
    TriggerFactory.createHandler(IPM_Project__c.sObjectType);    
>>>>>>> FETCH_HEAD
}