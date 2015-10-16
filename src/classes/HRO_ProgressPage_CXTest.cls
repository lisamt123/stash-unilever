/**********************************************************************
 Name:  HRO_ProgressPage_CXTest()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Test Class for HRO_ProgressPage_CX  class                                                       
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        13/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

@isTest
public class HRO_ProgressPage_CXTest {
    @isTest static void testPercentProgress() {
        User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User leader = HRO_UnitTestFactory.createUser('HROtestLeader');
        User leader1 = HRO_UnitTestFactory.createUser('HROtestLeader123');
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
        
        HRO_UnitTestFactory.createPreboardingTask(manager,leader,managerTasksTemplate);
        //mark 25% tasks for each phase as completed and check if logic working properly
		Map<String,List<HRO_Onboarding_Task__c>> tasksPerPhase = new Map<String,List<HRO_Onboarding_Task__c>>();
        List<HRO_Onboarding_Task__c> tasksToUpdate = new List<HRO_Onboarding_Task__c>();
        List<HRO_Onboarding_Task__c> totalTasks = [Select Phase__c,Id,Completed__c FROM HRO_Onboarding_Task__c Limit 1000];
        for(HRO_Onboarding_Task__c taskItem : totalTasks){
            if(!tasksPerPhase.containsKey(taskItem.Phase__c)){
                taskItem.Completed__c = true;
                tasksPerPhase.put(taskItem.Phase__c,new List<HRO_Onboarding_Task__c>{taskItem});
            }else if(tasksPerPhase.get(taskItem.Phase__c).size()<2){
                taskItem.Completed__c = true;
                tasksPerPhase.get(taskItem.Phase__c).add(taskItem);
            }
        }
        for(List<HRO_Onboarding_Task__c> lstsToUpdate : tasksPerPhase.values()){
            tasksToUpdate.addAll(lstsToUpdate);
        }
        update tasksToUpdate;
        
        List<HRO_Onboarding_Task__c> newLeaderTasks = HRO_UnitTestFactory.createPreboardingTask(manager,leader1,managerTasksTemplate);
        for(HRO_Onboarding_Task__c leaderTask : newLeaderTasks){
            leaderTask.Completed__c = true;
        }
        
        update newLeaderTasks;
        
        PageReference pageRef = Page.HRO_ProgressPage;
        pageRef.getParameters().put('sfdc.userId',UserInfo.getUserId());
        Test.setCurrentPage(pageRef);
        Test.startTest();
        	HRO_ProgressPage_CX pageController = new HRO_ProgressPage_CX();
        	pageController.getProfileUserId();
            pageController.getIsManager();
            //List<HRO_ProgressPage_CX.ProgressWrapper> progresLst = pageController.getProgressList();
            for(HRO_ProgressPage_CX.ProgressWrapper pWrapp : pageController.progressLst){
                
                system.assertEquals(50, pWrapp.perecntOfCompletion,'Percent of completion wrongly calculated');
                if(pWrapp.phase != 'Overall'){
                    system.assertEquals(4, pWrapp.totalTasks,'Wrong total task calculation');
                    system.assertEquals(2, pWrapp.totalCompletedTasks,'Wrong total completed tasks');
                }else{
                    system.assertEquals(totalTasks.size(), pWrapp.totalTasks,'Wrong Total tasks claculation');
                    system.assertEquals(totalTasks.size()/2, pWrapp.totalCompletedTasks,'Wrong total task comletion calculation');
                }
                
                
            }
        
        Test.stopTest();
    }

}