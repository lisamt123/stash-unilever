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

public with sharing class PBS_QuizViewerController_Helper{

        public void updateAssignmentFinalScore(PBS_Learning_Assignment__c assignment,PBS_Quiz__c quiz){
        
        PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();

        if(assignment.Evaluation_Times_Taken__c == null){
            assignment.Evaluation_Times_Taken__c = 0;
        }

        assignment.Evaluation_Times_Taken__c++;

        //Calculate Score

        //Fetch all quiz questions
        Map<Id,PBS_Question__c> quizQuestions = wsops.getQuestionsForQuiz(quiz.Id);

        Set<Id> answerQuestionIds = new Set<Id>();
        for(PBS_Question__c q : quizQuestions.values()){
            if(q.Answer_Sequence__c != null){
                answerQuestionIds.add(q.Answer_Sequence__c);
            }
        }

        //Fetch all question answer sequences
        Map<Id,PBS_Answer_Sequence__c> mapQuizAnswerSequences = wsops.fetchAnswerSequences(answerQuestionIds);

        //Evaluate responses
        Map<Id,PBS_Response__c> responseMap = fetchExistingResponses(assignment.Id,assignment.Shared_Learning_Assignment__c,null,quiz.Id);

        Integer correctQuestionCounter = 0;
        List<PBS_Response__c> responsesToUpdate = new List<PBS_Response__c>();

        for(Id questionId : responseMap.keySet()){

            PBS_Question__c q = quizQuestions.get(questionId);

            if(q != null){

                PBS_Response__c resp = responseMap.get(questionId);
                Boolean isCorrect = false;

                //Get correct answers for the current question
                Set<String> correctAnswers =new Set<String>();
                Set<String> currentAnswer =new Set<String>();

                if((q.Type__c == 'SelectOneQuestion' || q.Type__c == 'SelectMultipleQuestion') && q.Answer_Sequence__c != null){

                    PBS_Answer_Sequence__c aseq = mapQuizAnswerSequences.get(q.Answer_Sequence__c);
                    for(PBS_Answer_Sequence_Item__c asi : aseq.Answer_Sequence_Items__r){
                        if(asi.Is_Correct_Answer__c){
                            correctAnswers.add(asi.Item_Id__c);
                        }
                    }

                    if(correctAnswers.size()>0){
                        //Get answers for the current response
                        if(resp.Question_Type__c == 'SelectOneQuestion' || resp.Question_Type__c== 'SelectMultipleQuestion'){
                            String selectedAnswerSequence = resp.Response_Answer_Sequence_Long__c;
                            if(selectedAnswerSequence != null){
                                Set<String> selectedAnswersSet = new Set<String>();
                                selectedAnswersSet.addAll(selectedAnswerSequence.split(';',0));
                                if(resp.Question_Type__c == 'SelectOneQuestion'){
                                    if(correctAnswers.removeAll(selectedAnswersSet)){
                                        correctQuestionCounter++;
                                        isCorrect = true;
                                    }
                                }else if(resp.Question_Type__c== 'SelectMultipleQuestion'){
                                    if(selectedAnswersSet.containsAll(correctAnswers) && selectedAnswersSet.size() == correctAnswers.size()){
                                        correctQuestionCounter++;
                                        isCorrect = true;
                                    }
                                }
                            }
                        }
                    }

                }else if(q.Type__c == 'Number' && q.Correct_Number__c != null){

                    if(resp.Number_Response__c == q.Correct_Number__c){
                        correctQuestionCounter++;
                        isCorrect = true;
                    }
                }else if(q.Type__c == 'Boolean' && q.Correct_Boolean__c != null){

                    if(resp.Boolean_Response__c == q.Correct_Boolean__c){
                        correctQuestionCounter++;
                        isCorrect = true;
                    }
                }else{
                    //Unsupported types will be marked as correct
                    correctQuestionCounter++;
                    isCorrect = true;
                }

                if(resp != null){
                    resp.Correct_Response__c = isCorrect;
                    responsesToUpdate.add(resp);
                }

            }

        }

        Double finalScore = (correctQuestionCounter/quiz.Total_Questions__c)*100;
        assignment.Evaluation_Score__c = finalScore;
        if(quiz.Passing_Score__c == null || finalScore >= quiz.Passing_Score__c){
            assignment.Evaluation_Result__c = PBS_LMSConstants_CC.ASSIGNMENT_EVAL_PASSED;
            assignment.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
            assignment.Progress_Percentage__c = 100;
        }else{
            assignment.Evaluation_Result__c = PBS_LMSConstants_CC.ASSIGNMENT_EVAL_FAILED;
            assignment.Progress_Percentage__c = 100;
        }

        //No CRUD/FLS enforced here as Users don't have access to update the learning assignment object
        update assignment;

        if(quiz != null && quiz.Delete_Responses_On_Submission__c){
            PBS_LMSService_CC.deleteResponsesForAssignment(assignment.id, assignment.Shared_Learning_Assignment__c);
        }else{
          //Update correct response flag at the response level
          //No CRUD/FLS enforced here as Users don't have access to update the correct response flag object
          if(!PBS_LMSSettings_CC.getDisableCorrectResponseCheckbox() && responsesToUpdate.size()>0){
              wsops.upsertResponses(responsesToUpdate);
          }
        }

    }

  
   public void updateAssignmentProgress(PBS_Learning_Assignment__c assignment,PBS_Learning_Version__c learningVersion){

        if(learningVersion.Quiz__r.Total_Questions__c != null){

            PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();

            Integer respCount = wsops.getAssignmentResponseCount(assignment.Id, learningVersion.Quiz__c);

            Double newProgress = respCount/learningVersion.Quiz__r.Total_Questions__c;
            assignment.Progress_Percentage__c = newProgress*100;
            assignment.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS;

            //No CRUD/FLS enforced here as Users don't have access to update the learning assignment object
            update assignment;

        }

    }
      public Map<Id,PBS_Response__c> fetchExistingResponses(Id assignmentId, Id sharedAssignmentId, Id questionLineId, Id quizId){

        PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();

        List<PBS_Response__c> responses = wsops.getQuizResponses(quizId, questionLineId, assignmentId, sharedAssignmentId);

        Map<Id,PBS_Response__c> responseMap = new Map<Id, PBS_Response__c>();

        for (PBS_Response__c r: responses) {
            responseMap.put(r.Question__c,r);
        }

        return responseMap;
    }
    
      public Boolean isAllowedToTakeQuiz(PBS_Learning_Assignment__c assignment,PBS_Learning_Version__c learningVersion,Boolean isPreviewMode){

        if(!isPreviewMode){
            if(assignment.Progress__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED && assignment.Evaluation_Result__c == PBS_LMSConstants_CC.ASSIGNMENT_EVAL_PASSED){
                return false;
            }

            if(learningVersion.Quiz__r.Max_Attempts__c != null && assignment.Evaluation_Result__c != PBS_LMSConstants_CC.ASSIGNMENT_EVAL_PASSED){
                if(assignment.Evaluation_Times_Taken__c == learningVersion.Quiz__r.Max_Attempts__c){
                    return false;
                }
            }
        }

        return true;
    }
    
}