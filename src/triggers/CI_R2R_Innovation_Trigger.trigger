trigger CI_R2R_Innovation_Trigger on CI_R2R_Innovation__c (After insert) {
    CI_R2R_Innovation_TriggerFactory.createHandler(CI_R2R_Innovation__c.sObjectType);  
}