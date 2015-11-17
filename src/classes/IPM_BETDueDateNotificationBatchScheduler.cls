global class IPM_BETDueDateNotificationBatchScheduler implements Schedulable{
	private final string apexJobType = 'BatchApex';
	private final string processingStatus = 'Processing';
	private final string preaparingStatus = 'Preparing';
	private final string apexDateFormat = 's m H d M \'?\' yyyy';
	private final string apaexJobName = 'MatrixRetry';
	public static Boolean executeMoreThanFive = false;
	
   global void execute(SchedulableContext sc) {
   	
   		//check if there are 5 active batch jobs
		//In some cases, might need to add "Status='Queued' " to the criteria
		if ([SELECT count() FROM AsyncApexJob WHERE JobType =:apexJobType AND (Status =: processingStatus OR Status =: preaparingStatus)] < 5)
		{ 
  			IPM_BETDueDateNotificationBatch b = new IPM_BETDueDateNotificationBatch();
            database.executebatch(b);
		}
		 else {
   			//schedule this same schedulable class again in 30 mins
   			IPM_BETDueDateNotificationBatchScheduler scLater = new IPM_BETDueDateNotificationBatchScheduler();
   			Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
   			String timeForScheduler = dt.format(apexDateFormat);
   			System.Schedule(apaexJobName+timeForScheduler,timeForScheduler,scLater);
		}
   }
}