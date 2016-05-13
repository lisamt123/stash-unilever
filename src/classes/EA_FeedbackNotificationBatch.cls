/*
Class Name: EA_Feedback_Controller.cls
Author : Mindtree
Date: 27th Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Batch apex to send scheduled feedback reminders.
*/
global with sharing class EA_FeedbackNotificationBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){           
        String status = 'Self';
        dateTime whenDay = system.today()-1;
        //dateTime nowDay = system.now();
        String q = 'SELECT Activity_Due_Date__c,Id,Invitation_Status__c,Participant__c,Everyday_Activity__c FROM EA_Team_Member__c WHERE Invitation_Status__c =: status AND Activity_Due_Date__c =: whenDay';      
        return Database.getQueryLocator(q);
    }      
    global void execute(Database.BatchableContext BC, List<EA_Team_Member__c>scope){ 
                   
        if(scope != null && scope.size()>0){ 
                          
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput(); 
            
             
            List<Everyday_Activity__c> acts = new List<Everyday_Activity__c>();
                      
            Map<ID,String> actIdTOName = new Map<ID,String>();
           
            Set<ID> actIDs = new Set<ID>();  
                               
            for(EA_Team_Member__c tmObj : scope){  
                             
                actIDs.add(tmObj.Everyday_Activity__c);
            }           
            acts = [SELECT id, Name FROM Everyday_Activity__c WHERE ID IN: actIDs];   
                    
            for(Everyday_Activity__c  eaObj : acts){  
                         
                actIdTOName.put(eaObj.id,eaObj.Name);
            }
            
            List<FeedItem> feedList = new List<FeedItem>(); 
            
            String chatterSupportUserID = '';
             if(Test.isRunningTest()){
                 
                    User userObj = [SELECT id, Name FROM User WHERE Name =: 'Chatter Support'];
                    chatterSupportUserID = userObj.id;
            }
            else{
                    
                    chatterSupportUserID = EA_ReportingGA__c.getInstance('EA_System_User_ID').Text_Value__c;
                }
                      
            for(EA_Team_Member__c tmObj : scope){
                            
                if(tmObj.Invitation_Status__c == EA_Constants.INVITATION_STATUS_SELF){                   
                    
                    string actName = actIdTOName.get(tmObj.Everyday_Activity__c);
                    string userid= tmObj.Participant__c;                   
                    FeedItem newFeed=new FeedItem();               
                    newFeed.CreatedById = chatterSupportUserID;
                    newFeed.Body = 'Please provide feedback for "'+ actName+'" activity from Everyday Actions on Salesforce1 app. Your feedback help others.';
                    newFeed.ParentId =userid ;
                    newFeed.Type = 'TextPost';
                    feedList.add(newFeed);                    
                }
                
            }
            
            if(feedList != null && feedList.size()>0){
                
                insert feedList;
            }
        }                    
    }    
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}