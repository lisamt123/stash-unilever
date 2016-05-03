trigger FA_Trigger_After_Course on FA_Course__c (after insert) {

  if(trigger.isInsert)
  {
     FA_Trigger_Course.After_AddingOwnerAsFacilitator(trigger.new);
  }   
  

}