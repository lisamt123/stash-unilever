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
        //Create HRO application user Manger and Admin
        User manager = HRO_UnitTestFactory.createUserManager('HROmanager');
        User adminUser = HRO_UnitTestFactory.createUserManager('HROAdmin');
        
        HRO_UnitTestFactory.addHROPermissions(manager, adminUser);
        
        PageReference pageRef = Page.HRO_PreBoardingActionPage;
        
		Test.setCurrentPage(pageRef);
		Test.startTest();
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = new List<HRO_Onboarding_Plan__c>();
        
        System.runAs(adminUser){
            //create task template in HRO Admin context
            managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
            //List<HRO_Onboarding_Plan__c> leaderTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(false);
            insert managerTasksTemplate;
        }
        
        System.runAs(manager){
            //run test in manager context
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
            system.assertEquals([Select id FROM HRO_Onboarding_Task__c where Onboarding_Task_Set__r.OwnerId = :UserInfo.getUserId()].isEmpty(),false,'System should create task for manager');
            
            //test passing param to page
            pageRef.getParameters().put('sfdc.userId',manager.id);
            Test.setCurrentPage(pageRef);
            HRO_BoardingAction_CX pageControllerWithParam = new HRO_BoardingAction_CX(new ApexPages.StandardController(managerTasksTemplate[0]));
            HRO_BoardingAction_CX pageSetControllerWithParam = new HRO_BoardingAction_CX(new ApexPages.StandardSetController(managerTasksTemplate));
            pageController.planInfo = new HRO_Onboarding_Plan__c();
            //pageController.planInfo.Manager__c = manager.id;
            pageController.planInfo.New_Leader__c = 'Test leader 1';
            pageController.planInfo.Start_Date__c = Date.today();
            pageController.getProfileUserId();
            pageController.getPreBoardingTasks();
            system.assertEquals(pageController.listOfTemplateTasks.isEmpty(),false,
                          'System shoud retrive template tasks');
            pageController.isSalesforce1 = true;
            pageController.savePreBoarding();
            
        }
        
				
		Test.stopTest();

	}
	
}