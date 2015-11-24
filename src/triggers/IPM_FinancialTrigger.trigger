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
}