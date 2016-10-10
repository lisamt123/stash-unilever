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
public with sharing class PBS_QuizViewerController_CC extends PBS_LMSBaseController_CC{

    public static final string AID_1 = 'aid';
    public static final string QUIZVIEWERCONTROLLER= 'QuizViewerController';

    public PBS_Quiz__c quiz{get;set;}
    public PBS_Question_Line__c questionLine{get; private set;}
    public PBS_Question_Line__c startQuestionLine{get;private set;}
    public PBS_Question_Line__c finishQuestionLine{get;private set;}
    public List<PBS_QuizItem_CC> quizItemList { get ; set; }
    public Integer totalPages{get; private set;}
    public Integer progress{get; private set;}
    public PBS_Learning_Assignment__c assignment {get;private set;}
    private PBS_Learning_Version__c learningVersion;

    private List<Id> qlNavigation = new List<Id>();
    private Map<Id,PBS_Response__c> responseMap = new Map<Id, PBS_Response__c>();

    private Boolean isPreviewMode{get;set;}

    //Navigation logic
    public Boolean showStartButton {get {return questionLine.Id != startQuestionLine.Id;}}
    public Boolean showDoneButton {get {return questionLine.Id == finishQuestionLine.Id;}}
    public Boolean showNextButton {get {return questionLine.Id != finishQuestionLine.Id;}}
    public Boolean showPreviousButton {get {return !qlNavigation.isEmpty();}}
    public Boolean hasMessages{get{return ApexPages.hasMessages();}}

    public Boolean showBackNoSaveMessage{get;set;}

    public PBS_QuizViewerController_CC(){
        quizItemList = new List<PBS_QuizItem_CC>();
        totalPages = 0;
        progress = 0;
        isPreviewMode = false;
        showBackNoSaveMessage = false;

        initQuiz();
    }

    //Inner exception class
    public class QuizException extends Exception{}

    //Initialize quiz parameters
    private void initQuiz(){

        //Retrieve assignment id
        String aid = Apexpages.currentPage().getParameters().get(AID_1);
        //Retrieve quiz id
        String qid = Apexpages.currentPage().getParameters().get('qid');
        //Retrieve preview mode flag
        if(String.isNotBlank(Apexpages.currentPage().getParameters().get('pMode'))){
            isPreviewMode = true;
        }

        try{

            if(String.isNotBlank(aid)){

                assignment = PBS_LMSService_CC.getLearningAssignmentDetails(aid,UserInfo.getUserId());
                PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
                learningVersion = wsops.getLearningVersionDetails(assignment.Learning_Version__c,'Quiz');
                PBS_Learning__c assignmentLearning = wsops.getLearningDetails(assignment.Learning__c);

                if(learningVersion.Quiz__c == null){
                    PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Invalid_Assignment_Id);
                    return;
                }else{
                    quiz = learningVersion.Quiz__r;
                    if(quiz.Description__c == null){
                        quiz.Description__c = assignmentLearning.Description__c;
                    }
                }

                //Fetch quiz question lines
                List<PBS_Question_Line__c> questionLines = wsops.getQuizQuestionLines(quiz.Id);

                //Set default start question if no question line parameter is present
                String ql = Apexpages.currentPage().getParameters().get('ql') ;
                if (String.isBlank(ql)){
                    ql = questionLines.get(0).Id;
                }
                //Set question line object
                questionLine = questionLines.get(0);
                startQuestionLine = questionLines.get(0);
                finishQuestionLine = questionLines.get(questionLines.size()-1);

                //Set progress data
                totalPages = questionLines.size();

            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Invalid_Assignment_Id);
                return;
            }

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,QUIZVIEWERCONTROLLER);
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('QuizViewerController - initQuiz (1)');
        }

    }

    public PageReference initializeQuestions() {
     PBS_QuizViewerController_Helper quizViewrHelper = new PBS_QuizViewerController_Helper();
        //Verify if user can continue taking the quiz
        if(!quizViewrHelper.isAllowedToTakeQuiz(assignment,learningVersion,isPreviewMode)){
            return redirectToResultsPage();
        }

        showBackNoSaveMessage = false;
        try{

            PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();

            //Retrieve question line information
            questionLine = wsops.getQuestionLineDetails(quiz.Id,questionLine.Id);

            //Retrieve questions for the current question line
            List<PBS_Question__c> questions = wsops.getQuestionsForQuestionLine(questionLine.Id);

            //Collect Answer Sequence Ids for the current questions
            Set<Id> answerSequenceIDs = new Set<Id>();
            for (PBS_Question__c q : questions) {
                if (q.Answer_Sequence__c != null) {
                    answerSequenceIDs.add(q.Answer_Sequence__c);
                }
            }

            //Retrieve info for related answer sequences
            Map<Id,PBS_Answer_Sequence__c> answerSequencesMap = wsops.fetchAnswerSequences(answerSequenceIDs);

            // prepare the final list that will drive the page
            quizItemList.clear();

            //Fetch existing responses
            responseMap = quizViewrHelper.fetchExistingResponses(assignment.Id,assignment.Shared_Learning_Assignment__c,questionLine.Id,null);

            //Initialize wrapper list and set values for new responses
            for (PBS_Question__c q : questions) {
                PBS_Response__c re = responseMap.get(q.Id);
                if ( re == null ) {
                    re = new PBS_Response__c(Learning_Assignment__c = assignment.id
                                        ,Shared_Learning_Assignment__c = assignment.Shared_Learning_Assignment__c
                                        ,Question__c = q.id
                                        ,User__c = assignment.User__c
                                        ,OwnerId = assignment.User__c);
                    responseMap.put(q.Id, re);
                }
                PBS_QuizItem_CC qi = new PBS_QuizItem_CC(q,assignment,re);
                qi.answers = answerSequencesMap.get(q.Answer_Sequence__c);
                quizItemList.add(qi);
            }

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,QUIZVIEWERCONTROLLER);
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('QuizViewerController - initializeQuestions (2)');
        }

        return null;
    }

    //Redirect user to the training plan page
    public PageReference backToTrainingPlan(){
        PageReference ret = Page.PBS_TrainingPlanDetail;
        if(isPreviewMode){
          ret = new PageReference('/'+assignment.Learning__c);
        }else{
          ret.getParameters().put('id',assignment.Training_Plan__c);
        }
        ret.setRedirect(true);
        return ret;
    }

    //Reset progress to the first page
    public PageReference reset() {
        PageReference ret = Page.PBS_QuizViewer;
        ret.setRedirect( true );
        ret.getParameters().put(AID_1,Apexpages.currentPage().getParameters().get(AID_1));
        return ret;
    }

    //Save responses and move to the previous question line
    public PageReference previous() {

        try {
            saveResponses(true);

            questionLine = new PBS_Question_Line__c(id = qlNavigation.remove(qlNavigation.size()-1));
            PageReference ret = Page.PBS_QuizViewer;
            return ret;

        }catch(QuizException qe){
            showBackNoSaveMessage = true;
            PBS_LMSUtils_CC.addErrorMessage(qe.getMessage());
        }catch(Exception e) {
            showBackNoSaveMessage = true;
            PBS_LMSUtils_CC.logException(e,QUIZVIEWERCONTROLLER);
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('QuizViewerController - previous (3)');
        }
        return null;
    }

    //Return to the previous page without save
    public PageReference previousNoSave() {
        questionLine = new PBS_Question_Line__c(id = qlNavigation.remove(qlNavigation.size()-1));
        PageReference ret = Page.PBS_QuizViewer;
        return ret;
    }

    //Save responses and move to the next question line
    public PageReference next() {

        try {

            PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();

            saveResponses(true);

            List<PBS_Question_Line__c> orderedQuestionLines = wsops.getQuizOrderedQuestionLines(quiz.Id,questionLine.Id,questionLine.Order__c);

            //Fetch next question lines and define the next page
            for (PBS_Question_Line__c ql : orderedQuestionLines) {

                //Store the question we came from in navigation list
                if ( questionLine != null ) {
                    qlNavigation.add(questionLine.Id);
                }

                questionLine = ql;
                PageReference ref = Page.PBS_QuizViewer;
                return ref;

            }

            PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_No_Remaining_Question_Lines);

        }catch(QuizException qe){
            PBS_LMSUtils_CC.addErrorMessage(qe.getMessage());
        } catch(Exception e) {
            PBS_LMSUtils_CC.logException(e,QUIZVIEWERCONTROLLER);
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('QuizViewerController - next (4)');
        }
        return null;
    }

    //Submit quiz, save answers and redirect to completed page
    public PageReference done() {

        try {
            //Don't recalculate progress for final action, this is done in the updateAssignmentFinalScore method
            saveResponses(false);

            PBS_QuizViewerController_Helper quizvierHelper = new PBS_QuizViewerController_Helper();
            quizvierHelper.updateAssignmentFinalScore(assignment,quiz);

            return redirectToResultsPage();

        }catch(QuizException qe){
            PBS_LMSUtils_CC.addErrorMessage(qe.getMessage());
        }catch(Exception e) {
            PBS_LMSUtils_CC.logException(e,QUIZVIEWERCONTROLLER);
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('QuizViewerController - done (5)');
        }
        return null;

    }

    //Redirect to results page
    public PageReference redirectToResultsPage() {
        PageReference ret = Page.PBS_QuizResults;
        String networkName = PBS_LMSUtils_CC.getCurrentNetworkURLPath();
        String namespace = '';
        if(PBS_LMSUtils_CC.getPackageNamespace() != null){
            namespace = PBS_LMSUtils_CC.getPackageNamespace();
        }
        if(networkName != null){
            ret = new PageReference('/'+networkName+'/apex/'+namespace+'QuizResults');
        }
        ret.setRedirect( true );
        ret.getParameters().put(AID_1,Apexpages.currentPage().getParameters().get(AID_1) );

        if(isPreviewMode){
            ret.getParameters().put('pMode','true');
        }
        return ret;
    }

    //Save the responses captured in the current questionline
    public PageReference saveResponses(Boolean updateProgress) {
        PBS_QuizViewerController_Helper quizViewrHelper = new PBS_QuizViewerController_Helper();
        List<PBS_Response__c> tosave = new List<PBS_Response__c>();

        for (PBS_QuizItem_CC qi : quizItemList) {
            tosave.add(qi.response);
            Boolean missingAnswer = false;
            if ((qi.question.Type__c == 'SelectOneQuestion' || qi.question.Type__c == 'SelectMultipleQuestion' ) && String.isBlank(qi.response.Response_Answer_Sequence_Long__c)) {
                missingAnswer = true;
            }else if(qi.question.Type__c == 'Text' && String.isBlank(qi.response.Response_Text_Long__c)){
                missingAnswer = true;
            }else if(qi.question.Type__c == 'Number' && qi.response.Number_Response__c == null){
                missingAnswer = true;
            }else if(qi.question.Type__c == 'Boolean' && String.isBlank(qi.response.Boolean_Response__c)){
                missingAnswer = true;
            }

            if(missingAnswer){
              throw new QuizException(System.Label.ALMS_Quiz_Missing_Answers);
            }
        }

        //Update responses
        PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
        wsops.upsertResponses(tosave);

        if(updateProgress){
            quizViewrHelper.updateAssignmentProgress(assignment,learningVersion);
        }

        return null;
    }

}