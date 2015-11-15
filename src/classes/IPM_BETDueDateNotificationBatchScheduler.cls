/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Scheduler class for batch class IPM_BETDueDateNotificationBatch
* This class has been declared as Global as it implements Schedulable interface.
*********************************************/
global with sharing class IPM_BETDueDateNotificationBatchScheduler implements Schedulable{
    private final string apexJobType = 'BatchApex';
    private final string processingStatus = 'Processing';
    private final string preaparingStatus = 'Preparing';
    private final string apexJobName = 'MatrixRetry';
    
   global void execute(SchedulableContext sc) {
    
        //check if there are 5 active batch jobs
        //In some cases, might need to add "Status='Queued' " to the criteria
        if ([SELECT count() FROM AsyncApexJob WHERE JobType =:apexJobType AND (Status =: processingStatus OR Status =: preaparingStatus)] < 5)
        { 
            IPM_BETDueDateNotificationBatch b = new IPM_BETDueDateNotificationBatch();
            database.executebatch(b,50);
        }
         else {
            //schedule this same schedulable class at later time
            System.Schedule(apexJobName+String.valueOf(Datetime.now()), IPM_ConstantUtils.IPM_NEXT_FIRE_TIME,new IPM_BETDueDateNotificationBatchScheduler());
            
        }
   }
}