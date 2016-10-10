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
public  with sharing class PBS_LMSExport_Helper{
    private static final string Type = 'type';
    private static final string content = 'content';
  public void checkTracksCRUDFLS(){
        //BEGIN Access Check
        Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
        relatedFieldsObjects.put(PBS_Training_Track__c.sObjectType,new List<String>{'Name'});
        PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjects);
        //END Access Check
    }
     public void checkPlansCRUDFLS(){
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
    public Set<Id> filterRecordsWithoutEditAccess(Set<Id> recordIds){
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
     public Set<Id> getLearningIds(Set<Id> trainingPlanIds){
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
    public Set<Id> getAchievementIds(Set<Id> trainingPlanIds,Set<Id> trackAchievementIds){
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
     public List<Object> buildAchievementObjects(Set<Id> trainingPlanIds,Set<Id> trackAchievementIds,Map<String,String> achievementMappings,Map<Id,PBS_Achievement__c> achievementsMap,Set<Id> achievementCategoryIds){
        
        Set<Id> achievementIds = getAchievementIds(trainingPlanIds,trackAchievementIds);
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
     public Map<String,Object> mapSObject(SObject obj, Map<String,String> mappings){
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
   
     private List<Object> mapSObjects(List<SObject> sobjects, Map<String,String> mappings){
        List<Object> result =  new List<Object>();
        for(Sobject obj : sobjects){
            result.add(mapSObject(obj,mappings));
        }
        return result;
    }
     public Map<String,Object> initLearningObject(PBS_Learning__c l,Map<String,String> learningMappings){
    
        // Add lookup information
        Map<String,Object> result = mapSObject(l, learningMappings);
        result.put('record-type', l.RecordType.DeveloperName);
        return result;
    }
      public List<Object> buildCategoryLookups(Set<Id> learningCategoryIds,Map<String,String> categoryMappings){
    
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
            learningCategoryObject.put('Type','learning-category');
            results.add(learningCategoryObject);
        }

        return results;
    }
    
    public List<Object> buildAchievementCategoryLookups(Set<Id> achievementCategoryIds){
        List<Object> results = new List<Object>();

        if(achievementCategoryIds.size() == 0){
            return results;
        }

        for(PBS_Achievement_Category__c ac : [select Id
                                            ,Name
                                            from PBS_Achievement_Category__c
                                            where id in :achievementCategoryIds]){
            Map<String,Object> acObject = new Map<String,Object>();
            acObject.put('Type','achievement-category');
            acObject.put('name', ac.Name);
            acObject.put('content',new Map<String,Object>());
            results.add(acObject);
        }

        return results;
    }
    
     public List<Object> buildAnswerSequenceLookups(Set<Id> answerSequenceItemIds,Map<String,String> answerSequenceMappings,PBS_LMSExport_Helper.WithoutSharingOps wsops){
   
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
    public List<Object> buildTrackObjects(Set<Id> trainingTrackIds,Map<String,String> trainingTrackMappings,Map<String,String> trainingTrackLevelMappings,Map<String,String> trainingTrackLevelItemMappings,Set<Id> trackAchievementIds){
    
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
      public without sharing class WithoutSharingOps{

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