trigger DMS_ContactTrigger on Contact (after insert, after update) { 
    
    DMS_UserCreation vClassContact = new DMS_UserCreation();
    
    if(Trigger.isAfter && Trigger.isInsert) 
    {
        vClassContact.createNewUser(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) 
    {
        vClassContact.createtUserUpdate(Trigger.old, Trigger.new);
    }       
        
}