/*
Class Name: EA_ControllerTestClass
Author : Mindtree
Date: 11 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_ControllerClass.
*/
@IsTest
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
            event.Description__c='test.Description';
            event.Minutes_to_Complete_Action__c=4;
            event.Participants_Required__c=5;
            event.Rating__c=5;
            event.Top_Tip__c='dummyvalue';
            insert event;
            System.assertEquals('test.Description', event.Description__c);
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Day__c='Today';
            team.Activity_Points__c=5;
            team.Everyday_Activity__c=event.id;
            team.Feedback_Comments__c='test.feedback';
            team.Invitation_Status__c='Accepted';
            team.Invitation_Text__c='test.inv';
            team.Invited_By__c=localUser.id;
            team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
            System.assertEquals('test.feedback', team.Feedback_Comments__c);
            FeedItem post = new FeedItem();
            post.ParentId = event.id; 
            post.Body = 'test.Body';
            insert post;
          
            EA_ThemesDetails__c ea=new EA_ThemesDetails__c();
            ea.name='ThemesDetails';
            ea.ThemeColorCode__c='test.color';
            ea.ThemeDescription__c='Description';
            insert ea;
            EA_BadgeDetails__c badge=new EA_BadgeDetails__c();
            badge.name='Newbee';
            badge.BadgeColor__c='blue';
            badge.BadgeSerial__c=1;
            badge.BadgeValue__c=2;
            insert badge;
            
            Test.startTest();
            EA_ControllerClass Eacontroller=new EA_ControllerClass();
            EA_ControllerClass.getActivities();
            EA_ControllerClass.getThemes();
            EA_ControllerClass.updateParticipantResponse(team.id,team.Participant__c,'Accept');
            List<Everyday_Activity__c> temp1=EA_ControllerClass.getActivitiesonfilter('Working Effectively');
            List<Everyday_Activity__c> temp2=EA_ControllerClass.getactivitydetail('2223333');
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp4=EA_ControllerClass.getActivityPoints('122');
            EA_ControllerClass.getbooleanvalue('3446677');
            List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> temp6=EA_ControllerClass.getuserList('event.id');
            try{
             EA_ControllerClass.getUserDetail();
          //   EA_ControllerClass.getActivityParticipantCount(event.id);   
               List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> temp3=EA_ControllerClass.getcontentdetail(event.id);
               }catch(exception e){
            System.debug('Exception caught: ' + e.getMessage());}
              EA_ControllerClass.insertteamrecord(event.id); 
            
          EA_ControllerClass.getParticipantName(users);
             EA_ControllerClass.insertfeeditem(event.id,'comment');
             
             EA_ControllerClass.getbooleanvalue(event.id);               
                  
            List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper>temp12=EA_ControllerClass.getcommentDetail(event.id);
            
            EA_ControllerClass.getToDoTimeline();
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper> temp7=EA_ControllerClass.getUserActivities();    
            List<EA_Team_Member__c > temp211=EA_ControllerClass.getinvitelist(event.id);
            EA_ControllerClass.chatterfeeditem('postbody');
            string s1=EA_ControllerClass.callSubmitToDoAction(event.id,'json','activityTime');
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
            event.Description__c='test.Description';
            event.Minutes_to_Complete_Action__c=4;
            event.Participants_Required__c=5;
            event.Rating__c=5;
            event.Top_Tip__c='dummyvalue';
            insert event;
            System.assertEquals('test.Description', event.Description__c);
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Day__c='Today';
            team.Activity_Points__c=5;
            team.Everyday_Activity__c=event.id;
            team.Feedback_Comments__c='test.feedback';
            team.Invitation_Status__c='Accepted';
            team.Invitation_Text__c='test.inv';
            team.Invited_By__c=localUser.id;
            team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
            System.assertEquals('test.feedback', team.Feedback_Comments__c);
            FeedItem post = new FeedItem();
            post.ParentId = event.id; 
            post.Body = 'test.Body';
            insert post;
           
           
          aa_agent_app_custom_setting__c app=new aa_agent_app_custom_setting__c();
          app.Name='agent';
          app.Key__c='key';
          app.Value__c='value';
          insert app;
            EA_ThemesDetails__c ea=new EA_ThemesDetails__c();
            ea.name='test11';
            ea.ThemeColorCode__c='test.color';
            ea.ThemeDescription__c='Description';
            insert ea;
            EA_BadgeDetails__c badge=new EA_BadgeDetails__c();
            badge.name='Bronze';
            badge.BadgeColor__c='blue';
            badge.BadgeSerial__c=1;
            badge.BadgeValue__c=2;
            insert badge;
              Test.startTest();
        
            EA_ControllerClass Eacontroller=new EA_ControllerClass();
            EA_ControllerClass.getActivities();
            EA_ControllerClass.getThemes();
            EA_ControllerClass.updateParticipantResponse(team.id,team.Participant__c,'Accept');
            List<Everyday_Activity__c> temp1=EA_ControllerClass.getActivitiesonfilter('Working Effectively');
            List<Everyday_Activity__c> temp2=EA_ControllerClass.getactivitydetail('2223333');
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp4=EA_ControllerClass.getActivityPoints('122');
            EA_ControllerClass.getbooleanvalue('3446677');
            List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> temp6=EA_ControllerClass.getuserList('event.id');
           try{
             EA_ControllerClass.getUserDetail();
           //  EA_ControllerClass.getActivityParticipantCount(event.id);  
              List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> temp3=EA_ControllerClass.getcontentdetail(event.id);
              }catch(exception e){
             System.debug('Exception caught: ' + e.getMessage());}
                         
             EA_ControllerClass.insertfeeditem(event.id,'comment');
             EA_ControllerClass.getbooleanvalue(event.id);               
                  
            List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper>temp12=EA_ControllerClass.getcommentDetail(event.id);
           
            EA_ControllerClass.getToDoTimeline();
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper> temp7=EA_ControllerClass.getUserActivities();    
            List<EA_Team_Member__c > temp211=EA_ControllerClass.getinvitelist(event.id);
            EA_ControllerClass.chatterfeeditem('postbody');
            string s1=EA_ControllerClass.callSubmitToDoAction(event.id,'json','activityTime');
            Map<string,string> test2=EA_ControllerClass.getThemeColors();
            Test.stopTest();
        }
    } 
     
   }