/*
   Class Name              : CORE_CA_UnfollowUser_Scheduler
   Date                    : 12/09/2014
   Requirement/Project Name: Chatter Approvals
   Requirement/Description : Scheduler for the class 'CORE_CA_UnfollowUser_Batch'.
*/
global class CORE_CA_UnfollowUser_Scheduler implements Schedulable{
  
   global void execute(SchedulableContext sc) {
       CORE_CA_UnfollowUser_Batch objReminderAlert = new CORE_CA_UnfollowUser_Batch();
       //The excute the batch with the batch size 20.
       database.executebatch(objReminderAlert,20);
   }
}