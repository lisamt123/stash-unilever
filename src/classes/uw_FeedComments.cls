public without sharing class uw_FeedComments {
    public static List<FeedComment > getChatterGroupCommentContentAndLinks(String cgId)           //when user enters a file as a comment //KJ:17/10
    {
        return [Select f.RelatedRecordId, f.ParentId, f.Id, f.CommentBody, f.Commenttype, f.feeditemid From FeedComment f where ParentID = :cgId];
    }
    
    public static List<FeedComment> getFeedCommentById(String feedCommentId){
        return [SELECT CommentBody, CommentType, FeedItemId, ParentId, RelatedRecordId FROM FeedComment WHERE id = :feedCommentId];
    }

    public static List<FeedComment> getFeedCommentInId(Set<Id> feedCommentIdSet){
        return [SELECT CommentBody, CommentType, FeedItemId, ParentId, RelatedRecordId FROM FeedComment WHERE id IN :feedCommentIdSet];
    }
    
    public static List<FeedComment> getFeedCommentsByFeedItemAndCommentType(Set<Id> setDeletingFeedItems, String contentType) {
    	return [SELECT Id, CommentType, RelatedRecordId, ParentId FROM FeedComment WHERE FeedItemId IN :setDeletingFeedItems AND CommentType=:contentType];
    }
    
    public static List<CollaborationGroupFeed> getCollaborationGroupFeedByCollaborationGroupId(String groupId) {
    	return [Select Type, Title, RelatedRecordId, ParentId, LinkUrl, LikeCount, ContentType, ContentSize, ContentFileName
            , ContentDescription, CommentCount, Body,CreatedById, CreatedDate
            ,  (Select Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, IsDeleted, InsertedById From FeedComments)
            , (Select CreatedDate From FeedLikes) 
            From CollaborationGroupFeed where ParentId =: groupId];
    }
    
    public static List<CollaborationGroupFeed> getCollaborationGroupFeedByParentAndId(String parentId, List<String> feedItemIds) {
    	return [Select Type, Title, RelatedRecordId, ParentId, LinkUrl, LikeCount, ContentType, ContentSize, ContentFileName
            , ContentDescription, CommentCount, Body,CreatedById, CreatedDate
            ,  (Select Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, IsDeleted, InsertedById From FeedComments)
            , (Select CreatedDate From FeedLikes) 
            From CollaborationGroupFeed where ParentId =: parentId and Id in : feedItemIds];
    }
}