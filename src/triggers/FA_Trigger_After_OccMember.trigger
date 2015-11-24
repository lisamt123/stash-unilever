trigger FA_Trigger_After_OccMember on FA_Occurence_Member__c (after insert,after delete) {
  if(Trigger.isInsert)
    {     
      FA_Trigger_OccurenceMember.After_AssociateMembersToGroup(Trigger.new); 
      FA_Trigger_OccurenceMember.After_AssocMembersToHelpAndAllFAGroup(Trigger.new);     
      FA_Trigger_OccurenceMember.After_ShareAccessToOccMembers(trigger.new);
      FA_Trigger_OccurenceMember.After_AssocMembersToCourseGroup(Trigger.new);
   //   FA_Trigger_OccurenceMember.After_AssocMembersToThemeBasedGroups(Trigger.new);
      FA_Trigger_OccurenceMember.After_AssocTasksToNewMembers(Trigger.new);
    } 
  if(Trigger.isDelete)
    {
      FA_Trigger_OccurenceMember.After_DeleteMembersFromGroup(Trigger.old);
      FA_Trigger_OccurenceMember.After_RevokeAccessFromOccMembers(trigger.old); 
    }
 }