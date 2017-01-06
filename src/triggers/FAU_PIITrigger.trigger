trigger FAU_PIITrigger on FAU_PII__c (before insert, before update) {
if(Trigger.isinsert)
{
FAU_GroupCreationPIIClass.createChatterGroupPII(trigger.new);
}

FAU_GroupCreationPIIClass.retreivingFields(trigger.new);
}