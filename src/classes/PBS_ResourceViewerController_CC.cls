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
global with sharing class PBS_ResourceViewerController_CC{

    public Boolean continueRedirection{get;private set;}
    private Boolean isPreviewMode{get;set;}{isPreviewMode = false;}
    public transient String retURL{get;private set;}

    public PBS_ResourceViewerController_CC(){
        init();
    }

    private void init(){

        retURL = null;

        //Retrieve assignment id
        String aid = Apexpages.currentPage().getParameters().get('aid');
        //Retrieve preview mode flag
        if(!String.isBlank(Apexpages.currentPage().getParameters().get('pMode'))){
            isPreviewMode = true;
        }
        //Retrieve retURL value from URL
        if(!String.isBlank(Apexpages.currentPage().getParameters().get('tpid'))){
            retURL = PBS_LMSUtils_CC.getTrainingPlanDetailRetURL(Apexpages.currentPage().getParameters());
        }

        continueRedirection = false;

        try{

            if(!String.isBlank(aid)){

                PBS_Learning_Assignment__c assignment = getAssignment(aid);

                PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
                PBS_Learning_Version__c learningVersion = wsops.getLearningVersionDetails(assignment.Learning_Version__c,'Resource');

                if(learningVersion.Training_Resource__c == null){
                    PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Invalid_Assignment_Id);
                }else{
                    continueRedirection = true;
                }


            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Invalid_Assignment_Id);
            }

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'ResourceViewerController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('ResourceViewerController - init (1)');
        }
    }

    @RemoteAction
    global static String redirectToResource(String aid){

        PBS_Learning_Assignment__c assignment = getAssignment(aid);
        PBS_LMSService_CC.WithoutSharingOps wsops = new PBS_LMSService_CC.WithoutSharingOps();
        PBS_Learning_Version__c learningVersion = wsops.getLearningVersionDetails(assignment.Learning_Version__c,'Resource');

        PBS_Training_Resource__c resource = learningVersion.Training_Resource__r;

        //CRUD/FLS not enforced here as we don't want to give update create or edit access to the learning assignment object to LMS Users
        //Update assignment status
        if(!learningVersion.Training_Resource__r.Prevent_completion_on_launch__c){
            assignment.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
            assignment.Progress_Percentage__c = 100;
            assignment.Evaluation_Result__c = 'N/A';
            update assignment;
        }

        //Redirect to external resource
        String resourceURL = resource.Resource_URL__c;

        if(resourceURL == null){
            return '';
        }
        //Add https prefix in case protocol is not present in the resource url
        if(!resourceURL.startsWith('http')){
            resourceURL = 'https://'+resourceURL;
        }

        //Extract anchor component from url if present
        List<String> urlAnchorComponents = resourceURL.split('#');

        PageReference ref = new PageReference(resourceURL);

        if(resource.Add_training_parameters_to_URL__c){
            ref.getParameters().put('aid',assignment.Id);
            ref.getParameters().put('tid',assignment.Training_Plan__c);
            if(urlAnchorComponents.size() > 1){
                ref.setAnchor(urlAnchorComponents[1]);
            }
        }
        String resultURL = ref.getURL();
        return resultURL;

    }

    private static PBS_Learning_Assignment__c getAssignment(String aid){
        return PBS_LMSService_CC.getLearningAssignmentDetails(aid,UserInfo.getUserId());
    }

}