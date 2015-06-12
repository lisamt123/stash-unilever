trigger FA_Trigger_After_CouOccurence on FA_Course_Occurence__c (after insert,after update) {
    if(Trigger.isinsert)
     {
       FA_Trigger_CourseOccurence.After_ChatterGroupFeed(Trigger.new);
       FA_Trigger_CourseOccurence.After_AccessToFacilitators(Trigger.new);
     }
         if(Trigger.isUpdate)
     {
       FA_Trigger_CourseOccurence.After_CancelPartcipation(Trigger.new,Trigger.old);
     //  FA_Trigger_CourseOccurence.After_UpdateSendInvitataionMail(Trigger.new,Trigger.old);
       
       
       /*
          This trigger is used to update the field on the Occurance member called "Send Feedback Invite" to trigger 
          the workflow for sending the feedback invite mail          
       */
       FA_Trigger_CourseOccurence.After_InitiateFeedback(Trigger.new,Trigger.old);
     }

 }