global with sharing class MB_ScheduleBillingDataDeletion_Batch implements Schedulable {

   global void execute(SchedulableContext sc) {
      new MB_DeleteBillingData_Batch();
   }
    
}