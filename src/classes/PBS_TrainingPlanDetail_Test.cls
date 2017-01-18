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
public class PBS_TrainingPlanDetail_Test {
    // String variables to avoid code containing duplicate String literals
    public static final string SYSTEMADMINISTRATOR = 'System Administrator';
    public static final string STANDARDUSER = 'Standard User';
    public static final string LMS_ADMIN = 'PBS_LMS_Admin';
    public static final string LMS_USER = 'PBS_LMS_User';
    public static final string ACHIEVEMENTS = 'Achievements';
    public static final string USERAGENT = 'User-Agent';
    public static final string TRAININGPLANSECTIONITEMISSUESSIZE = 'Training Plan Section Item issues, size = ';
    public static final string ERRORONSELECTEDITEMSTATUSLABEL = 'Error on selectedItemStatusLabel, label = ';
    public static final string COMPLETED= 'completed' ;
    public static final string IPHONE = 'iphone';
    
    static testmethod void testTrainingPlanDetailMobile(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEMADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARDUSER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
        PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, lAchievement);
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
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, IPHONE);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(tplan.get(0));
            PBS_TrainingPlanDetailController_CC extension = new PBS_TrainingPlanDetailController_CC(stdcontroller);

            List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];
            System.assert(ltpsec.size() == 3);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
            System.assert(ltpsitem.size() == 1, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem.size());

            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-default', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                            and User__c =: lmsUsers.get(0).Id];
            for(PBS_Learning_Assignment__c oa : lassignment){
                oa.Progress__c = 'In Progress';
            }

            upsert lassignment;

            extension.init();
            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-warning', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            for(PBS_Learning_Assignment__c oa : lassignment){
                oa.Progress__c = COMPLETED;
            }

            upsert lassignment;

            extension.init();
            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-success', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem2 = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(1).Id order by Order__c asc];
            System.assert(ltpsitem2.size() == 3, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem2.size());

            extension.selectedSectionId = ltpsec.get(1).Id;
            extension.selectedItemId = ltpsitem2.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();

            List<PBS_Learning_Assignment__c> lassignment2 = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(1).Id
                                                            and User__c =: lmsUsers.get(0).Id];
            for(PBS_Learning_Assignment__c oa2 : lassignment2){
                oa2.Progress__c = COMPLETED;
            }

            upsert lassignment2;

            List<PBS_Training_Plan_Section_Item__c> ltpsitem3 = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(2).Id order by Order__c asc];
            System.assert(ltpsitem3.size() == 3, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem3.size());

            extension.selectedSectionId = ltpsec.get(2).Id;
            extension.selectedItemId = ltpsitem3.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();

            List<PBS_Learning_Assignment__c> lassignment3 = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(2).Id
                                                            and User__c =: lmsUsers.get(0).Id];
            for(PBS_Learning_Assignment__c oa3 : lassignment3){
                oa3.Progress__c = COMPLETED;
            }
            upsert lassignment3;

        }
    }

    static testmethod void testTrainingPlanDetailWeb(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEMADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARDUSER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
        PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, lAchievement);
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
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, 'Mozilla');
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(tplan.get(0));
            PBS_TrainingPlanDetailController_CC extension = new PBS_TrainingPlanDetailController_CC(stdcontroller);

            List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];
            System.assert(ltpsec.size() == 3);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
            System.assert(ltpsitem.size() == 1, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem.size());

            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-default', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                            and User__c =: lmsUsers.get(0).Id];
            for(PBS_Learning_Assignment__c oa : lassignment){
                oa.Progress__c = 'In Progress';
            }

            upsert lassignment;

            extension.init();
            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-warning', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            for(PBS_Learning_Assignment__c oa : lassignment){
                oa.Progress__c = COMPLETED;
            }

            upsert lassignment;

            extension.init();
            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-success', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem2 = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(1).Id order by Order__c asc];
            System.assert(ltpsitem2.size() == 3, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem2.size());

            extension.selectedSectionId = ltpsec.get(1).Id;
            extension.selectedItemId = ltpsitem2.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();

            List<PBS_Learning_Assignment__c> lassignment2 = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(1).Id
                                                            and User__c =: lmsUsers.get(0).Id];
            for(PBS_Learning_Assignment__c oa2 : lassignment2){
                oa2.Progress__c = COMPLETED;
            }

            upsert lassignment2;

            List<PBS_Training_Plan_Section_Item__c> ltpsitem3 = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(2).Id order by Order__c asc];
            System.assert(ltpsitem3.size() == 3, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem3.size());

            extension.selectedSectionId = ltpsec.get(2).Id;
            extension.selectedItemId = ltpsitem3.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();

            List<PBS_Learning_Assignment__c> lassignment3 = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(2).Id
                                                            and User__c =: lmsUsers.get(0).Id];
            for(PBS_Learning_Assignment__c oa3 : lassignment3){
                oa3.Progress__c = COMPLETED;
            }
            upsert lassignment3;

        }
    }

    static testmethod void testTrainingPlanDetailChangesOnLearning_KeepNewVersion(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEMADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARDUSER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
        PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, lAchievement);
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
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, IPHONE);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(tplan.get(0));
            PBS_TrainingPlanDetailController_CC extension = new PBS_TrainingPlanDetailController_CC(stdcontroller);

            List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];
            System.assert(ltpsec.size() == 3);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
            System.assert(ltpsitem.size() == 1, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem.size());

            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-default', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                            and User__c =: lmsUsers.get(0).Id];

            for(PBS_Learning_Assignment__c oa : lassignment){
                oa.Progress__c = COMPLETED;
            }

            upsert lassignment;
        }
        List<PBS_Training_Plan_Section__c> ltpsection = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];

        List<PBS_Learning_Assignment__c> lassignment3 = [select Id, Learning__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsection.get(2).Id
                                                            and User__c =: lmsUsers.get(0).Id];

        List<PBS_Learning__c> learning = [select Id from PBS_Learning__c where Id =: lassignment3.get(0).Learning__c];
        //create task
        List<PBS_Task__c> ttasks = PBS_LearningData_Test.createTestTask(learning);
        //publish task learning
        PBS_LearningData_Test.publishLearning(learning.get(0).Id,'task',ttasks.get(0).Id,false);

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, IPHONE);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(tplan.get(0));
            PBS_TrainingPlanDetailController_CC extension = new PBS_TrainingPlanDetailController_CC(stdcontroller);

            List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];
            System.assert(ltpsec.size() == 3);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
            System.assert(ltpsitem.size() == 1, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem.size());

            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            extension.updateToNewVersionAndLaunch();

            List<PBS_Training_Plan_Section_Item__c> ltpsitem2 = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(1).Id order by Order__c asc];
            System.assert(ltpsitem2.size() == 3, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem2.size());

            extension.init();
            extension.selectedSectionId = ltpsec.get(1).Id;
            extension.selectedItemId = ltpsitem2.get(1).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();

        }
    }


    static testmethod void testTrainingPlanDetailChangesOnLearning_KeepOldVersion(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEMADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARDUSER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
        PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, lAchievement);
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
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, IPHONE);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(tplan.get(0));
            PBS_TrainingPlanDetailController_CC extension = new PBS_TrainingPlanDetailController_CC(stdcontroller);

            List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];
            System.assert(ltpsec.size() == 3);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
            System.assert(ltpsitem.size() == 1, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem.size());

            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            System.assert(extension.selectedItemStatusLabel == 'label-default', ERRORONSELECTEDITEMSTATUSLABEL + extension.selectedItemStatusLabel);

            List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                            Progress__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                            and User__c =: lmsUsers.get(0).Id];

            for(PBS_Learning_Assignment__c oa : lassignment){
                oa.Progress__c = COMPLETED;
            }

            upsert lassignment;
        }

        //Update learning version on Plan
        List<PBS_Training_Plan_Section__c> ltpsection = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];

        List<PBS_Learning_Assignment__c> lassignment3 = [select Id, Learning__c from PBS_Learning_Assignment__c
                                                            where Training_Plan__c =: tplanId
                                                            and Training_Plan_Section__c =:ltpsection.get(2).Id
                                                            and User__c =: lmsUsers.get(0).Id];

        List<PBS_Learning__c> learning = [select Id from PBS_Learning__c where Id =: lassignment3.get(0).Learning__c];
        //create task
        List<PBS_Task__c> ttasks = PBS_LearningData_Test.createTestTask(learning);
        //publish task learning
        PBS_LearningData_Test.publishLearning(learning.get(0).Id,'task',ttasks.get(0).Id,false);

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, IPHONE);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(tplan.get(0));
            PBS_TrainingPlanDetailController_CC extension = new PBS_TrainingPlanDetailController_CC(stdcontroller);

            List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplan.get(0).Id order by Order__c asc];
            System.assert(ltpsec.size() == 3);

            List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
            System.assert(ltpsitem.size() == 1, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem.size());

            extension.selectedSectionId = ltpsec.get(0).Id;
            extension.selectedItemId = ltpsitem.get(0).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();
            extension.keepOldVersionAndLaunch();

            List<PBS_Training_Plan_Section_Item__c> ltpsitem2 = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(1).Id order by Order__c asc];
            System.assert(ltpsitem2.size() == 3, TRAININGPLANSECTIONITEMISSUESSIZE + ltpsitem2.size());

            extension.init();
            extension.selectedSectionId = ltpsec.get(1).Id;
            extension.selectedItemId = ltpsitem2.get(1).Id;
            extension.retrieveItemDetails();
            extension.launchLearning();

        }
    }

    static testmethod void testTrainingPlanDetailWebnNoMainAchievement(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEMADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARDUSER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());
        List<PBS_Training_Plan_Section__c> tplanSections = [select id,Training_Plan__c from PBS_Training_Plan_Section__c where Training_Plan__c = :tplan.get(0).id];


        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
        PBS_TrainingPlanData_Test.createTrainingPlanSectionAchievements(new List<PBS_Training_Plan_Section__c>{tplanSections.get(0)},lAchievement);
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
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, 'Mozilla');
            

        }
    }

    static testmethod void testTrainingPlanDetailWithMultipleAchievements(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEMADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARDUSER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());
        List<PBS_Training_Plan_Section__c> tplanSections = [select id,Training_Plan__c from PBS_Training_Plan_Section__c where Training_Plan__c = :tplan.get(0).id];


        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        //Create multiple achievments tied to the plan
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(2, lAchieveCat.get(0).Id, ACHIEVEMENTS);
        List<PBS_Achievement__c> lSectionAchievements = PBS_AchievementData_Test.createAchievements(2, lAchieveCat.get(0).Id, ACHIEVEMENTS);
        PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, new List<PBS_Achievement__c>{lAchievement.get(0)});
        PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplan, new List<PBS_Achievement__c>{lAchievement.get(1)});
         PBS_TrainingPlanData_Test.createTrainingPlanSectionAchievements(new List<PBS_Training_Plan_Section__c>{tplanSections.get(0)},new List<PBS_Achievement__c>{lSectionAchievements.get(0)});
        PBS_TrainingPlanData_Test.createTrainingPlanSectionAchievements(new List<PBS_Training_Plan_Section__c>{tplanSections.get(0)},new List<PBS_Achievement__c>{lSectionAchievements.get(1)});
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
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_TrainingPlanDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USERAGENT, 'Mozilla');
           
        }
    }
}