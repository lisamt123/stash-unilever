public without sharing class IPM_TaskHelper {
    
    public static void reAssignFunctionalWiseTasks(IPM_Project_Resource__c[] newProjectResources) {
    	
    	list<IPM_Task__c> tasksToUpdate = new list<IPM_Task__c>();
    	Map<String, String> functionalRoleUserMap = new Map<String, String>();
    	Set<Id> projectIds = new Set<Id>();
        Set<String> functionalRolesSet = new Set<String>();
    	for(IPM_Project_Resource__c eachPR : newProjectResources) {
    		functionalRolesSet.add(eachPR.IPM_Role_Type__c);
    		projectIds.add(eachPR.IPM_Project__c);
    		functionalRoleUserMap.put(eachPR.IPM_Role_Type__c+'-'+eachPR.IPM_Project__c, eachPR.IPM_User__c);
    	}
    	list<IPM_Task__c> tasksList = [SELECT IPM_Assignee__c, IPM_Function__c, IPM_Project__c FROM IPM_Task__c 
                                            WHERE IPM_Project__c IN :projectIds
                                            AND IPM_Function__c IN :functionalRolesSet AND IPM_Completed__c != true];
        for(IPM_Task__c eachTask : tasksList) {
            IPM_Task__c tskObj = eachTask;
            tskObj.IPM_Assignee__c = functionalRoleUserMap.get(eachTask.IPM_Function__c+'-'+eachTask.IPM_Project__c);
            tasksToUpdate.add(tskObj);
        }
        system.debug('** tasksToUpdate FROM FUNCTION WISE : ' + tasksToUpdate);
        update tasksToUpdate;
    }
    
    @future
    public static void reAssign(Set<Id> usersId) {
        
        system.debug('** usersId future : ' + usersId);
        IPM_Project_Resource__c[] newProResourcesList = new list<IPM_Project_Resource__c>();
        map<Id, IPM_Project_Resource__c> newProResourcesMap = new map<Id, IPM_Project_Resource__c>();
        Map<Id, IPM_Project_Resource__c> oldProResourcesMap = new Map<Id, IPM_Project_Resource__c>
                                                                ([SELECT IPM_User__c, IPM_Project__c, IPM_Project__r.IPM_Project_Leader__c, 
                                                                    IPM_Project_Role_Owner__c 
                                                                FROM IPM_Project_Resource__c 
                                                                WHERE IPM_Project_Role_Owner__c = true AND
                                                                        IPM_User__c IN :usersId]);
        for(IPM_Project_Resource__c eachNewPR : oldProResourcesMap.values()) {
            IPM_Project_Resource__c prSobj = eachNewPR;
            prSobj.IPM_User__c = null;
            newProResourcesList.add(prSobj);
            newProResourcesMap.put(eachNewPR.Id, prSobj);
        }
        oldProResourcesMap = new Map<Id, IPM_Project_Resource__c>
                                                                ([SELECT IPM_User__c, IPM_Project__c, IPM_Project__r.IPM_Project_Leader__c, 
                                                                    IPM_Project_Role_Owner__c 
                                                                FROM IPM_Project_Resource__c 
                                                                WHERE IPM_Project_Role_Owner__c = true AND
                                                                        IPM_User__c IN :usersId]);
        system.debug('** oldProResourcesMap USER AFTER : ' + oldProResourcesMap);
        system.debug('** newProResourcesMap USER AFTER : ' + newProResourcesMap);
        reAssignTasks(newProResourcesList, newProResourcesMap, oldProResourcesMap); 
    }
    
    public static void reAssignTasksForInActiveUsrs(User[] inActiveUsrsList) {
        
        Set<Id> usersId = new Set<Id>();
        for(User eachUser : inActiveUsrsList) {
            usersId.add(eachUser.Id);
        }
        system.debug('** usersId : ' + usersId);
        reAssign(usersId);
    }
    
    public static void reAssignTasks(IPM_Project_Resource__c[] newProjectsResources, 
                                        map<Id, IPM_Project_Resource__c> newProjectResourcesMap,
                                        map<Id, IPM_Project_Resource__c> oldProjectResourcesMap) {
        
        list<IPM_Task__c> tasksToUpdate = new list<IPM_Task__c>();
        list<IPM_Project_Resource__c> projectResourcesToUpdate = new list<IPM_Project_Resource__c>();
        IPM_Project_Resource__c oldProjectResource = new IPM_Project_Resource__c();
        Set<Id> projectIds = new Set<Id>();
        Set<String> functionalRolesSet = new Set<String>();
        map<Id, Id> usersToReplaceMap = new map<Id, Id>(); // old user => new user
        map<Id, IPM_Project_Resource__c> removedUsersMap = new map<Id, IPM_Project_Resource__c>();
        map<Id, IPM_Project_Resource__c> replacedUsersMap = new map<Id, IPM_Project_Resource__c>();
        map<Id, Id> projectLeaderMap = new map<Id, Id>();
        system.debug('** newProjectsResources : ' + newProjectsResources);
        system.debug('** newProjectResourcesMap : ' + newProjectResourcesMap);
        system.debug('** oldProjectResourcesMap : ' + oldProjectResourcesMap);
        for(IPM_Project_Resource__c eachProject : newProjectsResources) {
        	functionalRolesSet.add(eachProject.IPM_Role_Type__c);
            oldProjectResource = oldProjectResourcesMap.get(eachProject.Id);
            //check for those users who are removed frm the owner's role, find out their ManagerIds and replace their tasks with them.
            if(oldProjectResource.IPM_User__c != eachProject.IPM_User__c && eachProject.IPM_User__c == null &&
                eachProject.IPM_Project_Role_Owner__c) {
                removedUsersMap.put(oldProjectResource.IPM_User__c, oldProjectResource);
                projectIds.add(eachProject.IPM_Project__c);
            }
            //check for those users who are replaced by the system itself.
            if(oldProjectResource.IPM_User__c != eachProject.IPM_User__c && eachProject.IPM_User__c != null &&
                eachProject.IPM_Project_Role_Owner__c) {
                replacedUsersMap.put(eachProject.IPM_User__c, eachProject);
                usersToReplaceMap.put(oldProjectResource.IPM_User__c, eachProject.IPM_User__c);
                projectIds.add(eachProject.IPM_Project__c);
            }
        }
        system.debug('** removedUsersMap : ' + removedUsersMap);
        list<IPM_Project_Resource__c> projectResourcesList = [SELECT IPM_Project__r.IPM_Project_Leader__c, IPM_User__c 
                                                                FROM IPM_Project_Resource__c
                                                                WHERE Id IN: oldProjectResourcesMap.keySet()];
        for(IPM_Project_Resource__c eachPR : projectResourcesList) {
            IPM_Project_Resource__c oldPR = oldProjectResourcesMap.get(eachPR.Id);
            projectLeaderMap.put(oldPR.IPM_User__c, eachPR.IPM_Project__r.IPM_Project_Leader__c);
        }
        list<User> usersList = [SELECT ManagerId, Manager.IsActive FROM User WHERE Id IN :removedUsersMap.keySet()];
        for(User eachUser : usersList) {
            if(eachUser.ManagerId != null && eachUser.Manager.IsActive) {
                usersToReplaceMap.put(eachUser.Id, eachUser.ManagerId);
            }else {
                usersToReplaceMap.put(eachUser.Id, projectLeaderMap.get(removedUsersMap.get(eachUser.Id).IPM_User__c));
            }
        }
        
        system.debug('** projectLeaderMap : ' + projectLeaderMap);
        system.debug('** usersToReplaceMap : ' + usersToReplaceMap);
        Set<Id> pResourceIdsToUpdate = new Set<Id>();
        Set<Id> usersId = new Set<Id>();
        Set<Id> presourceIds = new Set<Id>();
        for(IPM_Project_Resource__c eachPR : removedUsersMap.values()) {
            pResourceIdsToUpdate.add(removedUsersMap.get(eachPR.IPM_User__c).Id);
        }
        
        list<IPM_Project_Resource__c> prList = [SELECT IPM_User__c, IPM_Project__c FROM IPM_Project_Resource__c WHERE Id IN :pResourceIdsToUpdate];
        for(IPM_Project_Resource__c eachPR : prList) {
            IPM_Project_Resource__c prObj = eachPR;
            IPM_Project_Resource__c oldPR = oldProjectResourcesMap.get(eachPR.Id);
            prObj.IPM_User__c = usersToReplaceMap.get(oldPR.IPM_User__c);
            prObj.IPM_Project__c = eachPR.IPM_Project__c;
            projectResourcesToUpdate.add(prObj);
            usersId.add(prObj.IPM_User__c);
            usersId.add(oldPR.IPM_User__c);
        }
        
        list<IPM_Task__c> tasksList = [SELECT IPM_Assignee__c FROM IPM_Task__c 
                                            WHERE IPM_Assignee__c IN :usersToReplaceMap.keySet()
                                            AND IPM_Project__c IN :projectIds];
        for(IPM_Task__c eachTask : tasksList) {
            IPM_Task__c tskObj = eachTask;
            tskObj.IPM_Assignee__c = usersToReplaceMap.get(eachTask.IPM_Assignee__c);
            tasksToUpdate.add(tskObj);
        }
        system.debug('** tasksToUpdate : ' + tasksToUpdate);
        update tasksToUpdate;
        update projectResourcesToUpdate;
        
        for(IPM_Project_Resource__c eachPResource : projectResourcesToUpdate) {
            presourceIds.add(eachPResource.Id);
        }
        IPM_Project_Resource__c[] projectResourcesUpdtdList = [SELECT IPM_User__c, IPM_Project__c, IPM_Project__r.IPM_Project_Leader__c
                                        FROM IPM_Project_Resource__c
                                        WHERE Id IN :presourceIds];
        Map<Id, Set<Id>> projectUserMap = new Map<Id, Set<Id>>();
        Map<Id, String> chatterTextMap = new Map<Id, String>();
        Map<Id, User> userDetailsMap = IPM_Utils.getUserDetailsMap(usersId);
        system.debug('** projectResourcesUpdtdList : ' + projectResourcesUpdtdList);
        system.debug('** oldProjectResourcesMap : ' + oldProjectResourcesMap);
        system.debug('** projectResourcesUpdtdList : ' + projectResourcesUpdtdList);
        for(IPM_Project_Resource__c eachPResource : projectResourcesUpdtdList) {
            if(!projectUserMap.containsKey(eachPResource.IPM_Project__c)) {
                set<Id> tmpSet = new Set<Id>();
                tmpSet.add(eachPResource.IPM_Project__r.IPM_Project_Leader__c);
                projectUserMap.put(eachPResource.IPM_Project__c, tmpSet);
            } else {
                projectUserMap.get(eachPResource.IPM_Project__c).add(eachPResource.IPM_Project__r.IPM_Project_Leader__c);
            }
            IPM_Project_Resource__c oldPR = oldProjectResourcesMap.get(eachPResource.Id);
            system.debug('** eachPResource.Id ' + eachPResource.Id);
            chatterTextMap.put(eachPResource.IPM_Project__c, userDetailsMap.get(oldPR.IPM_User__c).Name + IPM_ChatterUtils.INACTIVE_USERS_TEXT);
        }
        system.debug('** projectUserMap : ' + projectUserMap);
        system.debug('** chatterTextMap : ' + chatterTextMap);
        IPM_ChatterFeedHelper.postDynamicChatterUpdateToRecord(projectUserMap, chatterTextMap);
    }
    
    /*
        If there are tasks added to an excluded section then mark them as not excluded.
    */
    public static void markSectionNotStarted(Set<Id> sectionIds) {
        
        IPM_Project_Document_Section__c[] sectionsToUpdate = new List<IPM_Project_Document_Section__c>();
        IPM_Project_Document_Section__c[] projectSectionList = [SELECT IPM_Section_Status__c 
                                                                    FROM IPM_Project_Document_Section__c
                                                                    WHERE Id IN :sectionIds AND 
                                                                        IPM_Section_Status__c =:IPM_ConstantUtils.STATUS_EXCLUDED];
        for(IPM_Project_Document_Section__c eachSection : projectSectionList) {
            IPM_Project_Document_Section__c sectionObj = eachSection;
            sectionObj.IPM_Section_Status__c = IPM_ConstantUtils.STATUS_NOT_STARTED;
            sectionsToUpdate.add(sectionObj);
        }
        
        update sectionsToUpdate;
    }
    
    /*
        If there are no tasks related to a section then mark them as excluded.
    */
    public static void markSectionExcluded(Set<Id> sectionIds) {
        
        IPM_Project_Document_Section__c[] sectionsToUpdate = new List<IPM_Project_Document_Section__c>();
        IPM_Project_Document_Section__c[] projectSectionList = [SELECT (SELECT Id FROM Tasks__r WHERE IPM_Task_Type__c = 'Negotiable'),IPM_Section_Status__c 
                                                                    FROM IPM_Project_Document_Section__c
                                                                    WHERE Id IN :sectionIds];
        for(IPM_Project_Document_Section__c eachSection : projectSectionList) {
            IPM_Task__c[] tasksList = eachSection.Tasks__r;
            if(tasksList.size() == 0) {
                IPM_Project_Document_Section__c sectionObj = eachSection;
                sectionObj.IPM_Section_Status__c = IPM_ConstantUtils.STATUS_EXCLUDED;
                sectionsToUpdate.add(sectionObj);
            }
        }
        
        update sectionsToUpdate;
    }
}