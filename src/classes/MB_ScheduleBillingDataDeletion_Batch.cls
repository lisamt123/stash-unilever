global class MB_ScheduleBillingDataDeletion_Batch implements Schedulable {

   global void execute(SchedulableContext sc) {
      MB_DeleteBillingData_Batch batchObj = new MB_DeleteBillingData_Batch();
   }
    
}