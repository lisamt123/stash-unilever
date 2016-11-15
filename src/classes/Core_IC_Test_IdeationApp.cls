/*
  Class Name: Core_IC_Test_IdeationApp
  Author : Mindtree
  Date: 3 Aug 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover The following classes
                            Core_IC_WrapperUtility
                            Core_IC_AppConstants
                            Core_IC_LandingPage
                            Core_IC_PostVoteForIdeas
                            Core_IC_PostCommentForAnIdea
                            CORE_IC_Batch_ICampaignStatusUpdate
                            CORE_IC_Scheduler_ICampaignStatusUpdate
                            CORE_IC_IdeaDeatil
                            CORE_IC_CampaignDetail
                            Core_IC_PostSubmitIdea
                            Core_IC_FAQData
                            Core_IC_Test_IdeationApp
                            CORE_IC_Test_Batch_CampaignStatus            
*/

@isTest (Seealldata=true)
public class Core_IC_Test_IdeationApp {
    
    public static testMethod void TestLandingPage(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass2',Status='Closed',Title='TestIdeaThemefromTestclass2',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass2', ideaTheme2.Idea_Theme_Title__c);
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Idea');//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Categories').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New',Title='Hifromtestclassidea1',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea1;
        
        Idea idea2=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme2.id,Status='New',Title='Hifromtestclassidea2',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea2;
        
        System.runAs(usr) {
            IdeaComment ideaComment1=new IdeaComment(CommentBody='Hi1',IdeaId=idea1.Id);
            insert ideaComment1;
            IdeaComment ideaComment2=new IdeaComment(CommentBody='Hi2',IdeaId=idea1.Id);
            insert ideaComment2;
        }
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"4","IdeasOfTheWeekLimit":"4","MyUpdatesLimit":"4"}}','GetLandingPageData','GET');
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"All","IdeasOfTheWeekLimit":"0","MyUpdatesLimit":"0"}}','GetLandingPageData','GET');
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"0","IdeasOfTheWeekLimit":"All","MyUpdatesLimit":"0"}}','GetLandingPageData','GET');
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"0","IdeasOfTheWeekLimit":"0","MyUpdatesLimit":"All"}}','GetLandingPageData','GET');
        Test.stoptest();
    }
    
    public static testMethod void TestCampaignDetail(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass2',Status='Closed',Title='TestIdeaThemefromTestclass2',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass2', ideaTheme2.Idea_Theme_Title__c);
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Idea');//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Categories').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New',Title='Hifromtestclassidea1',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea1;
        
        Idea idea2=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme2.id,Status='New',Title='Hifromtestclassidea2',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea2;
        
        IdeaComment ideaComment=new IdeaComment(CommentBody='Hi',IdeaId=idea1.Id);
        insert ideaComment; 
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","LatestIdeasLimit":"5"}}','GetCampaignDetailData','GET');
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","LatestIdeasLimit":"All"}}','GetCampaignDetailData','GET');
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","LatestIdeasLimit":"0"}}','GetCampaignDetailData','GET');
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"","LatestIdeasLimit":"0"}}','GetCampaignDetailData','GET');
        test.stoptest();
        
    }
    
    public static testMethod void TestIdeaDetail(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner',Description__c='Test Desc');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass2',Status='Closed',Title='TestIdeaThemefromTestclass2',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner',Description__c='Test Desc');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass2', ideaTheme2.Idea_Theme_Title__c);
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Idea');//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Categories').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New',Title='Hifromtestclassidea1',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea1;
        
        Idea idea2=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme2.id,Status='New',Title='Hifromtestclassidea2',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea2;
        
        IdeaComment ideaComment=new IdeaComment(CommentBody='Hi',IdeaId=idea1.Id);
        insert ideaComment;
        
        RemoteServiceCallController.invokeService('{"ideaDetailRequest":{"IdeaId":"'+ idea1.Id +'"}}','GetIdeaDetailData','GET');
        RemoteServiceCallController.invokeService('{"ideaDetailRequest":{"IdeaId":""}}','GetIdeaDetailData','GET');
        test.stoptest();
    }
    
    public static testMethod void TestVoteForIdea(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
         
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
         
        Idea idea1;
        System.runAs(usr) { 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner',Description__c='Test Desc');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass2',Status='Closed',Title='TestIdeaThemefromTestclass2',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner',Description__c='Test Desc');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass2', ideaTheme2.Idea_Theme_Title__c);
        
        
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Idea');//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Categories').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        idea1=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New',Title='Hifromtestclassidea1',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea1;
        RemoteServiceCallController.invokeService('{"voteForIdeasOfTheWeekRequest":{"IdeaId":"'+idea1.ID+'"}}','PostVoteIdeas','POST');
        }
        
        RemoteServiceCallController.invokeService('{"voteForIdeasOfTheWeekRequest":{"IdeaId":"'+idea1.ID+'"}}','PostVoteIdeas','POST');
        RemoteServiceCallController.invokeService('{"voteForIdeasOfTheWeekRequest":{"IdeaId":""}}','PostVoteIdeas','POST');
        test.stoptest();
    }
    
    public static testMethod void TestCommentForIdea(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner',Description__c='Test Desc');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme1.Idea_Theme_Title__c);
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Idea');//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Categories').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New',Title='Hifromtestclassidea1',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea1;
        
        RemoteServiceCallController.invokeService('{"ideaCommentRequest":{"IdeaId":"'+idea1.Id+'","CommentBody":"Hi all  I am commenting"}}','PostCommentIdeas','POST');
        RemoteServiceCallController.invokeService('{"ideaCommentRequest":{"IdeaId":"","CommentBody":"Hi all  I am commenting"}}','PostCommentIdeas','POST');
        test.stoptest();
    }
    
    public static testMethod void TestSubmitIdea(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner',Description__c='Test Desc');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme1.Idea_Theme_Title__c);
        
        String str;
        
        RemoteServiceCallController.invokeService('{"submitIdeaRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","IdeaTitle":"Test4","IdeaDescription":"Test","IdeaCategories":["Innovation"],"AttachmentBody":null,"AttachmentName":null,"AttachmentContentType":null}}','PostSubmitIdeas','POST');
        RemoteServiceCallController.invokeService('{"submitIdeaRequest":{"IdeaCampaignId":"","IdeaTitle":"Test4","IdeaDescription":"Test","IdeaCategories":["Innovation"],"AttachmentBody":null,"AttachmentName":null,"AttachmentContentType":null}}','PostSubmitIdeas','POST');
        Utility.isEmpty(ideaTheme1);
        Utility.isEmpty('');
        test.stoptest();
    }
    
    public static testMethod void TestFAQData(){
        Core_IC_WrapperUtility wrapper=new Core_IC_WrapperUtility();
        test.starttest();
        RemoteServiceCallController.invokeService('','GetFAQValues','GET');
        RemoteServiceCallController.invokeServiceWithURLParameter('','GetFAQValues','GET','a0Kc000000FTJT3EAP');
        test.stoptest();
    }
    
    public static testMethod void TestBaseServiceExceptionForIdeation(){
        Core_IC_WrapperUtility wrapper=new Core_IC_WrapperUtility();
        Core_IC_AppConstants appConstants=new Core_IC_AppConstants();
        Test.starttest();
        Core_CA_BaseServiceException.resolveExceptions('test1',new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method'));
        Core_CA_BaseServiceException.resolveExceptions(new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method '));
        Core_CA_BaseServiceException.resolveExceptions('Test2',new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method'),'Test3');
        Test.stoptest();            
    }
    
}