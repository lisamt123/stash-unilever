trigger user_after_insert on User (after insert) 
{
	if (Trigger.isAfter && Trigger.isInsert)
	{
		uw_TriggerHandler handler = new uw_TriggerHandler();
		handler.handleUserAfterInserts(Trigger.newMap);
		
		uw_TacHelper tacHelper = new uw_TacHelper();
		tacHelper.handleUserAfterInserts(Trigger.new);
	}
}