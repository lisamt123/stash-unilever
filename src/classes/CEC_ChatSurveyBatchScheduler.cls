/***********************************************************************************
Name:  CEC_ChatSurveyBatchScheduler
Copyright@: 2016  Unilever
====================================================================================
====================================================================================
Purpose: A scheduler and batch class to update Case Id in the Survey records created 
by Live Chat.
=====================================================================================
=====================================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            		DATE            DETAIL                   
1.0      Goverdhan & Sathish        Feb-2016      Initial Development.   
*************************************************************************************/
global class CEC_ChatSurveyBatchScheduler implements Database.Batchable<sObject>, Schedulable {
	
	String query;

	CEC_ChatSurveyHelper chatSurveyHelper;
	
	global CEC_ChatSurveyBatchScheduler() {
		chatSurveyHelper = new CEC_ChatSurveyHelper();
	}
	
    /******************************************************************* 
        Purpose: 
            Mandatory method for Batchable interface to get the survey records
            to process which has chatKey and no case id information.
    ********************************************************************/
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = 'SELECT id, Case__c, ChatKey__c FROM cec_Additional_Case_Information__c WHERE (Case__c = null OR Case__c = \'\') AND ChatKey__c != null AND isDeleted = false';
		return Database.getQueryLocator(query);
	}

    /******************************************************************* 
        Purpose: 
            Mandatory method for Batchable interface to process the survey records
            to process which has chatKey and no case id information.
    ********************************************************************/
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		try {
			System.debug('Entering execute method : Scope = ' + scope);
            chatSurveyHelper.fetchAndUpdateSurveyRecords(scope);  
        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN PROCESSING THE CHAT SURVEY IN THE BATCH JOB *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Processing batch Job for chat survey failed');
            System.debug(msgBodyStr);
        }     
	}
	
    /******************************************************************* 
        Purpose: 
            Mandatory method for Batchable interface. No action required.
    ********************************************************************/
	global void finish(Database.BatchableContext BC) {
		
	}

    /******************************************************************* 
        Purpose: 
            Mandatory method for Schedulable interface to call the batch class.
    ********************************************************************/
	global void execute(SchedulableContext sc) {
        try {
            CEC_ChatSurveyBatchScheduler chatSurveyBatch = new CEC_ChatSurveyBatchScheduler();
            database.executebatch(chatSurveyBatch);

        } catch(Exception e) {
            String msgBodyStr = '*** ERROR IN EXECUTION IN THE CEC CHAT BATCH SURVEY SCHEDULER CLASS *** \n \n URL:: ' + URL.getSalesforceBaseUrl().toExternalForm() + '\n \n Details :: ' + e.getMessage();
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Execution in Apex Scheduler Class CEC_ChatSurveyBatchScheduler Failed');
            System.debug(msgBodyStr);
        }
	}
	
}