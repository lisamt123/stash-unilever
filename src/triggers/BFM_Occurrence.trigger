trigger BFM_Occurrence on BFM_Occurrence__c (before update) {
    BFM_TriggerFactory.createHandler(BFM_Occurrence__c.sObjectType);
}