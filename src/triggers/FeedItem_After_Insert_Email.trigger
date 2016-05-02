trigger FeedItem_After_Insert_Email on FeedItem (after insert) {

EmailHandler objhandler=new EmailHandler();
objhandler.FeedItemEmailHandler(trigger.new);

}