public without sharing class IPM_ProjectResourceTriggerHandler {
    
    private boolean m_isExecuting = false;

    public IPM_ProjectResourceTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    public void onAfterInsert(IPM_Project_Resource__c[] newProjectResources) {
        
        list<IPM_Project_Resource__c> newPRList = new list<IPM_Project_Resource__c>();
        for(IPM_Project_Resource__c eachPResource : newProjectResources) {
            if(eachPResource.IPM_Project_Role_Owner__c) {
                newPRList.add(eachPResource);
            }
        }
        if(IPM_CheckRecursive.runOnce() && newPRList.size() > 0) {
            IPM_TaskHelper.reAssignFunctionalWiseTasks(newPRList);
        }
        IPM_ChatterFeedHelper.autoFollowTeamMembers(newProjectResources);
    }
    
    public void OnAfterUpdate(IPM_Project_Resource__c[] newProjectResources, Map<Id, IPM_Project_Resource__c> newProjectResourcesMap, 
                                Map<Id, IPM_Project_Resource__c> oldProjectResources) {
        
        list<IPM_Project_Resource__c> newPRList = new list<IPM_Project_Resource__c>();
        for(IPM_Project_Resource__c eachPResource : newProjectResources) {
            IPM_Project_Resource__c oldPR = oldProjectResources.get(eachPResource.Id);
            if(eachPResource.IPM_Project_Role_Owner__c && 
                (eachPResource.IPM_User__c != oldPR.IPM_User__c || eachPResource.IPM_Project_Role_Owner__c != oldPR.IPM_Project_Role_Owner__c)) {
                newPRList.add(eachPResource);
            }
        }
        if(newPRList.size() > 0) {
            IPM_TaskHelper.reAssignFunctionalWiseTasks(newPRList);
        }
    }
    
     @future
    public static void notifyRoleChangeToPLs(Set<Id> userIds) {
        
        IPM_Project_Resource__c[] pResourceList = [SELECT IPM_Project__c, IPM_Role__c, IPM_User__c 
                                                       FROM IPM_Project_Resource__c
                                                       WHERE IPM_User__c IN :userIds];
        memberChangingRole(pResourceList);
    }
    
    public static void memberChangingRole(IPM_Project_Resource__c[] newProjectResources) {
                                        
        Map<Id, IPM_Project_Resource__c[]> pResourceRoleChangedMap = new Map<Id, IPM_Project_Resource__c[]>();
        Set<Id> userIds = new Set<Id>();
        for(IPM_Project_Resource__c eachPResource : newProjectResources) {
            if(!pResourceRoleChangedMap.containsKey(eachPResource.IPM_Project__c)) {
                IPM_Project_Resource__c[] tmpLst = new List<IPM_Project_Resource__c>();
                tmpLst.add(eachPResource);
                pResourceRoleChangedMap.put(eachPResource.IPM_Project__c, tmpLst);
            }else {
                pResourceRoleChangedMap.get(eachPResource.IPM_Project__c).add(eachPResource);
            }
            userIds.add(eachPResource.IPM_User__c);
        }
        system.debug('** pResourceRoleChangedMap : ' + pResourceRoleChangedMap);
        Map<Id, IPM_Project__c> projectMap = IPM_Utils.getProjectDetails(pResourceRoleChangedMap.keySet());
        Map<Id, User> userDetailsMap = IPM_Utils.getUserDetailsMap(userIds);
        Map<Id, String> pResourceDetailsMap = new Map<Id, String>();
        for(Id eachProject : pResourceRoleChangedMap.keySet()) {
            Set<String> contextMsgList = new Set<String>();
            for(IPM_Project_Resource__c eachPResource : pResourceRoleChangedMap.get(eachProject)) {
                String str = ' User : ' + userDetailsMap.get(eachPResource.IPM_User__c).Name + ' New Role : ' + eachPResource.IPM_Role__c;
                contextMsgList.add(str);
            }
            system.debug('** contextMsgList : ' + contextMsgList);
            pResourceDetailsMap.put(eachProject, IPM_Utils.convertSetToString(contextMsgList));
        }
        system.debug('** pResourceDetailsMap : ' + pResourceDetailsMap);
        system.debug('** projectMap : ' + projectMap);
        IPM_ChatterFeedHelper.postChatterUpdateToUser(projectMap, pResourceDetailsMap);
    }
    
    public void onAfterUnDelete(IPM_Project_Resource__c[] newProjectResources) {
        IPM_ChatterFeedHelper.autoFollowTeamMembers(newProjectResources);
    }
    
    public void OnAfterDelete(IPM_Project_Resource__c[] oldProjectResources) {
        IPM_ChatterFeedHelper.autoUnFollowTeamMembers(oldProjectResources);
    }
}