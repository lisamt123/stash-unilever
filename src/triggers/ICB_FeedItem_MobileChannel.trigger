trigger ICB_FeedItem_MobileChannel on FeedItem (before insert) {
    if(Trigger.isAfter && Trigger.isInsert) 
    {
        ICB_SetupPhotoMobileChannel.getInstance().changePhoto(trigger.new);        
    }
}