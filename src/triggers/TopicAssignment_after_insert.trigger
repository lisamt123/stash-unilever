trigger TopicAssignment_after_insert on TopicAssignment (after insert) {
  
  try{
        if (Trigger.isAfter && Trigger.isInsert)
          {
           uw_TriggerHandler handler = new uw_TriggerHandler();
    
           handler.handleTopicAssignmentAfterInsert(Trigger.newMap);
          }
     }
  
  catch(Exception ex){}  

 }