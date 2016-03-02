/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Scheduler class for batch class IPM_DueDateNotificationBatch
* This class has been declared as Global as it implements Schedulable interface.
*********************************************/
global with sharing class IPM_DueDateNotificationScheduler implements Schedulable{
    private static final string APEXJOBTYPE = 'BatchApex';
    private static final string PREPARINGSTATUS  = 'Preparing';
        
   global void execute(SchedulableContext sc) {
        string APEXJOBNAME  = 'Milestone Due DateNotification Job'; 
        string dateTimeString = String.valueOf(Datetime.now());
        IPM_DueDateNotificationScheduler schedular = new IPM_DueDateNotificationScheduler();
        //check if there are 5 active batch jobs
        //In some cases, might need to add "Status='Queued' " to the criteria
        if ([SELECT count() FROM AsyncApexJob WHERE JobType =:APEXJOBTYPE AND (Status =: APEXJOBTYPE OR Status =: PREPARINGSTATUS)] < 5)
        { 
            IPM_DueDateNotification_Batch b = new IPM_DueDateNotification_Batch();
            database.executebatch(b,50);
        }
         else {
                System.Schedule(APEXJOBNAME+dateTimeString , IPM_ConstantUtils.IPM_NEXT_FIRE_TIME,schedular );
            }
     }
}