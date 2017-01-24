trigger BFM_Shipment on BFM_Shipment__c (before update,before delete,after delete) {
    BFM_TriggerFactory.createHandler(BFM_Shipment__c.sObjectType);
}