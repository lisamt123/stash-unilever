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
public with sharing class PBS_TrainingPlanFeedbackController_CC extends PBS_LMSBaseController_CC{
    public ApexPages.StandardSetController setCon;
    public PBS_Training_Plan_Feedback__c feedback{get;set;}
    public transient List<User> lUsersWithAchievement {get;set;}
    public User currentUser{get;private set;}
    public String tplanId{get;private set;}
    public PBS_TrainingPlan_CC tPlan{get;private set;}
    public Boolean isPreview{get;private set;}
    public PBS_Training_Plan_Feedback__c existingFeedback{get;private set;}
    public Boolean isAllowedToView{get;private set;}

    public Boolean hasMessages{get{return ApexPages.hasMessages();}}
    public transient Boolean feedbackSuccess{get;private set;}

    public PBS_TrainingPlanFeedbackController_CC(){
        tplanId = ApexPages.currentPage().getParameters().get('id');
        isPreview = false;
        feedbackSuccess = false;
        if(!String.isBlank(ApexPages.currentPage().getParameters().get('preview'))){
            isPreview = true;
        }

        isAllowedToView = PBS_LMSService_CC.isAllowedToViewTrainingPlan(tplanId,UserInfo.getUserId(),PBS_LMSUtils_CC.isPortalUser());

        if(isAllowedToView){
            init();
        }else{
            PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Training_Plan_No_Access_Message);
        }
    }

    private void init(){
        loadTrainingPlanInfo();
        feedback = new PBS_Training_Plan_Feedback__c();
        existingFeedback = getExistingRating();
        feedback.Training_Plan__c = tplanId;
        feedback.User__c = UserInfo.getUserId();

        if(tPlan != null){
            currentUser = [select id,Name,SmallPhotoUrl from User where id = :UserInfo.getUserId()];
            PBS_TrainingPlanFeedbackController_CC.WithoutSharingOps wsops = new PBS_TrainingPlanFeedbackController_CC.WithoutSharingOps();
            setCon = wsops.getSetCon(tplanId);

            if(tPlan.mainAchievement != null){
                lUsersWithAchievement = PBS_LMSService_CC.getUsersForAchievement(tPlan.mainAchievement.Id, PBS_LMSConstants_CC.AA_ACQUIRED_STATUS, 12);
            }
        }
    }

    private void loadTrainingPlanInfo(){
        if(isPreview){
            this.tPlan = PBS_LMSWrappersService_CC.getTrainingPlanDetails(tplanId,UserInfo.getUserId(),true, false);
        }else{
            this.tPlan = PBS_LMSWrappersService_CC.getTrainingPlanDetails(tplanId,UserInfo.getUserId(),false, false);
        }
    }

    public PageReference submitFeedback(){
        if(!tPlan.trainingPlan.Optional_Feedback_Comments__c && String.isBlank(feedback.Comments__c)){
            PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Feedback_Missing_Comments);
        }else if (feedback.Rating__c  != null && feedback.Rating__c != 0 && existingFeedback != null){
            PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Feedback_Existing_Rating);
        }else if ((feedback.Rating__c  == null || feedback.Rating__c == 0) && String.isBlank(feedback.Comments__c)){
          PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Feedback_No_Data);
        }else{
            try{
                PBS_LMSService_CC.insertTrainingPlanFeedback(new List<PBS_Training_Plan_Feedback__c>{feedback});
                init();
                feedbackSuccess = true;
                PBS_LMSUtils_CC.addSuccessMessage(System.Label.ALMS_Feedback_Submitted);
            }catch(Exception e){
                PBS_LMSUtils_CC.addErrorMessage(e.getMessage());
            }
        }
        return null;
    }

    private PBS_Training_Plan_Feedback__c getExistingRating(){

        List<PBS_Training_Plan_Feedback__c> result =  PBS_LMSService_CC.getTrainingPlanFeedback(UserInfo.getUserId(),tplanId,true);

        if(result.size()>0){
            return result.get(0);
        }else{
            return null;
        }
    }

    public List<PBS_Training_Plan_Feedback__c> getComments() {
        return (List<PBS_Training_Plan_Feedback__c>) setCon.getRecords();
    }

    public void doNext(){
        if(this.setCon.getHasNext()){
            this.setCon.next();
        }
    }

    public void doPrevious(){
        if(this.setCon.getHasPrevious()){
            this.setCon.previous();
        }
    }

    public Boolean getHasPrevious(){
        return this.setCon.getHasPrevious();
    }

    public Boolean getHasNext(){
        return this.setCon.getHasNext();
    }

    public Integer getPageNumber(){
        return this.setCon.getPageNumber();
    }

    public Integer getTotalPages(){
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }

    public Boolean getIsAssignedToTrainingPlan(){
        List<PBS_Training_Plan_Assignment__c> tplanAssignments = [select id
                                                                    ,name
                                                                    from PBS_Training_Plan_Assignment__c
                                                                    where User__c = :UserInfo.getUserId()
                                                                    and Training_Plan__c = :tplanId];
       return tplanAssignments.size()>0;
    }

    private without sharing class WithoutSharingOps{
        public ApexPages.StandardSetController getSetCon(Id tplanId){
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                [select Id
                ,Name
                ,Rating__c
                ,Comments__c
                ,User__c
                ,User__r.Name
                ,User__r.SmallPhotoUrl
                from PBS_Training_Plan_Feedback__c
                where Training_Plan__c = :tplanId
                order by CreatedDate desc]));
                setCon.setPageSize(5);
            return setCon;
        }
    } 
}