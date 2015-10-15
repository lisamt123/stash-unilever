/**********************************************************************
 Name:  HRO_BoardingAction_CXTest()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Test Class for HRO_BoardingAction_CX  class                                                       
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        08/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

@isTest
private class HRO_BoardingAction_CXTest {
    
	/*******************************************************************
   Purpose:  Testing task creation for new leader boarding                                                 
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	@isTest static void testCreatingPreBoardingTasks() {
        
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
        //List<HRO_Onboarding_Plan__c> leaderTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(false);
        insert managerTasksTemplate;
		
        
        PageReference pageRef = Page.HRO_PreBoardingActionPage;
		Test.setCurrentPage(pageRef);
		Test.startTest();
		
        //controller initilization
       
        HRO_BoardingAction_CX pageController = new HRO_BoardingAction_CX(new ApexPages.StandardController(managerTasksTemplate[0]));
        HRO_BoardingAction_CX pageSetController = new HRO_BoardingAction_CX(new ApexPages.StandardSetController(managerTasksTemplate));
        pageController.planInfo = new HRO_Onboarding_Plan__c();
        //pageController.planInfo.Manager__c = manager.id;
        pageController.planInfo.New_Leader__c = 'Test leader';
        pageController.planInfo.Start_Date__c = Date.today();
        pageController.getProfileUserId();
        pageController.getPreBoardingTasks();
        system.assertEquals(pageController.listOfTemplateTasks.isEmpty(),false,
                      'System shoud retrive template task check method HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks if creating task templates'); 
        pageController.savePreBoarding();
        //check if task were created for manager and he is the owner
        system.assertEquals([Select id FROM HRO_Onboarding_Task__c where ownerId = :UserInfo.getUserId()].isEmpty(),false,'System should create task for manager');
				
		Test.stopTest();

	}
	
}