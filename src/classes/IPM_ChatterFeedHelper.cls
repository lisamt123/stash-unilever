public without sharing class IPM_ChatterFeedHelper {
    
    public static void autoFollowTeamMembers(IPM_Project_Resource__c[] newProjectResources) {
        
        Map<Id, Set<Id>> projectUserMap = getProjectUserMap(newProjectResources);
        Map<String, Boolean> projectSubscribedUsers = getSubscribedUser(projectUserMap.keySet());
        List<EntitySubscription> subscriptionRecordsToCreate = new List<EntitySubscription>();
        for(Id eachProject : projectUserMap.keySet()) {
            for(Id eachUser : projectUserMap.get(eachProject)) {
            	String key = eachProject + '-' + eachUser;
            	if(!projectSubscribedUsers.containskey(key)) {
            		subscriptionRecordsToCreate.add(buildSubscriptionObj(eachUser, eachProject));
            	}
            }
        }
        
        try{insert subscriptionRecordsToCreate;}catch(exception e){}
        postChatterUpdateToRecord(projectUserMap, IPM_ChatterUtils.ASSIGNMENT_PROJECT_TEXT);
    }
    
    private static Map<String, Boolean> getSubscribedUser(Set<Id> parentIds) {
    	
    	Map<String, Boolean> parentSubscriberMapToReturn = new Map<String, Boolean>();
    	EntitySubscription[] subscriptionList = [SELECT 
    	                                           ParentId, SubscriberId FROM EntitySubscription
    	                                           WHERE ParentId IN :parentIds ORDER BY CreatedDate DESC LIMIT 499];
    	for(Id eachProject : parentIds) {
    		for(EntitySubscription eachSubscription : subscriptionList) {
    			if(eachProject == eachSubscription.ParentId) {
    				String key = eachProject + '-' + eachSubscription.SubscriberId;
    				parentSubscriberMapToReturn.put(key, true);
    			}
	        }
    	}
    	
    	return parentSubscriberMapToReturn;
    }
    
    public static void autoFollowProjectMembers(Map<Id, Set<Id>> projectUserMap) {
        
        List<EntitySubscription> subscriptionRecordsToCreate = new List<EntitySubscription>();
        Map<String, Boolean> projectSubscribedUsers = getSubscribedUser(projectUserMap.keySet());
        system.debug('** projectSubscribedUsers : ' + projectSubscribedUsers);
        for(Id eachProject : projectUserMap.keySet()) {
            for(Id eachUser : projectUserMap.get(eachProject)) {
            	String key = eachProject + '-' + eachUser;
            	system.debug('** key :  ' + key);
                if(!projectSubscribedUsers.containskey(key)) {
                    subscriptionRecordsToCreate.add(buildSubscriptionObj(eachUser, eachProject));
                }
            }
        }
        system.debug('** subscriptionRecordsToCreate : ' + subscriptionRecordsToCreate);
        try{insert subscriptionRecordsToCreate;}catch(exception e){}
    }
    
    public static void postChatterUpdateToRecord(Map<Id, Set<Id>> recordUserMap, String postText) {
        
        for(Id eachRecord : recordUserMap.keySet()) {
            IPM_ChatterUtils.postRecordFeedWithMention(eachRecord, postText, recordUserMap.get(eachRecord));
        }
    }
    
    public static void postDynamicChatterUpdateToRecord(Map<Id, Set<Id>> recordUserMap, Map<Id, String> postTextMap) {
        
        system.debug('** postTextMap : ' + postTextMap);
        system.debug('** recordUserMap : ' + recordUserMap);
        for(Id eachRecord : recordUserMap.keySet()) {
            IPM_ChatterUtils.postRecordFeedWithMention(eachRecord, postTextMap.get(eachRecord), recordUserMap.get(eachRecord));
        }
    }
    
    public static void postChatterUpdateToUser(Map<Id, IPM_Project__c> projectOwnerMap, Map<Id, String> pResourceDetails) {
        
        for(Id eachProject : projectOwnerMap.keySet()) {
            String postText = getPostMessage(projectOwnerMap.get(eachProject).Name, pResourceDetails.get(eachProject));
            IPM_ChatterUtils.postUserFeedWithMention(UserInfo.getUserId(), projectOwnerMap.get(eachProject).IPM_Project_Leader__c, postText);
        }
    }
    
    private static String getPostMessage(String projectName, String projectMessage) {
        
        String msgToReturn = projectName;
        msgToReturn +=  IPM_ChatterUtils.USER_CHANGED_ROLES;
        msgToReturn += projectMessage;
        
        return msgToReturn;
    }
    
    public static Map<Id, Set<Id>> getProjectUserMap(IPM_Project_Resource__c[] newProjectResources) {
        
        Map<Id, Set<Id>> projectUserMapToReturn = new Map<Id, Set<Id>>();
        for(IPM_Project_Resource__c eachPResource : newProjectResources) {
            if(!projectUserMapToReturn.containsKey(eachPResource.IPM_Project__c)) {
                set<Id> tmpSet = new Set<Id>();
                tmpSet.add(eachPResource.IPM_User__c);
                projectUserMapToReturn.put(eachPResource.IPM_Project__c, tmpSet);
            } else {
                projectUserMapToReturn.get(eachPResource.IPM_Project__c).add(eachPResource.IPM_User__c);
            }
        }
        
        return projectUserMapToReturn;
    }
    
    private static EntitySubscription buildSubscriptionObj(Id follower, Id toFollow) {
        
        EntitySubscription subToReturn = new EntitySubscription();
        subToReturn.SubscriberId = follower;
        subToReturn.ParentId = toFollow;
        return subToReturn;
    }
    
    private static Map<String, Boolean> checkExistingSubscriber(Map<Id, Set<Id>> projectUserMap) {
    	
    	Map<String, Boolean> existingProjectUserMap = new Map<String, Boolean>();
    	//find out if this user is any team member currently in the project
    	IPM_Project__c[] ipmTeam = [SELECT IPM_Project_Leader__c, IPM_Technical_Project_Leader__c, Deputy_Project_Leader__c, 
    	                                           IPM_Finance_Member__c, IPM_Project_Gatekeeper__c,
    	                                   (SELECT IPM_User__c FROM IPM_Project_Resources__r)
    	                                       FROM IPM_Project__c 
    	                                       WHERE Id IN :projectUserMap.keySet()];
    	system.debug( projectUserMap.keySet() + ' ** ipmTeam : ' + ipmTeam);
		for(IPM_Project__c eachProject : ipmTeam) {
			for(IPM_Project_Resource__c eachResource : eachProject.IPM_Project_Resources__r) {
				String key = eachProject.Id + '-' + eachResource.IPM_User__c;
                existingProjectUserMap.put(key, true);
			}
			//Also add if the user is any project member currently in the project
			if(eachProject.IPM_Project_Leader__c != null) {
                String key = eachProject.Id + '-' + eachProject.IPM_Project_Leader__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.IPM_Technical_Project_Leader__c != null) {
                String key = eachProject.Id + '-' + eachProject.IPM_Technical_Project_Leader__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.IPM_Project_Gatekeeper__c != null) {
                String key = eachProject.Id + '-' + eachProject.IPM_Project_Gatekeeper__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.Deputy_Project_Leader__c != null) {
                String key = eachProject.Id + '-' + eachProject.Deputy_Project_Leader__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.IPM_Finance_Member__c != null) {
                String key = eachProject.Id + '-' + eachProject.IPM_Finance_Member__c;
                existingProjectUserMap.put(key, true);
            }
    	}
    	
        system.debug('** existingProjectUserMap : ' + existingProjectUserMap);
        return existingProjectUserMap;
    }
    
    public static void autoUnFollowTeamMembers(IPM_Project_Resource__c[] newProjectResources) {
        
        Map<Id, Set<Id>> projectUserMap = getProjectUserMap(newProjectResources);
        removeFollowingEntities(projectUserMap);
    }
    
    private static void removeFollowingEntities(Map<Id, Set<Id>> projectUserMap) {
    	
    	Set<Id> projects = new Set<Id>();
        EntitySubscription[] subsribingEntitiesToDelete = new list<EntitySubscription>();
        Map<String, Boolean> existingProjectUserMap = checkExistingSubscriber(projectUserMap);
        for(Id eachProject : projectUserMap.keySet()) {
            for(Id eachUser : projectUserMap.get(eachProject)) {
                String key = eachProject + '-' + eachUser;
                if(!existingProjectUserMap.containsKey(key)) {
                    projects.add(eachProject);
                }
            }
        }
        
        List<EntitySubscription> subscriptionList = [SELECT SubscriberId,ParentId FROM EntitySubscription 
                                                        WHERE ParentId = :projects
                                                        ORDER BY CreatedDate DESC
                                                        LIMIT 499];
        for(Id eachProject : projectUserMap.keySet()) {
            for(EntitySubscription eachEntity : subscriptionList) {
                String key = eachProject + '-' + eachEntity.SubscriberId;
                if(!existingProjectUserMap.containsKey(key)) {
                    subsribingEntitiesToDelete.add(eachEntity);
                }
            }
        }
        system.debug('** subsribingEntitiesToDelete: '  + subsribingEntitiesToDelete);
        try{delete subsribingEntitiesToDelete;}catch(exception e){}
    }
    public static void autoUnFollowProjectMembers(Map<Id, Set<Id>> projectUserMap) {
        
        removeFollowingEntities(projectUserMap);
    }
}