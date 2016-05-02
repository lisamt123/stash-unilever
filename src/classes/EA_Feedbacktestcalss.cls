/*
Class EA_FeedbackNotificationScheduler 
Author : Mindtree
Date: 28 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class EA_FeedbackNotificationScheduler .
*/
@isTest
        private class EA_Feedbacktestcalss {
           static testmethod void  testschedule(){
           Test.StartTest();
         EA_FeedbackNotificationScheduler sh1 = new EA_FeedbackNotificationScheduler ();      
         String sch = '0  00 1 3 * ?';
           system.schedule('Test', sch, sh1);
         List<EA_Team_Member__c > objectList = new List<EA_Team_Member__c >(); 
        System.assertEquals('0  00 1 3 * ?',  sch);
        Test.stopTest();
     }
    
    }