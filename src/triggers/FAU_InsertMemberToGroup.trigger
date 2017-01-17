trigger FAU_InsertMemberToGroup on FAU_Sponsor__c (after Insert,after delete) {

if(Trigger.isinsert)
{

FAU_GroupCreationPIIClass.insertMemberToGroup(Trigger.new);
}
if(Trigger.isdelete) 
{
 FAU_GroupCreationPIIClass.sponsordelfrmgroup(Trigger.old);
}
}