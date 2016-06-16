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
public class PBS_QuestionNewController_Test {

        public static final string SYSTEM_ADMINISTRATOR = 'system administrator';
        public static final string LMS_ADMIN= 'PBS_LMS_Admin';
        public static final string QUIZ1= 'quiz';
        public static final string RETURL= 'returl';
        public static final string EXTENSION_QUETION_IS_NOT_INITIALIZED = 'extension.question is not initialized';
        public static final string THIS_IS_A_TEST_OF_BOOLEAN= 'this is a test of boolean?';
        public static final string PB_BOOLEAN= 'boolean';
        public static final string ISSUE_WITH_QUESTION_SIZE = 'issues with question, size = ';
        public static final string SELECTMULTIPLEQUESTION= 'selectmultiplequestion';
        
        
    static testmethod void testCreateBooleanQuestion(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );
        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = THIS_IS_A_TEST_OF_BOOLEAN;
            extension.question.Type__c = PB_BOOLEAN;
            extension.question.Order__c = 1;
            extension.questiontype = PB_BOOLEAN;
            extension.answerseqenabler();
            extension.question.Correct_Boolean__c = 'true';
            extension.c_save();

            List<PBS_Question__c> lquestions = [select Id, Description__c, Type__c, Order__c, Correct_Boolean__c  from PBS_Question__c where Question_Line__c =: qline.get(0).Id];
            System.assert(lquestions.size() == 1, ISSUE_WITH_QUESTION_SIZE + lquestions.size());
            System.assert(lquestions.get(0).Description__c == THIS_IS_A_TEST_OF_BOOLEAN);
            System.assert(lquestions.get(0).Type__c == PB_BOOLEAN);
            System.assert(lquestions.get(0).Order__c == 1);
            System.assert(lquestions.get(0).Correct_Boolean__c == 'true');
        }
    }

    static testmethod void testCreateNumberQuestion(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );

        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = 'What is the age of the kid?';
            extension.question.Type__c = 'Number';
            extension.question.Order__c = 1;
            extension.questiontype = 'Number';
            extension.answerseqenabler();
            extension.question.Correct_Number__c = 3;
            extension.c_save();

            List<PBS_Question__c> lquestions = [select Id, Description__c, Type__c, Order__c, Correct_Number__c  from PBS_Question__c where Question_Line__c =: qline.get(0).Id];
            System.assert(lquestions.size() == 1, ISSUE_WITH_QUESTION_SIZE + lquestions.size());
            System.assert(lquestions.get(0).Description__c == 'What is the age of the kid?');
            System.assert(lquestions.get(0).Type__c == 'Number');
            System.assert(lquestions.get(0).Order__c == 1);
            System.assert(lquestions.get(0).Correct_Number__c == 3);
        }
    }

    static testmethod void testCreateTextQuestion(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );
        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = 'What is love?';
            extension.question.Type__c = 'Text';
            extension.question.Order__c = 1;
            extension.questiontype = 'Text';
            extension.answerseqenabler();
            extension.c_save();

            List<PBS_Question__c> lquestions = [select Id, Description__c, Type__c, Order__c from PBS_Question__c where Question_Line__c =: qline.get(0).Id];
            System.assert(lquestions.size() == 1, ISSUE_WITH_QUESTION_SIZE + lquestions.size());
            System.assert(lquestions.get(0).Description__c == 'What is love?');
            System.assert(lquestions.get(0).Type__c == 'Text');
            System.assert(lquestions.get(0).Order__c == 1);
        }
    }

    static testmethod void testCreateSelectOneQuestion(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );
        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = 'What is the best Blur song?';
            extension.question.Type__c = 'SelectOneQuestion';
            extension.question.Order__c = 1;
            extension.questiontype = 'SelectOneQuestion';
            extension.answerseqenabler();

            extension.lanswerseqitems.get(0).Item_Id__c = '#ans1';
            extension.lanswerseqitems.get(0).Answer_Text__c = 'Coffee & TV';
            extension.lanswerseqitems.get(0).Order__c = 1;
            extension.lanswerseqitems.get(0).Is_Correct_Answer__c = true;

            extension.addanswerseqitem();
            extension.lanswerseqitems.get(1).Item_Id__c = '#ans2';
            extension.lanswerseqitems.get(1).Answer_Text__c = 'Song #2';
            extension.lanswerseqitems.get(1).Order__c = 1;
            extension.lanswerseqitems.get(1).Is_Correct_Answer__c = false;

            extension.c_save();

            List<PBS_Answer_Sequence__c> lansseq = [select id from PBS_Answer_Sequence__c limit:integer.valueof(System.Label.PBS_soqllimit)];
            System.assert(lansseq.size() == 1, 'Answer Sequence is wrong, size = ' + lansseq.size());

            List<PBS_Answer_Sequence_Item__c> lasitem = [select id from PBS_Answer_Sequence_Item__c where Answer_Sequence__c = :lansseq.get(0).Id];
            System.assert(lasitem.size() == 2, 'Answer Sequence Item is wrong, size = ' + lasitem.size());

            List<PBS_Question__c> lquestions = [select Id,
                                                Description__c,
                                                Type__c,
                                                Order__c from PBS_Question__c
                                                where Question_Line__c =: qline.get(0).Id and Answer_Sequence__c =: lansseq.get(0).Id];

            System.assert(lquestions.size() == 1, ISSUE_WITH_QUESTION_SIZE + lquestions.size());
            System.assert(lquestions.get(0).Description__c == 'What is the best Blur song?');
            System.assert(lquestions.get(0).Type__c == 'SelectOneQuestion');
            System.assert(lquestions.get(0).Order__c == 1);
        }
    }

    static testmethod void testCreateSelectMultipleQuestion(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );
        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = 'What Blur songs are part of The Great Escape?';
            extension.question.Type__c = SELECTMULTIPLEQUESTION;
            extension.question.Order__c = 1;
            extension.questiontype = SELECTMULTIPLEQUESTION;
            extension.answerseqenabler();

            extension.lanswerseqitems.get(0).Item_Id__c = '#ans1';
            extension.lanswerseqitems.get(0).Answer_Text__c = 'Coffee & TV';
            extension.lanswerseqitems.get(0).Order__c = 1;
            extension.lanswerseqitems.get(0).Is_Correct_Answer__c = false;

            extension.addanswerseqitem();
            extension.lanswerseqitems.get(1).Item_Id__c = '#ans2';
            extension.lanswerseqitems.get(1).Answer_Text__c = 'Charmless Man';
            extension.lanswerseqitems.get(1).Order__c = 1;
            extension.lanswerseqitems.get(1).Is_Correct_Answer__c = true;

            extension.addanswerseqitem();
            extension.lanswerseqitems.get(2).Item_Id__c = '#ans3';
            extension.lanswerseqitems.get(2).Answer_Text__c = 'The Universal';
            extension.lanswerseqitems.get(2).Order__c = 1;
            extension.lanswerseqitems.get(2).Is_Correct_Answer__c = true;

            extension.c_save();

            List<PBS_Answer_Sequence__c> lansseq = [select id from PBS_Answer_Sequence__c limit:integer.valueof(System.Label.PBS_soqllimit)];
            System.assert(lansseq.size() == 1, 'Answer Sequence is wrong, size = ' + lansseq.size());

            List<PBS_Answer_Sequence_Item__c> lasitem = [select id from PBS_Answer_Sequence_Item__c where Answer_Sequence__c = :lansseq.get(0).Id];
            System.assert(lasitem.size() == 3, 'Answer Sequence Item is wrong, size = ' + lasitem.size());

            List<PBS_Question__c> lquestions = [select Id,
                                                Description__c,
                                                Type__c,
                                                Order__c from PBS_Question__c
                                                where Question_Line__c =: qline.get(0).Id and Answer_Sequence__c =: lansseq.get(0).Id];

            System.assert(lquestions.size() == 1, ISSUE_WITH_QUESTION_SIZE + lquestions.size());
            System.assert(lquestions.get(0).Description__c == 'What Blur songs are part of The Great Escape?');
            System.assert(lquestions.get(0).Type__c == SELECTMULTIPLEQUESTION);
            System.assert(lquestions.get(0).Order__c == 1);
        }
    }

    static testmethod void testCancelCreateQuestion(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );
        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = THIS_IS_A_TEST_OF_BOOLEAN;
            extension.question.Type__c = PB_BOOLEAN;
            extension.question.Order__c = 1;
            extension.questiontype = PB_BOOLEAN;
            extension.answerseqenabler();
            extension.question.Correct_Boolean__c = 'true';
            extension.cancel();

            List<PBS_Question__c> lquestions = [select Id, Description__c, Type__c, Order__c, Correct_Boolean__c  from PBS_Question__c where Question_Line__c =: qline.get(0).Id];
            System.assert(lquestions.size() == 0, ISSUE_WITH_QUESTION_SIZE + lquestions.size());
        }
    }

    static testmethod void testCreateBooleanQuestionAndEdit(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );
        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = THIS_IS_A_TEST_OF_BOOLEAN;
            extension.question.Type__c = PB_BOOLEAN;
            extension.question.Order__c = 1;
            extension.questiontype = PB_BOOLEAN;
            extension.answerseqenabler();
            extension.question.Correct_Boolean__c = 'true';
            extension.c_save();

            List<PBS_Question__c> lquestions = [select Id, Description__c, Type__c, Order__c, Correct_Boolean__c  from PBS_Question__c where Question_Line__c =: qline.get(0).Id];
            System.assert(lquestions.size() == 1);

            PageReference pageRef2 = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef2);
            pageRef2.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller2 = new ApexPages.StandardController(lquestions.get(0));
            PBS_QuestionNewController_CC extension2 = new PBS_QuestionNewController_CC(stdcontroller2);

            System.assert(extension2.question.Description__c == THIS_IS_A_TEST_OF_BOOLEAN);
            System.assert(extension2.question.Type__c == PB_BOOLEAN);
            System.assert(extension2.question.Order__c == 1);
            System.assert(extension2.question.Correct_Boolean__c == 'true');

            extension2.question.Correct_Boolean__c = 'false';
            extension2.c_save();

            List<PBS_Question__c> lquestions2 = [select Id, Description__c, Type__c, Order__c, Correct_Boolean__c  from PBS_Question__c where Question_Line__c =: qline.get(0).Id];
            System.assert(lquestions2.size() == 1);
            System.assert(lquestions2.get(0).Correct_Boolean__c == 'false');

        }
    }

    static testmethod void testCreateSelectMultipleQuestionAndEdit(){
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,SYSTEM_ADMINISTRATOR );
        //Assign corresponding perm sets
        PBS_UtilClass_Test.addPermissionSet(adminUsers,LMS_ADMIN);

        System.runAs(adminUsers.get(0)){

            //Create quiz learnings
            List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, QUIZ1, true);
            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 1);

            //go to QuestionNew page
            PageReference pageRef = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(new PBS_Question__c());
            PBS_QuestionNewController_CC extension = new PBS_QuestionNewController_CC(stdcontroller);
            System.assert(extension.question != null, EXTENSION_QUETION_IS_NOT_INITIALIZED);
            extension.question.Description__c = 'What Blur songs are part of The Great Escape?';
            extension.question.Type__c = SELECTMULTIPLEQUESTION;
            extension.question.Order__c = 1;
            extension.questiontype = SELECTMULTIPLEQUESTION;
            extension.answerseqenabler();

            extension.lanswerseqitems.get(0).Item_Id__c = '#ans1';
            extension.lanswerseqitems.get(0).Answer_Text__c = 'Coffee & TV';
            extension.lanswerseqitems.get(0).Order__c = 1;
            extension.lanswerseqitems.get(0).Is_Correct_Answer__c = false;

            extension.addanswerseqitem();
            extension.lanswerseqitems.get(1).Item_Id__c = '#ans2';
            extension.lanswerseqitems.get(1).Answer_Text__c = 'Charmless Man';
            extension.lanswerseqitems.get(1).Order__c = 1;
            extension.lanswerseqitems.get(1).Is_Correct_Answer__c = true;

            extension.addanswerseqitem();
            extension.lanswerseqitems.get(2).Item_Id__c = '#ans3';
            extension.lanswerseqitems.get(2).Answer_Text__c = 'The Universal';
            extension.lanswerseqitems.get(2).Order__c = 1;
            extension.lanswerseqitems.get(2).Is_Correct_Answer__c = true;

            extension.c_save();

            List<PBS_Answer_Sequence__c> lansseq = [select id from PBS_Answer_Sequence__c limit:integer.valueof(System.Label.PBS_soqllimit)];
            System.assert(lansseq.size() == 1, 'Answer Sequence is wrong, size = ' + lansseq.size());

            List<PBS_Question__c> lquestions = [select Id,
                                                Description__c,
                                                Type__c,
                                                Order__c,
                                                Answer_Sequence__c,
                                                Correct_Number__c,
                                                Correct_Boolean__c from PBS_Question__c
                                                where Question_Line__c =: qline.get(0).Id and Answer_Sequence__c =: lansseq.get(0).Id];

            //go to QuestionNew page
            PageReference pageRef2 = Page.PBS_QuestionNew;
            Test.setCurrentPage(pageRef2);
            pageRef2.getParameters().put(RETURL, '/'+qline.get(0).Id);
            ApexPages.Standardcontroller stdcontroller2 = new ApexPages.StandardController(lquestions.get(0));
            PBS_QuestionNewController_CC extension2 = new PBS_QuestionNewController_CC(stdcontroller2);

            System.assert(extension2.question.Description__c == 'What Blur songs are part of The Great Escape?');
            System.assert(extension2.question.Type__c == SELECTMULTIPLEQUESTION);
            System.assert(extension2.question.Order__c == 1);

            List<PBS_Answer_Sequence_Item__c> lasitem = [select id from PBS_Answer_Sequence_Item__c where Answer_Sequence__c = :lansseq.get(0).Id];
            System.assert(lasitem.size() == 3, 'Answer Sequence Item is wrong, size = ' + lasitem.size());
            System.assert(lasitem.size() == extension2.lanswerseqitems.size());

        }
    }

}