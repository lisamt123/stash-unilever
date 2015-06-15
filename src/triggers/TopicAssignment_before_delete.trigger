trigger TopicAssignment_before_delete on TopicAssignment (before delete) {
    
    try{
        if (Trigger.isBefore && Trigger.isDelete)
            {
              uw_TriggerHandler handler = new uw_TriggerHandler();
        
              handler.handleTopicBeforeDelete(Trigger.oldMap);
        
            }
       }
    
     catch(Exception ex){}
}