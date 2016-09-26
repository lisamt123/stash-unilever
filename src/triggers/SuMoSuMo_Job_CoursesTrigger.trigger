trigger SuMoSuMo_Job_CoursesTrigger on SuMo_Job_Courses__c (after insert, after update) {
  success.SuMoTriggerHandler handler = new success.SuMoTriggerHandler();
  if (Trigger.isInsert && Trigger.isAfter) {
    handler.OnInsert(Trigger.new);
  }
  if (Trigger.isUpdate && Trigger.isAfter) {
    handler.OnUpdate(Trigger.old, Trigger.new, Trigger.newMap);
  }
}