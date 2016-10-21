global class FA_PWTreminderMailScheduler implements Schedulable
{
    global void execute (SchedulableContext SC)
    {
        FA_PWTreminderMailBatchClass b = new FA_PWTreminderMailBatchClass();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,10);
     }
}