trigger ICB_Setup_Mobile_Channel on Contact (after insert, after update) {
    
    // Check isBefore
    if(Trigger.isAfter) 
    {               
        ICB_SetupMobileChannel.getInstance().initiateMethod(Trigger.new);   
    }
}