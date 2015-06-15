@IsTest(SeeAllData=true)
public with sharing class uw_PinnovateController_Test {

public static List<uw_PinnovateController.PinnovateRow> getPinnotaveTestRows()
  {

    uw_PinnovateController con = new uw_PinnovateController();
    List<uw_PinnovateController.PinnovateRow> rows = new List<uw_PinnovateController.PinnovateRow>();
    
    for (Integer r = 0 ; r < 2; r++)
    {
      uw_PinnovateController.PinnovateRow row = new uw_PinnovateController.PinnovateRow();
    
      for (Integer d = 0 ; d < 2; d++)
      {  
        uw_PinnovateController.PinnovateTableData ptd = new uw_PinnovateController.PinnovateTableData();
        ptd.title = 'Title --  '+r+':'+d;
        ptd.titleColour = con.getNextColour();
        row.tableData.add(ptd);
      }
      rows.add(row);
    }

    return rows;
  }
  
  // This test method needs to see all data to see Collab Groups Posts
  // Does not make scense to me - but it's true!!
  @IsTest(SeeAllData=true)
  public static void testController()
  {
    test.starttest();
    Id testCollabGroupId = uw_UnitTestDataFactory.getTestChatterGroup().Id;
    Apexpages.currentPage().getParameters().put('id',testCollabGroupId);
    
    // Create some test posts - 
    String testLongBody = '1234567890 1234567890 1234567890';
    String testBody = testLongBody;
    
    List<FeedItem> posts = new List<FeedItem>();
    
    for (Integer i = 0; i < 2; i++)
    {
      FeedItem feedPost = new FeedItem();
          feedPost.parentId = testCollabGroupId;
            
          feedPost.Type = 'LinkPost';
          feedPost.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
          feedPost.Title   = 'Test Title';
          feedPost.Body    = testBody;
          testBody += testLongBody;
          feedPost.CreatedById = Userinfo.getUserId();
            
          feedPost.CreatedDate = System.now().addDays((-1)*i);
          posts.add(feedPost);
          
    }
    
    insert posts;
    
    Topic topicOne = new Topic(Name = 'TopicOne');
    insert topicOne;
    
    TopicAssignment topicAssign = new TopicAssignment(TopicId = topicOne.Id, EntityId = posts[0].Id);
    insert topicAssign;
    
   // System.assertEquals(1, [Select Id from TopicAssignment where EntityId = :posts[0].Id and Topic.Name = 'TopicOne'].size());
    
    // Add a Like, A Comment and a link to each!
    List<uw_Links__c> wallLinks = new List<uw_Links__c>();
    List<FeedComment> feedComments = new List<FeedComment>();
    List<FeedLike> feedLikes = new List<FeedLike>();
    for (FeedItem feedItem:  posts)
    {
      uw_Links__c link = new uw_Links__c();
      link.Related_Feed_Item__c = feedItem.Id;
      link.Related_Collaboration_Group__c = testCollabGroupId;
      wallLinks.add(link);
      
      FeedLike fLike = new FeedLike();
      fLike.FeedItemId = feedItem.Id;
      feedLikes.add(fLike);
      
      FeedComment feedComment = new FeedComment();
      feedComment.CommentBody = 'Test';
      feedComment.FeedItemId = feedItem.Id;
      feedComments.add(feedComment);
      
    }
    
    insert wallLinks;
    insert feedLikes;
    insert feedComments;
    
    
    
    uw_PinnovateController controller = new uw_PinnovateController();
    controller.topicName = 'TopicOne';
    
    controller.getPinnotaveDataOrderedFirst();
   // System.assertEquals(1, controller.getPinnotaveDataOrderedFirst().size()); 
    
    delete feedComments;
    delete posts;
    
    controller.topicName = 'All';
    controller.getItems();
    controller.getCollaborationGroup();
    controller.getCollaborationGroupFeed();
    getPinnotaveTestRows();
    controller.getPinnotaveRows();
    controller.getFeedItemCreatedByUserMap();
    controller.getPinnovateTableData();
   // controller.getPinnotaveDataOrderedFirst();
    
    controller.backToGroup();
    
    test.stoptest(); 
  }
  
  public static TestMethod void testWrappers()
  {
    test.starttest();
    
    uw_PinnovateController.PinnovateRow pRow = new uw_PinnovateController.PinnovateRow();
    
    uw_PinnovateController.PinnovateTableData ptd = new uw_PinnovateController.PinnovateTableData();
    
    Datetime dt = Datetime.now();
    ptd.createdDate = dt;
    for (Integer i = 0; i < 2; i++)
    {
      ptd.getCreatedDateString();
      ptd.createdDate = ptd.createdDate.addDays(-1);
    }
    
    /*Author: Mindtree
    Date: 27/06/2014
    Description:Code to cover getLikeString() method of uw_PinnovateController.*/ 
        
    ptd.hasLikedPost=true;
    ptd.likecount=1;
    ptd.getLikeString();
    
    ptd.likecount=2;
    ptd.getLikeString();
   
    ptd.likecount=3;
    ptd.getLikeString();
    
    ptd.likecount=4;
    ptd.getLikeString();
    
    ptd.hasLikedPost=false;
    ptd.likedUserName='krathika';
    ptd.likeCount=1;
    ptd.getLikeString();
    
    ptd.likeCount=2;
    ptd.getLikeString();
    
    ptd.likeCount=3;
    ptd.getLikeString();
   /*--------- End ---------- */
    
    test.stoptest();
  }
  
   public static TestMethod void testcommentpopup()
   {
      test.starttest();
      
      uw_PinnovateController controller= new uw_PinnovateController();
      controller.refCommentDetails();
      controller.closePopupLik();
      controller.closePopupCom();
      
      test.stoptest();
   }

   //WrapperClassTest for comments and Like Popup
   public static TestMethod void testWrappersforCommentsandLikepopup(){
      test.starttest();
        List<user> u=[select id,smallphotourl from user limit 10];
        List<uw_PinnovateController.ClsCommentDet> ccd=new List<uw_PinnovateController.ClsCommentDet>();
      
      
      
          for(user usr:u)
          {
              uw_PinnovateController.ClsCommentDet c=new uw_PinnovateController.ClsCommentDet();
              c.strFeedCmmt='huio';
              c.objPhotoURL=usr;
              c.strUserName='prashanth@mindtree.com';
              c.createdidby=userinfo.getuserid();
              ccd.add(c);
          }
        
       test.stoptest();
      }
      
      public static TestMethod void testforinsrtComtLikeAndUnlikeAndPreview(){
        test.starttest();
          CollaborationGroup newGroup = new CollaborationGroup(Name='A public chatter group');
          newGroup.CollaborationType = 'public';
          insert newGroup;
          
          Apexpages.currentPage().getParameters().put('id',newGroup.id);
          String strCollaborationGroupID = ApexPages.currentPage().getParameters().get('id');
          
          Feeditem objFi=new Feeditem(Body='Hii',
          CreatedById=Userinfo.getUserId(),
          ParentId=newGroup.id,Type='TextPost');
          insert objFi;
          
          Feedcomment objFicom=new Feedcomment(commentbody='hi',
          feeditemid=objFi.id);
          insert objFicom;
          
          ApexPages.currentPage().getParameters().put('feeditemIdForLike',objFi.Id);
          string strFeedItemID = ApexPages.currentPage().getParameters().get('feeditemIdForLike');
            
          ApexPages.currentPage().getParameters().put('FCId',objFicom.Id);
          string strFeedCommentID = ApexPages.currentPage().getParameters().get('FCId');
           
          ApexPages.currentPage().getParameters().put('unlikeId',objFi.Id);
          string strFeedItemIDForUnlike = ApexPages.currentPage().getParameters().get('unlikeId');
          
          Feeditem objFiForLike=new Feeditem(Body='Hello',
          CreatedById=Userinfo.getUserId(),
          ParentId=newGroup.id,Type='TextPost');
          insert objFiForLike;
          
          ApexPages.currentPage().getParameters().put('likeId',objFiForLike.Id);
          string strFeedItemIDForLike = ApexPages.currentPage().getParameters().get('likeId');
          
          feedlike fdLik=new feedlike ();
          fdLik.feeditemid=objFi.id;
          insert fdLik;
          
          
          uw_PinnovateController controller= new uw_PinnovateController();
          controller.Comm='Hello';
          controller.CommId=strFeedItemID;
          //controller.getCollaborationGroup().Id=strCollaborationGroupID;
          controller.insrtComt();
          controller.closePopupPreview();
          controller.showPopupPreview();
          controller.ClickLike();
          controller.ClickUnLike();
          controller.refLikeDetails();
        test.stoptest();
      }
}