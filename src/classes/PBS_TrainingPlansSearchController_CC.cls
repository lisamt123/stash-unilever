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
public with sharing class PBS_TrainingPlansSearchController_CC extends PBS_LMSBaseController_CC{

    @TestVisible
    private ApexPages.StandardSetController setCon;
    public Boolean hasMessages{get{return ApexPages.hasMessages();}}
    public String currentSearchTerm{get;private set;}

    public PBS_TrainingPlansSearchController_CC(){
        init();
    }

    private void init(){
        try{

            //BEGIN Access Check
            Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
                relatedFieldsObjects.put(PBS_Training_Plan__c.sObjectType,new List<String>{
                'Name'
                ,'Description__c'
                ,'Self_Registration_Access__c'
                ,'Enable_Self_Registration__c'
                ,'New_Until__c'
                ,'Hide_After_End_Date__c'
                });
            PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjects);
            //END Access Check

            String searchTerm = ApexPages.currentPage().getParameters().get('q');
            currentSearchTerm = searchTerm;

            if(searchTerm != null && !String.isBlank(searchTerm) && searchTerm.trim().length() > 2){
                System.debug('serchTerm ' +searchTerm);
                searchTerm = '%'+searchTerm+'%';

                if(PBS_LMSUtils_CC.isPortalUser()){
                    PBS_TrainingPlansSearchController_CC.WithoutSharingOps wsops = new PBS_TrainingPlansSearchController_CC.WithoutSharingOps();
                    this.setCon = wsops.getSetCon(searchTerm);
                }else{
                    this.setCon= new ApexPages.StandardSetController(Database.getQueryLocator(
                        [SELECT Id
                                ,Name
                                ,Description__c
                                ,Enable_Self_Registration__c
                                ,Self_Registration_Access__c
                                ,New_Until__c
                                ,Start_Date__c
                                ,End_Date__c
                                ,Hide_After_End_Date__c
                                ,Status__c
                                FROM PBS_Training_Plan__c
                                WHERE Name LIKE :searchTerm
                                AND Status__c = :PBS_LMSConstants_CC.TPLAN_STATUS_ACTIVE
                                ORDER BY CreatedDate desc
                                LIMIT 200]
                    ));
                }
                this.setCon.setpageNumber(1);
                this.setCon.setPageSize(12);
            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Search_Minimum_Characters);
            }
        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'TrainingPlansSearchController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('TrainingPlansSearchController - init (1)');
        }
    }

    public List<PBS_TrainingPlanWithAchievement_CC> getSearchResults() {
        return createWrapperObjects();
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

    public Integer getTotalPages(){
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();

        Decimal pages = totalSize/pageSize;

        return (Integer)pages.round(System.RoundingMode.CEILING);
    }

    private List<PBS_TrainingPlanWithAchievement_CC> createWrapperObjects(){

        List<PBS_TrainingPlanWithAchievement_CC> tPlans = new List<PBS_TrainingPlanWithAchievement_CC>();
        List<PBS_Training_Plan__c> trainingPlans = new List<PBS_Training_Plan__c>();
        if(this.setCon != null){
            trainingPlans = (List<PBS_Training_Plan__c>) this.setCon.getRecords();
        }

        //Create wrapper objects that include main reward information
        if(trainingPlans.size()>0){

            //Get assignments for existing training plans
            Map<Id,PBS_Training_Plan_Assignment__c> assignedTrainingPlanIds = new Map<Id,PBS_Training_Plan_Assignment__c>();
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
                tplach.isExpired = !PBS_LMSService_CC.isActiveTrainingPlan(tp);

                tPlans.add(tplach);
            }
        }

        return tPlans;

    }

    private without sharing class WithoutSharingOps{
        public ApexPages.StandardSetController getSetCon(String searchTerm){
            PBS_LMSCommunitiesService_CC.WithoutSharingOps wsops = new PBS_LMSCommunitiesService_CC.WithoutSharingOps();
            Set<Id> accountTPlanIds = wsops.getTrainingPlanIdsForAccount(PBS_LMSUtils_CC.getUserAccountId());
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id
                            ,Name
                            ,Description__c
                            ,Enable_Self_Registration__c
                            ,Self_Registration_Access__c
                            ,New_Until__c
                            ,Start_Date__c
                            ,End_Date__c
                            ,Hide_After_End_Date__c
                            ,Status__c
                            FROM PBS_Training_Plan__c
                            WHERE Name LIKE :searchTerm
                            AND Status__c = :PBS_LMSConstants_CC.TPLAN_STATUS_ACTIVE
                            AND (Self_Registration_Access__c = :PBS_LMSConstants_CC.TPLAN_PUBLIC_EXTERNAL
                              OR id in :accountTPlanIds
                            )
                            ORDER BY CreatedDate desc
                            LIMIT 200]
            ));
            return setCon;
        }
    }
}