trigger BFM_NFSvalidation on BFM_NFS__c (before insert, before update,After update) {
    BFM_TriggerFactory.createhandler(BFM_NFS__c.sObjectType);  
}