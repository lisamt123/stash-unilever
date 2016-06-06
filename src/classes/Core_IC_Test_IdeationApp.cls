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
    
    @TestVisible static String strGet= 'GET';
    @TestVisible static String strPost= 'POST';
    @TestVisible static String strGeneral= 'General';
    @TestVisible static String strSysAdmin= 'System Administrator';
    @TestVisible static String strIdea= 'Idea';
    @TestVisible static String strCategories='Categories';
    
    public static testMethod void TestLandingPage(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass1',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair1,General1',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc1');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass2',Status='Closed',Title='TestIdeaThemefromTestclass2',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair2,General2',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc2');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass2', ideaTheme2.Idea_Theme_Title__c);
        
        Profile p = [Select Id from Profile where Name = :strSysAdmin LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD12341@test1341.com', Email = 'test123411@abc123.com',
                            FirstName = 'Test12341', LastName = 'User12341', alias='tx12341', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(strIdea);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(strCategories).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass1',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New',Title='Hifromtestclassidea1',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test1');
        insert idea1;
        
        Idea idea2=new Idea(Body='HifromTestClass2',CommunityId=community.id,IdeaThemeId=ideaTheme2.id,Status='New1',Title='Hifromtestclassidea2',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test2');
        insert idea2;
        
        System.runAs(usr) {
            IdeaComment ideaComment1=new IdeaComment(CommentBody='Hi1',IdeaId=idea1.Id);
            insert ideaComment1;
            IdeaComment ideaComment2=new IdeaComment(CommentBody='Hi2',IdeaId=idea1.Id);
            insert ideaComment2;
        }
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"4","IdeasOfTheWeekLimit":"4","MyUpdatesLimit":"4"}}','GetLandingPageData',strGet);
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"All","IdeasOfTheWeekLimit":"0","MyUpdatesLimit":"0"}}','GetLandingPageData',strGet);
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"0","IdeasOfTheWeekLimit":"All","MyUpdatesLimit":"0"}}','GetLandingPageData',strGet);
        RemoteServiceCallController.invokeService('{"ideaLandingPageRequest":{"FeaturedCampaignsLimit":"0","IdeasOfTheWeekLimit":"0","MyUpdatesLimit":"All"}}','GetLandingPageData',strGet);
        Test.stoptest();
    }
    
    public static testMethod void TestCampaignDetail(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass2',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass3',Status='Active',Title='TestIdeaThemefromTestclass3',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='General,Hair',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc3');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass3', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass4',Status='Closed',Title='TestIdeaThemefromTestclass2',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='General,Hair',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc4');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass4', ideaTheme2.Idea_Theme_Title__c);
        
        Profile p = [Select Id from Profile where Name = :strSysAdmin LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD12342@test1341.com', Email = 'test123412@abc123.com',
                            FirstName = 'Test12342', LastName = 'User12342', alias='tx12342', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(strIdea);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(strCategories).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass3',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New2',Title='Hifromtestclassidea3',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test3');
        insert idea1;
        
        Idea idea2=new Idea(Body='HifromTestClass4',CommunityId=community.id,IdeaThemeId=ideaTheme2.id,Status='New3',Title='Hifromtestclassidea4',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test4');
        insert idea2;
        
        IdeaComment ideaComment=new IdeaComment(CommentBody='Hi3',IdeaId=idea1.Id);
        insert ideaComment; 
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","LatestIdeasLimit":"5"}}','GetCampaignDetailData',strGet);
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","LatestIdeasLimit":"All"}}','GetCampaignDetailData',strGet);
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","LatestIdeasLimit":"0"}}','GetCampaignDetailData',strGet);
        RemoteServiceCallController.invokeService('{"ideaCampaignDetailRequest":{"IdeaCampaignId":"","LatestIdeasLimit":"0"}}','GetCampaignDetailData',strGet);
        test.stoptest();
        
    }
    
    public static testMethod void TestIdeaDetail(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass3',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass5',Status='Active',Title='TestIdeaThemefromTestclass5',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair3,General3',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner5',Description__c='Test Desc6');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass5', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass6',Status='Closed',Title='TestIdeaThemefromTestclass6',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair4,General4',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner6',Description__c='Test Desc6');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass6', ideaTheme2.Idea_Theme_Title__c);
        
        Profile p = [Select Id from Profile where Name = :strSysAdmin LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD12343@test1341.com', Email = 'test123413@abc123.com',
                            FirstName = 'Test12343', LastName = 'User12343', alias='tx12343', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(strIdea);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(strCategories).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass5',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New4',Title='Hifromtestclassidea5',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test5');
        insert idea1;
        
        Idea idea2=new Idea(Body='HifromTestClass6',CommunityId=community.id,IdeaThemeId=ideaTheme2.id,Status='New5',Title='Hifromtestclassidea6',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test6');
        insert idea2;
        
        IdeaComment ideaComment=new IdeaComment(CommentBody='Hi4',IdeaId=idea1.Id);
        insert ideaComment;
        
        RemoteServiceCallController.invokeService('{"ideaDetailRequest":{"IdeaId":"'+ idea1.Id +'"}}','GetIdeaDetailData',strGet);
        RemoteServiceCallController.invokeService('{"ideaDetailRequest":{"IdeaId":""}}','GetIdeaDetailData',strGet);
        test.stoptest();
    }
    
    public static testMethod void TestVoteForIdea(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass4',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
         
        Profile p = [Select Id from Profile where Name = :strSysAdmin LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD12344@test1341.com', Email = 'test123414@abc123.com',
                            FirstName = 'Test12344', LastName = 'User12344', alias='tx12344', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
         
        Idea idea1;
        System.runAs(usr) { 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass7',Status='Active',Title='TestIdeaThemefromTestclass7',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='General,Hair',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner7',Description__c='Test Desc7');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass7', ideaTheme1.Idea_Theme_Title__c);
        
        IdeaTheme ideaTheme2=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass8',Status='Closed',Title='TestIdeaThemefromTestclass8',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='General,Hair',StartDate=System.now(),EndDate=System.now().addMinutes(1),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner8',Description__c='Test Desc8');
        insert ideaTheme2;
        System.assertEquals('TestIdeaThemefromTestclass8', ideaTheme2.Idea_Theme_Title__c);
        
        
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(strIdea);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(strCategories).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        idea1=new Idea(Body='HifromTestClass7',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New6',Title='Hifromtestclassidea7',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test7');
        insert idea1;
        RemoteServiceCallController.invokeService('{"voteForIdeasOfTheWeekRequest":{"IdeaId":"'+idea1.ID+'"}}','PostVoteIdeas',strPost);
        }
        
        RemoteServiceCallController.invokeService('{"voteForIdeasOfTheWeekRequest":{"IdeaId":"'+idea1.ID+'"}}','PostVoteIdeas',strPost);
        RemoteServiceCallController.invokeService('{"voteForIdeasOfTheWeekRequest":{"IdeaId":""}}','PostVoteIdeas',strPost);
        test.stoptest();
    }
    
    public static testMethod void TestCommentForIdea(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass5',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass9',Status='Active',Title='TestIdeaThemefromTestclass9',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c=strGeneral,StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner9',Description__c='Test Desc9');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass9', ideaTheme1.Idea_Theme_Title__c);
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(strIdea);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(strCategories).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
        lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        Idea idea1=new Idea(Body='HifromTestClass8',CommunityId=community.id,IdeaThemeId=ideaTheme1.id,Status='New7',Title='Hifromtestclassidea8',Categories=lstPickvals[0],
        Categories__c=strGeneral,Description__c='Test8');
        insert idea1;
        
        RemoteServiceCallController.invokeService('{"ideaCommentRequest":{"IdeaId":"'+idea1.Id+'","CommentBody":"Hi all  I am commenting"}}','PostCommentIdeas',strPost);
        RemoteServiceCallController.invokeService('{"ideaCommentRequest":{"IdeaId":"","CommentBody":"Hi all  I am commenting"}}','PostCommentIdeas',strPost);
        test.stoptest();
    }
    
    public static testMethod void TestSubmitIdea(){
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass6',CollaborationType='Public');
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass10',Status='Active',Title='TestIdeaThemefromTestclass10',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='Test Banner10',Description__c='Test Desc10');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass10', ideaTheme1.Idea_Theme_Title__c);
        
        
        
        RemoteServiceCallController.invokeService('{"submitIdeaRequest":{"IdeaCampaignId":"'+ideaTheme1.Id+'","IdeaTitle":"Test4","IdeaDescription":"Test","IdeaCategories":["Innovation"],"AttachmentBody":null,"AttachmentName":null,"AttachmentContentType":null}}','PostSubmitIdeas',strPost);
        RemoteServiceCallController.invokeService('{"submitIdeaRequest":{"IdeaCampaignId":"","IdeaTitle":"Test4","IdeaDescription":"Test","IdeaCategories":["Innovation"],"AttachmentBody":null,"AttachmentName":null,"AttachmentContentType":null}}','PostSubmitIdeas',strPost);
        Utility.isEmpty(ideaTheme1);
        Utility.isEmpty('');
        test.stoptest();
    }
    
   public static testMethod void TestFAQData(){
        String faqId='a0Kc000000FTJT3EAP';
        Core_IC_WrapperUtility wrapper=new Core_IC_WrapperUtility();
        test.starttest();
        try{
        RemoteServiceCallController.invokeService('','GetFAQValues',strGet);
        }
         catch(Exception ex){
          system.assertEquals(ex.getMessage(), ex.getMessage());
        }
        RemoteServiceCallController.invokeServiceWithURLParameter('','GetFAQValues',strGet,faqId);
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