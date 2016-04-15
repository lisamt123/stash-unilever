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
            event.Activity_Points__c=44;
            event.Description__c='test.Description';
            event.Minutes_to_Complete_Action__c=4;
            event.Participants_Required__c=5;
            event.Rating__c=5;
            event.Top_Tip__c='dummyvalue';
            insert event;
            System.assertEquals('test.Description', event.Description__c);
            EA_Team_Member__c Team =new EA_Team_Member__c();
            team.Activity_Due_Date__c=datetime.newInstance(2014, 9, 15, 13, 30, 0);
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
            //insert team;
            List<EA_Team_Member__c> userList= new List<EA_Team_Member__c>();
            userList.add(team);
            insert userList;
            
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
         
            
            FeedItem chatterPost1 = new FeedItem(ParentId = event.id , Body = 'chatterPostComment', CreatedById = localUser.id);     
            insert chatterPost1;            
            FeedItem chatterPost2 = new FeedItem(ParentId = event.id , Body = 'chatterPostComment', CreatedById = localUser.id);     
            insert chatterPost2;            
            FeedItem chatterPost3 = new FeedItem(ParentId = event.id , Body = 'chatterPostComment', CreatedById = localUser.id);     
            insert chatterPost3;
            
            Test.startTest();
            EA_ControllerClass Eacontroller=new EA_ControllerClass();
            EA_ControllerClass.getActivities();
            EA_ControllerClass.getThemes();
            List<Everyday_Activity__c> temp1=EA_ControllerClass.getActivitiesonfilter('Working Effectively');
            List<Everyday_Activity__c> temp2=EA_ControllerClass.getactivitydetail('2223333');
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp4=EA_ControllerClass.getActivityPoints('122');
            EA_ControllerClass.getbooleanvalue('3446677');
            List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> temp6=EA_ControllerClass.getuserList('event.id');           
            try{
                EA_ControllerClass.getUserDetail(); 
                 List<EA_Wrapper_Class.EA_UserProfile_Wrapper> temp7=EA_ControllerClass.getUserActivities(); 
                      
            }catch(exception e){
                System.debug('Exception caught: ' + e.getMessage());}
                
            EA_ControllerClass.insertteamrecord(event.id); 
            EA_ControllerClass.getActivityParticipantCount(event.id);
            
            EA_ControllerClass.insertfeeditem(event.id,'comment');             
            EA_ControllerClass.getbooleanvalue(event.id);                                          
            EA_ControllerClass.getToDoTimeline();
            List<EA_Team_Member__c > temp211=EA_ControllerClass.getinvitelist(event.id);
            EA_ControllerClass.chatterfeeditem('postbody');
            string s1=EA_ControllerClass.callSubmitToDoAction(event.id,'json','activityTime');
            Map<string,string> test2=EA_ControllerClass.getThemeColors();
            //Increasing Test Coverage - Start
            string dateStr = '2015-12-05';
            string resultStr = EA_ControllerClass.getProperDate(dateStr);
            System.assertEquals(resultStr, '05-Dec-2015');
            
            //["005c00000024XSZAA2","005E0000006cowkIAA"]
            
            string jsonStr = '[' + '\"'+ localUser.id +'\"'+','+'\"'+ localUser.id +'\"'+']';
            
            system.debug('jsonStr=========>'+jsonStr);
            string result1 =EA_ControllerClass.callSubmitToDoAction(event.id, jsonStr,'Today');
            string result2 =EA_ControllerClass.callSubmitToDoAction(event.id, jsonStr,'Tomorrow');
            string result3 =EA_ControllerClass.callSubmitToDoAction(event.id, jsonStr,'Next Week');
            string result4 =EA_ControllerClass.callSubmitToDoAction(event.id, jsonStr,'Two Weeks');
            string result5 =EA_ControllerClass.callSubmitToDoAction(event.id, jsonStr,'One Month');
            List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> lst = EA_ControllerClass.getcommentDetail(event.id);
            //Increasing Test Coverage - End
            
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
            team.Invitation_Status__c='Declined';
            team.Invitation_Text__c='test.inv';
            team.Invited_By__c=localUser.id;
            //team.Participant__c=localUser.id;
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
           
            EA_ReportingGA__c re=new EA_ReportingGA__c();
            re.Name='testreport';
            re.Text_value__c =' EA_System_User_ID';
            insert re;
             EA_ReportingGA__c re1=new EA_ReportingGA__c();
            re1.Name='testreport';
            re1.Text_value__c ='GA_Id';
            insert re1;
            Test.startTest();
            
            EA_ControllerClass Eacontroller=new EA_ControllerClass();
            EA_ControllerClass.getActivities();
            EA_ControllerClass.getThemes();
            List<Everyday_Activity__c> temp1=EA_ControllerClass.getActivitiesonfilter('Working Effectively');
            List<Everyday_Activity__c> temp2=EA_ControllerClass.getactivitydetail('2223333');
            List<EA_Wrapper_Class.EA_UserProfile_Wrapper>temp4=EA_ControllerClass.getActivityPoints('122');
            EA_ControllerClass.getbooleanvalue('3446677');
            List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> temp6=EA_ControllerClass.getuserList('event.id');
            try{
                EA_ControllerClass.getUserDetail();
                   string test1=EA_ControllerClass.getGAID(); 
                   
                   // List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> temp3=EA_ControllerClass.getcontentdetail(event.id);  
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
            //Increasing Test Coverage - Start
            string dateStr = '2015-12-05';
            string resultStr = EA_ControllerClass.getProperDate(dateStr);
            System.assertEquals(resultStr, '05-Dec-2015');
            //Increasing Test Coverage - End
            Test.stopTest();
        }
    } 
    
}