trigger SOWSplitProjectAvoid on Oblix_Marketing_SOW_Project_Splits__c (before insert, before update, before delete, after insert, after update, after delete) {
     TriggerFactory.createHandler(Oblix_Marketing_SOW_Project_Splits__c.sObjectType);
}