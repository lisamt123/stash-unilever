/*
Class Name: EA_ControllerTestClass
Author : Mindtree
Date: 11 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_ControllerClass.
*/
@IsTest(SeeAllData=true)
public class EA_ControllerTestClass{
    static testMethod void postive() {
        ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
        user  localUser= new User(username='localuserforUnitTest@20110308test.com',
                                  alias = 'testu',
                                  email='localuserforUnitTest@20110308test.com',
                                  emailencodingkey='UTF-8',
                                  lastname='Syngenta',
                                  CommunityNickname ='mahi45678',
                                  languagelocalekey='en_US',
                                  localesidkey='en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey='Europe/Berlin'
                                 );
        insert localUser;
        List<user> users=[select id,name from user where profileid =:adminProfileID];
        System.runAs(localUser){
            Everyday_Activity__c  event=new Everyday_Activity__c();
            event.Active__c=true;
            event.Activity_Points__c=4;
            event.Description__c='test';
            event.Minutes_to_Complete_Action__c=4;
            event.Participants_Required__c=5;
            event.Rating__c=5;
            event.Top_Tip__c='dummyvalue';
            insert event;
            System.assertEquals('test', event.Description__c);
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Day__c='Today';
            team.Activity_Points__c=5;
            team.Everyday_Activity__c=event.id;
            team.Feedback_Comments__c='test';
            team.Invitation_Status__c='Accepted';
            team.Invitation_Text__c='test';
            team.Invited_By__c=localUser.id;
            team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
            System.assertEquals('test', team.Feedback_Comments__c);
            FeedItem post = new FeedItem();
            post.ParentId = event.id; 
            post.Body = 'test';
            insert post;
            aa_agent_app_custom_setting__c agent=new aa_agent_app_custom_setting__c();
            agent.name='test';
            agent.Key__c='test';
            agent.Value__c='test';
            insert agent;
            EA_ThemesDetails__c ea=new EA_ThemesDetails__c();
            ea.name='test';
            ea.ThemeColorCode__c='test';
            ea.ThemeDescription__c='test';
            insert ea;
            EA_BadgeDetails__c badge=new EA_BadgeDetails__c();
            badge.name='test1';
            badge.BadgeColor__c='blue';
            badge.BadgeSerial__c=1;
            badge.BadgeValue__c=2;
            insert badge;
            List<Everyday_Activity__c> activityList=[Select Id, CreatedDate, CreatedBy.SmallPhotoUrl, CreatedBy.Name, CreatedById, (Select Id, ParentId, Body, RelatedRecordId From Feeds limit 1) From Everyday_Activity__c Where Active__c =true AND id =:event.id];
           System.debug('=================='+activityList);
           
            Test.startTest();
            string Actid=ApexPages.currentPage().getParameters().put('Id',post.ParentId);
            string eventid=ApexPages.currentPage().getParameters().put('Id',event.id);
            EA_ControllerClass Eacontroller=new EA_ControllerClass();
                      EA_ControllerClass.getActivities();
            EA_ControllerClass.getThemes();
            List<Everyday_Activity__c> temp1=EA_ControllerClass.getActivitiesonfilter('test');
            List<Everyday_Activity__c> temp2=EA_ControllerClass.getactivitydetail('122');
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp4=EA_ControllerClass.getActivityPoints('122');
            EA_ControllerClass.getbooleanvalue('122');
            List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> temp6=EA_ControllerClass.getuserList('eventid');
            try{
                EA_ControllerClass.getbooleanvalue(Actid);
              //  List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> temp3=EA_ControllerClass.getcontentdetail('1234');
            }catch(exception e){}
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp7=EA_ControllerClass.getUserActivities();
            EA_ControllerClass.insertfeeditem(post.ParentId,'test');
            EA_ControllerClass.getUserDetail();
            EA_ControllerClass.chatterfeeditem();
           // EA_Team_Member__c temp8=EA_ControllerClass.getParticipantTeamMemberRec('122', '123');
           // EA_ControllerClass.inviteResponseNofitification('1234', '123' , '122', 'tst');
            try{
               // EA_ControllerClass.inviteUserToDoActivity('12','localUser.id,user.id');
               // EA_ControllerClass.postCommentAtUserFeed('112', 'localUser.id,user.id' ,'test');
            }catch(exception e){}
            EA_ControllerClass.insertteamrecord(eventid);
            Map<string,string> test2=EA_ControllerClass.getThemeColors();
            Test.stopTest();
           
                  
                  
        }
    }
   static testMethod void negative() {
        ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
        user  localUser= new User(username='localuserforUnitTest@20110308test.com',
                                  alias = 'testu',
                                  email='localuserforUnitTest@20110308test.com',
                                  emailencodingkey='UTF-8',
                                  lastname='Syngenta',
                                  CommunityNickname ='mahi45678',
                                  languagelocalekey='en_US',
                                  localesidkey='en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey='Europe/Berlin'
                                 );
        insert localUser;
        List<user> users=[select id,name from user where profileid =:adminProfileID];
        System.runAs(localUser){
            Everyday_Activity__c  event=new Everyday_Activity__c();
            event.Active__c=true;
            event.Activity_Points__c=4;
            event.Description__c='test';
            event.Minutes_to_Complete_Action__c=4;
            event.Participants_Required__c=5;
            event.Rating__c=5;
            event.Top_Tip__c='dummyvalue';
            insert event;
            System.assertEquals('test', event.Description__c);
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Day__c='Today';
            team.Activity_Points__c=5;
            team.Everyday_Activity__c=event.id;
            team.Feedback_Comments__c='test';
            team.Invitation_Status__c='Accepted';
            team.Invitation_Text__c='test';
            team.Invited_By__c=localUser.id;
            //team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
            System.assertEquals('test', team.Feedback_Comments__c);
            FeedItem post = new FeedItem();
            post.ParentId = event.id; 
            post.Body = 'test';
            insert post;
            aa_agent_app_custom_setting__c agent=new aa_agent_app_custom_setting__c();
            agent.name='test';
            agent.Key__c='test';
            agent.Value__c='test';
            insert agent;
            EA_ThemesDetails__c ea=new EA_ThemesDetails__c();
            ea.name='test';
            ea.ThemeColorCode__c='test';
            ea.ThemeDescription__c='test';
            insert ea;
            EA_BadgeDetails__c badge=new EA_BadgeDetails__c();
            badge.name='test';
            badge.BadgeColor__c='blue';
            badge.BadgeSerial__c=1;
            badge.BadgeValue__c=2;
            insert badge;
              List<Everyday_Activity__c> activityList=[Select Id, CreatedDate, CreatedBy.SmallPhotoUrl, CreatedBy.Name, CreatedById, (Select Id, ParentId, Body, RelatedRecordId From Feeds limit 1) From Everyday_Activity__c Where Active__c =true AND id =:event.id];
            Test.startTest();
            string Actid=ApexPages.currentPage().getParameters().put('Id',post.ParentId);
            string eventid=ApexPages.currentPage().getParameters().put('Id',event.id);
            EA_ControllerClass.getActivities();
            EA_ControllerClass.getThemes();
            List<Everyday_Activity__c> temp1=EA_ControllerClass.getActivitiesonfilter('test');
            List<Everyday_Activity__c> temp2=EA_ControllerClass.getactivitydetail('122');
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp4=EA_ControllerClass.getActivityPoints('122');
            EA_ControllerClass.getbooleanvalue('122');
            List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> temp6=EA_ControllerClass.getuserList('eventid');
            try{
                EA_ControllerClass.getbooleanvalue(Actid);
               // List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> temp3=EA_ControllerClass.getcontentdetail('1234');
            }catch(exception e){}
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp7=EA_ControllerClass.getUserActivities();
            EA_ControllerClass.insertfeeditem(post.ParentId,'test');
            EA_ControllerClass.getUserDetail();
            EA_ControllerClass.chatterfeeditem();
           // EA_Team_Member__c temp8=EA_ControllerClass.getParticipantTeamMemberRec('122', '123');
           // EA_ControllerClass.inviteResponseNofitification('1234', '123' , '122', 'tst');
            try{
               // EA_ControllerClass.inviteUserToDoActivity('12','localUser.id,user.id');
              //  EA_ControllerClass.postCommentAtUserFeed('112', 'localUser.id,user.id' ,'test');
            }catch(exception e){}
            EA_ControllerClass.insertteamrecord(eventid);
            Map<string,string> test2=EA_ControllerClass.getThemeColors();
            Test.stopTest();
        }
    } 
    }