global class uw_SendCollaborationInviteBatchJob_Sch implements Schedulable
{
	global void execute(SchedulableContext sc) 
    {
        uw_SendCollaborationInviteBatchJob batchJob = new uw_SendCollaborationInviteBatchJob();
        Database.executebatch(batchJob);
    } 
}