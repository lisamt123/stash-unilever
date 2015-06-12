@IsTest(SeeAllData=true)
public class CORE_ChatterIdeaThemesTrigger_Test {
   
     public static TestMethod void testIdeaThemesTrigger()
      {
      
        CollaborationGroup group1=new CollaborationGroup(name='IdeaTestClass',CollaborationType='Public');
        insert group1;
        
        List<ChatterIdeaThemes__c> chatterIdeaTheme1=[select DefaultIdeaThemeCreatedPic__c from ChatterIdeaThemes__c ORDER BY Name ASC NULLS FIRST limit 1];
                
        Community community=[select Id from Community where IsActive =:True limit 1];

        test.starttest();
 
        IdeaTheme ideaTheme=new IdeaTheme(Idea_Theme_Title__c='TestIdeaThemefromTestclass',Status='New',Title='TestIdeaThemefromTestclass.',Active_Challenge__c=false,Groups_to_Post__c=group1.id,
        CommunityId=community.id,Idea_Theme_Poster_URL__c=chatterIdeaTheme1[0].DefaultIdeaThemeCreatedPic__c);
        insert ideaTheme;
        System.assertEquals(false, ideaTheme.Active_Challenge__c);
        
        ideaTheme.Active_Challenge__c=true;
        update ideaTheme;
        
        IdeaTheme ideaTheme1=new IdeaTheme(Idea_Theme_Title__c='Hifromtestclass',Status='New',Title='Hifromtestclass.',Active_Challenge__c=true,Groups_to_Post__c=group1.id,
        CommunityId=community.id);
        insert ideaTheme1;
        System.assertEquals(true, ideaTheme1.Active_Challenge__c);
        
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
        
        Idea idea=new Idea(Body='HifromTestClass',CommunityId=community.id,IdeaThemeId=ideaTheme.id,Status='New',Title='Hifromtestclassidea.',Categories=lstPickvals[0]);
        insert idea;
        
        test.stoptest();
      }
}