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
public with sharing class PBS_TaskViewerController_CC extends PBS_LMSBaseController_CC{

    public PBS_Task__c task{get;set;}
    public PBS_Learning_Version__c learningVersion{get;set;}
    public PBS_Learning_Assignment__c assignment {get;private set;}
    private Boolean isPreviewMode{get;set;}
    public Boolean hasMessages{get{return ApexPages.hasMessages();}}
    public String externalResourceURL{get;private set;}
    public Boolean taskCompleted{get;private set;}
    public Boolean taskInReview{get;private set;}
    public String latestImageAttachment{get;private set;}
    public String redirectURL{get;set;}
    public String cancelURL{get;set;}
    public String assignmentComments{get;set;}

    public Attachment attachment {
        get {
        if (attachment == null){
          attachment = new Attachment();}
        return attachment;
        }
        set;
    }

    public PBS_TaskViewerController_CC(){
    isPreviewMode = false;
        init();
        PageReference cancelRef = finalRedirection();
        cancelURL = PBS_LMSUtils_CC.updateURLCommunityPath(cancelRef.getUrl());
    }

    private void init(){

        //Set task completion status
        taskCompleted = false;
        taskInReview = false;
        latestImageAttachment = null;
        assignmentComments = null;

        //Retrieve assignment id
        String aid = Apexpages.currentPage().getParameters().get('aid');
        //Retrieve preview mode flag
        if(!String.isBlank(Apexpages.currentPage().getParameters().get('pMode'))){
            isPreviewMode = true;
        }

        try{

            if(!String.isBlank(aid)){

                assignment = PBS_LMSService_CC.getLearningAssignmentDetails(aid,UserInfo.getUserId());
                PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
                learningVersion = wsops.getLearningVersionDetails(assignment.Learning_Version__c,'Task');
                PBS_Learning__c assignmentLearning = wsops.getLearningDetails(assignment.Learning__c);

                //Init assignment comments from user notes if there's already a value
                assignmentComments = assignment.User_Notes__c;

                List<Attachment> assignmentAtts = [select id
                                                    from Attachment
                                                    where ParentId = :assignment.Id
                                                    and Name = 'LMS Uploaded Image'
                                                    order by CreatedDate desc
                                                    limit 1];

                if(assignmentAtts.size()>0){
                    latestImageAttachment = assignmentAtts.get(0).Id;
                }

                if(learningVersion.Task__c == null){
                    PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Invalid_Assignment_Id);
                    return;
                }else{
                    task = learningVersion.Task__r;
                    if(task.Description__c == null){
                        task.Description__c = assignmentLearning.Description__c;
                    }
                }

                if(assignment.Progress__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED){
                    taskCompleted = true;
                }else if(assignment.Progress__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW){
                    taskCompleted = true;
                    taskInReview = true;
                }

                if(learningVersion.Task__r.External_Resource_URL__c != null){

                    String resourceURL = learningVersion.Task__r.External_Resource_URL__c;

                    //Add https prefix in case protocol is not present in the resource url
                    if(!resourceURL.startsWith('http')){
                        resourceURL = 'https://'+resourceURL;
                    }

                    PageReference extRef = new PageReference(resourceURL);
                    if(learningVersion.Task__r.Add_training_parameters_to_URL__c){
                        extRef.getParameters().put('aid',assignment.id);
                        extRef.getParameters().put('tid',assignment.Training_Plan__c);
                    }
                    externalResourceURL = extRef.getUrl();
                }


            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Invalid_Assignment_Id);
                return;
            }

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'TaskViewerController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('TaskViewerController - init (1)');
        }
    }

    public PageReference markCompletedAndRedirect(){
        //PageReference completedRef = markCompleted();
        if(redirectURL != null){
            PageReference redirectRef = new PageReference(redirectURL);
            return redirectRef;
        }else{
            return null;
        }
    }

    public PageReference markCompleted(){
        redirectURL = null;
        try{

            //BEGIN Access Check
                //We don't enforce CRUD/FLS here since LMS Users shouldn't have access to read task approvers and we dont expose this data in the UI
                //Additionally, we bypass CRUD/FLS settings for updating learning assignments as LMS Users have read only access
            //END Access Check

            //Check for assignment notes length
            if(!String.isBlank(assignmentComments) && assignmentComments.length() > 32000){
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Task_Comments_Max_Length);
                return null;
            }

            //Update assignment status
            if(assignment.Progress__c != PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED){

                Set<Id> taskApprovers = getTaskApprovers();

                //If we have task approvers, share the assignment with them so that they can see the record in the SF UI
                if(taskApprovers.size()>0){
                    shareLearningAssignmentsWithApprovers(taskApprovers,new Set<Id>{assignment.Id});
                }

                if(!isPreviewMode && (task.Requires_Manager_Approval__c || taskApprovers.size()>0)){
                    assignment.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW;
                    assignment.Progress_Percentage__c = 50;
                }else{
                    assignment.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
                    assignment.Progress_Percentage__c = 100;
                }

            }

            if(learningVersion.Task__r.Enable_Image_Upload__c && (attachment == null || attachment.body == null)){
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Task_Missing_Image);
                return null;
            }

            //Insert attachment if available
            if(attachment != null && attachment.body != null){
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId = assignment.Id;
                attachment.IsPrivate = true;
                attachment.Name = 'LMS Uploaded Image';
                insert attachment;
            }

            assignment.Evaluation_Result__c = 'N/A';
            assignment.User_Notes__c = assignmentComments;
            update assignment;

            PageReference ref = finalRedirection();
            redirectURL = PBS_LMSUtils_CC.updateURLCommunityPath(ref.getUrl());
            return null;

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'TaskViewerController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('TaskViewerController - markCompleted (2)');
            return null;
        }finally{
            attachment = new Attachment();
        }
    }

    public PageReference cancelTask(){
        PageReference ref = finalRedirection();
        redirectURL = PBS_LMSUtils_CC.updateURLCommunityPath(ref.getUrl());
        return null;
    }

    public PageReference resetTask(){
        redirectURL = null;
        try{

            //BEGIN Access Check
            //We don't enforce CRUD/FLS here since LMS Users shouldn't have access to read task approvers and we dont expose this data in the UI
            //Additionally, we bypass CRUD/FLS settings for updating learning assignments as LMS Users have read only access
            //END Access Check

            if(getIsTaskValidForReset()){
                assignment.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED;
                assignment.Progress_Percentage__c = 0;
                update assignment;
                PageReference ref = finalRedirection();
                redirectURL = PBS_LMSUtils_CC.updateURLCommunityPath(ref.getUrl());
            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Task_Undo_Error_Message);
            }
            return null;
        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'TaskViewerController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('TaskViewerController - undoCompleted (1)');
            return null;
        }
    }

    private PageReference finalRedirection(){
        PageReference ref = Page.PBS_MyTraining;
        if(isPreviewMode){
            ref = new PageReference('/'+assignment.Learning__c);
        }else{
            String retURL = PBS_LMSUtils_CC.getTrainingPlanDetailRetURL(Apexpages.currentPage().getParameters());
            if(!String.isBlank(retURL)){
                ref= new PageReference(retURL);
            }else{
                ref = Page.PBS_TrainingPlanDetail;
                ref.getParameters().put('id',assignment.Training_Plan__c);
                ref.getParameters().put('section',assignment.Training_Plan_Section__c);
            }
        }
        ref.setRedirect(true);
        ref.getParameters().put('aid',assignment.Id );
        return ref;
    }

    public Boolean getIsTaskValidForReset(){

        if(learningVersion.Task__r.Disable_Undo__c){
            return false;
        }

        //Fetch training plan assignment information
        List<PBS_Learning_Assignment__c> planAssignment = [select id
                                                            ,Training_Plan_Section_Assignment__r.Training_Plan_Assignment__c
                                                            ,Training_Plan_Section_Assignment__r.Training_Plan_Assignment__r.Status__c
                                                            from PBS_Learning_Assignment__c
                                                            where id = :assignment.id];
        if(planAssignment.size() == 0){
            return false;
        }

        String tplanStatus = planAssignment.get(0).Training_Plan_Section_Assignment__r.Training_Plan_Assignment__r.Status__c;

        if(tplanStatus != null && tplanStatus != PBS_LMSConstants_CC.TPLAN_STATUS_COMPLETED && assignment.Progress__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED){
            Set<Id> taskApprovers = getTaskApprovers();
            if((!task.Requires_Manager_Approval__c) && taskApprovers.size() == 0){
                return true;
            }
        }
        return false;
    }

    private void shareLearningAssignmentsWithApprovers(Set<Id> approverIds, Set<Id> learningAssignmentIds){
        PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
        wsops.shareLearningAssignmentsWithApprovers(approverIds, learningAssignmentIds);
    }

    private Set<Id> getTaskApprovers(){
        Set<Id> taskApprovers = new Set<Id>();

        //Get active task approvers
        PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
        List<PBS_Task_Approver__c> approvers = wsops.getTaskApprovers(task.Id);
        for(PBS_Task_Approver__c ta : approvers){
            if(ta.User__c != null && ta.User__r.IsActive){
                taskApprovers.add(ta.User__c);
            }
        }

        return taskApprovers;
    }

}