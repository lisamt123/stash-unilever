trigger BFM_NFEvalidation on BFM_Nf_e__c (before insert, before update,after insert,after update) {
    BFM_TriggerFactory.createhandler(BFM_Nf_e__c.sObjectType);  
}