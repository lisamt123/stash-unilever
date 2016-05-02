@isTest
private class CORE_ChatterGroupFeed_Page_Test{ 
    static testMethod void test_gp_feed() {            
       //test class here
     
     CollaborationGroup objgroup= new CollaborationGroup(Name = 'my_group1', CollaborationType = 'private');
     insert objgroup;
     ApexPages.currentPage().getParameters().put('groupId',objgroup.id);
     ApexPages.StandardController sc = new ApexPages.standardController(objgroup);
     ChatterGroupFeedController  objChatter = new ChatterGroupFeedController(sc);
     
     Map<String, Id> profiles = new Map<String, Id>();
     for(Profile p :[SELECT Id, Name FROM profile])
        profiles.put(p.Name, p.Id);
                
     User admin_user = new User (alias = 'Test', email='admin_user0@unilevertestenv.com', emailencodingkey='UTF-8', localesidkey = 'en_US',languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', profileId = profiles.get('System Administrator'),lastname='admin', username='admin_user0@unilevertestenv.com', IsActive = true);
     insert admin_user;

  
     CollaborationGroupMember objmemeber=new CollaborationGroupMember (CollaborationGroupId=objgroup.id,MemberId=admin_user.id);
     insert objmemeber;
     objChatter.DisplayMessages(); 
       
          
     /*Author:Mindtree
    Date:9/7/2014
    Description: Code coverage for class ChatterGroupFeedControllerAnnouncement */ 
        
        CollaborationGroup objPublicGroup = new CollaborationGroup(Name = 'my_group2', CollaborationType = 'public');
        insert objPublicGroup; 
        
        // Insert feedItem body with short string.      
        FeedItem objFeedItemShort=new FeedItem (Body='new Announcement',CreatedById = Userinfo.getUserId(),Type = 'AdvancedTextPost',Title= 'Test Title',parentId = objPublicGroup.id);
        insert objFeedItemShort;
        System.assertEquals(1, [Select Id from FeedItem where Id = :objFeedItemShort.Id].size()); 
            
        Announcement objShortAnnouncement=new Announcement(ExpirationDate= DateTime.Now().AddDays(1),FeedItemId=objFeedItemShort.id);
        insert objShortAnnouncement;
        System.assertEquals(1, [Select Id from Announcement where Id= :objShortAnnouncement.Id].size());
        
        CollaborationGroup objGroupUpdateShort=[select id from CollaborationGroup where id=:objPublicGroup.id];
        objGroupUpdateShort.AnnouncementId =objShortAnnouncement.id;
        update objGroupUpdateShort;
        ApexPages.currentPage().getParameters().put('groupId',objPublicGroup.id);
        ApexPages.StandardController sc_shortString = new ApexPages.standardController(objPublicGroup);
        

        // Insert feedItem body with long string.  
        FeedItem objFeedItemLong=new FeedItem (Body='new Announcement new Announcementnew Announcement new Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcementnew Announcement',
        CreatedById = Userinfo.getUserId(),Type = 'AdvancedTextPost',Title= 'Test Title',parentId = objPublicGroup.id);
        insert objFeedItemLong;
        System.assertEquals(1, [Select Id from FeedItem where Id = :objFeedItemLong.Id].size()); 
            
        Announcement objLongAnnouncement=new Announcement(ExpirationDate= DateTime.Now().AddDays(1),FeedItemId=objFeedItemLong.id);
        insert objLongAnnouncement;
        System.assertEquals(1, [Select Id from Announcement where Id= :objLongAnnouncement.Id].size()); 
            
        CollaborationGroup objGroupUpdatesLong=[select id from CollaborationGroup where id=:objPublicGroup.id];
        objGroupUpdatesLong.AnnouncementId =objLongAnnouncement.id;
        update objGroupUpdatesLong;   
        ApexPages.currentPage().getParameters().put('groupId',objPublicGroup.id);
        ApexPages.StandardController sc_longString = new ApexPages.standardController(objPublicGroup);
        
        Test.startTest(); 
        ChatterGroupFeedController  objChatterfeed = new ChatterGroupFeedController (sc_shortString);
        ChatterGroupFeedController  objChatterfeed1 = new ChatterGroupFeedController (sc_longString);
        Test.stopTest();

        /*----------- end ------------*/
    }               
 }