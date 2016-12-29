Trigger FAU_PIITableTrigger on FAU_PII_Table__c (
  before insert 
  ) {
FAU_GroupCreationPIIClass.createChatterGroupforPIITable(trigger.new);
}