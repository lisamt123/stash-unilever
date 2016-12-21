trigger BFM_PODTrigger on BFM_POD__c (before insert, before update,After insert,After update) {
    BFM_TriggerFactory.createhandler(BFM_POD__c.sObjectType);  
}