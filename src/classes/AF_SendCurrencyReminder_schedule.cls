/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_SendCurrencyReminder_schedule 
   @CreateDate : 23/8/2014
   @Description : This is a used to schedule the af_SendCurrencyReminder batch class
   @              
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global with sharing class AF_SendCurrencyReminder_schedule  implements Schedulable
 {
 
 
 global void execute(SchedulableContext ctx) 
    {  
 AF_SendCurrencyReminder currencyReminder= new AF_SendCurrencyReminder();
 database.executeBatch(currencyReminder);
 }
 
 
 
 
 }