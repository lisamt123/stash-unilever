global with sharing class MB_Scheduler implements Schedulable{
  
   global void execute(SchedulableContext sc) {

       MB_BillingBatch objMb=new MB_BillingBatch ();
       database.executebatch(objMb ,30000);
   }
}