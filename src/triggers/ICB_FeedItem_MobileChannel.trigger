trigger ICB_FeedItem_MobileChannel on FeedItem (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) 
    {
        ICB_SetupPhotoMobileChannel.getInstance().changePhoto(trigger.new);        
    }
}