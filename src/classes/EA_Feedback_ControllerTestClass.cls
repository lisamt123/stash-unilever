/*
Class Name: EA_Feedback_ControllerTestClass
Author : Mindtree
Date: 22 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_Feedback_ControllerClass.
*/
@IsTest(SeeAllData=true)
public class EA_Feedback_ControllerTestClass{
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
              Test.startTest();
            
            string eventid=ApexPages.currentPage().getParameters().put('Id',event.id);
            EA_Feedback_Controller temp1=new EA_Feedback_Controller();
            List<Everyday_Activity__c> test2=EA_Feedback_Controller.getactivitydetail(eventid);
            EA_Feedback_Controller.submitRating(eventid, eventid, 123);
            boolean b1=EA_Feedback_Controller.submitFeedback(eventid,'test', 2);
            EA_Feedback_Controller.updateActivityRating(eventid);
            Test.stopTest();
            }
            }
            }