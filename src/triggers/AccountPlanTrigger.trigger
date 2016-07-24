trigger AccountPlanTrigger on FS_Account_Plan__c (after insert, after update, before insert, before update) {
    FS_AccountPlanHandler handler=new FS_AccountPlanHandler();
    //Update approved and status on defined objective after account plan record is modified
    if(trigger.isAfter && trigger.isUpdate){
       handler.updateDefinedObjectiveonapproval(Trigger.new,Trigger.OldMap); 
    }
}