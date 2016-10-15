/*
   Class Name              : CORE_CA_ReminderAlert_Scheduler
   Date                    : 17/09/2014
   Requirement/Project Name: Chatter Approvals
   Requirement/Description : Scheduler for the class 'CORE_CA_ReminderAlert'.
*/
global with sharing class CORE_CA_ReminderAlert_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
            CORE_CA_ReminderAlert_Batch objReminderAlert = new CORE_CA_ReminderAlert_Batch();
            //The excute the batch with the batch size 20.
            database.executebatch(objReminderAlert,20);
        }
}