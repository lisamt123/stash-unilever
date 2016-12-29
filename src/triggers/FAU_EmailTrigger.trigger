trigger FAU_EmailTrigger on FAU_Email__c ( before insert,after update) {
    
         If(Trigger.IsAfter|| Trigger.IsUpdate){
            FAU_EmailHandler.sendEmail(Trigger.new);
        }

}