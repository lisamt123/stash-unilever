global class uw_EnableExternalUserBatchJob implements Database.Batchable<SObject>
{
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        return Database.getQueryLocator('Select Id from uw_Terms_Conditions__c where Status__c = \'Accepted\' AND Action_On_Accept__c = \'Enable User\'');
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> sscope)
    {   
    	List<uw_Terms_Conditions__c> TnCs = (List<uw_Terms_Conditions__c>)sscope;
    	
    	uw_BatchJobHelper batchJobHelper = new uw_BatchJobHelper();
    	batchJobHelper.enableExternalUsersForTsAndCs(TnCs);
    }
    
	global void finish(Database.BatchableContext BC)
	{
		//uw_BatchJobHelper helper = new uw_BatchJobHelper();
		//helper.markSendInviteJobAsFinished();
		//helper.scheduleNextSendInviteBatchJob();
		 
		// Run the batch job to mark the Terms & Conditions records as processed
		// We cannot do that in this job - as it would give a mixed DML exception
		// We can now daisy chain batch job together since v26.0
		uw_FinishEnableExternalUserBatchJob batchJob = new uw_FinishEnableExternalUserBatchJob();
        Database.executebatch(batchJob);
    }
    
}