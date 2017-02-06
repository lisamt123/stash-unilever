/***************************************************************
Name: UL_PromotionClosureBatch
======================================================
Purpose:
Handle closure of promotions in batches
======================================================
History
-------
VERSION     AUTHOR			DATE             DETAIL                 Description
1.0         Marcel Schulz	18/01/2017       Initial Development    Handle closure of promotions in batches
***************************************************************/

global class UL_PromotionClosureBatch implements Database.batchable<SObject>, Database.Stateful { 
	global Boolean successful = true;
	global List<String> failedMsgs = new List<String>();
	global List<ACCL__Promotion__c> promos;
	
	global UL_PromotionClosureBatch(List<ACCL__Promotion__c> promos){
		this.promos = promos;
	}
	
    /*******************************************************************
    Purpose: get the promotion scope 
    Version 1.0
    Parameters: 
    Returns: QueryLocator
    Throws : N/A 
    ********************************************************************/   
	global Database.QueryLocator start(Database.BatchableContext info){
        
        //main soql
		return Database.getQueryLocator([Select Id From ACCL__Promotion__c Where Id IN: promos LIMIT 1000000]);
	}     
	
    /*******************************************************************
    Purpose: execute the Promotion closure per batch
    Version 1.0
    Parameters: List<ACCL__Promotion__c>
    Returns: void
    Throws : N/A 
    ********************************************************************/ 
	global void execute(Database.BatchableContext info, List<ACCL__Promotion__c> cPromos){
		
		
        for (ACCL__Promotion__c cPromo: cPromos){
            cPromo.UL_Closed__c = true;
        }
        Database.update(cPromos,false);
        for (Database.SaveResult sr :Database.update(cPromos,false)){
            if (!sr.isSuccess()) {
                successful=false;
                for(Database.Error err : sr.getErrors()) {
	   				failedMsgs.add(err.getMessage() + UL_Utility.SPACE + UL_Utility.SPACE + err.getFields());
                }
            }
	   	}
        

	}     
	
	/*******************************************************************
    Purpose: send email in case there was an issue
    Version 1.0
    Parameters: 
    Returns: void
    Throws : N/A 
    ********************************************************************/   
	global void finish(Database.BatchableContext info){
		//if there were errors
		if (successful==false || Test.isRunningTest()){ 
			Messaging.SingleEmailMessage outbound = new Messaging.Singleemailmessage();
			String[] sendTo = new List<String>();
			//User Id is Id of user who scheduled the batch job
			for (User currentUser : [Select Email From User WHERE Id=:UserInfo.getUserId() LIMIT 1]){
				sendTo.add(currentUser.Email);
			}
			outbound.toAddresses = sendTo;
			outbound.setSubject('Batch job "UL_PromotionClosureBatch" failed');
   			String errorMessages = 'Error Messages: ';
			for (String currentMsg: failedMsgs) {
				errorMessages = errorMessages + UL_Utility.SPACE + UL_Utility.NEWLINE_CHAR + currentMsg;
			}
   			outbound.setHtmlBody(errorMessages);
            try {
   				Messaging.sendEmail(new Messaging.SingleEmailMessage[] {outbound});
            } catch (Exception e){
                UL_Utility.logError(e, UserInfo.getUserId());
            }
   		}
	} 
}