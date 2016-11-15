trigger FA_Trigger_After_CouFacilitator on FA_Course_Facilitator__c (after insert, after delete) {

     if(trigger.isInsert)
     {
       FA_Trigger_CourseFacilitator.After_AssociateFacilitatorsToGroup(trigger.new);
       FA_Trigger_CourseFacilitator.After_AssocFacilitatorsToGroup(trigger.new);
       FA_Trigger_CourseFacilitator.After_AccessToFacilitators(Trigger.new);       
       
     }
     
    if(trigger.isDelete)
      {
       FA_Trigger_CourseFacilitator.After_RevokeAccessFromCoFacilitators(Trigger.old);  
       FA_Trigger_CourseFacilitator.After_DeleteFacilitatorsFromGroup(trigger.old);
      } 
}