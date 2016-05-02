trigger AttachmentTrigger on Attachment (after insert) {
	AttachmentTriggerHandler handler = new AttachmentTriggerHandler(Trigger.isExecuting);
    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
}