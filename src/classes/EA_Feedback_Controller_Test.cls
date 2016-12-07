/*
Class Name: EA_Feedback_Controller_Test
Author : Mindtree
Date: 22 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_Feedback_Controller.
*/
@IsTest
public class EA_Feedback_Controller_Test{
    static testMethod void Postive() {
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
        // List<user> users=[select id,name from user where profileid =:adminProfileID]; // June 16 - SONAR Fix
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
            integer rating=Integer.valueOf(event.Rating__c);
            System.assertEquals('test.desc', event.Description__c);
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Day__c='Today';
            team.Activity_Points__c=5;
            team.Everyday_Activity__c=event.id;
            team.Feedback_Comments__c='test.comments';
            team.Invitation_Status__c='Self';
            team.Invitation_Text__c='test.inv';
            team.Invited_By__c=localUser.id;
            team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
              FeedItem post = new FeedItem();
            post.ParentId = event.id; 
            post.Body = 'test.Body';
            insert post;
            System.assertEquals('test.comments', team.Feedback_Comments__c);
              Test.startTest();
           
            // EA_Feedback_Controller feed=new EA_Feedback_Controller(); // June 16 - SONAR Fix
            string participantId=userinfo.getuserid();
            System.assert(participantId != null);
            List<Everyday_Activity__c> temp1=EA_Feedback_Controller.getactivitydetail(event.id); 
            System.assert(temp1 != null);
            EA_Feedback_Controller.updateActivityRating(event.id);
            List<Everyday_Activity__c> temp=EA_Feedback_Controller.provideRating(event.id,rating);
            System.assert(temp != null);
            EA_Feedback_Controller.submitFeedback(event.id,'feedbackText',rating,team.id); 
            try{
            EA_Feedback_Controller.submitRating(event.id,team.Participant__c,123);
               
            }catch(exception e){
              System.debug('Exception caught: ' + e.getMessage());}
              
            Integer testActivityRating = EA_Feedback_Controller.getActivityRating(event.id);
            System.assertEquals(testActivityRating, 5);
            string testTeamId = null;
            EA_Feedback_Controller.submitFeedback(event.id,'testFeedbackText',rating,testTeamId);
                   
            Test.stopTest();
            }
            }
      static testMethod void Negative() {
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
        // List<user> users=[select id,name from user where profileid =:adminProfileID]; // June 16 - SONAR Fix
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
            team.Invitation_Text__c='test.inv';
            team.Invited_By__c=localUser.id;
            team.Participant__c=localUser.id;
           //team.Rating_By_Participant__c=0;
            team.Type__c='Participant';
            insert team;
            list<EA_Team_Member__c> teamList = new list<EA_Team_Member__c>();
            teamList.add(team);
            System.assertEquals('test.comments', team.Feedback_Comments__c);
              Test.startTest();
            // EA_Feedback_Controller feed=new EA_Feedback_Controller(); // June 16 - SONAR Fix
            List<Everyday_Activity__c> temp1=EA_Feedback_Controller.getactivitydetail(event.id); 
            System.assert(temp1 != null);
            EA_Feedback_Controller.updateActivityRating(event.id);
           
            List<Everyday_Activity__c>temp=EA_Feedback_Controller.provideRating(event.id,2);
            System.assert(temp != null); 
            try{
            EA_Feedback_Controller.submitRating(event.id,team.Participant__c,123);
              }catch(exception e){  
              System.debug('Exception caught: ' + e.getMessage());}
            
            Test.stopTest();
            }
            }
            }