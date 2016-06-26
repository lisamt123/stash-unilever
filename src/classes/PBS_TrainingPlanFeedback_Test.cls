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
public class PBS_TrainingPlanFeedback_Test {

    static testmethod void testTrainingPlanWithNonPreview(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'PBS_LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();
        //Select the sample trainign plan
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        //Add an achievement to the trainign plan
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

        System.assertEquals(0,getFeedbackCount(tplanId));

        System.runAs(lmsUsers.get(0)){

            PageReference pageRef = Page.PBS_TrainingPlanFeedback;
            pageRef.getParameters().put('id', tplanId);
            Test.setCurrentPage(pageRef);

            PBS_TrainingPlanFeedbackController_CC cont = new PBS_TrainingPlanFeedbackController_CC();
            System.assertEquals(true,cont.isAllowedToView);
            System.assert(cont.tPlan != null);
            System.assert(cont.setCon != null);
            System.assert(cont.existingFeedback == null);
            List<PBS_Training_Plan_Feedback__c> comments = cont.getComments();
            System.assertEquals(0,comments.size());
            System.assertEquals(0,cont.getTotalPages());
            System.assertEquals(false,cont.getHasPrevious());
            System.assertEquals(false,cont.getHasNext());
            System.assertEquals(1,cont.getPageNumber());

            //These methods shouldn't make any changes to the current page
            cont.doPrevious();
            cont.doNext();

            System.assertEquals(1,cont.getPageNumber());

            //Submit a new feedback entry

            PBS_Training_Plan_Feedback__c feedback = cont.feedback;
            feedback.Rating__c = 5;

            //Try submitting without comments
            PageReference ref = cont.submitFeedback();
            System.assertEquals(true,cont.hasMessages);
            
            //Add comments and try again
            feedback.Comments__c = 'testing';
            ref = cont.submitFeedback();
            System.assert(ref == null);
        }

        System.assertEquals(1,getFeedbackCount(tplanId));
    }

    static testmethod void testTrainingPlanWithPreview(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'PBS_LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        }

        PBS_TrainingPlanData_Test.createSampleData();

        List<PBS_Training_Plan__c> tplans = [select id
                                            ,Enable_Self_Registration__c
                                            ,Self_Registration_Access__c
                                            from PBS_Training_Plan__c limit :integer.valueof(System.Label.PBS_soqllimit)];

        System.assertEquals(1,tplans.size());
        PBS_Training_Plan__c tplan = tplans.get(0);
        tplan.Enable_Self_Registration__c = true;
        tplan.Self_Registration_Access__c = 'Public';
        update tplan;


        //Select the sample training plan
        System.assertEquals(1,tplans.size());

        //Add an achievement to the trainign plan
        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, 'Achievements');
        List<PBS_Training_Plan_Achievement__c> lTPlanAchievement = PBS_TrainingPlanData_Test.createTrainingPlanAchievements(tplans, lAchievement);

        Id tplanId = tplans.get(0).Id;

        System.assertEquals(0,getFeedbackCount(tplanId));

        System.runAs(lmsUsers.get(0)){

            PageReference pageRef = Page.PBS_TrainingPlanFeedback;
            pageRef.getParameters().put('id', tplanId);
            pageRef.getParameters().put('preview', '1');
            Test.setCurrentPage(pageRef);

            PBS_TrainingPlanFeedbackController_CC cont = new PBS_TrainingPlanFeedbackController_CC();
            System.assertEquals(true,cont.isAllowedToView);
            System.assert(cont.tPlan != null);
            System.assert(cont.setCon != null);
            System.assert(cont.existingFeedback == null);
            List<PBS_Training_Plan_Feedback__c> comments = cont.getComments();
            System.assertEquals(0,comments.size());
            System.assertEquals(0,cont.getTotalPages());
            System.assertEquals(false,cont.getHasPrevious());
            System.assertEquals(false,cont.getHasNext());
            System.assertEquals(1,cont.getPageNumber());

            //These methods shouldn't make any changes to the current page
            cont.doPrevious();
            cont.doNext();

            System.assertEquals(1,cont.getPageNumber());

            Boolean isAllowedToSubmitFeedback = cont.getIsAssignedToTrainingPlan();
            System.assertEquals(false,isAllowedToSubmitFeedback);

        }

    }

    static Integer getFeedbackCount(Id tplanId){
        return [select count() from PBS_Training_Plan_Feedback__c where Training_Plan__c = :tplanId];
    }

}