<<<<<<< HEAD
trigger IPM_FinancialTrigger on IPM_Financial__c (after insert, after update, before delete) {
    ipmFinancialTriggerHandler handler = new ipmFinancialTriggerHandler();
    IPM_FinancialShare FinShare=new IPM_FinancialShare();
    if(System.Trigger.isBefore){
        if(System.Trigger.isDelete){
            handler.onBeforeDelete(trigger.oldMap);
        }

    }else if(System.Trigger.isAfter){
        if(System.Trigger.isInsert){
            handler.onAfterInsert(trigger.new);
            //FinShare.Sharerecords(Trigger.newMap);
        } else if(System.Trigger.isUpdate){
            handler.onAfterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
=======
/**
@Author Cognizant
@Name IPM_FinancialTrigger
@CreateDate 27/08/2015
@Description Trigger for object:IPM_Financial__c
@Version 1.0
@reference 
*/
trigger IPM_FinancialTrigger on IPM_Financial__c (before insert,after insert,before update,after update,before delete,after delete) {
    string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    IPM_Trigger_Router__c triggerRouter = IPM_Trigger_Router__c.getInstance(CSkey); 
    /** Checking for the trigger router flag from custom setting   */
    if(triggerRouter!=null && triggerRouter.is_Disabled__c){
        return;
    }
    TriggerFactory.createHandler(IPM_Financial__c.sObjectType);    
>>>>>>> FETCH_HEAD
}