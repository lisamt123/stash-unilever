@isTest
public class im_IssueTriggerHandlerTest {
    
    static testMethod void testim_IssueTriggerHandler(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='test@email.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testuser@testmethod.unilever.kof');
        
        User testUser2 = new User(Alias = 'standt', Email='test@email.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testuser@testmethod.unilever.kof2');
        insert testUser2;
        
        system.runAs(testUser)
        {
            // Create an issue
            im_Issue__c testIssue = new im_Issue__c();
            testIssue.Name = 'Test Issue';
            testIssue.Issue_Status__c = 'Reviewed';
            testIssue.Issue_Severity__c = 'Green';
            insert testIssue;
            system.assertNotEquals(testIssue,null,'Issue wasn\'t created successfully.');
            
            // Try and change the status
            try { 
                testIssue.Issue_Status__c = 'New';
                update testIssue; 
            }
            catch (Exception ex) { 
                // Update fail expected. Reset back to original status
                testIssue.Issue_Status__c = 'Reviewed';
            }
            system.assertNotEquals([Select Issue_Status__c From im_Issue__c Where Id = :testIssue.Id][0].Issue_Status__c,'New','Issue status should not have changed');
            
            
            // Try and change the severity
            try { 
                testIssue.Issue_Severity__c = 'Blue';
                update testIssue; 
            }
            catch (Exception ex) { 
                // Update fail expected. Reset to original status
                testIssue.Issue_Severity__c = 'Green';
                
            }
            system.assertNotEquals([Select Issue_Severity__c From im_Issue__c Where Id = :testIssue.Id][0].Issue_Severity__c,'Blue','Issue severity should not have changed');
            
            
            // re-query for iss
            
            // Try and change the owner
            try { 
                testIssue.OwnerId = testUser2.Id;
                update testIssue; 
            }
            catch (Exception ex) { 
            System.debug('Exception ' + ex);
                // Update fail expected
            }
            system.assertNotEquals([Select OwnerId From im_Issue__c Where Id = :testIssue.Id][0].OwnerId,testUser2.Id,'Issue owner should not have changed');
            
        }

    }

}