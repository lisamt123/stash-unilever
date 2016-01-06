global with sharing class AF_BonusQuaterEmailToCatfinance_Schedule implements Schedulable
 {
 
 
 global void execute(SchedulableContext ctx) 
    {  
 AF_BonusQuaterlyEmailToCatFinance  EmailtoCatFinance= new AF_BonusQuaterlyEmailToCatFinance();
 database.executeBatch(EmailtoCatFinance);
 }
 
 
 
 
 }