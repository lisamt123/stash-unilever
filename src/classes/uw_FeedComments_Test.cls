@isTest
public class uw_FeedComments_Test
{

private static testmethod void getChatterGroupCommentContentAndLinks_test()
{
Test.startTest();
CollaborationGroup cg=new CollaborationGroup(Name='Test Group Blessy',CollaborationType='Private');
Insert cg;
List<FeedComment> fc=uw_FeedComments.getChatterGroupCommentContentAndLinks(cg.id);
Test.stopTest();
}

private static testmethod void getFeedCommentById_test()
{
Test.startTest();
CollaborationGroup cg1=new CollaborationGroup(Name='Test Group Blessy1',CollaborationType='Private');
Insert cg1;
FeedItem testfeed=new FeedItem(Body='Test Feed Post',ParentId=cg1.Id,Type='TextPost');
Insert testfeed;
FeedComment testfeedcomment=new FeedComment(CommentBody='Test Feed Comment',FeedItemid=testfeed.id,CommentType='TextComment');
Insert testfeedcomment;
List<FeedComment> fc=uw_FeedComments.getFeedCommentById(testfeedcomment.id);
Test.stopTest();
}

public static testmethod void getFeedCommentInId_test()
{
Test.startTest();
Set<id> commentidset=new Set<id>();
for(integer i =0; i < 5;i++){
CollaborationGroup cg1=new CollaborationGroup(Name='Test Group Blessy2'+Math.random(),CollaborationType='Private');
Insert cg1;
FeedItem testfeed=new FeedItem(Body='Test Feed Post',ParentId=cg1.Id,Type='TextPost');
Insert testfeed;
FeedComment testfeedcomment=new FeedComment(CommentBody='Test Feed Comment',FeedItemid=testfeed.id,CommentType='TextComment');
Insert testfeedcomment;
commentidset.add(testfeedcomment.id);
}
List<FeedComment> fc1=uw_FeedComments.getFeedCommentInId(commentidset);
Test.stopTest();
}

public static testmethod void getFeedCommentsByFeedItemAndCommentType_test()
{
Test.startTest();
Set<id> commentidset=new Set<id>();
CollaborationGroup cg1=new CollaborationGroup(Name='Test Group Blessy3',CollaborationType='Private');
Insert cg1;
FeedItem testfeed=new FeedItem(Body='Test Feed Post',ParentId=cg1.Id,Type='TextPost');
Insert testfeed;
FeedComment testfeedcomment=new FeedComment(CommentBody='Test Feed Comment',FeedItemid=testfeed.id,CommentType='TextComment');
Insert testfeedcomment;

commentidset.add(testfeedcomment.id);
List<FeedComment> fc1=uw_FeedComments.getFeedCommentsByFeedItemAndCommentType(commentidset,testfeedcomment.CommentType);
Test.stopTest();
}

public static testmethod void getCollaborationGroupFeedByCollaborationGroupId_test()
{
Test.startTest();
CollaborationGroup cg1=new CollaborationGroup(Name='Test Group Blessy4',CollaborationType='Private');
Insert cg1;
FeedItem testfeed=new FeedItem(Body='Test Feed Post',ParentId=cg1.Id,Type='TextPost');
Insert testfeed;
FeedComment testfeedcomment=new FeedComment(CommentBody='Test Feed Comment',FeedItemid=testfeed.id,CommentType='TextComment');
Insert testfeedcomment;
List<CollaborationGroupFeed> cgf=uw_FeedComments.getCollaborationGroupFeedByCollaborationGroupId(cg1.id);
Test.stopTest();
}

public static testmethod void getCollaborationGroupFeedByParentAndId_test()
{
Test.startTest();
CollaborationGroup cg1=new CollaborationGroup(Name='Test Group Blessy5',CollaborationType='Private');
Insert cg1;
FeedItem testfeed=new FeedItem(Body='Test Feed Post',ParentId=cg1.Id,Type='TextPost');
Insert testfeed;
FeedComment testfeedcomment=new FeedComment(CommentBody='Test Feed Comment',FeedItemid=testfeed.id,CommentType='TextComment');
Insert testfeedcomment;
List<String> lst=new List<String>();
lst.add(testfeed.id);
 List<CollaborationGroupFeed> cgf=uw_FeedComments.getCollaborationGroupFeedByParentAndId(cg1.id,lst);
Test.stopTest();
}

}