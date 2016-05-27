/*
Copyright (c) 2014, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
@isTest
private class PBS_LearningAssignmentApproveExt_Test {

  static testMethod void testApprovalAsSysAdmin(){

    //Create users
    List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,'System Administrator');
    List<User> lmsUsers = PBS_UtilClass_Test.createUsers(2,'Standard User');

    createTestDataForApproval(adminUsers,lmsUsers);

    List<PBS_Learning_Assignment__c> learningAssignments = [select id,approved__c from PBS_Learning_Assignment__c limit:integer.valueof(System.Label.PBS_soqllimit)];

    Test.startTest();

      PBS_LearningAssignmentApproveExt_CC asgmtApproveExt = new PBS_LearningAssignmentApproveExt_CC(new ApexPages.StandardController(learningAssignments.get(0)));
      asgmtApproveExt.approveAssignment();
	  System.assert(asgmtApproveExt != null);	
    Test.stopTest();
  }

  static testMethod void testApprovalAsManager(){

    //Create users
    List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,'System Administrator');
    List<User> lmsUsers = PBS_UtilClass_Test.createUsers(2,'Standard User');

    createTestDataForApproval(adminUsers,lmsUsers);

    Test.startTest();

      System.runAs(lmsUsers.get(1)){

        List<PBS_Learning_Assignment__c> learningAssignments = [select id,approved__c from PBS_Learning_Assignment__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assert(learningAssignments.size() == 1);
        PBS_LearningAssignmentApproveExt_CC asgmtApproveExt = new PBS_LearningAssignmentApproveExt_CC(new ApexPages.StandardController(learningAssignments.get(0)));
        asgmtApproveExt.approveAssignment();

      }

    Test.stopTest();

  }

  private static void createTestDataForApproval(List<User> adminUsers,List<User> lmsUsers){

    System.runAs(adminUsers.get(0)){
      //Assign corresponding perm sets
      PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
      PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
    }

    String taskApproverId = lmsUsers.get(1).Id;

    //Create task learnings
    List<PBS_Learning__c> taskLearnings = PBS_LearningData_Test.createTestLearning(1, 'Task', false);

    //Update learning attributes
    Id learningId = taskLearnings.get(0).Id;

    //Create task resources
    List<PBS_Task__c> ttasks = PBS_LearningData_Test.createTestTask(taskLearnings);

    //Enable manager approval in the task
    PBS_Task__c learningTask = [select id,Requires_Manager_Approval__c from PBS_Task__c where Learning__c = :learningId];
    learningTask.Requires_Manager_Approval__c = true;
    update learningTask;

    //Add second user as a task approver
    PBS_Task_Approver__c ta = new PBS_Task_Approver__c();
    ta.Task__c = learningTask.Id;
    ta.User__c = taskApproverId;
    insert ta;

    //Publish learnings
    for(Integer i = 0;i < taskLearnings.size();i++){
      PBS_LearningData_Test.publishLearning(taskLearnings.get(i).Id,'task',ttasks.get(i).Id,false);
    }

    List<PBS_Training_Plan__c> tplans = PBS_TrainingPlanData_Test.createTrainingPlans(new List<PBS_Params_Test.TrainingPlanParam>{new PBS_Params_Test.TrainingPlanParam ()});

    //Create training plan sections
    List<PBS_Training_Plan_Section__c> tplanSections = PBS_TrainingPlanData_Test.createTrainingPlanSections(tplans.get(0).Id,1);

    //Create training plan section items for quizzes
    List<PBS_Training_Plan_Section_Item__c> tplanSectionItmes1 = PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections.get(0).Id,taskLearnings);

    //Assign the user to the trainign plan
    List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
    System.assertEquals(1,tplan.size());
    Id tplanId = tplan.get(0).Id;

    System.runAs(adminUsers.get(0)){
      Set<Id> selectedUserIds = new Set<Id>{lmsUsers.get(0).Id};
      PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId,null);
    }

    List<PBS_Learning_Assignment__c> learningAssignments = [select id,Approved__c,Progress__c from PBS_Learning_Assignment__c limit:integer.valueof(System.Label.PBS_soqllimit)];
    System.assertEquals(1,learningAssignments.size());

    PBS_Learning_Assignment__c la = learningAssignments.get(0);
    System.assertEquals('Not Started',la.Progress__c);
    la.Progress__c = 'In Review';
    update la;

    //Run sharing logic
    PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
    wsops.shareLearningAssignmentsWithApprovers(new Set<Id>{taskApproverId}, new Set<Id>{la.Id});

  }
}