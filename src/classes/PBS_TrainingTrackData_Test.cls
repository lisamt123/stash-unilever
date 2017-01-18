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
public class PBS_TrainingTrackData_Test {

    public static List<PBS_Training_Track__c> createTrainingTracks(List<PBS_Params_Test.TrainingTrackParam> params){
        List<PBS_Training_Track__c> lResult = new List<PBS_Training_Track__c>();

        // PBS
        PBS_Standard_Job_Profile__c sjp = PBS_TestHelper.createJobProfile('Guest');

        for(PBS_Params_Test.TrainingTrackParam p : params){
            PBS_Training_Track__c ttrack = new PBS_Training_Track__c();
            ttrack.Name = p.Name;
            ttrack.Description__c = p.Description;
            ttrack.Status__c = p.status;
            ttrack.Background_Color__c = p.backgroundColor;
            ttrack.Background_Image_URL__c = p.backgroundImageURL;
            ttrack.Text_Color__c = p.textColor;
            ttrack.Achievement__c = p.achievementId;

            // PBS changes
            ttrack.PBS_Standard_Job_Profile__c = sjp.Id;
            ttrack.Work_Level__c               = 'Guest';
            ttrack.geography__c                = 'Guest';

            lResult.add(ttrack);
        }
        insert lResult;
        return lResult;
    }

    public static List<PBS_Training_Track_Level_Item__c> createTrainingTrackItems(String trackId, List<PBS_Training_Plan__c> tplans, Integer level){
        List<PBS_Training_Track_Level_Item__c> lResult = new List<PBS_Training_Track_Level_Item__c>();

        //Create level
        PBS_Training_Track_Level__c ttlevel = new PBS_Training_Track_Level__c();
        ttlevel.Order__c = level;
        ttlevel.Training_Track__c = trackId;
        ttlevel.Description__c = 'test';
        insert ttlevel;

        //Create items
        for(PBS_Training_Plan__c tplan : tplans){
            PBS_Training_Track_Level_Item__c ttrackItem = new PBS_Training_Track_Level_Item__c();
            ttrackItem.Training_Track_Level__c = ttlevel.Id;
            ttrackItem.Training_Plan__c = tplan.Id;
            lResult.add(ttrackItem);
        }
        insert lResult;
        return lResult;
    }

    public static void createSampleData(){

        //Create quiz learnings
        List<PBS_Learning__c> quizLearnings = PBS_LearningData_Test.createTestLearning(1, 'Quiz', false);
        //create resource learnings
        List<PBS_Learning__c> resourceLearnings = PBS_LearningData_Test.createTestLearning(3, 'Resource', false);
        //create task learnings
        List<PBS_Learning__c> taskLearnings = PBS_LearningData_Test.createTestLearning(3, 'Task', false);
        //create quiz
        List<PBS_Quiz__c> quiz = PBS_LearningData_Test.createTestQuiz(quizLearnings);
        //create question line
        List<PBS_Question_Line__c> qline = PBS_LearningData_Test.createTestQuestionLine(quiz, 3);
        //create question
        //List<PBS_Question__c> question = 
        PBS_LearningData_Test.createTestQuestions(qline, 4, null);
        //create training resources
        List<PBS_Training_Resource__c> tresources = PBS_LearningData_Test.createTestTrainingResource(resourceLearnings);
        //create task resources
        List<PBS_Task__c> ttasks = PBS_LearningData_Test.createTestTask(taskLearnings);
        //create learning categories
        List<PBS_Learning_Category__c> learningCategories = PBS_LearningData_Test.createTestLearningCategories(2);

        //Publish learnings
        for(Integer i = 0;i < quizLearnings.size();i++){
            PBS_LearningData_Test.publishLearning(quizLearnings.get(i).Id,'quiz',quiz.get(i).Id,false);
        }
        for(Integer i = 0;i < resourceLearnings.size();i++){
            PBS_LearningData_Test.publishLearning(resourceLearnings.get(i).Id,'resource',tresources.get(i).Id,false);
        }
        for(Integer i = 0;i < taskLearnings.size();i++){
            PBS_LearningData_Test.publishLearning(taskLearnings.get(i).Id,'task',ttasks.get(i).Id,false);
        }

        //Create training plans
        PBS_Params_Test.TrainingPlanParam tplan1 = new PBS_Params_Test.TrainingPlanParam();
        PBS_Params_Test.TrainingPlanParam tplan2 = new PBS_Params_Test.TrainingPlanParam();
        PBS_Params_Test.TrainingPlanParam tplan3 = new PBS_Params_Test.TrainingPlanParam();
        List<PBS_Training_Plan__c> tplans = PBS_TrainingPlanData_Test.createTrainingPlans(new List<PBS_Params_Test.TrainingPlanParam>{tplan1,tplan2,tplan3});

        //Add learning categories to training plan
        //List<PBS_Training_Plan_Category__c> tplanCategories =
        PBS_TrainingPlanData_Test.createTrainingPlanCategories(tplans,learningCategories);

        //Create training plan sections
        List<PBS_Training_Plan_Section__c> tplanSections1 = PBS_TrainingPlanData_Test.createTrainingPlanSections(tplans.get(0).Id,1);
        List<PBS_Training_Plan_Section__c> tplanSections2 = PBS_TrainingPlanData_Test.createTrainingPlanSections(tplans.get(1).Id,2);
        List<PBS_Training_Plan_Section__c> tplanSections3 = PBS_TrainingPlanData_Test.createTrainingPlanSections(tplans.get(2).Id,1);


        //Create training plan section items for quizzes
       //List<PBS_Training_Plan_Section_Item__c> tplan1SectionItems1 = 
        PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections1.get(0).Id,quizLearnings);

        //List<PBS_Training_Plan_Section_Item__c> tplan2SectionItems1 = 
        PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections2.get(0).Id,resourceLearnings);
        //List<PBS_Training_Plan_Section_Item__c> tplan2SectionItems2 = 
        PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections2.get(1).Id,taskLearnings);

        //List<PBS_Training_Plan_Section_Item__c> tplan3SectionItems1 =
         PBS_TrainingPlanData_Test.createTrainingPlanSectionItems(tplanSections3.get(0).Id,resourceLearnings);

        //Create a training track
        PBS_Params_Test.TrainingTrackParam ttrack1 = new PBS_Params_Test.TrainingTrackParam();
        List<PBS_Training_Track__c> ttracks = createTrainingTracks(new List<PBS_Params_Test.TrainingTrackParam>{ttrack1});

        //Add training track items
        //List<PBS_Training_Track_Level_Item__c> trackItems1 = 
        createTrainingTrackItems(ttracks.get(0).Id,new List<PBS_Training_Plan__c>{tplans.get(0)},1);
        //List<PBS_Training_Track_Level_Item__c> trackItems2 = 
        createTrainingTrackItems(ttracks.get(0).Id,new List<PBS_Training_Plan__c>{tplans.get(1),tplans.get(2)},2);
    }
}