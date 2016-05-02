/*
Class Name:EA_FeedbackNotificationBatch 
Author : Mindtree
Date: 28 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class ForEA_FeedbackNotificationBatch .
*/


@isTest
private class EA_FeedbackNotificationBatchTestclass{


    static testmethod void testNotificationBatch() {
       
        List<Profile> profLst = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        ID adminProfileID = profLst[0].id; 
        
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
           
           
        
       List<EA_Team_Member__c> EA = new List<EA_Team_Member__c >();
       for (Integer i=0;i<10;i++) {
           EA_Team_Member__c team= new EA_Team_Member__c (
           Activity_Due_Date__c=system.today()-1,
            Activity_Due_Day__c='Today',
            Activity_Points__c=5,
            Everyday_Activity__c=event.id,
            Feedback_Comments__c='test',
            Invitation_Status__c='Self',
            Invitation_Text__c='test',
           Invited_By__c=localUser.id,
            Participant__c=localUser.id,
            Rating_By_Participant__c=4,
            Type__c='Participant');
           EA.add(team);
       }
       insert EA;
        
        

       Test.startTest();
       
           EA_FeedbackNotificationBatch  fnb = new EA_FeedbackNotificationBatch ();
          
           Id batchprocessId = Database.executeBatch(fnb);  
         
           
       Test.stopTest();

       
     } 
        
     }
}