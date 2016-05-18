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
public class PBS_TrainingPlans_Test {

    static testmethod void testOptionalSectionsValidations(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c];
        System.assertEquals(1,tplan.size());
        Id tplanId = tplan.get(0).Id;
        List<PBS_Training_Plan_Section__c> tplanSections = [select id,Optional__c from PBS_Training_Plan_Section__c where Training_Plan__c = :tplanId];

        //Test Insert
        Test.startTest();

            PBS_Training_Plan_Section__c sampleSection = tplanSections.get(0);
            try{
                sampleSection.Optional__c = true;
                update sampleSection;
                System.assert(false,'Section item with optional items cannot be made optional');
            }catch(Exception e){
                System.assert(true);
            }

        Test.stopTest();

    }

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
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c];
        System.assertEquals(1,tplan.size());
        Id tplanId = tplan.get(0).Id;
        Set<Id> selectedUserIds = new Set<Id>();

        for(User u : lmsUsers){
            selectedUserIds.add(u.Id);
        }

        //Test Insert
        Test.startTest();
            System.runAs(adminUsers.get(0)){
                PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId, null);
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

                PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId,null);
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
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c];
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
                PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId,null);
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

                PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId,null);
            }

        Test.stopTest();

        assignments = [select id from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
        System.assertEquals(5,assignments.size());
        List<PBS_Shared_Learning_Assignment__c> sharedlearningAssignments = [select id from PBS_Shared_Learning_Assignment__c where Learning__c in :resourceLearnings];
        System.assertEquals(5,sharedlearningAssignments.size());
        List<PBS_Achievement_Assignment__c> achievementAssignments = [select Id from PBS_Achievement_Assignment__c where Training_Plan_Achievement__c in :lTPlanAchievement and Status__c = 'Eligible'];
        System.assertEquals(lmsUsers.size(), achievementAssignments.size());
    }

    static testmethod void testUpsertAndDeleteTrainingPlanAssignment(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c];
        System.assertEquals(1,tplan.size());
        Id tplanId = tplan.get(0).Id;
        Set<Id> selectedUserIds = new Set<Id>();

        for(User u : lmsUsers){
            selectedUserIds.add(u.Id);
        }

        List<PBS_Training_Plan_Assignment__c> assignments = null;
        List<PBS_Learning_Assignment__c> learningAssignments = null;

        //Test Insert
        Test.startTest();
            System.runAs(adminUsers.get(0)){
                PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId,null);
                assignments = [select id from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
                System.assertEquals(5,assignments.size());
                learningAssignments = [select id from PBS_Learning_Assignment__c where Training_Plan_Section_Assignment__r.Training_Plan_Section__r.Training_Plan__c = :tplanId];
                System.assert(learningAssignments.size()>0);
                delete assignments;
            }


        Test.stopTest();

        assignments = [select id from PBS_Training_Plan_Assignment__c where Training_Plan__c = :tplanId];
        System.assertEquals(0,assignments.size());
        learningAssignments = [select id from PBS_Learning_Assignment__c where Training_Plan_Section_Assignment__r.Training_Plan_Section__r.Training_Plan__c = :tplanId];
        System.assertEquals(0,learningAssignments.size());

    }

    static testMethod void testTrainingPlanAchievementUpdates(){

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c];
        System.assertEquals(1,tplan.size());
        List<PBS_Training_Plan_Section__c> tplanSections = [select id,Training_Plan__c from PBS_Training_Plan_Section__c where Training_Plan__c = :tplan.get(0).id];

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievements = PBS_AchievementData_Test.createAchievements(3, lAchieveCat.get(0).Id, 'Achievements');
        List<PBS_Training_Plan_Achievement__c> lTPlanAchievement = PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, new List<PBS_Achievement__c>{lAchievements.get(0)});
        List<PBS_Training_Plan_Achievement__c> lTPlanSectionAchievements1 = PBS_TrainingPlanData_Test.createTrainingPlanSectionAchievements(new List<PBS_Training_Plan_Section__c>{tplanSections.get(0)},new List<PBS_Achievement__c>{lAchievements.get(1)});
        List<PBS_Training_Plan_Achievement__c> lTPlanSectionAchievements2 = PBS_TrainingPlanData_Test.createTrainingPlanSectionAchievements(new List<PBS_Training_Plan_Section__c>{tplanSections.get(1)},new List<PBS_Achievement__c>{lAchievements.get(2)});

        //Test Insert
        Test.startTest();

            //Update a training plan achievement to a section plan achievement
            PBS_Training_Plan_Achievement__c tpAchievement = [select id,Training_Plan_Section__c,Type__c from PBS_Training_Plan_Achievement__c where id = :lTPlanAchievement.get(0).Id];
            System.assertEquals('Plan',tpAchievement.Type__c);
            tpAchievement.Training_Plan_Section__c = tplanSections.get(2).Id;
            update tpAchievement;
            tpAchievement = [select id,Training_Plan_Section__c,Type__c from PBS_Training_Plan_Achievement__c where id = :lTPlanAchievement.get(0).Id];
            System.assertEquals('Section',tpAchievement.Type__c);

        Test.stopTest();


    }

    static testmethod void testTPlansWithSharedLearningAssignments(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(3,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleDataWithSharedLearnings();

        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c];
        System.assertEquals(2,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(2, lAchieveCat.get(0).Id, 'Achievements');
        List<PBS_Training_Plan_Achievement__c> lTPlanAchievement = PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, lAchievement);

        Id tplanId = tplan.get(0).Id;
        Id tplanId2 = tplan.get(1).Id;

        Set<Id> selectedUserIds = new Set<Id>();
        for(User u : lmsUsers){
            selectedUserIds.add(u.Id);
        }
        System.runAs(adminUsers.get(0)){
            //Upsert assignemtns for tplan 1
            PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId,null);
            //Upsert assignemtns for tplan 2
            PBS_LMSService_CC.upsertAssignments(selectedUserIds,tplanId2,null);
        }

        //Test Insert
        Test.startTest();

            List<PBS_Learning__c> sharedLearningSample = [select id
                                                    ,Sync_progress__c
                                                    from PBS_Learning__c
                                                    where RecordType.DeveloperName = 'Task'];

            PBS_Learning__c sharedLearning = sharedLearningSample.get(0);
            System.assert(sharedLearning.Sync_progress__c == true);


            List<PBS_Learning_Assignment__c> tplan1LearningAsgmts = [select id
                                                                ,Progress__c
                                                                ,Shared_Learning_Assignment__c
                                                                ,Training_Plan__c
                                                                from PBS_Learning_Assignment__c
                                                                where Training_Plan__c = :tplanId
                                                                and Learning__c = :sharedLearning.Id
                                                                and User__c = :lmsUsers.get(0).Id];

            System.assertEquals(1,tplan1LearningAsgmts.size());

            List<PBS_Learning_Assignment__c> tplan2LearningAsgmts = [select id
                                                                ,Progress__c
                                                                ,Shared_Learning_Assignment__c
                                                                ,Training_Plan__c
                                                                from PBS_Learning_Assignment__c
                                                                where Training_Plan__c = :tplanId2
                                                                and Learning__c = :sharedLearning.Id
                                                                and User__c = :lmsUsers.get(0).Id];

            System.assertEquals(1,tplan2LearningAsgmts.size());

            //Update learning assignment progress in training plan 1
            tplan1LearningAsgmts.get(0).Progress__c = 'Completed';
            update tplan1LearningAsgmts.get(0);

            //Confirm the change has been replicated to the shared learning assignment

            List<PBS_Shared_Learning_Assignment__c> sharedLearningAssignments = [select id
                                                                ,Progress__c
                                                                from PBS_Shared_Learning_Assignment__c
                                                                where Learning__c = :sharedLearning.Id
                                                                and User__c = :lmsUsers.get(0).Id];
            System.assertEquals(1,sharedLearningAssignments.size());
            System.assertEquals('Completed',sharedLearningAssignments.get(0).Progress__c);

        Test.stopTest();


        //Confirm that learning assignments in training plan 2 have also been updated
        List<PBS_Learning_Assignment__c> tplan2LearningAsgmtsUpdated = [select id
                                                            ,Progress__c
                                                            ,Shared_Learning_Assignment__c
                                                            ,Training_Plan__c
                                                            from PBS_Learning_Assignment__c
                                                            where Training_Plan__c = :tplanId2
                                                            and Learning__c = :sharedLearning.Id
                                                            and User__c = :lmsUsers.get(0).Id];
        System.assertEquals('Completed',tplan2LearningAsgmtsUpdated.get(0).Progress__c);
    } 
}