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
public with sharing class PBS_TrainingPlanPreviewController_CC extends PBS_LMSBaseController_CC{

    public PBS_TrainingPlan_CC tPlan{get;private set;}
    public List<User> lUsersWithAchievement {get;private set;}
    private Id trainingPlanId;
    public PBS_Training_Plan_Access_Request__c dummyRequest{get;set;}
    public PBS_Training_Plan_Access_Request__c existingRequest{get;set;}
    public Boolean isApprovalRequired{get;private set;}
    public String redirectURL{get;set;}
    public Boolean hasMessages{get{return ApexPages.hasMessages();}}

    //It's important to keep this as a custom controller so that we can bypass sharing restrictions for preview purposes
    public PBS_TrainingPlanPreviewController_CC(){
        trainingPlanId = ApexPages.currentPage().getParameters().get('id');
        init();
    }

    private void init(){
        try{
            loadTrainingPlanInfo();
            isApprovalRequired = false;
            dummyRequest = new PBS_Training_Plan_Access_Request__c();
            existingRequest = null;

            if(tPlan != null){
                if(tPlan.trainingPlan.Self_Registration_Access__c == 'Requires Approval'){
                    isApprovalRequired = true;
                }

                if(tPlan.mainAchievement != null){
                    lUsersWithAchievement = PBS_LMSService_CC.getUsersForAchievement(tPlan.mainAchievement.Id, PBS_LMSConstants_CC.AA_ACQUIRED_STATUS, 12);
                }
            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Training_Plan_No_Access_Message);
            }
        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'TrainingPlanPreviewController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('TrainingPlanPreviewController - init (1)');
        }
    }

    private void loadTrainingPlanInfo(){
        tPlan = PBS_LMSWrappersService_CC.getTrainingPlanDetails(trainingPlanId,UserInfo.getUserId(),true, true);
    }

    public PageReference checkAssignment(){
        if(hasTrainingPlanAssignment()){
            return redirectToPlanDetailPage();
        }else{
            return null;
        }
    }

    //Create assignment is user doesn't have the assignment already
    public PageReference registerForTrainingPlan(){
        redirectURL = null;
        try{

            List<PBS_Training_Plan__c> selectedTPlans = PBS_LMSService_CC.getTrainingPlans(new Set<Id>{trainingPlanId}, PBS_LMSUtils_CC.isPortalUser());

            PBS_Training_Plan__c selectedPlan = selectedTPlans.get(0);
            if(selectedPlan.Self_Registration_Access__c != 'Requires Approval' && PBS_LMSService_CC.isPublicTrainingPlanAvailable(trainingPlanId,UserInfo.getUserId(), PBS_LMSUtils_CC.isPortalUser())){
                PBS_LMSService_CC.upsertAssignments(new Set<Id>{UserInfo.getUserId()}, trainingPlanId, PBS_LMSUtils_CC.getCurrentNetworkId());
            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Public_Plan_Assignment_Error);
                return null;
            }

            PageReference ref = redirectToPlanDetailPage();
            redirectURL = ref.getUrl();
            return null;

        }catch(Exception e){
            PBS_LMSUtils_CC.addErrorMessage(e.getStackTraceString());
            return null;
        }
    }

    public PageReference fetchTrainingPlanInfo(){
        existingRequest = null;
        //List<PBS_Training_Plan__c> selectedTPlans= 
        PBS_LMSService_CC.getTrainingPlans(new Set<Id>{trainingPlanId}, PBS_LMSUtils_CC.isPortalUser());
        List<PBS_Training_Plan_Access_Request__c> existingReqs = PBS_LMSService_CC.fetchTrainingPlanAccessRequest(UserInfo.getUserId(),trainingPlanId,null,PBS_LMSUtils_CC.isPortalUser());
        if(existingReqs.size()>0){
            existingRequest = existingReqs.get(0);
        }
        return null;
    }

    public PageReference requestAccessForTrainingPlan(){

        try{
            //PBS_Training_Plan_Access_Request__c tpar = 
            PBS_LMSService_CC.createTrainingPlanAccessRequest(UserInfo.getUserId(),trainingPlanId,dummyRequest.Comments__c, PBS_LMSUtils_CC.isPortalUser());
            dummyRequest = new PBS_Training_Plan_Access_Request__c();
            PBS_LMSUtils_CC.addSuccessMessage(System.Label.ALMS_Public_Plan_Request_Submitted);
            return null;
        }catch(Exception e){
            PBS_LMSUtils_CC.addErrorMessage(e.getStackTraceString());
            return null;
        }
    }

    private PageReference redirectToPlanDetailPage(){
        String namespace = '';
        if(PBS_LMSUtils_CC.getPackageNamespace() != null){
            namespace = PBS_LMSUtils_CC.getPackageNamespace();
        }
        PageReference ref = new PageReference(PBS_LMSUtils_CC.updateURLCommunityPath('/apex/'+namespace+'PBS_TrainingPlanDetail'));
        ref.getParameters().put('id',trainingPlanId);
        ref.setRedirect(true);
        return ref;
    }

    private Boolean hasTrainingPlanAssignment(){
        if(String.isBlank(trainingPlanId)){
            return false;
        }
        //Get assignments for existing training plans
        List<PBS_Training_Plan_Assignment__c> tPlanAsgmts = [select id from PBS_Training_Plan_Assignment__c where User__c = :UserInfo.getUserId() and Training_Plan__c = :trainingPlanId];
        return tPlanAsgmts.size()>0;
    }
}