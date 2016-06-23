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
public with sharing class PBS_TrainingCatalogDetailController_CC extends PBS_LMSBaseController_CC{

    private transient List<PBS_Training_Plan__c> trainingPlans{get;private set;}
    public transient List<PBS_TrainingPlanWithAchievement_CC> tPlans{get;private set;}

    public PBS_Learning_Category__c learningcategory {get; private set;}

    public PBS_TrainingCatalogDetailController_CC(){
        learningcategory = new PBS_Learning_Category__c();
        init();
    }

    private void init(){
        trainingPlans = new List<PBS_Training_Plan__c>();

        //Fetch categoryId from url
        String categoryId = Apexpages.currentPage().getParameters().get('id');
        if(String.isBlank(categoryId)){
            tPlans = new List<PBS_TrainingPlanWithAchievement_CC>();
            PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Invalid_Category_Id);
        }else{
            List<PBS_Learning_Category__c> lcats = PBS_LMSService_CC.getLearningCategories(categoryId);
            if(lcats.size()>0){
                learningcategory = lcats.get(0);

                List<Id> sortedTPlanIds = new List<Id>();

                if(PBS_LMSUtils_CC.isPortalUser()){
                    sortedTPlanIds = PBS_LMSCommunitiesService_CC.getTrainingPlanIdsForCategory(new Set<Id>{categoryId},PBS_LMSUtils_CC.getUserAccountId());
                }else{
                    sortedTPlanIds = PBS_LMSService_CC.getTrainingPlanIdsForCategory(new Set<Id>{categoryId});
                }

                if(sortedTPlanIds.size()>0){
                    //Return a sorted list of training plans
                    Map<Id,PBS_Training_Plan__c> trainingPlansMap = new Map<Id,PBS_Training_Plan__c>();

                    List<PBS_Training_Plan__c> unsortedTrainingPlans = PBS_LMSService_CC.getTrainingPlansWithItems(UserInfo.getUserId(),new Set<Id>(sortedTPlanIds),false, PBS_LMSUtils_CC.isPortalUser());

                    for(PBS_Training_Plan__c tplan : unsortedTrainingPlans){
                        if(PBS_LMSService_CC.isActiveTrainingPlan(tplan)){
                            trainingPlansMap.put(tplan.Id,tplan);
                        }
                    }
                    // Add training plans to list in sorted order
                    for(Id tplanId : sortedTPlanIds){
                        if(trainingPlansMap.containsKey(tplanId)){
                            trainingPlans.add(trainingPlansMap.get(tplanId));
                        }
                    }
                }
                createWrapperObjects(trainingPlans);
            }
        }
    }

    private void createWrapperObjects(List<PBS_Training_Plan__c> trainingPlans){

        tPlans = new List<PBS_TrainingPlanWithAchievement_CC>();

        //Create wrapper objects that include main reward information
        if(trainingPlans.size()>0){

            //Get assignments for existing training plans
            Map<Id,PBS_Training_Plan_Assignment__c> assignedTrainingPlanIds = new Map<Id,PBS_Training_Plan_Assignment__c>();

            //This query should always run with sharing as the end-user should be the full owner of the assignment
            for(PBS_Training_Plan_Assignment__c tpa : [select id
                                                        ,Status__c
                                                        ,Training_Plan__c
                                                        from PBS_Training_Plan_Assignment__c
                                                        where User__c = :UserInfo.getUserId()
                                                        and Training_Plan__c in :trainingPlans]){
                assignedTrainingPlanIds.put(tpa.Training_Plan__c,tpa);
            }

            Map<Id,PBS_Achievement__c> tmp = PBS_LMSService_CC.getTrainingMainAchievements(PBS_LMSUtils_CC.ObjectListToIdSet(trainingPlans));

            for(PBS_Training_Plan__c tp : trainingPlans){

                Boolean hasAssignment = false;
                PBS_Training_Plan_Assignment__c tpAssignment = null;
                if(assignedTrainingPlanIds.containsKey(tp.Id)){
                    hasAssignment = true;
                    tpAssignment = assignedTrainingPlanIds.get(tp.Id);
                }

                PBS_TrainingPlanWithAchievement_CC tplach = new PBS_TrainingPlanWithAchievement_CC(tp, tmp.get(tp.Id),null,hasAssignment);
                if(tpAssignment != null){
                    tplach.assignmentStatus = tpAssignment.Status__c;
                }
                tplach.hideAfterEndDate = tp.Hide_After_End_Date__c;
                tPlans.add(tplach);
            }
        }
    }

}