/*
Class Name: EA_Feedback_Controller.cls
Author : Mindtree
Date: 27th Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Batch apex to send scheduled feedback reminders.
*/
global class EA_FeedbackNotificationBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){           
        String status = 'Self';
        dateTime whenDay = system.today()-1;
        String q = 'SELECT Activity_Due_Date__c,Id,Invitation_Status__c,Participant__c,Everyday_Activity__c FROM EA_Team_Member__c WHERE Invitation_Status__c =: status AND Activity_Due_Date__c >:whenDay';      
        return Database.getQueryLocator(q);
    }      
    global void execute(Database.BatchableContext BC, List<sObject>scope){            
        if(scope != null && scope.size()>0){               
            EA_Feedback_Controller.sendFeedbackReminder(scope);
        }                    
    }    
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}