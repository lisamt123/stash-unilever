global class uw_SendCollaborationInviteBatchJob implements Database.Batchable<SObject>
{

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        return Database.getQueryLocator('Select Id from uw_Terms_Conditions__c where Status__c = \'Accepted\' AND Action_On_Accept__c = \'Send Invite\'');
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> sscope)
    {   
    	List<uw_Terms_Conditions__c> TnCs = (List<uw_Terms_Conditions__c>)sscope;
    	
    	uw_BatchJobHelper batchJobHelper = new uw_BatchJobHelper();
    	batchJobHelper.sendCollaborationInvitesForAcceptedTsAndCs(TnCs);
    }
    
	global void finish(Database.BatchableContext BC)
	{
		// Run the batch job to enable users 
		// We can now daisy chain batch job together since v26.0
		uw_EnableExternalUserBatchJob batchJob = new uw_EnableExternalUserBatchJob();
        Database.executebatch(batchJob);
    }
}