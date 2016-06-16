/**********************************************************************
Name:  CEC_ClearAlertTracker_Batch
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: An batch class to delete alert tracker which does not
have nay alert tracker items
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Masood Ansari     Feb-2016     INITIAL DEVELOPMENT   

***********************************************************************/
global with sharing class CEC_ClearAlertTracker_Batch implements Database.Batchable<sObject>{
    
    String query;
    CEC_AlertHelper clearAlertHelper;
    global CEC_ClearAlertTracker_Batch() {
        clearAlertHelper = new CEC_AlertHelper();
    }
    // Mandatory method to be implemented for the batchable interface implementation.
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query ='SELECT Id FROM cec_Alert_Tracker__c where Alert_Tracker_Item_count__c = 0';
        return Database.getQueryLocator(query);
    }      
    
    // Mandatory method to be implemented for the batchable interface implementation to process the email alerts.
    global void execute(Database.BatchableContext BC, List<cec_Alert_Tracker__c> scope) {
        try {
            System.debug('****Scope'+scope);
            clearAlertHelper.deleteAlertTracker(scope);
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN PROCESSING THE ALERT TRACKER RECORDS IN THE BATCH JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Batch Job to process Alert Tracker deletion failed');
            System.debug(msgBodyStr); 
        }        
    }
    
    
    global void finish(Database.BatchableContext BC) {
        // No action required
    }
}