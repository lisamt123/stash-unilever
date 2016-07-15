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
public with sharing class PBS_LearningAssignmentsHelper_CC{

    //Initialize learning assignments with shared learning progress
    public void processBeforeInserts(List<PBS_Learning_Assignment__c> newAssignments){

        PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps wosHelper = new PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps();
        Set<Id> referencedLearnings = new Set<Id>();
        Set<Id> referencedUsers = new Set<Id>();
        Map<Id,PBS_Learning__c> sharedLearnings = new Map<Id,PBS_Learning__c>();
        Map<Id,List<PBS_Learning_Assignment__c>> learningAssignmentsForLearning = new Map<Id,List<PBS_Learning_Assignment__c>>();
        Map<Id,Map<Id,PBS_Shared_Learning_Assignment__c>> learningsSharedAssignments = null;

        //Create plan assignments
        Map<String,Id> planAssignments = wosHelper.createPlanAssignments(Trigger.new);
        //Create section assignments
        Map<String,Id> sectionAssignments = wosHelper.createSectionAssignments(Trigger.new,planAssignments);

        //Get ids from new assignments
        for(PBS_Learning_Assignment__c la : newAssignments){

            //Ignore test assignments
            if(la.Learning__c == null || la.Is_Test_Assignment__c){
                continue;
            }

            //Set TPSA Id
            la.Training_Plan_Section_Assignment__c = sectionAssignments.get(la.User__c+'_'+la.Training_Plan_Section__c);

            referencedLearnings.add(la.Learning__c);
            referencedUsers.add(la.User__c);

            if(!learningAssignmentsForLearning.containsKey(la.Learning__c)){
                learningAssignmentsForLearning.put(la.Learning__c,new List<PBS_Learning_Assignment__c>());
            }
            learningAssignmentsForLearning.get(la.Learning__c).add(la);
        }

        //At this point, the learnings should've been already shared with the current user, so this should be fine running with sharing
        //Get ids for learnings that have shared progress
        if(referencedLearnings.size()>0){
            List<PBS_Learning__c> learnings = wosHelper.getSharedLearningDataWOS(referencedLearnings);
            for(PBS_Learning__c l : learnings){
                sharedLearnings.put(l.Id,l);
            }
        }

        //We'll query for shared learning assignments records related to the shared learnings.
        learningsSharedAssignments = wosHelper.getSharedAssignmentsForLearningsWOS(sharedLearnings.keySet(),referencedUsers);

        //Create shared assignments for first time assignments
        List<PBS_Shared_Learning_Assignment__c> newSharedAssignments = new List<PBS_Shared_Learning_Assignment__c>();
        for(Id learningId : sharedLearnings.keySet()){
            if(!learningsSharedAssignments.containsKey(learningId)){
                PBS_Learning__c l = sharedLearnings.get(learningId);
                for(PBS_Learning_Assignment__c la : learningAssignmentsForLearning.get(learningId)){
                    PBS_Shared_Learning_Assignment__c sla = new PBS_Shared_Learning_Assignment__c();
                    sla.Learning__c = learningId;
                    sla.Progress_Percentage__c = 0;
                    sla.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED;
                    sla.Learning_Version__c = l.Current_Published_Version__c;
                    sla.OwnerId = la.OwnerId;
                    sla.User__c = la.User__c;

                    if(!learningsSharedAssignments.containsKey(l.Id)){
                        learningsSharedAssignments.put(l.Id,new Map<Id,PBS_Shared_Learning_Assignment__c>{la.User__c=>sla});
                    }else{
                        learningsSharedAssignments.get(l.Id).put(la.User__c,sla);
                    }

                    newSharedAssignments.add(sla);
                }
            }
        }

        //Insert new shared assignments
        if(newSharedAssignments.size()>0){
            wosHelper.insertSharedAssignmentsWOS(newSharedAssignments);
        }

        //Get shared assignments
        if(sharedLearnings.size()>0){
            for(PBS_Learning_Assignment__c  la : newAssignments){
                system.debug('*******la'+la);
               
                if(la.Learning__c != null){
                    Map<Id,PBS_Shared_Learning_Assignment__c> sharedAssignments = learningsSharedAssignments.get(la.Learning__c);
                    //Initialize new assignments with the shared learning assignments values if applicable
                     system.debug('*******sharedAssignments'+sharedAssignments);
                    if(sharedAssignments != null && sharedAssignments.get(la.User__c) != null){
                        PBS_Shared_Learning_Assignment__c sharedAssignment = sharedAssignments.get(la.User__c);
                        la.Shared_Learning_Assignment__c = sharedAssignment.Id;
                        la.Progress__c = sharedAssignment.Progress__c;
                        la.Progress_Percentage__c = sharedAssignment.Progress_Percentage__c;
                        la.Evaluation_Result__c = sharedAssignment.Evaluation_Result__c;
                        la.Evaluation_Score__c = sharedAssignment.Evaluation_Score__c;
                        la.Evaluation_Times_Taken__c = sharedAssignment.Evaluation_Times_Taken__c;
                        la.Last_Published_Learning_Version__c = sharedAssignment.Last_Published_Learning_Version__c;
                        la.Last_Published_Learning_Version_Decision__c = sharedAssignment.Last_Published_Learning_Version_Decision__c;
                        la.Learning_Version__c = sharedAssignment.Learning_Version__c;
                    }
                }
            }
        }

    }

    //Update approval fields
    public void processBeforeUpdates(Map<Id,PBS_Learning_Assignment__c> oldAssignmentsMap,Map<Id,PBS_Learning_Assignment__c> newAssignmentsMap){

        //Iterate over assignments to get trainin plan section item keys
        Map<Id,Boolean> tPlanSectionItemMap = new Map<Id,Boolean>();

        //Only process assignments that have changed
        for(PBS_Learning_Assignment__c la : newAssignmentsMap.values()){

            //Ignore test assignments
            if(la.Is_Test_Assignment__c){
                continue;
            }

            PBS_Learning_Assignment__c oldLA = oldAssignmentsMap.get(la.Id);

            if(la.Approved__c != oldLA.Approved__c && la.Progress__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW){
                la.Approved_By__c = UserInfo.getUserId();
                la.Progress__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
                la.Progress_Percentage__c = 100;
            }

            if(oldLA.Progress__c != PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED && la.Progress__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED){
                la.Completed_On__c = Date.today();
            }

            if(la.Training_Plan_Section_Item__c != null){
                tPlanSectionItemMap.put(la.Training_Plan_Section_Item__c,false);
            }
        }


        //Fetch optional attribute from related training plan section items
        if(tPlanSectionItemMap.size()>0){
            PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps wosHelper = new PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps();
            List<PBS_Training_Plan_Section_Item__c> tplanSectionItems = wosHelper.getTPlanSectionItemsWOS(tPlanSectionItemMap.keySet());
            for(PBS_Training_Plan_Section_Item__c tpsi : tplanSectionItems){
                Boolean isOptional = false;
                if(tpsi.Training_Plan_Section__r != null && tpsi.Training_Plan_Section__r.Optional__c){
                    isOptional = true;
                }else{
                    isOptional = tpsi.Optional__c;
                }
                tPlanSectionItemMap.put(tpsi.id,isOptional);
            }
        }

        //Update the optional field value at the learning assignment level
        for(PBS_Learning_Assignment__c la : newAssignmentsMap.values()){
            if(tPlanSectionItemMap.containsKey(la.Training_Plan_Section_Item__c) && (la.Optional__c != tPlanSectionItemMap.get(la.Training_Plan_Section_Item__c))){
                la.Optional__c = tPlanSectionItemMap.get(la.Training_Plan_Section_Item__c);
            }
        }

    }

    public void processBeforeDeletes(List<PBS_Learning_Assignment__c> oldAssignments){

        Set<Id> deletedUnSharedAssignments = new Set<Id>();

        //Delete responses for assignments that don't have a shared assignment or test assignments
        for(PBS_Learning_Assignment__c la : oldAssignments){
            if(la.Shared_Learning_Assignment__c == null || la.Is_Test_Assignment__c){
                deletedUnSharedAssignments.add(la.Id);
            }
        }

        //Retrieve related responses
        if(deletedUnSharedAssignments.size()>0){
            PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps wosHelper = new PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps();
            wosHelper.deleteResponsesForAssignmentWOS(deletedUnSharedAssignments);
        }

    }

    //Update section assignments status if the learning assignment was initialized through a shared assignment
    public void processAfterInserts(List<PBS_Learning_Assignment__c> newAssignments){
        Set<Id> updatedAssignmentsIds = new Set<Id>();

        for(PBS_Learning_Assignment__c la : newAssignments){
            if(!la.Is_Test_Assignment__c && la.Training_Plan_Section__c != null){
                updatedAssignmentsIds.add(la.Id);
            }
        }

        if(updatedAssignmentsIds.size()>0){
            updateSectionAssignments(updatedAssignmentsIds,null,null);
        }
    }

    //Update related shared progress for assignments
    public void processAfterUpdates(Map<Id,PBS_Learning_Assignment__c> oldAssignmentsMap,Map<Id,PBS_Learning_Assignment__c> newAssignmentsMap){

        Map<Id,PBS_Learning_Assignment__c> sharedAssignments = new Map<Id,PBS_Learning_Assignment__c>();
        List<PBS_Shared_Learning_Assignment__c> sharedAssignmentsForUpdate = new List<PBS_Shared_Learning_Assignment__c>();
        Set<Id> updatedAssignmentIds = new Set<Id>();

        //Only process assignments that have changd
        for(PBS_Learning_Assignment__c la : newAssignmentsMap.values()){

            //Skip triggers for test assignments
            if(la.Is_Test_Assignment__c){
                continue;
            }

            PBS_Learning_Assignment__c oldLA = oldAssignmentsMap.get(la.Id);

            if(((la.Progress__c != oldLA.Progress__c) || (la.Optional__c != oldLA.Optional__c))){
                //Add assignment id to completed list
                updatedAssignmentIds.add(la.Id);
            }

            //Only process changes for shared assignments if the current context is not "future"
            if(!System.isFuture() && !System.isBatch()){
                if(la.Shared_Learning_Assignment__c != null){

                    //Make sure we always keep these conditions in sync with the conditions defined in the shared Learning assignment helper class
                    if(!sharedAssignments.containsKey(la.Shared_Learning_Assignment__c)){
                        if(la.Progress__c != oldLA.Progress__c
                           || la.Progress_Percentage__c != oldLA.Progress_Percentage__c
                           || la.Last_Published_Learning_Version__c != oldLA.Last_Published_Learning_Version__c
                           || la.Last_Published_Learning_Version_Decision__c != oldLA.Last_Published_Learning_Version_Decision__c
                           || la.Approved__c != oldLA.Approved__c
                           || la.Approved_By__c != oldLA.Approved_By__c){

                            sharedAssignments.put(la.Shared_Learning_Assignment__c,la);
                        }
                    }
                }
            }else{
                //TODO: Analyze use cases and impact of not updating shared assignments in this scenario
                //It's important to understand that enabling this could potentially introduce update loops
                System.debug('*** Blocked updating shared assignment progress since we are already in future context');
            }
        }

        //Update related shared assignments
        for(Id saId : sharedAssignments.keySet()){
            PBS_Learning_Assignment__c la = sharedAssignments.get(saId);
            PBS_Shared_Learning_Assignment__c sla = new PBS_Shared_Learning_Assignment__c(Id=saId);
            sla.Progress__c = la.Progress__c;
            sla.Progress_Percentage__c = la.Progress_Percentage__c;
            sla.Last_Published_Learning_Version__c = la.Last_Published_Learning_Version__c;
            sla.Last_Published_Learning_Version_Decision__c = la.Last_Published_Learning_Version_Decision__c;
            sla.Evaluation_Result__c = la.Evaluation_Result__c;
            sla.Evaluation_Score__c = la.Evaluation_Score__c;
            sla.Evaluation_Times_Taken__c = la.Evaluation_Times_Taken__c;
            //Set the triggering learning assignment in the last update field to prevent updating it again
            sla.Learning_Assignment_Last_Update__c = la.Id;
            sla.Approved__c = la.Approved__c;
            sla.Approved_By__c = la.Approved_By__c;
            sharedAssignmentsForUpdate.add(sla);
        }

        if(sharedAssignmentsForUpdate.size()>0){
            PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps wosHelper = new PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps();
            wosHelper.updateSharedAssignmentsWOS(sharedAssignmentsForUpdate);
        }

        //Run additional processes for modified assignments
        if(updatedAssignmentIds.size()>0){
            if(!System.isFuture() && !System.isBatch() && !PBS_LMSSettings_CC.getDisableFutureProgressCalculation()){
                updateSectionAssignmentsInFuture(updatedAssignmentIds,null,null);
            }else{
                //Process section and training plan updates in the current (future/batch) transaction
                updateSectionAssignments(updatedAssignmentIds,null,null);
            }
        }
    }

    public void processAfterUnDeletes(List<PBS_Learning_Assignment__c> unDeletedAssignments){
        if(!System.isFuture() && !System.IsBatch()){
            Set<Id> updatedAssignmentIds = new Set<Id>();
            for(PBS_Learning_Assignment__c la : unDeletedAssignments){
                if(!la.Is_Test_Assignment__c){
                    updatedAssignmentIds.add(la.Id);
                }
            }
            updateSectionAssignmentsInFuture(updatedAssignmentIds,null,null);
        }else{
            System.debug('*** Unable to run processUnDeletes since we are already in future context');
        }
    }

    public void processAfterDeletes(List<PBS_Learning_Assignment__c> deletedAssignments){
        Set<Id> relatedTPlanSections = new Set<Id>();
        Set<Id> relatedUsers = new Set<Id>();
        for(PBS_Learning_Assignment__c la : deletedAssignments){
            if(!la.Is_Test_Assignment__c){
                relatedTPlanSections.add(la.Training_Plan_Section__c);
                relatedUsers.add(la.User__c);
            }
        }
        if(!System.isFuture() && !System.IsBatch()){
            updateSectionAssignmentsInFuture(new Set<Id>(),relatedTPlanSections,relatedUsers);
        }else{
            updateSectionAssignments(new Set<Id>(),relatedTPlanSections,relatedUsers);
        }
    }

    @future
    public static void updateSectionAssignmentsInFuture(Set<Id> updatedAssignmentIds, Set<Id> delTPSections, Set<Id> delUsers){
        updateSectionAssignments(updatedAssignmentIds,delTPSections,delUsers);
    }

    public static void updateSectionAssignments(Set<Id> updatedAssignmentIds, Set<Id> delTPSections, Set<Id> delUsers){
        PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps wosHelper = new PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps();
        wosHelper.updateSectionAssignmentsWOS(updatedAssignmentIds,delTPSections,delUsers);
    }

    public static void updateTrainingPlanAssignments(Set<Id> relatedTPlans,Set<Id> relatedUsers){
        PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps wosHelper = new PBS_LearningAssignmentsHelper_Helper.WithoutSharingOps();
        wosHelper.updateTrainingPlanAssignmentsWOS(relatedTPlans,relatedUsers);
    }

}