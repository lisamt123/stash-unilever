global with sharing class EA_FeedbackNotificationScheduler Implements Schedulable {
        
    global void execute(SchedulableContext sc){
        
        EA_FeedbackNotificationBatch fnbObj = new EA_FeedbackNotificationBatch();
        database.executebatch(fnbObj,10);
    }

        
}