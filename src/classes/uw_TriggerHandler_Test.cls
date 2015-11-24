//Copied all Test Methods from uw_TriggerHandler Class to this dedicated Test Class

@IsTest(SeeAllData=true)
public Class uw_TriggerHandler_Test{
    
    private static final String GROUP_NAME_POSTFIX = ' External View';
    private static final String CANNOT_DELETE_NOT_OWNER = 'Cannot delete Post because it contains a file which has been labelled. Please contact the Toolkit Owner.';
    private static final String CANNOT_DELETE_CHATTER_FILE = 'This Chatter File has been labelled in the Studio {0}. Please contact the Toolkit Owner: {1} who can delete the file. ';
     public static TestMethod void testBetInsertUpdateAndNewStudioCreation_Single()
    {
        Test.startTest();
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();
        insert brand;
        
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        
        //IDC- 14 Jun - new Inoplan parameter added     
        uw_BET__c bet = uw_UnitTestDataFactory.createBet(brand,'TB'+System.now(),inoPlanProject);        
        insert bet;
        
        // Assert we created a group - and the group is linked to the bet..
        uw_BET__c testBet = [Select Id, Name,Studio_Chatter_Group__c from uw_BET__c where Id = :bet.Id];
        
        System.assert(!uw_HelperMethods.valueIsNull(testBet.Studio_Chatter_Group__c),'No Studio Created');
        
        List<CollaborationGroup> betStudioList = [Select Id, Name from CollaborationGroup where Id = :testBet.Studio_Chatter_Group__c];
        
        System.assert(betStudioList.size() == 1, 'Found '+betStudioList.size()+' related chatter groups - should be only 1');
        // How do we assert only one group was created? 
        // Group Names Must be unique!
        
        // Assert the Group Name and Bet Name are the same but the Group has a postfix
        // add the postfix onto the bet and then they should be the same (geddit?)
        System.assertEquals(betStudioList[0].Name, bet.Name + GROUP_NAME_POSTFIX,'Group and BET names not equal after insert');
        
        // Now update the Bet to see the group name changes
        bet.Name = bet.Name + 'T_UPDATE';
        update bet; 
        
        betStudioList = [Select Id, Name from CollaborationGroup where Id = :testBet.Studio_Chatter_Group__c];
        // TODO - has this logic stopped working? Commented out for now
        System.assertEquals(betStudioList[0].Name, bet.Name,'Group and BET names not equal after Bet name Update');
        Test.stopTest(); 
    }

    public static TestMethod void testBetNameUpdatesDuplicateGroup()
    {
        Test.startTest();
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();
        insert brand;

        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        
        //IDC- 14 Jun - new Inoplan parameter added     
        uw_BET__c bet1 = uw_UnitTestDataFactory.createBet(brand,'TB'+System.now(),inoPlanProject);
        insert bet1;
        
        /* TODO - Investigate why this test does not work
        uw_BET__c bet2 = uw_UnitTestDataFactory.createBet(brand, bet1.Name+'XX');
        insert bet2;
        
        bet2.Name = bet1.Name;
        
        Database.Saveresult res =  Database.update(bet2,false);
        
        // TODO - has this logic stopped working? Commented out for now
        System.assert(!res.isSuccess(),'Bets should not be allowed to have the same name! - '+res.isSuccess());
        */
        Test.stopTest(); 
    }
    
    public static TestMethod void testBetInsertAndNewStudioCreation_Bulk()
    {
        Test.startTest();
        // Have to keep this under 100 as 100 is the limit 
        // of groups we can create or have this user as a member of - 
        // todo - add different group owners?
        Integer BULK_TEST_SIZE = 5;
        // Create 200 Brands
        List<uw_Brand__c> brands = new List<uw_Brand__c>();
        
        for (Integer i = 0; i < BULK_TEST_SIZE; i++)
        {
            brands.add(uw_UnitTestDataFactory.createParentBrand());
        }
        
        insert brands;
        //IDC- 14 June - New code for inoplan object.
        List<uw_Inoplan_Project__c> inoPlanProject = new List<uw_Inoplan_Project__c>();
        for (Integer i = 0; i < BULK_TEST_SIZE; i++)
        {
            inoPlanProject.add(uw_UnitTestDataFactory.createInoplan());
        }        
        insert inoPlanProject;
        
        List<uw_BET__c> bets = new List<uw_BET__c>();
        
        for (Integer i = 0; i < BULK_TEST_SIZE; i++)
        {
            // Better Make these names unique!
            bets.add(uw_UnitTestDataFactory.createBet(brands[i],'TB'+i+System.now(),inoPlanProject[i]));  
        }
        
        insert bets;
        
        Map<Id,uw_BET__c> testBets = new Map<Id,uw_BET__c>([Select Id, Name,Studio_Chatter_Group__c from uw_BET__c where Id in :bets]);
        
        Set<Id> collabGroupIds = new Set<Id>();
        Map<Id,Id> collabGroup2BetIdMap = new Map<Id,Id>();
        for (uw_BET__c bet:testBets.values())
        {
            collabGroupIds.add(bet.Studio_Chatter_Group__c);
            collabGroup2BetIdMap.put(bet.Studio_Chatter_Group__c,bet.Id);
        }
        
        System.assert(collabGroupIds.size() == BULK_TEST_SIZE);
        
        List<CollaborationGroup> collabGroups = [Select Id, Name from CollaborationGroup where Id = :collabGroupIds];
        
        for (CollaborationGroup cGroup: collabGroups)
        {
            // Ensure the Group Name contains the Bet Name - 
            // will possibly break if the naming convention changes
            // going to use contains to be safe
            uw_Bet__c cBet = testBets.get(collabGroup2BetIdMap.get(cGroup.Id));
            System.assert(cGroup.Name.contains(cBet.Name), 'Expected Group Name '+ cGroup.Name +' to contain the bet name : '+cBet.Name);
        }
        Test.stopTest(); 
    }
  
   
      public static  testmethod void testPinUnPinLaunch()
      {
        Test.startTest();
        //  CollaborationGroup cGroup = uw_UnitTestDataFactory.getTestChatterGroup();
            CollaborationGroup cGroup=new CollaborationGroup(name='mygroup',CollaborationType='public');
            insert cGroup;
        // Create a feed Item on the group with a youtube vid
        // add a pin comment - see a uw_link is created
        // delete the pin comment - see the uw_link is deleted
        
        // when feeditem type is linkpost
        List<FeedItem> feedItems_link = new List<FeedItem>();
        for (Integer i = 0; i < 5; i++)
        {
            FeedItem feedItem = new FeedItem();
            feedItem.parentId = cGroup.Id;
            
            feedItem.Type = 'LinkPost';
            feedItem.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
            feedItem.Title   = 'Test Title';
            feedItem.Body    = 'Test Body';
            feedItem.CreatedById = Userinfo.getUserId();
            
            feedItem.CreatedDate = System.now().addDays((-1)*i);
            feedItems_link.add(feedItem);
        }
        
        insert feedItems_link;
        
        List<FeedComment> pinFeedComments = new List<FeedComment>();
        
        for (FeedItem fItem: feedItems_link)
        {
            FeedComment feedComment = new FeedComment();
            feedComment.CommentBody = '#pin';
            feedComment.FeedItemId = fItem.Id;
            pinFeedComments.add(feedComment);   
        }
        
        insert pinFeedComments;
        
        //when feeditem typr is contentpost
        List<FeedItem> feedItems_content = new List<FeedItem>();
        Blob body=[Select Name, ContentType, Body From StaticResource where name='Preview_Close'].body;
        for (Integer i = 0; i < 5; i++)
        {
           
            FeedItem feedItem = new FeedItem();
            feedItem.parentId = cGroup.Id;
            feedItem.contentdata=body;
            feedItem.Type = 'ContentPost';
            feedItem.contentfilename='Preview_Close.png';      
            feedItem.CreatedById = Userinfo.getUserId();               
            feedItems_content.add(feedItem);
        }
        
        insert feedItems_content;
        
        List<FeedComment> pinFeedComments_content = new List<FeedComment>();
        
        for (FeedItem fItem: feedItems_content)
        {
            FeedComment feedComment = new FeedComment();
            feedComment.CommentBody = '#pin';
            feedComment.FeedItemId = fItem.Id;
            pinFeedComments_content.add(feedComment);   
        }
        
        insert pinFeedComments_content;
        
        
        // Test that uw_links were created
        FeedItem launchFeedItem = new FeedItem();
        launchFeedItem.parentId = cGroup.Id;
        launchFeedItem.Type = 'TextPost';
        launchFeedItem.Body    = Label.LAUNCH_PINNOVATE_CMD;
        
        insert launchFeedItem;
 
        delete pinFeedComments[1];
        delete pinFeedComments_content[1];
        Test.stopTest(); 
        // Try to Launch the bet as someone else!        
    }
 
     public static testmethod  void testTopicPinUnPinLaunch()
    {
        Test.startTest();
       // CollaborationGroup cGroup = uw_UnitTestDataFactory.getTestChatterGroup();
         CollaborationGroup cGroup=new CollaborationGroup(name='mygroup1',CollaborationType='private');
         insert cGroup;
        // Create a feed Item on the group with a youtube vid
        // add a pin comment - see a uw_link is created
        // delete the pin comment - see the uw_link is deleted
        
        List<FeedItem> feedItems = new List<FeedItem>();
        for (Integer i = 0; i < 5; i++)
        {
            FeedItem feedItem = new FeedItem();
            feedItem.parentId = cGroup.Id;
            
            feedItem.Type = 'LinkPost';
            feedItem.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
            feedItem.Title   = 'Test Title 1';
            feedItem.Body    = 'Test Body 1';
            feedItem.CreatedById = Userinfo.getUserId();
            
            feedItem.CreatedDate = System.now().addDays((-1)*i);
            feedItems.add(feedItem);
        }
        
        insert feedItems;
      
        List<TopicAssignment> pinTopicAssignment = new List<TopicAssignment>();
        
        //create a Pin topic if doesn't exist
        List<topic> topics =[select Id from topic where Name='Pin'];
        if (topics.isEmpty()) {
            Topic t = new Topic();
            t.name = 'Pin';
            insert t;
            topics.add(t);
        }
        
        
        
        for (FeedItem fItem: feedItems)
        {
            TopicAssignment topic_Asgn= new TopicAssignment();
            topic_Asgn.TopicId=topics[0].Id;
            topic_Asgn.EntityId= fItem.Id;
            pinTopicAssignment.add(topic_Asgn);   
        }
        
        insert pinTopicAssignment ;
        
        List<FeedItem> feedItems_content = new List<FeedItem>();
        Blob body=[Select Name, ContentType, Body From StaticResource where name='Preview_Close'].body;
        for (Integer i = 0; i < 5; i++)
        {
           
            FeedItem feedItem = new FeedItem();
            feedItem.parentId = cGroup.Id;
            feedItem.contentdata=body;
            feedItem.Type ='ContentPost';
            feedItem.contentfilename='Preview_Close.png';      
            feedItem.CreatedById = Userinfo.getUserId();               
            feedItems_content.add(feedItem);
        }
        
        insert feedItems_content;
        
        List<TopicAssignment> pinTopicAssignment_content = new List<TopicAssignment>();
        List<topic> topics2 =[select Id from topic where Name='Pin'];
        
        for (FeedItem fItem: feedItems_content)
        {
            TopicAssignment topic_Asgn= new TopicAssignment();
            topic_Asgn.TopicId=topics2[0].Id;
            topic_Asgn.EntityId= fItem.Id;
            pinTopicAssignment_content.add(topic_Asgn);   
        }
        
        insert pinTopicAssignment_content;        
        
        //create a Fab topic
        List<topic> topics3 =[select Id from topic where Name='Fab'];
        if (topics3.isEmpty()) {
            Topic t2 = new Topic();
            t2.name = 'Fab';
            insert t2;
            topics3.add(t2);
        }
        
         
        List<TopicAssignment> pinTopicAssignment_null = new List<TopicAssignment>();

        for (FeedItem fItem: feedItems_content)
        {
            TopicAssignment topic_Asgn= new TopicAssignment();
            topic_Asgn.TopicId=topics3[0].Id;
            topic_Asgn.EntityId= fItem.Id;
            pinTopicAssignment_null.add(topic_Asgn);   
        }
        
        insert pinTopicAssignment_null ;
        
        // Test that uw_links were created
        FeedItem launchFeedItem = new FeedItem();
        launchFeedItem.parentId = cGroup.Id;
        launchFeedItem.Type = 'TextPost';
        launchFeedItem.Body    = Label.LAUNCH_PINNOVATE_CMD;
        uw_TriggerHandler handler=new uw_TriggerHandler();
        
        
        insert launchFeedItem;
 
        delete pinTopicAssignment[1]; 
        delete pinTopicAssignment_content[1];
     Test.stopTest(); 
        // Try to Launch the bet as someone else!        
    } 
    
    public static TestMethod void testUserInsert()
    {
        Test.startTest();
        // This creates a user and runt the trigger
        User u = uw_UnitTestDataFactory.initInternalUser('ttrigxx', 'ttest@unilever.com', 'ttest@unilever.com', 'untest.sb@unichatter.com.sbx');
        
        // Update them ?
        u.IsActive = false;
        update u;
        u.IsActive = true;
        
        update u;
        Test.stopTest(); 
    }
    
    private static testmethod void test_misc() {
        Test.startTest();
        try{
        // system.assert(uw_TriggerHandler.getUWLinkPinnovateRecordType() != null);
        }
        
catch(exception e){}
Test.stopTest(); 
    }
    
    private static final String LOWER_FEDERATION = 'solar federation';
    private static final String UPPER_FEDERATION = 'SOLAR FEDERATION';
    private static final String MIXED_FEDERATION = 'SoLaR FeDERatIon';
    private static testmethod void testFederationId() {
        Test.startTest();
        User uNoFId = new User(username='test@test.com');
        User uFIdLower = new User(username='test@test.com',FederationIdentifier=LOWER_FEDERATION);
        User uFIdUpper = new User(username='test@test.com',FederationIdentifier=UPPER_FEDERATION);
        User uFIdMixed = new User(username='test@test.com',FederationIdentifier=MIXED_FEDERATION);
        List<User> ul = new List<User>();
        ul.add(uNoFId);
        ul.add(uFIdLower);
        ul.add(uFIdUpper);
        ul.add(uFIdMixed);
        uw_TriggerHandler h = new uw_TriggerHandler();
        h.handleUserBeforeInsert(ul);
        
        system.assertEquals(null, uNoFId.FederationIdentifier);
        system.assertEquals(LOWER_FEDERATION, uFIdLower.FederationIdentifier);
        system.assertEquals(LOWER_FEDERATION, uFIdUpper.FederationIdentifier);
        system.assertEquals(LOWER_FEDERATION, uFIdMixed.FederationIdentifier);
        
        uFIdLower.FederationIdentifier = LOWER_FEDERATION;
        uFIdUpper.FederationIdentifier = UPPER_FEDERATION;
        uFIdMixed.FederationIdentifier = MIXED_FEDERATION;
        h.handleUserBeforeUpdate(ul);
 
        system.assertEquals(null, uNoFId.FederationIdentifier);
        system.assertEquals(LOWER_FEDERATION, uFIdLower.FederationIdentifier);
        system.assertEquals(LOWER_FEDERATION, uFIdUpper.FederationIdentifier);
        system.assertEquals(LOWER_FEDERATION, uFIdMixed.FederationIdentifier);
        Test.stopTest(); 
        // Want to update the users to active and inactive...        
    }
    
    private static testmethod void testMisc() {
        Test.startTest();
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        //IDC- 14 Jun - new Inoplan parameter added    
        uw_BET__c bet = uw_UnitTestDataFactory.initBET('betName',true,inoPlanProject);
        ContentVersion cv = uw_UnitTestDataFactory.initContentVersion();
        uw_Asset__c asset = uw_UnitTestDataFactory.initAsset('n', cv, bet);
        uw_TriggerHandler th = new uw_TriggerHandler();
        FeedItem fi = new FeedItem(Type='LinkType', ParentId=bet.Id);

        th.canDemoteAsset(bet.Id, asset, fi);
        Test.stopTest(); 
    }   
    
    private static testmethod void testHandleAssets(){
     Test.startTest();
     List<uw_Asset__c> assetList = new List<uw_Asset__c>();    
   //IDC- 14 Jun - Creating test data for Inoplan object
     uw_Inoplan_Project__c inoPlanProject1 = uw_UnitTestDataFactory.createInoplan();
     insert inoPlanProject1;
    //IDC- 14 Jun - new Inoplan parameter added    
     uw_BET__c bet1 = uw_UnitTestDataFactory.initBET('betName1',true,inoPlanProject1);
     bet1.Sharing__c = 'Public';
     FeedItem fi1 = new FeedItem();
     fi1.parentId = bet1.Id;
     fi1.Type = 'LinkPost';
     fi1.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
     ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
     uw_Asset__c asset1 =uw_UnitTestDataFactory.initAsset('test1',cv1,bet1);
     asset1.betFeedID__c = bet1.Id;
     assetList.add(asset1);
     
     uw_Inoplan_Project__c projectNameUnique = uw_UnitTestDataFactory.createInoplan();
     insert projectNameUnique;
    //IDC- 14 Jun - new Inoplan parameter added  
     uw_BET__c bet2 = uw_UnitTestDataFactory.initBET('betName2', true,projectNameUnique);
     bet2.Sharing__c = 'Private';
     ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();
     uw_Asset__c asset2 =uw_UnitTestDataFactory.initAsset('test2',cv2,bet2);
     asset2.betFeedID__c = bet2.Id;
     assetList.add(asset2);
    
     List<uw_BET__c> betList = [SELECT Id,Sharing__c FROM uw_BET__c WHERE Id=:bet1.Id AND Sharing__c='Public'];
     System.debug('&&&&&&&&&'+betList);
     
     uw_TriggerHandler handlerObj = new uw_TriggerHandler();
     handlerObj.handleAssets(assetList,true);
     handlerObj.handleAssetAfterDelete(assetList);
     Test.stopTest(); 
     }
  private static testmethod void testDelAsset(){
    Test.startTest();
   //IDC- 14 Jun - Creating test data for Inoplan object
     uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
     insert inoPlanProject;
    //IDC- 14 Jun - new Inoplan parameter added    
     uw_BET__c bet1 = uw_UnitTestDataFactory.initBET('betName1',true,inoPlanProject);
     ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
     uw_BET_Team_Member__c teamMem = new uw_BET_Team_Member__c(Access_Level__c='Full Brand Experience (Toolkit & Studio)',Role__c='Manager',BET__c = bet1.id);
     uw_Asset__c asset1 =uw_UnitTestDataFactory.initAsset('test1',cv1,bet1);
     
     uw_TriggerHandler handlerObj = new uw_TriggerHandler();
     handlerObj.canDeleteAsset(asset1);
     
     }
     private static testmethod void testDeleteAssets(){
     Test.startTest();
   //IDC- 14 Jun - Creating test data for Inoplan object
     uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
     insert inoPlanProject;
    //IDC- 14 Jun - new Inoplan parameter added    
     uw_BET__c bet2 = uw_UnitTestDataFactory.initBET('betName2',true,inoPlanProject);
     bet2.Sharing__c = 'Public';
     ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();
     uw_Asset__c asset2 =uw_UnitTestDataFactory.initAsset('test2',cv2,bet2);
     
     
     Map<Id,Sobject> sMap = new Map<Id,Sobject>();
     sMap.put(asset2.id,asset2);
      uw_TriggerHandler handlerObj = new uw_TriggerHandler();
     handlerObj.canDeleteAsset(asset2,sMap);
     Test.stopTest(); 
     }
     
     private static testmethod void testFeedInsert(){
        Test.startTest();
    Map<Id,FeedItem> feedMap = new Map<Id,FeedItem>();
     Id cGroupId = uw_UnitTestDataFactory.getTestChatterGroupId();
     List<FeedItem> feedList = new List<FeedItem>();
     //IDC- 14 Jun - Creating test data for Inoplan object
     uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
     insert inoPlanProject;
    //IDC- 14 Jun - new Inoplan parameter added 
     uw_BET__c bet2 = uw_UnitTestDataFactory.initBET('betName2',true,inoPlanProject);
     bet2.Sharing__c = 'Public';
     ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();
     uw_Asset__c asset2 =uw_UnitTestDataFactory.initAsset('test2',cv2,bet2);
      FeedItem fi1 = new FeedItem();
      fi1.parentId = bet2.id;
      fi1.Type = 'LinkPost';
      fi1.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
      fi1.RelatedrecordId = asset2.id;
      FeedComment fcomment1 = new FeedComment();
      fcomment1.FeedItemId = fi1.id;
      fcomment1.CommentBody = 'This is a profound comment.';     
      
      feedList.add(fi1);
      feedMap.put(fi1.id,fi1);
      
      FeedItem fi2 = new FeedItem();
      fi2.parentId = bet2.id;
      fi2.Type = 'TextPost';
      fi2.Body = 'The mice will see you now';
      feedList.add(fi2);
      feedMap.put(fi2.id,fi2);
      
              
     FeedItem fi3 = new FeedItem();
      fi3.parentId = bet2.id;
      fi3.Type = 'ContentPost';
      fi3.ContentFileName = 'sample.png';
      fi3.RelatedrecordId = cv2.id; 
      
      FeedComment fcomment = new FeedComment();
      fcomment.FeedItemId = fi3.id;
      fcomment.CommentBody = 'This is a profound comment.';
      fcomment.CommentType = 'ContentComment';
      fcomment.RelatedRecordId = cv2.id; 
     
      feedList.add(fi3);
      feedMap.put(fi3.id,fi3);
      uw_TriggerHandler handlerObj = new uw_TriggerHandler();
      handlerObj.handleFeedItemBeforeDelete(feedList,feedMap);
     Test.stopTest(); 
   }
   private static testmethod void testHandleFeedBeforeDel(){
    Test.startTest();
   //IDC- 14 Jun - Creating test data for Inoplan object
     uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
     insert inoPlanProject;
    //IDC- 14 Jun - new Inoplan parameter added    
     uw_BET__c bet1 = uw_UnitTestDataFactory.initBET('betName1', true,inoPlanProject);
     ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
     uw_Asset__c asset1 =uw_UnitTestDataFactory.initAsset('test1',cv1,bet1);
     
      Id cGroupId = uw_UnitTestDataFactory.getTestChatterGroupId();
      FeedItem fi3 = new FeedItem();
      fi3.parentId = bet1.id;
      fi3.Type = 'ContentPost';
      fi3.ContentFileName = 'sample.png';
      uw_BET_Team_Member__c teamMem = new uw_BET_Team_Member__c(Access_Level__c='Full Brand Experience (Toolkit & Studio)',Role__c='Manager',BET__c = bet1.id);
      FeedComment fcomment = new FeedComment();
      fcomment.FeedItemId = fi3.id;
      fcomment.CommentType = 'ContentComment';
      fcomment.RelatedRecordId = cv1.id;
      fcomment.CommentBody = 'This is a profound comment.';
      List<FeedComment> commentList = new  List<FeedComment>();
      Map<Id,FeedComment> commentMap = new Map<Id,FeedComment>();
      commentList.add(fcomment);
      commentMap.put(fcomment.id,fcomment);
      uw_TriggerHandler handlerObj = new uw_TriggerHandler();
      handlerObj.handleFeedCommentWithContentBeforeDelete(commentList,commentMap);
   Test.stopTest(); 
    }
    
    public static TestMethod void testBetSharing()
    {
        Test.startTest();
        uw_BET__c bet1;
        uw_BET__c bet2;
       //IDC- 14 Jun - Creating test data for Inoplan object
         uw_Inoplan_Project__c inoPlanProject1 = uw_UnitTestDataFactory.createInoplan();
         insert inoPlanProject1;
        //IDC- 14 Jun - new Inoplan parameter added 
         bet1 = uw_UnitTestDataFactory.initBET('betName1', true,inoPlanProject1);
         bet1.Sharing__c = 'Public';
       ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
       uw_Asset__c asset1 =uw_UnitTestDataFactory.initAsset('test1',cv1,bet1);
       
       //IDC- 14 Jun - Creating test data for Inoplan object
         uw_Inoplan_Project__c inoPlanProject2 = uw_UnitTestDataFactory.createInoplan();
         insert inoPlanProject2;
        //IDC- 14 Jun - new Inoplan parameter added        
        bet2 = uw_UnitTestDataFactory.initBET('betName2', true,inoPlanProject2);
       bet2.Sharing__c = 'Private';
       ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();
       uw_Asset__c asset2 =uw_UnitTestDataFactory.initAsset('test2',cv2,bet2);
       
       List<id> changedBet = new  List<id>();
       Map<Id,uw_BET__c> oldBet = new Map<Id,uw_BET__c>();
       Map<Id,uw_BET__c> newBet = new Map<Id,uw_BET__c>();
       changedBet.add(bet1.id);
       changedBet.add(bet2.id);
       oldBet.put(bet1.id,bet1);
       oldBet.put(bet2.id,bet2);

       bet1.Sharing__c = 'Private';
       bet2.Sharing__c = 'Public';
       
       update bet1;
       update bet2;
       
       newBet.put(bet1.id,bet1);
       newBet.put(bet2.id,bet1);
       changedBet.add(bet1.id);
       changedBet.add(bet2.id);
       
       uw_TriggerHandler handlerObj = new uw_TriggerHandler();
       handlerObj.handleBetsWithChangedSharing(changedBet,newBet,oldBet);
        Test.stopTest(); 
     }
     
   private static testmethod void testHandleFeedCommentBeforeDel(){
    Test.startTest();
     uw_Inoplan_Project__c projectName_3 = uw_UnitTestDataFactory.createInoplan();
     insert projectName_3;
     //IDC- 14 Jun - new Inoplan parameter added  
     uw_BET__c bet1 = uw_UnitTestDataFactory.initBET('betName1', true,projectName_3);
     ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
     uw_Asset__c asset1 =uw_UnitTestDataFactory.initAsset('test1',cv1,bet1);
     
      Id cGroupId = uw_UnitTestDataFactory.getTestChatterGroupId();
      FeedItem fi3 = new FeedItem();
      fi3.parentId = bet1.id;
      fi3.Type = 'ContentPost';
      fi3.ContentFileName = 'sample.png';
      uw_BET_Team_Member__c teamMem = new uw_BET_Team_Member__c(Access_Level__c='Full Brand Experience (Toolkit & Studio)',Role__c='Manager',BET__c = bet1.id);
      FeedComment fcomment = new FeedComment();
      fcomment.FeedItemId = fi3.id;
      fcomment.CommentType = 'ContentComment';
      fcomment.RelatedRecordId = cv1.id;
      fcomment.CommentBody = 'This is a profound comment.';
      Map<Id,FeedComment> commentMap = new Map<Id,FeedComment>();
      commentMap.put(fcomment.id,fcomment);
      uw_TriggerHandler handlerObj = new uw_TriggerHandler();
      handlerObj.handleFeedCommentBeforeDelete(commentMap);
      handlerObj.handleFeedCommentAfterInsert(commentMap);
      Test.stopTest(); 
     }
    public static testmethod void testhandleFeedItemBeforeDelete()
    {
        Test.startTest();
      uw_Inoplan_Project__c projectName_Five = uw_UnitTestDataFactory.createInoplan();
         insert projectName_Five ;
        //IDC- 14 Jun - new Inoplan parameter added  
      uw_BET__c bet2 = uw_UnitTestDataFactory.initBET('betName1',true,projectName_Five);
      List<FeedItem> fList= new List<FeedItem>();
      Map<Id,FeedItem> fListMap= new Map<Id,FeedItem>();
      FeedItem fi4 = new FeedItem();
      fi4.parentId=bet2.id;
      fi4.Type = 'LinkPost';
      fi4.LinkUrl = 'http://www.youtube.com/watch?v=cA5ifsMo194&feature=g-hist';
      fi4.Title   = 'Test Title';
      fi4.Body    = 'Test Body';
      fList.add(fi4);
      fListMap.put(fi4.id,fi4);
      uw_TriggerHandler handlerObj1 = new uw_TriggerHandler();
      handlerObj1.handleFeedItemBeforeDelete(fList,fListMap);
    Test.stopTest(); 
    }     
  private static testmethod void testUserAfterUpadte(){
    Test.startTest();
    
    User uNoFId = new User(username='test@test.com',IsActive=false);
        User uFIdLower = new User(username='test@test.com',FederationIdentifier='solar federation',IsActive=true);
        User uFIdUpper = new User(username='test@test.com',FederationIdentifier='SOLAR FEDERATION',IsActive=false);
        User uFIdMixed = new User(username='test@test.com',FederationIdentifier='SoLaR FeDERatIon',IsActive=true);
        Map<id,User> activeUser = new Map<id,User>();
        Map<id,User> inActiveUser = new Map<id,User>();
        activeUser.put(uFIdLower.id,uFIdLower);
        activeUser.put(uFIdMixed.id,uFIdMixed);
        activeUser.put(uFIdUpper.id,uFIdUpper);
        
        inActiveUser.put(uNoFId.id,uNoFId);
        inActiveUser.put(uFIdUpper.id,uFIdUpper);
        uw_TriggerHandler handlerObj = new uw_TriggerHandler();
        handlerObj.handleUserAfterUpdates(activeUser,inActiveUser);
        Test.stopTest();  
    }
    
     /* Author: mindtree
        Descritption : code to cover handleUserAfterInserts of uw_TriggerHandler */
     public static testmethod void testUserAfterInsert()
     {
     
      Test.startTest();
      
        string cityName;
        string funcName; 
        
        profile p=[select id from profile where name=:'System administrator'];      
        List<CORE_CHATTER_USER_ADMINISTRATION__c> custSetValues= CORE_CHATTER_USER_ADMINISTRATION__c.getall().values();
        if(custSetValues != null) {
        for(CORE_CHATTER_USER_ADMINISTRATION__c temp: custSetValues){
            if(temp.Chatter_Group_Id__c !=null) { 
               funcName= temp.Name;
               break; }
        }
        for(CORE_CHATTER_USER_ADMINISTRATION__c temp: custSetValues){
            if(temp.Chatter_Group_Id__c !=null && temp.Name !=funcName) {
               cityName= temp.Name;
               break; }
            else
               cityName=funcName;      
        }
         
        User testUser1 = new User(username='Core_Chatter_user_admin_test1@admintest.com',IsActive=true,City=cityName,Function__c=funcName, Alias='user1',timezonesidkey='America/Los_Angeles',ProfileId=p.id,
                                 Email='ore_Chatter_user_admin_test1@admintest.com',FederationIdentifier='feed1',FirstName='Core_Chatter_user1', LastName='Core_Chatter_user2',emailencodingkey='UTF-8',
                                 languagelocalekey='en_US',localesidkey='en_US'); 
        insert  testUser1;
        
        User testUser2 = new User(username='ore_Chatter_user_admin_test2@admintest.com',IsActive=true, Alias='user2',timezonesidkey='America/Los_Angeles',ProfileId=p.id,
                                 Email='ore_Chatter_user_admin_test2@admintest.com',FederationIdentifier='feed2',FirstName='Core_Chatter_user3', LastName='Core_Chatter_user4',emailencodingkey='UTF-8',
                                 languagelocalekey='en_US',localesidkey='en_US'); 
        insert  testUser2;
        
        User testUser3 = new User(username='ore_Chatter_user_admin_test3@admintest.com',IsActive=true,City=cityName, Alias='user3',timezonesidkey='America/Los_Angeles',ProfileId=p.id,
                                 Email='ore_Chatter_user_admin_test3@admintest.com',FederationIdentifier='feed3',FirstName='Core_Chatter_user5', LastName='Core_Chatter_user6',emailencodingkey='UTF-8',
                                 languagelocalekey='en_US',localesidkey='en_US'); 
        insert  testUser3;
        }
      Test.stopTest();
     }
    
    //The following method is for pinnovate
  /*  private static testmethod void testForPinnovate(){
        
         CollaborationGroup cGroup=new CollaborationGroup(name='mygroup',CollaborationType='public');
         insert cGroup;
         
        // Create a feed Item on the group with a youtube vid
        // add a pin comment - see a uw_link is created
        // delete the pin comment - see the uw_link is deleted
      //  List<FeedItem> feeditm= [select parentId,Type,relatedrecordid,CreatedById,CreatedDate,ContentFileName,contentdata  from feeditem where type='contentpost'];
        List<FeedItem> feedItems = new List<FeedItem>();
        Blob body=[Select Name, ContentType, Body From StaticResource where name='Preview_Close'].body;
        for (Integer i = 0; i < 5; i++)
        {
           
            FeedItem feedItem = new FeedItem();
           feedItem.parentId = cGroup.Id;
            feedItem.contentdata=body;
            feedItem.Type = 'ContentPost';
            feedItem.contentfilename='Preview_Close.png';      
            feedItem.CreatedById = Userinfo.getUserId();               
            feedItems.add(feedItem);
        }
        
        insert feedItems ;
        
        List<FeedComment> pinFeedComments = new List<FeedComment>();
        
        for (FeedItem fItem: feedItems )
        {
            FeedComment feedComment = new FeedComment();
            feedComment.CommentBody = '#pin';
            feedComment.FeedItemId = fItem.Id;
            pinFeedComments.add(feedComment);   
        }
        
        insert pinFeedComments;
        
        // Test that uw_links were created
        FeedItem launchFeedItem = new FeedItem();
        launchFeedItem.parentId = cGroup.Id;
        launchFeedItem.Type = 'TextPost';
        launchFeedItem.Body= Label.LAUNCH_PINNOVATE_CMD;
        
        insert launchFeedItem;
 
        delete pinFeedComments[1];
        
    //  uw_TriggerHandler handlerObj1 = new uw_TriggerHandler();
    //  handlerObj1.handleFeedItemBeforeInsert(feedItems);
                
    } */
    
    
    
 }