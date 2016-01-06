global with sharing class AF_SendEmailToCatFinance_schedule  implements Schedulable
 {
 
 
 global void execute(SchedulableContext ctx) 
    {  
 AF_SendEmailToCatFinance catfinance= new AF_SendEmailToCatFinance();
 database.executeBatch(catfinance);
 }
 
 
 
 
 }