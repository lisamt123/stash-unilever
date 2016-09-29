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
private class PBS_AchievementAssignmentsWorkCom_Test{

    static testMethod void testCompletingTrainingPlan(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(1,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'PBS_LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        }

        Id learningAssignmentId = createSingleItemTrainingPlanWithWorkAchievement(adminUsers,lmsUsers);

        PageReference pageRef = Page.PBS_ResourceViewer;
        pageRef.getParameters().put('aid',learningAssignmentId);

        System.assertEquals(0,getWorkBadgeCount(lmsUsers.get(0).Id));

        Test.setCurrentPage(pageRef);
        Test.startTest();
            System.runAs(lmsUsers.get(0)){                
                new PBS_ResourceViewerController_CC();                
                String contRef = PBS_ResourceViewerController_CC.redirectToResource(learningAssignmentId);
                System.assert(contRef != null);
                List<PBS_Learning_Assignment__c> assignments;
                assignments = [select id,Progress__c from PBS_Learning_Assignment__c where id = :learningAssignmentId];
                System.assertEquals(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED,assignments.get(0).Progress__c);
            }

        Test.stopTest();

        //Assert work badge has been created
        System.assertEquals(1,getWorkBadgeCount(lmsUsers.get(0).Id));

    }

    private static Id createSingleItemTrainingPlanWithWorkAchievement(List<User> adminUsers, List<User> lmsUsers){

        //create resource learnings
        List<PBS_Learning__c> resourceLearnings = PBS_LearningData_Test.createTestLearning(1, 'Resource', false);
        //create training resources
        List<PBS_Training_Resource__c> tresources = PBS_LearningData_Test.createTestTrainingResource(resourceLearnings);

        for(Integer i = 0;i < resourceLearnings.size();i++){
            PBS_LearningData_Test.publishLearning(resourceLearnings.get(i).Id,'resource',tresources.get(i).Id,false);
        }

        //Create training plans
        List<PBS_Training_Plan__c> tplans = PBS_TrainingPlanData_Test.createTrainingPlans(new List<PBS_Params_Test.TrainingPlanParam>{new PBS_Params_Test.TrainingPlanParam()});
        //Create training plan sections
        List<PBS_Training_Plan_Section__c> tplanSections1 = PBS_TrainingPlanData_Test.createTrainingPlanSections(tplans.get(0).Id,1);
        //Create training plan section items for resource
        PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections1.get(0).Id,resourceLearnings);
        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievements = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, 'Achievements');
       // List<PBS_Training_Plan_Achievement__c> lTPlanAchievement =
        PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplans, new List<PBS_Achievement__c>{lAchievements.get(0)});

        List<WorkBadgeDefinition> lWorkBadges = PBS_AchievementData_Test.createWorkBadges(1);
        WorkBadgeDefinition wb = lWorkBadges.get(0);

        PBS_Achievement__c ach  = new PBS_Achievement__c(id = lAchievements.get(0).Id);
        ach.Work_Badge_Id__c = wb.Id;
        ach.Work_Badge_Image_URL__c = wb.ImageUrl;
        ach.Work_Badge_Giver__c = adminUsers.get(0).Id;
        update ach;
        
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)]; // Set Limit of 50000
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

    private static Integer getWorkBadgeCount(String userId){
        return  [select count() from WorkBadge where RecipientId = :userId];
    }

}