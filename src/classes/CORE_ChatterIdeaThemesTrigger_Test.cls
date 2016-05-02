@IsTest(SeeAllData=true)
public class CORE_ChatterIdeaThemesTrigger_Test {
   
     public static TestMethod void testIdeaThemesTrigger()
      {
      
        /*CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        List<ChatterIdeaThemes__c> chatterIdeaTheme1=[select DefaultIdeaThemeCreatedPic__c from ChatterIdeaThemes__c ORDER BY Name ASC NULLS FIRST limit 1];
                
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass1',Status='Active',Title='TestIdeaThemefromTestclass1',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc');
        insert ideaTheme;
        System.assertEquals('TestIdeaThemefromTestclass1', ideaTheme.Idea_Theme_Title__c);
        
        ideaTheme.Active_Challenge__c=true;
        update ideaTheme;
        
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass2',Status='Active',Title='TestIdeaThemefromTestclass2',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Categories__c='Hair,General',StartDate=System.now(),EndDate=System.now().addDays(6),
        Chatter_Post__c=true,Idea_Themes_Banner__c='<img alt="User-added image" src="https://unilever--CHAZWA2--c.cs14.content.force.com/servlet/rtaImage?eid=0Bgc00000008Odc&amp;feoid=00NE0000005Nugn&amp;refid=0EMc00000000FNP" style="height: 80px; width: 500px;"></img>',Description__c='Test Desc');
        insert ideaTheme1;
        System.assertEquals('TestIdeaThemefromTestclass2', ideaTheme1.Idea_Theme_Title__c);
        
        //Idea idea1=[select Categories from Idea limit 1];
        
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
        
        Idea idea=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme.id,Status='New',Title='Hifromtestclassidea1',Categories=lstPickvals[0],
        Categories__c='General',Description__c='Test');
        insert idea;
        
        test.stoptest();*/
      }
}