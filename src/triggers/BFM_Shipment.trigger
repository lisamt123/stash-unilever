trigger BFM_Shipment on BFM_Shipment__c (before update) {
    BFM_TriggerFactory.createHandler(BFM_Shipment__c.sObjectType);
}