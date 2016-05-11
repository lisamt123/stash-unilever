trigger AccounTrigger on Account (before insert,after insert) {

AccountHelper.accountinsert(trigger.new,trigger.isafter,trigger.isbefore);
}