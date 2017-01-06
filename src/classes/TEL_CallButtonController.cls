/**********************************************************************
Name: TEL_CallButtonController
Copyright © 2017 Unilever

Purpose:
Handles call phone info to make a call to external app. 

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Ronaldo Garcia  03/01/2017  Class creation  
**********************************************************************/
public with sharing class TEL_CallButtonController {

    // Retrieve the account phone. 
    @AuraEnabled 
    public static String getCallNumber(Id paraOppId){
      	System.debug('Entering <getCallNumber>');

        // Store the call number to be returned. 
        String callNumber = [Select Account.Phone From Opportunity Where Id =: paraOppId].Account.Phone;

        System.debug('Exit <getCallNumber>');
    	return callNumber;
    }
}