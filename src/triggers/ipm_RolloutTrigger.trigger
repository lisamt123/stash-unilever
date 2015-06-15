trigger ipm_RolloutTrigger on IPM_Project_Rollout__c (before delete, after insert,after update) {
    ipmRolloutTriggerHandler handler = new ipmRolloutTriggerHandler();
    IPM_RolloutShare RolloutShare=new IPM_RolloutShare();

    if(System.Trigger.isBefore){
        if(System.Trigger.isDelete){
            handler.processDelete(trigger.old);
        }
    } else if(System.Trigger.isAfter){
        if(System.Trigger.isInsert){
            handler.processInsert(trigger.new);
            RolloutShare.Sharerecords(trigger.newMap);
        }
        else if(System.Trigger.isUpdate){
            handler.processUpdate(trigger.newMap, trigger.oldMap);
            RolloutShare.UpdateSharerecords(trigger.newmap);        
        }
   }
  
}