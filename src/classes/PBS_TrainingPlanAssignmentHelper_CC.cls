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
public with sharing class PBS_TrainingPlanAssignmentHelper_CC{

    public static void processBeforeUpdate(Map<Id,PBS_Training_Plan_Assignment__c> oldAssignmentsMap,Map<Id,PBS_Training_Plan_Assignment__c> newAssignmentsMap){
        //Only process assignments that have changed
        for(PBS_Training_Plan_Assignment__c tpa : newAssignmentsMap.values()){

            PBS_Training_Plan_Assignment__c oldTPA = oldAssignmentsMap.get(tpa.Id);

            if(oldTPA.Status__c != PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED && tpa.Status__c == PBS_LMSConstants_CC.ASSIGNMENT_STATUS_COMPLETED){
                tpa.Completed_On__c = Date.today();
            }
        }
    }

    public static void processAfterInsert(List<PBS_Training_Plan_Assignment__c> assignments){
        postChatterNotifications(assignments);
    }

    public static void processBeforeDelete(List<PBS_Training_Plan_Assignment__c> assignments){
        PBS_TrainingPlanAssignmentHelper_Part.deleteAssociatedLearningAssignments(assignments);
    }

    public static void processAfterUpdate(Map<Id,PBS_Training_Plan_Assignment__c> oldAssignmentsMap,Map<Id,PBS_Training_Plan_Assignment__c> newAssignmentsMap){
        PBS_TrainingPlanAssignmentHelper_Part.processAchievementRulesForAssignments(oldAssignmentsMap,newAssignmentsMap);
    }

   
    private static void postChatterNotifications(List<PBS_Training_Plan_Assignment__c> assignments){

        Map<String,Set<Id>> mapTrainingPlanAssignments = new Map<String,Set<Id>>();
        Map<String,PBS_Training_Plan__c> mapTrainingPlanInfo = new Map<String,PBS_Training_Plan__c>();
        Map<Id,String> communityUserMap = new Map<Id,String>();
        Map<Id,String> communityNamesMap = new Map<Id,String>();
        Map<String,String> sitePrefixDomainMap = new Map<String,String>();

        //Collect all training plan assignments
        for(PBS_Training_Plan_Assignment__c tpa : assignments){

            if(tpa.Training_Plan__c != null){

                if(!mapTrainingPlanAssignments.containsKey(tpa.Training_Plan__c)){
                    mapTrainingPlanAssignments.put(tpa.Training_Plan__c,new Set<Id>());
                }

                mapTrainingPlanAssignments.get(tpa.Training_Plan__c).add(tpa.User__c);
                //Collect related community ids
                if(tpa.Community_Id__c != null){
                    communityUserMap.put(tpa.User__c , tpa.Community_Id__c);
                }
            }

        }

        PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps wosHelper = new PBS_TrainingPlanAssignmentHelper_CC.WithoutSharingOps();

        //Fetch additional community information
        if(communityUserMap.size()>0){
            for(SObject r : wosHelper.getCommunitiesInfoWOS(communityUserMap.values())){
                String communityURLPathPrefix = r.get('UrlPathPrefix')!=null?(String)r.get('UrlPathPrefix'):'';
                communityNamesMap.put(r.Id, communityURLPathPrefix);
            }
        }

        //Fetch site information for the referenced communiy url path prefixes
        if(communityNamesMap.size()>0){
            for(SObject s : wosHelper.getSiteInfoWOS()){
                String urlPrefix = s.get('UrlPathPrefix')!=null?(String)s.get('UrlPathPrefix'):'';
                sitePrefixDomainMap.put(urlPrefix, (String)s.get('Subdomain'));
            }
        }

        if(mapTrainingPlanAssignments.size()>0){
            for(PBS_Training_Plan__c tp : wosHelper.getTrainingPlansInfoWOS(mapTrainingPlanAssignments.keySet())){
                mapTrainingPlanInfo.put(tp.Id,tp);
            }
        }

        //Create chatter notification for each user + training plan combination
        for(String tplanId : mapTrainingPlanAssignments.keySet()){
            PBS_Training_Plan__c tPlanInfo = mapTrainingPlanInfo.get(tplanId);

            if(tPlanInfo != null && tPlanInfo.Chatter_Notifications_Enabled__c){

                Map<String,List<ConnectApi.BatchInput>> feedItemsMap = new Map<String,List<ConnectApi.BatchInput>>();
                for(Id uId : mapTrainingPlanAssignments.get(tplanId)){

                    try{
                        //Create message body input
                        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
                        //initalize message body segments
                        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

                        //Create a text segment
                        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
                        textSegment.text = System.Label.ALMS_Chatter_Notification_Greeting+' ';

                        if(tPlanInfo.Custom_Notification_Message__c == null){
                            messageInput.messageSegments.add(textSegment);
                        }

                        //Create a mention segment
                        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
                        mentionSegment.id = uId;
                        messageInput.messageSegments.add(mentionSegment);

                        //Create a text segment
                        textSegment = new ConnectApi.TextSegmentInput();

                        if(tPlanInfo.Custom_Notification_Message__c != null){
                            textSegment.text = '\n\n'+tPlanInfo.Custom_Notification_Message__c;
                        }else{
                            textSegment.text = ' '+System.Label.ALMS_Chatter_Notification_Message_1+' : '+tPlanInfo.Name+'. '+System.Label.ALMS_Chatter_Notification_Message_2+' : ';
                        }
                        messageInput.messageSegments.add(textSegment);

                        ConnectApi.LinkCapabilityInput linkSegment = new ConnectApi.LinkCapabilityInput();
                        String sfUrl=URL.getSalesforceBaseUrl().getHost();
                        PageReference tPlanDetailPageRef = Page.PBS_TrainingPlanDetail;

                        String tplanRefURL = tPlanDetailPageRef.getUrl();

                        Id userCommunityId = communityUserMap.get(uId);

                        if(userCommunityId != null){
                            String communityURLPathPrefix = communityNamesMap.get(userCommunityId);
                            tplanRefURL = PBS_LMSUtils_CC.updateURLCommunityPath(tplanRefURL,communityURLPathPrefix);
                            //Override sfURL with subdomain for the associated site
                            String siteSubdomain = sitePrefixDomainMap.get(communityURLPathPrefix);
                            if(siteSubdomain != null){
                                //Fix for dev edition url path
                                if(siteSubdomain.endsWith('developer-edition')){
                                    siteSubdomain += '.'+PBS_LMSUtils_CC.getCurrentInstance();
                                }
                                sfUrl = siteSubdomain+'.force.com';
                            }
                        }

                        String tPlanURL = 'https://'+sfUrl+''+tplanRefURL+'?id='+tplanId;
                        linkSegment.url = tPlanURL;
                        linkSegment.urlName = tPlanInfo.Name;

                        //Finally create the feed item
                        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
                        input.body = messageInput;
                        input.feedElementType = ConnectApi.FeedElementType.FeedItem;
                        ConnectApi.FeedElementCapabilitiesInput linkCapability = new ConnectApi.FeedElementCapabilitiesInput();
                        linkCapability.link = linkSegment;
                        input.capabilities = linkCapability;
                        input.subjectId = uId;

                        if(!feedItemsMap.containsKey(userCommunityId)){
                          feedItemsMap.put(userCommunityId, new List<ConnectApi.BatchInput>());
                        }

                        feedItemsMap.get(userCommunityId).add(new ConnectApi.BatchInput(input));

                    }catch(Exception e){
                        PBS_LMSUtils_CC.logException(e,'TrainingPlanAssignmentHelper');
                    }

                }

                //Insert feed items in batch
                for(String communityIdKey : feedItemsMap.keySet()){
                    List<ConnectApi.BatchInput> feedItems = feedItemsMap.get(communityIdKey);
                    if(feedItems.size()>0){
                        List<ConnectApi.BatchResult> results = ConnectApi.ChatterFeeds.postFeedElementBatch(communityIdKey,feedItems);
                    }
                }

            }
        }

    }

    public without sharing class WithoutSharingOps{

        // We need to run this without sharing to make sure we clean related assignment record even if the records are not available to the running user
        public void deleteAssociatedLearningAssignmentsWOS(List<PBS_Training_Plan_Assignment__c> assignments,Map<Id,Set<Id>> mapTPlanUserIds){

            //Fetch related training plan section assignments
            List<PBS_Training_Plan_Section_Assignment__c> tpsas = [select id
                                                                        from PBS_Training_Plan_Section_Assignment__c
                                                                        where Training_Plan_Assignment__c in :assignments];


            //Force a cascade deletion of the associated learning assignments.
            //CRUD/FLS enforcement is bypassed here to make sure all associated section assignments are cleared otherwise we can have corrupted data
            if(tpsas.size() > 0){
                delete tpsas;
            }

            //Delete existing shares for the training plan
            List<PBS_Training_Plan__Share> sharesToDelete = new List<PBS_Training_Plan__Share>();
            for(Id tPlanKey : mapTPlanUserIds.keySet()){
                Set<Id> uIds = mapTPlanUserIds.get(tPlanKey);
                List<PBS_Training_Plan__Share> tpshrs = [select id
                                                            from PBS_Training_Plan__Share
                                                            where ParentId = :tPlanKey
                                                            and UserOrGroupId in :uIds
                                                            and RowCause != 'Owner'];
                sharesToDelete.addAll(tpshrs);
            }

            //CRUD/FLS enforcement is bypassed here to make sure all associated tplan shares are cleared otherwise we can have corrupted data
            if(sharesToDelete.size()>0){
                delete sharesToDelete;
            }

        }

        // We need to update Achievement Assignments in a without sharing since records will be shared with public read only access
        public void updateAchievementAssignmentsWOS(List<PBS_Achievement_Assignment__c> achievementAssignmentsToUpdate){
            update achievementAssignmentsToUpdate;
        }

        // We need to calculate progress for training tracks in a without sharing context, as the executing (running) user may be a user different from the record owner
        // And this running user, may not have access to see all of the training tracks in the system
        public void calculateTrainingTrackProgressWOS(Set<Id> uIds, Set<Id> trackIds){

            if(uIds.size() > 0 && trackIds.size() > 0){

                //Determine if we should link the achievement assignment to a network id
                //Id currentNetworkId = null;
                if(uIds.size() == 1 && uIds.contains(UserInfo.getUserId())){
                    //currentNetworkId = PBS_LMSUtils_CC.getCurrentNetworkId();
                     PBS_LMSUtils_CC.getCurrentNetworkId();
                }

                //Get track achievements
                Map<Id,String> trackAchievementMap = new Map<Id,String>();
                Map<Id,String> completedTrackAchievementMap = new Map<Id,String>();
                Map<Id,Set<Id>> trackPlansMap = new Map<Id,Set<Id>>();
                Map<Id,Set<Id>> userCompletedPlansMap = new Map<Id,Set<Id>>();
                Set<Id> tplansToBeChecked = new Set<Id>();

                //Get achievement information for the specified tracks, only if they are active
                for(PBS_Training_Track__c tt : [select id
                                                ,Achievement__c
                                                from PBS_Training_Track__c
                                                where id in :trackIds
                                                and Status__c = :PBS_LMSConstants_CC.TTRACK_ACTIVE_STATUS]){
                    if(tt.Achievement__c != null){
                        trackAchievementMap.put(tt.Id,tt.Achievement__c);
                    }
                }

                //Continue only if the related active tracks have an achievement
                if(trackAchievementMap.size() == 0){
                    return;
                }

                //Get training plan information from related track items
                for(PBS_Training_Track_Level_Item__c tti : [select id
                                                        ,Training_Plan__c
                                                        ,Training_Track_Level__r.Training_Track__c
                                                        from PBS_Training_Track_Level_Item__c
                                                        where Training_Track_Level__r.Training_Track__c in :trackAchievementMap.keySet()]){
                    if(tti.Training_Plan__c != null){
                        tplansToBeChecked.add(tti.Training_Plan__c);

                        if(!trackPlansMap.containsKey(tti.Training_Track_Level__r.Training_Track__c)){
                            trackPlansMap.put(tti.Training_Track_Level__r.Training_Track__c, new Set<Id>());
                        }

                        trackPlansMap.get(tti.Training_Track_Level__r.Training_Track__c).add(tti.Training_Plan__c);
                    }

                }

                //Continue only if there are items to be checked
                if(tplansToBeChecked.size() == 0){
                    return;
                }

                //Get all the training plan assignments for the specified users
                for(PBS_Training_Plan_Assignment__c tpa : [select id
                                                            ,User__c
                                                            ,Status__c
                                                            ,Training_Plan__c
                                                            from PBS_Training_Plan_Assignment__c
                                                            where User__c in :uIds
                                                            and Training_Plan__c in :tplansToBeChecked
                                                            and Status__c = :PBS_LMSConstants_CC.TPLAN_STATUS_COMPLETED
                                                            order by User__c]){

                    if(!userCompletedPlansMap.containsKey(tpa.User__c)){
                        userCompletedPlansMap.put(tpa.User__c, new Set<Id>());
                    }

                    userCompletedPlansMap.get(tpa.User__c).add(tpa.Training_Plan__c);
                }


                //Iterate over each of the training tracks and check if the user has completed all associated training plans
                Map<Id,Set<Id>> userCompletedTrackMap = new Map<Id,Set<Id>>();

                for(Id trackId : trackPlansMap.keySet()){

                    Set<Id> trackPlanIds = trackPlansMap.get(trackId);

                    if(trackPlanIds != null && trackPlanIds.size()>0){
                        for(Id uid : uIds){
                            Set<Id> userCompletedPlanIds = userCompletedPlansMap.get(uid);

                            if(userCompletedPlanIds != null && userCompletedPlanIds.containsAll(trackPlanIds)){
                                //This user has completed all of the items in this track
                                if(!userCompletedTrackMap.containsKey(uid)){
                                    userCompletedTrackMap.put(uid,new Set<Id>());
                                }

                                userCompletedTrackMap.get(uid).add(trackId);

                                if(!completedTrackAchievementMap.containsKey(trackId)){
                                    completedTrackAchievementMap.put(trackId,trackAchievementMap.get(trackId));
                                }
                            }


                        }

                    }

                }

                // Continue if we found users that have completed tracks
                if(userCompletedTrackMap.size()>0){

                    Map<Id,Set<Id>> userAcquiredAchievementsMap = new Map<Id,Set<Id>>();

                    //Check existing achievement assignments for the current users, to make sure we dont creatre dups
                    for(PBS_Achievement_Assignment__c aa : [select id
                                                            ,Achievement__c
                                                            ,User__c
                                                            from PBS_Achievement_Assignment__c
                                                            where User__c in :userCompletedTrackMap.keySet()
                                                            and Status__c = :PBS_LMSConstants_CC.AA_ACQUIRED_STATUS
                                                            and Achievement__c in :completedTrackAchievementMap.values()]){

                        if(!userAcquiredAchievementsMap.containsKey(aa.User__c)){
                            userAcquiredAchievementsMap.put(aa.User__c, new Set<Id>());
                        }
                        userAcquiredAchievementsMap.get(aa.User__c).add(aa.Achievement__c);
                    }

                    Map<Id,User> userInfoMap = PBS_LMSService_CC.getUserMap(userCompletedTrackMap.keySet(), false);
                    List<PBS_Achievement_Assignment__c> aaInsert = new List<PBS_Achievement_Assignment__c>();

                    //Create achievement assignments if they don't exist already
                    for(Id uid : userCompletedTrackMap.keySet()){

                        Set<Id> userAcquiredAchievements = userAcquiredAchievementsMap.get(uid);
                        Set<Id> userCompTracks = userCompletedTrackMap.get(uid);
                        User uInfo = userInfoMap.get(uid);

                        for(Id tid : userCompTracks){

                            String trackAchievementId = completedTrackAchievementMap.get(tid);

                            if(userAcquiredAchievements == null || !userAcquiredAchievements.contains(trackAchievementId)){
                                PBS_Achievement_Assignment__c aa = new PBS_Achievement_Assignment__c();
                                aa.User__c = uid;
                                aa.Contact__c = uInfo.ContactId;
                                aa.OwnerId = uid;
                                aa.Achievement__c = trackAchievementId;
                                aa.Status__c = PBS_LMSConstants_CC.AA_ACQUIRED_STATUS;
                                aa.Training_Track__c = tid;
                                aaInsert.add(aa);

                            }

                        }

                    }

                    if(aaInsert.size()>0){
                        //By-pass CRUD/FLS checks as the invoking user doesn't have access to create achievement assignments
                        insert aaInsert;
                    }

                }

            }

        }

        // We want to make sure the running user has access to the training plan records even if the training plan hasn't been shared with the user
        public Map<Id,List<PBS_Training_Plan_Achievement__c>> getTrainingPlanAchievementsWOS(Set<Id> trainingPlanIds){

            Map<Id,List<PBS_Training_Plan_Achievement__c>> results = new Map<Id,List<PBS_Training_Plan_Achievement__c>>();

            //Create local scope vars for Dynamic SOQL binding
            Set<Id> tplIds = trainingPlanIds;

            List<String> listSOQLFields = new List<String>{
                'Id'
                ,'Name'
                ,'Training_Plan__c'
                ,'Training_Plan_Section__c'
                ,'Type__c'
                ,'Main_Achievement__c'
                ,'Achievement__c'
                ,'Achievement__r.Id'
                ,'Achievement__r.Acquired_Image__c'
                ,'Achievement__r.Eligible_Image__c'
                ,'Achievement__r.Work_Badge_Id__c'
                ,'Achievement__r.Work_Badge_Image_URL__c'
            };

            String soqlQuery = 'select '+String.join(listSOQLFields,',')+' from PBS_Training_Plan_Achievement__c where Training_Plan__c in :tplIds and Type__c = \'Plan\'';
            soqlQuery += ' order by CreatedDate desc';

            List<PBS_Training_Plan_Achievement__c> tplanAchievements = (List<PBS_Training_Plan_Achievement__c>)Database.query(soqlQuery);
            for(PBS_Training_Plan_Achievement__c tpa : tplanAchievements){
                if(!results.containsKey(tpa.Training_Plan__c)){
                    results.put(tpa.Training_Plan__c, new List<PBS_Training_Plan_Achievement__c>());
                }
                results.get(tpa.Training_Plan__c).add(tpa);
            }

            return results;

        }
        
        /*
        * We're running this query without sharing due to our data/security model design
        * This method will be called by a trigger running in a with sharing context, in some cases the running user
        * Will not have access to the all of the training tracks for the affected user, for example, an approver is updating an assignment status
        */
        //Get all the training track ids that have the specified training plan as part of the items
        
        public Set<Id> getAssociatedTrainingTracksWOS(Set<Id> tplanIds){

            Set<Id> result = new Set<Id>();
            for(PBS_Training_Track_Level_Item__c ti : [select Training_Track_Level__r.Training_Track__c
                                                from PBS_Training_Track_Level_Item__c
                                                where Training_Plan__c in :tplanIds]){
                result.add(ti.Training_Track_Level__r.Training_Track__c);

            }

            return result;

        }

        public List<SObject> getCommunitiesInfoWOS(List<String> communityIds){
            String soqlQuery = 'select Id,UrlPathPrefix from Network where Id in :communityIds';
            return Database.query(soqlQuery);
        }

        public List<SObject> getSiteInfoWOS(){
            String soqlQuery = 'select Id, UrlPathPrefix, Subdomain from Site where Status = \'Active\' and SiteType = \'ChatterNetwork\'';
            return Database.query(soqlQuery);
        }

        public List<PBS_Training_Plan__c> getTrainingPlansInfoWOS(Set<String> tplanIds){
            List<PBS_Training_Plan__c> results = [select id
                                                    ,Name
                                                    ,Chatter_Notifications_Enabled__c
                                                    ,Custom_Notification_Message__c
                                                    from PBS_Training_Plan__c
                                                    where id in :tplanIds];
            return results;
        }

    }


}