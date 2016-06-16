trigger DMS_ContactTrigger on Contact (after insert, after update) { 
    
    DMS_ContactTriggerHelper vClassContact = new DMS_ContactTriggerHelper();
    
    if(Trigger.isAfter && Trigger.isInsert) 
    {
        vClassContact.createNewUser(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) 
    {
        vClassContact.createtUserUpdate(Trigger.old, Trigger.new);
    }       
        
}