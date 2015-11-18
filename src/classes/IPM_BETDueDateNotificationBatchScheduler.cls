/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Scheduler class for batch class IPM_BETDueDateNotificationBatch
* This class has been declared as Global as it implements Schedulable interface.
*********************************************/
global with sharing class IPM_BETDueDateNotificationBatchScheduler implements Schedulable{
    private static final string APEXJOBTYPE = 'BatchApex';
    private static final string PROCESSINGSTATUS = 'Processing';
    private static final string PREPARINGSTATUS  = 'Preparing';
    
   global void execute(SchedulableContext sc) {
    
        //check if there are 5 active batch jobs
        //In some cases, might need to add "Status='Queued' " to the criteria
        if ([SELECT count() FROM AsyncApexJob WHERE JobType =:APEXJOBTYPE AND (Status =: PROCESSINGSTATUS OR Status =: PREPARINGSTATUS)] < 5)
        { 
            IPM_BETDueDateNotificationBatch b = new IPM_BETDueDateNotificationBatch();
            database.executebatch(b,50);
        }
         else {
            //schedule this same schedulable class at later time
            System.Schedule(PREPARINGSTATUS+String.valueOf(Datetime.now()), IPM_ConstantUtils.IPM_NEXT_FIRE_TIME,new IPM_BETDueDateNotificationBatchScheduler());
            
        }
   }
}