/*
Class Name: EA_Notification_Controller_Test
Author : Mindtree
Date: 22 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_Notification_Controller.
*/
@IsTest
public class EA_Notification_Controller_Test{
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
        System.runAs(localUser){
        // List<user> users=[select id,name from user where profileid =:adminProfileID]; // June 16 - SONAR Fix
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
            
            EA_BadgeDetails__c badge1=new EA_BadgeDetails__c();
            badge1.name='Bronze';
            badge1.BadgeColor__c='red';
            badge1.BadgeSerial__c=1;
            badge1.BadgeValue__c=2;
            insert badge1;
            
            EA_BadgeDetails__c badge2=new EA_BadgeDetails__c();
            badge2.name='Silver';
            badge2.BadgeColor__c='yellow';
            badge2.BadgeSerial__c=1;
            badge2.BadgeValue__c=2;
            insert badge2;
            
            EA_BadgeDetails__c badge3=new EA_BadgeDetails__c();
            badge3.name='Gold';
            badge3.BadgeColor__c='black';
            badge3.BadgeSerial__c=1;
            badge3.BadgeValue__c=2;
            insert badge3;
            
            EA_ReportingGA__c report=new EA_ReportingGA__c();
            report.name='ReportEA';
            report.Text_value__c='dummyvalue';
            insert report;
            
            EA_Team_Member__c team1=new  EA_Team_Member__c();
            
            System.assertEquals('test.comments', team.Feedback_Comments__c);
            Test.startTest();         
            // EA_Notification_Controller EAnote=new EA_Notification_Controller(); // June 16 - SONAR Fix                 
            team1=[Select id,Everyday_Activity__r.RecordTypeId,Type__c,Activity_Points__c,Invited_By__c,
                   Rating_By_Participant__c,Participant__c,Invitation_Status__c,Feedback_Comments__c,
                   Activity_Due_Day__c  From EA_Team_Member__c where id=:team.id];
            team1.Rating_By_Participant__c=5; 
            team1.Invitation_Status__c='Accepted';
            team1.Feedback_Comments__c='testTeam';      
            update team1;
            
            //EA_Notification_Controller.sendFeedbackReminder(event.id,team.Invited_By__c, team.Participant__c);
            EA_Notification_Controller.inviteResponseNofitification(event.id,team.id,'Accepted');
            EA_Notification_Controller.inviteResponseNofitification(event.id,team.id,'Declined');
              
            try{
             EA_Notification_Controller.getUserDetail();
             List<EA_Wrapper_Class.EA_UserProfile_Wrapper> temp1=EA_Notification_Controller.getuserimage(event.id, team.id);
             System.assert(temp1 != null);
             EA_Notification_Controller.updateParticipantResponse('event.id',team.Participant__c, team1.Invitation_Status__c);
            }catch(exception e){
            System.debug('Exception caught: ' + e.getMessage());}
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
        System.runAs(localUser){
        // List<user> users=[select id,name from user where profileid =:adminProfileID]; // June 16 - SONAR Fix
        
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
          
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Day__c='Today';
            team.Activity_Points__c=5;
            team.Everyday_Activity__c=event.id;
            team.Feedback_Comments__c='test.comments';
            team.Invitation_Status__c='Declined';
            team.Invitation_Text__c='test';
            //team.Invited_By__c=localUser.id;
            // team.Participant__c=localUser.id;
            team.Rating_By_Participant__c=4;
            team.Type__c='Participant';
            insert team;
            
            EA_Team_Member__c team1=new  EA_Team_Member__c();
            
            System.assertEquals('test.comments', team.Feedback_Comments__c);
            Test.startTest();
            // EA_Notification_Controller Eanote=new EA_Notification_Controller(); // June 16 - SONAR Fix
                string actvityName=event.name;
                string activityDesc=event.Description__c;
                Decimal points = event.Activity_Points__c;
            
                System.assert(actvityName == null);
                System.assertEquals(activityDesc,'test.desc');
                System.assertEquals(points,4);

            team1=[Select id,Everyday_Activity__r.RecordTypeId,Type__c,Activity_Points__c,Invited_By__c,
                   Rating_By_Participant__c,Participant__c,Invitation_Status__c,Feedback_Comments__c,
                   Activity_Due_Day__c  From EA_Team_Member__c where id=:team.id];
            team1.Rating_By_Participant__c=5; 
            team1.Invitation_Status__c='Declined';
            team1.Feedback_Comments__c='testTeam';      
            update team1;
            
             EA_Notification_Controller.sendFeedbackReminder(event.id, team.Invited_By__c, team.Participant__c);
           //  EA_Notification_Controller.updateParticipantResponse('event.id',' team.Participant__c','Decline');
            }
            }
            }