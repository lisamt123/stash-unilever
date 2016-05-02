global class AF_BonusQuarterly_Reminder_schedule  implements Schedulable
 {
 
 
 global void execute(SchedulableContext ctx) 
    {  
 AF_Bonusquarterly_Reminder  Reminder= new AF_Bonusquarterly_Reminder ();
 database.executeBatch(Reminder);
 }
 
 
 
 
 }