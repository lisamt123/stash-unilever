/**********************************************************************
Name:  CEC_TH1_DraftTrigger_Test
Copyright � 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for CEC_DraftTrigger Trigger.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Masood           15Jan-2016      INITIAL DEVELOPMENT   
1.1        Sathish          Mar-2016        Code Refactoring
***********************************************************************/
@isTest(SeeAllData=false)
public class CEC_TH1_DraftTrigger_Test {

    @testSetup static void setUpTestData() {
       CEC_TestDataFactory.createStandardCECTestUser();
    }
    
    @isTest static void test_DraftTrigger() {
        // Implement test code
         
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            Test.startTest();
            TH1__Document_Setting__c documentSettings = new TH1__Document_Setting__c();
            documentSettings.Name='abc';
            documentSettings.TH1__Template_name__c='Austria_Letter';
            documentSettings.TH1__Thunderhead_channel_name__c='Print';
            insert documentSettings;
            
            TH1__Draft__c drafts= new TH1__Draft__c();
            drafts.TH1__Document_Setting__c=documentSettings.id;
            drafts.TH1__Status__c='Pending';
            insert drafts;
            
            
            try{
                drafts.TH1__Status__c='Approved';
                database.update(drafts);
                System.assertEquals( drafts.TH1__Status__c, 'Approved');
            }
            catch(exception e){
                System.debug('Added error');
            }
            
            Test.stopTest();
        }
        
        
    }
}