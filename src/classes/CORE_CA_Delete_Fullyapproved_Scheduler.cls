/*
   Class Name              : CORE_CA_Delete_Fullyapproved_Scheduler
   Date                    : 07/07/2015        
   Requirement/Project Name: Chatter Approvals
   Requirement/Description : Scheduler for the class 'CORE_CA_Delete_Fullyapproved_Batch'.
*/
global class CORE_CA_Delete_Fullyapproved_Scheduler implements Schedulable{
  
   global void execute(SchedulableContext sc) {
       CORE_CA_Delete_Fullyapproved_Batch objFullyappr = new CORE_CA_Delete_Fullyapproved_Batch();
       //The excute the batch with the batch size 20.
       database.executebatch(objFullyappr,20);
   }
}