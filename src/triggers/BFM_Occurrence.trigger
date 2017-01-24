trigger BFM_Occurrence on BFM_Occurrence__c (before update,before delete,after delete) {
    BFM_TriggerFactory.createHandler(BFM_Occurrence__c.sObjectType);
}