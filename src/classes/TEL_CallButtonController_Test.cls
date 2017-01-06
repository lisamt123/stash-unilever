/**********************************************************************
Name: TEL_CallButtonController_Test
Copyright © 2017 Unilever
======================================================
Purpose: Class to test the class: TEL_CaseTrigger_Test.

History 
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	Ronaldo Garcia  	03/01/2017  Class Creation
***********************************************************************/
@isTest
public class TEL_CallButtonController_Test {
    
    @testSetup
    public static void createData() {
        Account accObj 		= new Account();
        accObj.Name 		= 'Test';
        accObj.Phone 		= '+5512345678';
        insert accObj;
        
        Opportunity oppObj 	= new Opportunity();
        oppObj.Name 		= 'Opp 1';
        oppObj.AccountId 	= accObj.Id;
        oppObj.StageName 	= 'Transmitted';
        oppObj.CloseDate 	= Date.today().addDays(15);
        insert oppObj;
    }
    
    // Validate call handler number. 
    static testMethod void retrieveCallNumberTest(){  
    	System.Test.startTest();
        
        Opportunity opp 		= [SELECT Id FROM Opportunity Where Name =: 'Opp 1' LIMIT 1];
        String 		callNumber 	= TEL_CallButtonController.getCallNumber(opp.Id);
        
        System.assert(callNumber != null);
        System.Test.stopTest();
    	
    }
}