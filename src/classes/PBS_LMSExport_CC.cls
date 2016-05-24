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
    private PBS_LMSExport_CC.WithoutSharingOps wsops;
    
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
        this.wsops = new PBS_LMSExport_CC.WithoutSharingOps();
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

        Map<String, Object> tTrackExportResults = new Map<String, Object>();
        this.trainingTrackIds = filterRecordsWithoutEditAccess(new Set<Id>{trainingTrackId});

        if(this.trainingTrackIds == null || this.trainingTrackIds.size() == 0){
            return tTrackExportResults;
        }

        checkTracksCRUDFLS();

        List<Object> trackObjects = buildTrackObjects();

        tTrackExportResults.put('track-objects',trackObjects);
        return tTrackExportResults;
    }

    public Map<String, Object> exportTrainingPlans(Set<Id> trainingPlanIds){

        Map<String, Object> tPlanExportResults = new Map<String, Object>();
        this.trainingPlanIds = filterRecordsWithoutEditAccess(trainingPlanIds);

        if(this.trainingPlanIds == null || this.trainingPlanIds.size() == 0){
            return tPlanExportResults;
        }

        checkPlansCRUDFLS();

        List<Object> learningObjects = buildLearningObjects();
        List<Object> achievementObjects = buildAchievementObjects();
        List<Object> planObjects = buildPlanObjects();
        List<Object> lookupObjects = buildLookupObjects();

        tPlanExportResults.put('learning-objects',learningObjects);
        tPlanExportResults.put('lookup-objects',lookupObjects);
        tPlanExportResults.put('achievement-objects',achievementObjects);
        tPlanExportResults.put('plan-objects',planObjects);
        return tPlanExportResults;
    }

    private void checkTracksCRUDFLS(){
        //BEGIN Access Check
        Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
        relatedFieldsObjects.put(PBS_Training_Track__c.sObjectType,new List<String>{'Name'});
        PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjects);
        //END Access Check
    }

    private void checkPlansCRUDFLS(){
        //BEGIN Access Check
        Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
        relatedFieldsObjects.put(PBS_Learning__c.sObjectType,new List<String>{'Name'});
        relatedFieldsObjects.put(PBS_Training_Resource__c.sObjectType,new List<String>{'Name'});
        relatedFieldsObjects.put(PBS_Task__c.sObjectType,new List<String>{'Name'});
        relatedFieldsObjects.put(PBS_Quiz__c.sObjectType,new List<String>{'Name'});
        relatedFieldsObjects.put(PBS_Achievement__c.sObjectType,new List<String>{'Name'});
        relatedFieldsObjects.put(PBS_Training_Plan__c.sObjectType,new List<String>{'Name'});
        relatedFieldsObjects.put(PBS_Training_Plan_Section__c.sObjectType,new List<String>{'Name','Training_Plan__c'});
        relatedFieldsObjects.put(PBS_Training_Plan_Section_Item__c.sObjectType,new List<String>{'Training_Plan_Section__c'});
        relatedFieldsObjects.put(PBS_Training_Plan_Achievement__c.sObjectType,new List<String>{'Training_Plan__c'});
        relatedFieldsObjects.put(PBS_Training_Track__c.sObjectType,new List<String>{'Name'});
        relatedFieldsObjects.put(PBS_Training_Track_Level__c.sObjectType,new List<String>{'Name','Training_Track__c'});
        PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjects);
        //END Access Check
    }

    private Set<Id> filterRecordsWithoutEditAccess(Set<Id> recordIds){
        Set<Id> result = new Set<Id>();
        for(UserRecordAccess ura : [select HasEditAccess
                                          ,RecordId
                                          from UserRecordAccess
                                          where RecordId in :recordIds and UserId = :UserInfo.getUserId()]){
            if(ura.HasEditAccess){
                result.add(ura.RecordId);
            }
        }
        return result;
    }
    private Set<Id> getLearningIds(){
        Set<Id> learningIds = new Set<Id>();
        for(PBS_Training_Plan_Section_Item__c tpi : [select Id
                                                        ,Learning__c
                                                        from PBS_Training_Plan_Section_Item__c
                                                        where Training_Plan_Section__r.Training_Plan__c in :trainingPlanIds]){
            if(tpi.Learning__c != null){
                learningIds.add(tpi.Learning__c);
            }
        }
        return learningIds;
    }

    private Set<Id> getAchievementIds(){
        Set<Id> achievementIds = new Set<Id>();
        for(PBS_Training_Plan_Achievement__c tpa : [select Id
                                                        ,Achievement__c
                                                        from PBS_Training_Plan_Achievement__c
                                                        where Training_Plan__c in :trainingPlanIds]){
            if(tpa.Achievement__c != null){
                achievementIds.add(tpa.Achievement__c);
            }
        }

        if(trackAchievementIds.size()>0){
            achievementIds.addAll(trackAchievementIds);
        }
        return achievementIds;
    }

    private List<Object> buildAchievementObjects(){
        Set<Id> achievementIds = getAchievementIds();
        List<Object> results = new List<Object>();
        for(PBS_Achievement__c a : [select Id
                                    ,Name
                                    ,Achievement_Category__c
                                    ,Achievement_Category__r.Name
                                    ,Acquired_Image__c
                                    ,Eligible_Image__c
                                    ,Expiration_Date__c
                                    ,Override_Completed_Status__c
                                    ,Override_URL__c
                                    ,Type__c
                                    ,Work_Badge_Message__c
                                    ,Hidden__c
                                    ,Is_Internal__c
                                    from PBS_Achievement__c where id in :achievementIds]){
            achievementsMap.put(a.Id, a);
        }

        for(PBS_Achievement__c a : achievementsMap.values()){
            Map<String,Object> achievementObject = mapSObject(a, achievementMappings);
            if(a.Achievement_Category__c != null){
                achievementCategoryIds.add(a.Achievement_Category__c);
                achievementObject.put('achievement-category', a.Achievement_Category__r.Name);
            }
            results.add(achievementObject);
        }

        return results;
    }

    private List<Object> buildLearningObjects(){
        Set<Id> learningIds = getLearningIds();
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
            Map<String,Object> learningObject = initLearningObject(learningsMap.get(tr.Learning__c));
            Map<String,Object> resourceObject = mapSObject(tr,resourceMappings);
            learningObject.put(content, resourceObject);
            result.add(learningObject);
        }

        return result;
    }

    private List<Object> buildTaskLearningsContent(){

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
            Map<String,Object> learningObject = initLearningObject(learningsMap.get(t.Learning__c));
            Map<String,Object> taskObject = mapSObject(t,taskMappings);
            learningObject.put(content, taskObject);
            result.add(learningObject);
        }

        return result;

    }

    private List<Object> buildQuizLearningsContent(){

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
            Map<String,Object> learningObject = initLearningObject(learningsMap.get(q.Learning__c));
            Map<String,Object> quizObject = mapSObject(q, quizMappings);

            List<Object> questionLineObjects = new List<Object>();

            List<Id> questionLineIds = questionLinesForQuiz.get(q.Id);

            if(questionLineIds == null){
                learningObject.put(content, quizObject);
                continue;
            }

            for(Id qlId : questionLineIds){
                PBS_Question_Line__c ql = questionLinemap.get(qlId);
                Map<String,Object> questionLineObject = mapSObject(ql, questionLineMappings);
                questionLineObjects.add(questionLineObject);

                List<Object> questionLineQuestions = new List<Object>();

                List<Id> questionForQLineIds = questionsForQuestionLine.get(ql.Id);

                if(questionForQLineIds == null){
                    continue;
                }

                for(Id qsId : questionForQLineIds){
                    PBS_Question__c qs = questionMap.get(qsId);
                    Map<String,Object> questionObject = mapSObject(qs, questionMappings);
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

    private Map<String,Object> initLearningObject(PBS_Learning__c l){
        // Add lookup information
        Map<String,Object> result = mapSObject(l, learningMappings);
        result.put('record-type', l.RecordType.DeveloperName);
        return result;
    }

    private List<Object> buildLookupObjects(){
        List<Object> results = new List<Object>();
        results.addAll(buildAnswerSequenceLookups());
        results.addAll(buildAchievementCategoryLookups());
        results.addAll(buildCategoryLookups());
        return results;
    }

    private List<Object> buildAchievementCategoryLookups(){
        List<Object> results = new List<Object>();

        if(achievementCategoryIds.size() == 0){
            return results;
        }

        for(PBS_Achievement_Category__c ac : [select Id
                                            ,Name
                                            from PBS_Achievement_Category__c
                                            where id in :achievementCategoryIds]){
            Map<String,Object> acObject = new Map<String,Object>();
            acObject.put(Type,'achievement-category');
            acObject.put('name', ac.Name);
            acObject.put(content,new Map<String,Object>());
            results.add(acObject);
        }

        return results;
    }

    private List<Object> buildAnswerSequenceLookups(){
        List<Object> results = new List<Object>();

        if(answerSequenceItemIds.size() == 0){
            return results;
        }

        Map<Id,PBS_Answer_Sequence__c> answerSequenceMap = new Map<Id,PBS_Answer_Sequence__c>();
        Map<Id,PBS_Answer_Sequence_Item__c> answerSequenceItemMap = new Map<Id,PBS_Answer_Sequence_Item__c>();
        Map<Id, List<Id>> itemsForAnswerSequence = new Map<Id, List<Id>>();

        List<PBS_Answer_Sequence__c> answerSequences = wsops.getAnswerSequenceObjects(answerSequenceItemIds);
        for(PBS_Answer_Sequence__c aseq : answerSequences){
            answerSequenceMap.put(aseq.Id, aseq);
        }

        List<PBS_Answer_Sequence_Item__c> answerSequenceItems = wsops.getAnswerSequenceItemObjects(answerSequenceMap.keySet());
        for(PBS_Answer_Sequence_Item__c asi : answerSequenceItems){
            answerSequenceItemMap.put(asi.Id, asi);
            if(!itemsForAnswerSequence.containsKey(asi.Answer_Sequence__c)){
                itemsForAnswerSequence.put(asi.Answer_Sequence__c, new List<Id>());
            }
            itemsForAnswerSequence.get(asi.Answer_Sequence__c).add(asi.Id);
        }

        for(PBS_Answer_Sequence__c aseq : answerSequenceMap.values()){
            Map<String,Object> asObject = new Map<String,Object>();
            asObject.put(Type,'answer-sequence');
            asObject.put('name', aseq.Id);

            Map<String,Object> asOptions = new Map<String,Object>();
            List<Object> asItems = new List<Object>();

            List<Id> asIds = itemsForAnswerSequence.get(aseq.Id);

            if(asIds == null){
                continue;
            }

            for(Id asId : asIds){
                PBS_Answer_Sequence_Item__c asi = answerSequenceItemMap.get(asId);
                asItems.add(mapSObject(asi, answerSequenceMappings));
            }
            asOptions.put('options',asItems);
            asObject.put(content,asOptions);
            results.add(asObject);
        }

        return results;
    }

    private List<Object> buildCategoryLookups(){
        List<Object> results = new List<Object>();
        if(learningCategoryIds == null || learningCategoryIds.size() == 0){
            return results;
        }
        for(PBS_Learning_Category__c lc : [select Id
                                            ,Name
                                            ,Background_Image_URL__c
                                            ,Logo__c
                                            ,Text_Color__C
                                            ,Hide_From_Catalog_Home__c
                                            ,Is_Internal__c
                                            ,Order__c
                                            from PBS_Learning_Category__c where id in :learningCategoryIds]){

            Map<String,Object> learningCategoryObject = mapSObject(lc, categoryMappings);
            learningCategoryObject.put(Type,'learning-category');
            results.add(learningCategoryObject);
        }

        return results;
    }

    private List<Object> buildTrackObjects(){
        List<Object> results = new List<Object>();
        Map<Id, PBS_Training_Track__c> trainingTracksMap = new Map<Id, PBS_Training_Track__c>();
        Map<Id, PBS_Training_Track_Level__c> trackLevelsMap = new Map<Id, PBS_Training_Track_Level__c>();
        Map<Id, List<Id>> levelsForTrainingTrack = new Map<Id, List<Id>>();
        Map<Id, PBS_Training_Track_Level_Item__c> trackLevelItemsMap = new Map<Id, PBS_Training_Track_Level_Item__c>();
        Map<Id, List<Id>> itemsForTrackLevel = new Map<Id, List<Id>>();

        //Fetch training tracks
        for(PBS_Training_Track__c tt : [select Id
                                        ,Name
                                        ,Description__c
                                        ,Status__c
                                        ,Background_Color__c
                                        ,Background_Image_URL__c
                                        ,Text_Color__c
                                        ,Order__c
                                        ,Enable_all_external_accounts__c
                                        ,New_Until__c
                                        ,Achievement__c
                                        ,Achievement__r.Name
                                        from PBS_Training_Track__c
                                        where id in :trainingTrackIds]){
            if(tt.Achievement__c != null){
                trackAchievementIds.add(tt.Achievement__c);
            }
            trainingTracksMap.put(tt.Id, tt);
        }

        //Fetch training track levels
        for(PBS_Training_Track_Level__c ttl : [select Id
                                        ,Name
                                        ,Description__c
                                        ,Order__c
                                        ,Training_Track__c
                                        from PBS_Training_Track_Level__c
                                        where Training_Track__c in :trainingTrackIds]){
            trackLevelsMap.put(ttl.Id, ttl);
            if(!levelsForTrainingTrack.containsKey(ttl.Training_Track__c)){
                levelsForTrainingTrack.put(ttl.Training_Track__c, new List<Id>());
            }
            levelsForTrainingTrack.get(ttl.Training_Track__c).add(ttl.Id);
        }

        //Fetch training track level items
        for(PBS_Training_Track_Level_Item__c ttli : [select Id
                                                    ,Order__c
                                                    ,Training_Track_Level__c
                                                    ,Training_Plan__c
                                                    ,Training_Plan__r.Name
                                                    from PBS_Training_Track_Level_Item__c
                                                    where Training_Track_Level__c in :trackLevelsMap.keySet()]){
            trackLevelItemsMap.put(ttli.Id, ttli);
            if(!itemsForTrackLevel.containsKey(ttli.Training_Track_Level__c)){
                itemsForTrackLevel.put(ttli.Training_Track_Level__c, new List<Id>());
            }
            itemsForTrackLevel.get(ttli.Training_Track_Level__c).add(ttli.Id);
        }

        for(PBS_Training_Track__c tt : trainingTracksMap.values()){
            Map<String,Object> trackObject = mapSObject(tt, trainingTrackMappings);
            trackObject.put('achievement', tt.Achievement__r.Name);

            List<Object> tTrackLevelObjects = new List<Object>();
            List<Id> ttlIds = levelsForTrainingTrack.get(tt.Id);

            if(ttlIds == null){
                results.add(trackObject);
                continue;
            }

            for(Id ttlId : ttlIds){
                PBS_Training_Track_Level__c ttl = trackLevelsMap.get(ttlId);
                Map<String,Object> levelObject = mapSObject(ttl, trainingTrackLevelMappings);

                List<Object> tTrackLevelItemObjects = new List<Object>();
                List<Id> ttliIds = itemsForTrackLevel.get(ttl.Id);

                if(ttliIds != null){
                    for(Id ttliId : ttliIds){
                        PBS_Training_Track_Level_Item__c ttli = trackLevelItemsMap.get(ttliId);
                        if(ttli.Training_Plan__r.Name == null){
                            continue;
                        }
                        Map<String,Object> levelItemObject = mapSObject(ttli, trainingTrackLevelItemMappings);
                        levelItemObject.put('plan', ttli.Training_Plan__r.Name);
                        tTrackLevelItemObjects.add(levelItemObject);
                    }
                    levelObject.put('items',tTrackLevelItemObjects);
                }

                tTrackLevelObjects.add(levelObject);
            }

            trackObject.put('levels', tTrackLevelObjects);
            results.add(trackObject);
        }

        return results;

    }

    private List<Object> buildPlanObjects(){
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
            Map<String,Object> planObject = mapSObject(tp, trainingPlanMappings);

            List<Object> tplanSectionObjects = new List<Object>();
            List<Id> tpsIds = sectionsForTrainingPlan.get(tp.Id);

            if(tpsIds == null){
                results.add(planObject);
                continue;
            }

            for(Id tpsId : tpsIds){
                PBS_Training_Plan_Section__c tps = trainingSectionsMap.get(tpsId);
                Map<String,Object> sectionObject = mapSObject(tps, trainingPlanSectionMappings);
                List<Object> tplanSectionItemObjects = new List<Object>();
                List<Id> tpsiIds = itemsForTrainingPlanSection.get(tps.Id);

                if(tpsiIds != null){
                    for(Id tpsiId : tpsiIds){
                        PBS_Training_Plan_Section_Item__c tpsi = trainingSectionItemsMap.get(tpsiId);
                        Map<String,Object> sectionItemObject = mapSObject(tpsi, trainingPlanSectionItemMappings);
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
                    Map<String,Object> tPlanAchievementObject = mapSObject(tpa, trainingPlanAchievementMappings);
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
                    Map<String,Object> tPlanCategoryObject = mapSObject(tpc, trainingPlanCategoryMappings);
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

    private List<Object> mapSObjects(List<SObject> sobjects, Map<String,String> mappings){
        List<Object> result =  new List<Object>();
        for(Sobject obj : sobjects){
            result.add(mapSObject(obj,mappings));
        }
        return result;
    }

    private Map<String,Object> mapSObject(SObject obj, Map<String,String> mappings){
        Map<String,Object> result =  new Map<String,Object>();
        for(String key : mappings.keySet()){
            if(key.startsWith('$DATE_')){
                String sObjectFieldKey = key.replace('$DATE_','');
                result.put(mappings.get(key), formatDateForExport(obj.get(sObjectFieldKey)));
            }else{
                result.put(mappings.get(key), obj.get(key));
            }
        }
        return result;
    }

    private String formatDateForExport(Object dateObj){
        if(dateObj == null){
            return null;
        }
        Date dt = (Date)dateObj;
        String monthValue = String.valueOf(dt.month());
        monthValue = monthValue.length()==1?'0'+monthValue:monthValue;
        String dayValue = String.valueOf(dt.day());
        dayValue = dayValue.length()==1?'0'+dayValue:dayValue;
        String dateValue = dt.year()+'-'+monthValue+'-'+dayValue;
        return dateValue;
    }

    //Without sharing operations
    private without sharing class WithoutSharingOps{

        public List<PBS_Learning__c> getLearningObjects(Set<Id> learningIds){
            List<PBS_Learning__c> result = [select Id
                                                ,Name
                                                ,RecordType.DeveloperName
                                                ,Duration__c
                                                ,Description__c
                                                ,Sync_progress__c
                                                ,Current_Published_Version__c
                                                ,Current_Published_Version__r.Task__c
                                                ,Current_Published_Version__r.Quiz__c
                                                ,Current_Published_Version__r.Training_Resource__c
                                                from PBS_Learning__c where id in :learningIds];
            return result;
        }

        public List<PBS_Training_Resource__c> getResourceObjects(List<Id> learningIds){
            List<PBS_Training_Resource__c> result = [select Id
                                                        ,Name
                                                        ,Resource_URL__c
                                                        ,Add_training_parameters_to_URL__c
                                                        ,Description__c
                                                        ,Display_in_Iframe__c
                                                        ,Learning__c
                                                        from PBS_Training_Resource__c
                                                        where Id in :learningIds];
            return result;
        }

        public List<PBS_Task__c> getTaskObjects(List<Id> learningIds){
            List<PBS_Task__c> result = [select Id
                                        ,Name
                                        ,External_Resource_Name__c
                                        ,External_Resource_URL__c
                                        ,External_Resource_Target__c
                                        ,Requires_Manager_Approval__c
                                        ,Disable_Undo__c
                                        ,Description_RTA__c
                                        ,Description__c
                                        ,Disable_Comments__c
                                        ,Add_training_parameters_to_URL__c
                                        ,Enable_Image_Upload__c
                                        ,Learning__c
                                        from PBS_Task__c
                                        where Id in :learningIds];
            return result;
        }

        public List<PBS_Quiz__c> getQuizObjects(List<Id> learningIds){
            List<PBS_Quiz__c> result = [select Id
                                        ,Name
                                        ,Passing_Score__c
                                        ,Max_Attempts__c
                                        ,Description__c
                                        ,Learning__c
                                        ,Delete_Responses_On_Submission__c
                                        from PBS_Quiz__c
                                        where Id in :learningIds];
            return result;
        }

        public List<PBS_Question_Line__c> getQuestionLineObjects(Set<Id> quizIds){
            List<PBS_Question_Line__c> result = [select Id
                                                    ,Name
                                                    ,Order__c
                                                    ,Description__c
                                                    ,Quiz__c
                                                    from PBS_Question_Line__c
                                                    where Quiz__c in :quizIds];
            return result;
        }

        public List<PBS_Question__c> getQuestionObjects(Set<Id> questionLineIds){
            List<PBS_Question__c> result = [select Id
                                                ,Name
                                                ,Order__c
                                                ,Description__c
                                                ,Description_RTA__c
                                                ,Type__c
                                                ,Correct_Boolean__c
                                                ,Correct_Number__c
                                                ,Answer_Sequence__c
                                                ,Question_Line__c
                                                from PBS_Question__c
                                                where Question_Line__c in :questionLineIds];
            return result;
        }

        public List<PBS_Answer_Sequence__c> getAnswerSequenceObjects(Set<Id> answerSequenceIds){
            List<PBS_Answer_Sequence__c> result = [select Id
                                                    ,Name
                                                    ,Internal_Notes__c
                                                    from PBS_Answer_Sequence__c
                                                    where Id in : answerSequenceIds];
            return result;
        }

        public List<PBS_Answer_Sequence_Item__c> getAnswerSequenceItemObjects(Set<Id> answerSequenceIds){
            List<PBS_Answer_Sequence_Item__c> result = [select Id
                                                        ,Name
                                                        ,Answer_Text__c
                                                        ,Is_Correct_Answer__c
                                                        ,Item_Id__c
                                                        ,Order__c
                                                        ,Answer_Sequence__c
                                                        from PBS_Answer_Sequence_Item__c
                                                        where Answer_Sequence__c in :answerSequenceIds];
            return result;
        }
    }

}