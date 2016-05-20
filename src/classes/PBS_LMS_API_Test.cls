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
public class PBS_LMS_API_Test {

    static testmethod void testUpsertTrainingPlanAssignment(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());
        Id tplanId = tplan.get(0).Id;
        Set<Id> selectedUserIds = new Set<Id>();

        for(User u : lmsUsers){
            selectedUserIds.add(u.Id);
        }

        //Test Insert
        Test.startTest();
            System.runAs(adminUsers.get(0)){
                PBS_LMS_API_CC.upsertAssignments(selectedUserIds,tplanId);
            }

            List<PBS_Training_Plan_Assignment__c> assignments = [select id from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
            System.assertEquals(5,assignments.size());
            List<PBS_Learning_Assignment__c> learningAssignments = [select id from PBS_Learning_Assignment__c where Training_Plan_Section_Assignment__r.Training_Plan_Section__r.Training_Plan__c = :tplanId];
            System.assert(learningAssignments.size()>0);
            List<PBS_Learning__c> resourceLearnings;

            System.runAs(adminUsers.get(0)){
                //Add an additional shared learning
                //create resource learnings
                resourceLearnings = PBS_LearningData_Test.createTestLearning(1, 'Resource', true);
                //create training resources
                List<PBS_Training_Resource__c> tresources = PBS_LearningData_Test.createTestTrainingResource(resourceLearnings);
                //Publish resource
                PBS_LearningData_Test.publishLearning(resourceLearnings.get(0).Id,'resource',tresources.get(0).Id,false);
                List<PBS_Training_Plan_Section__c> tplanSections = [select id from PBS_Training_Plan_Section__c where Training_Plan__c = :tplanId limit 1];
                //Add to training plan section
                List<PBS_Training_Plan_Section_Item__c> tplanSectionItemUpdate = PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections.get(0).Id,resourceLearnings);

                PBS_LMS_API_CC.upsertAssignments(selectedUserIds,tplanId);
            }

        Test.stopTest();

        assignments = [select id from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
        System.assertEquals(5,assignments.size());
        List<PBS_Shared_Learning_Assignment__c> sharedlearningAssignments = [select id from PBS_Shared_Learning_Assignment__c where Learning__c in :resourceLearnings];
        System.assertEquals(5,sharedlearningAssignments.size());

    }

    static testmethod void testUpsertTrainingPlanAssignmentWithAchievements(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, 'Achievements');
        List<PBS_Training_Plan_Achievement__c> lTPlanAchievement = PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, lAchievement);

        Id tplanId = tplan.get(0).Id;
        Set<Id> selectedUserIds = new Set<Id>();

        for(User u : lmsUsers){
            selectedUserIds.add(u.Id);
        }

        //Test Insert
        Test.startTest();
            System.runAs(adminUsers.get(0)){
                PBS_LMS_API_CC.upsertAssignments(selectedUserIds,tplanId);
            }

            List<PBS_Training_Plan_Assignment__c> assignments = [select id from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
            System.assertEquals(5,assignments.size());
            List<PBS_Learning_Assignment__c> learningAssignments = [select id from PBS_Learning_Assignment__c where Training_Plan_Section_Assignment__r.Training_Plan_Section__r.Training_Plan__c = :tplanId];
            System.assert(learningAssignments.size()>0);
            List<PBS_Learning__c> resourceLearnings;

            System.runAs(adminUsers.get(0)){
                //Add an additional shared learning
                //create resource learnings
                resourceLearnings = PBS_LearningData_Test.createTestLearning(1, 'Resource', true);
                //create training resources
                List<PBS_Training_Resource__c> tresources = PBS_LearningData_Test.createTestTrainingResource(resourceLearnings);
                //Publish resource
                PBS_LearningData_Test.publishLearning(resourceLearnings.get(0).Id,'resource',tresources.get(0).Id,false);
                List<PBS_Training_Plan_Section__c> tplanSections = [select id from PBS_Training_Plan_Section__c where Training_Plan__c = :tplanId limit 1];
                //Add to training plan section
                List<PBS_Training_Plan_Section_Item__c> tplanSectionItemUpdate = PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections.get(0).Id,resourceLearnings);

                PBS_LMS_API_CC.upsertAssignments(selectedUserIds,tplanId);
            }

        Test.stopTest();

        assignments = [select id from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
        System.assertEquals(5,assignments.size());
        List<PBS_Shared_Learning_Assignment__c> sharedlearningAssignments = [select id from PBS_Shared_Learning_Assignment__c where Learning__c in :resourceLearnings];
        System.assertEquals(5,sharedlearningAssignments.size());
        List<PBS_Achievement_Assignment__c> achievementAssignments = [select Id from PBS_Achievement_Assignment__c where Training_Plan_Achievement__c in :lTPlanAchievement and Status__c = 'Eligible'];
        System.assertEquals(lmsUsers.size(), achievementAssignments.size());
    }

    static testmethod void testImportData(){
        System.assertEquals(0,getTrainingPlanCount());
        System.assertEquals(0,getTrainingTrackCount());
        Test.startTest();
        PBS_LMSStartController_CC cont = new PBS_LMSStartController_CC();
        PBS_LMS_API_CC.importJSON(PBS_LMSInit_CC.fetchInitData('almond_LMSInitDataWithTracks'),false);
        System.assertEquals(1,getTrainingPlanCount());
        System.assertEquals(1,getTrainingTrackCount());
        Test.stopTest();
    }

    static testmethod void testImportDataWithTimeStamps(){
        System.assertEquals(0,getTrainingPlanCount());
        System.assertEquals(0,getTrainingTrackCount());
        Test.startTest();
        PBS_LMSStartController_CC cont = new PBS_LMSStartController_CC();
        PBS_LMS_API_CC.importJSON(PBS_LMSInit_CC.fetchInitData('almond_LMSInitDataWithTracks'),true);
        System.assertEquals(1,getTrainingPlanCount());
        System.assertEquals(1,getTrainingTrackCount());
        Test.stopTest();
    }

    static testmethod void testTrainingPlanExport(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,'System Administrator');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());
        Id tplanId = tplan.get(0).Id;

        Test.startTest();
            System.runAs(adminUsers.get(0)){
                String exportJSON = PBS_LMS_API_CC.exportTrainingPlan(tplanId,false);
                System.assert(exportJSON != null && exportJSON != '{}');
            }
        Test.stopTest();

    }

    static testmethod void testTrainingTrackExport(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(1,'System Administrator');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
        }

        PBS_TrainingTrackData_Test.createSampleData();

        List<PBS_Training_Track__c> tracks = [select id,name from PBS_Training_Track__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        List<PBS_Training_Track_Level_Item__c> trackItems = [select id,name from PBS_Training_Track_Level_Item__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tracks.size());
        System.assert(trackItems.size()>0);
        Id ttrackId = tracks.get(0).Id;

        Test.startTest();
            System.runAs(adminUsers.get(0)){
                String exportJSON = PBS_LMS_API_CC.exportTrainingTrack(ttrackId,false);
                System.assert(exportJSON != null && exportJSON != '{}');
            }
        Test.stopTest();

    }

    static Integer getTrainingPlanCount(){
        return [select count() from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
    }

    static Integer getTrainingTrackCount(){
        return [select count() from PBS_Training_Track__c limit:integer.valueof(System.Label.PBS_soqllimit)];
    }


}