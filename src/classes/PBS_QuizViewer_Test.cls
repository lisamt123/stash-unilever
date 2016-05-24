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
public class PBS_QuizViewer_Test {

    
        public static final string SYSTEM_ADMINISTRATOR = 'System Administrator';
        public static final string STANDARD_USER = 'Standard User';
        public static final string LMS_ADMIN = 'LMS_Admin';
        public static final string LMS_USER = 'LMS_User';
        public static final string ACHIEVEMENTS = 'Achievements';
        public static final string TRAINING_PLAN_SECTION_ITEM_ISSUES_SIZE = 'Training Plan Section Item issues, size = ';
        public static final string LEARNING_ASSIGNMENT_ISSUES_SIZE = 'Learning Assignment issues, size = ';
        public static final string LEARNING_ASSIGNMENT_IS_NOT_FOR_QUIZ = 'Learning Assignment is not for Quiz';
        public static final string USER_AGENT = 'User-Agent';
        public static final string AID = 'aid';

    static testmethod void testQuizViewerWeb(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARD_USER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
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

        List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplanId order by Order__c asc];
        System.assert(ltpsec.size() == 3);

        List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
        System.assert(ltpsitem.size() == 1, TRAINING_PLAN_SECTION_ITEM_ISSUES_SIZE + ltpsitem.size());

