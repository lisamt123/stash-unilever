/**********************************************************************
 Name:  HRO_HeadStart_CXTest
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Test class for HRO_HeadStart_CX
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0   Karol Szepietowksi        10/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

@isTest
private class HRO_HeadStart_CXTest {
	
   private static final String LEADERPHASEINFO = 'Property getLeaderPhase did not return proper Leader phase';
   private static final String SWITCHTOPHASEINFO = 'Property swichToPhase was not set properly';
   private static final String NEWLEADERNAME = 'HRONewLeader'; 
   /*******************************************************************
   Purpose:  Testing manager view on headstart page                                                      
   Parameters: [optional]
   Returns: [optional]
   Throws [Exceptions]: [optional]                                                          
  ********************************************************************/	
	@isTest static void testManagerView() {
		User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User adminUser = HRO_UnitTestFactory.createUser(NEWLEADERNAME);
        HRO_UnitTestFactory.addHROPermissions(manager, adminUser);
        
        
        Test.startTest();
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = new List<HRO_Onboarding_Plan__c>();
        System.runAs(adminUser){
            managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
        }
        
        PageReference pageRef = Page.HRO_HeadStart;
        pageRef.getParameters().put('sfdc.userId',manager.id);
        Test.setCurrentPage(pageRef);
        
        System.runAs(manager){
            HRO_UnitTestFactory.createPreboardingTask(manager,adminUser,managerTasksTemplate);
            HRO_HeadStart_CX pageController = new HRO_HeadStart_CX();
            system.assertEquals(pageController.selectedLeader, NEWLEADERNAME,'There should be selected :'+NEWLEADERNAME);
            system.assertEquals(pageController.getAvailableLeaders().size(), 1,'Manager should see only one Leader :'+NEWLEADERNAME);
            pageController.getIntroductionInfoMap();
            List<HRO_Onboarding_Task__c> leaderPhaseOnbordingTasks = pageController.getOnboardingTasks();
            system.assertEquals(leaderPhaseOnbordingTasks.isEmpty(),false,'Task should be created for each phase');
            HRO_HeadStart_CX.markComplete(leaderPhaseOnbordingTasks.get(0).id);
            //check if task was marked as completed under db
            system.assertEquals(true,[Select Completed__c FROM HRO_Onboarding_Task__c WHERE ID =:leaderPhaseOnbordingTasks.get(0).id].get(0).Completed__c,'Task should be marked as competed under database');
            pageController.resetleaderPhase();
            
            //test passing param for selected leader
            pageRef.getParameters().put('leaderToSelect',NEWLEADERNAME);
            Test.setCurrentPage(pageRef);
            HRO_HeadStart_CX pageControllerWithParam = new HRO_HeadStart_CX();
            system.assertEquals(pageControllerWithParam.selectedLeader, NEWLEADERNAME,'Following leader should be selected'+NEWLEADERNAME);
            
        }
        
        Test.stopTest();
        
	}
    
    /*******************************************************************
   Purpose:  Testing swiching between phases                                                      
   Parameters: [optional]
   Returns: [optional]
   Throws [Exceptions]: [optional]                                                          
  ********************************************************************/	
    @isTest static void testSwichingBetweenPhases() {
       	User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User adminUser = HRO_UnitTestFactory.createUser('HROtestAdmin');
        HRO_UnitTestFactory.addHROPermissions(manager, adminUser);
        
        PageReference pageRef = Page.HRO_HeadStart;
        pageRef.getParameters().put('sfdc.userId',manager.id);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = new List<HRO_Onboarding_Plan__c>();
        System.runAs(adminUser){
            managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
        }
        System.runAs(manager){
            HRO_UnitTestFactory.createPreboardingTask(manager,adminUser,managerTasksTemplate);
            HRO_HeadStart_CX pageController = new HRO_HeadStart_CX();
            pageController.getOnboardingTasks();
            pageController.selectedPhaseButton = 'preBoardingBtn';
            pageController.phaseButtonClicked();
            system.assertEquals(HRO_HeadStart_CX.PREBOARDINGPHASE,pageController.switchToPhase,'swichToPhase should be set to'+HRO_HeadStart_CX.PREBOARDINGPHASE);
            pageController.changeSelectedButton();
            
            pageController.selectedPhaseButton = 'dayOneBtn';
            pageController.phaseButtonClicked();
            system.assertEquals(HRO_HeadStart_CX.DAY1PHASE,pageController.switchToPhase,'swichToPhase was not set properly to '+HRO_HeadStart_CX.DAY1PHASE);
            pageController.changeSelectedButton();
            
            pageController.selectedPhaseButton = 'weekOneBtn';
            pageController.phaseButtonClicked();
            system.assertEquals(HRO_HeadStart_CX.WEEK1PHASE,pageController.switchToPhase,'Method changeSelectedButton should set swichToPhase to following value: '+HRO_HeadStart_CX.WEEK1PHASE);
            pageController.changeSelectedButton();
            
            pageController.selectedPhaseButton = 'monthOneBtn';
            pageController.phaseButtonClicked();
            system.assertEquals(HRO_HeadStart_CX.MONTH1PHASE,pageController.switchToPhase,SWITCHTOPHASEINFO);
            pageController.changeSelectedButton();
            
            pageController.selectedPhaseButton = 'monthTwoBtn';
            pageController.phaseButtonClicked();
            system.assertEquals(HRO_HeadStart_CX.MONTH2PHASE,pageController.switchToPhase,SWITCHTOPHASEINFO);
            pageController.changeSelectedButton();
            
            pageController.selectedPhaseButton = 'monthThreeBtn';
            pageController.phaseButtonClicked();
            system.assertEquals(HRO_HeadStart_CX.MONTH3PHASE,pageController.switchToPhase,SWITCHTOPHASEINFO);
            pageController.changeSelectedButton();
            
            pageController.selectedPhaseButton = 'beyondOnboardingBtn';
            pageController.phaseButtonClicked();
            system.assertEquals(HRO_HeadStart_CX.BEONBOARDPHASE,pageController.switchToPhase,SWITCHTOPHASEINFO);
            pageController.changeSelectedButton();
            
            pageController.switchToPhase = null;
            system.assertEquals(HRO_HeadStart_CX.WEEK1PHASE,pageController.getLeaderPhase(),LEADERPHASEINFO);
            
            HRO_Onboarding_Task_Set__c taskSet = [Select Start_Date__c From HRO_Onboarding_Task_Set__c Limit 1].get(0);
            taskSet.Start_Date__c = Date.today().addDays(1);
            update taskSet;
            system.assertEquals(HRO_HeadStart_CX.PREBOARDINGPHASE,pageController.getLeaderPhase(),LEADERPHASEINFO);
            
            taskSet.Start_Date__c = Date.today();
            update taskSet;
            system.assertEquals(HRO_HeadStart_CX.DAY1PHASE,pageController.getLeaderPhase(),LEADERPHASEINFO);
            
            taskSet.Start_Date__c = Date.today().addDays(-8);
            update taskSet;
            system.assertEquals(HRO_HeadStart_CX.MONTH1PHASE,pageController.getLeaderPhase(),LEADERPHASEINFO);
            
            taskSet.Start_Date__c = Date.today().addDays(-29);
            update taskSet;
            system.assertEquals(HRO_HeadStart_CX.MONTH2PHASE,pageController.getLeaderPhase(),LEADERPHASEINFO);
            
            taskSet.Start_Date__c = Date.today().addDays(-57);
            update taskSet;
            system.assertEquals(HRO_HeadStart_CX.MONTH3PHASE,pageController.getLeaderPhase(),LEADERPHASEINFO);
            
            taskSet.Start_Date__c = Date.today().addDays(-85);
            update taskSet;
            system.assertEquals(HRO_HeadStart_CX.BEONBOARDPHASE,pageController.getLeaderPhase(),LEADERPHASEINFO);
        }
        
        Test.stopTest();
        
    }
	
}