trigger FeedComment_After_Insert_Email on FeedComment (after insert) {

EmailHandler objhandler=new EmailHandler();
objhandler.FeedCommentEmailHandler(trigger.new);

}