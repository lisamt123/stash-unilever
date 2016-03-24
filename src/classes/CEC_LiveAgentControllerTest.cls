/**********************************************************************
Name:  CEC_LiveAgentControllerTest()
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class for CEC_LiveAgentController Apex class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sreya           Jan-2016      INITIAL DEVELOPMENT   
1.1      Sathish         May-2016       Code Refactoring.
***********************************************************************/

@isTest(SeeAllData = False)
public class CEC_LiveAgentControllerTest{

    @testSetup static void setUpTestData() {
        User u = CEC_TestDataFactory.createStandardCECTestUser();
     } 
    
/**
Positive test for fetchRecords method
**/  
    public static testMethod void test_fetchrecords_positive(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
                        
            CEC_LiveAgentController ControllerObj = new CEC_LiveAgentController();                    
            ControllerObj.chatKey = 'TestKey';
            ControllerObj.surveyId = 'ThisIsUnitTestMethodRunning';
            
            Test.startTest();
            PageReference reference = ControllerObj.takeSurvey();           
            String referenceURL = reference.getUrl();
     
            System.assert(referenceURL.contains('clicktools'));            
            Test.stopTest();
            
        }         
    }
    
/**
Negetive test for  fetchRecords method
**/  
    public static testMethod void test_fetchrecords_Negative(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
                        
            CEC_LiveAgentController ControllerObj = new CEC_LiveAgentController();                    
            ControllerObj.chatKey = 'TestKey';
            ControllerObj.surveyId = '';
            
            Test.startTest();
                PageReference reference = ControllerObj.takeSurvey();
     
                System.assertEquals(null,reference);            
            Test.stopTest();
            
        }         
    }
}