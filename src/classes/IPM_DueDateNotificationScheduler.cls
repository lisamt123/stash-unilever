/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Scheduler class for batch class IPM_DueDateNotificationBatch
* This class has been declared as Global as it implements Schedulable interface.
*********************************************/
global with sharing class IPM_DueDateNotificationScheduler implements Schedulable{
	private final string apexJobType = 'BatchApex';
	private final string processingStatus = 'Processing';
	private final string preaparingStatus = 'Preparing';
	private final string apaexJobName = 'MatrixRetry';
	
   global void execute(SchedulableContext sc) {
   	
   		//check if there are 5 active batch jobs
		//In some cases, might need to add "Status='Queued' " to the criteria
		if ([SELECT count() FROM AsyncApexJob WHERE JobType =:apexJobType AND (Status =: processingStatus OR Status =: preaparingStatus)] < 5)
		{ 
  			IPM_DueDateNotification_Batch b = new IPM_DueDateNotification_Batch();
            database.executebatch(b,50);
		}
		 else {
   				System.Schedule(apaexJobName+String.valueOf(Datetime.now()), IPM_ConstantUtils.IPM_NEXT_FIRE_TIME,new IPM_DueDateNotificationScheduler());
			}
   	 }
}