/**********************************************************************
Name: CEC_ClearAlertTrackerItem_BatchScheduler
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: An Batch class to delete alert tracker items when retention date
is reached .
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Masood Ansari     Feb-2016      INITIAL DEVELOPMENT   

***********************************************************************/
global class CEC_ClearAlertTrackerItem_BatchScheduler implements Database.Batchable<sObject>,Schedulable  {
    
    String query;
    
    CEC_AlertHelper clearAlertHelper;
    
    global CEC_ClearAlertTrackerItem_BatchScheduler() {
        clearAlertHelper = new CEC_AlertHelper();
    }
    
    // Mandatory method to be implemented for the Schedulable interface implementation
    global void execute(SchedulableContext sc) {
        // Call the batchable class
        try {
            CEC_ClearAlertTrackerItem_BatchScheduler clearAlertData = new CEC_ClearAlertTrackerItem_BatchScheduler();
            database.executebatch(clearAlertData);
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN SCHEDULING THE ALERT TRACKER ITEM DELETION BATCH APEX JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Scheduling Apex Job Failed');
            System.debug(msgBodyStr);
        }
    }
    
    // Mandatory method to be implemented for the batchable interface implementation.
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date alertCreationDate = clearAlertHelper.fetchCreatedDate();
        System.debug('@@@alertCreationDate '+ alertCreationDate);
        query = 'Select id from cec_Alert_Tracker_Item__c where CreatedDate <=: alertCreationDate';
        return Database.getQueryLocator(query);
    }
    
    // Mandatory method to be implemented for the batchable interface implementation to process the email alerts.
    global void execute(Database.BatchableContext BC, List<cec_Alert_Tracker_Item__c> scope) {
        try {
            System.debug('****Scope'+scope);
            clearAlertHelper.deleteAlertTrackerItem(scope);
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN PROCESSING THE ALERT TRACKER ITEM RECORDS IN THE BATCH JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Batch Job to process Alert Tracker Item deletion failed');
            System.debug(msgBodyStr);
        }        
    }
    
    global void finish(Database.BatchableContext BC) {
		
		// Calling the other batch class to delete Alert Tracker which has no Alert Tracker Item.
        CEC_ClearAlertTracker_Batch alertTrackerBatch = new CEC_ClearAlertTracker_Batch();
        database.executeBatch(alertTrackerBatch);
    }
    
    
}