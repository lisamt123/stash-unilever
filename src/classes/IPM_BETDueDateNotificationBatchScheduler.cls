/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Scheduler class for batch class IPM_BETDueDateNotificationBatch
* This class has been declared as Global as it implements Schedulable interface.
*********************************************/
global with sharing class IPM_BETDueDateNotificationBatchScheduler implements Schedulable{
    
   global void execute(SchedulableContext sc) {
		string PREPARINGSTATUS  = 'Preparing';  
        string dateTimeString = String.valueOf(Datetime.now());
        string APEXJOBTYPE = 'BatchApex';
    	string PROCESSINGSTATUS = 'Processing';
        
        //check if there are 5 active batch jobs
        //In some cases, might need to add "Status='Queued' " to the criteria
        if ([SELECT count() FROM AsyncApexJob WHERE JobType =:APEXJOBTYPE AND (Status =: PROCESSINGSTATUS OR Status =: PREPARINGSTATUS)] < 5)
        { 
            IPM_BETDueDateNotificationBatch b = new IPM_BETDueDateNotificationBatch();
            database.executebatch(b,50);
        }
         else {
            //schedule this same schedulable class at later time
            System.Schedule(PREPARINGSTATUS+dateTimeString, IPM_ConstantUtils.IPM_NEXT_FIRE_TIME,new IPM_BETDueDateNotificationBatchScheduler());
            
        }
   }
}