/*
Class Name: EA_LookupSObjectController_Test
Author : Mindtree
Date: 11 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_LookupSObjectController.
*/
@IsTest
public class EA_LookupSObjectController_Test{
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
        //List<user> users=[select id,name from user where profileid =:adminProfileID];
        System.runAs(localUser){
            Everyday_Activity__c  event=new Everyday_Activity__c();
            event.Active__c=true;
            event.Activity_Points__c=4;
            event.Description__c='test.desc';
            event.Minutes_to_Complete_Action__c=4;
            event.Participants_Required__c=5;
            event.Rating__c=5;
            event.Top_Tip__c='dummyvalue';
            insert event;
            System.assertEquals('test.desc', event.Description__c);
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Day__c='Today';
            team.Activity_Points__c=5;
            team.Everyday_Activity__c=event.id;
            team.Feedback_Comments__c='test.comments';
            team.Invitation_Status__c='Accepted';
            team.Invitation_Text__c='test';
            team.Invited_By__c=localUser.id;
            team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
            System.assertEquals('test.comments', team.Feedback_Comments__c);
            FeedItem post = new FeedItem();
            post.ParentId = event.id; 
            post.Body = 'test.body';
            insert post;
            aa_agent_app_custom_setting__c agent=new aa_agent_app_custom_setting__c();
            agent.name='test.agent';
            agent.Key__c='test.key';
            agent.Value__c='test.value';
            insert agent;
            EA_ThemesDetails__c ea=new EA_ThemesDetails__c();
            ea.name='test';
            ea.ThemeColorCode__c='test.color';
            ea.ThemeDescription__c='test.desc';
            insert ea;
            EA_BadgeDetails__c badge=new EA_BadgeDetails__c();
            badge.name='test1';
            badge.BadgeColor__c='blue';
            badge.BadgeSerial__c=1;
            badge.BadgeValue__c=2;
            insert badge;
         
            Test.startTest();    
            new EA_LookupSObjectController(); 
            EA_LookupSObjectController.Result rs = new EA_LookupSObjectController.Result('object',event.id);//this is for 2nd constructor
            System.assert(rs != null);
            EA_LookupSObjectController.lookup('sobject','user');
             
            EA_LookupSObjectController.getRecentlyWorkedWithUsers();
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
           }
           }
           }