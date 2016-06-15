@isTest
public class Core_IC_IdeaControllerTest {

    @TestVisible static String strGet= 'GET';
    @TestVisible static String strPost= 'POST';
    @TestVisible static String strGeneral= 'General';
    @TestVisible static String strSysAdmin= 'System Administrator';
    @TestVisible static String strIdea= 'Idea';
    @TestVisible static String strCategories='Categories';
    @TestVisible static String strCollaborationType='Public';
    @TestVisible static String strStatus='Active';
    private static testMethod void Core_IC_IdeaControllerMethod() {
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass2',CollaborationType=strCollaborationType);
        insert group1;
        
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass3',Status=strStatus,Title='TestIdeaThemefromTestclass3',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
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
                            FirstName = 'Test12342', LastName = 'User12342', alias='tx12342', EmailEncodingKey='UTF-8',  LanguageLocaleKey='pt_BR', 
                              LocaleSidKey=' da', TimeZoneSidKey='America/Los_Angeles');
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
        
        System.assertNotEquals(null,Core_IC_IdeaController.getCampaignList('1'));
        Core_IC_IdeaController.getIdeaList('3');
        Core_IC_IdeaController.getMyUpdatesList('4');
         Core_IC_IdeaController.getIdeaDetail(idea1.id); 
         Core_IC_IdeaController.postCommentAnIdea(idea1.id,'abc');
        
        //Core_IC_IdeaController.postSubmitAnIdea(ideaTheme1.Id,'Test4','Test', 'Innovation','','','');
        System.runAs(usr) { 
            Core_IC_IdeaController.postVoteForIdea(idea1.id);
        }
        Core_Ideation__c ideaCustom = new Core_Ideation__c();
        ideaCustom.Checkbox_Value__c=false;
        ideaCustom.Name = 'DescriptionLimit';
        ideaCustom.Text_Value__c='80';
        insert ideaCustom;
        
        Core_IC_IdeaController.getCampaignDetail(ideaTheme1.Id,'4');                 

        Core_IC_FAQ__c faqTest=new Core_IC_FAQ__c();
        faqTest.Description__c='question';
        faqTest.Title__c='Answer';
        faqTest.Name='FAQ1';
        insert faqTest;
        Core_IC_IdeaController.getFaqList();
        System.assert(faqTest!=null);
        Test.stopTest();
    }
}