trigger BFM_CCEvalidation on BFM_CC_e__c (before insert, after insert) {
    BFM_TriggerFactory.createhandler(BFM_CC_e__c.sObjectType);  
}