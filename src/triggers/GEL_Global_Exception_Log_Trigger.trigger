trigger GEL_Global_Exception_Log_Trigger on GEL_Global_Exception_Log__c (before insert,before update) {
    GEL_Global_Exception_TriggerFactory.createHandler(GEL_Global_Exception_Log__c.sObjectType);  
}