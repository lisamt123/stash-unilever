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
public with sharing class PBS_LMSExport_CC{
    public static final string DESCRIPTION_C = 'Description__c' ; 
    public static final string ORDER_C = 'order__c';
    private Set<Id> trainingPlanIds;
    private Set<Id> trainingTrackIds;
    private PBS_LMSExport_Helper.WithoutSharingOps wsops;
    
    private static final string description = 'description'; // Added this to avoid duplication of string literal LastName
    private static final string Order = 'order';
    private static final string Type = 'type';
    private static final string content = 'content';
    
    
    //Learning aux collections
    private Map<Id,PBS_Learning__c> learningsMap;
    private Map<String,List<Id>> learningIdsByType;

    //Lookup aux collections
    private Map<Id,PBS_Achievement__c> achievementsMap;
    private Map<Id,PBS_Learning_Category__c> categoriesMap;
    private Set<Id> answerSequenceItemIds;
    private Set<Id> achievementCategoryIds;
    private Set<Id> learningCategoryIds;
    private Set<Id> trackAchievementIds;

    //Export mappings
    private Map<String,String> quizMappings = new Map<String,String>{
        'Name' => 'name'
        ,DESCRIPTION_C => description
        ,'Passing_Score__c' => 'passing-score'
        ,'Max_Attempts__c' => 'max-attempts'
        ,'Delete_Responses_On_Submission__c' => 'delete-responses-on-submission'
    };

    Map<String,String> learningMappings = new Map<String,String>{
        'Name' => 'name'
        ,'Duration__c' => 'duration'
        ,'Sync_progress__c' => 'sync-progress'
        ,DESCRIPTION_C => description
    };

    Map<String,String> questionLineMappings = new Map<String,String>{
        'Name' => 'name'
        ,ORDER_C => Order
        ,DESCRIPTION_C => description
    };

    Map<String,String> questionMappings = new Map<String,String>{
        ORDER_C => Order
        ,DESCRIPTION_C => description
        ,'Type__c' => Type
        ,'Correct_Boolean__c' => 'correct-boolean'
        ,'Correct_Number__c' => 'correct-number'
        ,'Description_RTA__c' => 'description-rta'
    };

    Map<String,String> taskMappings = new Map<String,String>{
        'Name' => 'name'
        ,'External_Resource_Name__c' => 'resource-name'
        ,'External_Resource_URL__c' => 'resource-url'
        ,'External_Resource_Target__c' => 'resource-target'
        ,'Add_training_parameters_to_URL__c' => 'training-params-url'
        ,DESCRIPTION_C => description
        ,'Description_RTA__c' => 'description-rta'
        ,'Enable_Image_Upload__c' => 'enable-image-upload'
        ,'Disable_Undo__c' => 'disable-undo'
        ,'Disable_Comments__c' => 'disable-comments'
    };

    Map<String,String> resourceMappings = new Map<String,String>{
        'Name' => 'name'
        ,'Resource_URL__c' => 'resource-url'
        ,'Add_training_parameters_to_URL__c' => 'training-params-url'
        ,DESCRIPTION_C => description
        ,'Display_in_Iframe__c' => 'display-in-iframe'
    };

    Map<String,String> answerSequenceMappings = new Map<String,String>{
        ORDER_C => Order
        ,'Answer_Text__c' => 'answer-text'
        ,'Item_Id__c' => 'answer-id'
        ,'Is_Correct_Answer__c' => 'is-correct-answer'
    };

    Map<String,String> achievementMappings = new Map<String,String>{
        'Name' => 'name'
        ,'Type__c' => Type
        ,'Acquired_Image__c' => 'acquired-image'
        ,'Eligible_Image__c' => 'eligible-image'
        ,'Hidden__c' => 'hidden'
        ,'Is_Internal__c' => 'is-internal'
        ,'Override_Completed_Status__c' => 'override-completed-status'
        ,'Override_URL__c' => 'override-url'
        ,'Work_Badge_Message__c' => 'work-badge-message'
        ,'$DATE_Expiration_Date__c' => 'expiration-date'
    };

    Map<String,String> trainingPlanMappings = new Map<String,String>{
        'Name' => 'name'
        ,DESCRIPTION_C => description
        ,'Status__c' => 'status'
        ,'Intro_Video_URL__c' => 'intro-video-url'
        ,'Background_Image_URL__c' => 'background-image-url'
        ,'Background_Color__c' => 'background-color'
        ,'Text_Color__c' => 'text-color'
        ,'Enforce_Sequence__c' => 'enforce-sequence'
        ,'Enable_Self_Registration__c' => 'enable-self-registration'
        ,'Self_Registration_Access__c' => 'self-registration-access'
        ,'Hide_Chatter_Photos__c' => 'hide-chatter-photos'
        ,'Optional_Feedback_Comments__c' => 'optional-feedback-comments'
        ,'Custom_Notification_Message__c' => 'custom-notification-message'
        ,'Hide_After_End_Date__c' => 'hide-after-end-date'
        ,'$DATE_Start_Date__c' => 'start-date'
        ,'$DATE_End_Date__c' => 'end-date'
        ,'$DATE_New_Until__c' => 'end-date'
    };

    Map<String,String> trainingTrackMappings = new Map<String,String>{
        'Name' => 'name'
        ,DESCRIPTION_C => description
        ,'Status__c' => 'status'
        ,'Background_Color__c' => 'background-color'
        ,'Background_Image_URL__c' => 'background-image-url'
        ,'Text_Color__c' => 'text-color'
        ,ORDER_C => Order
        ,'Enable_all_external_accounts__c' => 'enable-all-external-accounts'
        ,'$DATE_New_Until__c' => 'new-until'
    };

    Map<String,String> trainingTrackLevelMappings = new Map<String,String>{
        'Name' => 'name'
        ,DESCRIPTION_C => description
        ,ORDER_C => Order
    };

    Map<String,String> trainingTrackLevelItemMappings = new Map<String,String>{
        ORDER_C => Order
    };

    Map<String,String> trainingPlanSectionMappings = new Map<String,String>{
        'Name' => 'name'
        ,ORDER_C => Order
        ,'Optional__c' => 'optional'
    };

    Map<String,String> trainingPlanSectionItemMappings = new Map<String,String>{
        ORDER_C => Order,
        'Optional__c' => 'optional'
    };

    Map<String,String> trainingPlanAchievementMappings = new Map<String,String>{
        'Main_Achievement__c' => 'main-achievement'
    };

    Map<String,String> categoryMappings = new Map<String,String>{
        'Name' => 'name'
        ,'Background_Image_URL__c' => 'background-image-url'
        ,'Logo__c' => 'logo'
        ,'Text_Color__c' => 'text-color'
        ,'Hide_From_Catalog_Home__c' => 'hide-from-catalog-home'
        ,ORDER_C => Order
        ,'Is_Internal__c' => 'is-internal'
    };

    Map<String,String> trainingPlanCategoryMappings = new Map<String,String>{
        ORDER_C => Order
    };

    Map<String,String> learningRTFieldMappings = new Map<String,String>{
        'Quiz' => 'Quiz__c'
        ,'Resource' => 'Training_Resource__c'
        ,'Task' => 'Task__c'
    };

    public static String trainingTrackToJSON(Id trainingTrackId, Boolean serializePretty){
        try{
            PBS_LMSExport_CC exprt = new PBS_LMSExport_CC();
            Map<String,Object> exportResults = new Map<String,Object>();

            Map<String,Object> ttrackExportResults = exprt.exportTrainingTrack(trainingTrackId);
            exportResults.putAll(ttrackExportResults);

            //Get associated training plan ids
            Set<Id> tplanIds = new Set<Id>();
            for(PBS_Training_Track_Level_Item__c ttitem : [select id
                                                            ,Training_Plan__c
                                                            from PBS_Training_Track_Level_Item__c
                                                            where Training_Track_Level__r.Training_Track__c = :trainingTrackId]){
                tplanIds.add(ttitem.Training_Plan__c);
            }
            tplanIds.remove(null); //Remove any null items

            Map<String,Object> tplanExportResults = exprt.exportTrainingPlans(tplanIds);
            if(tplanExportResults != null){
                exportResults.putAll(tplanExportResults);
            }

            if(serializePretty){
                return JSON.serializePretty(exportResults);
            }
            return JSON.serialize(exportResults);
        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'LMSExport');
            return null;
        }
    }

    public static String trainingPlanToJSON(Id trainingPlanId, Boolean serializePretty){
        try{
            PBS_LMSExport_CC exprt = new PBS_LMSExport_CC();
            Map<String,Object> exportResults = exprt.exportTrainingPlans(new Set<Id>{trainingPlanId});
            if(serializePretty){
                return JSON.serializePretty(exportResults);
            }
            return JSON.serialize(exportResults);
        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'LMSExport');
            return null;
        }
    }

    public class LMSExportException extends Exception{}

    public PBS_LMSExport_CC(){
        this.wsops = new PBS_LMSExport_Helper.WithoutSharingOps();
        this.learningsMap = new Map<Id,PBS_Learning__c>();
        this.achievementsMap = new Map<Id,PBS_Achievement__c>();
        this.categoriesMap = new Map<Id,PBS_Learning_Category__c>();
        this.answerSequenceItemIds = new Set<Id>();
        this.achievementCategoryIds = new Set<Id>();
        this.learningIdsByType = new Map<String,List<Id>>();
        this.learningCategoryIds = new Set<Id>();
        this.trackAchievementIds = new Set<Id>();
    }

    public Map<String, Object> exportTrainingTrack(Id trainingTrackId){
         PBS_LMSExport_Helper exportHelper = new PBS_LMSExport_Helper();
        Map<String, Object> tTrackExportResults = new Map<String, Object>();
        this.trainingTrackIds = exportHelper.filterRecordsWithoutEditAccess(new Set<Id>{trainingTrackId});

        if(this.trainingTrackIds == null || this.trainingTrackIds.size() == 0){
            return tTrackExportResults;
        }

        exportHelper.checkTracksCRUDFLS();

        List<Object> trackObjects = exportHelper.buildTrackObjects(trainingTrackIds,trainingTrackMappings,trainingTrackLevelMappings,trainingTrackLevelItemMappings,trackAchievementIds);

        tTrackExportResults.put('track-objects',trackObjects);
        return tTrackExportResults;
    }

    public Map<String, Object> exportTrainingPlans(Set<Id> trainingPlanIds){
        PBS_LMSExport_Helper exportHelper = new PBS_LMSExport_Helper();
        Map<String, Object> tPlanExportResults = new Map<String, Object>();
        this.trainingPlanIds = exportHelper.filterRecordsWithoutEditAccess(trainingPlanIds);

        if(this.trainingPlanIds == null || this.trainingPlanIds.size() == 0){
            return tPlanExportResults;
        }

        exportHelper.checkPlansCRUDFLS();

        List<Object> learningObjects = buildLearningObjects();
        List<Object> achievementObjects = exportHelper.buildAchievementObjects(trainingPlanIds,trackAchievementIds,achievementMappings,achievementsMap,achievementCategoryIds);
        List<Object> planObjects = buildPlanObjects();
        List<Object> lookupObjects = buildLookupObjects();
        tPlanExportResults.put('learning-objects',learningObjects);
        tPlanExportResults.put('lookup-objects',lookupObjects);
        tPlanExportResults.put('achievement-objects',achievementObjects);
        tPlanExportResults.put('plan-objects',planObjects);
        return tPlanExportResults;
    }

   private List<Object> buildLearningObjects(){
    PBS_LMSExport_Helper exportHelper = new PBS_LMSExport_Helper();
        Set<Id> learningIds = exportHelper.getLearningIds(trainingPlanIds);
        List<Object> results = new List<Object>();

        List<PBS_Learning__c> learnings = wsops.getLearningObjects(learningIds);
        for(PBS_Learning__c l : learnings){
            learningsMap.put(l.Id,l);
            if(l.Current_Published_Version__c != null){
                String contentFieldName = learningRTFieldMappings.get(l.RecordType.DeveloperName);
                if(contentFieldName == null){
                    continue;
                }
                PBS_Learning_Version__c lv = (PBS_Learning_Version__c)l.getSObject('Current_Published_Version__r');
                if(!learningIdsByType.containsKey(l.RecordType.DeveloperName)){
                    learningIdsByType.put(l.RecordType.DeveloperName, new List<Id>());
                }
                learningIdsByType.get(l.RecordType.DeveloperName).add((Id)lv.get(contentFieldName));
            }
        }
        results.addAll(buildQuizLearningsContent());
        results.addAll(buildTaskLearningsContent());
        results.addAll(buildResourceLearningsContent());
        return results;
    }

    private List<Object> buildResourceLearningsContent(){
        PBS_LMSExport_Helper exportHelper =  new PBS_LMSExport_Helper();
        List<Object> result = new List<Object>();
        List<Id> resourceLearningIds = learningIdsByType.get('Resource');

        if(resourceLearningIds == null || resourceLearningIds.size() == 0){
            return result;
        }

        Map<Id,PBS_Training_Resource__c> resourcesMap = new Map<Id,PBS_Training_Resource__c>();

        //Fetch Resource Info
        List<PBS_Training_Resource__c> trainingResources = wsops.getResourceObjects(resourceLearningIds);
        for(PBS_Training_Resource__c tr : trainingResources){
            resourcesMap.put(tr.Id,tr);
        }

        for(PBS_Training_Resource__c tr : resourcesMap.values()){
            Map<String,Object> learningObject = exportHelper.initLearningObject(learningsMap.get(tr.Learning__c),learningMappings);
            Map<String,Object> resourceObject = exportHelper.mapSObject(tr,resourceMappings);
            learningObject.put(content, resourceObject);
            result.add(learningObject);
        }

        return result;
    }

    private List<Object> buildTaskLearningsContent(){
        PBS_LMSExport_Helper exportHelper =  new PBS_LMSExport_Helper();
        List<Object> result = new List<Object>();
        List<Id> taskLearningIds = learningIdsByType.get('Task');
        if(taskLearningIds == null || taskLearningIds.size() == 0){
            return result;
        }

        Map<Id,PBS_Task__c> tasksMap = new Map<Id,PBS_Task__c>();

        //Fetch Task Info
        List<PBS_Task__c> tasks = wsops.getTaskObjects(taskLearningIds);
        for(PBS_Task__c t : tasks){
            tasksMap.put(t.Id,t);
        }

        for(PBS_Task__c t : tasksMap.values()){
            Map<String,Object> learningObject = exportHelper.initLearningObject(learningsMap.get(t.Learning__c),learningMappings);
            Map<String,Object> taskObject = exportHelper.mapSObject(t,taskMappings);
            learningObject.put(content, taskObject);
            result.add(learningObject);
        }

        return result;

    }

    private List<Object> buildQuizLearningsContent(){
         PBS_LMSExport_Helper exportHelper =  new PBS_LMSExport_Helper();
        List<Object> result = new List<Object>();
        List<Id> quizLearningIds = learningIdsByType.get('Quiz');
        Map<Id, List<Id>> questionLinesForQuiz = new Map<Id, List<Id>>();
        Map<Id, PBS_Question_Line__c> questionLinemap = new Map<Id, PBS_Question_Line__c>();
        Map<Id, List<Id>> questionsForQuestionLine = new Map<Id, List<Id>>();
        Map<Id, PBS_Question__c> questionMap = new Map<Id, PBS_Question__c>();

        if(quizLearningIds == null || quizLearningIds.size() == 0){
            return result;
        }

        Map<Id,PBS_Quiz__c> quizzesMap = new Map<Id,PBS_Quiz__c>();

        //Fetch Quiz Info
        List<PBS_Quiz__c> quizzes = wsops.getQuizObjects(quizLearningIds);
        for(PBS_Quiz__c q : quizzes){
            quizzesMap.put(q.Id,q);
        }

        //Fetch Question Lines
        List<PBS_Question_Line__c> questionLines = wsops.getQuestionLineObjects(quizzesMap.keySet());
        for(PBS_Question_Line__c ql : questionLines){
            questionLinemap.put(ql.Id,ql);
            if(!questionLinesForQuiz.containsKey(ql.Quiz__c)){
                questionLinesForQuiz.put(ql.Quiz__c, new List<Id>());
            }
            questionLinesForQuiz.get(ql.Quiz__c).add(ql.Id);
        }

        //Fetch Questions
        List<PBS_Question__c> questions = wsops.getQuestionObjects(questionLinemap.keySet());
        for(PBS_Question__c q : questions){
            questionMap.put(q.Id,q);
            if(q.Answer_Sequence__c != null){
                answerSequenceItemIds.add(q.Answer_Sequence__c);
            }
            if(!questionsForQuestionLine.containsKey(q.Question_Line__c)){
                questionsForQuestionLine.put(q.Question_Line__c, new List<Id>());
            }
            questionsForQuestionLine.get(q.Question_Line__c).add(q.Id);
        }

        for(PBS_Quiz__c q : quizzesMap.values()){
            Map<String,Object> learningObject = exportHelper.initLearningObject(learningsMap.get(q.Learning__c),learningMappings);
            Map<String,Object> quizObject = exportHelper.mapSObject(q, quizMappings);

            List<Object> questionLineObjects = new List<Object>();

            List<Id> questionLineIds = questionLinesForQuiz.get(q.Id);

            if(questionLineIds == null){
                learningObject.put(content, quizObject);
                continue;
            }

            for(Id qlId : questionLineIds){
                PBS_Question_Line__c ql = questionLinemap.get(qlId);
                Map<String,Object> questionLineObject = exportHelper.mapSObject(ql, questionLineMappings);
                questionLineObjects.add(questionLineObject);

                List<Object> questionLineQuestions = new List<Object>();

                List<Id> questionForQLineIds = questionsForQuestionLine.get(ql.Id);

                if(questionForQLineIds == null){
                    continue;
                }

                for(Id qsId : questionForQLineIds){
                    PBS_Question__c qs = questionMap.get(qsId);
                    Map<String,Object> questionObject = exportHelper.mapSObject(qs, questionMappings);
                    questionObject.put('answer-sequence',qs.Answer_Sequence__c);
                    questionLineQuestions.add(questionObject);
                }
                questionLineObject.put('questions', questionLineQuestions);
            }

            quizObject.put('question-lines',questionLineObjects);
            learningObject.put(content, quizObject);
            result.add(learningObject);
        }

        return result;

    }

    private List<Object> buildLookupObjects(){
    PBS_LMSExport_Helper exportHelper = new PBS_LMSExport_Helper();
        List<Object> results = new List<Object>();
        results.addAll(exportHelper.buildAnswerSequenceLookups(answerSequenceItemIds,answerSequenceMappings,wsops));
        results.addAll(exportHelper.buildAchievementCategoryLookups(achievementCategoryIds));
        results.addAll(exportHelper.buildCategoryLookups(learningCategoryIds,categoryMappings));
        return results;
    }

    private List<Object> buildPlanObjects(){
        PBS_LMSExport_Helper exportHelper = new PBS_LMSExport_Helper();
        List<Object> results = new List<Object>();

        Map<Id, PBS_Training_Plan__c> trainingPlansMap = new Map<Id, PBS_Training_Plan__c>();
        Map<Id, PBS_Training_Plan_Section__c> trainingSectionsMap = new Map<Id, PBS_Training_Plan_Section__c>();
        Map<Id, List<Id>> sectionsForTrainingPlan = new Map<Id, List<Id>>();
        Map<Id, PBS_Training_Plan_Section_Item__c> trainingSectionItemsMap = new Map<Id, PBS_Training_Plan_Section_Item__c>();
        Map<Id, List<Id>> itemsForTrainingPlanSection = new Map<Id, List<Id>>();
        Map<Id, PBS_Training_Plan_Achievement__c> trainingPlanAchievementsMap = new Map<Id, PBS_Training_Plan_Achievement__c>();
        Map<Id, List<Id>> achievementsForTrainingPlan = new Map<Id, List<Id>>();
        Map<Id, PBS_Training_Plan_Category__c> trainingPlanCategoriesMap = new Map<Id, PBS_Training_Plan_Category__c>();
        Map<Id, List<Id>> categoriesForTrainingPlan = new Map<Id, List<Id>>();

        //Fetch training plans
        for(PBS_Training_Plan__c tp : [select Id
                                        ,Name
                                        ,Description__c
                                        ,Status__c
                                        ,Intro_Video_URL__c
                                        ,Background_Image_URL__c
                                        ,Background_Color__c
                                        ,Text_Color__c
                                        ,Enforce_Sequence__c
                                        ,Enable_Self_Registration__c
                                        ,Self_Registration_Access__c
                                        ,Hide_Chatter_Photos__c
                                        ,Optional_Feedback_Comments__c
                                        ,Custom_Notification_Message__c
                                        ,Hide_After_End_Date__c
                                        ,Start_Date__c
                                        ,End_Date__c
                                        ,New_Until__c
                                        from PBS_Training_Plan__c
                                        where id in :trainingPlanIds]){
            trainingPlansMap.put(tp.Id, tp);
        }

        //Fetch training plan achievements
        for(PBS_Training_Plan_Achievement__c tpa : [select Id
                                        ,Name
                                        ,Achievement__c
                                        ,Achievement__r.Name
                                        ,Main_Achievement__c
                                        ,Training_Plan_Section__c
                                        ,Training_Plan_Section__r.Name
                                        ,Training_Plan__c
                                        ,Type__c
                                        from PBS_Training_Plan_Achievement__c
                                        where Training_Plan__c in :trainingPlanIds]){
            if(tpa.Achievement__c != null){
                trainingPlanAchievementsMap.put(tpa.Id, tpa);
                if(!achievementsForTrainingPlan.containsKey(tpa.Training_Plan__c)){
                    achievementsForTrainingPlan.put(tpa.Training_Plan__c, new List<Id>());
                }
                achievementsForTrainingPlan.get(tpa.Training_Plan__c).add(tpa.Id);
            }
        }

        //Fetch training plan categories
        for(PBS_Training_Plan_Category__c tpc : [select Id
                                        ,Name
                                        ,Order__c
                                        ,Learning_Category__c
                                        ,Learning_Category__r.Name
                                        ,Training_Plan__c
                                        from PBS_Training_Plan_Category__c
                                        where Training_Plan__c in :trainingPlanIds]){
            if(tpc.Learning_Category__c != null){
                learningCategoryIds.add(tpc.Learning_Category__c);
                trainingPlanCategoriesMap.put(tpc.Id, tpc);
                if(!categoriesForTrainingPlan.containsKey(tpc.Training_Plan__c)){
                    categoriesForTrainingPlan.put(tpc.Training_Plan__c, new List<Id>());
                }
                categoriesForTrainingPlan.get(tpc.Training_Plan__c).add(tpc.Id);
            }
        }

        //Fetch training plan sections
        for(PBS_Training_Plan_Section__c tps : [select Id
                                                    ,Name
                                                    ,Order__c
                                                    ,Optional__c
                                                    ,Training_Plan__c
                                                    from PBS_Training_Plan_Section__c
                                                    where Training_Plan__c in :trainingPlanIds]){
            trainingSectionsMap.put(tps.Id, tps);
            if(!sectionsForTrainingPlan.containsKey(tps.Training_Plan__c)){
                sectionsForTrainingPlan.put(tps.Training_Plan__c, new List<Id>());
            }
            sectionsForTrainingPlan.get(tps.Training_Plan__c).add(tps.Id);
        }

        //Fetch training plan section items
        for(PBS_Training_Plan_Section_Item__c tpsi : [select Id
                                                    ,Order__c
                                                    ,Learning__c
                                                    ,Training_Plan_Section__c
                                                    ,Optional__c
                                                    from PBS_Training_Plan_Section_Item__c
                                                    where Training_Plan_Section__c in :trainingSectionsMap.keySet()]){
            trainingSectionItemsMap.put(tpsi.Id, tpsi);
            if(!itemsForTrainingPlanSection.containsKey(tpsi.Training_Plan_Section__c)){
                itemsForTrainingPlanSection.put(tpsi.Training_Plan_Section__c, new List<Id>());
            }
            itemsForTrainingPlanSection.get(tpsi.Training_Plan_Section__c).add(tpsi.Id);
        }

        for(PBS_Training_Plan__c tp : trainingPlansMap.values()){
            Map<String,Object> planObject = exportHelper.mapSObject(tp, trainingPlanMappings);

            List<Object> tplanSectionObjects = new List<Object>();
            List<Id> tpsIds = sectionsForTrainingPlan.get(tp.Id);

            if(tpsIds == null){
                results.add(planObject);
                continue;
            }

            for(Id tpsId : tpsIds){
                PBS_Training_Plan_Section__c tps = trainingSectionsMap.get(tpsId);
                Map<String,Object> sectionObject = exportHelper.mapSObject(tps, trainingPlanSectionMappings);
                List<Object> tplanSectionItemObjects = new List<Object>();
                List<Id> tpsiIds = itemsForTrainingPlanSection.get(tps.Id);

                if(tpsiIds != null){
                    for(Id tpsiId : tpsiIds){
                        PBS_Training_Plan_Section_Item__c tpsi = trainingSectionItemsMap.get(tpsiId);
                        Map<String,Object> sectionItemObject = exportHelper.mapSObject(tpsi, trainingPlanSectionItemMappings);
                        PBS_Learning__c learning = learningsMap.get(tpsi.Learning__c);
                        if(learning == null){
                            continue;
                        }
                        sectionItemObject.put('learning', learning.Name);
                        tplanSectionItemObjects.add(sectionItemObject);
                    }
                    sectionObject.put('items',tplanSectionItemObjects);
                }
                tplanSectionObjects.add(sectionObject);
            }

            List<Object> tplanAchievementObjects = new List<Object>();
            List<Id> achTPlanIds = achievementsForTrainingPlan.get(tp.Id);

            if(achTPlanIds != null){
                for(Id tpaId : achTPlanIds){
                    PBS_Training_Plan_Achievement__c tpa = trainingPlanAchievementsMap.get(tpaId);
                    if(tpa.Achievement__c == null){
                        continue;
                    }
                    Map<String,Object> tPlanAchievementObject = exportHelper.mapSObject(tpa, trainingPlanAchievementMappings);
                    tPlanAchievementObject.put('achievement',tpa.Achievement__r.Name);
                    if(tpa.Training_Plan_Section__c != null){
                        tPlanAchievementObject.put('section',tpa.Training_Plan_Section__r.Name);
                    }
                    tplanAchievementObjects.add(tPlanAchievementObject);
                }
            }

            List<Object> tplanCategoryObjects = new List<Object>();
            List<Id> categoryTPlanIds = categoriesForTrainingPlan.get(tp.Id);

            if(categoryTPlanIds != null){
                for(Id tpcId : categoryTPlanIds){
                    PBS_Training_Plan_Category__c tpc = trainingPlanCategoriesMap.get(tpcId);
                    if(tpc.Learning_Category__c == null){
                        continue;
                    }
                    Map<String,Object> tPlanCategoryObject = exportHelper.mapSObject(tpc, trainingPlanCategoryMappings);
                    tPlanCategoryObject.put('category',tpc.Learning_Category__r.Name);
                    tplanCategoryObjects.add(tPlanCategoryObject);
                }
            }

            planObject.put('sections', tplanSectionObjects);
            planObject.put('achievements', tplanAchievementObjects);
            planObject.put('categories', tplanCategoryObjects);
            results.add(planObject);
        }

        return results;
    }

   
    
    //Without sharing operations
  
}