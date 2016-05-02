global class CORE_Batch_Deactivate_Ext_User_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
            CORE_Batch_Deactivate_External_User b = new CORE_Batch_Deactivate_External_User();
            database.executebatch(b,20);
        }
}