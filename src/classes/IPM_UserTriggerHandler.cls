public with sharing class IPM_UserTriggerHandler {
    
    private boolean m_isExecuting = false;

    public IPM_UserTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    public void OnAfterUpdate(User[] newUsers, Map<Id, User> oldUsersMap) {
        
        User[] newUsrs = new list<User>();
        Set<Id> changeRoleIds = new Set<Id>();
        for(User eachUser : newUsers) {
            User oldUsers = oldUsersMap.get(eachUser.Id); 
            if(!eachUser.IsActive && oldUsers.IsActive != eachUser.IsActive) {
                newUsrs.add(eachUser);
            }
            if(eachUser.IPM_Role__c != null && oldUsers.IPM_Role__c != eachUser.IPM_Role__c) {
                changeRoleIds.add(eachUser.Id);
            }
        }
        IPM_TaskHelper.reAssignTasksForInActiveUsrs(newUsrs);
        IPM_ProjectResourceTriggerHandler.notifyRoleChangeToPLs(changeRoleIds);
    }
    
    public void OnAfterDelete(User[] oldUsers) {
        
        IPM_TaskHelper.reAssignTasksForInActiveUsrs(oldUsers);
    }
}