        List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                        Learning__c, Learning_Version__r.Quiz__c from PBS_Learning_Assignment__c
                                                        where Training_Plan__c =: tplanId
                                                        and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                        and User__c =: lmsUsers.get(0).Id];

        System.assert(lassignment.size() == 1, LEARNING_ASSIGNMENT_ISSUES_SIZE + lassignment.size());
        System.assert(lassignment.get(0).Learning_Version__r.Quiz__c != null, LEARNING_ASSIGNMENT_IS_NOT_FOR_QUIZ);

        Set<Id> qlineIds = new Set<Id>();
        for(PBS_Question_Line__c oql : [select Id from PBS_Question_Line__c where Quiz__c =: lassignment.get(0).Learning_Version__r.Quiz__c]){
            qlineIds.add(oql.Id);
        }

        Map<String, PBS_Response__c> mResponses = PBS_LearningData_Test.createTestQuestionResponses(qlineIds, lmsUsers.get(0).Id, lassignment.get(0).Id);


        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_QuizViewer;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USER_AGENT, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:25.0) Gecko/20100101 Firefox/25.0');
            pageRef.getParameters().put(AID, lassignment.get(0).Id);
            PBS_QuizViewerController_CC controller = new PBS_QuizViewerController_CC();
            controller.initializeQuestions();

            //first section
            List<PBS_QuizItem_CC> lqi = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi){
                qi.response   = mResponses.get(qi.question.Id);
            }

            controller.next();

            //second section
            List<PBS_QuizItem_CC> lqi2 = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi2){
                qi.response   = mResponses.get(qi.question.Id);
            }
            //controller.previous();
            controller.next();

            //third & final section
            List<PBS_QuizItem_CC> lqi3 = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi3){
                qi.response   = mResponses.get(qi.question.Id);
            }
            controller.done();
        }
    }

    static testmethod void testQuizViewerWeb2(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARD_USER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
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

        List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplanId order by Order__c asc];
        System.assert(ltpsec.size() == 3);

        List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
        System.assert(ltpsitem.size() == 1, TRAINING_PLAN_SECTION_ITEM_ISSUES_SIZE + ltpsitem.size());

        List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                        Learning__c, Learning_Version__r.Quiz__c from PBS_Learning_Assignment__c
                                                        where Training_Plan__c =: tplanId
                                                        and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                        and User__c =: lmsUsers.get(0).Id];

        System.assert(lassignment.size() == 1, LEARNING_ASSIGNMENT_ISSUES_SIZE + lassignment.size());
        System.assert(lassignment.get(0).Learning_Version__r.Quiz__c != null, LEARNING_ASSIGNMENT_IS_NOT_FOR_QUIZ);

        Set<Id> qlineIds = new Set<Id>();
        for(PBS_Question_Line__c oql : [select Id from PBS_Question_Line__c where Quiz__c =: lassignment.get(0).Learning_Version__r.Quiz__c]){
            qlineIds.add(oql.Id);
        }

        Map<String, PBS_Response__c> mResponses = PBS_LearningData_Test.createTestQuestionResponses(qlineIds, lmsUsers.get(0).Id, lassignment.get(0).Id);


        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_QuizViewer;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USER_AGENT, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:25.0) Gecko/20100101 Firefox/25.0');
            pageRef.getParameters().put(AID, lassignment.get(0).Id);
            PBS_QuizViewerController_CC controller = new PBS_QuizViewerController_CC();
            controller.initializeQuestions();

            //first section
            List<PBS_QuizItem_CC> lqi = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi){
                qi.response   = mResponses.get(qi.question.Id);
            }

            controller.next();
            controller.previous();
            PageReference redirect = controller.backToTrainingPlan();
            System.assert(redirect.getParameters().get('id') == tplanId, 'backToTrainingPlan is not adding params properly');

            //go back to quiz & reset it
            PageReference pageRef2 = Page.PBS_QuizViewer;
            Test.setCurrentPage(pageRef2);
            pageRef.getHeaders().put(USER_AGENT, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:25.0) Gecko/20100101 Firefox/25.0');
            pageRef2.getParameters().put(AID, lassignment.get(0).Id);
            PBS_QuizViewerController_CC controller2 = new PBS_QuizViewerController_CC();
            controller2.initializeQuestions();
            PageReference redirect2 = controller2.reset();
            System.assert(redirect2.getParameters().get(AID) == lassignment.get(0).Id, 'reset is not adding params properly');


        }
    }

    static testmethod void testQuizViewerMobile(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARD_USER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
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

        List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplanId order by Order__c asc];
        System.assert(ltpsec.size() == 3);

        List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
        System.assert(ltpsitem.size() == 1, TRAINING_PLAN_SECTION_ITEM_ISSUES_SIZE + ltpsitem.size());

        List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                        Learning__c, Learning_Version__r.Quiz__c from PBS_Learning_Assignment__c
                                                        where Training_Plan__c =: tplanId
                                                        and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                        and User__c =: lmsUsers.get(0).Id];

        System.assert(lassignment.size() == 1, LEARNING_ASSIGNMENT_ISSUES_SIZE + lassignment.size());
        System.assert(lassignment.get(0).Learning_Version__r.Quiz__c != null, LEARNING_ASSIGNMENT_IS_NOT_FOR_QUIZ);

        Set<Id> qlineIds = new Set<Id>();
        for(PBS_Question_Line__c oql : [select Id from PBS_Question_Line__c where Quiz__c =: lassignment.get(0).Learning_Version__r.Quiz__c]){
            qlineIds.add(oql.Id);
        }

        Map<String, PBS_Response__c> mResponses = PBS_LearningData_Test.createTestQuestionResponses(qlineIds, lmsUsers.get(0).Id, lassignment.get(0).Id);


        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_QuizViewer;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USER_AGENT, 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53');
            pageRef.getParameters().put(AID, lassignment.get(0).Id);
            PBS_QuizViewerController_CC controller = new PBS_QuizViewerController_CC();
            controller.initializeQuestions();

            //first section
            List<PBS_QuizItem_CC> lqi = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi){
                qi.response   = mResponses.get(qi.question.Id);
            }

            controller.next();

            //second section
            List<PBS_QuizItem_CC> lqi2 = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi2){
                qi.response   = mResponses.get(qi.question.Id);
            }
            //controller.previous();
            controller.next();

            //third & final section
            List<PBS_QuizItem_CC> lqi3 = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi3){
                qi.response   = mResponses.get(qi.question.Id);
            }
            controller.done();
        }
    }

    static testmethod void testQuizViewerMobile2(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARD_USER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
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

        List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplanId order by Order__c asc];
        System.assert(ltpsec.size() == 3);

        List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
        System.assert(ltpsitem.size() == 1, TRAINING_PLAN_SECTION_ITEM_ISSUES_SIZE + ltpsitem.size());

        List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                        Learning__c, Learning_Version__r.Quiz__c from PBS_Learning_Assignment__c
                                                        where Training_Plan__c =: tplanId
                                                        and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                        and User__c =: lmsUsers.get(0).Id];

        System.assert(lassignment.size() == 1, LEARNING_ASSIGNMENT_ISSUES_SIZE + lassignment.size());
        System.assert(lassignment.get(0).Learning_Version__r.Quiz__c != null, LEARNING_ASSIGNMENT_IS_NOT_FOR_QUIZ);

        Set<Id> qlineIds = new Set<Id>();
        for(PBS_Question_Line__c oql : [select Id from PBS_Question_Line__c where Quiz__c =: lassignment.get(0).Learning_Version__r.Quiz__c]){
            qlineIds.add(oql.Id);
        }

        Map<String, PBS_Response__c> mResponses = PBS_LearningData_Test.createTestQuestionResponses(qlineIds, lmsUsers.get(0).Id, lassignment.get(0).Id);


        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_QuizViewer;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USER_AGENT, 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53');
            pageRef.getParameters().put(AID, lassignment.get(0).Id);
            PBS_QuizViewerController_CC controller = new PBS_QuizViewerController_CC();
            controller.initializeQuestions();

            //first section
            List<PBS_QuizItem_CC> lqi = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi){
                qi.response   = mResponses.get(qi.question.Id);
            }

            controller.next();
            controller.previous();
            PageReference redirect = controller.backToTrainingPlan();
            System.assert(redirect.getParameters().get('id') == tplanId, 'backToTrainingPlan is not adding params properly');

            //go back to quiz & reset it
            PageReference pageRef2 = Page.PBS_QuizViewer;
            Test.setCurrentPage(pageRef2);
            pageRef.getHeaders().put(USER_AGENT, 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53');
            pageRef2.getParameters().put(AID, lassignment.get(0).Id);
            PBS_QuizViewerController_CC controller2 = new PBS_QuizViewerController_CC();
            controller2.initializeQuestions();
            PageReference redirect2 = controller2.reset();
            System.assert(redirect2.getParameters().get(AID) == lassignment.get(0).Id, 'reset is not adding params properly');
        }
    }

    static testmethod void testQuizViewerPreview(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR);
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,STANDARD_USER);

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,LMS_USER);
        }

        PBS_TrainingPlanData_Test.createSampleData();
        List<PBS_Training_Plan__c> tplan = [select id from PBS_Training_Plan__c limit:integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tplan.size());

        List<PBS_Achievement_Category__c> lAchieveCat = PBS_AchievementData_Test.createAchievementCategories(1);
        List<PBS_Achievement__c> lAchievement = PBS_AchievementData_Test.createAchievements(1, lAchieveCat.get(0).Id, ACHIEVEMENTS);
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

        List<PBS_Training_Plan_Section__c> ltpsec = [select id from PBS_Training_Plan_Section__c where Training_Plan__c =: tplanId order by Order__c asc];
        System.assert(ltpsec.size() == 3);

        List<PBS_Training_Plan_Section_Item__c> ltpsitem = [select id from PBS_Training_Plan_Section_Item__c where Training_Plan_Section__c =: ltpsec.get(0).Id order by Order__c asc];
        System.assert(ltpsitem.size() == 1, TRAINING_PLAN_SECTION_ITEM_ISSUES_SIZE + ltpsitem.size());

        List<PBS_Learning_Assignment__c> lassignment = [select Id,
                                                        Learning__c, Learning_Version__r.Quiz__c from PBS_Learning_Assignment__c
                                                        where Training_Plan__c =: tplanId
                                                        and Training_Plan_Section__c =:ltpsec.get(0).Id
                                                        and User__c =: lmsUsers.get(0).Id];

        System.assert(lassignment.size() == 1, LEARNING_ASSIGNMENT_ISSUES_SIZE + lassignment.size());
        System.assert(lassignment.get(0).Learning_Version__r.Quiz__c != null, LEARNING_ASSIGNMENT_IS_NOT_FOR_QUIZ);

        Set<Id> qlineIds = new Set<Id>();
        for(PBS_Question_Line__c oql : [select Id from PBS_Question_Line__c where Quiz__c =: lassignment.get(0).Learning_Version__r.Quiz__c]){
            qlineIds.add(oql.Id);
        }

        Map<String, PBS_Response__c> mResponses = PBS_LearningData_Test.createTestQuestionResponses(qlineIds, lmsUsers.get(0).Id, lassignment.get(0).Id);


        System.runAs(lmsUsers.get(0)){
            PageReference pageRef = Page.PBS_QuizViewer;
            Test.setCurrentPage(pageRef);
            pageRef.getHeaders().put(USER_AGENT, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:25.0) Gecko/20100101 Firefox/25.0');
            pageRef.getParameters().put(AID, lassignment.get(0).Id);
            pageRef.getParameters().put('pMode', 'true');

            PBS_QuizViewerController_CC controller = new PBS_QuizViewerController_CC();
            controller.initializeQuestions();

            //first section
            List<PBS_QuizItem_CC> lqi = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi){
                qi.response   = mResponses.get(qi.question.Id);
            }

            controller.next();

            //second section
            List<PBS_QuizItem_CC> lqi2 = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi2){
                qi.response   = mResponses.get(qi.question.Id);
            }
            //controller.previous();
            controller.next();

            //third & final section
            List<PBS_QuizItem_CC> lqi3 = controller.quizItemList;

            for(PBS_QuizItem_CC qi : lqi3){
                qi.response   = mResponses.get(qi.question.Id);
            }
            controller.done();
        }
    } 
   
}