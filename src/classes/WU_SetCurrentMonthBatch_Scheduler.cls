global class WU_SetCurrentMonthBatch_Scheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    WU_SetCurrentMonthBatch setCurrentMonth = new WU_SetCurrentMonthBatch(); 
      database.executebatch(setCurrentMonth);
    }
}