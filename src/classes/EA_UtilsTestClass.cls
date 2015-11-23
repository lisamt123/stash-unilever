/*
Class Name: EA_UtilsTestClass
Author : Mindtree
Date: 22 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_UtilsClass.
*/
@IsTest(SeeAllData=true)
public class EA_UtilsTestClass{
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
             EA_Team_Member__c team1=new  EA_Team_Member__c();
           team1=[Select id,Everyday_Activity__r.RecordTypeId,Type__c,Activity_Points__c,Invited_By__c,Rating_By_Participant__c,Participant__c,Invitation_Status__c,Feedback_Comments__c,Activity_Due_Day__c  From EA_Team_Member__c where id=:team.id];
           update team1;
            System.assertEquals('test', team.Feedback_Comments__c);
              Test.startTest();
            string userid=ApexPages.currentPage().getParameters().put('Id',localUser.id);
            string eventid=ApexPages.currentPage().getParameters().put('Id',event.id);
            string inviteid=ApexPages.currentPage().getParameters().put('Id',team.Invited_By__c);
            string partid=ApexPages.currentPage().getParameters().put('Id',team.Participant__c);
            EA_Utils EAnote=new EA_Utils();
            boolean temp1=EA_Utils.isEmpty('test');
            Everyday_Activity__c ea=EA_Utils.getActivitydetails(eventid);
            EA_Utils.postCommentAtUserFeed(eventid,userid, 'test');
            List<EA_Team_Member__c> temp2=EA_Utils.getTeamMebersForActivity(eventid);
            Integer t1=EA_Utils.getactivityRating(10.2);
            EA_Team_Member__c temp3=EA_Utils.getParticipantTeamMemberRec(eventid,partid);
            //EA_Utils.postOnChatter(eventid,'test');
           
            }
            }
            }