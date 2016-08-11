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
public class PBS_Learning_Test {

        public static final string System_Administrator ='System Administrator';
        public static final string LMS_Admin= 'PBS_LMS_Admin';
        public static final string SELECTEDCONTENT_IS_WRONG = 'selectedcontent is wrong';
        public static final string CURRENTRECORDTYPE_IS_WRONG= 'currentrecordtype is wrong';
        public static final string GETCONTENTS_IS_WRONG= 'getcontents is wrong';
        public static final string LEARNING_TASK= 'Task';
        private static final string LEARNING_PREVIEWED= 'Learning has already been previewed';

    static testmethod void testLearningQuizAndPreview(){
    
    

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, 'Quiz', false);

            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(learning);

            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 3);

            //create question
            PBS_LearningData_Test.createTestQuestions(qline, 4, null);


            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Preview'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, LEARNING_PREVIEWED);

            PageReference pageRef = Page.PBS_Learning_Preview;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Preview_Ext_CC extension = new PBS_Learning_Preview_Ext_CC(stdcontroller);
            extension.selectedContent = quiz.get(0).Id;
            List<sObject> lsobjects = extension.getContents();
            System.assert(String.isNotBlank(extension.selectedContent), SELECTEDCONTENT_IS_WRONG);
            System.assert(extension.currentRecordType == 'Quiz', CURRENTRECORDTYPE_IS_WRONG);
            System.assert(lsobjects.size() == 1, GETCONTENTS_IS_WRONG);

            extension.previewContent();
           
        }

    }

    static testmethod void testLearningTrainingResourceAndPreview(){

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, 'Resource', false);

            //create training resource
            List<PBS_Training_Resource__c> tresource = PBS_LearningData_Test.createTestTrainingResource(learning);


            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Preview'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, LEARNING_PREVIEWED);

            PageReference pageRef = Page.PBS_Learning_Preview;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Preview_Ext_CC extension = new PBS_Learning_Preview_Ext_CC(stdcontroller);
            extension.selectedContent = tresource.get(0).Id;
            List<sObject> lsobjects = extension.getContents();
            System.assert(String.isNotBlank(extension.selectedContent), SELECTEDCONTENT_IS_WRONG);
            System.assert(extension.currentRecordType == 'Resource', CURRENTRECORDTYPE_IS_WRONG);
            System.assert(lsobjects.size() == 1, GETCONTENTS_IS_WRONG);

            extension.previewContent();
           
        }

    }

    static testmethod void testLearningTaskAndPreview(){

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, LEARNING_TASK, false);

            //create task
            List<PBS_Task__c> task = PBS_LearningData_Test.createTestTask(learning);

            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Preview'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, LEARNING_PREVIEWED);

            PageReference pageRef = Page.PBS_Learning_Preview;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Preview_Ext_CC extension = new PBS_Learning_Preview_Ext_CC(stdcontroller);
            extension.selectedContent = task.get(0).Id;
            List<sObject> lsobjects = extension.getContents();
            System.assert(String.isNotBlank(extension.selectedContent), SELECTEDCONTENT_IS_WRONG);
            System.assert(extension.currentRecordType == LEARNING_TASK, CURRENTRECORDTYPE_IS_WRONG);
            System.assert(lsobjects.size() == 1, GETCONTENTS_IS_WRONG);

            extension.previewContent();
           
        }

    }

    static testmethod void testExistingLearningPreview(){

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(2,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        List<PBS_Learning__c> learning;
        List<PBS_Task__c> task;

        System.runAs(systemUsers.get(0)){

            //create learning
            learning = PBS_LearningData_Test.createTestLearning(1, LEARNING_TASK, false);

            //create task
            task = PBS_LearningData_Test.createTestTask(learning);


            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Preview'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, LEARNING_PREVIEWED);

            PageReference pageRef = Page.PBS_Learning_Preview;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Preview_Ext_CC extension = new PBS_Learning_Preview_Ext_CC(stdcontroller);
            extension.selectedContent = task.get(0).Id;
            List<sObject> lsobjects = extension.getContents();
            System.assert(String.isNotBlank(extension.selectedContent), SELECTEDCONTENT_IS_WRONG);
            System.assert(extension.currentRecordType == LEARNING_TASK, CURRENTRECORDTYPE_IS_WRONG);
            System.assert(lsobjects.size() == 1, GETCONTENTS_IS_WRONG);

            extension.previewContent();

             System.assert(extension.doRedirection()== null);
        }

        System.runAs(systemUsers.get(1)){
          
            PageReference pageRef = Page.PBS_Learning_Preview;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Preview_Ext_CC extension = new PBS_Learning_Preview_Ext_CC(stdcontroller);
            extension.selectedContent = task.get(0).Id;
            System.assert(String.isNotBlank(extension.selectedContent), SELECTEDCONTENT_IS_WRONG);
            System.assert(extension.currentRecordType == LEARNING_TASK, CURRENTRECORDTYPE_IS_WRONG);

            extension.previewContent();
            
        }

    }

    static testmethod void testLearningPreviewFail(){

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);

        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, LEARNING_TASK, false);

            //create task
            PBS_LearningData_Test.createTestTask(learning);

            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Preview'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, LEARNING_PREVIEWED);

            PageReference pageRef = Page.PBS_Learning_Preview;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Preview_Ext_CC extension = new PBS_Learning_Preview_Ext_CC(stdcontroller);
            //extension.selectedContent = task.get(0).Id;
            List<sObject> lsobjects = extension.getContents();
            System.assert(String.isBlank(extension.selectedContent), SELECTEDCONTENT_IS_WRONG);
            System.assert(extension.currentRecordType == LEARNING_TASK, CURRENTRECORDTYPE_IS_WRONG);
            System.assert(lsobjects.size() == 1, GETCONTENTS_IS_WRONG);

            extension.previewContent();

            System.assert(ApexPages.getMessages().size() == 1, 'Page error messages is wrong');
           
        }

    }

    static testmethod void testLearningQuizAndPublish(){

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, 'Quiz', false);

            //create quiz
            List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(learning);

            //create question line
            List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 3);

            //create question
            PBS_LearningData_Test.createTestQuestions(qline, 4, null);

            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Publish'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, LEARNING_PREVIEWED);

            PageReference pageRef = Page.PBS_Learning_Publish;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Publish_Ext_CC extension = new PBS_Learning_Publish_Ext_CC(stdcontroller);
            extension.dummyLearningVersion.Version_selection_behavior__c = 'Update version on launch';
            extension.getContents();
            extension.publishContent();

        }

    }

    static testmethod void testLearningTrainingResourceAndPublish(){

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, 'Resource', false);

            //create training resource
            PBS_LearningData_Test.createTestTrainingResource(learning);

            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Published'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, 'Learning has already been published');

            PageReference pageRef = Page.PBS_Learning_Publish;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Publish_Ext_CC extension = new PBS_Learning_Publish_Ext_CC(stdcontroller);
            extension.dummyLearningVersion.Version_selection_behavior__c = 'Update version on launch';
            extension.getContents();
            extension.publishContent();
           }

    }

    static testmethod void testLearningTaskAndPublish(){
        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, LEARNING_TASK, false);

            //create task
            PBS_LearningData_Test.createTestTask(learning);

            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Published'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, 'Learning has already been published');

            PageReference pageRef = Page.PBS_Learning_Publish;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Publish_Ext_CC extension = new PBS_Learning_Publish_Ext_CC(stdcontroller);
            extension.dummyLearningVersion.Version_selection_behavior__c = 'Update version on launch';
            extension.getContents();
            //System.assert(lsobjects.size() == 1, GETCONTENTS_IS_WRONG);
            extension.publishContent();
            
        }

    }

    static testmethod void testLearningTaskRePublish(){

        //create users
        List<User> systemUsers = PBS_UtilClass_Test.createUsers(2,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);

        List<PBS_Learning__c> learning;
       // List<PBS_Task__c> task;

        System.runAs(systemUsers.get(0)){

            //create learning
            learning = PBS_LearningData_Test.createTestLearning(1, LEARNING_TASK, false);

            List<PBS_Learning_Version__c> learningversions = [select id from PBS_Learning_Version__c
                                                                where Type__c = 'Published'
                                                                and Learning__c = :learning.get(0).Id];

            System.assert(learningversions.size() == 0, 'Learning has already been published');

            PageReference pageRef = Page.PBS_Learning_Publish;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Publish_Ext_CC extension = new PBS_Learning_Publish_Ext_CC(stdcontroller);
            extension.dummyLearningVersion.Version_selection_behavior__c = 'Update version on launch';
            extension.publishContent();

          }

        System.runAs(systemUsers.get(1)){         

            PageReference pageRef = Page.PBS_Learning_Publish;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
            PBS_Learning_Publish_Ext_CC extension = new PBS_Learning_Publish_Ext_CC(stdcontroller);
            extension.dummyLearningVersion.Version_selection_behavior__c = 'Ask user for version selection';
            extension.getContents();
            //System.assert(lsobjects.size() == 1, GETCONTENTS_IS_WRONG);
            extension.publishContent();
             
        }
    }
   static testmethod void testExcpt(){

       List<User> systemUsers = PBS_UtilClass_Test.createUsers(1,System_Administrator);
        PBS_UtilClass_Test.addPermissionSet(systemUsers, LMS_Admin);
       
        System.runAs(systemUsers.get(0)){

            //create learning
            List<PBS_Learning__c> learning = PBS_LearningData_Test.createTestLearning(1, LEARNING_TASK, false);

            //create task
             ApexPages.Standardcontroller stdcontroller = New ApexPages.StandardController(learning.get(0));
           PBS_Learning_Preview_Ext_CC extension = new PBS_Learning_Preview_Ext_CC(stdcontroller);
           System.assert(extension.getContents()!=null);
              
            }
        
       
        }       
}