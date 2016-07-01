/*
Class EA_Feedbacktestcalss 
Author : Mindtree
Date: 28 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class EA_FeedbackNotificationScheduler .
*/
@isTest
private class EA_Feedbacktestcalss {
 static testMethod void postive() {
            Everyday_Activity__c  event=new Everyday_Activity__c();
            event.Active__c=true;
            event.Activity_Points__c=44;
            event.Description__c='test.Description';
            event.Minutes_to_Complete_Action__c=4;
            event.Participants_Required__c=5;
            event.Rating__c=5;
            event.Top_Tip__c='dummyvalue';
            insert event;
            
            System.assertNotEquals(event,null);
    }
    
}