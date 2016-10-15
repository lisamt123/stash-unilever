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
public class PBS_TestTrainingPlanData_Test {
/*
    public static List<Almond__Training_Plan__c> createTrainingPlans(List<TestParams.TrainingPlanParam> params){
        List<Almond__Training_Plan__c> lResult = new List<Almond__Training_Plan__c>();
        for(TestParams.TrainingPlanParam p : params){
            Almond__Training_Plan__c tplan = new Almond__Training_Plan__c();
            tplan.Name = p.Name;
            tplan.Almond__Chatter_Notifications_Enabled__c = p.chatterNotificationsEnabled;
            tplan.Almond__Description__c = p.Description;
            tplan.Almond__Enable_Self_Registration__c = p.enableSelfRegistration;
            tplan.Almond__End_Date__c =  p.endDate;
            tplan.Almond__Start_Date__c = p.startDate;
            tplan.Almond__Enforce_Sequence__c = p.enforceSequence;
            tplan.Almond__Self_Registration_Access__c = p.selfRegistrationAccess;
            tplan.Almond__Status__c = p.status;
            lResult.add(tplan);
        }
        insert lResult;
        return lResult;
    }

    public static List<Almond__Training_Plan_Section__c> createTrainingPlanSections(String tplanId, Integer totalSections){
        List<Almond__Training_Plan_Section__c> lResult = new List<Almond__Training_Plan_Section__c>();
        for(Integer i =1;i<= totalSections;i++){
            Almond__Training_Plan_Section__c tPlanSection = new Almond__Training_Plan_Section__c();
            tPlanSection.Almond__Optional__c = false;
            tPlanSection.Almond__Order__c = i;
            tPlanSection.Almond__Training_Plan__c = tplanId;
            lResult.add(tPlanSection);
        }
        insert lResult;
        return lResult;
    }

    public static List<Almond__Training_Plan_Section_Item__c> createTrainingPlanSectionItems(String tplanSectionId,List<Almond__Learning__c> learnings){
        List<Almond__Training_Plan_Section_Item__c> lResult = new List<Almond__Training_Plan_Section_Item__c>();
        for(Almond__Learning__c l : learnings){
            Almond__Training_Plan_Section_Item__c tPlanSectionItem = new Almond__Training_Plan_Section_Item__c();
            tPlanSectionItem.Almond__Optional__c = false;
            tPlanSectionItem.Almond__Order__c = lResult.size()+1;
            tPlanSectionItem.Almond__Learning__c = l.Id;
            tPlanSectionItem.Almond__Training_Plan_Section__c = tplanSectionId;
            lResult.add(tPlanSectionItem);
        }
        insert lResult;
        return lResult;
    }

    public static List<Almond__Training_Plan_Achievement__c> createTrainingPlanAchievements(List<Almond__Training_Plan__c> lTPlans, List<Almond__Achievement__c> lAchievements){
        List<Almond__Training_Plan_Achievement__c> lResult = new List<Almond__Training_Plan_Achievement__c>();
        for(Integer i = 0; i < lTPlans.size(); i++){
            Almond__Training_Plan_Achievement__c otpa = new Almond__Training_Plan_Achievement__c();
            otpa.Almond__Achievement__c = lAchievements.get(i).Id;
            otpa.Almond__Main_Achievement__c = true;
            otpa.Almond__Training_Plan__c = lTPlans.get(i).Id;
            otpa.Almond__Type__c = 'Plan';
            lResult.add(otpa);
        }
        insert lResult;
        return lResult;
    }

    public static List<Almond__Training_Plan_Achievement__c> createTrainingPlanSectionAchievements(List<Almond__Training_Plan_Section__c> lTPlanSections, List<Almond__Achievement__c> lAchievements){
        List<Almond__Training_Plan_Achievement__c> lResult = new List<Almond__Training_Plan_Achievement__c>();
        for(Integer i = 0; i < lTPlanSections.size(); i++){
            Almond__Training_Plan_Achievement__c otpa = new Almond__Training_Plan_Achievement__c();
            otpa.Almond__Achievement__c = lAchievements.get(i).Id;
            otpa.Almond__Main_Achievement__c = true;
            otpa.Almond__Training_Plan__c = lTPlanSections.get(i).Almond__Training_Plan__c;
            otpa.Almond__Training_Plan_Section__c = lTPlanSections.get(i).Id;
            otpa.Almond__Type__c = 'Section';
            lResult.add(otpa);
        }
        insert lResult;
        return lResult;
    }

    public static List<Almond__Training_Plan_Category__c> createTrainingPlanCategories(List<Almond__Training_Plan__c> lTPlans, List<Almond__Learning_Category__c> lCategories){
        List<Almond__Training_Plan_Category__c> lResult = new List<Almond__Training_Plan_Category__c>();
        for(Almond__Training_Plan__c tplan : lTPlans){
            for(Almond__Learning_Category__c  lc : lCategories){
                Almond__Training_Plan_Category__c tpc = new Almond__Training_Plan_Category__c();
                tpc.Almond__Training_Plan__c = tplan.Id;
                tpc.Almond__Learning_Category__c = lc.Id;
                lResult.add(tpc);
            }

        }
        insert lResult;
        return lResult;
    }

    public static void createSampleData(){

        //Create quiz learnings
        List<Almond__Learning__c> quizLearnings = PBS_TestLearningData_Test.createTestLearning(1, 'Quiz', false);
        //create resource learnings
        List<Almond__Learning__c> resourceLearnings = PBS_TestLearningData_Test.createTestLearning(3, 'Resource', false);
        //create task learnings
        List<Almond__Learning__c> taskLearnings = PBS_TestLearningData_Test.createTestLearning(3, 'Task', false);
        //create quiz
        List<Almond__Quiz__c> quiz = PBS_TestLearningData_Test.createTestQuiz(quizLearnings);
        //create question line
        List<Almond__Question_Line__c> qline = PBS_TestLearningData_Test.createTestQuestionLine(quiz, 3);
        //create question
        List<Almond__Question__c> question = PBS_TestLearningData_Test.createTestQuestions(qline, 4, null);
        //create training resources
        List<Almond__Training_Resource__c> tresources = PBS_TestLearningData_Test.createTestTrainingResource(resourceLearnings);
        //create task resources
        List<Almond__Task__c> ttasks = PBS_TestLearningData_Test.createTestTask(taskLearnings);
        //create learning categories
        List<Almond__Learning_Category__c> learningCategories = PBS_TestLearningData_Test.createTestLearningCategories(2);

        //Publish learnings
        for(Integer i = 0;i < quizLearnings.size();i++){
            PBS_TestLearningData_Test.publishLearning(quizLearnings.get(i).Id,'quiz',quiz.get(i).Id,false);
        }
        for(Integer i = 0;i < resourceLearnings.size();i++){
            PBS_TestLearningData_Test.publishLearning(resourceLearnings.get(i).Id,'resource',tresources.get(i).Id,false);
        }
        for(Integer i = 0;i < taskLearnings.size();i++){
            PBS_TestLearningData_Test.publishLearning(taskLearnings.get(i).Id,'task',ttasks.get(i).Id,false);
        }

        //Create training plans
        TestParams.TrainingPlanParam tplan = new TestParams.TrainingPlanParam ();
        List<Almond__Training_Plan__c> tplans = createTrainingPlans(new List<TestParams.TrainingPlanParam>{tplan});

        //Add learning categories to training plan
        List<Almond__Training_Plan_Category__c> tplanCategories = createTrainingPlanCategories(tplans,learningCategories);

        //Create training plan sections
        List<Almond__Training_Plan_Section__c> tplanSections = createTrainingPlanSections(tplans.get(0).Id,3);

        //Create training plan section items for quizzes
        List<Almond__Training_Plan_Section_Item__c> tplanSectionItmes1 = createTrainingPlanSectionItems(tplanSections.get(0).Id,quizLearnings);
        //Create training plan section items for resources
        List<Almond__Training_Plan_Section_Item__c> tplanSectionItmes2 = createTrainingPlanSectionItems(tplanSections.get(1).Id,resourceLearnings);
        //Create training plan section items for tasks
        List<Almond__Training_Plan_Section_Item__c> tplanSectionItmes3 = createTrainingPlanSectionItems(tplanSections.get(2).Id,taskLearnings);

    }

    public static void createSampleDataWithSharedLearnings(){

        //Create quiz learnings
        List<Almond__Learning__c> quizLearnings = PBS_TestLearningData_Test.createTestLearning(1, 'Quiz', true);
        //create resource learnings
        List<Almond__Learning__c> resourceLearnings = PBS_TestLearningData_Test.createTestLearning(1, 'Resource', true);
        //create task learnings
        List<Almond__Learning__c> taskLearnings = PBS_TestLearningData_Test.createTestLearning(1, 'Task', true);
        //create quiz
        List<Almond__Quiz__c> quiz = PBS_TestLearningData_Test.createTestQuiz(quizLearnings);
        //create question line
        List<Almond__Question_Line__c> qline = PBS_TestLearningData_Test.createTestQuestionLine(quiz, 3);
        //create question
        List<Almond__Question__c> question = PBS_TestLearningData_Test.createTestQuestions(qline, 4, null);
        //create training resources
        List<Almond__Training_Resource__c> tresources = PBS_TestLearningData_Test.createTestTrainingResource(resourceLearnings);
        //create task resources
        List<Almond__Task__c> ttasks = PBS_TestLearningData_Test.createTestTask(taskLearnings);
        //create learning categories
        List<Almond__Learning_Category__c> learningCategories = PBS_TestLearningData_Test.createTestLearningCategories(2);

        //Publish learnings
        for(Integer i = 0;i < quizLearnings.size();i++){
            PBS_TestLearningData_Test.publishLearning(quizLearnings.get(i).Id,'quiz',quiz.get(i).Id,false);
        }
        for(Integer i = 0;i < resourceLearnings.size();i++){
            PBS_TestLearningData_Test.publishLearning(resourceLearnings.get(i).Id,'resource',tresources.get(i).Id,false);
        }
        for(Integer i = 0;i < taskLearnings.size();i++){
            PBS_TestLearningData_Test.publishLearning(taskLearnings.get(i).Id,'task',ttasks.get(i).Id,false);
        }

        //Create training plans
        List<Almond__Training_Plan__c> tplans = createTrainingPlans(new List<TestParams.TrainingPlanParam>{new TestParams.TrainingPlanParam (),new TestParams.TrainingPlanParam ()});
        //Add learning categories to training plan
        List<Almond__Training_Plan_Category__c> tplanCategories = createTrainingPlanCategories(tplans,learningCategories);
        //Create training plan sections
        List<Almond__Training_Plan_Section__c> tplanSections1 = createTrainingPlanSections(tplans.get(0).Id,3);
        //Create training plan section items for quizzes
        List<Almond__Training_Plan_Section_Item__c> tplan1SectionItems1 = createTrainingPlanSectionItems(tplanSections1.get(0).Id,quizLearnings);
        //Create training plan section items for resources
        List<Almond__Training_Plan_Section_Item__c> tplan1SectionItems2 = createTrainingPlanSectionItems(tplanSections1.get(1).Id,resourceLearnings);
        //Create training plan section items for tasks
        List<Almond__Training_Plan_Section_Item__c> tplan1SectionItems3 = createTrainingPlanSectionItems(tplanSections1.get(2).Id,taskLearnings);

        //Create training plan sections
        List<Almond__Training_Plan_Section__c> tplanSections2 = createTrainingPlanSections(tplans.get(1).Id,3);
        //Create training plan section items for quizzes
        List<Almond__Training_Plan_Section_Item__c> tplan2SectionItems1 = createTrainingPlanSectionItems(tplanSections2.get(0).Id,quizLearnings);
        //Create training plan section items for resources
        List<Almond__Training_Plan_Section_Item__c> tplan2SectionItems2 = createTrainingPlanSectionItems(tplanSections2.get(1).Id,resourceLearnings);
        //Create training plan section items for tasks
        List<Almond__Training_Plan_Section_Item__c> tplan2SectionItems3 = createTrainingPlanSectionItems(tplanSections2.get(2).Id,taskLearnings);

    }

    public static void createExternalSampleData(){
        createSampleData();

        List<Almond__Training_Plan__c> tplans = [select id,Almond__Enable_Self_Registration__c,Almond__Self_Registration_Access__c from Almond__Training_Plan__c ];
        for(Almond__Training_Plan__c tp : tplans){
            tp.Almond__Enable_Self_Registration__c = true;
            tp.Almond__Self_Registration_Access__c = 'External';
        }
        update tplans;

    }
*/
}