trigger BFM_CTEvalidation on BFM_CT_e__c (before insert, before update,after insert, after update) {
    BFM_TriggerFactory.createhandler(BFM_CT_e__c.sObjectType);  
}