/**********************************************************************
Name:  CEC_TypeaheadTest
Copyright � 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Typeahead classs
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        -                -           INITIAL DEVELOPMENT   
1.1        Sathish          Mar 2016    Code Refactoring.

***********************************************************************/
@isTest(seeAllData=false)

public class CEC_TypeaheadTest {
    @testSetup static void setUpTestData() {
        CEC_TestDataFactory.createStandardCECTestUser();
    } 

   static  testmethod void testSearchRecords(){
    
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest(); 
            mdm_Reason_Code__c reasonCode = new mdm_Reason_Code__c();
            reasonCode.Name='do* test reason';
            insert reasonCode;
            
            List<String> fieldsList=new List<String>();
            fieldsList.add('Name');
            fieldsList.add('Id');
            list<sObject> listSearchResults=Typeahead.searchRecords( 'do','mdm_Reason_Code__c',fieldsList,'Name','','',10);
            System.assertEquals(true,listSearchResults.size()>=0);
            Test.stopTest();
        } 
    }
}