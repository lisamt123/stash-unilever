/**
    @Description: Trigger handler on the user object.
    @Author: Cognizant Technology
    @Date: Oct 2014
**/
public with sharing class IPM_UserTriggerHandler {
    
    private boolean m_isExecuting = false;
    
    //constructor
    public IPM_UserTriggerHandler(boolean isExecuting)
    {
        m_isExecuting = isExecuting;
    }
    
    public void bulkAfter()
    {
       if(Trigger.isUpdate)
       {
         User[] newUsrs = new list<User>();//list of new users
        Set<Id> changeRoleIds = new Set<Id>();//id of those whose role is changed at user level
        for(User eachUser :(List<User>)Trigger.New)
        {
          User oldUsers = ( (Map<Id,User>)Trigger.OldMap).get(eachUser.Id);
            if(!eachUser.IsActive && oldUsers.IsActive != eachUser.IsActive) 
            {
                newUsrs.add(eachUser);
            }
            
           //@rajesh:commented below codes.we are removing user custom field references,so please verify.
           /* if(eachUser.IPM_Role__c != null && oldUsers.IPM_Role__c != eachUser.IPM_Role__c) 
            {
                changeRoleIds.add(eachUser.Id);
            }*/
        }
        IPM_TaskHelper.reAssignTasksForInActiveUsrs(newUsrs);//reassign their current tasks
        IPM_ProjectResourceTriggerHandler.notifyRoleChangeToPLs(changeRoleIds);
        
       }  
    }
    /**************************************************************
    * @description: After delete context
    * @param1 newUsers : The list of old users in the trigger context
    */
    public void OnAfterDelete(User[] oldUsers) {
        // Used for future usage of After delete functionality.
    }
}