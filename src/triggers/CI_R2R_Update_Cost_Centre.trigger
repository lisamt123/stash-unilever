trigger CI_R2R_Update_Cost_Centre on CI_R2R_Budget__c (after insert) {
    CI_R2R_Innovation_TriggerFactory.createHandler(CI_R2R_Budget__c.sObjectType);  
}