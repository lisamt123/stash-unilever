/*
Class Name: EA_Utils_Test
Author : Mindtree
Date: 22 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_UtilsClass.
*/
@IsTest
public class EA_Utils_Test{
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
            team.Invitation_Status__c='Invited';
            team.Invitation_Text__c='test';
            team.Invited_By__c=localUser.id;
            team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
            
            EA_Team_Member__c team2 =new EA_Team_Member__c();
            team2.Activity_Due_Day__c='Today';
            team2.Activity_Points__c=5;
            team2.Everyday_Activity__c=event.id;
            team2.Feedback_Comments__c='test.comments';
            team2.Invitation_Status__c='Accepted';
            team2.Invitation_Text__c='test';
            team2.Invited_By__c=localUser.id;
            team2.Participant__c=localUser.id;
            team2.Rating_By_Participant__c=4;
            team2.Type__c='Participant';
            insert team2;
           
            
             // EA_Team_Member__c team1=new  EA_Team_Member__c(); // June 16 - SONAR Fix
             List<SObject>  lstActivity =new List<SObject>();
             lstActivity.add(team);
             EA_ReportingGA__c report=new EA_ReportingGA__c();
             report.Name='EAreport';
             report.Text_value__c='dummyvalue';
             insert report;
             
                  Test.startTest();
            
            // EA_Utils EAnote=new EA_Utils(); // June 16 - SONAR Fix
             boolean temp1=EA_Utils.isEmpty(lstActivity );
             System.assertEquals(temp1, false);
             lstActivity.clear();
             boolean temp2=EA_Utils.isEmpty(lstActivity );
             System.assertEquals(temp2, true);
             boolean temp3=EA_Utils.isEmpty('true');
             System.assertEquals(temp3, true);
             boolean temp4=EA_Utils.isEmpty('');
             System.assertEquals(temp4, false);
             
            Everyday_Activity__c ea=EA_Utils.getActivitydetails(event.id);
            System.assert(ea != null);
           try{
           EA_Utils.postCommentAtUserFeed('team.id','team2.Invited_By__c','team2.Participant__c','postcomment');
          // EA_Utils.postCommentAtUserFeed(null,null,null,null);
           }catch(exception e){ System.debug('Exception caught: ' + e.getMessage());}
            List<EA_Team_Member__c> temp33=EA_Utils.getTeamMebersForActivity(event.id);
            System.assert(temp33 != null);
            Integer t1=EA_Utils.getactivityRating(10.2);
            System.assertEquals(t1, 10);
            Integer t11=EA_Utils.getactivityRating(10.7);
            System.assertEquals(t11, 11);
            EA_Team_Member__c temp44=EA_Utils.getParticipantTeamMemberRec(event.id,team.Participant__c);
            System.assert(temp44 != null);
            EA_Utils.postOnChatter(event.id,'test');
           
            }
            }
            }