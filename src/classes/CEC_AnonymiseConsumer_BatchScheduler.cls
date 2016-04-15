/**********************************************************************
Name:  CEC_AnonymiseConsumer_BatchScheduler
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: An Batch class to anonymise consumer data when retention date
is reached 
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Masood Ansari     Dec-2015      INITIAL DEVELOPMENT   

***********************************************************************/
global class CEC_AnonymiseConsumer_BatchScheduler implements Database.Batchable<sObject>,Schedulable {
    
    String query;
    CEC_AnonymiseConsumerHelper anonymiseConsumerDataHelper;
    
    global CEC_AnonymiseConsumer_BatchScheduler() {
        anonymiseConsumerDataHelper = new CEC_AnonymiseConsumerHelper();
    }
    
    // Mandatory method to be implemented for the Schedulable interface implementation
    global void execute(SchedulableContext sc) {
        // Call the batchable class
        try {
            CEC_AnonymiseConsumer_BatchScheduler anonymiseConsumerData = new CEC_AnonymiseConsumer_BatchScheduler();
            database.executebatch(anonymiseConsumerData);
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN SCHEDULING THE ACCOUNT DATA UPDATION BATCH APEX JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Scheduling Apex Job Failed');
            System.debug(msgBodyStr);
        }
    }
    
    // Mandatory method to be implemented for the batchable interface implementation.
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        string personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        System.debug('***Record ID'+ personRecordTypeId );
        date d2 = System.today();
        System.debug('***Current date'+d2);
        query = 'SELECT Id,FirstName,LastName,PersonEmail,Phone,BillingStreet,BillingCity from Account where Retention_Date__c <:d2 AND Retention_Date__c !=null AND RecordTypeId =: personRecordTypeId AND Anonymise_check__c = true';
        return Database.getQueryLocator(query);
    }
    
    // Mandatory method to be implemented for the batchable interface implementation to process the email alerts.
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        try {
            System.debug('****Scope'+scope);
            anonymiseConsumerDataHelper.updateAccountInformation(scope);  
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN PROCESSING THE ACCOUNT RECORDS IN THE BATCH JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Batch Job to process Account Information failed');
            System.debug(msgBodyStr);
        }        
    }
    
    global void finish(Database.BatchableContext BC) {
        // No action required
    }
    
    
}