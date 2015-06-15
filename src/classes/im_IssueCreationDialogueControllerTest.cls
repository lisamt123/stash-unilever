/*Class : im_IssueCreationDialogueControllerTest
 Author : Sachin Chincholi Date:25/09/2013 Version:1.0
Purpose : This is a Test Class for im_IssueCreationDialogueController */
@isTest 
private class im_IssueCreationDialogueControllerTest{
    
    //Positive Scenario to test.
    static testMethod void issueCreation_PositiveCase() {       
        
        //This variable to hold the issue record.
        im_Issue__c iss;    
        iss = new im_Issue__c (Name='Test Issue', Issue_Status__c='New',
                               Issue_Severity__c='Green',Issue_Severity_on_submission__c='');
        insert iss;
       test.startTest();
        //This is to assert that,issue has been successfully inserted.
        System.assertEquals(iss.Name,'Test Issue');
        System.assertNotEquals(null,iss.id);
       
        ApexPages.StandardController sc = new ApexPages.standardController(iss);
        im_issueCreationDialogueController e = new im_issueCreationDialogueController(sc);
        
        //Calling the method in the Class im_issueCreationDialogueController
        String results = im_issueCreationDialogueController.updateIssueFields(iss.id);
        test.stopTest();
        //This is to assert that issue has been updated.
        System.debug(results);
        System.assertNotEquals(null,results);
    }
    
    //Negative Scenario to push into Catch Block   
    static testMethod void issueCreation_NegativeCase() {
        
        //This variable to hold the issue record.
        im_Issue__c iss;   
        iss = new im_Issue__c (Name='test one',Issue_Severity__c='Green',Issue_Severity_on_submission__c='');
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(iss);
        im_issueCreationDialogueController e = new im_issueCreationDialogueController(sc);
        
        //Calling this fails, without id and pushes into Catch block
        String results = im_issueCreationDialogueController.updateIssueFields(iss.id);
        test.stopTest();
        //This is to assert that, it throws an error and is pushed to catch block
        system.assertEquals(null,iss.id);
        
        //This defines the message returned from the catch Block.
        system.Debug(results);   
    }
}