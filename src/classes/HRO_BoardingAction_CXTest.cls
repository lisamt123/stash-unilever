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
   1.0    Karol Szepietowski        dd/mm/yyyy      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

@isTest
private class HRO_BoardingAction_CXTest {
	
	@isTest static void testCreatingPreBoardingTasks() {

		User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User leader = HRO_UnitTestFactory.createUser('HROtestLeader');
        
		PageReference pageRef = Page.HRO_PreBoardingActionPage;
		List<HRO_Onboarding_Plan__c> managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
		//List<HRO_Onboarding_Plan__c> leaderTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(false);
		insert managerTasksTemplate;
		system.debug('Manager tasks created: '+JSON.serialize(managerTasksTemplate));
		Test.setCurrentPage(pageRef);
		Test.startTest();
		System.runAs(manager){
			//controller initilization
			system.debug('Run as :'+manager);
        	system.debug('Run as :'+leader);
			HRO_BoardingAction_CX pageController = new HRO_BoardingAction_CX(new ApexPages.StandardController(managerTasksTemplate[0]));
			HRO_BoardingAction_CX pageSetController = new HRO_BoardingAction_CX(new ApexPages.StandardSetController(managerTasksTemplate));
			pageController.planInfo = new HRO_Onboarding_Plan__c();
			pageController.planInfo.Manager__c = manager.id;
			pageController.planInfo.New_Leader__c = 'Test leader';
			pageController.planInfo.Start_Date__c = Date.today();
			pageController.getPreBoardingTasks();
			system.assert(pageController.listOfTemplateTasks.size()>0); 
			pageController.createPreBoardingTasks();
			system.debug(JSON.serialize([Select id FROM HRO_Onboarding_Task__c where ownerId = :manager.id]));
			//check if task were created for manager and he is the owner
			system.assert([Select id FROM HRO_Onboarding_Task__c where ownerId = :manager.id and Phase__c =: HRO_UnitTestFactory.PREBOARDINGPHASE].size()>0);
				

		}
		Test.stopTest();

	}
	
	@isTest static void testCreatingPostBoardingTasks() {
		User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User leader = HRO_UnitTestFactory.createUser('HROtestLeader');
        
		PageReference pageRef = Page.HRO_PreBoardingActionPage;
		List<HRO_Onboarding_Plan__c> managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
		List<HRO_Onboarding_Plan__c> leaderTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(false);
		insert managerTasksTemplate;
		insert leaderTasksTemplate;
		system.debug('Manager tasks created: '+JSON.serialize(managerTasksTemplate));
		Test.setCurrentPage(pageRef);
		Test.startTest();
		System.runAs(manager){
			//controller initilization
			system.debug('Run as :'+manager);
        	system.debug('Run as :'+leader);
			HRO_BoardingAction_CX pageController = new HRO_BoardingAction_CX(new ApexPages.StandardController(managerTasksTemplate[0]));
			HRO_BoardingAction_CX pageSetController = new HRO_BoardingAction_CX(new ApexPages.StandardSetController(managerTasksTemplate));
			pageController.planInfo = new HRO_Onboarding_Plan__c();
			pageController.planInfo.Manager__c = manager.id;
			pageController.planInfo.New_LeaderLookup__c = leader.id;
			pageController.planInfo.Start_Date__c = Date.today();
			pageController.getPostBoardingTasks();
			system.assert(pageController.listOfTemplateTasks.size()>0); 
			pageController.createPostBoardingTasks();
			system.debug(JSON.serialize([Select id FROM HRO_Onboarding_Task__c where ownerId = :manager.id]));
			//check if task were created for manager and he is the owner
			system.assert([Select id FROM HRO_Onboarding_Task__c where ownerId = :manager.id and Phase__c =: HRO_UnitTestFactory.DAY1PHASE].size()>0);
				

		}
		Test.stopTest();
	}
	
}