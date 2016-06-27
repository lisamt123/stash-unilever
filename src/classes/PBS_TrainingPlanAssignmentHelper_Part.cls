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
public with sharing class PBS_TrainingPlanAssignmentHelper_Part{

  //This method evaluates completed plan assignments and updates related AA records status
    public static void processAchievementRulesForAssignments(Map<Id,PBS_Training_Plan_Assignment__c> oldAssignmentsMap,Map<Id,PBS_Training_Plan_Assignment__c> newAssignmentsMap){

        PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps wosHelper = new PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps();

        //Auxiliary collections
        Set<Id> trainingPlanIds = new Set<Id>();
        Set<Id> trainingPlanAchievementIds = new Set<Id>();
        List<PBS_Achievement_Assignment__c> achievementAssignmentsToUpdate = new List<PBS_Achievement_Assignment__c>();

        List<PBS_Training_Plan_Assignment__c> completedAssignments = new List<PBS_Training_Plan_Assignment__c>();
        Map<Id,List<PBS_Training_Plan_Assignment__c>> completedAssignmentsPerUser = new Map<Id,List<PBS_Training_Plan_Assignment__c>>();

        //Get plan ids for assignments and separate completed assignments
        for(PBS_Training_Plan_Assignment__c tpa : newAssignmentsMap.values()){

            PBS_Training_Plan_Assignment__c oldTpa = oldAssignmentsMap.get(tpa.Id);

            if(tpa.User__c != null && tpa.Training_Plan__c != null){
                if(oldTpa.Status__c != PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED && tpa.Status__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED){

                    if(!completedAssignmentsPerUser.containsKey(tpa.User__c)){
                        completedAssignmentsPerUser.put(tpa.User__c,new List<PBS_Training_Plan_Assignment__c>());
                    }

                    completedAssignmentsPerUser.get(tpa.User__c).add(tpa);
                    trainingPlanIds.add(tpa.Training_Plan__c);
                    completedAssignments.add(tpa);
                }
            }
        }

        //Continue only if there are completed assignments
        if(completedAssignments.size()>0){

            //Get training plan achievements for the plan
            Map<Id,List<PBS_Training_Plan_Achievement__c>> planAchievementsMap = wosHelper.getTrainingPlanAchievementsWOS(trainingPlanIds);

            for(Id tpId : planAchievementsMap.keySet()){
                for(PBS_Training_Plan_Achievement__c tpa : planAchievementsMap.get(tpId)){
                    trainingPlanAchievementIds.add(tpa.Id);
                }
            }

            //We have achievements related to the completed plans, continue analysis
            if(trainingPlanAchievementIds != null && trainingPlanAchievementIds.size()>0){

                //Get AA records for the users + training plan achievements
                Map<String,List<PBS_Achievement_Assignment__c>> userPlanAchievementAssignments = PBS_LMSService_CC.getAchievementAssignmentforTrainingPlanAchievements(completedAssignmentsPerUser.keySet(),trainingPlanAchievementIds);

                //Iterate over completed assignments and update corresponding achievement assignment records
                for(PBS_Training_Plan_Assignment__c tpa : completedAssignments){
                    List<PBS_Achievement_Assignment__c> aas = userPlanAchievementAssignments.get(tpa.User__c+'_'+tpa.Training_Plan__c);
                    if(aas != null){
                        for(PBS_Achievement_Assignment__c aa : aas){
                            if(aa.Achievement__r.Override_Completed_Status__c != null){
                                aa.Status__c = aa.Achievement__r.Override_Completed_Status__c;
                            }else{
                                aa.Status__c = PBS_LMSConstants_CC.AA_ACQUIRED_STATUS;
                            }
                            achievementAssignmentsToUpdate.add(aa);
                        }
                    }
                }
            }

            //Update AA records
            if(achievementAssignmentsToUpdate.size()>0){
                wosHelper.updateAchievementAssignmentsWOS(achievementAssignmentsToUpdate);
            }

            if(!PBS_LMSSettings_CC.getDisableTrackAchievements()){
                //Check for training track progress for the completed assignments
                processAchievementRulesForTracks(completedAssignmentsPerUser.keySet(),trainingPlanIds);
            }

        }

    }
    
     private static void processAchievementRulesForTracks(Set<Id> uIds, Set<Id> tPlanIds){

        try{

            //Extract training tracks from the completed training plan ids
            PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps wosHelper = new PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps();
            Set<Id> trackIds = wosHelper.getAssociatedTrainingTracksWOS(tPlanIds);

            //Update progress for all the users in the associated tracks
            if(!System.isFuture() && !System.isBatch()){
                calculateTrainingTrackProgressInFuture(uIds,trackIds);
            }else{
                calculateTrainingTrackProgress(uIds,trackIds);
            }

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'TrainingPlanAssignmentHelper');
        }

    }
    
    @future
    private static void calculateTrainingTrackProgressInFuture(Set<Id> uIds, Set<Id> trackIds){
        calculateTrainingTrackProgress(uIds,trackIds);
    }

    private static void calculateTrainingTrackProgress(Set<Id> uIds, Set<Id> trackIds){
        PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps wosHelper = new PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps();
        wosHelper.calculateTrainingTrackProgressWOS(uIds,trackIds);
    }
    
    //This methods deletes all training plan section assignments associated to the specified plan assignments
    public static void deleteAssociatedLearningAssignments(List<PBS_Training_Plan_Assignment__c> assignments){

        //Set a static attribute in the assignment helper with the list of the deleted training plan asssignment ids
        //This will be used to ignore progress recalculation
        Set<Id> deletedTrainingPlanAssignmentIds = new Set<Id>();
        Map<Id,Set<Id>> mapTPlanUserIds = new Map<Id,Set<Id>>();

        for(PBS_Training_Plan_Assignment__c tpa : assignments){
            if(tpa.Training_Plan__c != null){
                deletedTrainingPlanAssignmentIds.add(tpa.Id);
                if(!mapTPlanUserIds.containsKey(tpa.Training_Plan__c)){
                    mapTPlanUserIds.put(tpa.Training_Plan__c, new Set<Id>());
                }
                mapTPlanUserIds.get(tpa.Training_Plan__c).add(tpa.User__c);
            }
        }

        PBS_TrainingPlanSectionAsgnmtHelper_CC.deletedTrainingPlanAssignments = deletedTrainingPlanAssignmentIds;

        PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps wosHelper = new PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps();
        wosHelper.deleteAssociatedLearningAssignmentsWOS(assignments,mapTPlanUserIds);

    }
}