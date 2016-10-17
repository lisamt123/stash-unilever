trigger BFM_DebitNoteTrigger on BFM_Debit_Note__c (before insert, before update) {
    BFM_TriggerFactory.createhandler(BFM_Debit_Note__c.sObjectType);  
}