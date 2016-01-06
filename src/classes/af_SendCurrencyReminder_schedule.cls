global with sharing class af_SendCurrencyReminder_schedule  implements Schedulable
 {
 
 
 global void execute(SchedulableContext ctx) 
    {  
 af_SendCurrencyReminder currencyReminder= new af_SendCurrencyReminder();
 database.executeBatch(currencyReminder);
 }
 
 
 
 
 }