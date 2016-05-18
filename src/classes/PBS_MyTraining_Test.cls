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
public class PBS_MyTraining_Test {

    static testmethod void testMyTrainingNotStarted(){

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
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_MyTraining;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put('User-Agent', 'iPhone');
            PBS_MyTrainingController_CC controller = new PBS_MyTrainingController_CC();

            System.assert(controller.selectedType == PBS_LMSConstants_CC.TPLAN_STATUS_NOT_STARTED);
            System.assert(controller.tPlans.size() == 1);

            controller.selectedType = PBS_LMSConstants_CC.TPLAN_STATUS_IN_PROGRESS;
            controller.loadTrainingPlans();
            System.assert(controller.tPlans.size() == 0);

            controller.selectedType = PBS_LMSConstants_CC.TPLAN_STATUS_COMPLETED;
            controller.loadTrainingPlans();
            System.assert(controller.tPlans.size() == 0);

        }

    }

    static testmethod void testMyTrainingInProgress(){

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

                List<PBS_Training_Plan_Assignment__c> ltpa = [select id,
                                                                Status__c,
                                                                Training_Plan__c,
                                                                User__c from PBS_Training_Plan_Assignment__c
                                                                where User__c =: lmsUsers.get(0).Id
                                                                and Training_Plan__c =: tplan.get(0).Id];
                System.assert(ltpa.size() == 1);
                ltpa.get(0).Status__c = 'In Progress';
                upsert ltpa;
            }
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_MyTraining;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put('User-Agent', 'iPhone');
            PBS_MyTrainingController_CC controller = new PBS_MyTrainingController_CC();

            System.assert(controller.selectedType == PBS_LMSConstants_CC.TPLAN_STATUS_NOT_STARTED);
            System.assert(controller.tPlans.size() == 0);

            controller.selectedType = PBS_LMSConstants_CC.TPLAN_STATUS_IN_PROGRESS;
            controller.loadTrainingPlans();
            System.assert(controller.tPlans.size() == 1);

            controller.selectedType = PBS_LMSConstants_CC.TPLAN_STATUS_COMPLETED;
            controller.loadTrainingPlans();
            System.assert(controller.tPlans.size() == 0);

            controller.selectedType ='INVALID VALUE';
            controller.loadTrainingPlans();
            System.assert(controller.tPlans.size() == 0);

        }

    }

    static testmethod void testMyTrainingInProgressWithExpiredItems(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id,Start_Date__c,End_Date__c,Hide_After_End_Date__c from PBS_Training_Plan__c];
        System.assertEquals(1,tplan.size());

        //Update date configuration
        PBS_Training_Plan__c tp = tplan.get(0);
        tp.Start_Date__c = Date.today().addDays(-10);
        tp.End_Date__c = Date.today().addDays(-1);
        tp.Hide_After_End_Date__c = true;
        update tp;


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

                List<PBS_Training_Plan_Assignment__c> ltpa = [select id,
                                                                Status__c,
                                                                Training_Plan__c,
                                                                User__c from PBS_Training_Plan_Assignment__c
                                                                where User__c =: lmsUsers.get(0).Id
                                                                and Training_Plan__c =: tplan.get(0).Id];
                System.assert(ltpa.size() == 1);
                ltpa.get(0).Status__c = 'In Progress';
                upsert ltpa;
            }
        Test.stopTest();

        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_MyTraining;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put('User-Agent', 'iPhone');
            PBS_MyTrainingController_CC controller = new PBS_MyTrainingController_CC();

            System.assert(controller.selectedType == PBS_LMSConstants_CC.TPLAN_STATUS_NOT_STARTED);
            System.assert(controller.tPlans.size() == 0);

            controller.selectedType = PBS_LMSConstants_CC.TPLAN_STATUS_IN_PROGRESS;
            controller.loadTrainingPlans();
          //  System.assert(controller.tPlans.size() == 0);

            controller.selectedType = PBS_LMSConstants_CC.TPLAN_STATUS_COMPLETED;
            controller.loadTrainingPlans();
            System.assert(controller.tPlans.size() == 0);

        }

    }


}