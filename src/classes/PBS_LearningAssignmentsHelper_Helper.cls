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
public with sharing class PBS_LearningAssignmentsHelper_Helper{

 public without sharing class WithoutSharingOps{

        // We need to make sure progress recalculation has access to all assignment records even if some are not shared
        // with the running user
        public void updateTrainingPlanAssignmentsWOS(Set<Id> relatedTPlans,Set<Id> relatedUsers){

            Map<String,Map<String,Integer>> sectionAggregatedResults = new Map<String,Map<String,Integer>>();
            List<PBS_Training_Plan_Assignment__c> planAssignmentsToUpdate = new List<PBS_Training_Plan_Assignment__c>();

            if(relatedTPlans != null && relatedUsers != null && relatedTPlans.size()>0 && relatedUsers.size() >0){

                //Get aggregate information for associated section assignments
                AggregateResult[] tPlanGroupedResults = [select Training_Plan_Section__r.Training_Plan__c tplan
                                                         ,User__c
                                                         ,Status__c
                                                         ,Training_Plan_Section__r.Optional__c opt
                                                         ,count(Id) cnt
                                                         from PBS_Training_Plan_Section_Assignment__c
                                                         where User__c in :relatedUsers
                                                         and Training_Plan_Section__r.Training_Plan__c in :relatedTPlans
                                                         group by Training_Plan_Section__r.Training_Plan__c,User__c,Status__c,Training_Plan_Section__r.Optional__c];

                //Update progress on related section assignments
                String ns = PBS_LMSUtils_CC.getPackageNamespace();
                String OPT_PREFIX = 'opt_';

                for(AggregateResult ar : tPlanGroupedResults){
                    String tPlanId = (String)ar.get('tplan');
                    String userId = (String)ar.get(ns+'User__c');
                    String statusType = (String)ar.get(ns+'Status__c');
                    Integer count = (Integer)ar.get('cnt');

                    String optionalItem = '';
                    if(ar.get('opt') != null){
                      Boolean isOptional = (Boolean)ar.get('opt');
                      optionalItem = isOptional?OPT_PREFIX:'';
                    }
                    statusType = optionalItem+statusType;

                    String arKey = userId+'_'+tPlanId;

                    if(!sectionAggregatedResults.containsKey(arKey)){
                        Map<String,Integer> initMap = new Map<String,Integer>{
                            PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED=>0,
                            PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS=>0,
                            PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED=>0,
                            ''+OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED=>0,
                            ''+OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS=>0,
                            ''+OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED=>0
                        };
                        sectionAggregatedResults.put(arKey,initMap);
                    }
                    sectionAggregatedResults.get(arKey).put(statusType,count);
                }

                //Fetch training plan assignments
                for(PBS_Training_Plan_Assignment__c pa : [select id
                                                      ,User__c
                                                      ,Training_Plan__c
                                                      ,Status__c
                                                      from PBS_Training_Plan_Assignment__c
                                                      where User__c in :relatedUsers
                                                      and Training_Plan__c in :relatedTPlans]){


                    String asKey = pa.User__c+'_'+pa.Training_Plan__c;
                    if(sectionAggregatedResults.containsKey(asKey)){
                        Integer lNotStarted = sectionAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED);
                        Integer lInProgress = sectionAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS);
                        Integer lCompleted = sectionAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED);
                        sectionAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED);
                        Integer lInProgressOpt = sectionAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS);
                        Integer lCompletedOpt = sectionAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED);

                        String currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED;

                        if(lInProgress >= 1 || (lCompleted > 0 && lNotStarted >= 1) || (lInProgress == 0 && lCompleted == 0 && (lInProgressOpt >= 1 || (lCompletedOpt >= 1 && lNotStarted >= 1)))){
                            currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS;
                        }else if(lInProgress == 0 && lNotStarted == 0 && lCompleted > 0){
                            currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
                        }else if (lInProgress == 0 && lNotStarted == 0 && lCompleted == 0 && lInProgressOpt == 0 && lNotStarted == 0 && lCompletedOpt >= 1){
                          currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
                        }

                        pa.Status__c = currentStatus;
                        planAssignmentsToUpdate.add(pa);
                    }

                }

                //Update training plan assignments
                if(planAssignmentsToUpdate.size()>0){
                    update planAssignmentsToUpdate;
                }

            }
        }

        //We need to run this without sharing in case the running user doesn't have access to the parent training plan
        public List<PBS_Training_Plan_Section_Item__c> getTPlanSectionItemsWOS(Set<Id> tplanSectionItemIds){
            return [select id
                            ,Optional__c
                            ,Training_Plan_Section__r.Optional__c
                            from PBS_Training_Plan_Section_Item__c
                            where id in :tplanSectionItemIds];
        }

        //We need to run this without sharing in case the running use doesn't have View All access on the response object
        public void deleteResponsesForAssignmentWOS(Set<Id> assignmentIds){
            List<PBS_Response__c> relatedResponsesToDelete = [select id from PBS_Response__c where Learning_Assignment__c in :assignmentIds];
            if(relatedResponsesToDelete.size()>0){
                delete relatedResponsesToDelete;
            }
        }

        //We need to run this without sharing to make sure the running user has access to shared learning assignments that may have not been shared with him/her
        //This could happen when an approver, or delegated admin with limited access is creating assignments
        //Return a map of shared assignments for the specified learnings + user ids
        public Map<Id,Map<Id,PBS_Shared_Learning_Assignment__c>> getSharedAssignmentsForLearningsWOS(Set<Id> learningIds,Set<Id> userIds){

            Map<Id,Map<Id,PBS_Shared_Learning_Assignment__c>> results = new Map<Id,Map<Id,PBS_Shared_Learning_Assignment__c>>();

            //Create local scope vars for Dynamic SOQL binding
            Set<Id> lIds = learningIds;
            Set<Id> uIds = userIds;

            List<String> listSOQLFields = new List<String>{
                'Id'
                ,'Name'
                ,'Contact__c'
                ,'OwnerId'
                ,'User__c'
                ,'Learning__c'
                ,'Learning_Version__c'
                ,'Learning_Version__r.Version__c'
                ,'Learning_Version__r.Learning_Content_ID__c'
                ,'Progress__c'
                ,'Progress_Percentage__c'
                ,'Evaluation_Result__c'
                ,'Evaluation_Score__c'
                ,'Evaluation_Times_Taken__c'
                ,'Approved__c'
                ,'Approved_By__c'
                ,'Last_Published_Learning_Version__c'
                ,'Last_Published_Learning_Version_Decision__c'
            };

            String soqlQuery = 'select '+String.join(listSOQLFields,',')+' from PBS_Shared_Learning_Assignment__c where User__c in :uIds and Learning__c in :lIds';
            soqlQuery += ' order by CreatedDate desc';

            List<PBS_Shared_Learning_Assignment__c> sharedAssignments = (List<PBS_Shared_Learning_Assignment__c>)Database.query(soqlQuery);
            for(PBS_Shared_Learning_Assignment__c a : sharedAssignments){

                if(!results.containsKey(a.Learning__c)){
                    results.put(a.Learning__c, new Map<Id,PBS_Shared_Learning_Assignment__c>());
                }
                results.get(a.Learning__c).put(a.User__c,a);
            }

            return results;
        }

        //It's possible that a users with limited access to learnings is creating an assignment for another user, we need to make sure we still have access to read the learning data
        public List<PBS_Learning__c> getSharedLearningDataWOS(Set<Id> referencedLearnings){
            return [select id,Current_Published_Version__c from PBS_Learning__c where id in :referencedLearnings and Sync_progress__c = true];
        }

        //We need to insert shared assignments without sharing since we're referencing learnings that may not be shared with the running user
        public void insertSharedAssignmentsWOS(List<PBS_Shared_Learning_Assignment__c> newSharedAssignments){
            insert newSharedAssignments;
        }

        //We need to insert shared assignments without sharing since we're referencing learnings that may not be shared with the running user
        public void updateSharedAssignmentsWOS(List<PBS_Shared_Learning_Assignment__c> updatedSharedAssignments){
            update updatedSharedAssignments;
        }

        // We need to update section assignments without sharing since it's possible that the training plan objects have not been shared with the running user
        public void updateSectionAssignmentsWOS(Set<Id> updatedAssignmentIds, Set<Id> delTPSections, Set<Id> delUsers){

            Map<String,Map<String,Integer>> learningAggregatedResults = new Map<String,Map<String,Integer>>();
            List<PBS_Training_Plan_Section_Assignment__c> sectionAssignmentsToUpdate = new List<PBS_Training_Plan_Section_Assignment__c>();

            Set<Id> relatedTPlans = new Set<Id>();
            Set<Id> relatedTPlanSections = new Set<Id>();
            Set<Id> relatedUsers = new Set<Id>();

            if(delTPSections != null && delUsers != null){
                relatedTPlanSections = delTPSections;
                relatedUsers = delUsers;
            }else{
                //Get additional assignment information
                for(PBS_Learning_Assignment__c la : [select id
                                                        ,User__c
                                                        ,Training_Plan_Section__c
                                                        from PBS_Learning_Assignment__c
                                                        where id in :updatedAssignmentIds]){

                    relatedTPlanSections.add(la.Training_Plan_Section__c);
                    relatedUsers.add(la.User__c);
                }
            }

            //Filter inactive users
            Set<Id> activeUserIds = new Set<Id>();
            for(User u : [select id from User where id in :relatedUsers and IsActive = true]){
                activeUserIds.add(u.Id);
            }
            relatedUsers = activeUserIds;

            //Get aggregate information for associated assignments
            AggregateResult[] groupedResults = [select Training_Plan_Section__c
                                                        ,User__c
                                                        ,Progress__c
                                                        ,Training_Plan_Section_Item__r.Optional__c opt
                                                        ,count(Id) cnt
                                                        from PBS_Learning_Assignment__c
                                                        where User__c in :relatedUsers
                                                        and Training_Plan_Section__c in :relatedTPlanSections
                                                        and Training_Plan_Section_Item__c != null
                                                        group by Training_Plan_Section__c,User__c,Progress__c,Training_Plan_Section_Item__r.Optional__c];

            String OPT_PREFIX = 'opt_';

            //Update progress on related section assignments
            String ns = PBS_LMSUtils_CC.getPackageNamespace();
            for(AggregateResult ar : groupedResults){
                String tPlanSectionId = (String)ar.get(ns+'Training_Plan_Section__c');
                String userId = (String)ar.get(ns+'User__c');

                Integer count = (Integer)ar.get('cnt');

                String optionalItem = '';
                if(ar.get('opt') != null){
                  Boolean isOptional = (Boolean)ar.get('opt');
                  optionalItem = isOptional?OPT_PREFIX:'';
                }

                //Default value of the progress type is not started
                String progressType = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED;
                if(ar.get(ns+'Progress__c') != null){
                  progressType = (String)ar.get(ns+'Progress__c');
                }
                progressType = optionalItem+progressType;

                String arKey = userId+'_'+tPlanSectionId;

                if(!learningAggregatedResults.containsKey(arKey)){
                    Map<String,Integer> initMap = new Map<String,Integer>{
                        PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED=>0,
                        PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS=>0,
                        PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW=>0,
                        PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED=>0,
                        ''+OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED=>0,
                        ''+OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS=>0,
                        ''+OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW=>0,
                        ''+OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED=>0

                    };
                    learningAggregatedResults.put(arKey,initMap);
                }
                learningAggregatedResults.get(arKey).put(progressType,count);
            }

            //Fetch training plan section assignments
            for(PBS_Training_Plan_Section_Assignment__c sa : [select id
                                                                ,User__c
                                                                ,Training_Plan_Section__c
                                                                ,Training_Plan_Section__r.Training_Plan__c
                                                                ,Status__c
                                                                from PBS_Training_Plan_Section_Assignment__c
                                                                where User__c in :relatedUsers
                                                                and Training_Plan_Section__c in :relatedTPlanSections]){

                relatedTPlans.add(sa.Training_Plan_Section__r.Training_Plan__c);

                String asKey = sa.User__c+'_'+sa.Training_Plan_Section__c;
                if(learningAggregatedResults.containsKey(asKey)){

                    Integer lNotStarted = learningAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED);
                    Integer lInProgress = learningAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS);
                    Integer lCompleted = learningAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED);
                    learningAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED);
                    Integer lInProgressOpt = learningAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS);
                    Integer lCompletedOpt = learningAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED);

                    if(learningAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW) != null){
                      lInProgress += learningAggregatedResults.get(asKey).get(PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW);
                    }
                    if(learningAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW) != null){
                      lInProgressOpt += learningAggregatedResults.get(asKey).get(OPT_PREFIX+PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_REVIEW);
                    }

                    String currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED;

                    if(lInProgress >= 1 || (lCompleted > 0 && lNotStarted >= 1) || (lInProgress == 0 && lCompleted == 0 && (lInProgressOpt >= 1 || (lCompletedOpt >= 1 && lNotStarted >= 1)))){
                        currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_IN_PROGRESS;
                    }else if(lInProgress == 0 && lNotStarted == 0 && lCompleted > 0){
                        currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
                    }else if (lInProgress == 0 && lNotStarted == 0 && lCompleted == 0 && lInProgressOpt == 0 && lNotStarted == 0 && lCompletedOpt >= 1){
                      currentStatus = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED;
                    }

                    sa.Status__c = currentStatus;
                    sectionAssignmentsToUpdate.add(sa);

                }

            }

            //Update section assigments
            if(sectionAssignmentsToUpdate.size()>0){
                update sectionAssignmentsToUpdate;
            }

            //Clear unusued maps before we continue
            learningAggregatedResults.clear();
            groupedResults.clear();

            //Update Training Plan Assignments
            PBS_LearningAssignmentsHelper_CC.updateTrainingPlanAssignments(relatedTPlans,relatedUsers);
        }

        // We need to update section assignments without sharing since it's possible that the training plan objects have not been shared with the running user
        public Map<String,Id> createPlanAssignments(List<PBS_Learning_Assignment__c> newAssignments){

            Map<String,Id> results = new Map<String,Id>();
            Map<String,PBS_Training_Plan_Assignment__c> insertTPAs = new Map<String,PBS_Training_Plan_Assignment__c>();

            Set<Id> userIds = new Set<Id>();
            Set<Id> trainingPlanIds = new Set<Id>();
            for(PBS_Learning_Assignment__c la : newAssignments){
                if(la.Training_Plan__c != null && !la.Is_Test_Assignment__c){
                    results.put(la.User__c+'_'+la.Training_Plan__c,null);
                    userIds.add(la.User__c);
                    trainingPlanIds.add(la.Training_Plan__c);
                }
            }

            //Look for existing plan assignments
            for(PBS_Training_Plan_Assignment__c tpa : [select id
                                                            ,Status__c
                                                            ,User__c
                                                            ,Training_Plan__c
                                                            from PBS_Training_Plan_Assignment__c
                                                            where User__c in :userIds
                                                            and Training_Plan__c in :trainingPlanIds]){
                results.put(tpa.User__c+'_'+tpa.Training_Plan__c,tpa.Id);
            }

            //Create new plan assignments in case these are not present
            for(PBS_Learning_Assignment__c la : newAssignments){
                String laKey = la.User__c+'_'+la.Training_Plan__c;
                if(!la.Is_Test_Assignment__c && results.get(laKey) == null && !insertTPAs.containsKey(laKey)){
                    PBS_Training_Plan_Assignment__c newTPA = new PBS_Training_Plan_Assignment__c();
                    newTPA.User__c = la.User__c;
                    newTPA.OwnerId = la.User__c;
                    newTPA.Training_Plan__c = la.Training_Plan__c;
                    newTPA.Community_Id__c = la.Community_Id__c;
                    newTPA.Status__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED;
                    insertTPAs.put(laKey,newTPA);
                }
            }

            if(insertTPAs.size()>0){
                insert insertTPAs.values();
            }

            for(PBS_Training_Plan_Assignment__c tpa : insertTPAs.values()){
                results.put(tpa.User__c+'_'+tpa.Training_Plan__c,tpa.Id);
            }

            return results;

        }

        // We need to update section assignments without sharing since it's possible that the training plan objects have not been shared with the running user
        public Map<String,Id> createSectionAssignments(List<PBS_Learning_Assignment__c> newAssignments,Map<String,Id> planAssignments){

            Map<String,Id> results = new Map<String,Id>();
            Map<String,PBS_Training_Plan_Section_Assignment__c> insertTPSAs = new Map<String,PBS_Training_Plan_Section_Assignment__c>();

            Set<Id> userIds = new Set<Id>();
            Set<Id> trainingPlanSectionIds = new Set<Id>();
            for(PBS_Learning_Assignment__c la : newAssignments){
                if(la.Training_Plan_Section__c != null && !la.Is_Test_Assignment__c){
                    results.put(la.User__c+'_'+la.Training_Plan_Section__c,null);
                    userIds.add(la.User__c);
                    trainingPlanSectionIds.add(la.Training_Plan_Section__c);
                }
            }

            //Look for existing section assignments
            for(PBS_Training_Plan_Section_Assignment__c tpsa : [select id
                                                                    ,Status__c
                                                                    ,User__c
                                                                    ,Training_Plan_Section__c
                                                                    from PBS_Training_Plan_Section_Assignment__c
                                                                    where User__c in :userIds
                                                                    and Training_Plan_Section__c in :trainingPlanSectionIds]){
                results.put(tpsa.User__c+'_'+tpsa.Training_Plan_Section__c,tpsa.Id);
            }

            //Create new section assignments in case these are not present
            for(PBS_Learning_Assignment__c la : newAssignments){
                String laKey = la.User__c+'_'+la.Training_Plan_Section__c;
                if(!la.Is_Test_Assignment__c && results.get(laKey) == null && !insertTPSAs.containsKey(laKey)){
                    PBS_Training_Plan_Section_Assignment__c newTPSA = new PBS_Training_Plan_Section_Assignment__c();
                    newTPSA.User__c = la.User__c;
                    newTPSA.OwnerId = la.User__c;
                    newTPSA.Training_Plan_Section__c = la.Training_Plan_Section__c;
                    newTPSA.Status__c = PBS_LMSConstants_CC.ASSIGNMENT_STATUS_NOT_STARTED;
                    newTPSA.Community_Id__c = la.Community_Id__c;
                    newTPSA.Training_Plan_Assignment__c = planAssignments.get(la.User__c+'_'+la.Training_Plan__c);
                    insertTPSAs.put(laKey,newTPSA);
                }
            }

            if(insertTPSAs.size()>0){
                insert insertTPSAs.values();
            }

            for(PBS_Training_Plan_Section_Assignment__c tpsa : insertTPSAs.values()){
                results.put(tpsa.User__c+'_'+tpsa.Training_Plan_Section__c,tpsa.Id);
            }

            return results;
        }

    }
}