trigger EA_SendFeedback_Notification_trigger on EA_Team_Member__c (after insert) {
            
       if(Trigger.isAfter && Trigger.isInsert) {
       
            if(Trigger.new != null && Trigger.new.size()>0){
            
                EA_Feedback_Controller.sendFeedbackReminder(Trigger.new);
             }         
       }   
     
}