/**********************************************************************
 Name:  HRO_OnboardingTaksList_CCTest
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Test class for HRO_OnboardingTaskList_CC
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0   Karol Szepietowksi        10/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/
@istest
private with sharing class HRO_OnboardingTaskList_CCTest {
	
   private static final String TESTMSG = 'current phase sould be set to : ';
   /*******************************************************************
   Purpose:  Testing getTaskAssignedToPhase method                                                       
   Parameters: [optional]
   Returns: [optional]
   Throws [Exceptions]: [optional]                                                          
  ********************************************************************/	
    @isTest static void testGetTaskAssignedToPhase() {
        User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User adminUser = HRO_UnitTestFactory.createUser('HROtestLeader');
        HRO_UnitTestFactory.addHROPermissions(manager, adminUser);
        
        Test.startTest();
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = new List<HRO_Onboarding_Plan__c>();
        System.runAs(adminUser){
             managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
        }
        
        System.runAs(manager){
        	List<HRO_Onboarding_Task__c> initialTasks = HRO_UnitTestFactory.createPreboardingTask(manager,adminUser,managerTasksTemplate);
        
            if(!initialTasks.isEmpty()){
                //reset task link to null;
                initialTasks.get(0).ExternalPortalLink__c = null;
                update initialTasks.get(0);
            }
            
            
            HRO_OnboardingTaskList_CC pageController = new HRO_OnboardingTaskList_CC();
            pageController.cPhase = HRO_HeadStart_CX.PREBOARDINGPHASE;
            HRO_Onboarding_Task_Set__c taskSet = [Select Start_Date__c From HRO_Onboarding_Task_Set__c Limit 1].get(0);
            taskSet.Start_Date__c = Date.today().addDays(1);
            update taskSet;
            
            pageController.cRecordId = taskSet.id;
            pageController.cTaskId = initialTasks.get(0).id;
            System.assertEquals(HRO_HeadStart_CX.PREBOARDINGPHASE,pageController.getLeaderPhase(),'Wrongly calculated Leader Phase');
            List<HRO_OnboardingTaskList_CC.OnboardingTasksWrapper> taskLst = pageController.getTaskAssignedToPhase();
            //there shuld be 4 tasks in PREBOARDINGPHASE
            system.assertEquals(4, taskLst.size(),'Wrong number of retrived task in phase:'+HRO_HeadStart_CX.PREBOARDINGPHASE);
            //testing leader phase
            pageController.cStartDate = Date.today();
            system.assertEquals(HRO_HeadStart_CX.DAY1PHASE, pageController.getLeaderPhase(),TESTMSG+HRO_HeadStart_CX.DAY1PHASE);
            pageController.cStartDate = Date.today().addDays(-7);
            system.assertEquals(HRO_HeadStart_CX.WEEK1PHASE, pageController.getLeaderPhase(),TESTMSG+HRO_HeadStart_CX.WEEK1PHASE);
            pageController.cStartDate = Date.today().addDays(-28);
            system.assertEquals(HRO_HeadStart_CX.MONTH1PHASE, pageController.getLeaderPhase(),TESTMSG+HRO_HeadStart_CX.MONTH1PHASE);
            pageController.cStartDate = Date.today().addDays(-56);
            system.assertEquals(HRO_HeadStart_CX.MONTH2PHASE, pageController.getLeaderPhase(),TESTMSG+HRO_HeadStart_CX.MONTH2PHASE);
            pageController.cStartDate = Date.today().addDays(-84);
            system.assertEquals(HRO_HeadStart_CX.MONTH3PHASE, pageController.getLeaderPhase(),TESTMSG+HRO_HeadStart_CX.MONTH3PHASE);
            pageController.cStartDate = Date.today().addDays(-85);
            system.assertEquals(HRO_HeadStart_CX.BEONBOARDPHASE, pageController.getLeaderPhase(),TESTMSG+HRO_HeadStart_CX.BEONBOARDPHASE);
    
        }
        
        Test.stopTest();
    }
    
   /*******************************************************************
   Purpose:  Testing getOverDuedTaskList method                                                       
   Parameters: [optional]
   Returns: [optional]
   Throws [Exceptions]: [optional]                                                          
  ********************************************************************/	
    @isTest static void testGetOverDuedTasks() {
        User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User adminUser = HRO_UnitTestFactory.createUser('HROtestLeader');
        HRO_UnitTestFactory.addHROPermissions(manager, adminUser);
        
        Test.startTest();
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = new List<HRO_Onboarding_Plan__c>();
        System.runAs(adminUser){
            managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
        }
        
        System.runAs(manager){
            List<HRO_Onboarding_Task__c> createdTasks = HRO_UnitTestFactory.createPreboardingTask(manager,adminUser,managerTasksTemplate);
            Boolean firstIteration = true;
            for(HRO_Onboarding_Task__c t : createdTasks){
                t.Due_Date__c = Date.today().addDays(-80);
                if(firstIteration){
                    firstIteration = false;
                    t.ExternalPortalLink__c = null;
                }
            }
            
            update createdTasks;
            
            
            HRO_OnboardingTaskList_CC pageController = new HRO_OnboardingTaskList_CC();
            pageController.cPhase = HRO_HeadStart_CX.MONTH3PHASE;
            HRO_Onboarding_Task_Set__c taskSet = new HRO_Onboarding_Task_Set__c(Id = createdTasks.get(0).Onboarding_Task_Set__c);
            taskSet.Start_Date__c = Date.today().addDays(-80);
            update taskSet;
            system.debug('check start date : '+taskSet);
            
            pageController.cRecordId = taskSet.id;
            pageController.cStartDate = taskSet.Start_Date__c;
            pageController.getTaskLink();
            pageController.cTaskLink = createdTasks.get(1).ExternalPortalLink__c;
            pageController.getTaskLink();
            System.assertEquals(HRO_HeadStart_CX.MONTH3PHASE,pageController.getLeaderPhase(),'Wrong number of retrived task in phase:'+HRO_HeadStart_CX.PREBOARDINGPHASE);
            List<HRO_OnboardingTaskList_CC.OnboardingTasksWrapper> taskLst = pageController.getOverDuedTaskList();
            system.assertEquals(taskLst.isEmpty(),false,'There should be retrived task from phase:'+HRO_HeadStart_CX.MONTH3PHASE);
        }
        
        Test.stopTest();
    }
}