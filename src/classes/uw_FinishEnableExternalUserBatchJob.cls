global class uw_FinishEnableExternalUserBatchJob implements Database.Batchable<SObject>
{
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        return Database.getQueryLocator('Select Id from uw_Terms_Conditions__c where Status__c = \'Accepted\' AND Action_On_Accept__c = \'Enable User\'');
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> sscope)
    {   
    	List<uw_Terms_Conditions__c> TnCs = (List<uw_Terms_Conditions__c>)sscope;
    	
    	uw_BatchJobHelper batchJobHelper = new uw_BatchJobHelper();
    	batchJobHelper.finishEnableExternalUsersForTsAndCs(TnCs);
    }
    
	global void finish(Database.BatchableContext BC)
	{
		// This is the last in the chain of batch jobs - 
		// Now schedule the initial job again
		uw_BatchJobHelper helper = new uw_BatchJobHelper();
		helper.markSendInviteJobAsFinished();
		helper.scheduleNextSendInviteBatchJob();
    }
}