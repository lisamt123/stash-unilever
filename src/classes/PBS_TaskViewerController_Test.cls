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
private class PBS_TaskViewerController_Test{
  //String constants to avoid code containing duplicate String literals
   public Static final string systemAdministrator = 'System Administrator';
   public Static final string standardUser = 'Standard User';
   public Static final string LMSAdmin = 'LMS_Admin';
   public Static final string LMSUser = 'LMS_User';
   public Static final string aid = 'aid';
   
    static testMethod void testSimpleTask(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,systemAdministrator);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,standardUser);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMSAdmin);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMSUser);
        }

        Id learningAssignmentId = createTaskViewerData(adminUsers,lmsUsers,false);

            //Test Insert
            PageReference pageRef = Page.PBS_TaskViewer;
            pageRef.getParameters().put(aid,learningAssignmentId);
            Test.setCurrentPage(pageRef);
            Test.startTest();
                System.runAs(lmsUsers.get(0)){
                PBS_TaskViewerController_CC cont = new PBS_TaskViewerController_CC();
                PageReference contRef;
                //Test cancel
                contRef = cont.cancelTask();
                System.assert(cont.redirectURL != null);
                PageReference dummyRef = new PageReference(cont.redirectURL);
                System.assert(dummyRef.getParameters().get('section') != null);
                List<PBS_Learning_Assignment__c> assignments;
                assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
                System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED,assignments.get(0).Progress__c);
                contRef = cont.markCompleted();
                assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
                System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED,assignments.get(0).Progress__c);

            }

        Test.stopTest();
    }

    static testMethod void testTaskWithApprovers(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,systemAdministrator);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,standardUser);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMSAdmin);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMSUser);
        }

        Id learningAssignmentId = createTaskViewerData(adminUsers,lmsUsers,true);

            //Test Insert
            PageReference pageRef = Page.PBS_TaskViewer;
            pageRef.getParameters().put(aid,learningAssignmentId);
            Test.setCurrentPage(pageRef);
            Test.startTest();
            System.runAs(lmsUsers.get(0)){
                PBS_TaskViewerController_CC cont = new PBS_TaskViewerController_CC();
                PageReference contRef;
                List<PBS_Learning_Assignment__c> assignments;
                assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
                System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED,assignments.get(0).Progress__c);
                contRef = cont.markCompleted();
                assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
                System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW,assignments.get(0).Progress__c);

            }

        Test.stopTest();
    }


    static testMethod void testTaskWithAttachment(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,systemAdministrator);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,standardUser);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMSAdmin);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMSUser);
        }

        Id learningAssignmentId = createTaskViewerData(adminUsers,lmsUsers,false);

            //Test Insert
            PageReference pageRef = Page.PBS_TaskViewer;
            pageRef.getParameters().put(aid,learningAssignmentId);
            Test.setCurrentPage(pageRef);
            Test.startTest();
            System.runAs(lmsUsers.get(0)){
                PBS_TaskViewerController_CC cont = new PBS_TaskViewerController_CC();
                PageReference contRef;
                cont.attachment.Body = Blob.valueOf('Test Data');
                List<PBS_Learning_Assignment__c> assignments;
                assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
                System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED,assignments.get(0).Progress__c);
                contRef = cont.markCompletedAndRedirect();
                assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
                System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED,assignments.get(0).Progress__c);

            }

        Test.stopTest();
    }

    static testMethod void testLoadingCompletedTask(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,systemAdministrator);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,standardUser);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMSAdmin);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMSUser);
        }

        Id learningAssignmentId = createTaskViewerData(adminUsers,lmsUsers,false);
        List<PBS_Learning_Assignment__c> theAssignment = [select id,Progress__c from PBS_Learning_Assignment__c where id  = :learningAssignmentId];
        theAssignment.get(0).Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
        update theAssignment.get(0);

            PageReference pageRef = Page.PBS_TaskViewer;
            pageRef.getParameters().put(aid,learningAssignmentId);
            Test.setCurrentPage(pageRef);
            Test.startTest();
            System.runAs(lmsUsers.get(0)){
                PBS_TaskViewerController_CC cont = new PBS_TaskViewerController_CC();
                System.assertEquals(true,cont.taskCompleted);
            }

        Test.stopTest();
    }

    static testMethod void testLoadingInReviewTask(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,systemAdministrator);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,standardUser);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMSAdmin);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMSUser);
        }

        Id learningAssignmentId = createTaskViewerData(adminUsers,lmsUsers,false);
        List<PBS_Learning_Assignment__c> theAssignment = [select id,Progress__c from PBS_Learning_Assignment__c where id  = :learningAssignmentId];
        theAssignment.get(0).Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW;
        update theAssignment.get(0);

            PageReference pageRef = Page.PBS_TaskViewer;
            pageRef.getParameters().put(aid,learningAssignmentId);
            Test.setCurrentPage(pageRef);
            Test.startTest();
            System.runAs(lmsUsers.get(0)){
                PBS_TaskViewerController_CC cont = new PBS_TaskViewerController_CC();
                System.assertEquals(true,cont.taskCompleted);
                System.assertEquals(true,cont.taskInReview);
            }

        Test.stopTest();
    }


    static testMethod void testUndoTask(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,systemAdministrator);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,standardUser);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMSAdmin);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMSUser);
        }

        Id learningAssignmentId = createTaskViewerData(adminUsers,lmsUsers,false);

        //Test Insert
        PageReference pageRef = Page.PBS_TaskViewer;
        pageRef.getParameters().put(aid,learningAssignmentId);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        System.runAs(lmsUsers.get(0)){
            PBS_TaskViewerController_CC cont = new PBS_TaskViewerController_CC();
            PageReference contRef;
            //Test cancel
            contRef = cont.cancelTask();
            System.assert(cont.redirectURL != null);
            PageReference dummyRef = new PageReference(cont.redirectURL);
            System.assert(dummyRef.getParameters().get('section') != null);
            List<PBS_Learning_Assignment__c> assignments;
            assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
            System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED,assignments.get(0).Progress__c);
            contRef = cont.markCompleted();
            assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
            System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED,assignments.get(0).Progress__c);
            contRef = cont.resetTask();
            assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
            System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED,assignments.get(0).Progress__c);

        }

        Test.stopTest();
    }

    private static Id createTaskViewerData(List<User> adminUsers, List<User> lmsUsers, Boolean hasApprovers){

        //create task learnings
        List<PBS_Learning__c> taskLearnings = PBS_LearningData_Test.createTestLearning(1, 'Task', false);
        //create task resources
        List<PBS_Task__c> ttasks = PBS_LearningData_Test.createTestTask(taskLearnings);

        if(hasApprovers){
            List<User> approvers = PBS_UtilClass_Test.createUsers(1,standardUser);
            System.runAs(adminUsers.get(0)){
                PBS_UtilClass_Test.addPermissionSet(approvers,LMSUser);
            }

            //Enable manager approval in the task
            PBS_Task__c theTask = [select id,Requires_Manager_Approval__c,Add_training_parameters_to_URL__c from PBS_Task__c where Id = :ttasks.get(0).Id];
            theTask.Requires_Manager_Approval__c = true;
            theTask.Add_training_parameters_to_URL__c = true;
            update theTask;

            //Add second user as a task approver
            PBS_Task_Approver__c ta = new PBS_Task_Approver__c();
            ta.Task__c = theTask.Id;
            ta.User__c = approvers.get(0).Id;
            insert ta;
        }

        for(Integer i = 0;i < taskLearnings.size();i++){
            PBS_LearningData_Test.publishLearning(taskLearnings.get(i).Id,'task',ttasks.get(i).Id,false);
        }
        //Create training plans
        List<PBS_Training_Plan__c> tplans = PBS_TrainingPlanData_Test.createTrainingPlans(new List<PBS_Params_Test.TrainingPlanParam>{new PBS_Params_Test.TrainingPlanParam()});
        //Create training plan sections
        List<PBS_Training_Plan_Section__c> tplanSections1 = PBS_TrainingPlanData_Test.createTrainingPlanSections(tplans.get(0).Id,1);
        //Create training plan section items for quizzes
        List<PBS_Training_Plan_Section_Item__c> tplan1SectionItems1 = PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections1.get(0).Id,taskLearnings);

        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());
        Id tplanId = tplan.get(0).Id;

        Set<Id> selectedUserIds = new Set<Id>();

        for(User u : lmsUsers){
            selectedUserIds.add(u.Id);
        }

        System.runAs(adminUsers.get(0)){
            PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId,null);
        }

        List<PBS_Learning_Assignment__c> assignments = [select id from PBS_Learning_Assignment__c where Training_Plan__c = :tplanId];
        System.assertEquals(1,assignments.size());
        return assignments.get(0).Id;

    }
    
}