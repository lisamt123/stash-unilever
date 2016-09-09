global  with sharing class AA_Follow_UnFollow_Schedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      AA_Follow_Unfollow_batch b = new AA_Follow_Unfollow_batch(); 
      database.executebatch(b);
   }
}
/*
This code is to schedule the batch job hourly 
  AA_Follow_UnFollow_Schedular b= new AA_Follow_UnFollow_Schedular(); 
      String cron = '0 59 * * * ?';
      System.schedule('Agent App Follow Unfollow Job', cron, b);      
*/