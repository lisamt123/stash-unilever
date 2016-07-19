/**********************************************************************
 Name:  CEC_AlertActionBatch
 Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: An scheduler Batch class to execute alert actions 

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
  1.0      Sathish           Aug-2015      INITIAL DEVELOPMENT   

 ***********************************************************************/
global with sharing class CEC_AlertActionBatchScheduler implements Database.Batchable<sObject>,Schedulable {
    
    String query;

    CEC_BatchAlertActionHelper alertActionHelper;
    
    global CEC_AlertActionBatchScheduler() {
        alertActionHelper = new CEC_BatchAlertActionHelper();
    }

    // Mandatory method to be implemented for the Schedulable interface implementation
    global void execute(SchedulableContext sc) {
        // Call the batchable class
        try {
            CEC_AlertActionBatchScheduler alertActionBatch = new CEC_AlertActionBatchScheduler();
            database.executebatch(alertActionBatch);
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN SCHEDULING THE CEC ALERT ACTION BATCH APEX JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Scheduling Apex Job Failed');
            System.debug(msgBodyStr);
        }
    }
    
    // Mandatory method to be implemented for the batchable interface implementation.
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'SELECT Id, Current_Threshold__c, Alert_Threshold__c, Alert_Rule_Id__c, Name, Product_No_Size__c, L5_Reason_Code__c, Trigger_Batch__c FROM cec_Alert_Tracker__c WHERE Trigger_Batch__c = true';
        return Database.getQueryLocator(query);
    }

    // Mandatory method to be implemented for the batchable interface implementation to process the email alerts.
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try {
            alertActionHelper.executeAction(scope);  
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN PROCESSING THE ALERT EMAILS IN THE BATCH JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Batch Job to send Alert Emails failed');
            System.debug(msgBodyStr);
        }        
    }
    
    global void finish(Database.BatchableContext BC) {
        // No action required
    }

    // Start the scheduler based on the minute settings configured in the custom settings.
    public static void startScheduler() {
        try {
            String jobName, minutes, scheduleTimeExpr;
            cec_Org_Settings__c cp = cec_Org_Settings__c.getOrgDefaults();
            String timeSettings = cp.AlertAction_Time_Scheduler__c; 
            if (timeSettings != null && timeSettings != '') {
                String[] timeSettingsArr = timeSettings.split(';');
                System.debug('Time settings Array :: '+ timeSettingsArr);
                for(Integer i=0; i < timeSettingsArr.size(); i++){
                    minutes = timeSettingsArr[i];
                    jobName = Label.CEC_AlertActionSchedulerName + ' @' + minutes + 'th minute';
                    scheduleTimeExpr = '0 ' + minutes + ' * * * ?';
                    System.debug('JobName :: ' + jobName);
                    System.debug('Time Expression :: ' + scheduleTimeExpr);
                    System.schedule(jobName , scheduleTimeExpr, new CEC_AlertActionBatchScheduler());       
                } 
            }
              
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN STARTING THE CEC ALERT ACTION SCHEDULER *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Starting the  Apex Job Scheduler Failed');
            System.debug(msgBodyStr);
        }

    }

    // Stop all the CEC Alert Action Scheduler jobs.
    public static void stopAllScheduler() {
        try {
            String cecNameFilter = Label.CEC_AlertActionSchedulerName + '%';
            List<CronTrigger> cecAsyncJobList = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger WHERE CronJobDetail.Name LIKE :cecNameFilter AND CronJobDetail.JobType = '7' AND (STATE = 'WAITING' OR STATE = 'RUNNING')];
            System.debug('The list of CEC Alert Action Jobs :: ' + cecAsyncJobList);
            for(CronTrigger ct : cecAsyncJobList){
                System.debug('Job :: ' + ct.id + ', Name :: ' + ct.CronJobDetail.Name);
                System.abortJob(ct.Id);
            }  
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN STOPING THE CEC ALERT ACTION SCHEDULER *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Stoping the  Apex Job Scheduler Failed');
            System.debug(msgBodyStr);
        }

    }
    
}