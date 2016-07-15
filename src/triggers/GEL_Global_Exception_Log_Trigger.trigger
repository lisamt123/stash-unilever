trigger GEL_Global_Exception_Log_Trigger on GEL_Global_Exception_Log__c (before insert,before update,after insert,before delete,after undelete, after update,after delete) {
    GEL_Global_Exception_TriggerFactory.createHandler(GEL_Global_Exception_Log__c.sObjectType);  
}