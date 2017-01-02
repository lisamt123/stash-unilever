/**********************************************************************
Name: TEL_AssignOpportunityOwner_Test
Copyright © 2016 Unilever
======================================================
Purpose: Class to test the class: TEL_AssignOpportunityOwner_Test.

History 
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	Ronaldo Garcia  	27/12/2016  Class Creation
***********************************************************************/
@isTest
public class TEL_AssignOpportunityOwner_Test {
	
    @testSetup
    public static void createData() {
        Profile prfObj 	= 	[Select Id From Profile Where Name =: 'Standard User'];
        	
        User	userObj	= 	new User(
        				  		Alias = 'teltest',
            					email = 'teltest@teltest.com',
            					EmailEncodingKey='UTF-8', 
            					LastName='Test', 
            					LanguageLocaleKey='en_US',
								LocaleSidKey='en_US', 
            					ProfileId = prfObj.Id,
								TimeZoneSidKey='America/Los_Angeles', 
            					UserName='teltestuser@teltest.com'
        					);
       	System.Database.insert(userObj);
        
        Opportunity oppObj 	= new Opportunity();
        oppObj.Name 		= 'Test';
        oppObj.StageName	= 'Pending Call';
        oppObj.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'TEL_Telesales' LIMIT 1].Id;
        oppObj.OwnerId		= userObj.Id;
        oppObj.CloseDate	= System.today().addDays(30);
        System.Database.insert(oppObj);
    }
    
    static testMethod void testAssignOppOwner() {
		Id oppId 				= [Select Id From Opportunity Where name = 'Test'].Id;
        String returnSuccess	= TEL_AssignOpportunityOwner.assignOppOwner(oppId);
    }
    
    static testMethod void testAssignOppOwnerCatch() {
        Id userId = [SELECT Id FROM User WHERE LastName = 'Test' LIMIT 1].Id;
        String returnSuccess = TEL_AssignOpportunityOwner.assignOppOwner(userId);
    }    
}